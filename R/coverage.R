#' Compute data coverage
#'
#' Computes, for each group, the share of non-missing values in every other
#' column, as a percentage. Optionally averages the shares across columns,
#' giving one coverage value per group.
#'
#' @param data Data frame or remote database table (`tbl_dbi`).
#' @param group_cols Character vector of columns to group by, or `NULL`
#'   (default) for no grouping.
#' @param include_ref_date Logical. Also group by `ref_date`. Default `FALSE`.
#' @param aggregate Logical. Average the coverage across columns, giving one
#'   value per group. Default `FALSE`.
#' @param ... Arguments passed to methods.
#'
#' @returns A table with the grouping columns, `variable` (the name of a
#'   column, unless `aggregate` is `TRUE`) and `coverage` (the share of
#'   non-missing values, from 0 to 100). A data.table, also for `tbl_dbi`
#'   input.
#'
#' @details
#' Every column that is not a grouping column is covered, identifiers
#' included. Missing groups are kept as their own group. With
#' `aggregate = TRUE`, every column weighs equally in the average.
#'
#' For `tbl_dbi` input, the coverage of every column is computed in the
#' database, giving one row per group, and only that summary is brought into
#' memory to be reshaped.
#'
#' @seealso [compute_global_coverage()], which gives a single coverage
#'   value for the whole table. [plot_coverage_trend()],
#'   [plot_coverage_bar()] and [plot_coverage_heatmap()], which
#'   draw coverage.
#'
#' @examples
#' hr <- data.frame(
#'   ref_date = as.Date(c("2020-01-01", "2020-01-01", "2021-01-01")),
#'   gender = c("F", NA, "M"),
#'   birth_date = as.Date(c("1980-01-01", NA, NA))
#' )
#' compute_coverage(hr, include_ref_date = TRUE)
#'
#' @export
compute_coverage <- function(data, ...) {
  UseMethod("compute_coverage")
}

#' @rdname compute_coverage
#' @importFrom data.table .SD as.data.table melt setorderv
#' @importFrom rlang check_dots_empty
#' @export
compute_coverage.data.frame <- function(
  data,
  group_cols = NULL,
  include_ref_date = FALSE,
  aggregate = FALSE,
  ...
) {
  rlang::check_dots_empty()

  if (include_ref_date) {
    group_cols <- unique(c("ref_date", group_cols))
  }

  dt <- data.table::as.data.table(data)
  value_cols <- setdiff(names(dt), group_cols)

  coverage_wide <- dt[
    , lapply(.SD, \(col) 100 * mean(!is.na(col))),
    by = group_cols,
    .SDcols = value_cols
  ]

  pivot_coverage(coverage_wide, group_cols, value_cols, aggregate)
}

#' @rdname compute_coverage
#' @importFrom dplyr across all_of collect if_else summarise
#' @importFrom rlang check_dots_empty
#' @export
compute_coverage.tbl_dbi <- function(
  data,
  group_cols = NULL,
  include_ref_date = FALSE,
  aggregate = FALSE,
  ...
) {
  rlang::check_dots_empty()

  if (include_ref_date) {
    group_cols <- unique(c("ref_date", group_cols))
  }

  value_cols <- setdiff(colnames(data), group_cols)

  # the wide summary has one row per group, so reshaping it in memory is cheap,
  # whereas reshaping in SQL takes dbplyr seconds to render for a few dozen
  # columns
  coverage_wide <- data |>
    dplyr::summarise(
      dplyr::across(
        dplyr::all_of(value_cols),
        \(col) 100 * mean(dplyr::if_else(is.na(col), 0, 1), na.rm = TRUE)
      ),
      .by = dplyr::all_of(group_cols)
    ) |>
    dplyr::collect()

  pivot_coverage(coverage_wide, group_cols, value_cols, aggregate)
}

# reshapes one row per group with a coverage column per variable into one row
# per group and variable, shared by both compute_coverage() methods
#' @importFrom data.table as.data.table melt setorderv
#' @keywords internal
#' @noRd
pivot_coverage <- function(coverage_wide, group_cols, value_cols, aggregate) {
  coverage <- data.table::melt(
    data.table::as.data.table(coverage_wide),
    id.vars = group_cols,
    measure.vars = value_cols,
    variable.name = "variable",
    value.name = "coverage",
    variable.factor = FALSE
  )

  if (aggregate) {
    coverage <- coverage[, .(coverage = mean(coverage)), by = group_cols]
  }

  # stable, so each group keeps its variables in column order
  if (!is.null(group_cols)) {
    data.table::setorderv(coverage, group_cols)
  }

  coverage[]
}

#' Compute global coverage
#'
#' Computes the share of non-missing values across every cell of a table, as a
#' percentage.
#'
#' @param data Data frame or remote database table (`tbl_dbi`).
#' @param digits Whole number. Decimal places to round to. Default `2`.
#'
#' @returns A number from 0 to 100.
#'
#' @details
#' Every column has the same number of records, so the share across all cells
#' is the average of each column's coverage from [compute_coverage()], which
#' is computed in the database for `tbl_dbi` input.
#'
#' @seealso [compute_coverage()], which gives the coverage of each column.
#'
#' @examples
#' hr <- data.frame(gender = c("F", NA, "M"), grade = c(NA, NA, "G1"))
#' compute_global_coverage(hr)
#'
#' @export
compute_global_coverage <- function(data, digits = 2) {
  coverage <- compute_coverage(data)

  round(mean(coverage[["coverage"]]), digits)
}
