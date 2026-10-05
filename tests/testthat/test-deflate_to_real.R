# tests/testthat/test-deflate_to_real.R
library(testthat)

# expected values are computed from govhr::cpi, so the tests check the
# formula rather than numbers that move whenever the CPI data is refreshed
cpi_in_month <- function(code, month){
  govhr::cpi$cpi[
    govhr::cpi$country_code == code & govhr::cpi$ref_date == as.Date(month)
  ]
}

test_that("deflate_to_real deflates to prices of the default base month (December 2021)", {
  result <- deflate_to_real(10000, as.Date("2019-01-01"), "BRA")

  expected <- 10000 * cpi_in_month("BRA", "2021-12-01") / cpi_in_month("BRA", "2019-01-01")
  expect_equal(result, expected)
  expect_gt(result, 10000)
})

test_that("deflate_to_real returns the input for a value in the base month", {
  result <- deflate_to_real(10000, as.Date("2021-12-20"), "BRA")

  expect_equal(result, 10000)
})

test_that("deflate_to_real matches any day of the month to that month's CPI", {
  first_day <- deflate_to_real(10000, as.Date("2019-01-01"), "BRA")
  mid_month <- deflate_to_real(10000, as.Date("2019-01-17"), "BRA")

  expect_equal(mid_month, first_day)
})

test_that("deflate_to_real distinguishes months within the same year", {
  result <- deflate_to_real(
    c(10000, 10000),
    as.Date(c("2021-01-01", "2021-11-01")),
    "BRA"
  )

  expect_false(result[1] == result[2])
})

test_that("deflate_to_real respects a custom base_month", {
  result <- deflate_to_real(10000, as.Date("2021-12-01"), "BRA", base_month = "2019-01-01")

  expected <- 10000 * cpi_in_month("BRA", "2019-01-01") / cpi_in_month("BRA", "2021-12-01")
  expect_equal(result, expected)
  expect_lt(result, 10000)
})

test_that("deflate_to_real accepts base_month as a string or a Date", {
  as_string <- deflate_to_real(10000, as.Date("2019-01-01"), "BRA", base_month = "2020-01-01")
  as_date <- deflate_to_real(10000, as.Date("2019-01-01"), "BRA", base_month = as.Date("2020-01-01"))

  expect_equal(as_date, as_string)
})

test_that("deflate_to_real accepts a column of country codes", {
  result <- deflate_to_real(
    c(10000, 10000),
    as.Date(c("2019-01-01", "2019-01-01")),
    c("BRA", "MOZ")
  )

  expect_length(result, 2)
  expect_equal(result[1], deflate_to_real(10000, as.Date("2019-01-01"), "BRA"))
  expect_false(anyNA(result))
})

test_that("deflate_to_real works inside mutate()", {
  data <- tibble::tibble(
    wage = c(100, 200),
    ref_date = as.Date(c("2020-01-01", "2020-02-01"))
  )

  result <- dplyr::mutate(data, wage_real = deflate_to_real(wage, ref_date, "BRA"))

  expect_equal(
    result$wage_real,
    deflate_to_real(c(100, 200), data$ref_date, "BRA")
  )
})

test_that("deflate_to_real returns NA with a warning for an unknown country code", {
  expect_warning(
    result <- deflate_to_real(10000, as.Date("2019-01-01"), "ZZZ"),
    "No CPI for 1 country-month"
  )

  expect_true(is.na(result))
})

test_that("deflate_to_real returns NA with a warning for a month with no CPI", {
  expect_warning(
    result <- deflate_to_real(10000, as.Date("1950-01-01"), "BRA"),
    "BRA 1950-01"
  )

  expect_true(is.na(result))
})

test_that("deflate_to_real does not warn about values that are already NA", {
  expect_no_warning(
    result <- deflate_to_real(NA_real_, as.Date("2019-01-01"), "ZZZ")
  )

  expect_true(is.na(result))
})

test_that("deflate_to_real requires a base_month within a rebased country's data", {
  # Venezuela's CPI stops in December 2016, before the default base month
  expect_warning(
    result <- deflate_to_real(100, as.Date("2015-06-01"), "VEN"),
    "No CPI in base month 2021-12 for VEN \\(.* to 2016-12\\)"
  )
  expect_true(is.na(result))

  # a base month within its data works
  result <- deflate_to_real(100, as.Date("2015-06-01"), "VEN", base_month = "2016-12-01")
  expected <- 100 * cpi_in_month("VEN", "2016-12-01") / cpi_in_month("VEN", "2015-06-01")
  expect_equal(result, expected)
})

test_that("deflate_to_real warns once per row, for its first missing CPI", {
  warnings <- testthat::capture_warnings(
    deflate_to_real(10000, as.Date("2019-01-01"), "ZZZ")
  )

  expect_length(warnings, 1)
})

test_that("deflate_to_real rejects a base_month that is not the first of a month", {
  invalid <- list(
    "not a date",
    "2021-13-01",
    "2021-12-15",
    "12/01/2021",
    c("2020-01-01", "2021-01-01")
  )

  for(base_month in invalid){
    expect_error(
      deflate_to_real(10000, as.Date("2019-01-01"), "BRA", base_month = base_month),
      "first of a month"
    )
  }
})

test_that("deflate_to_real no longer takes base_year", {
  expect_error(
    deflate_to_real(10000, as.Date("2019-01-01"), "BRA", base_year = 2021),
    "unused argument"
  )
})
