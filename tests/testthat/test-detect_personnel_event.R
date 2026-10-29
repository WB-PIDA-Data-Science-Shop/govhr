# ---- detect_personnel_event --------------------------------------------------
# Deprecated in favour of detect_movement() and detect_retirement(), but kept
# for callers such as govhrcast, so its behaviour is pinned down here.

# 1 is active throughout. 2 joins in 2021, so is a hire. 3 leaves after 2021,
# so is a fire. 4 is missing in 2021 and back in 2022, so is a fire in 2020 and
# a hire in 2022. 5 is only ever inactive
personnel <- data.frame(
  personnel_id = c(1, 1, 1, 2, 2, 3, 3, 4, 4, 5),
  ref_date = as.Date(c(
    "2020-01-01", "2021-01-01", "2022-01-01",
    "2021-01-01", "2022-01-01",
    "2020-01-01", "2021-01-01",
    "2020-01-01", "2022-01-01",
    "2021-01-01"
  )),
  employment_status = c(rep("active", 9), "inactive")
)

detect <- function(data, event_type, ...) {
  detect_personnel_event(
    data,
    id_col = "personnel_id",
    event_type = event_type,
    start_date = "2020-01-01",
    end_date = "2022-01-01",
    status_col = "employment_status",
    ...
  )
}

test_that("detect_personnel_event flags hires and fires, with a warning naming the replacement", {
  lifecycle::expect_deprecated(
    hires <- detect(personnel, "hire"),
    "the `hire` column of `detect_movement\\(\\)`"
  )
  lifecycle::expect_deprecated(
    fires <- detect(personnel, "fire"),
    "`separation` column of `detect_movement\\(\\)`, and `detect_retirement\\(\\)`"
  )

  expect_s3_class(hires, "data.frame")
  expect_false(data.table::is.data.table(hires))
  expect_named(hires, c("personnel_id", "ref_date", "type_event"))
  expect_equal(hires$personnel_id, c(2, 4))
  expect_equal(hires$ref_date, as.Date(c("2021-01-01", "2022-01-01")))
  expect_equal(unique(hires$type_event), "hire")

  expect_equal(fires$personnel_id, c(3, 4))
  expect_equal(fires$ref_date, as.Date(c("2021-01-01", "2020-01-01")))
  expect_equal(unique(fires$type_event), "fire")

  expect_error(
    suppressWarnings(detect(personnel, "retire")),
    "should be one of"
  )
})

test_that("detect_personnel_event matches detect_movement on evenly spaced dates", {
  movement <- detect_movement(personnel)

  hires <- suppressWarnings(detect(data.table::as.data.table(personnel), "hire"))
  fires <- suppressWarnings(detect(data.table::as.data.table(personnel), "fire"))

  expect_true(data.table::is.data.table(hires))
  expect_equal(
    hires[order(ref_date, personnel_id), .(personnel_id, ref_date)],
    movement[hire %in% TRUE, .(personnel_id, ref_date)]
  )
  expect_equal(
    fires[order(ref_date, personnel_id), .(personnel_id, ref_date)],
    movement[separation %in% TRUE, .(personnel_id, ref_date)]
  )

  # a date nobody is recorded on still counts as a gap: 1 is missing in 2021
  biennial <- personnel[personnel$personnel_id == 1 & personnel$ref_date != as.Date("2021-01-01"), ]
  expect_equal(suppressWarnings(detect(biennial, "hire"))$ref_date, as.Date("2022-01-01"))
})
