# retirement_panel is in helper-retirement_panel.R

# detect_movement() and detect_retirement() flag the active person-dates of
# retirement_panel:
# hires: p7 in 2022, returning after the 2021 gap
# separations: p2, p5, p6 and p7 in 2020, p1 in 2021 and p7 in 2022
# retirements: p5 and p6 in 2020, p1 in 2021 and p7 in 2022

flagged <- function(events, flag) {
  events[events[[flag]] %in% TRUE, c("personnel_id", "ref_date")] |>
    as.data.frame()
}

test_that("detect_movement flags hires and separations", {
  result <- detect_movement(retirement_panel)

  # one row per active person and date, so p3's two 2020 contracts count once
  expect_equal(nrow(result), 15L)

  # the first date has no previous date, and the last no next date
  expect_true(all(is.na(result$hire[result$ref_date == as.Date("2020-01-01")])))
  expect_true(all(is.na(result$separation[result$ref_date == as.Date("2023-01-01")])))

  expect_equal(
    flagged(result, "hire"),
    data.frame(personnel_id = "p7", ref_date = as.Date("2022-01-01"))
  )
  expect_equal(
    flagged(result, "separation"),
    data.frame(
      personnel_id = c("p2", "p5", "p6", "p7", "p1", "p7"),
      ref_date = as.Date(c(rep("2020-01-01", 4), "2021-01-01", "2022-01-01"))
    )
  )
})

test_that("detect_movement adds up to compute_movement()", {
  counts <- detect_movement(retirement_panel) |>
    dplyr::summarise(
      hires = sum(.data[["hire"]]),
      separations = sum(.data[["separation"]]),
      .by = "ref_date"
    )

  expected <- compute_movement(retirement_panel)

  expect_equal(counts$ref_date, expected$ref_date)
  expect_equal(counts$hires, expected$hires)
  expect_equal(counts$separations, expected$separations)
})

test_that("detect_retirement flags the separations into a pension", {
  result <- detect_retirement(retirement_panel)

  expect_true(all(is.na(result$retirement[result$ref_date == as.Date("2023-01-01")])))

  # p7's 2020 exit is followed by a return to work, not a pension
  expect_equal(
    flagged(result, "retirement"),
    data.frame(
      personnel_id = c("p5", "p6", "p1", "p7"),
      ref_date = as.Date(c("2020-01-01", "2020-01-01", "2021-01-01", "2022-01-01"))
    )
  )
})

test_that("detect_movement and detect_retirement agree on a database table", {
  skip_if_not_installed("dbplyr")
  skip_if_not_installed("duckdb")

  con <- DBI::dbConnect(duckdb::duckdb())
  remote <- dplyr::copy_to(con, retirement_panel, "retirement_panel")

  for (detect in list(detect_movement, detect_retirement)) {
    expected <- detect(retirement_panel) |>
      as.data.frame()

    result <- detect(remote) |>
      dplyr::collect() |>
      dplyr::arrange(.data[["ref_date"]], .data[["personnel_id"]]) |>
      as.data.frame()

    expect_equal(result, expected, ignore_attr = TRUE)
  }

  DBI::dbDisconnect(con, shutdown = TRUE)
})
