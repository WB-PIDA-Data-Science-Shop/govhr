# ---- compute_wagebill_analytics ----------------------------------------------
# compute_wagebill_analytics() keeps the contracts of active personnel,
# deflates their pay, and passes them to each indicator function, so these
# tests check the filter and the deflation, and that a data frame and a duckdb
# table give the same indicators, each with the class its method returns.

contracts <- data.frame(
  personnel_id = c(1, 2, 3, 1, 2, 3),
  ref_date = as.Date(rep(c("2020-01-01", "2021-01-01"), each = 3)),
  est_id = c("A", "A", "B", "A", "B", "B"),
  base_salary_lcu = c(800, 900, 1000, 850, 950, 1100),
  allowance_lcu = c(200, 100, 300, 250, 150, 200)
)
contracts$gross_salary_lcu <- contracts$base_salary_lcu + contracts$allowance_lcu

# person 3 is a pensioner in 2021, so their pay is left out that year
personnel <- data.frame(
  personnel_id = c(1, 2, 3, 1, 2, 3),
  ref_date = as.Date(rep(c("2020-01-01", "2021-01-01"), each = 3)),
  employment_status = c("active", "active", "active", "active", "active", "pensioner")
)

establishment <- data.frame(
  est_id = c("A", "B"),
  country_code = "BRA"
)

# with 2020 as the base month, 2020 pay is unchanged and 2021 pay is
# multiplied by this deflator
deflator_2021 <- deflate_to_real(
  1, as.Date("2021-01-01"), "BRA", base_month = "2020-01-01"
)

wagebill_analytics <- function(contracts, personnel, establishment) {
  compute_wagebill_analytics(
    contracts,
    personnel,
    establishment,
    binwidth = 100,
    base_month = "2020-01-01"
  )
}

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
  result <- wagebill_analytics(contracts, personnel, establishment)

  expect_named(
    result,
    c(
      "wagebill", "wagebill_by_est", "wage", "wage_by_est",
      "composition", "distribution"
    )
  )
  expect_true(all(vapply(result, data.table::is.data.table, logical(1))))
})

test_that("counts the deflated pay of active personnel only", {
  result <- wagebill_analytics(contracts, personnel, establishment)

  expect_equal(result$wagebill$wagebill, c(3300, 2200 * deflator_2021))
  expect_equal(result$wage$wage, c(1100, 1100 * deflator_2021))
})

test_that("deflates to December 2021 prices by default", {
  result <- compute_wagebill_analytics(
    contracts, personnel, establishment, binwidth = 100
  )

  expected <- deflate_to_real(c(3300, 2200), unique(contracts$ref_date), "BRA")
  expect_equal(result$wagebill$wagebill, expected)
})

test_that("component shares add up to 1 within each date", {
  composition <- wagebill_analytics(contracts, personnel, establishment)$composition

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
  DBI::dbWriteTable(con, "personnel", personnel)
  DBI::dbWriteTable(con, "establishment", establishment)

  result <- wagebill_analytics(
    dplyr::tbl(con, "contracts"),
    dplyr::tbl(con, "personnel"),
    dplyr::tbl(con, "establishment")
  )

  expect_true(all(vapply(result, inherits, logical(1), what = "tbl_dbi")))
  expect_equal(
    collect_wagebill_indicators(result),
    collect_wagebill_indicators(
      wagebill_analytics(contracts, personnel, establishment)
    )
  )
})

test_that("warns about establishments with no country", {
  expect_warning(
    result <- wagebill_analytics(contracts, personnel, establishment[1, ]),
    "missing from `establishment`.*: B"
  )
  expect_true(all(is.na(result$wagebill_by_est$wagebill[result$wagebill_by_est$est_id == "B"])))
})

test_that("stops when an establishment has more than one country", {
  two_countries <- rbind(establishment, data.frame(est_id = "A", country_code = "MOZ"))

  expect_error(
    wagebill_analytics(contracts, personnel, two_countries),
    "more than one `country_code` for est_id: A"
  )
})

test_that("reports missing columns", {
  expect_error(
    wagebill_analytics(
      contracts[c("personnel_id", "ref_date", "est_id", "gross_salary_lcu")],
      personnel,
      establishment
    ),
    "`contracts` is missing required columns: base_salary_lcu, allowance_lcu"
  )
  expect_error(
    wagebill_analytics(contracts, personnel, establishment["est_id"]),
    "`establishment` is missing required columns: country_code"
  )
})
