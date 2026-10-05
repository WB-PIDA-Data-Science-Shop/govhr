# ---- compute_workforce_analytics ---------------------------------------------
# compute_workforce_analytics() keeps the contracts of active personnel and
# passes them to each indicator function, so these tests check the filter, and
# that a data frame, a tibble and a duckdb table give the same indicators, each
# with the class its method returns.

contracts <- data.frame(
  personnel_id = rep(1:3, each = 3),
  ref_date = rep(as.Date(c("2020-01-01", "2021-01-01", "2022-01-01")), times = 3),
  est_id = c("A", "A", "A", "B", "B", "A", "A", "A", "B")
)

personnel <- data.frame(
  personnel_id = rep(1:3, each = 3),
  ref_date = rep(as.Date(c("2020-01-01", "2021-01-01", "2022-01-01")), times = 3),
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
  result <- compute_workforce_analytics(contracts, personnel)

  expect_named(
    result,
    c("headcount", "headcount_by_est", "movement", "transitions")
  )
  expect_true(all(vapply(result, data.table::is.data.table, logical(1))))
  expect_equal(result$movement$hires, c(NA, 1L, 0L))
  expect_equal(result$movement$separations, c(0L, 1L, NA))
})

test_that("counts only active personnel", {
  result <- compute_workforce_analytics(contracts, personnel)
  headcount <- result$headcount[order(result$headcount$ref_date), ]

  expect_equal(headcount$headcount, c(2L, 3L, 2L))
  # person 3 moves to B only once inactive, so it is not a transition
  expect_false(3 %in% result$transitions$personnel_id)
})

test_that("leaves out contracts with no personnel record", {
  result <- compute_workforce_analytics(contracts, personnel[-1, ])
  headcount <- result$headcount[order(result$headcount$ref_date), ]

  expect_equal(headcount$headcount, c(1L, 3L, 2L))
})

test_that("does not modify the input", {
  input_contracts <- data.table::as.data.table(contracts)
  input_personnel <- data.table::as.data.table(personnel)
  before_contracts <- data.table::copy(input_contracts)
  before_personnel <- data.table::copy(input_personnel)

  compute_workforce_analytics(input_contracts, input_personnel)

  expect_identical(input_contracts, before_contracts)
  expect_identical(input_personnel, before_personnel)
})

test_that("a tibble gives the same indicators as a data frame", {
  expect_equal(
    collect_indicators(
      compute_workforce_analytics(
        tibble::as_tibble(contracts),
        tibble::as_tibble(personnel)
      )
    ),
    collect_indicators(compute_workforce_analytics(contracts, personnel))
  )
})

test_that("a duckdb table is processed by the tbl_dbi methods", {
  skip_if_not_installed("duckdb")
  skip_if_not_installed("dbplyr")

  # silence duckdb's notice about where it stores extensions
  con <- suppressMessages(DBI::dbConnect(duckdb::duckdb()))
  on.exit(DBI::dbDisconnect(con, shutdown = TRUE))
  DBI::dbWriteTable(con, "contracts", contracts)
  DBI::dbWriteTable(con, "personnel", personnel)

  result <- compute_workforce_analytics(
    dplyr::tbl(con, "contracts"),
    dplyr::tbl(con, "personnel")
  )

  expect_s3_class(result$headcount, "tbl_dbi")
  expect_s3_class(result$headcount_by_est, "tbl_dbi")
  expect_s3_class(result$movement, "tbl_dbi")
  expect_s3_class(result$transitions, "tbl_dbi")
  expect_equal(
    collect_indicators(result),
    collect_indicators(compute_workforce_analytics(contracts, personnel))
  )
})

test_that("reports missing columns", {
  expect_error(
    compute_workforce_analytics(contracts[c("personnel_id", "ref_date")], personnel),
    "`contracts` is missing required columns: est_id"
  )
  expect_error(
    compute_workforce_analytics(contracts, personnel[c("personnel_id", "ref_date")]),
    "`personnel` is missing required columns: employment_status"
  )
})
