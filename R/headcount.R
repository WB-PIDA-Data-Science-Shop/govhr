#' Compute headcount by group
#'
#' Counts how many distinct people (`personnel_id`) are in each group within
#' each reference group, usually a reference date, and what share of the
#' reference group's total headcount each group represents.
#'
#' @param data Data frame or remote database table (`tbl_dbi`) with one row
#'   per person-record. Must contain `personnel_id` and the column named in
#'   `reference_group_col`.
#' @param group_cols Character vector of columns to group by, or `NULL` to
#'   count everyone together. Must not include `reference_group_col`.
#' @param reference_group_col Character. Name of the column that defines the
#'   reference groups, usually a date. Shares are computed within each
#'   reference group. Default `"ref_date"`.
#' @param ... Arguments passed to methods.
#'
#' @returns A table with the grouping columns, `reference_group_col`,
#'   `headcount` (number of distinct people) and `share_headcount` (the
#'   group's share of all people in its reference group, between 0 and 1). A
#'   data.table for data frame input; a lazy table for `tbl_dbi` input (use
#'   [dplyr::collect()] to bring it into memory).
#'
#' @details Rows with a missing `personnel_id` are not counted. A group whose
#'   IDs are all missing still appears, with a headcount of 0.
#'
#' @examples
#' hr <- data.frame(
#'   personnel_id = c(1, 2, 3, 1, 2),
#'   ref_date = as.Date(c(rep("2020-01-01", 3), rep("2021-01-01", 2))),
#'   gender = c("F", "M", "F", "F", "M")
#' )
#' compute_headcount(hr, group_cols = "gender")
#'
#' @export
compute_headcount <- function(data, ...) {
  UseMethod("compute_headcount")
}

#' @rdname compute_headcount
#' @importFrom data.table := as.data.table uniqueN
#' @importFrom rlang check_dots_empty
#' @export
compute_headcount.data.frame <- function(
  data,
  group_cols = NULL,
  reference_group_col = "ref_date",
  ...
) {
  rlang::check_dots_empty()

  if (reference_group_col %in% group_cols) {
    stop("`", reference_group_col, "` should not be included in `group_cols`")
  }

  dt <- data.table::as.data.table(data)

  headcount <- dt[
    , .(headcount = uniqueN(personnel_id, na.rm = TRUE)),
    by = c(group_cols, reference_group_col)
  ][
    , share_headcount := headcount / sum(headcount, na.rm = TRUE),
    by = reference_group_col
  ]

  headcount
}

#' @rdname compute_headcount
#' @importFrom dplyr across all_of group_by mutate n_distinct summarise ungroup
#' @importFrom rlang check_dots_empty
#' @export
compute_headcount.tbl_dbi <- function(
  data,
  group_cols = NULL,
  reference_group_col = "ref_date",
  ...
) {
  rlang::check_dots_empty()

  if (reference_group_col %in% group_cols) {
    stop("`", reference_group_col, "` should not be included in `group_cols`")
  }

  headcount <- data |>
    group_by(across(all_of(c(group_cols, reference_group_col)))) |>
    summarise(
      headcount = n_distinct(personnel_id, na.rm = TRUE),
      .groups = "drop"
    ) |>
    group_by(across(all_of(reference_group_col))) |>
    mutate(
      share_headcount = headcount / sum(headcount, na.rm = TRUE)
    ) |>
    ungroup()

  headcount
}
