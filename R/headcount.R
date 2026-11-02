#' Compute headcount by group
#'
#' Counts how many distinct people (`personnel_id`) are in each group within
#' each reference group, usually a reference date, and what share of the
#' reference group's total headcount each group represents.
#'
#' @param data Data frame or remote database table (`tbl_dbi`) with one row
#'   per person-record. Must contain `personnel_id` and the columns named in
#'   `reference_group_cols`.
#' @param group_cols Character vector of columns to group by, or `NULL` to
#'   count everyone together. Must not overlap with `reference_group_cols`.
#' @param reference_group_cols Character vector of the columns that together
#'   define the reference groups, such as a date, or a date and a country.
#'   Shares are computed within each combination of these columns. Default
#'   `"ref_date"`.
#' @param ... Arguments passed to methods.
#'
#' @returns A table with the grouping columns, `reference_group_cols`,
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
#'   country = c("A", "A", "B", "A", "B"),
#'   gender = c("F", "M", "F", "F", "M")
#' )
#' compute_headcount(hr, group_cols = "gender")
#'
#' # shares within each date and country
#' compute_headcount(
#'   hr,
#'   group_cols = "gender",
#'   reference_group_cols = c("ref_date", "country")
#' )
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
  reference_group_cols = "ref_date",
  ...
) {
  rlang::check_dots_empty()

  overlap <- intersect(reference_group_cols, group_cols)

  if (length(overlap) > 0) {
    stop("`", paste(overlap, collapse = "`, `"), "` should not be included in `group_cols`")
  }

  dt <- data.table::as.data.table(data)

  headcount <- dt[
    , .(headcount = uniqueN(personnel_id, na.rm = TRUE)),
    by = c(group_cols, reference_group_cols)
  ][
    , share_headcount := headcount / sum(headcount, na.rm = TRUE),
    by = reference_group_cols
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
  reference_group_cols = "ref_date",
  ...
) {
  rlang::check_dots_empty()

  overlap <- intersect(reference_group_cols, group_cols)

  if (length(overlap) > 0) {
    stop("`", paste(overlap, collapse = "`, `"), "` should not be included in `group_cols`")
  }

  headcount <- data |>
    group_by(across(all_of(c(group_cols, reference_group_cols)))) |>
    summarise(
      headcount = n_distinct(personnel_id, na.rm = TRUE),
      .groups = "drop"
    ) |>
    group_by(across(all_of(reference_group_cols))) |>
    mutate(
      share_headcount = headcount / sum(headcount, na.rm = TRUE)
    ) |>
    ungroup()

  headcount
}
