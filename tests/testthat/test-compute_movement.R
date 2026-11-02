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
        "hire_rate", "separation_rate", "replacement_rate"
      )
    )
    expect_equal(result$headcount, c(2, 2, 2))
    expect_equal(result$hires, c(NA, 1, 0))
    # person 2 leaves after 2020, so is counted in 2021, the first date absent
    expect_equal(result$separations, c(NA, 1, 0))
    expect_equal(result$hire_rate, c(NA, 0.5, 0))
    expect_equal(result$separation_rate, c(NA, 0.5, 0))
    # person 3 replaces person 2 in 2021; nobody moves in 2022
    expect_equal(result$replacement_rate, c(NA, 1, NaN))
  })

  test_that(paste0("adds hires and removes separations from headcount (", backend, ")"), {
    # people join, leave and return at different dates
    churn <- data.frame(
      personnel_id = c(1, 2, 3, 1, 3, 4, 2, 4, 5, 2, 5),
      ref_date = as.Date(rep(
        c("2020-01-01", "2021-01-01", "2022-01-01", "2023-01-01"),
        times = c(3, 3, 3, 2)
      )),
      employment_status = "active"
    )

    result <- run_movement(backend, churn)
    previous <- result$headcount[-nrow(result)]

    expect_equal(
      result$headcount[-1],
      previous + result$hires[-1] - result$separations[-1]
    )
  })

  test_that(paste0("rates divide by the previous headcount (", backend, ")"), {
    # four people in 2020, two of whom leave; one more joins in 2021
    shrinking <- data.frame(
      personnel_id = c(1, 2, 3, 4, 1, 2, 5),
      ref_date = as.Date(rep(c("2020-01-01", "2021-01-01"), times = c(4, 3))),
      employment_status = "active"
    )

    result <- run_movement(backend, shrinking)

    expect_equal(result$separations, c(NA, 2))
    expect_equal(result$separation_rate, c(NA, 2 / 4))
    expect_equal(result$hire_rate, c(NA, 1 / 4))
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

    # person 1 moves from A to B in 2022 without being hired or separated,
    # leaving A empty, which still appears in 2022. B has nobody in 2020, so
    # has no headcount to compare its 2021 separations with
    expect_equal(result$est_id, c("A", "A", "B", "A", "B"))
    expect_equal(result$headcount, c(2, 1, 1, 0, 2))
    expect_equal(result$hires, c(NA, 0, 1, 0, 0))
    expect_equal(result$separations, c(NA, 1, NA, 0, 0))
  })

  test_that(paste0("counts a separation in the group left (", backend, ")"), {
    # everyone in A leaves after 2020
    closing <- data.frame(
      personnel_id = c(1, 2, 3, 3),
      ref_date = as.Date(c(
        "2020-01-01", "2020-01-01", "2020-01-01", "2021-01-01"
      )),
      est_id = c("A", "A", "B", "B"),
      employment_status = "active"
    )

    result <- run_movement(backend, closing, group_cols = "est_id")

    expect_equal(result$est_id, c("A", "B", "A", "B"))
    expect_equal(result$headcount, c(2, 1, 0, 1))
    expect_equal(result$separations, c(NA, NA, 2, 0))
    expect_equal(result$separation_rate, c(NA, NA, 1, 0))
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
