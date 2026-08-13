test_that("compute_workforce_movement computes hire count and rate correctly", {
  panel_dt <- data.table::data.table(
    personnel_id = rep(1:3, each = 3),
    ref_date = rep(as.Date(c("2020-01-01", "2021-01-01", "2022-01-01")), times = 3),
    employment_status = c(
      "active", "active", "inactive",  # id 1 -> fire at 2021
      "inactive", "active", "active",  # id 2 -> hire at 2021
      "active", "active", "active"     # id 3 -> no event
    )
  )

  res_count <- compute_workforce_movement(
    .data = panel_dt,
    movement_type = "hire",
    measurement_type = "count",
    group_cols = NULL
  )
  res_rate <- compute_workforce_movement(
    .data = panel_dt,
    movement_type = "hire",
    measurement_type = "rate",
    group_cols = NULL
  )

  data.table::setorder(res_count, ref_date)
  data.table::setorder(res_rate, ref_date)

  expect_equal(res_count$ref_date, as.Date(c("2021-01-01", "2022-01-01")))
  expect_equal(res_count$indicator, c(1, 0))
  expect_equal(res_rate$indicator, c(1/3, 0))
})

test_that("compute_workforce_movement computes fire count and rate correctly", {
  panel_dt <- data.table::data.table(
    personnel_id = rep(1:3, each = 3),
    ref_date = rep(as.Date(c("2020-01-01", "2021-01-01", "2022-01-01")), times = 3),
    employment_status = c(
      "active", "active", "inactive",
      "inactive", "active", "active",
      "active", "active", "active"
    )
  )

  res_count <- compute_workforce_movement(
    .data = panel_dt,
    movement_type = "fire",
    measurement_type = "count",
    group_cols = NULL
  )
  res_rate <- compute_workforce_movement(
    .data = panel_dt,
    movement_type = "fire",
    measurement_type = "rate",
    group_cols = NULL
  )

  data.table::setorder(res_count, ref_date)
  data.table::setorder(res_rate, ref_date)

  expect_equal(res_count$ref_date, as.Date(c("2020-01-01", "2021-01-01")))
  expect_equal(res_count$indicator, c(0, 1))
  expect_equal(res_rate$indicator, c(0, 1/3))
})

test_that("compute_workforce_movement computes turnover and accepts count/rate argument", {
  panel_dt <- data.table::data.table(
    personnel_id = rep(1:3, each = 3),
    ref_date = rep(as.Date(c("2020-01-01", "2021-01-01", "2022-01-01")), times = 3),
    employment_status = c(
      "active", "active", "inactive",
      "inactive", "active", "active",
      "active", "active", "active"
    )
  )

  res_count <- compute_workforce_movement(
    .data = panel_dt,
    movement_type = "turnover",
    measurement_type = "count",
    group_cols = NULL
  )
  res_rate <- compute_workforce_movement(
    .data = panel_dt,
    movement_type = "turnover",
    measurement_type = "rate",
    group_cols = NULL
  )

  data.table::setorder(res_count, ref_date)
  data.table::setorder(res_rate, ref_date)

  expect_equal(nrow(res_count), 1L)
  expect_equal(res_count$ref_date, as.Date("2021-01-01"))
  expect_equal(res_count$indicator, 1)
  expect_equal(res_rate$indicator, res_count$indicator)
})