library(testthat)
library(data.table)
library(lubridate)
library(dplyr)

set.seed(123)

# Large synthetic dataset
n_personnel <- 1000
years <- 2015:2025

personnel_dt <- data.table(
  personnel_id = rep(1:n_personnel, each = length(years)),
  ref_date = rep(ymd(paste0(years, "-01-01")), times = n_personnel),
  status = sample(c("active", "inactive"), n_personnel * length(years), replace = TRUE, prob = c(0.7, 0.3))
)


convert_data <- function(dt_expanded, original_data) {
  # For testing: return dt_expanded
  return(dt_expanded)
}

test_that("detect_personnel_event detects hires correctly", {
  res <- detect_personnel_event(
    data = personnel_dt,
    id_col = "personnel_id",
    event_type = "hire",
    start_date = "2015-01-01",
    end_date = "2025-12-31",
    freq = "year"
  )

  # Output should have only 'hire' events
  expect_true(all(res$type_event == "hire"))

  # Output columns should exist
  expect_true(all(c("personnel_id", "ref_date", "type_event") %in% names(res)))

  # All personnel_id should be in 1:n_personnel
  expect_true(all(res$personnel_id %in% 1:n_personnel))
})

test_that("detect_personnel_event detects fires correctly", {
  res <- detect_personnel_event(
    data = personnel_dt,
    id_col = "personnel_id",
    event_type = "fire",
    start_date = "2015-01-01",
    end_date = "2025-12-31",
    freq = "year"
  )

  # Output should have only 'fire' events
  expect_true(all(res$type_event == "fire"))

  # Columns should exist
  expect_true(all(c("personnel_id", "ref_date", "type_event") %in% names(res)))

  # All personnel_id should be in 1:n_personnel
  expect_true(all(res$personnel_id %in% 1:n_personnel))
})

test_that("detect_personnel_event ignores inactive personnel", {
  # Add a fully inactive personnel
  dt2 <- copy(personnel_dt)
  dt2[personnel_id == 1, status := "inactive"]

  res <- detect_personnel_event(
    data = dt2,
    id_col = "personnel_id",
    event_type = "hire",
    start_date = "2015-01-01",
    end_date = "2025-12-31",
    freq = "year"
  )

  # personnel_id 1 should not appear
  expect_false(1 %in% res$personnel_id)
})

test_that("detect_personnel_event works with multiple personnel and dates", {
  # Randomly set some active/inactive transitions
  dt3 <- copy(personnel_dt)
  dt3[, status := sample(c("active", "inactive"), .N, replace = TRUE)]

  res_hire <- detect_personnel_event(dt3, "personnel_id", "hire", "2015-01-01", "2025-12-31")
  res_fire <- detect_personnel_event(dt3, "personnel_id", "fire", "2015-01-01", "2025-12-31")

  # Should return data.tables with correct columns
  expect_true(all(c("personnel_id", "ref_date", "type_event") %in% names(res_hire)))
  expect_true(all(c("personnel_id", "ref_date", "type_event") %in% names(res_fire)))

  # Should contain at least some events
  expect_true(nrow(res_hire) > 0)
  expect_true(nrow(res_fire) > 0)
})

test_that("detect_personnel_event output respects start_date / end_date filtering", {
  # Set start_date in the middle
  res <- detect_personnel_event(
    data = personnel_dt,
    id_col = "personnel_id",
    event_type = "hire",
    start_date = "2020-01-01",
    end_date = "2025-12-31"
  )

  expect_true(all(res$ref_date > ymd("2020-01-01")))

  res_fire <- detect_personnel_event(
    data = personnel_dt,
    id_col = "personnel_id",
    event_type = "fire",
    start_date = "2015-01-01",
    end_date = "2020-01-01"
  )

  expect_true(all(res_fire$ref_date < ymd("2020-01-01")))
})

