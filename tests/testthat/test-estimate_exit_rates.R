library(testthat)
library(data.table)

# ---------------------------------------------------------------------------
# Helpers
# ---------------------------------------------------------------------------

# Minimal personnel panel — two snapshots, with one "fire" event detectable
# between them (person P2 disappears at T1).
make_personnel <- function() {
  data.table::rbindlist(list(
    data.table(personnel_id = "P1", ref_date = as.Date("2015-09-01"), employment_status = "active"),
    data.table(personnel_id = "P2", ref_date = as.Date("2015-09-01"), employment_status = "active"),
    data.table(personnel_id = "P1", ref_date = as.Date("2016-09-01"), employment_status = "active")
    # P2 absent at T1 → detected as fire event
  ))
}

make_contract <- function(est_id = "E1") {
  data.table::rbindlist(list(
    data.table(
      personnel_id       = "P1",
      ref_date           = as.Date("2015-09-01"),
      est_id             = est_id,
      contract_type      = "permanent",
      start_date         = as.Date("2010-01-01"),
      end_date           = NA_real_
    ),
    data.table(
      personnel_id       = "P2",
      ref_date           = as.Date("2015-09-01"),
      est_id             = est_id,
      contract_type      = "permanent",
      start_date         = as.Date("2010-01-01"),
      end_date           = NA_real_
    ),
    data.table(
      personnel_id       = "P1",
      ref_date           = as.Date("2016-09-01"),
      est_id             = est_id,
      contract_type      = "permanent",
      start_date         = as.Date("2010-01-01"),
      end_date           = NA_real_
    )
  ))
}

# ---------------------------------------------------------------------------
# Input validation
# ---------------------------------------------------------------------------
test_that("fewer than 2 personnel snapshots raises error", {
  p <- data.table(personnel_id = "P1", ref_date = as.Date("2015-09-01"), status = "active")
  c <- make_contract()
  expect_error(
    estimate_exit_rates(contract_dt = c, personnel_dt = p),
    "2 distinct ref_date"
  )
})

test_that("data.frame inputs are accepted without error", {
  expect_no_error(
    estimate_exit_rates(
      contract_dt  = as.data.frame(make_contract()),
      personnel_dt = as.data.frame(make_personnel())
    )
  )
})

test_that("ref_date extra argument is silently absorbed (no partial-match error)", {
  expect_no_error(
    estimate_exit_rates(
      contract_dt  = make_contract(),
      personnel_dt = make_personnel(),
      ref_date     = "2015-09-01"
    )
  )
})

# ---------------------------------------------------------------------------
# Output structure
# ---------------------------------------------------------------------------
test_that("ungrouped result has exactly one row with exit_rate column", {
  out <- estimate_exit_rates(
    contract_dt  = make_contract(),
    personnel_dt = make_personnel(),
    group_cols   = NULL
  )
  expect_s3_class(out, "data.table")
  expect_equal(nrow(out), 1L)
  expect_true("exit_rate" %in% names(out))
})

test_that("grouped result has one row per group", {
  # Two establishments
  c_dt <- data.table::rbindlist(list(
    make_contract("E1"),
    make_contract("E2")[, personnel_id := paste0("X", personnel_id)]
  ))
  p_dt <- data.table::rbindlist(list(
    make_personnel(),
    make_personnel()[, personnel_id := paste0("X", personnel_id)]
  ))
  out <- estimate_exit_rates(
    contract_dt  = c_dt,
    personnel_dt = p_dt,
    group_cols   = "est_id"
  )
  expect_equal(nrow(out), 2L)
  expect_true("est_id"     %in% names(out))
  expect_true("exit_rate"  %in% names(out))
})

test_that("exit_rate is numeric and non-negative", {
  out <- estimate_exit_rates(
    contract_dt  = make_contract(),
    personnel_dt = make_personnel()
  )
  expect_type(out$exit_rate, "double")
  expect_true(all(out$exit_rate >= 0, na.rm = TRUE))
})

# ---------------------------------------------------------------------------
# Correctness
# ---------------------------------------------------------------------------
test_that("zero exits produces exit_rate of 0", {
  # Both persons present at both snapshots → no fire events
  p <- data.table::rbindlist(list(
    data.table(personnel_id = "P1", ref_date = as.Date("2015-09-01"), employment_status = "active"),
    data.table(personnel_id = "P2", ref_date = as.Date("2015-09-01"), employment_status = "active"),
    data.table(personnel_id = "P1", ref_date = as.Date("2016-09-01"), employment_status = "active"),
    data.table(personnel_id = "P2", ref_date = as.Date("2016-09-01"), employment_status = "active")
  ))
  c <- data.table::rbindlist(list(
    make_contract()[personnel_id == "P1"],
    make_contract()[personnel_id == "P2"],
    make_contract()[personnel_id == "P1"][, ref_date := as.Date("2016-09-01")],
    make_contract()[personnel_id == "P2"][, ref_date := as.Date("2016-09-01")]
  ))
  out <- estimate_exit_rates(contract_dt = c, personnel_dt = p)
  expect_equal(out$exit_rate, 0)
})

test_that("integer ref_date column is coerced without error", {
  p <- make_personnel()
  c <- make_contract()
  # Simulate integer storage (days since origin)
  p[, ref_date := as.integer(ref_date)]
  c[, ref_date := as.integer(ref_date)]
  expect_no_error(
    estimate_exit_rates(contract_dt = c, personnel_dt = p)
  )
})

test_that("contracts with non-active types (inactive) are excluded from stock", {
  c <- make_contract()
  # Replace contract type with inactive — stock should be 0
  c[, contract_type := "inactive"]
  p <- make_personnel()
  out <- estimate_exit_rates(contract_dt = c, personnel_dt = p)
  # No active stock → exit_rate = 0 (fifelse guard)
  expect_equal(out$exit_rate, 0)
})

# ---------------------------------------------------------------------------
# Edge: group_cols present but no matching contracts for some groups
# ---------------------------------------------------------------------------
test_that("group with no contract stock gets exit_rate of 0, not NA", {
  c <- make_contract("E1")
  # Remove contracts for E1 stock (make all inactive)
  c[, contract_type := "inactive"]
  p <- make_personnel()
  out <- estimate_exit_rates(
    contract_dt  = c,
    personnel_dt = p,
    group_cols   = "est_id"
  )
  expect_false(any(is.na(out$exit_rate)))
})
