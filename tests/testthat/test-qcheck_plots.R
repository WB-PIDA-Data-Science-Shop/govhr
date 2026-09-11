qc_data <- tibble::tibble(
  ref_date = as.Date(rep(c("2020-01-01", "2021-01-01"), each = 4)),
  personnel_id = rep(1:4, times = 2),
  paygrade = rep(c("G1", "G1", "G2", "G2"), times = 2),
  salary = c(100, NA, 150, 200, 110, 130, NA, 210),
  birth_date = as.Date(c(
    "1990-01-01", "1990-01-01", "1985-06-01", "1985-06-01",
    "1990-01-01", "1990-01-02", "1985-06-01", "1985-06-01"
  ))
)

# ---- plot_coverage_trend ------------------------------------------------------

test_that("plot_coverage_trend returns a ggplot line trend over ref_date", {
  p <- plot_coverage_trend(qc_data, group = "ref_date")

  expect_s3_class(p, "ggplot")
  layer_geoms <- sapply(p$layers, \(l) class(l$geom)[1])
  expect_true("GeomLine" %in% layer_geoms)
})

test_that("plot_coverage_trend toggle_growth adds a baseline reference line", {
  p <- plot_coverage_trend(qc_data, group = "ref_date", toggle_growth = TRUE)

  layer_geoms <- sapply(p$layers, \(l) class(l$geom)[1])
  expect_true("GeomHline" %in% layer_geoms)
})

test_that("plot_coverage_trend accepts a real grouping column", {
  expect_no_error(plot_coverage_trend(qc_data, group = "paygrade"))
})

# ---- plot_consistency_trend ---------------------------------------------------

test_that("plot_consistency_trend plots record consistency over time", {
  record_consistency <- compute_record_consistency(qc_data, id_col = "personnel_id")

  p <- plot_consistency_trend(
    record_consistency,
    id_col = "personnel_id",
    group = "ref_date",
    value_col = NULL,
    type_plot = "record"
  )

  expect_s3_class(p, "ggplot")
})

test_that("plot_consistency_trend plots value consistency over time", {
  value_consistency <- compute_value_consistency(
    qc_data,
    id_col = "personnel_id",
    value_col = "birth_date"
  )

  p <- plot_consistency_trend(
    value_consistency,
    id_col = "personnel_id",
    group = "ref_date",
    value_col = "birth_date",
    type_plot = "value"
  )

  expect_s3_class(p, "ggplot")
})

test_that("plot_consistency_trend rejects an invalid type_plot", {
  record_consistency <- compute_record_consistency(qc_data, id_col = "personnel_id")

  expect_error(
    plot_consistency_trend(
      record_consistency,
      id_col = "personnel_id",
      group = "ref_date",
      value_col = NULL,
      type_plot = "not_a_type"
    ),
    "Invalid type_plot"
  )
})

# ---- plot_coverage_bar ---------------------------------------------------------

test_that("plot_coverage_bar returns a ggplot with a GeomCol layer", {
  p <- plot_coverage_bar(qc_data)

  expect_s3_class(p, "ggplot")
  layer_geoms <- sapply(p$layers, \(l) class(l$geom)[1])
  expect_true("GeomCol" %in% layer_geoms)
})

test_that("plot_coverage_bar tiers coverage into Low/Medium/High", {
  built <- ggplot2::ggplot_build(plot_coverage_bar(qc_data))
  tiers <- levels(built$plot$data$coverage_tier)

  expect_equal(tiers, c("Low (<50%)", "Medium (50-79%)", "High (>=80%)"))
})

# ---- plot_coverage_heatmap ------------------------------------------------------

test_that("plot_coverage_heatmap returns a plotly heatmap", {
  p <- plot_coverage_heatmap(qc_data, group = "ref_date")

  expect_s3_class(p, "plotly")
})

test_that("plot_coverage_heatmap treats NULL and 'none' group as ref_date", {
  expect_no_error(plot_coverage_heatmap(qc_data, group = NULL))
  expect_no_error(plot_coverage_heatmap(qc_data, group = "none"))
})

# ---- plot_consistency_heatmap ---------------------------------------------------

test_that("plot_consistency_heatmap returns a plotly heatmap", {
  p <- plot_consistency_heatmap(qc_data, id_col = "personnel_id", group = "ref_date")

  expect_s3_class(p, "plotly")
})
