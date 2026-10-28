# ---- build_survival_panel ----------------------------------------------------
# Every test runs on data frames (data.table method) and on duckdb tables
# (tbl_dbi method), so the two implementations are held to the same behaviour.

backends <- c("data.frame", "duckdb")

# run build_survival_panel() on the two tables or duckdb copies of them, and
# return an in-memory data frame sorted the same way for both backends
run_survival_panel <- function(backend, personnel, contracts, ...) {
  if (backend == "duckdb") {
    skip_if_not_installed("duckdb")
    skip_if_not_installed("dbplyr")

    # silence duckdb's notice about where it stores extensions
    con <- suppressMessages(DBI::dbConnect(duckdb::duckdb()))
    on.exit(DBI::dbDisconnect(con, shutdown = TRUE))

    DBI::dbWriteTable(con, "personnel", as.data.frame(personnel))
    DBI::dbWriteTable(con, "contracts", as.data.frame(contracts))
    personnel <- dplyr::tbl(con, "personnel")
    contracts <- dplyr::tbl(con, "contracts")
  }

  # the data only: a plain data frame without the survival_panel attributes
  result <- dplyr::collect(build_survival_panel(personnel, contracts, ...))
  result <- as.data.frame(as.list(result), check.names = FALSE)
  result <- result[order(result$personnel_id, result$ref_date), ]
  rownames(result) <- NULL

  result
}

# a hand-worked panel of four people over three annual snapshots, one
# contract each per year:
#
#   person  2020                 2021                  2022
#   P1      active, t0, pay 100  active, t1, pay 110   active, t2, pay 121
#   P2      active, t0, pay 200  (gone)
#   P3      active, t1, pay 100  pensioner, t2
#   P4                           active, t0, pay 100   active, t1, pay 90
#
# at risk: everyone active at 2020 or 2021 (2022 is the last snapshot, so
# censored). P2 is gone in 2021 (other exit) and P3 a pensioner (retired):
# both left at some point in the year, so count half of it
survival_personnel <- function() {
  data.frame(
    personnel_id = c("P1", "P2", "P3", "P1", "P3", "P4", "P1", "P4"),
    ref_date = as.Date(c(
      "2020-01-01", "2020-01-01", "2020-01-01",
      "2021-01-01", "2021-01-01", "2021-01-01",
      "2022-01-01", "2022-01-01"
    )),
    employment_status = c(
      "active", "active", "active",
      "active", "pensioner", "active",
      "active", "active"
    ),
    tenure = c(0, 0, 1, 1, 2, 0, 2, 1),
    gender = c("F", "F", "M", "F", "M", "M", "F", "M")
  )
}

survival_contracts <- function() {
  data.frame(
    contract_id = c("C1", "C2", "C3", "C4", "C5", "C6", "C7"),
    personnel_id = c("P1", "P2", "P3", "P1", "P4", "P1", "P4"),
    ref_date = as.Date(c(
      "2020-01-01", "2020-01-01", "2020-01-01",
      "2021-01-01", "2021-01-01",
      "2022-01-01", "2022-01-01"
    )),
    pay = c(100, 200, 100, 110, 100, 121, 90),
    occupation = c("teacher", "nurse", "admin", "teacher", "nurse", "teacher", "nurse")
  )
}

survival_args <- list(
  tenure_col = "tenure", salary_col = "pay", status_col = "employment_status"
)

# one person per snapshot date, for the tests that need snapshots to exist
# without caring who is in them
anchor_panel <- function(dates, id = "Z") {
  list(
    personnel = data.frame(
      personnel_id = id, ref_date = as.Date(dates),
      employment_status = "active", tenure = seq_along(dates)
    ),
    contracts = data.frame(
      contract_id = paste0(id, seq_along(dates)), personnel_id = id,
      ref_date = as.Date(dates), pay = 100
    )
  )
}

for (backend in backends) {
  test_that(paste0("one row per person and interval at risk, with the exit seen at the next snapshot (", backend, ")"), {
    result <- do.call(run_survival_panel, c(
      list(backend, survival_personnel(), survival_contracts()),
      survival_args,
      list(covariate_cols = c("gender", "occupation"))
    ))

    expected <- data.frame(
      personnel_id = c("P1", "P1", "P2", "P3", "P4"),
      ref_date = as.Date(c("2020-01-01", "2021-01-01", "2020-01-01", "2020-01-01", "2021-01-01")),
      next_date = as.Date(c("2021-01-01", "2022-01-01", "2021-01-01", "2021-01-01", "2022-01-01")),
      tenure = c(0, 1, 0, 1, 0),
      exposure = c(1, 1, 0.5, 0.5, 1),
      exit_type = c("none", "none", "other", "retired", "none"),
      pay = c(100, 110, 200, 100, 100),
      gender = c("F", "F", "F", "M", "M"),
      occupation = c("teacher", "teacher", "nurse", "admin", "nurse")
    )
    expect_equal(result, expected)
  })

  test_that(paste0("pay is summed across contracts, and contract covariates come from the selected one (", backend, ")"), {
    personnel <- data.frame(
      personnel_id = "P1", ref_date = as.Date(c("2020-01-01", "2021-01-01")),
      employment_status = "active", tenure = c(0, 1)
    )
    contracts <- data.frame(
      contract_id = c("C1", "C2", "C3"), personnel_id = "P1",
      ref_date = as.Date(c("2020-01-01", "2020-01-01", "2021-01-01")),
      pay = c(100, 300, 400), occupation = c("teacher", "admin", "admin")
    )
    args <- c(survival_args, list(covariate_cols = "occupation"))

    highest <- do.call(run_survival_panel, c(list(backend, personnel, contracts), args))
    lowest <- do.call(run_survival_panel, c(
      list(backend, personnel, contracts), args, list(select_contract = "lowest_paid")
    ))

    expect_equal(highest$pay, 400)
    expect_equal(highest$occupation, "admin")
    expect_equal(lowest$occupation, "teacher")
  })

  test_that(paste0("someone missing for a snapshot leaves, and is at risk again when back (", backend, ")"), {
    dates <- c("2020-01-01", "2021-01-01", "2022-01-01", "2023-01-01")
    anchor <- anchor_panel(dates)
    personnel <- rbind(anchor$personnel, data.frame(
      personnel_id = "A", ref_date = as.Date(dates[c(1, 3, 4)]),
      employment_status = "active", tenure = c(0, 2, 3)
    ))

    result <- do.call(run_survival_panel, c(
      list(backend, personnel, anchor$contracts), survival_args
    ))
    result <- result[result$personnel_id == "A", ]

    expect_equal(result$ref_date, as.Date(dates[c(1, 3)]))
    expect_equal(result$exit_type, c("other", "none"))
    expect_equal(result$exposure, c(0.5, 1))
  })

  test_that(paste0("an interval spanning a missing snapshot counts its real length (", backend, ")"), {
    # 2021 is missing for everyone: A stays two years, B leaves within them
    anchor <- anchor_panel(c("2020-01-01", "2022-01-01"))
    personnel <- rbind(anchor$personnel, data.frame(
      personnel_id = c("A", "A", "B"),
      ref_date = as.Date(c("2020-01-01", "2022-01-01", "2020-01-01")),
      employment_status = "active", tenure = c(0, 2, 5)
    ))

    result <- do.call(run_survival_panel, c(
      list(backend, personnel, anchor$contracts), survival_args
    ))

    expect_equal(result$exposure[result$personnel_id == "A"], 2)
    expect_equal(result$exposure[result$personnel_id == "B"], 1)
  })

  test_that(paste0("monthly snapshots give exposure as the share of a year (", backend, ")"), {
    # January and February 2020: 31 and 29 days of a 366-day year
    anchor <- anchor_panel(c("2020-01-01", "2020-02-01", "2020-03-01"))

    result <- do.call(run_survival_panel, c(
      list(backend, anchor$personnel, anchor$contracts), survival_args
    ))

    expect_equal(result$exposure, c(31, 29) / 366)
  })

  test_that(paste0("without a status column everyone is active and every exit is other (", backend, ")"), {
    result <- do.call(run_survival_panel, c(
      list(backend, survival_personnel(), survival_contracts()),
      survival_args[c("tenure_col", "salary_col")]
    ))

    # P3 is now active in 2021 and gone in 2022
    expect_equal(result$personnel_id, c("P1", "P1", "P2", "P3", "P3", "P4"))
    expect_equal(result$exit_type, c("none", "none", "other", "none", "other", "none"))
  })

  test_that(paste0("a next status other than active or pensioner is an other exit (", backend, ")"), {
    personnel <- survival_personnel()
    personnel$employment_status[5] <- "suspended"

    result <- do.call(run_survival_panel, c(
      list(backend, personnel, survival_contracts()), survival_args
    ))

    expect_equal(result$exit_type[result$personnel_id == "P3"], "other")
  })

  test_that(paste0("a person with no contract is kept, with no pay (", backend, ")"), {
    contracts <- survival_contracts()[-5, ]

    result <- do.call(run_survival_panel, c(
      list(backend, survival_personnel(), contracts),
      survival_args, list(covariate_cols = "occupation")
    ))

    expect_equal(nrow(result), 5L)
    expect_equal(result$pay[result$personnel_id == "P4"], NA_real_)
    expect_equal(result$occupation[result$personnel_id == "P4"], NA_character_)
  })

  test_that(paste0("a person-snapshot with no tenure is kept, with NA tenure (", backend, ")"), {
    personnel <- survival_personnel()
    personnel$tenure[1] <- NA

    result <- do.call(run_survival_panel, c(
      list(backend, personnel, survival_contracts()), survival_args
    ))

    expect_equal(nrow(result), 5L)
    expect_equal(result$tenure, c(NA, 1, 0, 1, 0))
  })

  test_that(paste0("a duplicated person-snapshot warns and is counted once (", backend, ")"), {
    personnel <- survival_personnel()
    personnel <- rbind(personnel, personnel[1, ])

    expect_warning(
      result <- do.call(run_survival_panel, c(
        list(backend, personnel, survival_contracts()), survival_args
      )),
      "1 duplicate"
    )
    expect_equal(result$personnel_id, c("P1", "P1", "P2", "P3", "P4"))
    expect_equal(result$exit_type, c("none", "none", "other", "retired", "none"))
  })

  test_that(paste0("a missing required column errors naming it (", backend, ")"), {
    contracts <- survival_contracts()
    contracts$pay <- NULL

    expect_error(
      do.call(run_survival_panel, c(
        list(backend, survival_personnel(), contracts), survival_args
      )),
      "`contracts` is missing required columns: pay"
    )
  })

  test_that(paste0("a covariate in both tables, or in neither, errors naming it (", backend, ")"), {
    contracts <- survival_contracts()
    contracts$gender <- "F"

    expect_error(
      do.call(run_survival_panel, c(
        list(backend, survival_personnel(), contracts),
        survival_args, list(covariate_cols = "gender")
      )),
      "`gender` is in both"
    )
    expect_error(
      do.call(run_survival_panel, c(
        list(backend, survival_personnel(), survival_contracts()),
        survival_args, list(covariate_cols = "grade")
      )),
      "`grade` is in neither"
    )
  })
}

test_that("both backends give the same panel on the bundled data", {
  skip_if_not_installed("duckdb")
  skip_if_not_installed("dbplyr")

  contracts <- data.table::as.data.table(bra_hrmis_contract)
  personnel <- data.table::as.data.table(bra_hrmis_personnel)
  tenure <- compute_tenure_panel(contracts)
  personnel <- merge(personnel, tenure, by = c("personnel_id", "ref_date"), all.x = TRUE)
  # only the needed columns: some text columns are not valid UTF-8, which
  # duckdb refuses to store
  personnel <- personnel[, .(personnel_id, ref_date, employment_status, tenure_years, gender)]
  contracts <- contracts[, .(contract_id, personnel_id, ref_date, gross_salary_lcu, paygrade)]
  args <- list(
    tenure_col = "tenure_years", salary_col = "gross_salary_lcu",
    status_col = "employment_status", covariate_cols = c("gender", "paygrade")
  )

  from_df <- do.call(run_survival_panel, c(list("data.frame", personnel, contracts), args))
  from_db <- do.call(run_survival_panel, c(list("duckdb", personnel, contracts), args))

  expect_gt(nrow(from_df), 9000L)
  expect_equal(from_db, from_df)
})

test_that("an unsupported input errors", {
  expect_error(
    build_survival_panel(as.matrix(survival_personnel()), survival_contracts(), "tenure", "pay"),
    "must be a data frame or a lazy database table"
  )
})

# ---- survival_panel class ----------------------------------------------------

for (backend in backends) {
  test_that(paste0("the panel is a survival_panel that remembers its columns, also once filtered (", backend, ")"), {
    personnel <- survival_personnel()
    contracts <- survival_contracts()
    if (backend == "duckdb") {
      skip_if_not_installed("duckdb")
      con <- suppressMessages(DBI::dbConnect(duckdb::duckdb()))
      on.exit(DBI::dbDisconnect(con, shutdown = TRUE))
      DBI::dbWriteTable(con, "personnel", personnel)
      DBI::dbWriteTable(con, "contracts", contracts)
      personnel <- dplyr::tbl(con, "personnel")
      contracts <- dplyr::tbl(con, "contracts")
    }

    panel <- do.call(build_survival_panel, c(
      list(personnel, contracts), survival_args, list(covariate_cols = "gender")
    ))
    filtered <- dplyr::filter(panel, gender == "F")

    for (x in list(panel, filtered)) {
      expect_s3_class(x, "survival_panel")
      expect_identical(attr(x, "tenure_col"), "tenure")
      expect_identical(attr(x, "ref_date_col"), "ref_date")
      expect_identical(attr(x, "covariate_cols"), "gender")
    }
  })
}

# ---- fit_survival_model ------------------------------------------------------

# build the panel on `backend` and fit it there, returning the fitted model
fit_on <- function(backend, personnel, contracts, panel_args, ...) {
  if (backend == "duckdb") {
    skip_if_not_installed("duckdb")
    skip_if_not_installed("dbplyr")
    con <- suppressMessages(DBI::dbConnect(duckdb::duckdb()))
    on.exit(DBI::dbDisconnect(con, shutdown = TRUE))
    DBI::dbWriteTable(con, "personnel", as.data.frame(personnel))
    DBI::dbWriteTable(con, "contracts", as.data.frame(contracts))
    personnel <- dplyr::tbl(con, "personnel")
    contracts <- dplyr::tbl(con, "contracts")
  }

  panel <- do.call(build_survival_panel, c(list(personnel, contracts), panel_args))
  fit_survival_model(panel, ...)
}

# two snapshots, everyone a new hire in 2020. Of 4 women, 1 is gone in 2021
# (exposure 3 + 0.5 = 3.5, 1 exit); of 4 men, 2 are (exposure 2 + 1 = 3,
# 2 exits). The hazard ratio of men to women is (2 / 3) / (1 / 3.5) = 7 / 3
two_group_panel <- function() {
  women <- paste0("F", 1:4)
  men <- paste0("M", 1:4)
  stay <- c("F1", "F2", "F3", "M1", "M2")
  list(
    personnel = data.frame(
      personnel_id = c(women, men, stay),
      ref_date = as.Date(rep(c("2020-01-01", "2021-01-01"), c(8, 5))),
      tenure = rep(c(0, 1), c(8, 5)),
      gender = substr(c(women, men, stay), 1, 1)
    ),
    contracts = data.frame(
      contract_id = "C1", personnel_id = "F1",
      ref_date = as.Date("2020-01-01"), pay = 100
    )
  )
}

two_group_args <- list(
  tenure_col = "tenure", salary_col = "pay", covariate_cols = "gender"
)

for (backend in backends) {
  test_that(paste0("the hazard ratio of a covariate matches exits per year at risk by hand (", backend, ")"), {
    data <- two_group_panel()

    fit <- fit_on(backend, data$personnel, data$contracts, two_group_args, exit_types = "other")

    expect_s3_class(fit, "fixest")
    expect_equal(exp(unname(stats::coef(fit)["genderM"])), 7 / 3)
  })

  test_that(paste0("an exit type with no exits is left out, with a warning naming it (", backend, ")"), {
    # no status column, so no one can retire
    data <- two_group_panel()

    expect_warning(
      fit <- fit_on(backend, data$personnel, data$contracts, two_group_args),
      "No `retired` exits"
    )
    expect_s3_class(fit, "fixest")
    expect_equal(exp(unname(stats::coef(fit)["genderM"])), 7 / 3)
  })

  test_that(paste0("a covariate not in the panel errors naming it (", backend, ")"), {
    data <- two_group_panel()

    expect_error(
      fit_on(backend, data$personnel, data$contracts, two_group_args, covariate_cols = "grade"),
      "`grade`"
    )
  })

  test_that(paste0("an extra argument reaches fepois() (", backend, ")"), {
    data <- two_group_panel()

    fit <- fit_on(backend, data$personnel, data$contracts, two_group_args,
      exit_types = "other", nthreads = 1
    )
    expect_equal(exp(unname(stats::coef(fit)["genderM"])), 7 / 3)

    # fixest's own warning for a name it does not know shows the argument
    # got through
    expect_warning(
      fit_on(backend, data$personnel, data$contracts, two_group_args,
        exit_types = "other", fixef_tol = 1e-6
      ),
      "fixef_tol is not a valid argument"
    )
  })

  test_that(paste0("an argument fit_survival_model() sets itself, or that would be wrong on cells, errors naming it (", backend, ")"), {
    data <- two_group_panel()

    expect_error(
      fit_on(backend, data$personnel, data$contracts, two_group_args, vcov = "hetero"),
      "`vcov` cannot be passed through `...`"
    )
    expect_error(
      fit_on(backend, data$personnel, data$contracts, two_group_args, weights = ~exposure),
      "`weights` cannot be passed through `...`"
    )
  })
}

test_that("both backends fit the same models on the bundled data: both exit types, the panel's covariates, band and year effects", {
  skip_if_not_installed("duckdb")
  skip_if_not_installed("dbplyr")

  contracts <- data.table::as.data.table(bra_hrmis_contract)
  personnel <- data.table::as.data.table(bra_hrmis_personnel)
  personnel <- merge(personnel, compute_tenure_panel(contracts), by = c("personnel_id", "ref_date"), all.x = TRUE)
  # gender only: categories with almost no exits (some paygrades) have
  # coefficients heading to -Inf, whose values depend on where the fit stops
  personnel <- personnel[, .(personnel_id, ref_date, employment_status, tenure_years, gender)]
  contracts <- contracts[, .(contract_id, personnel_id, ref_date, gross_salary_lcu)]
  panel_args <- list(
    tenure_col = "tenure_years", salary_col = "gross_salary_lcu",
    status_col = "employment_status", covariate_cols = "gender"
  )

  from_df <- suppressMessages(fit_on("data.frame", personnel, contracts, panel_args, band_width = 5))
  from_db <- suppressMessages(fit_on("duckdb", personnel, contracts, panel_args, band_width = 5))

  expect_s3_class(from_df, "fixest_multi")
  expect_equal(fixest::models(from_df)$lhs, c("exit_retired", "exit_other"))
  expect_named(stats::coef(from_df[[1]]), "genderMASCULINO")
  expect_setequal(names(fixest::fixef(from_df[[2]])), c(".band", ".year"))
  expect_true(all(as.numeric(names(fixest::fixef(from_df[[2]])$.band)) %% 5 == 0))

  for (i in 1:2) {
    expect_equal(stats::coef(from_db[[i]]), stats::coef(from_df[[i]]), tolerance = 1e-6)
    expect_equal(fixest::se(from_db[[i]]), fixest::se(from_df[[i]]), tolerance = 1e-6)
  }
})

test_that("period_effects = FALSE leaves out the year effects", {
  data <- two_group_panel()

  fit <- fit_on("data.frame", data$personnel, data$contracts, two_group_args,
    exit_types = "other", period_effects = FALSE
  )

  expect_equal(names(fixest::fixef(fit)), ".band")
})

test_that("a table that is not a survival_panel errors pointing to build_survival_panel()", {
  expect_error(
    fit_survival_model(survival_personnel()),
    "build_survival_panel"
  )
  expect_error(
    fit_survival_model(as.matrix(survival_personnel())),
    "must be a data frame or a lazy database table"
  )
})

# ---- tidy.survival_model -----------------------------------------------------

# two_group_panel() with a status column, so both exit types happen: F3 and
# M2 are pensioners in 2021 (retired); F4, M3 and M4 are gone (other)
two_exit_panel <- function() {
  data <- two_group_panel()
  retired <- data$personnel$personnel_id %in% c("F3", "M2") &
    data$personnel$ref_date == as.Date("2021-01-01")
  data$personnel$employment_status <- ifelse(retired, "pensioner", "active")
  data
}

two_exit_args <- c(two_group_args, status_col = "employment_status")

for (backend in backends) {
  test_that(paste0("tidy() gives hazard ratios and their interval, one row per exit type and term (", backend, ")"), {
    data <- two_exit_panel()
    fit <- fit_on(backend, data$personnel, data$contracts, two_exit_args)

    out <- broom::tidy(fit, conf.level = 0.9)

    expect_named(out, c(
      "exit_type", "term", "estimate", "std.error", "statistic", "p.value",
      "conf.low", "conf.high"
    ))
    expect_equal(out$exit_type, c("retired", "other"))
    expect_equal(out$term, c("genderM", "genderM"))
    for (i in 1:2) {
      expect_equal(out$estimate[i], exp(unname(stats::coef(fit[[i]]))))
      expect_equal(out$std.error[i], unname(fixest::se(fit[[i]])), ignore_attr = TRUE)
      expect_equal(
        c(out$conf.low[i], out$conf.high[i]),
        exp(unlist(stats::confint(fit[[i]], level = 0.9), use.names = FALSE))
      )
    }
  })

  test_that(paste0("make_tidy_output = TRUE returns the tidy table instead of the model (", backend, ")"), {
    data <- two_exit_panel()

    fit <- fit_on(backend, data$personnel, data$contracts, two_exit_args)
    out <- fit_on(backend, data$personnel, data$contracts, two_exit_args, make_tidy_output = TRUE)

    expect_s3_class(out, "tbl_df")
    expect_equal(out, broom::tidy(fit))
  })
}

test_that("tidy() of a model with one exit type gives that exit type", {
  data <- two_group_panel()
  fit <- fit_on("data.frame", data$personnel, data$contracts, two_group_args, exit_types = "other")

  out <- broom::tidy(fit)

  expect_equal(out$exit_type, "other")
  expect_equal(out$estimate, 7 / 3)
})

test_that("tidy() of a model with no covariates gives no rows, with the same columns", {
  # the bundled data: a small fixture has too few cells per band to fit on
  # band effects alone
  contracts <- data.table::as.data.table(bra_hrmis_contract)
  personnel <- data.table::as.data.table(bra_hrmis_personnel)
  personnel <- merge(personnel, compute_tenure_panel(contracts), by = c("personnel_id", "ref_date"), all.x = TRUE)
  panel <- build_survival_panel(
    personnel, contracts,
    tenure_col = "tenure_years", salary_col = "gross_salary_lcu"
  )
  fit <- suppressMessages(fit_survival_model(panel, exit_types = "other", band_width = 5))

  out <- broom::tidy(fit)

  expect_equal(nrow(out), 0L)
  expect_named(out, c(
    "exit_type", "term", "estimate", "std.error", "statistic", "p.value",
    "conf.low", "conf.high"
  ))
})

test_that("a survival_model still works with fixest's own functions", {
  data <- two_exit_panel()
  fit <- fit_on("data.frame", data$personnel, data$contracts, two_exit_args)

  expect_identical(class(fit), c("survival_model", "fixest_multi"))
  expect_s3_class(summary(fit), "fixest_multi")
  expect_named(fixest::fixef(fit[[1]]), c(".band", ".year"))
  expect_identical(class(fit[[1]]), "fixest")
})

# ---- predict.survival_model --------------------------------------------------

# the bundled data's panel, with gender. In 5-year bands no one retires at
# tenure 0-4, and some cells have no tenure
bundled_survival_panel <- function() {
  contracts <- data.table::as.data.table(bra_hrmis_contract)
  personnel <- data.table::as.data.table(bra_hrmis_personnel)
  personnel <- merge(personnel, compute_tenure_panel(contracts), by = c("personnel_id", "ref_date"), all.x = TRUE)
  build_survival_panel(
    personnel, contracts,
    tenure_col = "tenure_years", salary_col = "gross_salary_lcu",
    status_col = "employment_status", covariate_cols = "gender"
  )
}

for (backend in backends) {
  test_that(paste0("predict() with no newdata gives the expected exits in each cell fitted on (", backend, ")"), {
    # one band and year, so each model fits its two cells exactly: women
    # have 3 years at risk, 1 retirement and 1 other exit; men 2.5, 1 and 2
    data <- two_exit_panel()
    fit <- fit_on(backend, data$personnel, data$contracts, two_exit_args)

    out <- predict(fit)

    expect_named(out, c(
      "ref_date", "tenure_band", "gender", "exposure",
      "exit_retired", "pred_retired", "exit_other", "pred_other"
    ))
    expect_equal(out$gender, c("F", "M"))
    expect_equal(out$exposure, c(3, 2.5))
    expect_equal(out$pred_retired, c(1, 1))
    expect_equal(out$pred_other, c(1, 2))
  })

  test_that(paste0("predict() with newdata gives each row's hazard per year (", backend, ")"), {
    # women: 1 other exit in 3.5 years at risk; men: 2 in 3
    data <- two_group_panel()
    fit <- fit_on(backend, data$personnel, data$contracts, two_group_args, exit_types = "other")
    newdata <- data.frame(
      tenure = c(0, 0.5), ref_date = as.Date("2020-06-01"), gender = c("F", "M")
    )
    original <- newdata

    out <- predict(fit, newdata)

    expect_equal(out$hazard_other, c(1 / 3.5, 2 / 3))
    expect_identical(newdata, original)
    expect_identical(out[, names(newdata), with = FALSE], data.table::as.data.table(newdata))
  })
}

test_that("predict() of the cells adds up to the exits seen, gives 0 where fixest dropped a band for no exits, and NA without tenure", {
  fit <- suppressMessages(fit_survival_model(bundled_survival_panel(), band_width = 5))

  out <- predict(fit)

  kept <- !is.na(out$tenure_band)
  expect_equal(sum(out$pred_retired[kept]), sum(out$exit_retired[kept]), tolerance = 1e-6)
  expect_equal(sum(out$pred_other[kept]), sum(out$exit_other[kept]), tolerance = 1e-6)
  expect_true(all(out$pred_retired[out$tenure_band %in% 0] == 0))
  expect_true(all(is.na(out$pred_retired[!kept])))
})

test_that("predict() with newdata gives 0 for a band seen with no exits, NA for one never seen", {
  fit <- suppressMessages(fit_survival_model(bundled_survival_panel(), band_width = 5))
  newdata <- data.frame(
    tenure_years = c(2, 12, 200), ref_date = as.Date("2012-01-01"), gender = "FEMININO"
  )

  out <- predict(fit, newdata)

  expect_equal(out$hazard_retired[1], 0)
  expect_gt(out$hazard_retired[2], 0)
  expect_true(is.na(out$hazard_retired[3]))
})

test_that("predict() with newdata gives the chance of each exit within the horizon, at a constant hazard", {
  # no status column, so no retirements: that hazard is 0
  data <- two_group_panel()
  expect_warning(
    fit <- fit_on("data.frame", data$personnel, data$contracts, two_group_args),
    "No `retired` exits"
  )
  newdata <- data.frame(tenure = 0, ref_date = as.Date("2020-06-01"), gender = c("F", "M"))
  hazard <- c(1 / 3.5, 2 / 3)

  out <- predict(fit, newdata, horizon = 1 / 12)

  expect_equal(out$hazard_retired, c(0, 0))
  expect_equal(out$prob_retired, c(0, 0))
  expect_equal(out$prob_other, 1 - exp(-hazard / 12))
  expect_equal(out$prob_stay, exp(-hazard / 12))
})

test_that("predict() splits the chance of leaving between exit types in proportion to their hazards", {
  data <- two_exit_panel()
  fit <- fit_on("data.frame", data$personnel, data$contracts, two_exit_args)
  newdata <- data.frame(tenure = 0, ref_date = as.Date("2020-06-01"), gender = c("F", "M"))

  out <- predict(fit, newdata)

  total <- out$hazard_retired + out$hazard_other
  expect_equal(out$prob_retired, out$hazard_retired / total * (1 - exp(-total)))
  expect_equal(out$prob_retired + out$prob_other + out$prob_stay, c(1, 1))
})

test_that("predict() and fit_survival_model() of the cells: an exit type no one had is 0, one not asked for is left out", {
  data <- two_group_panel()
  expect_warning(
    fit <- fit_on("data.frame", data$personnel, data$contracts, two_group_args),
    "No `retired` exits"
  )
  expect_equal(predict(fit)$pred_retired, c(0, 0))

  data <- two_exit_panel()
  fit <- fit_on("data.frame", data$personnel, data$contracts, two_exit_args, exit_types = "other")
  newdata <- data.frame(tenure = 0, ref_date = as.Date("2020-06-01"), gender = "F")

  expect_false("pred_retired" %in% names(predict(fit)))
  out <- predict(fit, newdata)
  expect_false(any(c("hazard_retired", "prob_retired", "prob_other", "prob_stay") %in% names(out)))
})

test_that("monthly snapshots give hazards per year", {
  # two_group_panel() with the second snapshot a month later: exposure is
  # 31/366 of a year per stayer, half that per leaver
  data <- two_group_panel()
  data$personnel$ref_date[data$personnel$ref_date == as.Date("2021-01-01")] <- as.Date("2020-02-01")
  fit <- fit_on("data.frame", data$personnel, data$contracts, two_group_args, exit_types = "other")
  newdata <- data.frame(tenure = 0, ref_date = as.Date("2020-01-01"), gender = c("F", "M"))

  out <- predict(fit, newdata)

  month <- 31 / 366
  expect_equal(out$hazard_other, c(1 / (3.5 * month), 2 / (3 * month)))
})

test_that("predict() errors on newdata missing a column, or a horizon that is not a positive number", {
  data <- two_group_panel()
  fit <- fit_on("data.frame", data$personnel, data$contracts, two_group_args, exit_types = "other")

  expect_error(
    predict(fit, data.frame(tenure = 0, ref_date = as.Date("2020-06-01"))),
    "`newdata` is missing required columns: gender"
  )
  newdata <- data.frame(tenure = 0, ref_date = as.Date("2020-06-01"), gender = "F")
  expect_error(predict(fit, newdata, horizon = 0), "`horizon`")
  expect_error(predict(fit, newdata, horizon = c(1, 2)), "`horizon`")
})
