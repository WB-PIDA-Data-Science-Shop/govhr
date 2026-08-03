# Tests for compute_quantile() ------------------------------------------

test_that("compute_quantile assigns deciles within groups and reports correct median/mean", {
  set.seed(1)
  df <- data.frame(
    group = rep(c("A", "B"), each = 100),
    ref_date = as.Date("2020-01-01"),
    wage = c(1:100, 101:200)
  )

  out <- compute_quantile(
    df,
    group_cols = "group",
    measure_col = "wage",
    n_quantiles = 10
  )

  # 10 deciles per group per ref_date
  expect_equal(nrow(out), 20)
  expect_true(all(out$decile %in% 1:10))

  # group A's decile 1 should hold the lowest wages (1:10), decile 10 the highest (91:100)
  a_d1 <- out[out$group == "A" & out$decile == 1, ]
  expect_equal(a_d1$median_value, median(1:10))
})

test_that("compute_quantile with latest_measure = TRUE filters to max ref_date before computing deciles", {
  df <- data.frame(
    group = "A",
    ref_date = rep(as.Date(c("2020-01-01", "2020-02-01")), each = 20),
    wage = c(rep(1, 20), 1:20)
  )

  out <- compute_quantile(
    df,
    group_cols = "group",
    measure_col = "wage",
    latest_measure = TRUE,
    n_quantiles = 4
  )

  # only the 2020-02-01 slice (varying wages) should produce real quantile splits
  expect_equal(nrow(out), 4)
  expect_false("ref_date" %in% names(out))
})

# Tests for compute_compression_ratio() ----------------------------------

test_that("compute_compression_ratio returns the requested percentiles per group/ref_date", {
  df <- data.frame(
    group = rep("A", 100),
    ref_date = as.Date("2020-01-01"),
    wage = 1:100
  )

  out <- compute_compression_ratio(
    df,
    group_cols = "group",
    percentiles = c(0.9, 0.5, 0.1),
    measure_col = "wage"
  )

  expect_equal(nrow(out), 1)
  expect_true(out$percentile_upper > out$percentile_50)
  expect_true(out$percentile_50 > out$percentile_lower)
})

# Tests for compute_density() --------------------------------------------

test_that("compute_density bins values and pct/cum_pct sum correctly within each group", {
  df <- data.frame(
    group = rep(c("A", "B"), each = 10),
    wage = c(1:10, 1:10)
  )

  out <- compute_density(df, group_col = "group", measure_col = "wage", binwidth = 2)

  # pct should sum to 1 within each group
  totals <- tapply(out$pct, out$group, sum)
  expect_equal(as.numeric(totals), c(1, 1), tolerance = 1e-8)

  # cum_pct should be non-decreasing and end at 1 within each group
  last_cum <- tapply(out$cum_pct, out$group, max)
  expect_equal(as.numeric(last_cum), c(1, 1), tolerance = 1e-8)
})

# Tests for compute_time_trend() ------------------------------------------

test_that("compute_time_trend counts rows per period when measure_col is NULL", {
  df <- data.frame(
    ref_date = as.Date(c("2020-01-01", "2020-01-01", "2020-02-01")),
    group = c("A", "A", "A")
  )

  out <- compute_time_trend(df, group = "ref_date")

  expect_equal(out$value, c(2, 1))
})

test_that("compute_time_trend sums measure_col per group and ref_date when supplied", {
  df <- data.frame(
    ref_date = as.Date(c("2020-01-01", "2020-01-01", "2020-02-01")),
    group = c("A", "A", "A"),
    wage = c(10, 20, 5)
  )

  out <- compute_time_trend(df, group = "group", measure_col = "wage")

  expect_equal(sum(out$value), 35)
})

# Tests for rescale_baseline() --------------------------------------------

test_that("rescale_baseline indexes the first ungrouped value to 100", {
  df <- data.frame(
    ref_date = as.Date(c("2020-01-01", "2020-02-01", "2020-03-01")),
    value = c(50, 75, 100)
  )

  out <- rescale_baseline(df, group = "ref_date")

  expect_equal(out$value[1], 100)
  expect_equal(out$value[2], 150)
})

test_that("rescale_baseline indexes within each group separately", {
  df <- data.frame(
    ref_date = rep(as.Date(c("2020-01-01", "2020-02-01")), 2),
    group = rep(c("A", "B"), each = 2),
    value = c(10, 20, 5, 15)
  )

  out <- rescale_baseline(df, group = "group")

  expect_equal(out$value[out$group == "A"], c(100, 200))
  expect_equal(out$value[out$group == "B"], c(100, 300))
})

# Tests for compute_cross_section() ---------------------------------------

test_that("compute_cross_section filters to the latest ref_date per group and sums measure_col", {
  df <- data.frame(
    group = c("A", "A", "B", "B"),
    ref_date = as.Date(c("2020-01-01", "2020-02-01", "2020-01-01", "2020-02-01")),
    wage = c(10, 20, 5, 15)
  )

  out <- compute_cross_section(df, group = "group", measure_col = "wage")

  expect_equal(out$value[out$group == "A"], 20)
  expect_equal(out$value[out$group == "B"], 15)
})

test_that("compute_cross_section counts rows when measure_col is NULL", {
  df <- data.frame(
    group = c("A", "A", "A", "B"),
    ref_date = as.Date(c("2020-01-01", "2020-02-01", "2020-02-01", "2020-01-01"))
  )

  out <- compute_cross_section(df, group = "group")

  expect_equal(out$value[out$group == "A"], 2)
  expect_equal(out$value[out$group == "B"], 1)
})

# Tests for compute_growth() ----------------------------------------------

test_that("compute_growth computes percentage change from first to last ref_date", {
  df <- data.frame(
    group = rep("A", 3),
    ref_date = as.Date(c("2020-01-01", "2020-02-01", "2020-03-01")),
    wage = c(100, 110, 150)
  )

  out <- compute_growth(df, group = "group", measure_col = "wage")

  expect_equal(out$growth_rate, 50)
})

test_that("compute_growth counts rows per group when measure_col is NULL", {
  df <- data.frame(
    group = c("A", "A", "A", "A"),
    ref_date = as.Date(c("2020-01-01", "2020-01-01", "2020-03-01", "2020-03-01"))
  )
  # first period: 2 rows, last period: 2 rows -> 0% growth
  out <- compute_growth(df, group = "group")

  expect_equal(out$growth_rate, 0)
})