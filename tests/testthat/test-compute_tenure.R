library(testthat)
library(data.table)

# ---------------------------------------------------------------------------
# Helper: minimal contract data.table
# ---------------------------------------------------------------------------
make_contracts <- function(personnel_id,
                           contract_id,
                           start_date,
                           end_date,
                           contract_type_code = "permanent") {
  data.table::data.table(
    personnel_id       = personnel_id,
    contract_id        = contract_id,
    start_date         = as.Date(start_date),
    end_date           = as.Date(end_date),
    contract_type_code = contract_type_code
  )
}

ref <- "2020-01-01"

# ---------------------------------------------------------------------------
# Output structure
# ---------------------------------------------------------------------------
test_that("compute_tenure returns correct columns and one row per person", {
  dt <- make_contracts("P1", "C1", "2015-01-01", "2019-01-01")
  out <- compute_tenure(dt, ref_date = ref)
  expect_s3_class(out, "data.table")
  expect_named(out, c("personnel_id", "tenure_days", "tenure_years"))
  expect_equal(nrow(out), 1L)
})

test_that("tenure_years == tenure_days / 365.25", {
  dt <- make_contracts("P1", "C1", "2015-01-01", "2019-01-01")
  out <- compute_tenure(dt, ref_date = ref)
  expect_equal(out$tenure_years, out$tenure_days / 365.25)
})

# ---------------------------------------------------------------------------
# Single non-overlapping contract
# ---------------------------------------------------------------------------
test_that("single contract: tenure equals end minus start in days", {
  dt <- make_contracts("P1", "C1", "2018-01-01", "2019-01-01")
  out <- compute_tenure(dt, ref_date = ref)
  expected_days <- as.numeric(as.Date("2019-01-01") - as.Date("2018-01-01"))
  expect_equal(out$tenure_days, expected_days)
})

# ---------------------------------------------------------------------------
# ref_date coercion
# ---------------------------------------------------------------------------
test_that("ref_date accepts a character string", {
  dt <- make_contracts("P1", "C1", "2018-01-01", "2019-06-01")
  expect_no_error(compute_tenure(dt, ref_date = "2020-01-01"))
})

test_that("ref_date accepts a Date object", {
  dt <- make_contracts("P1", "C1", "2018-01-01", "2019-06-01")
  expect_no_error(compute_tenure(dt, ref_date = as.Date("2020-01-01")))
})

test_that("character and Date ref_date give identical results", {
  dt <- make_contracts("P1", "C1", "2018-01-01", "2019-06-01")
  r1 <- compute_tenure(dt, ref_date = "2020-01-01")
  r2 <- compute_tenure(dt, ref_date = as.Date("2020-01-01"))
  expect_equal(r1$tenure_days, r2$tenure_days)
})

# ---------------------------------------------------------------------------
# Open-ended contract (end_date = NA)
# ---------------------------------------------------------------------------
test_that("open-ended contract is capped at ref_date", {
  dt <- make_contracts("P1", "C1", "2018-01-01", NA)
  out <- compute_tenure(dt, ref_date = "2020-01-01")
  expected_days <- as.numeric(as.Date("2020-01-01") - as.Date("2018-01-01"))
  expect_equal(out$tenure_days, expected_days)
})

# ---------------------------------------------------------------------------
# Contract starts after ref_date → excluded
# ---------------------------------------------------------------------------
test_that("contracts starting after ref_date are excluded and return empty", {
  dt <- make_contracts("P1", "C1", "2021-01-01", "2022-01-01")
  out <- compute_tenure(dt, ref_date = "2020-01-01")
  expect_equal(nrow(out), 0L)
  expect_named(out, c("personnel_id", "tenure_days", "tenure_years"))
})

# ---------------------------------------------------------------------------
# Inactive / pensioner filtering
# ---------------------------------------------------------------------------
test_that("inactive contracts are excluded", {
  dt <- make_contracts("P1", "C1", "2015-01-01", "2019-01-01",
                       contract_type_code = "inactive")
  out <- compute_tenure(dt, ref_date = ref)
  expect_equal(nrow(out), 0L)
})

test_that("pensioner contracts are excluded", {
  dt <- make_contracts("P1", "C1", "2015-01-01", "2019-01-01",
                       contract_type_code = "pensioner")
  out <- compute_tenure(dt, ref_date = ref)
  expect_equal(nrow(out), 0L)
})

test_that("active contract is kept when mixed with inactive", {
  dt <- data.table::rbindlist(list(
    make_contracts("P1", "C1", "2015-01-01", "2019-01-01", "permanent"),
    make_contracts("P1", "C2", "2015-01-01", "2019-01-01", "inactive")
  ))
  out <- compute_tenure(dt, ref_date = ref)
  expect_equal(nrow(out), 1L)
})

# ---------------------------------------------------------------------------
# Overlapping contracts — must not double-count days
# ---------------------------------------------------------------------------
test_that("two fully overlapping contracts count days only once", {
  dt <- data.table::rbindlist(list(
    make_contracts("P1", "C1", "2018-01-01", "2019-06-01"),
    make_contracts("P1", "C2", "2018-06-01", "2019-01-01")  # nested inside C1
  ))
  out_overlap  <- compute_tenure(dt, ref_date = ref)
  out_single   <- compute_tenure(
    make_contracts("P1", "C1", "2018-01-01", "2019-06-01"),
    ref_date = ref
  )
  expect_equal(out_overlap$tenure_days, out_single$tenure_days)
})

test_that("two partially overlapping contracts: union counted correctly", {
  # C1: 2018-01-01 → 2018-07-01  (181 days)
  # C2: 2018-04-01 → 2018-10-01  (183 days)
  # Union: 2018-01-01 → 2018-10-01
  dt <- data.table::rbindlist(list(
    make_contracts("P1", "C1", "2018-01-01", "2018-07-01"),
    make_contracts("P1", "C2", "2018-04-01", "2018-10-01")
  ))
  out <- compute_tenure(dt, ref_date = ref)
  expected_days <- as.numeric(as.Date("2018-10-01") - as.Date("2018-01-01"))
  expect_equal(out$tenure_days, expected_days)
})

# ---------------------------------------------------------------------------
# Adjacent contracts — boundary day must not be double-counted
# ---------------------------------------------------------------------------
test_that("adjacent contracts (end of A == start of B) are not double-counted", {
  # C1 ends 2018-07-01, C2 starts 2018-07-01 — the boundary day belongs to C2
  dt <- data.table::rbindlist(list(
    make_contracts("P1", "C1", "2018-01-01", "2018-07-01"),
    make_contracts("P1", "C2", "2018-07-01", "2019-01-01")
  ))
  out <- compute_tenure(dt, ref_date = ref)
  # Total should equal the full span without the gap
  expected_days <- as.numeric(as.Date("2019-01-01") - as.Date("2018-01-01"))
  expect_equal(out$tenure_days, expected_days)
})

# ---------------------------------------------------------------------------
# Non-overlapping contracts with a gap
# ---------------------------------------------------------------------------
test_that("gap between contracts is excluded from tenure", {
  # C1: 2016-01-01 → 2017-01-01 (366 days)
  # C2: 2018-01-01 → 2019-01-01 (365 days)
  # gap of 2017 is excluded
  dt <- data.table::rbindlist(list(
    make_contracts("P1", "C1", "2016-01-01", "2017-01-01"),
    make_contracts("P1", "C2", "2018-01-01", "2019-01-01")
  ))
  out <- compute_tenure(dt, ref_date = ref)
  expected_days <- as.numeric(as.Date("2017-01-01") - as.Date("2016-01-01")) +
    as.numeric(as.Date("2019-01-01") - as.Date("2018-01-01"))
  expect_equal(out$tenure_days, expected_days)
})

# ---------------------------------------------------------------------------
# Multiple persons — one row per person, independent calculation
# ---------------------------------------------------------------------------
test_that("multiple persons each get their own tenure row", {
  dt <- data.table::rbindlist(list(
    make_contracts("P1", "C1", "2015-01-01", "2019-01-01"),
    make_contracts("P2", "C2", "2016-01-01", "2019-01-01")
  ))
  out <- compute_tenure(dt, ref_date = ref)
  expect_equal(nrow(out), 2L)
  expect_true("P1" %in% out$personnel_id)
  expect_true("P2" %in% out$personnel_id)
  # P1 has more tenure than P2
  p1 <- out[out$personnel_id == "P1", ]$tenure_days
  p2 <- out[out$personnel_id == "P2", ]$tenure_days
  expect_gt(p1, p2)
})

# ---------------------------------------------------------------------------
# Panel data — duplicate (contract_id, start_date) rows must be deduplicated
# ---------------------------------------------------------------------------
test_that("panel duplicates do not inflate tenure", {
  single <- make_contracts("P1", "C1", "2015-01-01", "2019-01-01")
  panel  <- data.table::rbindlist(replicate(3, single, simplify = FALSE))
  out_single <- compute_tenure(single, ref_date = ref)
  out_panel  <- compute_tenure(panel,  ref_date = ref)
  expect_equal(out_single$tenure_days, out_panel$tenure_days)
})

# ---------------------------------------------------------------------------
# Custom column names
# ---------------------------------------------------------------------------
test_that("custom column names are respected", {
  dt <- data.table::data.table(
    pid   = "P1",
    cid   = "C1",
    s_dt  = as.Date("2015-01-01"),
    e_dt  = as.Date("2019-01-01"),
    ctype = "permanent"
  )
  out <- compute_tenure(
    dt,
    ref_date           = ref,
    personnel_id_col   = "pid",
    contract_id_col    = "cid",
    start_date_col     = "s_dt",
    end_date_col       = "e_dt",
    contract_type_col  = "ctype"
  )
  expect_named(out, c("pid", "tenure_days", "tenure_years"))
  expect_equal(nrow(out), 1L)
})

# ---------------------------------------------------------------------------
# Input accepts data.frame (not just data.table)
# ---------------------------------------------------------------------------
test_that("data.frame input is accepted without error", {
  df <- as.data.frame(make_contracts("P1", "C1", "2015-01-01", "2019-01-01"))
  expect_no_error(compute_tenure(df, ref_date = ref))
})
