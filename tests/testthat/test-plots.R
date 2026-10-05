
# ---- scale_plot_height --------------------------------------------------------

test_that("scale_plot_height grows with the number of rows", {
  expect_equal(scale_plot_height(data.frame(x = 1:10)), 450)
  expect_equal(scale_plot_height(data.frame(x = 1:20)), 800)
})

test_that("scale_plot_height never drops below 350", {
  expect_equal(scale_plot_height(data.frame(x = integer(0))), 350)
  expect_equal(scale_plot_height(data.frame(x = 1)), 350)
})

# ---- "no grouping" convention ------------------------------------------------
# Module sidebars pass input$group_filter straight through, and its "All" option
# is the string "ref_date", never NULL. Every plot helper must therefore treat
# "ref_date" as "no grouping" -- a helper that only checks for NULL tries to
# facet or colour by a column the summary frames need not carry.

binned <- tibble::tibble(
  bin = c(0, 100, 200, 0, 100, 200),
  count = c(3L, 5L, 2L, 1L, 4L, 6L),
  pct = c(0.3, 0.5, 0.2, 0.1, 0.4, 0.6),
  cum_pct = c(0.3, 0.8, 1.0, 0.1, 0.5, 1.0),
  paygrade = rep(c("G1", "G2"), each = 3)
)

test_that("plot_histogram treats ref_date as no grouping", {
  # the cached percentile frame carries no ref_date column at all, so faceting
  # by it errored on the equity panel's first paint
  ungrouped <- binned[binned$paygrade == "G1", c("bin", "count", "pct", "cum_pct")]

  expect_no_error(plot_histogram(ungrouped, "histogram", group_col = "ref_date"))
  expect_no_error(plot_histogram(ungrouped, "cumulative", group_col = NULL))
})

test_that("plot_histogram facets when a real group is supplied", {
  built <- ggplot2::ggplot_build(
    ggplot2::ggplot(binned, ggplot2::aes(x = .data[["bin"]], y = .data[["pct"]])) +
      ggplot2::geom_col() +
      ggplot2::facet_wrap(ggplot2::vars(.data[["paygrade"]]))
  )
  expect_equal(nrow(built$layout$layout), 2L)

  expect_no_error(plot_histogram(binned, "histogram", group_col = "paygrade"))
})

test_that("grouped plot helpers accept ref_date without a ref_date column", {
  trend <- tibble::tibble(ref_date = as.Date(c("2020-01-01", "2021-01-01")), value = c(10, 20))
  deciles <- tibble::tibble(decile = 1:10, mean_value = seq(100, 1000, by = 100))
  compression <- tibble::tibble(
    ref_date = as.Date(c("2020-01-01", "2021-01-01")),
    percentile_lower = c(1, 1.1),
    percentile_50 = c(2, 2.1),
    percentile_upper = c(3, 3.1)
  )
  costs <- tibble::tibble(ref_date = as.Date("2020-01-01"), movement_cost = 500)

  expect_no_error(plot_trend(trend, group_col = "ref_date"))
  expect_no_error(plot_decile(deciles, group_col = "ref_date"))
  expect_no_error(plot_compression_ratio(compression, group_col = "ref_date"))
  expect_no_error(plot_movement_cost(costs, group_col = "ref_date"))
})
# ---- plot_movement -----------------------------------------------------------

movement_hr <- data.frame(
  personnel_id = c(1, 2, 1, 3, 1, 3),
  ref_date = as.Date(rep(c("2020-01-01", "2021-01-01", "2022-01-01"), each = 2)),
  gender = c("F", "M", "F", "M", "F", "M"),
  employment_status = "active"
)

test_that("plot_movement plots the column matching movement and measurement", {
  movement <- compute_movement(movement_hr)

  hire_count <- plot_movement(movement)
  separation_rate <- plot_movement(
    movement,
    movement_type = "separation",
    measurement_type = "rate"
  )

  expect_equal(rlang::as_label(hire_count$mapping$y), "hires")
  expect_equal(hire_count$labels$y, "Hires")
  expect_equal(rlang::as_label(separation_rate$mapping$y), "separation_rate")
  expect_equal(separation_rate$labels$y, "Separation rate")
})

test_that("plot_movement leaves out dates without hires to compare with", {
  plot <- plot_movement(compute_movement(movement_hr))

  # the first date has no previous date, so its hires are NA
  expect_equal(plot$data$ref_date, as.Date(c("2021-01-01", "2022-01-01")))
})

test_that("plot_movement draws one line per group", {
  movement <- compute_movement(movement_hr, group_cols = "gender")

  grouped <- plot_movement(movement, group_cols = "gender")

  expect_equal(rlang::as_label(grouped$mapping$colour), "gender")
  expect_null(plot_movement(movement, group_cols = "ref_date")$mapping$colour)
})

test_that("plot_movement rejects unknown movement types", {
  movement <- compute_movement(movement_hr)

  expect_error(plot_movement(movement, movement_type = "fire"), "should be one of")
  expect_error(plot_movement(movement, group_cols = c("a", "b")), "single column")
})

test_that("plot_movement accepts a lazy database table", {
  skip_if_not_installed("duckdb")
  skip_if_not_installed("dbplyr")

  # silence duckdb's notice about where it stores extensions
  con <- suppressMessages(DBI::dbConnect(duckdb::duckdb()))
  on.exit(DBI::dbDisconnect(con, shutdown = TRUE))
  DBI::dbWriteTable(con, "movement_hr", movement_hr)

  plot <- plot_movement(compute_movement(dplyr::tbl(con, "movement_hr")))

  expect_s3_class(plot, "ggplot")
  expect_equal(nrow(plot$data), 2L)
})
