test_data <- data.frame(
  ref_date = as.Date(c(
    "2020-01-01", "2020-01-01", "2021-01-01", "2021-01-01",
    "2022-01-01", "2022-01-01"
  )),
  group = c("A", "B", "A", "B", "A", "B"),
  salary = c(100, 200, 150, 250, 120, 300),
  stringsAsFactors = FALSE
)

# ---- plot_trend --------------------------------------------------------------

test_that("plot_trend returns a ggplot object", {
  summary <- compute_trend_summary(test_data, group_col = "ref_date")
  expect_s3_class(plot_trend(summary, group_col = "ref_date"), "ggplot")
})

test_that("plot_trend toggle_growth adds a hline layer", {
  summary <- compute_trend_summary(test_data, group_col = "ref_date")
  p <- plot_trend(summary, group_col = "ref_date", toggle_growth = TRUE)
  layer_geoms <- sapply(p$layers, \(l) class(l$geom)[1])
  expect_true("GeomHline" %in% layer_geoms)
})

# ---- plot_bar_total ----------------------------------------------------------

test_that("plot_bar_total returns a ggplot with a GeomCol layer", {
  cs <- compute_cross_section_summary(test_data, group_col = "group")
  p <- plot_bar_total(cs, group_col = "group", x_label = "Headcount")
  layer_geoms <- sapply(p$layers, \(l) class(l$geom)[1])
  expect_s3_class(p, "ggplot")
  expect_true("GeomCol" %in% layer_geoms)
})

# ---- plot_bar_growth ---------------------------------------------------------

test_that("plot_bar_growth returns a ggplot with a GeomVline layer at 0", {
  growth <- compute_growth(test_data, group_col = "group", measure_col = "salary")
  p <- plot_bar_growth(growth, group_col = "group")
  expect_s3_class(p, "ggplot")
  layer_geoms <- sapply(p$layers, \(l) class(l$geom)[1])
  expect_true("GeomVline" %in% layer_geoms)
})

