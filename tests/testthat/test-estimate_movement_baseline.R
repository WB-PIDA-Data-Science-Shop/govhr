library(testthat)
library(data.table)

# ---------------------------------------------------------------------------
# Helper: build a minimal panel data.table
#   personnel_id | ref_date | group (paygrade) | start_date | end_date | contract_type_code
# ---------------------------------------------------------------------------
make_panel <- function(personnel_id,
                       ref_date,
                       paygrade,
                       start_date  = "2010-01-01",
                       end_date    = NA_character_,
                       ctype       = "permanent") {
  data.table::data.table(
    personnel_id  = personnel_id,
    ref_date      = as.Date(ref_date),
    paygrade      = paygrade,
    start_date    = as.Date(start_date),
    end_date      = as.Date(end_date),
    contract_type = ctype
  )
}

# A minimal two-snapshot panel where P1 moves G1 → G2
two_snap_mover <- function() {
  data.table::rbindlist(list(
    make_panel("P1", "2015-01-01", "G1"),
    make_panel("P2", "2015-01-01", "G2"),
    make_panel("P1", "2016-01-01", "G2"),  # P1 moved
    make_panel("P2", "2016-01-01", "G2")   # P2 stayed
  ))
}

# ---------------------------------------------------------------------------
# estimate_movement_rates — input validation
# ---------------------------------------------------------------------------
test_that("non-data.table input raises error", {
  df <- as.data.frame(two_snap_mover())
  expect_error(
    estimate_movement_rates(df, group_cols = "paygrade"),
    "data.table"
  )
})

test_that("missing group_cols raises error", {
  dt <- two_snap_mover()
  expect_error(
    estimate_movement_rates(dt, group_cols = character(0)),
    "group_cols"
  )
})

test_that("missing columns raises error", {
  dt <- two_snap_mover()
  expect_error(
    estimate_movement_rates(dt, group_cols = "nonexistent_col"),
    "not found"
  )
})

test_that("fewer than 2 snapshots raises error", {
  dt <- make_panel("P1", "2015-01-01", "G1")
  expect_error(
    estimate_movement_rates(dt, group_cols = "paygrade"),
    "2 panel snapshots"
  )
})

# ---------------------------------------------------------------------------
# estimate_movement_rates — output structure
# ---------------------------------------------------------------------------
test_that("output has expected columns", {
  out <- estimate_movement_rates(two_snap_mover(), group_cols = "paygrade")
  expect_named(out, c("from_group", "to_group", "movement_rate", "from_period", "to_period", "n_pop", "n_moves"))
})

test_that("output is a data.table", {
  out <- estimate_movement_rates(two_snap_mover(), group_cols = "paygrade")
  expect_s3_class(out, "data.table")
})

# ---------------------------------------------------------------------------
# estimate_movement_rates — correctness
# ---------------------------------------------------------------------------
test_that("one mover out of two: movement_rate is 1.0 for G1 -> G2 (P1 is sole G1 occupant)", {
  out <- estimate_movement_rates(two_snap_mover(), group_cols = "paygrade")
  row <- out[from_group == "G1" & to_group == "G2"]
  expect_equal(nrow(row), 1L)
  # P1 is the only person at G1 at T0 and moves to G2 → rate = 1/1 = 1.0
  expect_equal(row$movement_rate, 1.0)
})

test_that("stay rows (from_group == to_group) are excluded", {
  out <- estimate_movement_rates(two_snap_mover(), group_cols = "paygrade")
  expect_true(all(out$from_group != out$to_group))
})

test_that("from_period and to_period are Date columns", {
  out <- estimate_movement_rates(two_snap_mover(), group_cols = "paygrade")
  expect_s3_class(out$from_period, "Date")
  expect_s3_class(out$to_period,   "Date")
})

test_that("from_period < to_period for all rows", {
  out <- estimate_movement_rates(two_snap_mover(), group_cols = "paygrade")
  expect_true(all(out$from_period < out$to_period))
})

test_that("three snapshots: movement rates and period columns are correct", {
  # P1: G1 → G2 → G1 across three snapshots
  # P2: G2 → G2 → G2 (stays)
  dt <- data.table::rbindlist(list(
    make_panel("P1", "2015-01-01", "G1"),
    make_panel("P2", "2015-01-01", "G2"),
    make_panel("P1", "2016-01-01", "G2"),
    make_panel("P2", "2016-01-01", "G2"),
    make_panel("P1", "2017-01-01", "G1"),
    make_panel("P2", "2017-01-01", "G2")
  ))
  out <- estimate_movement_rates(dt, group_cols = "paygrade")
  # G1->G2 occurs in period 2015->2016 only
  g1_g2 <- out[from_group == "G1" & to_group == "G2"]
  expect_equal(nrow(g1_g2), 1L)
  expect_equal(g1_g2$movement_rate, 1.0)
  expect_equal(g1_g2$from_period, as.Date("2015-01-01"))
  expect_equal(g1_g2$to_period,   as.Date("2016-01-01"))
  # G2->G1 occurs in period 2016->2017 only
  g2_g1 <- out[from_group == "G2" & to_group == "G1"]
  expect_equal(nrow(g2_g1), 1L)
  expect_equal(g2_g1$movement_rate, 0.5)  # P1 out of {P1, P2} at G2
  expect_equal(g2_g1$from_period, as.Date("2016-01-01"))
  expect_equal(g2_g1$to_period,   as.Date("2017-01-01"))
})

test_that("NA in group col rows are excluded and do not appear in output", {
  dt <- data.table::rbindlist(list(
    make_panel("P1", "2015-01-01", NA_character_),  # NA group → dropped
    make_panel("P2", "2015-01-01", "G2"),
    make_panel("P1", "2016-01-01", "G1"),
    make_panel("P2", "2016-01-01", "G2")
  ))
  out <- estimate_movement_rates(dt, group_cols = "paygrade")
  expect_true(!any(is.na(out$from_group)))
  expect_true(!any(is.na(out$to_group)))
  expect_true(!any(out$from_group == "NA"))
  expect_true(!any(out$to_group  == "NA"))
})

test_that("all persons stay → output is empty (no actual transitions)", {
  dt <- data.table::rbindlist(list(
    make_panel("P1", "2015-01-01", "G1"),
    make_panel("P2", "2015-01-01", "G2"),
    make_panel("P1", "2016-01-01", "G1"),
    make_panel("P2", "2016-01-01", "G2")
  ))
  out <- estimate_movement_rates(dt, group_cols = "paygrade")
  expect_equal(nrow(out), 0L)
})

test_that("person exits at T1: not counted as a transition", {
  # P1 exits (absent at T1), P2 stays
  dt <- data.table::rbindlist(list(
    make_panel("P1", "2015-01-01", "G1"),
    make_panel("P2", "2015-01-01", "G2"),
    make_panel("P2", "2016-01-01", "G2")   # P1 not present at T1
  ))
  out <- estimate_movement_rates(dt, group_cols = "paygrade")
  # No actual movers
  expect_equal(nrow(out), 0L)
})

test_that("person enters at T1: not counted (no T0 state)", {
  # P2 enters at T1, P1 stays
  dt <- data.table::rbindlist(list(
    make_panel("P1", "2015-01-01", "G1"),
    make_panel("P1", "2016-01-01", "G1"),
    make_panel("P2", "2016-01-01", "G2")   # new entrant at T1
  ))
  out <- estimate_movement_rates(dt, group_cols = "paygrade")
  expect_equal(nrow(out), 0L)
})

test_that("multi-column group_cols concatenated with ||", {
  dt <- data.table::rbindlist(list(
    make_panel("P1", "2015-01-01", "G1"),
    make_panel("P2", "2015-01-01", "G2"),
    make_panel("P1", "2016-01-01", "G2"),
    make_panel("P2", "2016-01-01", "G2")
  ))
  dt[, est_id := ifelse(ref_date == as.Date("2015-01-01"), "E1", "E1")]
  out <- estimate_movement_rates(dt, group_cols = c("est_id", "paygrade"))
  # Groups should be "E1||G1", "E1||G2" etc.
  expect_true(all(grepl("\\|\\|", out$from_group)))
})

test_that("inactive contracts at snapshot are excluded from active pool", {
  dt <- data.table::rbindlist(list(
    make_panel("P1", "2015-01-01", "G1", ctype = "inactive"),
    make_panel("P2", "2015-01-01", "G2"),
    make_panel("P1", "2016-01-01", "G2"),
    make_panel("P2", "2016-01-01", "G2")
  ))
  out <- estimate_movement_rates(dt, group_cols = "paygrade")
  # P1 inactive at T0 → not in active pool → no G1 transitions
  expect_equal(nrow(out[from_group == "G1"]), 0L)
})

# ---------------------------------------------------------------------------
# roll_snapshot_pairs — standalone tests
# ---------------------------------------------------------------------------
test_that("roll_snapshot_pairs errors on non-data.table", {
  df <- data.frame(ref_date = as.Date("2015-01-01"), x = 1)
  expect_error(roll_snapshot_pairs(df, "ref_date", identity), "data.table")
})

test_that("roll_snapshot_pairs errors when date_col missing", {
  dt <- data.table::data.table(x = 1)
  expect_error(roll_snapshot_pairs(dt, "ref_date", identity), "not found")
})

test_that("roll_snapshot_pairs returns empty data.table for single snapshot", {
  dt <- data.table::data.table(ref_date = as.Date("2015-01-01"), x = 1)
  out <- roll_snapshot_pairs(dt, "ref_date", function(a, b) data.table(n = 1))
  expect_s3_class(out, "data.table")
  expect_equal(nrow(out), 0L)
})

test_that("roll_snapshot_pairs calls f once per consecutive pair", {
  dt <- data.table::data.table(
    ref_date = as.Date(c("2015-01-01", "2015-01-01",
                         "2016-01-01", "2016-01-01",
                         "2017-01-01", "2017-01-01")),
    x = 1:6
  )
  call_count <- 0L
  counter_fn <- function(a, b) { call_count <<- call_count + 1L; NULL }
  roll_snapshot_pairs(dt, "ref_date", counter_fn)
  # 3 snapshots → 2 pairs
  expect_equal(call_count, 2L)
})

test_that("roll_snapshot_pairs skips NULL returns from f", {
  dt <- data.table::data.table(
    ref_date = as.Date(c("2015-01-01", "2016-01-01")),
    x = 1:2
  )
  out <- roll_snapshot_pairs(dt, "ref_date", function(a, b) NULL)
  expect_s3_class(out, "data.table")
  expect_equal(nrow(out), 0L)
})

test_that("roll_snapshot_pairs rbinds all non-NULL results", {
  dt <- data.table::data.table(
    ref_date = as.Date(c("2015-01-01", "2016-01-01", "2017-01-01")),
    x = 1:3
  )
  f <- function(a, b) data.table(pair = paste(a$x, b$x, sep = "->"))
  out <- roll_snapshot_pairs(dt, "ref_date", f)
  expect_equal(nrow(out), 2L)
  expect_equal(sort(out$pair), c("1->2", "2->3"))
})


# ---------------------------------------------------------------------------
# Helper: panel with salary column
# ---------------------------------------------------------------------------
make_panel_sal <- function(personnel_id,
                           ref_date,
                           paygrade,
                           salary,
                           start_date = "2010-01-01",
                           end_date   = NA_character_,
                           ctype      = "permanent") {
  data.table::data.table(
    personnel_id  = personnel_id,
    ref_date      = as.Date(ref_date),
    paygrade      = paygrade,
    salary        = salary,
    start_date    = as.Date(start_date),
    end_date      = as.Date(end_date),
    contract_type = ctype
  )
}

# One mover (P1: G1→G2, salary 1000→1200), one stayer (P2: G2, salary 2000→2000)
two_snap_salary <- function() {
  data.table::rbindlist(list(
    make_panel_sal("P1", "2015-01-01", "G1", salary = 1000),
    make_panel_sal("P2", "2015-01-01", "G2", salary = 2000),
    make_panel_sal("P1", "2016-01-01", "G2", salary = 1200),
    make_panel_sal("P2", "2016-01-01", "G2", salary = 2000)
  ))
}

# ---------------------------------------------------------------------------
# salary_col — output structure
# ---------------------------------------------------------------------------
test_that("salary_col: output contains all expected columns", {
  out <- estimate_movement_rates(two_snap_salary(), group_cols = "paygrade",
                                 salary_col = "salary")
  expected_cols <- c("from_group", "to_group", "movement_rate",
                     "from_period", "to_period", "n_pop", "n_moves",
                     "mean_salary_t0", "mean_salary_t1",
                     "mean_salary_change", "median_salary_change",
                     "mean_salary_pct_change")
  expect_named(out, expected_cols, ignore.order = TRUE)
})

test_that("salary_col = NULL: salary columns are absent from output", {
  out <- estimate_movement_rates(two_snap_salary(), group_cols = "paygrade",
                                 salary_col = NULL)
  salary_cols <- c("mean_salary_t0", "mean_salary_t1", "mean_salary_change",
                   "median_salary_change", "mean_salary_pct_change")
  expect_false(any(salary_cols %in% names(out)))
})

test_that("salary_col not in data raises error", {
  dt <- two_snap_mover()  # no salary column
  expect_error(
    estimate_movement_rates(dt, group_cols = "paygrade", salary_col = "salary"),
    "salary_col"
  )
})

# ---------------------------------------------------------------------------
# salary_col — arithmetic correctness (single mover)
# ---------------------------------------------------------------------------
test_that("salary: mean_salary_t0 reflects T0 salary of mover only", {
  # P1 is the sole mover from G1. P2 stays at G2.
  # mean_salary_t0 for G1->G2 should be P1's T0 salary = 1000
  out <- estimate_movement_rates(two_snap_salary(), group_cols = "paygrade",
                                 salary_col = "salary")
  row <- out[from_group == "G1" & to_group == "G2"]
  expect_equal(row$mean_salary_t0, 1000)
})

test_that("salary: mean_salary_t1 reflects T1 salary of mover only", {
  # P1 moves to G2 with salary 1200 at T1
  out <- estimate_movement_rates(two_snap_salary(), group_cols = "paygrade",
                                 salary_col = "salary")
  row <- out[from_group == "G1" & to_group == "G2"]
  expect_equal(row$mean_salary_t1, 1200)
})

test_that("salary: mean_salary_change = T1 - T0 for mover", {
  out <- estimate_movement_rates(two_snap_salary(), group_cols = "paygrade",
                                 salary_col = "salary")
  row <- out[from_group == "G1" & to_group == "G2"]
  expect_equal(row$mean_salary_change, 200)
})

test_that("salary: median_salary_change = T1 - T0 for single mover", {
  out <- estimate_movement_rates(two_snap_salary(), group_cols = "paygrade",
                                 salary_col = "salary")
  row <- out[from_group == "G1" & to_group == "G2"]
  expect_equal(row$median_salary_change, 200)
})

test_that("salary: mean_salary_pct_change = (T1 - T0) / T0 for mover", {
  # (1200 - 1000) / 1000 = 0.2
  out <- estimate_movement_rates(two_snap_salary(), group_cols = "paygrade",
                                 salary_col = "salary")
  row <- out[from_group == "G1" & to_group == "G2"]
  expect_equal(row$mean_salary_pct_change, 0.2)
})

# ---------------------------------------------------------------------------
# salary_col — computed over movers only, not full T0 population
# ---------------------------------------------------------------------------
test_that("salary: stats reflect movers only, not full T0 from_group population", {
  # P1 and P3 are both in G1 at T0. Only P1 moves to G2. P3 stays at G1.
  # mean_salary_t0 for G1->G2 should be 1000 (P1 only), NOT mean(1000, 3000)
  dt <- data.table::rbindlist(list(
    make_panel_sal("P1", "2015-01-01", "G1", salary = 1000),
    make_panel_sal("P3", "2015-01-01", "G1", salary = 3000),  # stayer, should not affect salary stats
    make_panel_sal("P2", "2015-01-01", "G2", salary = 2000),
    make_panel_sal("P1", "2016-01-01", "G2", salary = 1200),  # P1 moved
    make_panel_sal("P3", "2016-01-01", "G1", salary = 3000),  # P3 stayed
    make_panel_sal("P2", "2016-01-01", "G2", salary = 2000)
  ))
  out <- estimate_movement_rates(dt, group_cols = "paygrade", salary_col = "salary")
  row <- out[from_group == "G1" & to_group == "G2"]
  # Only P1 is a mover → mean_salary_t0 should be 1000, not (1000+3000)/2 = 2000
  expect_equal(row$mean_salary_t0, 1000)
})

# ---------------------------------------------------------------------------
# salary_col — multiple movers, aggregation correctness
# ---------------------------------------------------------------------------
test_that("salary: mean and median computed correctly across multiple movers", {
  # P1: G1→G2, salary 1000→1200, change = +200, pct = 0.20
  # P3: G1→G2, salary 2000→2200, change = +200, pct = 0.10
  # mean_salary_t0        = (1000 + 2000) / 2 = 1500
  # mean_salary_t1        = (1200 + 2200) / 2 = 1700
  # mean_salary_change    = (200 + 200) / 2   = 200
  # median_salary_change  = median(200, 200)   = 200
  # mean_salary_pct_change= (0.20 + 0.10) / 2 = 0.15
  dt <- data.table::rbindlist(list(
    make_panel_sal("P1", "2015-01-01", "G1", salary = 1000),
    make_panel_sal("P3", "2015-01-01", "G1", salary = 2000),
    make_panel_sal("P2", "2015-01-01", "G2", salary = 5000),
    make_panel_sal("P1", "2016-01-01", "G2", salary = 1200),
    make_panel_sal("P3", "2016-01-01", "G2", salary = 2200),
    make_panel_sal("P2", "2016-01-01", "G2", salary = 5000)
  ))
  out <- estimate_movement_rates(dt, group_cols = "paygrade", salary_col = "salary")
  row <- out[from_group == "G1" & to_group == "G2"]
  expect_equal(row$mean_salary_t0,         1500)
  expect_equal(row$mean_salary_t1,         1700)
  expect_equal(row$mean_salary_change,      200)
  expect_equal(row$median_salary_change,    200)
  expect_equal(row$mean_salary_pct_change,  0.15)
})

test_that("salary: asymmetric pct changes aggregated correctly", {
  # P1: G1→G2, salary 1000→1500, change = +500, pct = 0.50
  # P3: G1→G2, salary 4000→4400, change = +400, pct = 0.10
  # mean_salary_pct_change = (0.50 + 0.10) / 2 = 0.30
  # median_salary_change   = median(500, 400)   = 450
  dt <- data.table::rbindlist(list(
    make_panel_sal("P1", "2015-01-01", "G1", salary = 1000),
    make_panel_sal("P3", "2015-01-01", "G1", salary = 4000),
    make_panel_sal("P2", "2015-01-01", "G2", salary = 9000),
    make_panel_sal("P1", "2016-01-01", "G2", salary = 1500),
    make_panel_sal("P3", "2016-01-01", "G2", salary = 4400),
    make_panel_sal("P2", "2016-01-01", "G2", salary = 9000)
  ))
  out <- estimate_movement_rates(dt, group_cols = "paygrade", salary_col = "salary")
  row <- out[from_group == "G1" & to_group == "G2"]
  expect_equal(row$mean_salary_pct_change, 0.30)
  expect_equal(row$median_salary_change,   450)
})

# ---------------------------------------------------------------------------
# salary_col — multi-contract summation within person-group
# ---------------------------------------------------------------------------
test_that("salary: multi-contract person has salary summed before state construction", {
  # P1 has two active contracts at T0 in G1 (salary 600 + 400 = 1000 effective)
  # P1 moves to G2 at T1 with salary 1200
  dt <- data.table::rbindlist(list(
    make_panel_sal("P1", "2015-01-01", "G1", salary = 600),
    make_panel_sal("P1", "2015-01-01", "G1", salary = 400),  # second contract, same person/group/date
    make_panel_sal("P2", "2015-01-01", "G2", salary = 2000),
    make_panel_sal("P1", "2016-01-01", "G2", salary = 1200),
    make_panel_sal("P2", "2016-01-01", "G2", salary = 2000)
  ))
  out <- estimate_movement_rates(dt, group_cols = "paygrade", salary_col = "salary")
  row <- out[from_group == "G1" & to_group == "G2"]
  # sum of P1's T0 contracts = 1000; mean over one mover = 1000
  expect_equal(row$mean_salary_t0, 1000)
  expect_equal(row$mean_salary_change, 200)
})

# ---------------------------------------------------------------------------
# salary_col — exiting persons do not contribute to salary stats
# ---------------------------------------------------------------------------
test_that("salary: person who exits at T1 does not appear in salary calculations", {
  # P1 exits (not at T1), P2 moves G1→G2
  # salary stats should reflect P2 only
  dt <- data.table::rbindlist(list(
    make_panel_sal("P1", "2015-01-01", "G1", salary = 9999),  # exits — should not affect stats
    make_panel_sal("P2", "2015-01-01", "G1", salary = 1000),
    make_panel_sal("P3", "2015-01-01", "G2", salary = 5000),
    make_panel_sal("P2", "2016-01-01", "G2", salary = 1200),  # P2 moved; P1 absent
    make_panel_sal("P3", "2016-01-01", "G2", salary = 5000)
  ))
  out <- estimate_movement_rates(dt, group_cols = "paygrade", salary_col = "salary")
  row <- out[from_group == "G1" & to_group == "G2"]
  # Only P2 is a mover; P1 exits before T1 and should not factor into salary
  expect_equal(row$mean_salary_t0, 1000)
  expect_equal(row$n_moves, 1L)
})
