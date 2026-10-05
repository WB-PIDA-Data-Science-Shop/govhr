# ---- compute_movement -------------------------------------------------------
# Every test runs on a data frame (data.table method) and on a duckdb table
# (tbl_dbi method), so the two implementations are held to the same behaviour.

backends <- c("data.frame", "duckdb")

# run compute_movement() on `data` or a duckdb copy of it, and return an
# in-memory data frame sorted the same way for both backends
run_movement <- function(backend, data, ...) {
  if (backend == "duckdb") {
    skip_if_not_installed("duckdb")
    skip_if_not_installed("dbplyr")

    # silence duckdb's notice about where it stores extensions
    con <- suppressMessages(DBI::dbConnect(duckdb::duckdb()))
    on.exit(DBI::dbDisconnect(con, shutdown = TRUE))

    DBI::dbWriteTable(con, "movement", data)
    data <- dplyr::tbl(con, "movement")
  }

  result <- as.data.frame(dplyr::collect(compute_movement(data, ...)))

  sort_cols <- intersect(c("ref_date", "est_id"), names(result))
  result <- result[do.call(order, unname(result[sort_cols])), ]
  rownames(result) <- NULL

  result
}

# person 1 stays throughout, person 2 leaves after 2020, person 3 joins in
# 2021. person 4 is never active
hr <- data.frame(
  personnel_id = c(1, 2, 4, 1, 3, 1, 3),
  ref_date = as.Date(c(
    "2020-01-01", "2020-01-01", "2020-01-01",
    "2021-01-01", "2021-01-01",
    "2022-01-01", "2022-01-01"
  )),
  est_id = c("A", "A", "A", "A", "B", "B", "B"),
  employment_status = c(
    "active", "active", "inactive", "active", "active", "active", "active"
  )
)

for (backend in backends) {
  test_that(paste0("counts headcount, hires and separations (", backend, ")"), {
    result <- run_movement(backend, hr)

    expect_named(
      result,
      c(
        "ref_date", "headcount", "hires", "separations",
        "hire_rate", "separation_rate"
      )
    )
    expect_equal(result$headcount, c(2, 2, 2))
    expect_equal(result$hires, c(NA, 1, 0))
    expect_equal(result$separations, c(1, 0, NA))
    expect_equal(result$hire_rate, c(NA, 0.5, 0))
    expect_equal(result$separation_rate, c(0.5, 0, NA))
  })

  test_that(paste0("counts people with several contracts once (", backend, ")"), {
    duplicated_hr <- rbind(hr, hr[hr$personnel_id == 3, ])

    expect_equal(
      run_movement(backend, duplicated_hr),
      run_movement(backend, hr)
    )
  })

  test_that(paste0("moving between groups is not a hire (", backend, ")"), {
    result <- run_movement(backend, hr, group_cols = "est_id")

    # person 1 moves from A to B in 2022 without being hired or separated
    expect_equal(result$est_id, c("A", "A", "B", "B"))
    expect_equal(result$headcount, c(2, 1, 1, 2))
    expect_equal(result$hires, c(NA, 0, 1, 0))
    expect_equal(result$separations, c(1, 0, 0, NA))
  })

  test_that(paste0("uses a custom status column (", backend, ")"), {
    renamed_hr <- hr
    names(renamed_hr)[names(renamed_hr) == "employment_status"] <- "status"

    expect_equal(
      run_movement(backend, renamed_hr, status_col = "status"),
      run_movement(backend, hr)
    )
  })

  test_that(paste0("rejects ref_date in group_cols (", backend, ")"), {
    expect_error(
      run_movement(backend, hr, group_cols = "ref_date"),
      "should not be included"
    )
  })
}

test_that("does not modify a data.table input", {
  input <- data.table::as.data.table(hr)
  before <- data.table::copy(input)

  compute_movement(input)

  expect_identical(input, before)
})
