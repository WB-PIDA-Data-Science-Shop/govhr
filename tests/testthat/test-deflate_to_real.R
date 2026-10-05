# tests/testthat/test-deflate_to_real.R
library(testthat)

# expected values are computed from govhr::cpi, so the tests check the
# formula rather than numbers that move whenever the CPI data is refreshed
bra_cpi <- govhr::cpi[govhr::cpi$country_code == "BRA", ]

cpi_in_month <- function(month){
  bra_cpi$cpi[bra_cpi$ref_date == as.Date(month)]
}

cpi_in_year <- function(year){
  mean(bra_cpi$cpi[format(bra_cpi$ref_date, "%Y") == year])
}

test_that("deflate_to_real deflates to average prices of the default base year (2021)", {
  result <- deflate_to_real(10000, as.Date("2019-01-01"), "BRA")

  expected <- 10000 * cpi_in_year("2021") / cpi_in_month("2019-01-01")
  expect_equal(result, expected)
  expect_gt(result, 10000)
})

test_that("deflate_to_real matches any day of the month to that month's CPI", {
  first_day <- deflate_to_real(10000, as.Date("2019-01-01"), "BRA")
  mid_month <- deflate_to_real(10000, as.Date("2019-01-17"), "BRA")

  expect_equal(mid_month, first_day)
})

test_that("deflate_to_real distinguishes months within the same year", {
  result <- deflate_to_real(
    c(10000, 10000),
    as.Date(c("2021-01-01", "2021-12-01")),
    "BRA"
  )

  expect_false(result[1] == result[2])
})

test_that("deflate_to_real respects a custom base_year", {
  result <- deflate_to_real(10000, as.Date("2021-01-01"), "BRA", base_year = 2019)

  expected <- 10000 * cpi_in_year("2019") / cpi_in_month("2021-01-01")
  expect_equal(result, expected)
  expect_lt(result, 10000)
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

test_that("deflate_to_real returns NA with a warning for an unknown country code", {
  expect_warning(
    result <- deflate_to_real(10000, as.Date("2019-01-01"), "ZZZ"),
    "No CPI"
  )

  expect_true(is.na(result))
})

test_that("deflate_to_real does not warn about values that are already NA", {
  expect_no_warning(
    result <- deflate_to_real(NA_real_, as.Date("2019-01-01"), "ZZZ")
  )

  expect_true(is.na(result))
})

test_that("deflate_to_real rejects an invalid base_year", {
  expect_error(
    deflate_to_real(10000, as.Date("2019-01-01"), "BRA", base_year = c(2019, 2020)),
    "base_year"
  )
})
