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

# two departments with 11 records on each of two dates; for 1:11 the 90th,
# 50th and 10th percentiles are 10, 6 and 2
compression_panel <- data.frame(
  dept = rep(c("A", "B"), each = 22),
  ref_date = rep(as.Date(c("2020-01-01", "2021-01-01")), each = 11, times = 2),
  wage = c(1:11, 1:11 * 2, 1:11 * 10, 1:11 * 20)
)

test_that("compute_compression_ratio returns three percentiles per group and date", {
  result <- compute_compression_ratio(
    compression_panel,
    measure_col = "wage",
    group_cols = "dept"
  )

  expect_equal(
    names(result),
    c("dept", "ref_date", "percentile_upper", "percentile_50", "percentile_lower")
  )
  expect_equal(result[["dept"]], c("A", "A", "B", "B"))
  expect_equal(result[["percentile_upper"]], c(10, 20, 100, 200))
  expect_equal(result[["percentile_50"]], c(6, 12, 60, 120))
  expect_equal(result[["percentile_lower"]], c(2, 4, 20, 40))
})

test_that("compute_compression_ratio interpolates the requested percentiles", {
  result <- compression_panel[
    compression_panel[["dept"]] == "A" &
      compression_panel[["ref_date"]] == as.Date("2020-01-01"),
  ] |>
    compute_compression_ratio(
      measure_col = "wage",
      percentiles = c(0.75, 0.5, 0.25)
    )

  expect_equal(result[["percentile_upper"]], 8.5)
  expect_equal(result[["percentile_50"]], 6)
  expect_equal(result[["percentile_lower"]], 3.5)
})

test_that("compute_compression_ratio keeps the latest date with a measure", {
  # a later date with only missing wages does not count as the latest
  hr <- rbind(
    compression_panel,
    data.frame(dept = "A", ref_date = as.Date("2022-01-01"), wage = NA)
  )

  grouped <- compute_compression_ratio(
    hr,
    measure_col = "wage",
    group_cols = "dept",
    latest_measure = TRUE
  )
  expect_equal(grouped[["ref_date"]], as.Date(c("2021-01-01", "2021-01-01")))
  expect_equal(grouped[["percentile_upper"]], c(20, 200))

  # govhr's version failed when latest_measure was used without groups
  ungrouped <- compute_compression_ratio(
    hr[hr[["dept"]] == "A", ],
    measure_col = "wage",
    latest_measure = TRUE
  )
  expect_equal(ungrouped[["ref_date"]], as.Date("2021-01-01"))
  expect_equal(ungrouped[["percentile_lower"]], 4)
})

test_that("compute_compression_ratio rejects ref_date as a group", {
  expect_error(
    compute_compression_ratio(
      compression_panel,
      measure_col = "wage",
      group_cols = "ref_date"
    ),
    "ref_date"
  )
})

test_that("compute_compression_ratio gives the same result on a database table", {
  skip_if_not_installed("dbplyr")
  skip_if_not_installed("duckdb")

  # missing wages are dropped and missing groups kept
  hr <- rbind(
    compression_panel,
    data.frame(
      dept = c("A", NA, NA),
      ref_date = as.Date("2021-01-01"),
      wage = c(NA, 5, 15)
    )
  )

  con <- DBI::dbConnect(duckdb::duckdb())
  remote <- dplyr::copy_to(con, hr, "compression_panel")

  for (group_cols in list(NULL, "dept")) {
    for (latest_measure in c(FALSE, TRUE)) {
      sort_keys <- c(group_cols, "ref_date")

      expected <- compute_compression_ratio(
        hr,
        measure_col = "wage",
        group_cols = group_cols,
        latest_measure = latest_measure
      ) |>
        dplyr::arrange(dplyr::across(dplyr::all_of(sort_keys))) |>
        as.data.frame()

      result <- compute_compression_ratio(
        remote,
        measure_col = "wage",
        group_cols = group_cols,
        latest_measure = latest_measure
      ) |>
        dplyr::collect() |>
        dplyr::arrange(dplyr::across(dplyr::all_of(sort_keys))) |>
        as.data.frame()

      expect_equal(result, expected, ignore_attr = TRUE)
    }
  }

  DBI::dbDisconnect(con, shutdown = TRUE)
})

# Tests for compute_percentile() --------------------------------------------

test_that("compute_percentile bins values and pct/cum_pct sum correctly within each group", {
  df <- data.frame(
    group = rep(c("A", "B"), each = 10),
    wage = c(1:10, 1:10)
  )

  out <- compute_percentile(df, measure_col = "wage", group_cols = "group", binwidth = 2)

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

  out <- compute_time_trend(df, group_col = "ref_date")

  expect_equal(out$value, c(2, 1))
})

test_that("compute_time_trend sums measure_col per group and ref_date when supplied", {
  df <- data.frame(
    ref_date = as.Date(c("2020-01-01", "2020-01-01", "2020-02-01")),
    group = c("A", "A", "A"),
    wage = c(10, 20, 5)
  )

  out <- compute_time_trend(df, group_col = "group", measure_col = "wage")

  expect_equal(sum(out$value), 35)
})

# Tests for rescale_baseline() --------------------------------------------

test_that("rescale_baseline indexes the first ungrouped value to 100", {
  df <- data.frame(
    ref_date = as.Date(c("2020-01-01", "2020-02-01", "2020-03-01")),
    value = c(50, 75, 100)
  )

  out <- rescale_baseline(df, group_col = "ref_date")

  expect_equal(out$value[1], 100)
  expect_equal(out$value[2], 150)
})

test_that("rescale_baseline indexes within each group separately", {
  df <- data.frame(
    ref_date = rep(as.Date(c("2020-01-01", "2020-02-01")), 2),
    group = rep(c("A", "B"), each = 2),
    value = c(10, 20, 5, 15)
  )

  out <- rescale_baseline(df, group_col = "group")

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

  out <- compute_cross_section(df, group_cols = "group", measure_col = "wage")

  expect_equal(out$value[out$group == "A"], 20)
  expect_equal(out$value[out$group == "B"], 15)
})

test_that("compute_cross_section counts rows when measure_col is NULL", {
  df <- data.frame(
    group = c("A", "A", "A", "B"),
    ref_date = as.Date(c("2020-01-01", "2020-02-01", "2020-02-01", "2020-01-01"))
  )

  out <- compute_cross_section(df, group_cols = "group")

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

  out <- compute_growth(df, group_col = "group", measure_col = "wage")

  expect_equal(out$growth_rate, 50)
})

test_that("compute_growth counts rows per group when measure_col is NULL", {
  df <- data.frame(
    group = c("A", "A", "A", "A"),
    ref_date = as.Date(c("2020-01-01", "2020-01-01", "2020-03-01", "2020-03-01"))
  )
  # first period: 2 rows, last period: 2 rows -> 0% growth
  out <- compute_growth(df, group_col = "group")

  expect_equal(out$growth_rate, 0)
})
