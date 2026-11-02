# ---- scale_plot_height --------------------------------------------------------

test_that("scale_plot_height grows with the number of rows, never below 350", {
  expect_equal(scale_plot_height(data.frame(x = 1:10)), 450)
  expect_equal(scale_plot_height(data.frame(x = 1:20)), 800)
  expect_equal(scale_plot_height(data.frame(x = integer(0))), 350)
  expect_equal(scale_plot_height(data.frame(x = 1)), 350)
})

# ---- "no grouping" convention -------------------------------------------------
# Module sidebars pass input$group_filter straight through, and its "All" option
# is the string "ref_date", never NULL, so every plot helper must treat it as
# no grouping, even when the data has no ref_date column.

test_that("grouped plot helpers accept ref_date without a ref_date column", {
  trend <- tibble::tibble(ref_date = as.Date(c("2020-01-01", "2021-01-01")), value = c(10, 20))
  deciles <- tibble::tibble(decile = 1:10, mean_value = seq(100, 1000, by = 100))
  compression <- tibble::tibble(
    ref_date = as.Date(c("2020-01-01", "2021-01-01")),
    percentile_lower = c(1, 1.1),
    percentile_50 = c(2, 2.1),
    percentile_upper = c(3, 3.1)
  )

  expect_no_error(plot_trend(trend, group_col = "ref_date"))
  expect_no_error(plot_decile(deciles, group_col = "ref_date"))
  expect_no_error(plot_compression_ratio(compression, group_col = "ref_date"))
})

# ---- plot_change and plot_area --------------------------------------------------

growth <- data.frame(
  ref_date = as.Date(rep(c("2020-01-01", "2021-01-01", "2022-01-01"), times = 2)),
  unit = rep(c("A", "B"), each = 3),
  wage_growth = c(NA, 0.05, -0.02, NA, -0.01, 0.03)
)

test_that("plot_change colours bars by sign and leaves out missing changes", {
  plot <- plot_change(growth, x_col = "ref_date", y_col = "wage_growth", group_cols = "unit")

  # the first date has nothing to change from
  expect_equal(plot$data$wage_growth, c(0.05, -0.02, -0.01, 0.03))
  expect_equal(plot$data$change_sign, c("positive", "negative", "negative", "positive"))
  expect_s3_class(plot$facet, "FacetWrap")

  expect_error(
    plot_change(growth, x_col = "ref_date", y_col = "wage_growth", group_cols = "paygrade"),
    "`group_cols` not found in data: paygrade"
  )
})

test_that("plot_area stacks one area per fill value, or a single area", {
  headcount <- data.frame(
    ref_date = as.Date(rep(c("2020-01-01", "2021-01-01"), each = 2)),
    contract_type = rep(c("permanent", "temporary"), times = 2),
    headcount = c(80, 20, 85, 25)
  )

  stacked <- ggplot2::ggplot_build(
    plot_area(headcount, y_col = "headcount", fill_col = "contract_type")
  )
  expect_equal(length(unique(stacked$data[[1]]$fill)), 2L)
  # the second area sits on top of the first
  expect_equal(max(stacked$data[[1]]$ymax), 85 + 25)

  single <- ggplot2::ggplot_build(plot_area(headcount, y_col = "headcount"))
  expect_equal(length(unique(single$data[[1]]$fill)), 1L)
})
