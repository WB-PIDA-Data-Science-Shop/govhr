#' Compute record consistency
#'
#' Computes, for each group, the share of identifiers that appear in exactly
#' one record per reference date, as a percentage.
#'
#' @param data Data frame or remote database table (`tbl_dbi`) with `ref_date`
#'   and the columns named in `id_col` and `group_cols`.
#' @param id_col Character. Column identifying the entity, such as
#'   `"personnel_id"`.
#' @param group_cols Character vector of columns to group by, such as
#'   `"ref_date"`, or `NULL` (default) for the whole table.
#' @param digits Whole number. Decimal places to round to. Default `2`.
#' @param ... Arguments passed to methods.
#'
#' @returns A table with the grouping columns and `record_consistency`, from 0
#'   to 100. A data.table for data frame input; a lazy table for `tbl_dbi`
#'   input (use [dplyr::collect()] to bring it into memory).
#'
#' @details
#' Records are counted per identifier, `ref_date` and group. A combination
#' with exactly one record is consistent, and `record_consistency` is the
#' share of consistent combinations in each group. Missing identifiers and
#' groups are kept as their own value.
#'
#' @seealso [compute_value_consistency()], which checks that each identifier
#'   keeps the same value. [compute_global_consistency()], which combines
#'   both.
#'
#' @examples
#' hr <- data.frame(
#'   personnel_id = c("a", "a", "b"),
#'   ref_date = as.Date("2020-01-01")
#' )
#' compute_record_consistency(hr, id_col = "personnel_id")
#'
#' @export
compute_record_consistency <- function(data, ...) {
  UseMethod("compute_record_consistency")
}

#' @rdname compute_record_consistency
#' @importFrom data.table .N as.data.table setorderv
#' @importFrom rlang check_dots_empty
#' @export
compute_record_consistency.data.frame <- function(
  data,
  id_col,
  group_cols = NULL,
  digits = 2,
  ...
) {
  rlang::check_dots_empty()

  dt <- data.table::as.data.table(data)
  count_cols <- unique(c(id_col, "ref_date", group_cols))

  records <- dt[, .(n_records = .N), by = count_cols]

  consistency <- records[
    , .(record_consistency = round(100 * mean(n_records == 1), digits)),
    by = group_cols
  ]

  if (!is.null(group_cols)) {
    data.table::setorderv(consistency, group_cols)
  }

  consistency[]
}

#' @rdname compute_record_consistency
#' @importFrom dplyr across all_of count if_else summarise
#' @importFrom rlang check_dots_empty
#' @export
compute_record_consistency.tbl_dbi <- function(
  data,
  id_col,
  group_cols = NULL,
  digits = 2,
  ...
) {
  rlang::check_dots_empty()

  count_cols <- unique(c(id_col, "ref_date", group_cols))

  data |>
    dplyr::count(dplyr::across(dplyr::all_of(count_cols)), name = "n_records") |>
    dplyr::summarise(
      # whole digits, which SQL's ROUND() requires
      record_consistency = round(
        100 * mean(dplyr::if_else(n_records == 1, 1, 0), na.rm = TRUE),
        !!as.integer(digits)
      ),
      .by = dplyr::all_of(group_cols)
    )
}

#' Compute value consistency
#'
#' Computes, for each group, the share of identifiers that keep a single value
#' of `value_col`, as a percentage.
#'
#' @inheritParams compute_record_consistency
#' @param value_col Character. Column whose values should stay the same for
#'   each identifier, such as `"birth_date"`.
#'
#' @returns A table with the grouping columns and `value_consistency`, from 0
#'   to 100. A data.table for data frame input; a lazy table for `tbl_dbi`
#'   input (use [dplyr::collect()] to bring it into memory).
#'
#' @details
#' Distinct values of `value_col` are counted per identifier and group, across
#' all dates unless `ref_date` is one of `group_cols`. An identifier with
#' exactly one distinct value is consistent. A missing value counts as a value
#' of its own, so an identifier recorded with and without a value is not
#' consistent.
#'
#' @seealso [compute_record_consistency()], which checks that each identifier
#'   has one record per date. [compute_global_consistency()], which combines
#'   both.
#'
#' @examples
#' hr <- data.frame(
#'   personnel_id = c("a", "a", "b"),
#'   ref_date = as.Date(c("2020-01-01", "2021-01-01", "2020-01-01")),
#'   birth_date = as.Date(c("1980-01-01", "1981-01-01", "1990-01-01"))
#' )
#' compute_value_consistency(hr, id_col = "personnel_id", value_col = "birth_date")
#'
#' @export
compute_value_consistency <- function(data, ...) {
  UseMethod("compute_value_consistency")
}

#' @rdname compute_value_consistency
#' @importFrom data.table .N as.data.table setorderv
#' @importFrom rlang check_dots_empty
#' @export
compute_value_consistency.data.frame <- function(
  data,
  id_col,
  value_col,
  group_cols = NULL,
  digits = 2,
  ...
) {
  rlang::check_dots_empty()

  dt <- data.table::as.data.table(data)
  by_cols <- unique(c(id_col, group_cols))

  distinct_values <- unique(dt[, c(by_cols, value_col), with = FALSE])[
    , .(n_values = .N),
    by = by_cols
  ]

  consistency <- distinct_values[
    , .(value_consistency = round(100 * mean(n_values == 1), digits)),
    by = group_cols
  ]

  if (!is.null(group_cols)) {
    data.table::setorderv(consistency, group_cols)
  }

  consistency[]
}

#' @rdname compute_value_consistency
#' @importFrom dplyr across all_of count distinct if_else summarise
#' @importFrom rlang check_dots_empty
#' @export
compute_value_consistency.tbl_dbi <- function(
  data,
  id_col,
  value_col,
  group_cols = NULL,
  digits = 2,
  ...
) {
  rlang::check_dots_empty()

  by_cols <- unique(c(id_col, group_cols))

  data |>
    dplyr::distinct(dplyr::across(dplyr::all_of(c(by_cols, value_col)))) |>
    dplyr::count(dplyr::across(dplyr::all_of(by_cols)), name = "n_values") |>
    dplyr::summarise(
      # whole digits, which SQL's ROUND() requires
      value_consistency = round(
        100 * mean(dplyr::if_else(n_values == 1, 1, 0), na.rm = TRUE),
        !!as.integer(digits)
      ),
      .by = dplyr::all_of(group_cols)
    )
}

#' Compute global consistency
#'
#' Averages record consistency and the value consistency of the columns in
#' `value_cols` into a single percentage for the whole table.
#'
#' @inheritParams compute_record_consistency
#' @param value_cols Character vector of columns whose values should stay the
#'   same for each identifier.
#'
#' @returns A number from 0 to 100.
#'
#' @details
#' The value consistencies of `value_cols` are averaged first, and that
#' average weighs as much as record consistency. Intermediate results are not
#' rounded, so rounding errors do not compound.
#'
#' @seealso [compute_record_consistency()] and
#'   [compute_value_consistency()], which it combines.
#'
#' @examples
#' hr <- data.frame(
#'   personnel_id = c("a", "a", "b"),
#'   ref_date = as.Date(c("2020-01-01", "2021-01-01", "2020-01-01")),
#'   birth_date = as.Date(c("1980-01-01", "1981-01-01", "1990-01-01"))
#' )
#' compute_global_consistency(hr, "personnel_id", value_cols = "birth_date")
#'
#' @importFrom dplyr pull
#' @importFrom purrr map_dbl
#' @export
compute_global_consistency <- function(data, id_col, value_cols, digits = 2) {
  record_consistency <- compute_record_consistency(
    data,
    id_col = id_col,
    digits = 10
  ) |>
    dplyr::pull(.data[["record_consistency"]])

  value_consistency <- value_cols |>
    purrr::map_dbl(
      \(value_col) {
        compute_value_consistency(
          data,
          id_col = id_col,
          value_col = value_col,
          digits = 10
        ) |>
          dplyr::pull(.data[["value_consistency"]])
      }
    ) |>
    mean(na.rm = TRUE)

  round(mean(c(record_consistency, value_consistency), na.rm = TRUE), digits)
}
