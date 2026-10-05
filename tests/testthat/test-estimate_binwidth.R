# ---- estimate_binwidth -------------------------------------------------------
# Every test runs on a data frame and on a duckdb table, since the quantiles
# are computed in the database for tbl_dbi input.

backends <- c("data.frame", "duckdb")

run_binwidth <- function(backend, data, ...) {
  if (backend == "duckdb") {
    skip_if_not_installed("duckdb")
    skip_if_not_installed("dbplyr")

    # silence duckdb's notice about where it stores extensions
    con <- suppressMessages(DBI::dbConnect(duckdb::duckdb()))
    on.exit(DBI::dbDisconnect(con, shutdown = TRUE))

    DBI::dbWriteTable(con, "pay", data)
    data <- dplyr::tbl(con, "pay")
  }

  estimate_binwidth(data, "gross_salary_lcu", ...)
}

# skewed pay, like real salaries: most people earn little, a few earn a lot
set.seed(1)
skewed_pay <- data.frame(gross_salary_lcu = round(rlnorm(5000, meanlog = 7.5, sdlog = 0.7)))

for (backend in backends) {
  test_that(paste0("returns a readable whole-number width (", backend, ")"), {
    binwidth <- run_binwidth(backend, skewed_pay)

    expect_equal(binwidth, round(binwidth))
    # 1, 2 or 5 times a power of ten
    expect_true((binwidth / 10^floor(log10(binwidth))) %in% c(1, 2, 5))
  })

  test_that(paste0("keeps the bulk of pay within 20 to 60 bins (", backend, ")"), {
    p <- quantile(skewed_pay$gross_salary_lcu, c(0.01, 0.99))
    n_bins <- diff(p) / run_binwidth(backend, skewed_pay)

    # rounding the width up (e.g. from just over 2 to 5) can cut the number of
    # bins by up to 2.5 times
    expect_gte(n_bins, 20 / 2.5)
    expect_lte(n_bins, 60)
  })

  test_that(paste0("is not thrown off by a few very high salaries (", backend, ")"), {
    with_outliers <- rbind(skewed_pay, data.frame(gross_salary_lcu = c(1e7, 2e7)))

    expect_equal(
      run_binwidth(backend, with_outliers),
      run_binwidth(backend, skewed_pay)
    )
  })

  test_that(paste0("returns 1 when pay barely varies (", backend, ")"), {
    expect_equal(run_binwidth(backend, data.frame(gross_salary_lcu = rep(500, 10))), 1)
  })

  test_that(paste0("ignores missing pay and rejects all-missing pay (", backend, ")"), {
    with_missing <- rbind(skewed_pay, data.frame(gross_salary_lcu = rep(NA, 100)))

    expect_equal(run_binwidth(backend, with_missing), run_binwidth(backend, skewed_pay))
    expect_error(
      run_binwidth(backend, data.frame(gross_salary_lcu = c(NA_real_, NA_real_))),
      "no non-missing values"
    )
  })
}
