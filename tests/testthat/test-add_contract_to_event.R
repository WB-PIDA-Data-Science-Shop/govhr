library(testthat)
library(data.table)
library(lubridate)

# Example event data
event_dt <- data.table(
  personnel_id = c(1, 2, 3),
  ref_date = ymd(c("2022-01-01", "2022-01-01", "2022-01-01")),
  type_event = c("hire", "retire", "reallocation")
)

# Example contract data
contract_dt <- data.table(
  personnel_id = c(1, 2, 2, 3),
  ref_date = ymd(c("2022-01-01", "2022-01-01", "2022-01-01", "2022-01-01")),
  contract_type = c("A", "B", "B", "C"),
  salary = c(100, 200, 200, 300),
  extra_col = c("x","y","y","z")
)

test_that("add_contract_to_event joins contract data correctly", {
  res <- add_contract_to_event(event_dt, contract_dt, keep_vars = c("contract_type", "salary"))

  # Output should have original columns plus keep_vars
  expect_true(all(c("personnel_id", "ref_date", "type_event", "contract_type", "salary") %in% names(res)))

  # Values should match contract data
  expect_equal(res[personnel_id == 1]$contract_type, "A")
  expect_equal(res[personnel_id == 2]$salary, 200)
  expect_equal(res[personnel_id == 3]$contract_type, "C")

  # Extra columns should NOT appear
  expect_false("extra_col" %in% names(res))
})

test_that("add_contract_to_event removes duplicates in contract_dt", {
  # contract_dt has duplicate row for personnel_id 2
  res <- add_contract_to_event(event_dt, contract_dt, keep_vars = c("contract_type", "salary"))

  # Should have same number of rows as event_dt
  expect_equal(nrow(res), nrow(event_dt))
})

test_that("add_contract_to_event handles events with no contract match", {
  dt_event2 <- data.table(
    personnel_id = c(4, 5),
    ref_date = ymd(c("2022-01-01", "2022-01-01")),
    type_event = c("hire","retire")
  )

  res <- add_contract_to_event(dt_event2, contract_dt, keep_vars = c("contract_type", "salary"))

  # All keep_vars should be NA
  expect_true(all(is.na(res$contract_type)))
  expect_true(all(is.na(res$salary)))
})

test_that("add_contract_to_event works with large dataset", {
  n_personnel <- 10000
  years <- 2015:2025
  n_rows <- n_personnel * length(years)

  events <- data.table(
    personnel_id = rep(1:n_personnel, each = length(years)),
    ref_date = rep(ymd(paste0(years,"-01-01")), times = n_personnel),
    type_event = sample(c("hire","retire","reallocation"), n_rows, replace = TRUE)
  )

  contracts <- data.table(
    personnel_id = rep(1:n_personnel, each = length(years)),
    ref_date = rep(ymd(paste0(years,"-01-01")), times = n_personnel),
    contract_type = sample(c("A","B","C"), n_rows, replace = TRUE),
    salary = sample(50000:100000, n_rows, replace = TRUE)
  )

  start_time <- Sys.time()
  res <- add_contract_to_event(events, contracts, keep_vars = c("contract_type","salary"))
  end_time <- Sys.time()
  runtime <- as.numeric(difftime(end_time, start_time, units = "secs"))
  message(sprintf("Runtime for %d rows: %.2f seconds", n_rows, runtime))

  # Output checks
  expect_equal(nrow(res), nrow(events))
  expect_true(all(c("contract_type","salary") %in% names(res)))
  expect_lt(runtime, 10)
})

