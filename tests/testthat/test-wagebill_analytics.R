# ---- compute_wagebill_analytics ----------------------------------------------
# compute_wagebill_analytics() passes `data` to each indicator function as is,
# so these tests check that a data frame and a duckdb table give the same
# indicators, and that each one keeps the class its method returns.

contracts <- data.frame(
  ref_date = as.Date(rep(c("2020-01-01", "2021-01-01"), each = 3)),
  est_id = c("A", "A", "B", "A", "B", "B"),
  base_salary_lcu = c(800, 900, 1000, 850, 950, 1100),
  allowance_lcu = c(200, 100, 300, 250, 150, 200)
)
contracts$gross_salary_lcu <- contracts$base_salary_lcu + contracts$allowance_lcu

# bring every indicator into memory as a data frame sorted the same way, so
# results from different backends can be compared
collect_wagebill_indicators <- function(indicators) {
  lapply(indicators, function(indicator) {
    result <- as.data.frame(dplyr::collect(indicator))
    result <- result[do.call(order, unname(result)), , drop = FALSE]
    rownames(result) <- NULL
    result[sort(names(result))]
  })
}

test_that("returns the six indicators", {
  result <- compute_wagebill_analytics(contracts, binwidth = 100)

  expect_named(
    result,
    c(
      "wagebill", "wagebill_by_est", "wage", "wage_by_est",
      "composition", "distribution"
    )
  )
  expect_true(all(vapply(result, data.table::is.data.table, logical(1))))
  expect_equal(result$wagebill$wagebill, c(3300, 3500))
  expect_equal(result$wage$wage, c(1100, 3500 / 3))
})

test_that("component shares add up to 1 within each date", {
  composition <- compute_wagebill_analytics(contracts, binwidth = 100)$composition

  expect_setequal(composition$component, c("base_salary_lcu", "allowance_lcu"))
  expect_equal(
    as.vector(tapply(composition$share_wagebill, composition$ref_date, sum)),
    c(1, 1)
  )
})

test_that("a duckdb table gives the same indicators as a data frame", {
  skip_if_not_installed("duckdb")
  skip_if_not_installed("dbplyr")

  # silence duckdb's notice about where it stores extensions
  con <- suppressMessages(DBI::dbConnect(duckdb::duckdb()))
  on.exit(DBI::dbDisconnect(con, shutdown = TRUE))
  DBI::dbWriteTable(con, "contracts", contracts)

  result <- compute_wagebill_analytics(
    dplyr::tbl(con, "contracts"),
    binwidth = 100
  )

  expect_true(all(vapply(result, inherits, logical(1), what = "tbl_dbi")))
  expect_equal(
    collect_wagebill_indicators(result),
    collect_wagebill_indicators(
      compute_wagebill_analytics(contracts, binwidth = 100)
    )
  )
})

test_that("reports missing columns", {
  expect_error(
    compute_wagebill_analytics(
      contracts[c("ref_date", "est_id", "gross_salary_lcu")],
      binwidth = 100
    ),
    "base_salary_lcu, allowance_lcu"
  )
})
