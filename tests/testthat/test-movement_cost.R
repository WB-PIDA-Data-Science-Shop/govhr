# retirement_panel is in helper-retirement_panel.R

# compute_movement_cost() and compute_retirement_cost() add up the movers' pay
# in retirement_panel, where each record's pay is ten times its row number:
# hires: p7 in 2022
# separations: p2, p5, p6 and p7 in 2020, p1 in 2021 and p7 in 2022
# retirements: p5 and p6 in 2020, p1 in 2021 and p7 in 2022
cost_panel <- retirement_panel
cost_panel$pay <- seq_len(nrow(cost_panel)) * 10

cost_dates <- as.Date(c("2020-01-01", "2021-01-01", "2022-01-01", "2023-01-01"))

test_that("compute_movement_cost adds up the movers' pay on each date", {
  result <- compute_movement_cost(cost_panel, measure_col = "pay")

  expect_equal(result$ref_date, rep(cost_dates, 2))
  expect_equal(result$movement_type, rep(c("hire", "separation"), each = 4))

  # the first date has nothing to detect hires against, and the last nothing
  # to detect separations against
  expect_equal(
    result$movement_cost,
    c(
      NA, 0, 180, 0,
      20 + 60 + 70 + 80, 90, 180, NA
    )
  )
})

test_that("compute_movement_cost counts pay in the group of its record", {
  result <- compute_movement_cost(
    cost_panel,
    event_type = "separation",
    measure_col = "pay",
    group_cols = "unit"
  )

  # every unit with active personnel on a date appears for that date, so only
  # unit B on the last
  expect_equal(result$unit, c("A", "B", "A", "B", "A", "B", "B"))
  expect_equal(result$movement_cost, c(20 + 70 + 80, 60, 90, 0, 180, 0, NA))
})

test_that("compute_movement_cost costs every active contract of a mover", {
  # b is hired in 2021 with two contracts, alongside a pension
  hr <- data.frame(
    personnel_id = c("a", "a", "b", "b", "b"),
    ref_date = as.Date(c(
      "2020-01-01", "2021-01-01", "2021-01-01", "2021-01-01", "2021-01-01"
    )),
    employment_status = c("active", "active", "active", "active", "pensioner"),
    pay = c(100, 110, 200, 50, 30)
  )

  result <- compute_movement_cost(hr, event_type = "hire", measure_col = "pay")

  expect_equal(result$movement_cost, c(NA, 200 + 50))
})

test_that("compute_movement_cost rejects retirements, unknown movements and ref_date groups", {
  expect_error(
    compute_movement_cost(cost_panel, event_type = "retirement", measure_col = "pay")
  )
  expect_error(
    compute_movement_cost(cost_panel, event_type = "fire", measure_col = "pay")
  )
  expect_error(
    compute_movement_cost(cost_panel, measure_col = "pay", group_cols = "ref_date"),
    "ref_date"
  )
})

test_that("compute_retirement_cost adds up the retirees' pay on each date", {
  result <- compute_retirement_cost(cost_panel, measure_col = "pay")

  expect_equal(result$ref_date, cost_dates)
  # p7's 2020 exit is followed by a return to work, so is not costed; the last
  # date has nothing to compare with
  expect_equal(result$retirement_cost, c(60 + 70, 90, 180, NA))
})

test_that("compute_retirement_cost counts pay in the group of its record", {
  result <- compute_retirement_cost(
    cost_panel,
    measure_col = "pay",
    group_cols = "unit"
  )

  expect_equal(result$unit, c("A", "B", "A", "B", "A", "B", "B"))
  expect_equal(result$retirement_cost, c(70, 60, 90, 0, 180, 0, NA))
})

test_that("compute_retirement_cost rejects ref_date as a group", {
  expect_error(
    compute_retirement_cost(cost_panel, measure_col = "pay", group_cols = "ref_date"),
    "ref_date"
  )
})

test_that("compute_movement_cost and compute_retirement_cost agree on a database table", {
  skip_if_not_installed("dbplyr")
  skip_if_not_installed("duckdb")

  con <- DBI::dbConnect(duckdb::duckdb())
  remote <- dplyr::copy_to(con, cost_panel, "cost_panel")

  for (compute_cost in list(compute_movement_cost, compute_retirement_cost)) {
    for (group_cols in list(NULL, "unit")) {
      sort_keys <- c("movement_type", "ref_date", group_cols)

      expected <- compute_cost(
        cost_panel,
        measure_col = "pay",
        group_cols = group_cols
      ) |>
        dplyr::arrange(dplyr::across(dplyr::any_of(sort_keys))) |>
        as.data.frame()

      result <- compute_cost(
        remote,
        measure_col = "pay",
        group_cols = group_cols
      ) |>
        dplyr::collect() |>
        dplyr::arrange(dplyr::across(dplyr::any_of(sort_keys))) |>
        as.data.frame()

      expect_equal(result, expected, ignore_attr = TRUE)
    }
  }

  DBI::dbDisconnect(con, shutdown = TRUE)
})
