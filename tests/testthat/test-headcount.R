# ---- compute_headcount -------------------------------------------------------
# Shares are computed within each combination of `reference_group_cols`, and
# the data.table and tbl_dbi methods must agree. Person 3 holds two records in
# one group and counts once; the record with a missing id is not counted.

hr <- data.frame(
  personnel_id = c(1, 2, 3, 3, NA, 4, 1, 2),
  ref_date = as.Date(c(rep("2020-01-01", 6), rep("2021-01-01", 2))),
  country = c("A", "A", "A", "A", "A", "B", "A", "B"),
  gender = c("F", "M", "F", "F", "M", "F", "F", "M"),
  stringsAsFactors = FALSE
)

expected <- data.frame(
  gender = c("F", "M", "F", "F", "M"),
  ref_date = as.Date(c(rep("2020-01-01", 3), rep("2021-01-01", 2))),
  country = c("A", "A", "B", "A", "B"),
  headcount = c(2L, 1L, 1L, 1L, 1L),
  share_headcount = c(2 / 3, 1 / 3, 1, 1, 1),
  stringsAsFactors = FALSE
)

# in-memory data frame sorted the same way for every backend
tidy_headcount <- function(headcount) {
  headcount <- as.data.frame(dplyr::collect(headcount))
  headcount[["headcount"]] <- as.integer(headcount[["headcount"]])
  headcount <- headcount[order(headcount[["ref_date"]], headcount[["country"]], headcount[["gender"]]), ]
  rownames(headcount) <- NULL
  headcount[names(expected)]
}

test_that("compute_headcount shares headcount within several reference columns", {
  reference_group_cols <- c("ref_date", "country")

  # a tibble goes through the data.frame method
  expect_equal(
    tidy_headcount(
      compute_headcount(
        tibble::as_tibble(hr),
        group_cols = "gender",
        reference_group_cols = reference_group_cols
      )
    ),
    expected
  )

  expect_error(
    compute_headcount(hr, group_cols = c("gender", "country"), reference_group_cols = reference_group_cols),
    "`country` should not be included in `group_cols`"
  )

  skip_if_not_installed("duckdb")
  skip_if_not_installed("dbplyr")

  # silence duckdb's notice about where it stores extensions
  con <- suppressMessages(DBI::dbConnect(duckdb::duckdb()))
  on.exit(DBI::dbDisconnect(con, shutdown = TRUE))
  DBI::dbWriteTable(con, "hr", hr)

  expect_equal(
    tidy_headcount(
      compute_headcount(
        dplyr::tbl(con, "hr"),
        group_cols = "gender",
        reference_group_cols = reference_group_cols
      )
    ),
    expected
  )
})
