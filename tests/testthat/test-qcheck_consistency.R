# The data.frame and tbl_dbi methods must agree. The last test also checks
# compute_global_coverage() on a database table.

# a has two records on 2020-01-01; b moves from unit A to B and changes value;
# c changes value
consistency_panel <- data.frame(
  id = c("a", "a", "b", "c", "a", "b", "c"),
  ref_date = as.Date(c(rep("2020-01-01", 4), rep("2021-01-01", 3))),
  unit = c("A", "A", "A", "B", "A", "B", "B"),
  value = c(1, 1, 2, 3, 1, 5, 4)
)

test_that("compute_record_consistency gives the share of single records", {
  # 5 of the 6 identifier-dates have a single record
  overall <- compute_record_consistency(consistency_panel, id_col = "id")
  expect_equal(names(overall), "record_consistency")
  expect_equal(overall[["record_consistency"]], round(5 / 6 * 100, 2))

  by_date <- compute_record_consistency(
    consistency_panel,
    id_col = "id",
    group_cols = "ref_date"
  )
  expect_equal(by_date[["record_consistency"]], c(round(2 / 3 * 100, 2), 100))

  by_unit <- compute_record_consistency(
    consistency_panel,
    id_col = "id",
    group_cols = "unit"
  )
  expect_equal(by_unit[["unit"]], c("A", "B"))
  expect_equal(by_unit[["record_consistency"]], c(round(2 / 3 * 100, 2), 100))
})

test_that("compute_value_consistency gives the share of single values", {
  # only a keeps one value across dates
  overall <- compute_value_consistency(
    consistency_panel,
    id_col = "id",
    value_col = "value"
  )
  expect_equal(overall[["value_consistency"]], round(1 / 3 * 100, 2))

  # within a date, everyone has one value
  by_date <- compute_value_consistency(
    consistency_panel,
    id_col = "id",
    value_col = "value",
    group_cols = "ref_date"
  )
  expect_equal(by_date[["value_consistency"]], c(100, 100))

  # in unit B, c has two values and b one
  by_unit <- compute_value_consistency(
    consistency_panel,
    id_col = "id",
    value_col = "value",
    group_cols = "unit"
  )
  expect_equal(by_unit[["value_consistency"]], c(100, 50))
})

test_that("compute_value_consistency counts a missing value as a value", {
  hr <- data.frame(id = c("a", "a"), value = c(1, NA))

  result <- compute_value_consistency(hr, id_col = "id", value_col = "value")

  expect_equal(result[["value_consistency"]], 0)
})

test_that("compute_global_consistency averages record and value consistency", {
  result <- compute_global_consistency(
    consistency_panel,
    id_col = "id",
    value_cols = "value"
  )

  expect_equal(result, round(mean(c(5 / 6, 1 / 3)) * 100, 2))
})

test_that("plot_consistency_trend draws the chosen consistency", {
  consistency <- compute_value_consistency(
    consistency_panel,
    id_col = "id",
    value_col = "value",
    group_cols = c("unit", "ref_date")
  )

  plot <- plot_consistency_trend(consistency, group_col = "unit", type_plot = "value")
  plotted <- ggplot2::ggplot_build(plot)[["data"]][[1]]

  expect_setequal(plotted[["y"]], consistency[["value_consistency"]])
  expect_error(plot_consistency_trend(consistency, type_plot = "other"))
})

test_that("plot_consistency_heatmap draws stacked value consistency", {
  consistency <- c("unit", "value") |>
    purrr::map(
      \(value_col) {
        compute_value_consistency(
          consistency_panel,
          id_col = "id",
          value_col = value_col,
          group_cols = "ref_date"
        ) |>
          dplyr::mutate(variable = value_col)
      }
    ) |>
    dplyr::bind_rows()

  plot <- plot_consistency_heatmap(consistency)

  expect_s3_class(plot, "plotly")
  expect_no_error(plotly::plotly_build(plot))
})

test_that("the consistency functions give the same result on a database table", {
  skip_if_not_installed("dbplyr")
  skip_if_not_installed("duckdb")

  # a missing identifier, unit and value are each kept as their own value
  hr <- rbind(
    consistency_panel,
    data.frame(
      id = c(NA, "d", "d"),
      ref_date = as.Date("2021-01-01"),
      unit = c("A", NA, NA),
      value = c(1, NA, 2)
    )
  )

  con <- DBI::dbConnect(duckdb::duckdb())
  remote <- dplyr::copy_to(con, hr, "consistency_panel")

  for (group_cols in list(NULL, "ref_date", "unit", c("unit", "ref_date"))) {
    expected <- compute_record_consistency(hr, "id", group_cols = group_cols) |>
      dplyr::arrange(dplyr::across(dplyr::all_of(group_cols))) |>
      as.data.frame()
    result <- compute_record_consistency(remote, "id", group_cols = group_cols) |>
      dplyr::collect() |>
      dplyr::arrange(dplyr::across(dplyr::all_of(group_cols))) |>
      as.data.frame()
    expect_equal(result, expected, ignore_attr = TRUE)

    expected <- compute_value_consistency(hr, "id", "value", group_cols = group_cols) |>
      dplyr::arrange(dplyr::across(dplyr::all_of(group_cols))) |>
      as.data.frame()
    result <- compute_value_consistency(remote, "id", "value", group_cols = group_cols) |>
      dplyr::collect() |>
      dplyr::arrange(dplyr::across(dplyr::all_of(group_cols))) |>
      as.data.frame()
    expect_equal(result, expected, ignore_attr = TRUE)
  }

  expect_equal(
    compute_global_consistency(remote, "id", value_cols = c("unit", "value")),
    compute_global_consistency(hr, "id", value_cols = c("unit", "value"))
  )
  expect_equal(compute_global_coverage(remote), compute_global_coverage(hr))

  # a lazy table straight from the database is collected before plotting
  lazy_trend <- compute_record_consistency(
    remote,
    "id",
    group_cols = c("unit", "ref_date")
  )
  expect_no_error(
    ggplot2::ggplot_build(plot_consistency_trend(lazy_trend, group_col = "unit"))
  )

  DBI::dbDisconnect(con, shutdown = TRUE)
})
