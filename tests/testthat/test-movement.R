# Tests for classify_personnel_event() -------------------------------------

test_that("classify_personnel_event('hire') flags a genuine mid-panel hire and excludes presence-at-start", {
  df <- data.table::data.table(
    personnel_id = c(1, 1, 1, 2, 2),
    ref_date = as.Date(c("2019-01-01", "2020-01-01", "2021-01-01", "2020-01-01", "2021-01-01")),
    employment_status = "active"
  )

  out <- classify_personnel_event(
    data = df,
    id_col = "personnel_id",
    event_type = "hire",
    start_date = "2019-01-01",
    end_date = "2021-01-01",
    status_col = "employment_status"
  )

  # id 1 is present from the very first ref_date -> never a "hire" (start-date
  # presence is excluded, and it has no gap thereafter)
  expect_true(all(out[personnel_id == 1, type_event] == "stayed"))

  # id 2 has no 2019 record, so its 2020 appearance is a genuine hire
  expect_equal(out[personnel_id == 2 & ref_date == as.Date("2020-01-01"), type_event], "hire")
  expect_equal(out[personnel_id == 2 & ref_date == as.Date("2021-01-01"), type_event], "stayed")

  # the earliest ref_date (2019-01-01) is dropped entirely for hire classification
  expect_false(any(out$ref_date == as.Date("2019-01-01")))
})

test_that("classify_personnel_event('retirement') flags the active->pensioner transition", {
  # person 2 keeps 2021-01-01 in the calendar of active dates, as in a full
  # panel
  df <- data.table::data.table(
    personnel_id = rep(1:2, each = 3),
    ref_date = rep(as.Date(c("2019-01-01", "2020-01-01", "2021-01-01")), 2),
    employment_status = c("active", "active", "pensioner", rep("active", 3))
  )

  out <- classify_personnel_event(
    data = df,
    id_col = "personnel_id",
    event_type = "retirement",
    start_date = "2019-01-01",
    end_date = "2021-01-01",
    status_col = "employment_status"
  )[personnel_id == 1]

  # retirement is detected on the last *active* record before the pensioner
  # status appears, i.e. 2020-01-01, not 2021-01-01
  expect_equal(out[ref_date == as.Date("2020-01-01"), type_event], "retirement")
  expect_equal(out[ref_date == as.Date("2019-01-01"), type_event], "stayed")
  expect_equal(out[ref_date == as.Date("2021-01-01"), type_event], "stayed")
})
