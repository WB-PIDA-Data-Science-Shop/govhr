# Tests for compute_decile() ----------------------------------------------

# two departments, each with 20 records on each of two dates, so every decile
# holds two records
decile_panel <- data.frame(
  dept = rep(c("A", "B"), each = 40),
  ref_date = rep(as.Date(c("2020-01-01", "2021-01-01")), each = 20, times = 2),
  wage = c(1:20, 21:40, 1:20 * 10, 21:40 * 10)
)

test_that("compute_decile splits each group and date into ten deciles", {
  result <- compute_decile(decile_panel, measure_col = "wage", group_cols = "dept")

  expect_equal(
    names(result),
    c("dept", "ref_date", "decile", "median_value", "mean_value")
  )
  expect_equal(nrow(result), 2L * 2L * 10L)

  a_2020 <- result[
    result[["dept"]] == "A" & result[["ref_date"]] == as.Date("2020-01-01"),
  ]
  expect_equal(a_2020[["decile"]], 1:10)
  # decile k holds 2k - 1 and 2k
  expect_equal(a_2020[["median_value"]], seq(1.5, 19.5, by = 2))
  expect_equal(a_2020[["mean_value"]], seq(1.5, 19.5, by = 2))

  # ranked within the department, not across them
  b_2020 <- result[
    result[["dept"]] == "B" & result[["ref_date"]] == as.Date("2020-01-01"),
  ]
  expect_equal(b_2020[["median_value"]][1], 15)
})

test_that("compute_decile drops missing measures before ranking", {
  hr <- data.frame(
    ref_date = as.Date("2020-01-01"),
    wage = c(30, NA, 10, 20, NA)
  )

  result <- compute_decile(hr, measure_col = "wage")

  # three records fill only the first three deciles
  expect_equal(result[["decile"]], 1:3)
  expect_equal(result[["median_value"]], c(10, 20, 30))
})

test_that("compute_decile keeps the latest date across all groups", {
  result <- compute_decile(
    decile_panel,
    measure_col = "wage",
    group_cols = "dept",
    latest_measure = TRUE
  )

  expect_false("ref_date" %in% names(result))
  expect_equal(nrow(result), 2L * 10L)
  # only the 2021 records: 21 to 40 in A
  expect_equal(
    result[result[["dept"]] == "A", ][["median_value"]],
    seq(21.5, 39.5, by = 2)
  )
})

test_that("compute_decile leaves a data.table passed in unchanged", {
  dt <- data.table::as.data.table(decile_panel)

  compute_decile(dt, measure_col = "wage")

  expect_named(dt, names(decile_panel))
})

test_that("compute_decile rejects ref_date as a group", {
  expect_error(
    compute_decile(decile_panel, measure_col = "wage", group_cols = "ref_date"),
    "ref_date"
  )
})

test_that("compute_decile gives the same result on a database table", {
  skip_if_not_installed("dbplyr")
  skip_if_not_installed("duckdb")

  # ties straddle decile boundaries, and missing wages and groups are kept
  tied_panel <- rbind(
    transform(decile_panel, wage = wage %/% 3 * 3),
    data.frame(
      dept = c("A", NA),
      ref_date = as.Date("2021-01-01"),
      wage = c(NA, 50)
    )
  )

  con <- DBI::dbConnect(duckdb::duckdb())
  remote <- dplyr::copy_to(con, tied_panel, "tied_panel")

  for (group_cols in list(NULL, "dept")) {
    for (latest_measure in c(FALSE, TRUE)) {
      sort_keys <- c(group_cols, if (!latest_measure) "ref_date", "decile")

      expected <- compute_decile(
        tied_panel,
        measure_col = "wage",
        group_cols = group_cols,
        latest_measure = latest_measure
      ) |>
        dplyr::arrange(dplyr::across(dplyr::all_of(sort_keys))) |>
        as.data.frame()

      result <- compute_decile(
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

test_that("compute_decile ignores a missing ref_date when finding the latest date", {
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
