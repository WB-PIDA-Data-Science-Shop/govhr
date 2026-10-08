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

# t0/t1 pair used across the .compute_decrement_pair() bug-regression tests:
#   P1, P2: active at 60 -> P1 retires, P2 stays active
#   P3: ALREADY a pensioner at t0 (age 65) and remains one at t1 -- must never
#       contribute to exposure or exits (the persistent-pensioner bug)
#   P4: active at 30 -> drops out of the panel entirely by t1 (non-retirement-exit)
#   P5: active at 45 -> explicit "deceased" status at t1 (agnostic-vocabulary check)
decrement_pair_snaps <- function() {
  snap_t0 <- make_snap(
    c("P1", "P2", "P3", "P4", "P5"),
    "2020-01-01",
    c(60L, 60L, 65L, 30L, 45L),
    c("active", "active", "pensioner", "active", "active"),
    gender = c("M", "M", "M", "F", "M")
  )
  snap_t1 <- make_snap(
    c("P1", "P2", "P3", "P5"),
    "2021-01-01",
    c(61L, 61L, 66L, 46L),
    c("pensioner", "active", "pensioner", "deceased"),
    gender = c("M", "M", "M", "M")
  )
  list(snap_t0 = snap_t0, snap_t1 = snap_t1)
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
# .compute_decrement_pair() -- single snapshot-pair workhorse
# ---------------------------------------------------------------------------
test_that("basic exposure/exit counts and rates are correct", {
  snaps <- decrement_pair_snaps()
  out <- .compute_decrement_pair(
    snaps$snap_t0, snaps$snap_t1,
    age_col = "age", status_col = "employment_status",
    personnel_id_col = "personnel_id", ref_date_col = "ref_date",
    group_cols = "gender"
  )
  row_60_pensioner <- out[age == 60 & gender == "M" & employment_status == "pensioner"]
  expect_equal(row_60_pensioner$pop, 2L)
  expect_equal(row_60_pensioner$exits, 1L)
  expect_equal(row_60_pensioner$decrement_rate, 0.5)
})

test_that("someone already a pensioner at t0 is excluded from exposure entirely (no rate > 1)", {
  # regression test: P3 (age 65, already pensioner at t0) must never inflate
  # any age bucket's exits, and age 65 should not appear in the output at all
  # since nobody was ACTIVE at age 65 in this panel
  snaps <- decrement_pair_snaps()
  out <- .compute_decrement_pair(
    snaps$snap_t0, snaps$snap_t1,
    age_col = "age", status_col = "employment_status",
    personnel_id_col = "personnel_id", ref_date_col = "ref_date",
    group_cols = "gender"
  )
  expect_true(all(out$decrement_rate <= 1))
  expect_false(65L %in% out$age)
})

test_that("a non-retirement-exit is attributed to the person's own t0 age, not shifted", {
  # regression test: P4 (active, age 30 at t0) drops out of the panel by t1.
  # must be counted at age 30, never age 29 (the old hardcoded age-1 shift)
  snaps <- decrement_pair_snaps()
  out <- .compute_decrement_pair(
    snaps$snap_t0, snaps$snap_t1,
    age_col = "age", status_col = "employment_status",
    personnel_id_col = "personnel_id", ref_date_col = "ref_date",
    group_cols = "gender"
  )
  row <- out[age == 30 & gender == "F" & employment_status == "non-retirement-exit"]
  expect_equal(nrow(row), 1L)
  expect_equal(row$exits, 1L)
  expect_false(29L %in% out$age)
})

test_that("outcome vocabulary is derived from the data, not hardcoded", {
  # P5 has an explicit "deceased" status at t1 -- never special-cased anywhere
  # in the implementation, so this only works if the vocabulary is data-driven
  snaps <- decrement_pair_snaps()
  out <- .compute_decrement_pair(
    snaps$snap_t0, snaps$snap_t1,
    age_col = "age", status_col = "employment_status",
    personnel_id_col = "personnel_id", ref_date_col = "ref_date",
    group_cols = "gender"
  )
  expect_true("deceased" %in% out$employment_status)
  row <- out[age == 45 & gender == "M" & employment_status == "deceased"]
  expect_equal(row$exits, 1L)
})

test_that("every exposed age/group reports all outcome types with explicit zeros, never NA status", {
  snaps <- decrement_pair_snaps()
  out <- .compute_decrement_pair(
    snaps$snap_t0, snaps$snap_t1,
    age_col = "age", status_col = "employment_status",
    personnel_id_col = "personnel_id", ref_date_col = "ref_date",
    group_cols = "gender"
  )
  expect_false(anyNA(out$employment_status))
  expect_true(all(out$exits >= 0L))
  # every age/group present has a row for every outcome type observed anywhere
  n_types <- data.table::uniqueN(out$employment_status)
  counts <- out[, .N, by = .(age, gender)]
  expect_true(all(counts$N == n_types))
})

test_that("outcome rates sum to exactly 1 for every age/group", {
  snaps <- decrement_pair_snaps()
  out <- .compute_decrement_pair(
    snaps$snap_t0, snaps$snap_t1,
    age_col = "age", status_col = "employment_status",
    personnel_id_col = "personnel_id", ref_date_col = "ref_date",
    group_cols = "gender"
  )
  sums <- out[, .(total = sum(decrement_rate)), by = .(age, gender)]
  expect_equal(sums$total, rep(1, nrow(sums)))
})

test_that("t0_date and t1_date are attached correctly", {
  snaps <- decrement_pair_snaps()
  out <- .compute_decrement_pair(
    snaps$snap_t0, snaps$snap_t1,
    age_col = "age", status_col = "employment_status",
    personnel_id_col = "personnel_id", ref_date_col = "ref_date",
    group_cols = "gender"
  )
  expect_true(all(out$t0_date == as.Date("2020-01-01")))
  expect_true(all(out$t1_date == as.Date("2021-01-01")))
})

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
    out <- run_decrements(backend, decrement_pair_snaps() |> data.table::rbindlist(), "gender")
    expect_named(
      out,
      c("age", "gender", "employment_status", "pop", "exits", "n_periods", "decrement_rate")
    )
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
        personnel_dt = data, age_col = "age", status_col = "employment_status",
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

test_that("pooled output over one pair matches .compute_decrement_pair()", {
  snaps <- decrement_pair_snaps()
  pair <- .compute_decrement_pair(
    snaps$snap_t0, snaps$snap_t1,
    age_col = "age", status_col = "employment_status",
    personnel_id_col = "personnel_id", ref_date_col = "ref_date",
    group_cols = "gender"
  )
  out <- estimate_decrement_rates(
    rbind(snaps$snap_t0, snaps$snap_t1),
    "age", "employment_status", "personnel_id", "ref_date", "gender"
  )
  key <- c("age", "gender", "employment_status")
  data.table::setorderv(pair, key)
  expect_equal(out[, .(age, gender, employment_status, pop, exits, decrement_rate)],
               pair[, .(age, gender, employment_status, pop, exits, decrement_rate)])
  expect_true(all(out$n_periods == 1L))
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

test_that("compute_service_table() returns the full life table by default", {
  st <- compute_service_table(
    deterministic_panel(), "age", "employment_status",
    "personnel_id", "ref_date", group_cols = NULL, radix = 100, smooth = FALSE
  )
  expect_named(st, c("age", "px", "lx", "lx_next", "Lx", "Tx", "ex"))
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
  expect_equal(short, full[, .(age, px, ex)])

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

  n_warn <- 0
  st <- withCallingHandlers(
    compute_service_table(panel, "age", "employment_status", "personnel_id", "ref_date", "gender"),
    warning = function(w) { n_warn <<- n_warn + 1; invokeRestart("muffleWarning") }
  )
  expect_equal(n_warn, 1L)
  expect_false(any(diff(st$age) != 1L))
  expect_false(anyNA(st$lx))
  expect_false(anyNA(st$ex))
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
