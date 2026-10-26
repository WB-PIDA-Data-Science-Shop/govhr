# ---------------------------------------------------------------------------
# backends
#
# Every behaviour test runs on a data frame and on a duckdb table, so the two
# implementations are held to the same results.
# ---------------------------------------------------------------------------
backends <- c("data.frame", "duckdb")

# the table as each backend sees it: as it is, or written to duckdb (the
# connection is closed when the calling test ends)
as_backend <- function(backend, data, env = parent.frame()) {
  if (backend == "data.frame") {
    return(data)
  }
  skip_if_not_installed("duckdb")
  skip_if_not_installed("dbplyr")
  con <- suppressMessages(DBI::dbConnect(duckdb::duckdb()))
  withr::defer(DBI::dbDisconnect(con, shutdown = TRUE), envir = env)
  DBI::dbWriteTable(con, "data", as.data.frame(data))
  dplyr::tbl(con, "data")
}

# a table with one row per date: all .build_calendar() reads
dates_table <- function(dates) {
  data.frame(personnel_id = seq_along(dates), ref_date = as.Date(dates))
}

# ---------------------------------------------------------------------------
# .build_calendar()
# ---------------------------------------------------------------------------
for (backend in backends) test_that(paste0("annual snapshots: each date's next date, twelve months on, all regular but the last", " [", backend, "]"), {
  dates <- c("2020-01-01", "2021-01-01", "2022-01-01")
  calendar <- .build_calendar(as_backend(backend, dates_table(dates)))

  expect_s3_class(calendar, "data.table")
  expect_named(calendar, c("ref_date", "next_date", "interval_months", "regular"))
  expect_equal(calendar$ref_date, as.Date(dates))
  expect_equal(calendar$next_date, as.Date(c(dates[2:3], NA)))
  expect_equal(calendar$interval_months, c(12, 12, NA))
  expect_equal(calendar$regular, c(TRUE, TRUE, FALSE))
  expect_equal(attr(calendar, "usual_interval_months"), 12)
})

for (backend in backends) test_that(paste0("monthly snapshots with one month missing: the two-month step is irregular", " [", backend, "]"), {
  # no March: February's next date is April
  dates <- c("2020-01-01", "2020-02-01", "2020-04-01", "2020-05-01", "2020-06-01")
  calendar <- .build_calendar(as_backend(backend, dates_table(dates)))

  expect_equal(attr(calendar, "usual_interval_months"), 1)
  expect_equal(calendar$interval_months, c(1, 2, 1, 1, NA))
  expect_equal(calendar$regular, c(TRUE, FALSE, TRUE, TRUE, FALSE))
})

for (backend in backends) test_that(paste0("the usual interval is the most common one, not a median between two", " [", backend, "]"), {
  # steps of 1, 2, 1 and 12 months: the median would be 1.5, making the
  # two-month step look regular; the most common step is 1
  dates <- c("2020-01-01", "2020-02-01", "2020-04-01", "2020-05-01", "2021-05-01")
  calendar <- .build_calendar(as_backend(backend, dates_table(dates)))

  expect_equal(attr(calendar, "usual_interval_months"), 1)
  expect_equal(calendar$regular, c(TRUE, FALSE, TRUE, FALSE, FALSE))
})

test_that("a tie between intervals goes to the shorter one", {
  # two monthly steps and two quarterly ones
  dates <- c("2020-01-01", "2020-02-01", "2020-03-01", "2020-06-01", "2020-09-01")
  expect_equal(attr(.build_calendar(dates_table(dates)), "usual_interval_months"), 1)
})

for (backend in backends) test_that(paste0("a year's gap in monthly data is irregular", " [", backend, "]"), {
  # monthly through 2023, then December 2024 only (the Gambian calendar)
  dates <- c(seq(as.Date("2023-01-01"), as.Date("2023-12-01"), by = "month"), as.Date("2024-12-01"))
  calendar <- .build_calendar(as_backend(backend, dates_table(dates)))

  expect_equal(calendar[ref_date == as.Date("2023-12-01"), interval_months], 12)
  expect_false(calendar[ref_date == as.Date("2023-12-01"), regular])
  expect_true(all(calendar[ref_date < as.Date("2023-12-01"), regular]))
})

for (backend in backends) test_that(paste0("a snapshot taken a month late is still a regular annual step", " [", backend, "]"), {
  # within half the usual interval of a year: 13 and 11 months are regular
  dates <- c("2019-01-01", "2020-01-01", "2021-02-01", "2022-01-01")
  calendar <- .build_calendar(as_backend(backend, dates_table(dates)))

  expect_equal(calendar$interval_months, c(12, 13, 11, NA))
  expect_equal(calendar$regular, c(TRUE, TRUE, TRUE, FALSE))
})

for (backend in backends) test_that(paste0("dates are listed once, sorted, without missing ones", " [", backend, "]"), {
  data <- data.frame(
    personnel_id = 1:5,
    ref_date = as.Date(c("2021-01-01", "2020-01-01", NA, "2021-01-01", "2022-01-01"))
  )
  calendar <- .build_calendar(as_backend(backend, data))

  expect_equal(calendar$ref_date, as.Date(c("2020-01-01", "2021-01-01", "2022-01-01")))
})

for (backend in backends) test_that(paste0("the date column can have another name", " [", backend, "]"), {
  data <- data.frame(id = 1:2, snapshot = as.Date(c("2020-01-01", "2021-01-01")))
  calendar <- .build_calendar(as_backend(backend, data), ref_date_col = "snapshot")

  expect_named(calendar, c("snapshot", "next_date", "interval_months", "regular"))
  expect_equal(calendar$interval_months, c(12, NA))
})

for (backend in backends) test_that(paste0("fewer than two snapshots errors", " [", backend, "]"), {
  expect_error(
    .build_calendar(as_backend(backend, dates_table(c("2020-01-01", "2020-01-01")))),
    "must contain at least 2 snapshots"
  )
})

test_that("a table with no date column errors naming it", {
  expect_error(
    .build_calendar(data.frame(id = 1), ref_date_col = "ref_date"),
    "missing required columns: ref_date"
  )
})
