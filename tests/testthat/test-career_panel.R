# ---------------------------------------------------------------------------
# backends
#
# Every test but two runs on data frames (data.frame method) and on duckdb
# tables (tbl_dbi method), so the two implementations are held to the same
# behaviour. run_panel() writes both tables to one duckdb connection,
# builds the panel there, collects it and sorts it as the data.frame method
# does (a database table has no row order).
# ---------------------------------------------------------------------------
backends <- c("data.frame", "duckdb")

run_panel <- function(backend, personnel, contracts, ...) {
  if (backend == "data.frame") {
    return(build_career_panel(personnel, contracts, ...))
  }

  skip_if_not_installed("duckdb")
  skip_if_not_installed("dbplyr")

  # silence duckdb's notice about where it stores extensions
  con <- suppressMessages(DBI::dbConnect(duckdb::duckdb()))
  on.exit(DBI::dbDisconnect(con, shutdown = TRUE))
  DBI::dbWriteTable(con, "personnel", as.data.frame(personnel))
  DBI::dbWriteTable(con, "contracts", as.data.frame(contracts))

  out <- build_career_panel(
    dplyr::tbl(con, "personnel"), dplyr::tbl(con, "contracts"), ...
  )
  out <- data.table::as.data.table(dplyr::collect(out))
  data.table::setorderv(out, c("personnel_id", "ref_date"))
  out[]
}

# ---------------------------------------------------------------------------
# fixtures
#
# the hand-worked panel of the estimate_progression_rates() tests: four
# people over three annual snapshots, one contract each per year:
#
#   person  2020                 2021                  2022
#   P1      active, t0, pay 100  active, t1, pay 110   active, t2, pay 121
#   P2      active, t0, pay 200  (gone)
#   P3      active, t1, pay 100  pensioner, t2
#   P4                           active, t0, pay 100   active, t1, pay 90
#
# rows at risk (active, with a later snapshot), by person and date:
#
#   P1/2020 -> 2021  stays            exposure 1    growth log(110 / 100)
#   P1/2021 -> 2022  stays            exposure 1    growth log(121 / 110)
#   P2/2020 -> 2021  gone: other      exposure 1/2  no growth
#   P3/2020 -> 2021  pensioner        exposure 1/2  no growth
#   P4/2021 -> 2022  stays            exposure 1    growth log(90 / 100)
#
# the 2022 rows have no later snapshot, and P3/2021 is not active, so none
# of them is at risk
# ---------------------------------------------------------------------------
panel_personnel <- function() {
  data.table::data.table(
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
    tenure = c(0, 0, 1, 1, 2, 0, 2, 1)
  )
}

panel_contracts <- function() {
  data.table::data.table(
    contract_id = c("C1", "C2", "C3", "C4", "C5", "C6", "C7"),
    personnel_id = c("P1", "P2", "P3", "P1", "P4", "P1", "P4"),
    ref_date = as.Date(c(
      "2020-01-01", "2020-01-01", "2020-01-01",
      "2021-01-01", "2021-01-01",
      "2022-01-01", "2022-01-01"
    )),
    pay = c(100, 200, 100, 110, 100, 121, 90)
  )
}

# ---------------------------------------------------------------------------
# build_career_panel()
# ---------------------------------------------------------------------------
for (backend in backends) test_that(paste0("each active person-year gets its interval, exposure, exit type and pay growth", " [", backend, "]"), {
  out <- run_panel(backend, 
    panel_personnel(), panel_contracts(),
    clock_col = "tenure", salary_col = "pay"
  )

  expect_equal(out$personnel_id, c("P1", "P1", "P2", "P3", "P4"))
  expect_equal(
    out$ref_date,
    as.Date(c("2020-01-01", "2021-01-01", "2020-01-01", "2020-01-01", "2021-01-01"))
  )
  expect_equal(
    out$next_ref_date,
    as.Date(c("2021-01-01", "2022-01-01", "2021-01-01", "2021-01-01", "2022-01-01"))
  )
  expect_equal(out$spell, c(1L, 1L, 1L, 1L, 1L))
  expect_equal(out$tenure, c(0, 1, 0, 1, 0))
  expect_equal(out$pay, c(100, 110, 200, 100, 100))
  expect_equal(out$exposure, c(1, 1, 0.5, 0.5, 1))
  expect_equal(out$exit_type, c("none", "none", "other", "retirement", "none"))
  expect_equal(out$pay_growth, c(log(1.1), log(1.1), NA, NA, log(0.9)))
})

# the same panel with an occupation on each contract, and two people holding
# two contracts in 2020:
#   P1/2020: clerk 60 + nurse 40 (total 100)
#   P3/2020: driver 50 (C9) + clerk 50 (C3), a tie in pay
panel_occupation_contracts <- function() {
  data.table::data.table(
    contract_id = c("C1", "C8", "C2", "C9", "C3", "C4", "C5", "C6", "C7"),
    personnel_id = c("P1", "P1", "P2", "P3", "P3", "P1", "P4", "P1", "P4"),
    ref_date = as.Date(c(
      "2020-01-01", "2020-01-01", "2020-01-01", "2020-01-01", "2020-01-01",
      "2021-01-01", "2021-01-01",
      "2022-01-01", "2022-01-01"
    )),
    pay = c(60, 40, 200, 50, 50, 110, 100, 121, 90),
    occupation = c(
      "clerk", "nurse", "nurse", "driver", "clerk",
      "clerk", "clerk", "clerk", "clerk"
    )
  )
}

for (backend in backends) test_that(paste0("a contract covariate comes from the highest-paid contract, with pay summed across contracts", " [", backend, "]"), {
  # P1/2020 is a clerk (60 > 40) on total pay 100; P3/2020's 50/50 tie
  # goes to the lower contract_id, C3, a clerk
  out <- run_panel(backend, 
    panel_personnel(), panel_occupation_contracts(),
    clock_col = "tenure", salary_col = "pay", covariate_cols = "occupation"
  )

  expect_equal(out$occupation, c("clerk", "clerk", "nurse", "clerk", "clerk"))
  expect_equal(out$pay, c(100, 110, 200, 100, 100))
})

for (backend in backends) test_that(paste0("select_contract = \"lowest_paid\" takes the covariate from the lowest-paid contract", " [", backend, "]"), {
  # P1/2020 is now a nurse (40 < 60); P3/2020's tie still goes to C3
  out <- run_panel(backend, 
    panel_personnel(), panel_occupation_contracts(),
    clock_col = "tenure", salary_col = "pay", covariate_cols = "occupation",
    select_contract = "lowest_paid"
  )

  expect_equal(out$occupation, c("nurse", "clerk", "nurse", "clerk", "clerk"))
  expect_equal(out$pay, c(100, 110, 200, 100, 100))
})

for (backend in backends) test_that(paste0("covariates from personnel and from contracts sit side by side", " [", backend, "]"), {
  personnel <- panel_personnel()
  personnel[, gender := ifelse(personnel_id %in% c("P1", "P2"), "F", "M")]

  out <- run_panel(backend, 
    personnel, panel_occupation_contracts(),
    clock_col = "tenure", salary_col = "pay",
    covariate_cols = c("gender", "occupation")
  )

  expect_equal(out$gender, c("F", "F", "F", "M", "M"))
  expect_equal(out$occupation, c("clerk", "clerk", "nurse", "clerk", "clerk"))
})

for (backend in backends) test_that(paste0("only a pensioner counts as retiring; any other status, or none, is an other exit", " [", backend, "]"), {
  # P2 is "inactive" in 2021 and P3 has a missing status there; neither
  # retired
  personnel <- panel_personnel()
  personnel <- rbind(personnel, data.table::data.table(
    personnel_id = "P2", ref_date = as.Date("2021-01-01"),
    employment_status = "inactive", tenure = 1
  ))
  personnel[personnel_id == "P3" & ref_date == as.Date("2021-01-01"),
    employment_status := NA_character_
  ]

  out <- run_panel(backend, 
    personnel, panel_contracts(), clock_col = "tenure", salary_col = "pay"
  )

  expect_equal(out$exit_type, c("none", "none", "other", "other", "none"))
  expect_equal(out$exposure, c(1, 1, 0.5, 0.5, 1))
})

for (backend in backends) test_that(paste0("someone who leaves and comes back starts a new spell", " [", backend, "]"), {
  # R is active in 2020, gone in 2021, back in 2022 and 2023; S is active
  # throughout. R's 2020 row ends in an other exit (spell 1) and R's 2022
  # row is spell 2; the 2023 rows are in the last snapshot
  dates <- as.Date(c("2020-01-01", "2021-01-01", "2022-01-01", "2023-01-01"))
  personnel <- data.table::data.table(
    personnel_id = c("R", "R", "R", "S", "S", "S", "S"),
    ref_date = dates[c(1, 3, 4, 1, 2, 3, 4)],
    employment_status = "active",
    tenure = c(5, 6, 7, 1, 2, 3, 4)
  )
  contracts <- data.table::data.table(
    contract_id = paste0("C", 1:7),
    personnel_id = personnel$personnel_id,
    ref_date = personnel$ref_date,
    pay = 100
  )

  out <- run_panel(backend, 
    personnel, contracts, clock_col = "tenure", salary_col = "pay"
  )

  expect_equal(out$personnel_id, c("R", "R", "S", "S", "S"))
  expect_equal(out$ref_date, dates[c(1, 3, 1, 2, 3)])
  expect_equal(out$exit_type, c("other", "none", "none", "none", "none"))
  expect_equal(out$spell, c(1L, 2L, 1L, 1L, 1L))
})

for (backend in backends) test_that(paste0("a person-year with no clock value is left out, with a warning, but still counts as the year before's next", " [", backend, "]"), {
  # P1/2021 has no tenure: its own row goes, but P1/2020 still sees P1
  # active in 2021, so stays, with growth log(110 / 100)
  personnel <- panel_personnel()
  personnel[personnel_id == "P1" & ref_date == as.Date("2021-01-01"),
    tenure := NA
  ]

  expect_warning(
    out <- run_panel(backend, 
      personnel, panel_contracts(), clock_col = "tenure", salary_col = "pay"
    ),
    "1 active person-snapshot.*no `tenure`"
  )
  expect_equal(out$personnel_id, c("P1", "P2", "P3", "P4"))
  expect_equal(out$exit_type, c("none", "other", "retirement", "none"))
  expect_equal(out$pay_growth, c(log(1.1), NA, NA, log(0.9)))
})

for (backend in backends) test_that(paste0("a duplicated personnel row warns and gives one row", " [", backend, "]"), {
  personnel <- panel_personnel()
  personnel <- rbind(personnel, personnel[personnel_id == "P2"])

  expect_warning(
    out <- run_panel(backend, 
      personnel, panel_contracts(), clock_col = "tenure", salary_col = "pay"
    ),
    "duplicate"
  )
  expect_equal(out$personnel_id, c("P1", "P1", "P2", "P3", "P4"))
  expect_equal(out$exit_type, c("none", "none", "other", "retirement", "none"))
})

for (backend in backends) test_that(paste0("a missing clock column errors and says how to build one", " [", backend, "]"), {
  expect_error(
    run_panel(backend, 
      panel_personnel(), panel_contracts(),
      clock_col = "years_of_service", salary_col = "pay"
    ),
    "years_of_service.*compute_tenure_panel[(][)].*age"
  )
})

for (backend in backends) test_that(paste0("a missing pay column errors naming it", " [", backend, "]"), {
  expect_error(
    run_panel(backend, 
      panel_personnel(), panel_contracts(),
      clock_col = "tenure", salary_col = "gross_salary_real"
    ),
    "`contracts` is missing required columns: gross_salary_real"
  )
})

for (backend in backends) test_that(paste0("a covariate found in both tables errors, since it is ambiguous", " [", backend, "]"), {
  personnel <- panel_personnel()
  personnel[, occupation := "clerk"]

  expect_error(
    run_panel(backend, 
      personnel, panel_occupation_contracts(),
      clock_col = "tenure", salary_col = "pay", covariate_cols = "occupation"
    ),
    "`occupation` is in both `personnel` and `contracts`"
  )
})

for (backend in backends) test_that(paste0("a covariate found in neither table errors naming it", " [", backend, "]"), {
  expect_error(
    run_panel(backend, 
      panel_personnel(), panel_contracts(),
      clock_col = "tenure", salary_col = "pay", covariate_cols = "region"
    ),
    "`region` is in neither `personnel` nor `contracts`"
  )
})

for (backend in backends) test_that(paste0("fewer than 2 snapshots errors", " [", backend, "]"), {
  personnel <- panel_personnel()[ref_date == as.Date("2020-01-01")]

  expect_error(
    run_panel(backend, 
      personnel, panel_contracts(), clock_col = "tenure", salary_col = "pay"
    ),
    "`personnel` must contain at least 2 snapshots"
  )
})

for (backend in backends) test_that(paste0("missing or zero pay leaves a row at risk but without pay growth", " [", backend, "]"), {
  # P1/2021 has pay 0, P2/2020 has NA pay, and P3/2020 has a second
  # contract with NA pay, left out of its total (still 100). P1/2020's
  # growth ends on zero pay and P1/2021's starts on it, so neither has one
  contracts <- panel_contracts()
  contracts[personnel_id == "P1" & ref_date == as.Date("2021-01-01"), pay := 0]
  contracts[personnel_id == "P2", pay := NA]
  contracts <- rbind(contracts, data.table::data.table(
    contract_id = "C10", personnel_id = "P3",
    ref_date = as.Date("2020-01-01"), pay = NA_real_
  ))

  out <- run_panel(backend, 
    panel_personnel(), contracts, clock_col = "tenure", salary_col = "pay"
  )

  expect_equal(out$pay, c(100, 0, NA, 100, 100))
  expect_equal(out$exit_type, c("none", "none", "other", "retirement", "none"))
  expect_equal(out$exposure, c(1, 1, 0.5, 0.5, 1))
  expect_equal(out$pay_growth, c(NA, NA, NA, NA, log(0.9)))
})

test_that("the caller's tables are not changed", {
  personnel <- panel_personnel()
  contracts <- panel_occupation_contracts()
  personnel_before <- data.table::copy(personnel)
  contracts_before <- data.table::copy(contracts)

  build_career_panel(
    personnel, contracts,
    clock_col = "tenure", salary_col = "pay", covariate_cols = "occupation"
  )

  expect_identical(personnel, personnel_before)
  expect_identical(contracts, contracts_before)
})

test_that("on annual data, the panel summed by whole years of tenure gives Level 1's rates", {
  # estimate_progression_rates() counts the same person-years in its own
  # way; summing the panel's rows by whole years of tenure must agree
  contracts <- data.table::as.data.table(bra_hrmis_contract)
  personnel <- data.table::as.data.table(bra_hrmis_personnel)
  tenure <- compute_tenure_panel(contracts)
  personnel <- merge(personnel, tenure, by = c("personnel_id", "ref_date"), all.x = TRUE)

  # both warn about the same person-years with no tenure
  rates <- suppressWarnings(estimate_progression_rates(
    personnel, contracts, tenure_col = "tenure_years", salary_col = "gross_salary_lcu"
  ))
  panel <- suppressWarnings(build_career_panel(
    personnel, contracts, clock_col = "tenure_years", salary_col = "gross_salary_lcu"
  ))

  summed <- panel[,
    .(
      pop = .N,
      stayers = sum(exit_type == "none"),
      n_pay = sum(!is.na(pay_growth)),
      log_growth = mean(pay_growth, na.rm = TRUE)
    ),
    keyby = .(tenure_years = as.integer(tenure_years))
  ]

  expect_equal(summed$tenure_years, rates$tenure_years)
  expect_equal(summed$pop, rates$pop)
  expect_equal(summed$stayers, rates$stayers)
  expect_equal(summed$n_pay, rates$n_pay)
  expect_equal(summed$log_growth[summed$n_pay > 0], log1p(rates$pay_growth[rates$n_pay > 0]))
})

# a monthly panel from January 2020 to March 2021: M is active every month,
# on pay 100 in 2020 and 110 in 2021
monthly_dates <- function() {
  seq(as.Date("2020-01-01"), as.Date("2021-03-01"), by = "month")
}

monthly_panel <- function() {
  dates <- monthly_dates()
  personnel <- data.table::data.table(
    personnel_id = "M", ref_date = dates, employment_status = "active",
    tenure = seq(0, by = 1 / 12, length.out = length(dates))
  )
  contracts <- data.table::data.table(
    contract_id = "CM", personnel_id = "M", ref_date = dates,
    pay = ifelse(dates < as.Date("2021-01-01"), 100, 110)
  )
  list(personnel = personnel, contracts = contracts)
}

for (backend in backends) test_that(paste0("monthly snapshots give monthly exposure and pay growth to the same month a year later", " [", backend, "]"), {
  # L is active January to June 2020, then gone, leaving during June. time
  # is counted in calendar months, each 1/12 of a year
  m <- monthly_panel()
  l_dates <- monthly_dates()[1:6]
  personnel <- rbind(m$personnel, data.table::data.table(
    personnel_id = "L", ref_date = l_dates, employment_status = "active",
    tenure = 3
  ))
  contracts <- rbind(m$contracts, data.table::data.table(
    contract_id = "CL", personnel_id = "L", ref_date = l_dates, pay = 50
  ))

  out <- run_panel(backend, 
    personnel, contracts, clock_col = "tenure", salary_col = "pay"
  )
  m_out <- out[personnel_id == "M"]
  l_out <- out[personnel_id == "L"]

  # M: every month but the last; the twelve months of 2020 add up to a year
  expect_equal(nrow(m_out), 14L)
  expect_equal(sum(m_out$exposure[1:12]), 1)
  expect_equal(m_out$exposure[1], 1 / 12)
  # January to March 2020 have the same month in 2021; later months do not
  expect_equal(m_out$pay_growth, c(rep(log(1.1), 3), rep(NA, 11)))

  # L: stays January to May, leaves during June (half of June's exposure)
  expect_equal(l_out$exit_type, c(rep("none", 5), "other"))
  expect_equal(l_out$exposure[6], (1 / 12) / 2)
  expect_equal(l_out$pay_growth, rep(NA_real_, 6))
})

for (backend in backends) test_that(paste0("a snapshot missing from the whole panel gives a longer interval and no pay growth across it", " [", backend, "]"), {
  # annual snapshots 2019, 2020, 2021 and 2023 (no 2022); A is active in all
  # of them, B leaves after 2021
  dates <- as.Date(c("2019-01-01", "2020-01-01", "2021-01-01", "2023-01-01"))
  personnel <- data.table::data.table(
    personnel_id = c("A", "A", "A", "A", "B"),
    ref_date = dates[c(1, 2, 3, 4, 3)],
    employment_status = "active",
    tenure = c(0, 1, 2, 4, 10)
  )
  contracts <- data.table::data.table(
    contract_id = paste0("C", 1:5),
    personnel_id = personnel$personnel_id,
    ref_date = personnel$ref_date,
    pay = c(100, 110, 121, 150, 300)
  )

  out <- run_panel(backend, 
    personnel, contracts, clock_col = "tenure", salary_col = "pay"
  )

  expect_equal(out$personnel_id, c("A", "A", "A", "B"))
  expect_equal(out$next_ref_date, dates[c(2, 3, 4, 4)])
  expect_equal(out$exposure, c(1, 1, 2, 1))
  expect_equal(out$exit_type, c("none", "none", "none", "other"))
  expect_equal(out$pay_growth, c(log(1.1), log(1.1), NA, NA))
})

for (backend in backends) test_that(paste0("a seasonal worker gets pay growth to a year later, though they left in between", " [", backend, "]"), {
  # W works January 2020, leaves, and is back in December 2020 and January
  # 2021. W's January 2020 row ends in an exit, yet W is active a year
  # later, so its pay growth is measured
  m <- monthly_panel()
  w_dates <- as.Date(c("2020-01-01", "2020-12-01", "2021-01-01"))
  personnel <- rbind(m$personnel, data.table::data.table(
    personnel_id = "W", ref_date = w_dates, employment_status = "active",
    tenure = c(0, 1 / 12, 2 / 12)
  ))
  contracts <- rbind(m$contracts, data.table::data.table(
    contract_id = "CW", personnel_id = "W", ref_date = w_dates,
    pay = c(100, 100, 120)
  ))

  out <- run_panel(backend, 
    personnel, contracts, clock_col = "tenure", salary_col = "pay"
  )[personnel_id == "W"]

  expect_equal(out$ref_date, w_dates)
  expect_equal(out$exit_type, c("other", "none", "other"))
  expect_equal(out$spell, c(1L, 2L, 2L))
  expect_equal(out$pay_growth, c(log(1.2), NA, NA))
})

for (backend in backends) test_that(paste0("someone paid as a pensioner a year later gets no pay growth", " [", backend, "]"), {
  # P3 retires in 2021 but has a pension contract paying 80 then
  contracts <- rbind(panel_contracts(), data.table::data.table(
    contract_id = "C11", personnel_id = "P3",
    ref_date = as.Date("2021-01-01"), pay = 80
  ))

  out <- run_panel(backend, 
    panel_personnel(), contracts, clock_col = "tenure", salary_col = "pay"
  )

  expect_equal(out[personnel_id == "P3", exit_type], "retirement")
  expect_equal(out[personnel_id == "P3", pay_growth], NA_real_)
})

for (backend in backends) test_that(paste0("pay growth is per year when the snapshots are not exactly a year apart", " [", backend, "]"), {
  # annual snapshots, but 2021's was taken in February: 13 months after
  # 2020's, and still the closest to a year later. A's pay rises by 1.3
  dates <- as.Date(c("2019-01-01", "2020-01-01", "2021-02-01", "2022-01-01"))
  personnel <- data.table::data.table(
    personnel_id = "A", ref_date = dates, employment_status = "active",
    tenure = 0:3
  )
  contracts <- data.table::data.table(
    contract_id = "CA", personnel_id = "A", ref_date = dates,
    pay = c(100, 100, 130, 130)
  )

  out <- run_panel(backend, 
    personnel, contracts, clock_col = "tenure", salary_col = "pay"
  )

  expect_equal(out$exposure, c(1, 13 / 12, 11 / 12))
  expect_equal(out$pay_growth, c(0, log(1.3) / (13 / 12), 0))
})

for (backend in backends) test_that(paste0("an exit on a row with no clock value still starts a new spell", " [", backend, "]"), {
  # P1 has no tenure in 2021 and is gone in 2022, then back in 2023: the
  # 2021 row goes, but its exit still makes the 2023 return spell 2
  personnel <- panel_personnel()
  personnel <- personnel[!(personnel_id == "P1" & ref_date == as.Date("2022-01-01"))]
  personnel[personnel_id == "P1" & ref_date == as.Date("2021-01-01"), tenure := NA]
  personnel <- rbind(personnel, data.table::data.table(
    personnel_id = c("P1", "P1", "P4", "P4"),
    ref_date = as.Date(c("2023-01-01", "2024-01-01", "2023-01-01", "2024-01-01")),
    employment_status = "active",
    tenure = c(2, 3, 2, 3)
  ))

  out <- suppressWarnings(run_panel(backend, 
    personnel, panel_contracts(), clock_col = "tenure", salary_col = "pay"
  ))

  expect_equal(out[personnel_id == "P1", ref_date], as.Date(c("2020-01-01", "2023-01-01")))
  expect_equal(out[personnel_id == "P1", spell], c(1L, 2L))
})

for (backend in backends) test_that(paste0("with uneven snapshot spacing, pay growth is to the snapshot a year later by date", " [", backend, "]"), {
  # annual, then quarterly through 2019, then annual again. the usual
  # spacing is about a quarter, so "a year later" must be within ~46 days
  # of one year on: 2018-01 -> 2019-01, 2019-01 -> 2020-01 (four snapshots
  # on), 2020-01 -> 2021-01; the April, July and October 2019 snapshots
  # have none. Q is in every snapshot; G only in January 2019 and 2020
  dates <- as.Date(c(
    "2018-01-01", "2019-01-01", "2019-04-01", "2019-07-01", "2019-10-01",
    "2020-01-01", "2021-01-01"
  ))
  personnel <- data.table::data.table(
    personnel_id = c(rep("Q", 7), "G", "G"),
    ref_date = c(dates, dates[c(2, 6)]),
    employment_status = "active",
    tenure = c(0:6, 3, 4)
  )
  contracts <- data.table::data.table(
    contract_id = paste0("C", 1:9),
    personnel_id = personnel$personnel_id,
    ref_date = personnel$ref_date,
    pay = c(100, 110, 110, 110, 110, 121, 133.1, 200, 220)
  )

  out <- run_panel(backend, 
    personnel, contracts, clock_col = "tenure", salary_col = "pay"
  )

  expect_equal(out[personnel_id == "Q", ref_date], dates[1:6])
  expect_equal(
    out[personnel_id == "Q", pay_growth],
    c(log(1.1), log(1.1), NA, NA, NA, log(1.1))
  )
  expect_equal(out[personnel_id == "G", ref_date], dates[c(2, 6)])
  expect_equal(out[personnel_id == "G", exit_type], c("other", "other"))
  expect_equal(out[personnel_id == "G", pay_growth], c(log(1.1), NA))
})

# ---------------------------------------------------------------------------
# build_career_panel() on a database
# ---------------------------------------------------------------------------
local_duckdb_tables <- function(personnel, contracts, env = parent.frame()) {
  skip_if_not_installed("duckdb")
  skip_if_not_installed("dbplyr")
  con <- suppressMessages(DBI::dbConnect(duckdb::duckdb()))
  withr::defer(DBI::dbDisconnect(con, shutdown = TRUE), envir = env)
  DBI::dbWriteTable(con, "personnel", as.data.frame(personnel))
  DBI::dbWriteTable(con, "contracts", as.data.frame(contracts))
  list(con = con, personnel = dplyr::tbl(con, "personnel"), contracts = dplyr::tbl(con, "contracts"))
}

test_that("on a database, the panel is a lazy table, left there until collected", {
  db <- local_duckdb_tables(panel_personnel(), panel_contracts())

  out <- build_career_panel(
    db$personnel, db$contracts, clock_col = "tenure", salary_col = "pay"
  )

  expect_s3_class(out, "tbl_dbi")
  expect_equal(
    colnames(out),
    c(
      "personnel_id", "ref_date", "next_ref_date", "spell", "tenure", "pay",
      "exposure", "exit_type", "pay_growth"
    )
  )
})

test_that("on the bundled data, the database panel equals the data frame panel", {
  # only the columns used (some native-language text columns are not valid
  # UTF-8, which duckdb refuses to store)
  contracts <- data.table::as.data.table(bra_hrmis_contract)[,
    .(contract_id, personnel_id, ref_date, gross_salary_lcu, occupation_english, est_id)
  ]
  personnel <- data.table::as.data.table(bra_hrmis_personnel)[,
    .(personnel_id, ref_date, employment_status, age, gender, educat7)
  ]

  args <- list(
    clock_col = "age", salary_col = "gross_salary_lcu",
    covariate_cols = c("gender", "educat7", "occupation_english", "est_id")
  )
  from_df <- do.call(build_career_panel, c(list(personnel, contracts), args))
  from_db <- do.call(run_panel, c(list("duckdb", personnel, contracts), args))

  expect_equal(from_db, from_df, ignore_attr = TRUE)
})

test_that("personnel in a database with contracts in memory errors", {
  db <- local_duckdb_tables(panel_personnel(), panel_contracts())

  expect_error(
    build_career_panel(
      db$personnel, panel_contracts(), clock_col = "tenure", salary_col = "pay"
    ),
    "`personnel` and `contracts` must be tables on the same database connection"
  )
})

test_that("tables on two different database connections error", {
  db1 <- local_duckdb_tables(panel_personnel(), panel_contracts())
  db2 <- local_duckdb_tables(panel_personnel(), panel_contracts())

  expect_error(
    build_career_panel(
      db1$personnel, db2$contracts, clock_col = "tenure", salary_col = "pay"
    ),
    "`personnel` and `contracts` must be tables on the same database connection"
  )
})

test_that("input that is neither a data frame nor a database table errors naming it", {
  expect_error(
    build_career_panel(
      list(1), panel_contracts(), clock_col = "tenure", salary_col = "pay"
    ),
    "`personnel` must be a data frame or a lazy database table"
  )
})
