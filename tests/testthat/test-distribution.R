# Tests for compute_decile() ----------------------------------------------

test_that("compute_decile splits each group and reference date into ten deciles", {
  df <- data.frame(
    dept = rep(c("A", "B"), each = 200),
    ref_date = rep(as.Date(c("2020-01-01", "2021-01-01")), each = 100, times = 2),
    wage = c(1:100, 101:200, 1:100 * 10, 101:200 * 10)
  )

  out <- compute_decile(df, group_cols = "dept", measure_col = "wage")

  expect_equal(names(out), c("dept", "ref_date", "decile", "median_value", "mean_value"))
  # 2 groups x 2 dates x 10 deciles
  expect_equal(nrow(out), 40)
  expect_equal(out[dept == "A" & ref_date == as.Date("2020-01-01")]$decile, 1:10)

  # deciles are computed within each group and date, not across them
  a_2020 <- out[dept == "A" & ref_date == as.Date("2020-01-01")]
  b_2020 <- out[dept == "B" & ref_date == as.Date("2020-01-01")]
  expect_equal(a_2020$median_value[1], 5.5)
  expect_equal(b_2020$median_value[1], 55)
  expect_true(all(diff(a_2020$mean_value) > 0))
})

test_that("compute_decile drops missing measures and handles fewer than ten records", {
  df <- data.frame(
    ref_date = as.Date("2020-01-01"),
    wage = c(30, NA, 10, 20, NA)
  )

  out <- compute_decile(df, measure_col = "wage")

  # three non-missing records fill only the first three deciles
  expect_equal(out$decile, 1:3)
  expect_equal(out$median_value, c(10, 20, 30))
  expect_false(anyNA(out$mean_value))
})

test_that("compute_decile latest_measure keeps the latest date and ignores missing dates", {
  df <- data.frame(
    ref_date = as.Date(c(rep("2020-01-01", 10), rep("2021-01-01", 10), NA)),
    wage = c(1:10, 11:20, 999)
  )

  out <- compute_decile(df, measure_col = "wage", latest_measure = TRUE)

  expect_false("ref_date" %in% names(out))
  expect_equal(out$decile, 1:10)
  # only the 2021 records (11 to 20) are kept
  expect_equal(out$median_value, 11:20)
})

# Tests for compute_percentile() ------------------------------------------

test_that("compute_percentile fills empty bins with zero and accumulates shares", {
  df <- data.frame(wage = c(-1.5, 0.2, 0.7, 3.1))

  out <- compute_percentile(df, measure_col = "wage", binwidth = 1)

  expect_equal(names(out), c("bin", "count", "pct", "cum_pct"))
  # negative values floor down, and bins 1 and 2 are empty but present
  expect_equal(out$bin, c(-2, -1, 0, 1, 2, 3))
  expect_equal(out$count, c(1, 0, 2, 0, 0, 1))
  expect_equal(out$pct, c(0.25, 0, 0.5, 0, 0, 0.25))
  expect_equal(out$cum_pct, c(0.25, 0.25, 0.75, 0.75, 0.75, 1))
})

test_that("compute_percentile requires a positive whole-number binwidth", {
  df <- data.frame(wage = c(0.1, 0.2, 0.3, 0.3))

  # 0.3 / 0.1 is 2.9999... in floating point, which would floor into 0.2
  expect_error(compute_percentile(df, measure_col = "wage", binwidth = 0.1), "whole number")
  expect_error(compute_percentile(df, measure_col = "wage", binwidth = 0), "whole number")
  expect_error(compute_percentile(df, measure_col = "wage", binwidth = NA), "whole number")

  # rescaling the measure gives exact bins instead
  df$wage_tenths <- round(df$wage * 10)
  out <- compute_percentile(df, measure_col = "wage_tenths", binwidth = 1)
  expect_equal(out$bin, c(1, 2, 3))
  expect_equal(out$count, c(1, 1, 2))
})

test_that("compute_percentile keeps missing groups, drops missing measures and errors when nothing is left", {
  df <- data.frame(
    dept = c("A", "A", NA, "B"),
    wage = c(1, NA, 2, 4)
  )

  out <- compute_percentile(df, measure_col = "wage", group_cols = "dept")

  # every group, including NA, spans the same bins across the whole range
  expect_equal(nrow(out), 3 * 4)
  expect_true(any(is.na(out$dept)))
  expect_equal(sum(out$count), 3)
  totals <- tapply(out$pct, addNA(out$dept), sum)
  expect_equal(as.numeric(totals), c(1, 1, 1))

  expect_error(
    compute_percentile(data.frame(wage = c(NA_real_, NA_real_)), measure_col = "wage"),
    "no non-missing values"
  )
  expect_error(
    compute_percentile(
      data.frame(ref_date = as.Date(c("2020-01-01", NA)), wage = c(1, 2)),
      measure_col = "wage",
      latest_measure = TRUE
    ),
    NA
  )
})

# ---- compute_percentile: default binwidth ------------------------------------

# skewed pay, like real salaries, over two reference dates
set.seed(2)
skewed_wages <- data.frame(
  ref_date = as.Date(rep(c("2020-01-01", "2021-01-01"), each = 2000)),
  wage = round(c(rlnorm(2000, 7, 0.6), rlnorm(2000, 8, 0.6)))
)

# width of the bins compute_percentile() used
bin_width <- function(out) unique(diff(sort(unique(out$bin))))

test_that("compute_percentile estimates binwidth when it is not given", {
  out <- compute_percentile(skewed_wages, measure_col = "wage")

  expect_equal(bin_width(out), estimate_binwidth(skewed_wages, "wage"))
})

test_that("compute_percentile uses a given binwidth over the estimate", {
  out <- compute_percentile(skewed_wages, measure_col = "wage", binwidth = 250)

  expect_equal(bin_width(out), 250)
})

test_that("compute_percentile estimates binwidth from the latest date only", {
  out <- compute_percentile(skewed_wages, measure_col = "wage", latest_measure = TRUE)
  latest <- skewed_wages[skewed_wages$ref_date == max(skewed_wages$ref_date), ]

  expect_equal(bin_width(out), estimate_binwidth(latest, "wage"))
})

test_that("compute_percentile estimates the same binwidth on a database table", {
  skip_if_not_installed("duckdb")
  skip_if_not_installed("dbplyr")

  # silence duckdb's notice about where it stores extensions
  con <- suppressMessages(DBI::dbConnect(duckdb::duckdb()))
  on.exit(DBI::dbDisconnect(con, shutdown = TRUE))
  DBI::dbWriteTable(con, "wages", skewed_wages)

  out <- compute_percentile(dplyr::tbl(con, "wages"), measure_col = "wage") |>
    dplyr::collect()

  expect_equal(bin_width(out), estimate_binwidth(skewed_wages, "wage"))
})
