# compute_retirement() mirrors compute_movement(), so the data.frame and
# tbl_dbi methods must agree. retirement_panel is in helper-retirement_panel.R

test_that("compute_retirement counts exits whose next status is pensioner", {
  result <- compute_retirement(retirement_panel)

  expect_equal(
    result$ref_date,
    as.Date(c("2020-01-01", "2021-01-01", "2022-01-01", "2023-01-01"))
  )
  expect_equal(result$headcount, c(7L, 3L, 3L, 2L))
  expect_equal(result$retirements, c(2L, 1L, 1L, NA))
  expect_equal(result$retirement_rate, c(2 / 7, 1 / 3, 1 / 3, NA))
})

test_that("compute_retirement dates a lagged pension registration by the exit", {
  # p3 keeps the 2021 date in the calendar, as in a full panel
  result <- retirement_panel |>
    dplyr::filter(.data[["personnel_id"]] %in% c("p3", "p6")) |>
    compute_retirement()

  expect_equal(result$retirements, c(1L, 0L, 0L, NA))
})

test_that("compute_retirement ignores an exit followed by a return to work", {
  result <- retirement_panel |>
    dplyr::filter(.data[["personnel_id"]] %in% c("p3", "p7")) |>
    compute_retirement()

  expect_equal(result$retirements, c(0L, 0L, 1L, NA))
})

test_that("compute_retirement counts each person in their group on that date", {
  result <- compute_retirement(retirement_panel, group_cols = "unit")

  expect_equal(result$unit, c("A", "B", "A", "B", "A", "B", "B"))
  expect_equal(result$headcount, c(4L, 3L, 1L, 2L, 1L, 2L, 2L))
  expect_equal(result$retirements, c(1L, 1L, 1L, 0L, 1L, 0L, NA))
})

test_that("compute_retirement counts only separations as retirements", {
  retirement <- compute_retirement(retirement_panel)
  movement <- compute_movement(retirement_panel)

  expect_true(
    all(retirement$retirements <= movement$separations, na.rm = TRUE)
  )
  expect_identical(retirement$headcount, movement$headcount)
})

test_that("compute_retirement rejects ref_date as a group", {
  expect_error(
    compute_retirement(retirement_panel, group_cols = "ref_date"),
    "ref_date"
  )
})

test_that("compute_retirement gives the same result on a database table", {
  skip_if_not_installed("dbplyr")
  skip_if_not_installed("duckdb")

  con <- DBI::dbConnect(duckdb::duckdb())
  remote <- dplyr::copy_to(con, retirement_panel, "retirement_panel")

  for (group_cols in list(NULL, "unit")) {
    expected <- compute_retirement(retirement_panel, group_cols = group_cols) |>
      as.data.frame()

    result <- compute_retirement(remote, group_cols = group_cols) |>
      dplyr::collect() |>
      dplyr::arrange(dplyr::across(dplyr::all_of(c("ref_date", group_cols)))) |>
      as.data.frame()

    # SQL returns every count as a double
    expect_equal(result, expected, ignore_attr = TRUE, tolerance = 1e-12)
  }

  DBI::dbDisconnect(con, shutdown = TRUE)
})
