library(testthat)
library(data.table)

# ---------------------------------------------------------------------------
# Helpers
# ---------------------------------------------------------------------------

# a single snapshot of the personnel panel
make_snap <- function(personnel_id, ref_date, age, status, ...) {
  data.table::data.table(
    personnel_id = personnel_id,
    ref_date = as.Date(ref_date),
    age = as.integer(age),
    employment_status = status,
    ...
  )
}

# one t0/t1 pair holding the decrement bug regressions:
#   P1, P2: active at 60 -> P1 retires, P2 stays active
#   P3: ALREADY a pensioner at t0 (age 65) and remains one at t1 -- must never
#       contribute to exposure or exits (the persistent-pensioner bug)
#   P4: active at 30 -> drops out of the panel entirely by t1 (non-retirement-exit)
#   P5: active at 45 -> explicit "deceased" status at t1 (agnostic-vocabulary check)
decrement_pair_panel <- function() {
  data.table::rbindlist(list(
    make_snap(
      c("P1", "P2", "P3", "P4", "P5"),
      "2020-01-01",
      c(60L, 60L, 65L, 30L, 45L),
      c("active", "active", "pensioner", "active", "active"),
      gender = c("M", "M", "M", "F", "M")
    ),
    make_snap(
      c("P1", "P2", "P3", "P5"),
      "2021-01-01",
      c(61L, 61L, 66L, 46L),
      c("pensioner", "active", "pensioner", "deceased"),
      gender = c("M", "M", "M", "M")
    )
  ))
}

# a deterministic 3-age panel with exact, hand-verifiable decrement rates:
#   age 50 (n=4): 1 retires             -> px = 0.75
#   age 51 (n=2): 1 retires             -> px = 0.50
#   age 52 (n=2): 0 retire, 0 exit      -> px = 1.00
# used for both estimate_decrement_rates() and compute_service_table() exact-
# arithmetic checks
deterministic_panel <- function() {
  data.table::rbindlist(list(
    make_snap(
      c("P1", "P2", "P3", "P4", "P5", "P6", "P7", "P8"),
      "2020-01-01",
      c(50L, 50L, 50L, 50L, 51L, 51L, 52L, 52L),
      "active"
    ),
    make_snap(
      c("P1", "P2", "P3", "P4", "P5", "P6", "P7", "P8"),
      "2021-01-01",
      c(51L, 51L, 51L, 51L, 52L, 52L, 53L, 53L),
      c("pensioner", "active", "active", "active",
        "pensioner", "active", "active", "active")
    )
  ))
}

# a panel spanning ages 55-65 with a synthetic 40%/year retirement hazard
# above age 60, with age == 62 removed everywhere -- a real, unrecoverable
# age gap in the raw data, used to exercise gap-filling/smoothing
gapped_panel <- function(n_people = 150, seed = 7) {
  set.seed(seed)
  ages <- 55:65
  ids <- paste0("P", seq_len(n_people))
  panel <- data.table::rbindlist(lapply(2015:2019, function(yr) {
    make_snap(ids, sprintf("%d-01-01", yr),
              sample(ages, n_people, replace = TRUE), "active")
  }))
  data.table::setorder(panel, personnel_id, ref_date)
  panel[, employment_status := {
    st <- employment_status
    for (i in 2:length(st)) {
      if (st[i - 1] == "active" && age[i - 1] >= 60 && stats::runif(1) < 0.4) {
        st[i:length(st)] <- "pensioner"
      }
    }
    st
  }, by = personnel_id]
  panel[age != 62]
}

# ---------------------------------------------------------------------------
# estimate_decrement_rates() -- pooling across period-pairs
#
# Behaviour tests run on a data frame (data.table method) and on a duckdb
# table (tbl_dbi method), so the two implementations are held to the same
# results.
# ---------------------------------------------------------------------------
backends <- c("data.frame", "duckdb")

# run estimate_decrement_rates() on `data` or a duckdb copy of it, and return
# a data.table sorted the same way for both backends
run_decrements <- function(backend, data, group_cols = NULL) {
  if (backend == "duckdb") {
    skip_if_not_installed("duckdb")
    skip_if_not_installed("dbplyr")

    # silence duckdb's notice about where it stores extensions
    con <- suppressMessages(DBI::dbConnect(duckdb::duckdb()))
    on.exit(DBI::dbDisconnect(con, shutdown = TRUE))

    DBI::dbWriteTable(con, "personnel", as.data.frame(data))
    data <- dplyr::tbl(con, "personnel")
  }

  result <- data.table::as.data.table(dplyr::collect(
    estimate_decrement_rates(
      data, "age", "employment_status", "personnel_id", "ref_date", group_cols
    )
  ))
  data.table::setorderv(result, c("age", group_cols, "employment_status"))
  result[]
}

for (backend in backends) {
  test_that(paste0("errors when fewer than 2 snapshots are present (", backend, ")"), {
    dt <- make_snap("P1", "2020-01-01", 50L, "active")
    expect_error(
      run_decrements(backend, dt),
      "`personnel` must contain at least 2 snapshots .*found 1"
    )
  })

  test_that(paste0("returns the documented columns (", backend, ")"), {
    out <- run_decrements(backend, decrement_pair_panel(), "gender")
    expect_named(
      out,
      c("age", "gender", "employment_status", "pop", "exits", "n_periods", "decrement_rate")
    )
  })

  test_that(paste0("one snapshot pair matches a hand-calculated table (", backend, ")"), {
    # the regressions this table guards (see decrement_pair_panel()):
    # - P3, a pensioner already at t0, is not exposed: no age 65 rows
    # - P4's exit counts at their own t0 age 30, not a shifted 29
    # - P5's "deceased" is picked up from the data, not hardcoded
    # - every exposed age/group has a row per outcome, zeros included, and
    #   its rates sum to 1
    out <- run_decrements(backend, decrement_pair_panel(), "gender")
    outcomes <- c("active", "deceased", "non-retirement-exit", "pensioner")
    expected <- data.table::data.table(
      age = rep(c(30L, 45L, 60L), each = 4),
      gender = rep(c("F", "M", "M"), each = 4),
      employment_status = rep(outcomes, 3),
      pop = rep(c(1L, 1L, 2L), each = 4),
      exits = c(0L, 0L, 1L, 0L,
                0L, 1L, 0L, 0L,
                1L, 0L, 0L, 1L),
      n_periods = 1L
    )
    expected[, decrement_rate := exits / pop]
    expect_equal(out, expected)
  })

  test_that(paste0("pooled decrement rates match hand-calculated values exactly (", backend, ")"), {
    out <- run_decrements(backend, deterministic_panel())
    expect_equal(out[age == 50 & employment_status == "pensioner"]$decrement_rate, 0.25)
    expect_equal(out[age == 51 & employment_status == "pensioner"]$decrement_rate, 0.50)
    expect_equal(out[age == 52 & employment_status == "pensioner"]$decrement_rate, 0.00)
    expect_equal(out[age == 52 & employment_status == "active"]$decrement_rate, 1.00)
  })

  test_that(paste0("pooling sums exposure/events across period-pairs, not a mean of per-period rates (", backend, ")"), {
    # age 60/pensioner: pair 1 has pop=2, 1 retires (rate 0.5);
    # pair 2 has pop=11, 1 retires (rate 1/11). pooled rate must be
    # (1+1)/(2+11) = 2/13, NOT the naive mean (0.5 + 1/11)/2
    panel <- data.table::rbindlist(list(
      make_snap(paste0("A", 1:2), "2020-01-01", 60L, "active"),
      make_snap(paste0("A", 1:2), "2021-01-01", 61L, c("pensioner", "active")),
      make_snap(paste0("B", 1:11), "2021-01-01", 60L, "active"),
      make_snap(paste0("B", 1:11), "2022-01-01", 61L, c("pensioner", rep("active", 10)))
    ), use.names = TRUE, fill = TRUE)

    out <- run_decrements(backend, panel)
    row <- out[age == 60 & employment_status == "pensioner"]
    expect_equal(row$pop, 13L)
    expect_equal(row$exits, 2L)
    expect_equal(row$decrement_rate, 2 / 13)
    expect_equal(row$n_periods, 2L)
  })

  test_that(paste0("output rates sum to 1 per age/group after pooling (", backend, ")"), {
    out <- run_decrements(backend, deterministic_panel())
    sums <- out[, .(total = sum(decrement_rate)), by = age]
    expect_equal(sums$total, rep(1, nrow(sums)))
  })

  test_that(paste0("rates sum to 1 when an outcome status only appears in some snapshots (", backend, ")"), {
    # regression test: the outcome vocabulary used to be built per snapshot
    # pair, so "pensioner" (seen only at 2021) and "deceased" (seen only at
    # 2022) were pooled over just one pair's exposure (pop 4 and 3) while
    # "active" was pooled over both (pop 7) -- rates summed to 1.30
    panel <- data.table::rbindlist(list(
      make_snap(paste0("A", 1:4), "2020-01-01", 50L, "active"),
      make_snap(paste0("A", 1:4), "2021-01-01", 50L, c("active", "active", "active", "pensioner")),
      make_snap(paste0("A", 1:3), "2022-01-01", 50L, c("active", "active", "deceased"))
    ))
    out <- run_decrements(backend, panel)

    expect_equal(out$pop, rep(7L, 4))
    expect_equal(out$n_periods, rep(2L, 4))
    expect_equal(
      out[, stats::setNames(exits, employment_status)],
      c(active = 5L, deceased = 1L, `non-retirement-exit` = 0L, pensioner = 1L)
    )
    expect_equal(sum(out$decrement_rate), 1)
  })

  test_that(paste0("a person missing from the next snapshot is a non-retirement-exit, even if they reappear later (", backend, ")"), {
    # P2 is absent at 2021 and back at 2022: the 2020 -> 2021 pair must count
    # an exit, and the 2021 -> 2022 pair must not count P2 as exposed at all
    panel <- data.table::rbindlist(list(
      make_snap(c("P1", "P2"), "2020-01-01", 40L, "active"),
      make_snap("P1", "2021-01-01", 41L, "active"),
      make_snap(c("P1", "P2"), "2022-01-01", c(42L, 42L), "active")
    ))
    out <- run_decrements(backend, panel)

    expect_equal(out[age == 40 & employment_status == "non-retirement-exit"]$exits, 1L)
    expect_equal(out[age == 40]$pop, rep(2L, nrow(out[age == 40])))
    expect_equal(out[age == 41]$pop, rep(1L, nrow(out[age == 41])))
    expect_false(42L %in% out$age)  # last snapshot is never exposure
  })

  test_that(paste0("an NA status at the next snapshot is a non-retirement-exit (", backend, ")"), {
    panel <- data.table::rbindlist(list(
      make_snap(c("P1", "P2"), "2020-01-01", 40L, "active"),
      make_snap(c("P1", "P2"), "2021-01-01", 41L, c("active", NA))
    ))
    out <- run_decrements(backend, panel)
    expect_equal(out[employment_status == "non-retirement-exit"]$exits, 1L)
    expect_false(anyNA(out$employment_status))
  })

  test_that(paste0("NA values in group_cols form their own group (", backend, ")"), {
    panel <- data.table::rbindlist(list(
      make_snap(c("P1", "P2"), "2020-01-01", 40L, "active", gender = c("F", NA)),
      make_snap(c("P1", "P2"), "2021-01-01", 41L, c("active", "pensioner"), gender = c("F", NA))
    ))
    out <- run_decrements(backend, panel, "gender")
    expect_equal(out[is.na(gender) & employment_status == "pensioner"]$exits, 1L)
    expect_equal(out[gender == "F" & employment_status == "active"]$exits, 1L)
  })

  test_that(paste0("duplicate personnel_id/ref_date rows warn and are counted once (", backend, ")"), {
    clean <- deterministic_panel()
    dupes <- rbind(clean, clean[personnel_id %in% c("P1", "P5")])
    expect_warning(out <- run_decrements(backend, dupes), "4 duplicate rows")
    expect_equal(out, run_decrements(backend, clean))
  })

  test_that(paste0("conflicting duplicates keep the first row by status, whatever the row order (", backend, ")"), {
    # P8 is NA and active in 2020, P9 pensioner and active: the first by
    # status (missing last) is "active" for both, so all three are exposed
    panel <- data.table::rbindlist(list(
      make_snap(c("P1", "P8", "P8", "P9", "P9"), "2020-01-01", 50L,
                c("active", NA, "active", "pensioner", "active")),
      make_snap(c("P1", "P8", "P9"), "2021-01-01", 51L, "active")
    ))
    for (rows in list(seq_len(nrow(panel)), rev(seq_len(nrow(panel))))) {
      expect_warning(
        out <- run_decrements(backend, panel[rows]),
        "2 duplicate rows.*first by status"
      )
      expect_equal(out[employment_status == "active"]$pop, 3L)
      expect_equal(out[employment_status == "active"]$exits, 3L)
    }
  })

  test_that(paste0("clean (unique) panels raise no warning (", backend, ")"), {
    expect_no_warning(run_decrements(backend, deterministic_panel()))
  })

  test_that(paste0("the deprecated personnel_dt argument still works (", backend, ")"), {
    data <- deterministic_panel()
    if (backend == "duckdb") {
      skip_if_not_installed("duckdb")
      con <- suppressMessages(DBI::dbConnect(duckdb::duckdb()))
      on.exit(DBI::dbDisconnect(con, shutdown = TRUE))
      DBI::dbWriteTable(con, "personnel", as.data.frame(data))
      data <- dplyr::tbl(con, "personnel")
    }
    expect_warning(
      out <- estimate_decrement_rates(
        personnel_dt = data, duration_col = "age", status_col = "employment_status",
        personnel_id_col = "personnel_id", ref_date_col = "ref_date", group_cols = NULL
      ),
      "deprecated"
    )
    out <- data.table::as.data.table(dplyr::collect(out))
    data.table::setorderv(out, c("age", "employment_status"))
    expect_equal(out, run_decrements(backend, deterministic_panel()))
  })
}

test_that("the data.frame and duckdb methods agree on a larger grouped panel", {
  panel <- gapped_panel()
  panel[, gender := rep_len(c("F", "M", NA), .N)]
  expect_equal(
    run_decrements("duckdb", panel, "gender"),
    run_decrements("data.frame", panel, "gender")
  )
})

test_that("duplicates keep a missing status last even where the database sorts it first", {
  skip_if_not_installed("duckdb")
  skip_if_not_installed("dbplyr")
  con <- suppressMessages(DBI::dbConnect(duckdb::duckdb()))
  on.exit(DBI::dbDisconnect(con, shutdown = TRUE))
  DBI::dbExecute(con, "SET default_null_order = 'nulls_first'")

  # P8 is NA and active in 2020: "active" is kept, so P8 is exposed
  panel <- data.table::rbindlist(list(
    make_snap(c("P1", "P8", "P8"), "2020-01-01", 50L, c("active", NA, "active")),
    make_snap(c("P1", "P8"), "2021-01-01", 51L, "active")
  ))
  DBI::dbWriteTable(con, "personnel", as.data.frame(panel))
  expect_warning(
    out <- estimate_decrement_rates(
      dplyr::tbl(con, "personnel"), "age", "employment_status", "personnel_id", "ref_date"
    ),
    "1 duplicate rows"
  )
  out <- dplyr::collect(out)
  expect_equal(out$pop[out$employment_status == "active"], 2L)
})

test_that("data frame input returns a data.table", {
  df <- as.data.frame(deterministic_panel())
  out <- estimate_decrement_rates(df, "age", "employment_status", "personnel_id", "ref_date", NULL)
  expect_s3_class(out, "data.table")
})

test_that("tbl_dbi input returns a lazy table", {
  skip_if_not_installed("duckdb")
  skip_if_not_installed("dbplyr")
  con <- suppressMessages(DBI::dbConnect(duckdb::duckdb()))
  on.exit(DBI::dbDisconnect(con, shutdown = TRUE))
  DBI::dbWriteTable(con, "personnel", as.data.frame(deterministic_panel()))

  out <- estimate_decrement_rates(
    dplyr::tbl(con, "personnel"), "age", "employment_status", "personnel_id", "ref_date", NULL
  )
  expect_s3_class(out, "tbl_lazy")
})

test_that("unsupported input errors naming the argument", {
  expect_error(
    estimate_decrement_rates(list(a = 1), "age", "employment_status", "personnel_id", "ref_date", NULL),
    "`personnel` must be a data frame or a lazy database table"
  )
})

test_that("the caller's data.table is not re-keyed or re-ordered", {
  panel <- deterministic_panel()[c(16:9, 1:8)]
  before <- data.table::copy(panel)
  estimate_decrement_rates(panel, "age", "employment_status", "personnel_id", "ref_date", NULL)
  expect_null(data.table::key(panel))
  expect_equal(panel, before)
})

# ---------------------------------------------------------------------------
# .smooth_rate_curve() -- single-curve graduation
# ---------------------------------------------------------------------------
test_that("a single distinct age is carried forward flat, and left unclipped", {
  # rate = 1.5 is not a valid probability -- this checks the function does
  # NOT clip; clipping is the caller's (smooth_decrement_rates()) job
  out <- .smooth_rate_curve(age = 60L, rate = 1.5, weight = 5, full_ages = 58:62, span = 0.75)
  expect_equal(out, rep(1.5, 5))
})

test_that("2-3 distinct ages fall back to linear interpolation matching stats::approx", {
  expected <- stats::approx(x = c(60, 62), y = c(0.2, 0.4), xout = 58:64, rule = 2)$y
  out <- .smooth_rate_curve(age = c(60, 62), rate = c(0.2, 0.4), weight = c(1, 1),
                            full_ages = 58:64, span = 0.75)
  expect_equal(out, expected)
})

test_that("4+ distinct ages use loess and closely recover a known linear trend", {
  ages <- 50:59
  rates <- 0.01 * ages
  out <- .smooth_rate_curve(age = ages, rate = rates, weight = rep(1, 10),
                            full_ages = ages, span = 0.75)
  expect_equal(out, rates, tolerance = 1e-6)
})

# ---------------------------------------------------------------------------
# smooth_decrement_rates() -- gap-fill + graduate
# ---------------------------------------------------------------------------
test_that("fills a real age gap without changing the observed age range", {
  panel <- gapped_panel()
  raw <- estimate_decrement_rates(panel, "age", "employment_status", "personnel_id", "ref_date", NULL)
  expect_false(62L %in% raw$age)  # confirm the gap actually exists in raw data

  sm <- smooth_decrement_rates(raw, "age", "employment_status", NULL)
  expect_true(62L %in% sm$age)
  expect_equal(range(sm$age), range(raw$age))
  expect_false(any(diff(sort(unique(sm$age))) != 1L))
})

test_that("smoothed rates stay within [0, 1] and sum close to 1 per age/group", {
  panel <- gapped_panel()
  raw <- estimate_decrement_rates(panel, "age", "employment_status", "personnel_id", "ref_date", NULL)
  sm <- smooth_decrement_rates(raw, "age", "employment_status", NULL)

  expect_true(all(sm$decrement_rate >= 0 & sm$decrement_rate <= 1))
  sums <- sm[, .(total = sum(decrement_rate)), by = age]
  expect_true(all(abs(sums$total - 1) < 0.02))
})

test_that("pop, exits, and n_periods are not carried forward into the smoothed output", {
  panel <- gapped_panel()
  raw <- estimate_decrement_rates(panel, "age", "employment_status", "personnel_id", "ref_date", NULL)
  sm <- smooth_decrement_rates(raw, "age", "employment_status", NULL)
  expect_false(any(c("pop", "exits", "n_periods") %in% names(sm)))
})

test_that("group_cols = NULL works (regression: on = group_cols join used to fail with NULL)", {
  panel <- gapped_panel()
  raw <- estimate_decrement_rates(panel, "age", "employment_status", "personnel_id", "ref_date", NULL)
  expect_error(smooth_decrement_rates(raw, "age", "employment_status", NULL), NA)
})

test_that("smooth_decrement_rates() accepts the lazy duckdb output of estimate_decrement_rates()", {
  # the tbl_dbi method of estimate_decrement_rates() returns a lazy table;
  # smoothing (loess) runs in R, so the small pooled table is collected first
  skip_if_not_installed("duckdb")
  skip_if_not_installed("dbplyr")
  con <- suppressMessages(DBI::dbConnect(duckdb::duckdb()))
  on.exit(DBI::dbDisconnect(con, shutdown = TRUE))
  panel <- gapped_panel()
  DBI::dbWriteTable(con, "personnel", as.data.frame(panel))

  lazy <- estimate_decrement_rates(
    dplyr::tbl(con, "personnel"), "age", "employment_status", "personnel_id", "ref_date", NULL
  )
  raw <- estimate_decrement_rates(panel, "age", "employment_status", "personnel_id", "ref_date", NULL)

  from_db <- smooth_decrement_rates(lazy, "age", "employment_status", NULL)
  expect_s3_class(from_db, "data.table")
  expect_equal(from_db, smooth_decrement_rates(raw, "age", "employment_status", NULL))
})

# ---------------------------------------------------------------------------
# compute_service_table() -- age-chaining
# ---------------------------------------------------------------------------
test_that("lx/Lx/Tx/ex chain matches hand-calculated values exactly", {
  st <- compute_service_table(
    deterministic_panel(), "age", "employment_status",
    "personnel_id", "ref_date", group_cols = NULL,
    radix = 100, smooth = FALSE
  )
  expect_equal(st$px, c(0.75, 0.50, 1.00))
  expect_equal(st$lx, c(100, 75, 37.5))
  expect_equal(st$lx_next, c(75, 37.5, 37.5))
  expect_equal(st$Lx, c(87.5, 56.25, 37.5))
  expect_equal(st$Tx, c(181.25, 93.75, 37.5))
  expect_equal(st$ex, c(1.8125, 1.25, 1.0))
})

test_that("compute_service_table() accepts a duckdb table and matches the data frame result", {
  # regression test: estimate_decrement_rates() returns a lazy table for
  # tbl_dbi input, which the life-table chain must collect before using
  skip_if_not_installed("duckdb")
  skip_if_not_installed("dbplyr")
  con <- suppressMessages(DBI::dbConnect(duckdb::duckdb()))
  on.exit(DBI::dbDisconnect(con, shutdown = TRUE))
  DBI::dbWriteTable(con, "personnel", as.data.frame(deterministic_panel()))

  args <- list("age", "employment_status", "personnel_id", "ref_date",
               group_cols = NULL, radix = 100, smooth = FALSE)
  from_db <- do.call(compute_service_table, c(list(dplyr::tbl(con, "personnel")), args))
  from_df <- do.call(compute_service_table, c(list(deterministic_panel()), args))
  expect_equal(from_db, from_df)
})

test_that("compute_service_table(smooth = TRUE) accepts a duckdb table and matches the data frame result", {
  skip_if_not_installed("duckdb")
  skip_if_not_installed("dbplyr")
  con <- suppressMessages(DBI::dbConnect(duckdb::duckdb()))
  on.exit(DBI::dbDisconnect(con, shutdown = TRUE))
  panel <- gapped_panel()
  panel[, gender := "M"]
  DBI::dbWriteTable(con, "personnel", as.data.frame(panel))

  args <- list("age", "employment_status", "personnel_id", "ref_date",
               group_cols = "gender", smooth = TRUE)
  from_db <- do.call(compute_service_table, c(list(dplyr::tbl(con, "personnel")), args))
  from_df <- do.call(compute_service_table, c(list(panel), args))
  expect_s3_class(from_db, "data.table")
  expect_equal(from_db, from_df)
})

test_that("compute_service_table() returns the full life table by default, as a service_table", {
  st <- compute_service_table(
    deterministic_panel(), "age", "employment_status",
    "personnel_id", "ref_date", group_cols = NULL, radix = 100, smooth = FALSE
  )
  expect_named(st, c("age", "pop", "px", "lx", "lx_next", "Lx", "Tx", "ex"))
  expect_s3_class(st, c("service_table", "data.table"))
  expect_equal(attr(st, "duration_col"), "age")
  expect_null(attr(st, "group_cols"))
  # pop: the people active at each age, whose stay rate px rests on
  expect_equal(st$pop, c(4L, 2L, 2L))
})

test_that("include_all = FALSE keeps only age, group_cols, px and ex", {
  full <- compute_service_table(
    deterministic_panel(), "age", "employment_status",
    "personnel_id", "ref_date", group_cols = NULL, radix = 100, smooth = FALSE
  )
  short <- compute_service_table(
    deterministic_panel(), "age", "employment_status",
    "personnel_id", "ref_date", group_cols = NULL, radix = 100, smooth = FALSE,
    include_all = FALSE
  )
  expect_named(short, c("age", "px", "ex"))
  expect_equal(short$px, full$px)
  expect_equal(short$ex, full$ex)

  panel <- deterministic_panel()
  panel[, gender := "M"]
  grouped <- compute_service_table(
    panel, "age", "employment_status", "personnel_id", "ref_date",
    group_cols = "gender", smooth = FALSE, include_all = FALSE
  )
  expect_named(grouped, c("age", "gender", "px", "ex"))
})

test_that("ex is invariant to the choice of radix", {
  st_small <- compute_service_table(
    deterministic_panel(), "age", "employment_status",
    "personnel_id", "ref_date", group_cols = NULL, radix = 100, smooth = FALSE
  )
  st_large <- compute_service_table(
    deterministic_panel(), "age", "employment_status",
    "personnel_id", "ref_date", group_cols = NULL, radix = 100000000, smooth = FALSE
  )
  expect_equal(st_small$ex, st_large$ex)
})

test_that("lx is non-increasing within each group", {
  # gapped_panel() always has an age gap, so the reactive-smoothing warning
  # is expected here and not what this test is checking -- suppress it
  panel <- gapped_panel()
  panel[, gender := "M"]
  st <- suppressWarnings(
    compute_service_table(panel, "age", "employment_status", "personnel_id", "ref_date", "gender")
  )
  expect_true(all(diff(st$lx) <= 1e-8))
})

test_that("no warning is raised when the age sequence has no gaps", {
  n_warn <- 0
  st <- withCallingHandlers(
    compute_service_table(
      deterministic_panel(), "age", "employment_status",
      "personnel_id", "ref_date", group_cols = NULL, smooth = FALSE
    ),
    warning = function(w) { n_warn <<- n_warn + 1; invokeRestart("muffleWarning") }
  )
  expect_equal(n_warn, 0L)
})

test_that("a gap with smooth = FALSE warns AND the returned table is actually gap-filled", {
  # regression test: earlier, the reactive-smoothing branch re-smoothed
  # decrement_dt but never rebuilt survival_dt from it, so the warning fired
  # while the chain silently kept running on the stale, still-gappy table
  panel <- gapped_panel()
  panel[, gender := "M"]

  warnings <- character()
  st <- withCallingHandlers(
    compute_service_table(panel, "age", "employment_status", "personnel_id", "ref_date", "gender"),
    warning = function(w) {
      warnings <<- c(warnings, conditionMessage(w))
      invokeRestart("muffleWarning")
    }
  )
  expect_length(warnings, 1L)
  expect_match(warnings, "smoothed to fill the gap; set smooth = TRUE")
  expect_no_match(warnings, "\n")
  expect_false(any(diff(st$age) != 1L))
  expect_false(anyNA(st$lx))
  expect_false(anyNA(st$ex))
})

test_that("an age everyone leaves ends the chain: ex is NA after it, with a warning naming the group", {
  # both people active at 51 retire, so px = 0 at 51 and no one is left at
  # 52: ex there is 0 / 0, which is reported as NA rather than NaN
  panel <- deterministic_panel()
  panel[personnel_id == "P6" & ref_date == as.Date("2021-01-01"), employment_status := "pensioner"]
  panel[, gender := "M"]

  expect_warning(
    st <- compute_service_table(
      panel, "age", "employment_status", "personnel_id", "ref_date",
      group_cols = "gender", radix = 100
    ),
    "gender = M \\(from age 52\\)"
  )
  expect_equal(st$px, c(0.75, 0, 1))
  expect_equal(st$lx, c(100, 75, 0))
  expect_equal(st$ex, c(1.25, 0.5, NA))

  expect_warning(
    compute_service_table(
      panel, "age", "employment_status", "personnel_id", "ref_date", group_cols = NULL
    ),
    "the table \\(from age 52\\)"
  )

  # with smoothing already on, the warning does not suggest it
  msg <- tryCatch(
    compute_service_table(panel, "age", smooth = TRUE),
    warning = conditionMessage
  )
  expect_match(msg, "from age 52")
  expect_no_match(msg, "smooth = TRUE")
})

test_that("compute_service_table() is a generic with data.frame, tbl_dbi and default methods", {
  for (cls in c("data.frame", "tbl_dbi", "default")) {
    expect_false(is.null(utils::getS3method("compute_service_table", cls, optional = TRUE)), info = cls)
  }
  expect_error(
    compute_service_table(list(a = 1), "age"),
    "`personnel` must be a data frame or a lazy database table"
  )
})

test_that("duration_col is required; the other column arguments have defaults", {
  expect_error(compute_service_table(deterministic_panel()), "duration_col")
  expect_equal(
    compute_service_table(deterministic_panel(), "age"),
    compute_service_table(
      deterministic_panel(), "age", "employment_status", "personnel_id", "ref_date",
      group_cols = NULL
    )
  )
})

test_that("radix, smooth and span come through ..., and a misspelt one errors", {
  st <- compute_service_table(deterministic_panel(), "age", radix = 100)
  expect_equal(st$lx, c(100, 75, 37.5))
  expect_error(compute_service_table(deterministic_panel(), "age", smoth = TRUE), "smoth")
})

test_that("any precomputed duration works: tenure, by hand", {
  # tenure 0: P1/2020, P2/2020 and P4/2021 at risk, P2 leaves (px 2/3);
  # tenure 1: P3/2020 retires, P1/2021 stays (px 1/2)
  panel <- data.table::data.table(
    personnel_id = c("P1", "P2", "P3", "P1", "P3", "P4", "P1", "P4"),
    ref_date = as.Date(rep(c("2020-01-01", "2021-01-01", "2022-01-01"), c(3, 3, 2))),
    employment_status = c("active", "active", "active", "active", "pensioner",
                          "active", "active", "active"),
    tenure = c(0, 0, 1, 1, 2, 0, 2, 1)
  )
  st <- compute_service_table(panel, "tenure", radix = 100)
  expect_equal(st$tenure, 0:1)
  expect_equal(st$px, c(2 / 3, 1 / 2))
  expect_equal(st$lx, c(100, 200 / 3))
  expect_equal(st$Tx, c((100 + 200 / 3) / 2 + (200 / 3 + 100 / 3) / 2, 50))
  expect_equal(st$ex, c(400 / 300, 0.75))
})

test_that("a missing duration is left out with a warning", {
  # P9 is active in both years with no age: left out, with a warning, and
  # the table is that of the panel without P9
  panel <- data.table::rbindlist(list(
    deterministic_panel(),
    make_snap("P9", c("2020-01-01", "2021-01-01"), NA_integer_, "active")
  ))
  expect_warning(
    st <- compute_service_table(panel, "age", radix = 100),
    "1 active person-snapshot.*no `age`"
  )
  expect_equal(st, compute_service_table(deterministic_panel(), "age", radix = 100))
})

test_that("pop is NA at an age filled in by smoothing", {
  panel <- gapped_panel()
  st <- compute_service_table(panel, "age", smooth = TRUE)
  expect_true(is.na(st[age == 62]$pop))
  expect_false(anyNA(st[age != 62]$pop))
})

test_that("smooth = TRUE up front avoids the reactive warning even with a gap", {
  panel <- gapped_panel()
  panel[, gender := "M"]

  n_warn <- 0
  st <- withCallingHandlers(
    compute_service_table(panel, "age", "employment_status", "personnel_id", "ref_date", "gender", smooth = TRUE),
    warning = function(w) { n_warn <<- n_warn + 1; invokeRestart("muffleWarning") }
  )
  expect_equal(n_warn, 0L)
  expect_false(any(diff(st$age) != 1L))
})

test_that("group_cols = NULL with a gap works end to end (regression: user's original failing call)", {
  # the gap triggers the (expected) reactive-smoothing warning; this test is
  # only checking that it no longer errors, so the warning is suppressed
  panel <- gapped_panel()
  expect_error(
    suppressWarnings(
      compute_service_table(panel, "age", "employment_status", "personnel_id", "ref_date", group_cols = NULL)
    ),
    NA
  )
})

# ---------------------------------------------------------------------------
# plot.service_table()
# ---------------------------------------------------------------------------
test_that("plot() draws ex by duration, one line per group, with dots sized by pop", {
  withr::local_pdf(tempfile(fileext = ".pdf"))
  panel <- gapped_panel()
  panel[, gender := fifelse(as.integer(sub("P", "", personnel_id)) %% 2L == 0L, "F", "M")]
  st <- compute_service_table(panel, "age", group_cols = "gender", smooth = TRUE)

  p <- plot(st)
  expect_s3_class(p, "ggplot")
  built <- ggplot2::ggplot_build(p)
  expect_length(built$data, 2L)                       # line and dots
  expect_equal(p$labels$x, "age")
  expect_setequal(unique(as.character(p$data$group)), c("F", "M"))

  expect_length(ggplot2::ggplot_build(plot(st, show_n = FALSE))$data, 1L)
})

test_that("plot() works without pop (include_all = FALSE), drawing the line only", {
  withr::local_pdf(tempfile(fileext = ".pdf"))
  st <- compute_service_table(deterministic_panel(), "age", include_all = FALSE)
  p <- plot(st)
  expect_s3_class(p, "ggplot")
  expect_length(ggplot2::ggplot_build(p)$data, 1L)
})
