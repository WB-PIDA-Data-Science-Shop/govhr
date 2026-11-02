test_data <- data.frame(
  ref_date = as.Date(c(
    "2020-01-01", "2020-01-01", "2021-01-01", "2021-01-01",
    "2022-01-01", "2022-01-01"
  )),
  group = c("A", "B", "A", "B", "A", "B"),
  salary = c(100, 200, 150, 250, 120, 300),
  stringsAsFactors = FALSE
)

# ---- compute_trend_summary ---------------------------------------------------

test_that("compute_trend_summary counts rows when measure_col is NULL", {
  result <- compute_trend_summary(test_data, group_col = "ref_date")
  expect_equal(names(result), c("ref_date", "value"))
  expect_equal(nrow(result), 3L)
  expect_true(all(result$value == 2))
})

test_that("compute_trend_summary sums measure_col when supplied", {
  result <- compute_trend_summary(test_data, group_col = "group", measure_col = "salary")
  expect_setequal(names(result), c("ref_date", "indicator", "group", "value"))
  expect_equal(result$value[result$group == "A" & result$ref_date == as.Date("2020-01-01")], 100)
})

# ---- apply_baseline_index ----------------------------------------------------

test_that("apply_baseline_index sets first period to 100 when ungrouped", {
  summary <- compute_trend_summary(test_data, group_col = "ref_date")
  result <- apply_baseline_index(summary, group_col = "ref_date")
  expect_equal(result$value[result$ref_date == min(result$ref_date)], 100)
})

test_that("apply_baseline_index rescales independently per group", {
  summary <- compute_trend_summary(test_data, group_col = "group", measure_col = "salary")
  result <- apply_baseline_index(summary, group_col = "group")
  first_vals <- result |>
    dplyr::group_by(group) |>
    dplyr::slice_min(ref_date) |>
    dplyr::pull(value)
  expect_true(all(first_vals == 100))
})

# ---- compute_cross_section_summary -------------------------------------------

test_that("compute_cross_section_summary uses only the latest date", {
  result <- compute_cross_section_summary(test_data, group_col = "group")
  expect_equal(nrow(result), 2L)
  expect_equal(result$value[result$group == "A"], 1L)  # 1 row per group at 2022
})

test_that("compute_cross_section_summary sums measure_col at latest date", {
  result <- compute_cross_section_summary(test_data, group_col = "group", measure_col = "salary")
  expect_equal(result$value[result$group == "B"], 300)
})

# ---- count_entity ------------------------------------------------------------

entities <- data.frame(
  personnel_id = c(1, 1, 2, NA, 3),
  est_id = c("A", "A", "B", "B", "B"),
  stringsAsFactors = FALSE
)

test_that("count_entity counts distinct non-missing ids per group", {
  result <- count_entity(entities, id_col = "personnel_id", group_cols = "est_id")

  expect_true(data.table::is.data.table(result))
  expect_equal(result[["est_id"]], c("A", "B"))
  expect_equal(result[["count"]], c(1L, 2L))
})

test_that("count_entity gives the same counts on a duckdb table", {
  skip_if_not_installed("duckdb")
  skip_if_not_installed("dbplyr")

  # silence duckdb's notice about where it stores extensions
  con <- suppressMessages(DBI::dbConnect(duckdb::duckdb()))
  on.exit(DBI::dbDisconnect(con, shutdown = TRUE))
  DBI::dbWriteTable(con, "entities", entities)

  result <- count_entity(
    dplyr::tbl(con, "entities"),
    id_col = "personnel_id",
    group_cols = "est_id"
  )

  expect_s3_class(result, "tbl_dbi")

  result <- dplyr::collect(result)
  result <- result[order(result[["est_id"]]), ]

  expect_equal(result[["est_id"]], c("A", "B"))
  expect_equal(as.integer(result[["count"]]), c(1L, 2L))
})
