library(testthat)
library(data.table)

test_that("compute_fastchange returns a data.table with expected columns", {
  dt <- data.table::data.table(
    year = 2018:2020,
    value = c(100, 120, 150)
  )

  res <- compute_fastchange(dt, col = "value", date_col = "year")

  expect_s3_class(res, "data.table")
  expect_true(all(c("year", "value", "value_growth") %in% names(res)))
})

test_that("compute_fastchange correctly computes year-over-year growth", {
  dt <- data.table::data.table(
    year = c(2018, 2019, 2020),
    value = c(100, 110, 121)
  )

  res <- compute_fastchange(dt, col = "value", date_col = "year")

  expected_growth <- c(NA, 110/100 - 1, 121/110 - 1)

  expect_equal(res$value_growth, expected_growth)
})

test_that("compute_fastchange fills missing years and inserts NAs for missing values", {
  dt <- data.table::data.table(
    year = c(2018, 2020),
    value = c(100, 150)
  )

  res <- compute_fastchange(dt, col = "value", date_col = "year")

  expect_equal(res$year, 2018:2020)
  expect_equal(res$value, c(100, NA, 150))
  # growth should be NA, NA, NA because the middle year is NA
  expect_true(all(is.na(res$value_growth)))
})

test_that("compute_fastchange handles non-character col/date_col correctly (symbols)", {
  dt <- data.table::data.table(
    year = 2019:2021,
    gdp = c(50, 55, 60)
  )

  res <- compute_fastchange(dt, "gdp", "year")

  expect_true("gdp_growth" %in% names(res))
  expect_equal(res$gdp_growth, c(NA, 55/50 - 1, 60/55 - 1))
})

test_that("compute_fastchange handles a single-year dataset", {
  dt <- data.table::data.table(
    year = 2020,
    x = 500
  )

  res <- compute_fastchange(dt, "x", "year")

  expect_equal(nrow(res), 1)
  expect_true(is.na(res$x_growth))
})

test_that("compute_fastchange works with NA values inside the input column", {
  dt <- data.table::data.table(
    year = 2020:2022,
    val = c(100, NA, 200)
  )

  res <- compute_fastchange(dt, "val", "year")

  # growth becomes: NA, NA, NA
  expect_true(all(is.na(res$val_growth)))
})

