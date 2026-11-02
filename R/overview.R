
#' Count unique entities by group
#'
#' Counts how many distinct entities, such as people or contracts, are in each
#' group. Rows with a missing identifier are not counted.
#'
#' @param data Data frame or remote database table (`tbl_dbi`) containing
#'   `id_col` and `group_cols`.
#' @param id_col Character. Column name of the unique identifier for the entity.
#' @param group_cols Character vector of column names to group by, or `NULL` for no grouping.
#' @param ... Arguments passed to methods.
#'
#' @returns A table with the grouping columns and a `count` column representing
#'   the number of unique entities in each group. A data.table sorted by the
#'   grouping columns for data frame input; a lazy table for `tbl_dbi` input
#'   (use [dplyr::collect()] to bring it into memory).
#'
#' @examples
#' hr <- data.frame(
#'   personnel_id = c(1, 1, 2, NA),
#'   est_id = c("A", "A", "B", "B")
#' )
#' count_entity(hr, id_col = "personnel_id", group_cols = "est_id")
#'
#' @export
count_entity <- function(data, ...) {
  UseMethod("count_entity")
}

#' @rdname count_entity
#' @export
count_entity.data.frame <- function(data, id_col, group_cols = NULL, ...) {
  rlang::check_dots_empty()

  # as.data.table() copies, which is wasted on a data.table input
  dt <- if (data.table::is.data.table(data)) {
    data
  } else {
    data.table::as.data.table(data)
  }

  out <- dt[
    !is.na(get(id_col)),
    .(
      count = data.table::uniqueN(get(id_col))
    ),
    keyby = group_cols
  ]

  data.table::setorderv(out, c(group_cols, "count"))

  out[]
}

#' @rdname count_entity
#' @export
count_entity.tbl_dbi <- function(data, id_col, group_cols = NULL, ...) {
  rlang::check_dots_empty()

  data |>
    dplyr::filter(
      !is.na(.data[[id_col]])
    ) |>
    dplyr::summarise(
      count = dplyr::n_distinct(.data[[id_col]]),
      .by = dplyr::all_of(group_cols)
    )
}


#' Compute trend summary
#'
#' Aggregates data over time into a tidy frame of `ref_date`, the optional
#' grouping column, and `value`. Counts rows when `measure_col` is `NULL`
#' (headcount) and sums the column otherwise (wage bill).
#'
#' @param data Data frame containing at least a `ref_date` column.
#' @param group_col Character. Column to group by, or `"ref_date"` for no
#'   grouping.
#' @param measure_col Character. Numeric column to sum, or `NULL` to count rows.
#'
#' @returns A data frame with `ref_date`, optionally `group_col`, and `value`.
#'
#' @importFrom dplyr across all_of
#' @export
compute_trend_summary <- function(data, group_col, measure_col = NULL) {
  groups <- if (group_col == "ref_date") "ref_date" else c("ref_date", group_col)

  if (is.null(measure_col)) {
    fastcount(data, dplyr::across(dplyr::all_of(groups)), name = "value")
  } else {
    compute_fastsummary(
      data,
      cols = measure_col,
      fns = "sum",
      group_cols = groups
    )
  }
}

#' Apply baseline index to a trend summary
#'
#' Rescales `value` so the earliest observation equals 100. When a grouping
#' column is supplied the rescaling is applied independently within each group.
#'
#' @param data Data frame with `ref_date` and `value`, as returned by
#'   [compute_trend_summary()].
#' @param group_col Character. Column to group by, or `"ref_date"` for no
#'   grouping.
#'
#' @returns The input data frame with `value` rescaled to a baseline index.
#'
#' @importFrom dplyr arrange mutate all_of first
#' @export
apply_baseline_index <- function(data, group_col) {
  indexed <- dplyr::arrange(data, .data[["ref_date"]])

  if (group_col == "ref_date") {
    dplyr::mutate(
      indexed,
      value = .data[["value"]] / dplyr::first(.data[["value"]]) * 100
    )
  } else {
    dplyr::mutate(
      indexed,
      value = .data[["value"]] / dplyr::first(.data[["value"]]) * 100,
      .by = dplyr::all_of(group_col)
    )
  }
}

#' Compute cross-section summary
#'
#' Keeps each group's latest reference date and aggregates it into a single
#' `value` per group. Counts rows when `measure_col` is `NULL` (headcount) and
#' sums the column otherwise (wage bill).
#'
#' @param data Data frame containing `ref_date` and the grouping column.
#' @param group_col Character. Column to group by.
#' @param measure_col Character. Numeric column to sum, or `NULL` to count rows.
#'
#' @returns A data frame with the grouping column and a `value` column.
#'
#' @importFrom dplyr all_of filter n summarise
#' @export
compute_cross_section_summary <- function(data, group_col, measure_col = NULL) {
  # only consider each group's latest reference date
  data_latest <- dplyr::filter(
    data,
    .data[["ref_date"]] == max(.data[["ref_date"]]),
    .by = dplyr::all_of(group_col)
  )

  if (is.null(measure_col)) {
    dplyr::summarise(
      data_latest,
      value = dplyr::n(),
      .by = dplyr::all_of(group_col)
    )
  } else {
    govhr::compute_fastsummary(
      data_latest,
      cols = measure_col,
      fns = "sum",
      group_cols = group_col
    )
  }
}
