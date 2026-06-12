# tests/testthat/test-deflate_to_real.R
library(testthat)

mock_macro <- tibble::tibble(
  country_code = c("AAA", "AAA", "AAA", "BBB", "BBB", "BBB"),
  year         = c(2019L, 2020L, 2021L, 2019L, 2020L, 2021L),
  cpi          = c(80.0, 90.0, 100.0, 50.0, 75.0, 100.0)
)

test_that("deflate_to_real deflates correctly to default base year (2021)", {
  result <- deflate_to_real(10000, as.Date("2019-01-01"), "BRA")

  expect_equal(result, 11178.01, tolerance = 0.01)
})

test_that("deflate_to_real returns unchanged value when observation is at the base year", {
  result <- deflate_to_real(10000, as.Date("2021-06-15"), "BRA")

  expect_equal(result, 10000)
})

test_that("deflate_to_real respects a custom base_year", {
  result <- deflate_to_real(10000, as.Date("2021-01-01"), "BRA", base_year = 2019)

  expect_equal(result, 8946.14, tolerance = 0.01)
})

test_that("deflate_to_real returns NA for an unknown country code", {
  result <- deflate_to_real(10000, as.Date("2019-01-01"), "ZZZ")

  expect_true(is.na(result))
})