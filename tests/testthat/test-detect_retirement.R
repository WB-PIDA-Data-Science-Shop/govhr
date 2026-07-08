library(testthat)
library(data.table)
library(lubridate)

# Example dataset
set.seed(123)
years <- 2015:2025
n_personnel <- 1000

dt <- data.table(
  personnel_id = rep(1:n_personnel, each = length(years)),
  ref_date = rep(ymd(paste0(years, "-01-01")), times = n_personnel),
  employment_status = sample(c("active", "pensioner"), n_personnel * length(years), replace = TRUE, prob = c(0.7,0.3))
)

# Mock convert_data if not available
convert_data <- function(dt_expanded, original_data) dt_expanded


test_that("detect_retirement detects retirement events correctly", {
  # Create a simple test case
  dt2 <- data.table(
    personnel_id = c(1,1,1,2,2),
    ref_date = ymd(c("2020-01-01","2021-01-01","2022-01-01","2020-01-01","2021-01-01")),
    employment_status = c("active","active","pensioner","active","pensioner")
  )

  res <- detect_retirement(dt2)

  # Check output columns
  expect_true(all(c("personnel_id", "ref_date", "type_event") %in% names(res)))

  # Should detect retirement for both personnel
  expect_equal(res$personnel_id, c(1,2))
  expect_equal(res$type_event, c("retire","retire"))

  # Dates should be the last active before inactive
  expect_equal(res$ref_date, ymd(c("2021-01-01","2020-01-01")))
})

test_that("detect_retirement ignores non-retire transitions", {
  dt3 <- data.table(
    personnel_id = 1:3,
    ref_date = ymd(c("2020-01-01","2021-01-01","2022-01-01")),
    employment_status = c("active","active","active")
  )

  res <- detect_retirement(dt3)
  expect_equal(nrow(res), 0)
})

test_that("detect_retirement works with multiple personnel and years", {
  dt_large <- copy(dt)
  # Randomly set the last year of each personnel to inactive
  dt_large[, employment_status := ifelse(ref_date == max(ref_date), "pensioner", "active"), by = personnel_id]

  res <- detect_retirement(dt_large)

  # Should return one retirement per personnel
  expect_equal(nrow(res), n_personnel)

  # All type_event should be "retire"
  expect_true(all(res$type_event == "retire"))

  # All personnel_id should be valid
  expect_true(all(res$personnel_id %in% 1:n_personnel))
})

test_that("detect_retirement output is ordered correctly", {
  res <- detect_retirement(dt)

  expect_s3_class(res, "data.table")
  expect_true(all(c("personnel_id", "ref_date", "type_event") %in% names(res)))
})

test_that("detect_retirement handles edge cases with single-year personnel", {
  dt_edge <- data.table(
    personnel_id = c(1,2),
    ref_date = ymd(c("2020-01-01","2020-01-01")),
    employment_status = c("active","pensioner")
  )

  res <- detect_retirement(dt_edge)
  # No retire events possible because no lead status
  expect_equal(nrow(res), 0)
})
