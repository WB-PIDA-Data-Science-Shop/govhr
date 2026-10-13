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

layer_geoms <- function(plot) {
  vapply(plot[["layers"]], \(layer) class(layer[["geom"]])[1], character(1))
}

# ---- plot_coverage_trend ------------------------------------------------------

test_that("plot_coverage_trend returns a ggplot line trend over ref_date", {
  coverage <- compute_coverage(qc_data, include_ref_date = TRUE, aggregate = TRUE)

  p <- plot_coverage_trend(coverage)

  expect_s3_class(p, "ggplot")
  expect_true("GeomLine" %in% layer_geoms(p))
})

test_that("plot_coverage_trend toggle_growth adds a baseline reference line", {
  coverage <- compute_coverage(qc_data, include_ref_date = TRUE, aggregate = TRUE)

  p <- plot_coverage_trend(coverage, toggle_growth = TRUE)

  expect_true("GeomHline" %in% layer_geoms(p))
})

test_that("plot_coverage_trend accepts a real grouping column", {
  coverage <- compute_coverage(
    qc_data,
    group_cols = "paygrade",
    include_ref_date = TRUE,
    aggregate = TRUE
  )

  expect_no_error(plot_coverage_trend(coverage, group_col = "paygrade"))
})

# ---- plot_consistency_trend ---------------------------------------------------

test_that("plot_consistency_trend plots record consistency over time", {
  record_consistency <- compute_record_consistency(
    qc_data,
    id_col = "personnel_id",
    group_cols = "ref_date"
  )

  p <- plot_consistency_trend(record_consistency, type_plot = "record")

  expect_s3_class(p, "ggplot")
})

test_that("plot_consistency_trend plots value consistency over time", {
  value_consistency <- compute_value_consistency(
    qc_data,
    id_col = "personnel_id",
    value_col = "birth_date",
    group_cols = "ref_date"
  )

  p <- plot_consistency_trend(value_consistency, type_plot = "value")

  expect_s3_class(p, "ggplot")
})

# ---- plot_coverage_bar ---------------------------------------------------------

test_that("plot_coverage_bar returns a ggplot with a GeomCol layer", {
  p <- plot_coverage_bar(compute_coverage(qc_data))

  expect_s3_class(p, "ggplot")
  expect_true("GeomCol" %in% layer_geoms(p))
})

test_that("plot_coverage_bar tiers coverage into Low/Medium/High", {
  built <- ggplot2::ggplot_build(plot_coverage_bar(compute_coverage(qc_data)))
  tiers <- levels(built[["plot"]][["data"]][["coverage_tier"]])

  expect_equal(tiers, c("Low (<50%)", "Medium (50-79%)", "High (>=80%)"))
})

# ---- plot_coverage_heatmap ------------------------------------------------------

test_that("plot_coverage_heatmap returns a plotly heatmap", {
  coverage <- compute_coverage(qc_data, group_cols = "ref_date")

  expect_s3_class(plot_coverage_heatmap(coverage), "plotly")
})

# ---- plot_consistency_heatmap ---------------------------------------------------

test_that("plot_consistency_heatmap returns a plotly heatmap", {
  consistency <- c("paygrade", "salary", "birth_date") |>
    purrr::map(
      \(value_col) {
        compute_value_consistency(
          qc_data,
          id_col = "personnel_id",
          value_col = value_col,
          group_cols = "ref_date"
        ) |>
          dplyr::mutate(variable = value_col)
      }
    ) |>
    dplyr::bind_rows()

  expect_s3_class(plot_consistency_heatmap(consistency), "plotly")
})
