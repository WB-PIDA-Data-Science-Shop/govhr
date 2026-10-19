# ---- compute_wage and compute_wagebill ---------------------------------------
# Every test runs on a data frame (data.table method) and on a duckdb table
# (tbl_dbi method), so the two implementations are held to the same behaviour.

backends <- c("data.frame", "duckdb")

# run `fun` on `data` or a duckdb copy of it, and return an in-memory data
# frame sorted the same way for both backends
run_wage <- function(backend, data, ..., fun = compute_wage) {
  if (backend == "duckdb") {
    skip_if_not_installed("duckdb")
    skip_if_not_installed("dbplyr")

    # silence duckdb's notice about where it stores extensions
    con <- suppressMessages(DBI::dbConnect(duckdb::duckdb()))
    on.exit(DBI::dbDisconnect(con, shutdown = TRUE))

    DBI::dbWriteTable(con, "wages", data)
    data <- dplyr::tbl(con, "wages")
  }

  result <- as.data.frame(dplyr::collect(fun(data, ...)))

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

# A and B are in country X and C in country Y. B has no record in 2021, and
# country Y none in 2022
country_wages <- data.frame(
  ref_date = as.Date(c(
    "2020-01-01", "2020-01-01", "2020-01-01",
    "2021-01-01", "2021-01-01",
    "2022-01-01", "2022-01-01"
  )),
  country = c("X", "X", "Y", "X", "Y", "X", "X"),
  est_id = c("A", "B", "C", "A", "C", "A", "B"),
  gross_salary_lcu = c(100, 300, 400, 300, 200, 330, 330)
)

for (backend in backends) {
  test_that(paste0("averages wages for each date (", backend, ")"), {
    result <- run_wage(backend, wages)

    expect_named(result, c("ref_date", "wage", "wage_growth"))
    expect_equal(result$wage, c(250, 300, 330))
    expect_equal(result$wage_growth, c(NA, 0.2, 0.1))

    renamed <- wages
    names(renamed)[names(renamed) == "gross_salary_lcu"] <- "base_salary_lcu"

    expect_equal(run_wage(backend, renamed, measure_col = "base_salary_lcu"), result)
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

  test_that(paste0("compute_wagebill shares within several reference columns (", backend, ")"), {
    result <- run_wage(
      backend,
      country_wages,
      group_cols = "est_id",
      reference_group_cols = c("ref_date", "country"),
      fun = compute_wagebill
    )

    # each establishment is a series within its own country only
    expect_equal(result$est_id, rep(c("A", "B", "C"), each = 3))
    expect_equal(result$country, rep(c("X", "X", "Y"), each = 3))
    expect_equal(result$wagebill, c(100, 300, 330, 300, NA, 330, 400, 200, NA))
    expect_equal(
      result$share_wagebill,
      c(0.25, 1, 0.5, 0.75, NA, 0.5, 1, 1, NA)
    )
    expect_equal(
      result$wagebill_growth,
      c(NA, 2, 0.1, NA, NA, NA, NA, -0.5, NA)
    )

    expect_error(
      run_wage(
        backend,
        country_wages,
        reference_group_cols = "country",
        fun = compute_wagebill
      ),
      "must include `ref_date`"
    )
  })

  test_that(paste0("rejects ref_date in group_cols (", backend, ")"), {
    expect_error(
      run_wage(backend, wages, group_cols = "ref_date"),
      "should not be included"
    )
    expect_error(
      run_wage(
        backend,
        country_wages,
        group_cols = "country",
        reference_group_cols = c("ref_date", "country"),
        fun = compute_wagebill
      ),
      "`country` should not be included"
    )
  })
}
