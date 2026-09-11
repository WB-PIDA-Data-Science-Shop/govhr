
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