# tests/testthat/test-convert_constant_ppp.R
library(testthat)

test_that("convert_constant_ppp computes correct PPP-adjusted values", {
  data <- tibble(
    country_code = c("A", "A"),
    year = c(2010, 2021),
    wage_lcu = c(20000, 25000)
  )

  macro_indicators <- tibble(
    country_code = "A",
    year = c(2010, 2021),
    cpi = c(85, 100),
    ppp = c(1.5, 3.5)
  )

  result <- convert_constant_ppp(data, "wage_lcu", macro_indicators)

  # expected computation:
  # 2010: (85 / 100) * (20000 / 3.5) = 4857.14
  # 2021: (100 / 100) * (25000 / 3.5) = 7142.86
  expect_true("wage_ppp" %in% names(result))
  expect_equal(result$wage_ppp, c(4857.14, 7142.86), tolerance = 1e-2)
})

test_that("convert_constant_ppp errors when required columns are missing", {
  bad_data <- tibble(country_code = "A", wage = 20000)
  macro_indicators <- tibble(country_code = "A", year = 2021, cpi = 100, ppp = 3.5)

  expect_error(
    convert_constant_ppp(bad_data, "wage", macro_indicators),
    "must contain columns: country_code, year"
  )
})

test_that("convert_constant_ppp preserves original columns", {
  data <- tibble(
    country_code = "A",
    year = 2021,
    wage_lcu = 10000,
    sector = "public"
  )

  macro_indicators <- tibble(
    country_code = "A",
    year = 2021,
    cpi = 100,
    ppp = 2
  )

  result <- convert_constant_ppp(data, "wage_lcu", macro_indicators)
  expect_true("sector" %in% names(result))
})
