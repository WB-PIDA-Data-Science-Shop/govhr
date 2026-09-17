# tests/testthat/test-ggplot_point_line.R
library(testthat)
library(ggplot2)

test_that("ggplot_point_line returns a ggplot object", {
  df <- tibble(
    year = c(2020, 2021, 2022),
    value = c(10, 15, 12)
  )

  p <- ggplot_point_line(df, x = year, y = value)

  expect_s3_class(p, "ggplot")
})

test_that("ggplot_point_line includes geom_line and geom_point layers", {
  df <- tibble(
    year = c(2020, 2021, 2022),
    value = c(10, 15, 12)
  )

  p <- ggplot_point_line(df, x = year, y = value)

  layer_classes <- sapply(p$layers, function(l) class(l$geom)[1])
  expect_true("GeomLine" %in% layer_classes)
  expect_true("GeomPoint" %in% layer_classes)
})

test_that("ggplot_point_line adds labels when 'label' argument is used", {
  df <- tibble(
    year = c(2020, 2021, 2022),
    value = c(10, 15, 12)
  )

  p <- ggplot_point_line(df, x = year, y = value, label = year)

  layer_classes <- sapply(p$layers, function(l) class(l$geom)[1])
  expect_true("GeomTextRepel" %in% layer_classes)
})

test_that("ggplot_point_line applies color grouping when 'group' argument is used", {
  df <- tibble(
    year = rep(2020:2022, 2),
    value = c(10, 15, 12, 8, 10, 9),
    group_var = rep(c("A", "B"), each = 3)
  )

  p <- ggplot_point_line(df, x = year, y = value, group_col = group_var)
  mapping <- ggplot2::ggplot_build(p)$plot$mapping

  expect_true("colour" %in% names(mapping))
  expect_equal(as_label(mapping$colour), "group_var")
})

test_that("ggplot_point_line works when both group and label are specified", {
  df <- tibble(
    year = rep(2020:2022, 2),
    value = c(10, 15, 12, 8, 10, 9),
    group_var = rep(c("A", "B"), each = 3)
  )

  p <- ggplot_point_line(df, x = year, y = value, group_col = group_var, label = year)

  expect_s3_class(p, "ggplot")
  layer_classes <- sapply(p$layers, function(l) class(l$geom)[1])
  expect_true(all(c("GeomLine", "GeomPoint", "GeomTextRepel") %in% layer_classes))
})
