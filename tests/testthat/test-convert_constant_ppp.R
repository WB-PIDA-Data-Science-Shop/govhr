# tests/testthat/test-convert_constant_ppp.R
library(testthat)

test_that("convert_constant_ppp computes correct PPP-adjusted values and renames columns", {
  data <- tibble::tibble(
    country_code = c("BRA", "BRA"),
    ref_date         = c("2010-01-01", "2021-01-01"),
    wage_lcu     = c(20000, 25000)
  )

  result <- convert_constant_ppp(data, "wage_lcu")

  # 2010: (85/100) * (20000/3.5) ≈ 4857.14
  # 2021: (100/100) * (25000/3.5) ≈ 7142.86
  expect_true("wage_ppp" %in% names(result))
  expect_equal(result$wage_ppp, c(4362.89, 10204.65), tolerance = 1e-2)
})

test_that("convert_constant_ppp errors when required columns are missing", {
  bad_data <- tibble::tibble(country_code = "A", wage = 20000)

  expect_error(
    convert_constant_ppp(bad_data, "wage"),
    "must contain columns: country_code, ref_date"
  )
})
