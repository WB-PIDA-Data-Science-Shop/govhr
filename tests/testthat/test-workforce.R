# ---- compute_workforce_analytics ---------------------------------------------
# compute_workforce_analytics() passes `data` to each indicator function as
# is, so these tests check that a data frame, a tibble and a duckdb table give
# the same indicators, and that each one keeps the class its method returns.

workforce <- data.frame(
  personnel_id = rep(1:3, each = 3),
  ref_date = rep(as.Date(c("2020-01-01", "2021-01-01", "2022-01-01")), times = 3),
  est_id = c("A", "A", "A", "B", "B", "A", "A", "A", "B"),
  employment_status = c(
    "active", "active", "active",
    "inactive", "active", "active",
    "active", "active", "inactive"
  )
)

# bring every indicator into memory as a data frame sorted the same way, so
# results from different backends can be compared
collect_indicators <- function(indicators) {
  lapply(indicators, function(indicator) {
    result <- as.data.frame(dplyr::collect(indicator))
    result$ref_date <- as.Date(result$ref_date)
    result <- result[do.call(order, unname(result)), , drop = FALSE]
    rownames(result) <- NULL
    result[sort(names(result))]
  })
}

test_that("returns the four indicators", {
  result <- compute_workforce_analytics(workforce)

  expect_named(
    result,
    c("headcount", "headcount_by_est", "movement", "transitions")
  )
  expect_true(all(vapply(result, data.table::is.data.table, logical(1))))
  expect_equal(result$movement$hires, c(NA, 1L, 0L))
  expect_equal(result$movement$separations, c(0L, 1L, NA))
})

test_that("does not modify the input", {
  input <- data.table::as.data.table(workforce)
  before <- data.table::copy(input)

  compute_workforce_analytics(input)

  expect_identical(input, before)
})

test_that("a tibble gives the same indicators as a data frame", {
  expect_equal(
    collect_indicators(compute_workforce_analytics(tibble::as_tibble(workforce))),
    collect_indicators(compute_workforce_analytics(workforce))
  )
})

test_that("a duckdb table is processed by the tbl_dbi methods", {
  skip_if_not_installed("duckdb")
  skip_if_not_installed("dbplyr")

  # silence duckdb's notice about where it stores extensions
  con <- suppressMessages(DBI::dbConnect(duckdb::duckdb()))
  on.exit(DBI::dbDisconnect(con, shutdown = TRUE))
  DBI::dbWriteTable(con, "workforce", workforce)

  result <- compute_workforce_analytics(dplyr::tbl(con, "workforce"))

  expect_s3_class(result$headcount, "tbl_dbi")
  expect_s3_class(result$headcount_by_est, "tbl_dbi")
  expect_s3_class(result$movement, "tbl_dbi")
  expect_s3_class(result$transitions, "tbl_dbi")
  expect_equal(
    collect_indicators(result),
    collect_indicators(compute_workforce_analytics(workforce))
  )
})

test_that("reports missing columns", {
  expect_error(
    compute_workforce_analytics(workforce[c("personnel_id", "ref_date")]),
    "est_id, employment_status"
  )
})
