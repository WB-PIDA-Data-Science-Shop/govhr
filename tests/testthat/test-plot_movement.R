# ---- plot_movement -----------------------------------------------------------

# 2021: 3 and 4 join and 2 leaves. 2022: 4 leaves. so net movement is +1 then
# -1, and both colours of bar appear
movement_hr <- data.frame(
  personnel_id = c(1, 2, 1, 3, 4, 1, 3),
  ref_date = as.Date(c(
    "2020-01-01", "2020-01-01",
    "2021-01-01", "2021-01-01", "2021-01-01",
    "2022-01-01", "2022-01-01"
  )),
  gender = c("F", "M", "F", "M", "F", "F", "M"),
  employment_status = "active"
)

layer_geoms <- function(plot) {
  vapply(plot$layers, \(layer) class(layer$geom)[[1]], character(1))
}

test_that("plot_movement draws each movement type from the matching columns", {
  movement <- compute_movement(movement_hr)

  hire_count <- plot_movement(movement)
  expect_equal(hire_count$data$value, c(2, 0))
  expect_equal(hire_count$labels$y, "Hires")

  separation_rate <- plot_movement(
    movement,
    movement_type = "separation",
    measurement_type = "rate"
  )
  expect_equal(separation_rate$data$value, c(1 / 2, 1 / 3))
  expect_equal(separation_rate$labels$y, "Separation rate")

  # both movements as two lines, coloured by movement
  joint <- plot_movement(movement, movement_type = "joint")
  expect_equal(joint$data$movement, rep(c("hire", "separation"), each = 2))
  expect_equal(rlang::as_label(joint$mapping$colour), "movement")

  # one bar per date, coloured by its sign
  net_rate <- plot_movement(movement, movement_type = "net", measurement_type = "rate")
  expect_equal(net_rate$data$value, c(1 - 1 / 2, 0 - 1 / 3))
  expect_equal(net_rate$data$movement, c("hire", "separation"))
  expect_true("GeomCol" %in% layer_geoms(net_rate))
})

test_that("plot_movement leaves out dates without movements to compare with", {
  movement <- compute_movement(movement_hr)

  # the first date has no previous date, so its hires are NA
  expect_equal(plot_movement(movement)$data$ref_date, as.Date(c("2021-01-01", "2022-01-01")))
  expect_equal(
    plot_movement(movement, movement_type = "net")$data$ref_date,
    as.Date(c("2021-01-01", "2022-01-01"))
  )
})

test_that("plot_movement colours groups for one movement and facets them for two", {
  movement <- compute_movement(movement_hr, group_cols = "gender")

  grouped <- plot_movement(movement, group_col = "gender")
  expect_equal(rlang::as_label(grouped$mapping$colour), "gender")
  expect_s3_class(grouped$facet, "FacetNull")
  expect_null(plot_movement(movement, group_col = "ref_date")$mapping$colour)

  # colour already tells hires from separations, so groups get panels
  joint <- plot_movement(movement, movement_type = "joint", group_col = "gender")
  expect_equal(rlang::as_label(joint$mapping$colour), "movement")
  expect_s3_class(joint$facet, "FacetWrap")
  # panels share one y-axis, counts included, so groups can be compared
  expect_false(joint$facet$params$free$y)

  net <- plot_movement(movement, movement_type = "net", group_col = "gender")
  expect_s3_class(net$facet, "FacetWrap")
})

test_that("plot_movement rejects unknown movement types", {
  movement <- compute_movement(movement_hr)

  expect_error(plot_movement(movement, movement_type = "fire"), "should be one of")
  expect_error(plot_movement(movement, group_col = c("a", "b")), "`group_col` must be a single column")
})

test_that("plot_movement still takes the deprecated group_cols", {
  movement <- compute_movement(movement_hr, group_cols = "gender")

  lifecycle::expect_deprecated(
    grouped <- plot_movement(movement, group_cols = "gender"),
    "use the `group_col` argument"
  )
  expect_equal(rlang::as_label(grouped$mapping$colour), "gender")
})
