# tests/testthat/test-convert_constant_lcu.R
library(testthat)

test_that("convert_constant_lcu deflates correctly and renames _lcu to _real", {
  data <- tibble::tibble(
    country_code = c("A", "A"),
    year         = c(2010, 2021),
    wage_lcu     = c(20000, 25000)
  )

  macro_indicators <- tibble::tibble(
    country_code = c("A", "A"),
    year         = c(2010, 2021),
    cpi          = c(85, 100)
  )

  result <- convert_constant_lcu(data, "wage_lcu", macro_indicators)

  # 2010: 20000 * (100 / 85) ≈ 23529.41
  # 2021: 25000 * (100 / 100) = 25000
  expect_true("wage_real" %in% names(result))
  expect_equal(result$wage_real, c(23529.41, 25000), tolerance = 1e-2)
})

test_that("convert_constant_lcu errors on missing required or value columns", {
  macro_indicators <- tibble::tibble(country_code = "A", year = 2021, cpi = 100)

  expect_error(
    convert_constant_lcu(tibble::tibble(country_code = "A", wage_lcu = 1000), "wage_lcu", macro_indicators),
    "must contain columns: country_code, year"
  )

  expect_error(
    convert_constant_lcu(tibble::tibble(country_code = "A", year = 2021), "wage_lcu", macro_indicators),
    "Column\\(s\\) not found"
  )
})
