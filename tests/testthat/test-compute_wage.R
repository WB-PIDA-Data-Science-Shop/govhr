# ---- compute_wage ------------------------------------------------------------
# Every test runs on a data frame (data.table method) and on a duckdb table
# (tbl_dbi method), so the two implementations are held to the same behaviour.

backends <- c("data.frame", "duckdb")

# run compute_wage() on `data` or a duckdb copy of it, and return an in-memory
# data frame sorted the same way for both backends
run_wage <- function(backend, data, ...) {
  if (backend == "duckdb") {
    skip_if_not_installed("duckdb")
    skip_if_not_installed("dbplyr")

    # silence duckdb's notice about where it stores extensions
    con <- suppressMessages(DBI::dbConnect(duckdb::duckdb()))
    on.exit(DBI::dbDisconnect(con, shutdown = TRUE))

    DBI::dbWriteTable(con, "wages", data)
    data <- dplyr::tbl(con, "wages")
  }

  result <- as.data.frame(dplyr::collect(compute_wage(data, ...)))

  sort_cols <- intersect(c("est_id", "ref_date"), names(result))
  result <- result[do.call(order, unname(result[sort_cols])), ]
  rownames(result) <- NULL

  result
}

# B's only 2021 wage is missing, and C appears in 2020 only
wages <- data.frame(
  ref_date = as.Date(c(
    "2020-01-01", "2020-01-01", "2020-01-01", "2020-01-01",
    "2021-01-01", "2021-01-01",
    "2022-01-01", "2022-01-01"
  )),
  est_id = c("A", "A", "B", "C", "A", "B", "A", "B"),
  gross_salary_lcu = c(100, 200, 300, 400, 300, NA, 330, 330)
)

for (backend in backends) {
  test_that(paste0("averages wages for each date (", backend, ")"), {
    result <- run_wage(backend, wages)

    expect_named(result, c("ref_date", "wage", "wage_growth"))
    expect_equal(result$wage, c(250, 300, 330))
    expect_equal(result$wage_growth, c(NA, 0.2, 0.1))
  })

  test_that(paste0("keeps missing and absent groups as NA (", backend, ")"), {
    result <- run_wage(backend, wages, group_cols = "est_id")

    expect_equal(result$est_id, rep(c("A", "B", "C"), each = 3))
    expect_equal(result$wage, c(150, 300, 330, 300, NA, 330, 400, NA, NA))
    # growth is never measured across a gap
    expect_equal(
      result$wage_growth,
      c(NA, 1, 0.1, NA, NA, NA, NA, NA, NA)
    )
  })

  test_that(paste0("uses a custom measure column (", backend, ")"), {
    renamed <- wages
    names(renamed)[names(renamed) == "gross_salary_lcu"] <- "base_salary_lcu"

    expect_equal(
      run_wage(backend, renamed, measure_col = "base_salary_lcu"),
      run_wage(backend, wages)
    )
  })

  test_that(paste0("rejects ref_date in group_cols (", backend, ")"), {
    expect_error(
      run_wage(backend, wages, group_cols = "ref_date"),
      "should not be included"
    )
  })
}
