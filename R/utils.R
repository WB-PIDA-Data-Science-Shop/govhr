#' Drop rows with missing values in selected columns
#'
#' Keeps only the rows where every column in `cols` is non-missing. This
#' implementation was designed for use with duckplyr databases.
#'
#' @param data A data frame or lazy database table.
#' @param cols A character vector of column names that must not be `NA`.
#'
#' @return `data` with rows containing `NA` in any of `cols` removed.
#'
#' @importFrom rlang syms expr !!!
#' @importFrom dplyr filter
#' @keywords internal
drop_missing <- function(data, cols){
  conditions <- lapply(
    rlang::syms(cols),
    function(col) rlang::expr(!is.na(!!col))
  )

  data |>
    filter(!!!conditions)
}

#' Build a calendar of reference dates
#'
#' Lists each distinct `ref_date` in the data alongside the reference date
#' immediately before and after it. Useful for matching each period to its
#' neighbours, e.g. when computing period-over-period changes.
#'
#' @param data A data frame or lazy database table with a `ref_date` column.
#'
#' @return A table with one row per distinct `ref_date` and columns
#'   `ref_date`, `prev_date` (the previous reference date, `NA` for the
#'   first) and `next_date` (the next reference date, `NA` for the last).
#'
#' @importFrom dplyr distinct mutate lag lead
#' @keywords internal
build_calendar <- function(data) {
  calendar <- data |>
    distinct(ref_date) |>
    mutate(
      prev_date = lag(ref_date, order_by = ref_date),
      next_date = lead(ref_date, order_by = ref_date)
    )

  calendar
}

#' Group ages into age bands
#'
#' Converts a numeric age into a factor of age bands. Each band includes its
#' lower bound and excludes its upper bound, so an age of 30 falls in
#' `"30-39"`, not `"20-29"`.
#'
#' @param age A numeric vector of ages.
#' @param breaks A numeric vector of band boundaries, passed to [base::cut()].
#' @param labels A character vector of band labels, one fewer than `breaks`.
#'
#' @return A factor the same length as `age`, with levels given by `labels`.
#'
#' @keywords internal
cut_age <- function(
  age,
  breaks = c(-Inf, 20, 30, 40, 50, 60, Inf),
  labels = c("<20", "20-29", "30-39", "40-49", "50-59", "60+")
){
  cut(
    age,
    breaks = breaks,
    labels = labels,
    right = FALSE
  )
}

#' Check that a table has the columns a function needs
#'
#' @param data A data frame or lazy database table.
#' @param required_cols A character vector of column names `data` must have.
#' @param arg Character. Name of the argument holding `data`, used in the
#'   error message.
#'
#' @return `data`, invisibly. Stops with an error listing the missing columns
#'   if there are any.
#'
#' @keywords internal
check_required_cols <- function(data, required_cols, arg = "data"){
  # colnames() rather than names(), which does not list a tbl_dbi's columns
  missing_cols <- setdiff(required_cols, colnames(data))

  if(length(missing_cols) > 0){
    stop(
      "`", arg, "` is missing required columns: ",
      paste(missing_cols, collapse = ", ")
    )
  }

  invisible(data)
}

#' Check that a panel has enough snapshots
#'
#' Panel analyses that compare consecutive snapshots (decrement rates,
#' movement and exit rates, ...) need a minimum number of distinct reference
#' dates. Callers count the distinct, non-missing dates themselves, so the
#' check works the same for in-memory and database tables.
#'
#' @param n_snaps Integer. Number of distinct, non-missing reference dates
#'   in the panel.
#' @param min_snaps Integer. Minimum number of snapshots required. Default
#'   `2`, the fewest that form one consecutive pair.
#' @param arg Character. Name of the argument holding the panel, used in the
#'   error message.
#' @param ref_date_col Character. Name of the reference date column, used in
#'   the error message.
#'
#' @return `n_snaps`, invisibly. Stops with an error if it is below
#'   `min_snaps`.
#'
#' @keywords internal
.check_panel_snapshots <- function(n_snaps,
                                   min_snaps = 2L,
                                   arg = "data",
                                   ref_date_col = "ref_date") {
  if (n_snaps < min_snaps) {
    stop(
      "`", arg, "` must contain at least ", min_snaps, " snapshots ",
      "(distinct, non-missing `", ref_date_col, "` values); found ",
      n_snaps, ".",
      call. = FALSE
    )
  }

  invisible(n_snaps)
}

#' Stop for data a function cannot handle
#'
#' Used by the `.default` method of generics that accept a data frame or a
#' lazy database table, so unsupported input (a list, vector, matrix, ...)
#' gets an error that names the argument instead of R's "no applicable
#' method" message.
#'
#' @param x The object that was passed.
#' @param arg Character. Name of the argument holding `x`, used in the error
#'   message.
#'
#' @return Does not return; always stops with an error.
#'
#' @keywords internal
stop_unsupported_data <- function(x, arg = "data") {
  stop(
    "`", arg, "` must be a data frame or a lazy database table (tbl_dbi), ",
    "not a <", class(x)[1], ">.",
    call. = FALSE
  )
}

#' Keep the contracts of active personnel
#'
#' Matches each contract to the personnel module by `personnel_id` and
#' `ref_date`, and keeps only the contracts of people whose
#' `employment_status` is `"active"` on that date. Contracts with no matching
#' personnel record are dropped.
#'
#' @param contracts A data frame or lazy database table with `personnel_id`
#'   and `ref_date`.
#' @param personnel A data frame or lazy database table with `personnel_id`,
#'   `ref_date` and `employment_status`. For lazy tables, it must live in the
#'   same database as `contracts`.
#'
#' @return `contracts`, filtered to active personnel, with an
#'   `employment_status` column taken from `personnel` (always `"active"`).
#'
#' @importFrom dplyr across all_of any_of distinct filter inner_join select
#' @importFrom rlang .data
#' @keywords internal
keep_active_contracts <- function(contracts, personnel){
  # one row per person and date, so the join does not duplicate contracts
  active_personnel <- personnel |>
    filter(.data[["employment_status"]] == "active") |>
    distinct(across(all_of(c("personnel_id", "ref_date", "employment_status"))))

  # status comes from the personnel module, so drop any copy in contracts
  contracts |>
    select(-any_of("employment_status")) |>
    inner_join(active_personnel, by = c("personnel_id", "ref_date"))
}

#' Validate column exists in data table
#'
#' @param dt Data.table to check.
#' @param colname Character. Column name to validate.
#' @param varname Character. Variable name for error messages.
#'
#' @returns Invisible TRUE if valid, stops with error otherwise
#' @keywords internal
validate_column_exists <- function(dt, colname, varname) {
  if (!colname %in% names(dt)) {
    stop(
      "Column '",
      colname,
      "' not found in ",
      varname,
      call. = FALSE
    )
  }

  return(invisible(TRUE))
}

#' Validate multiple columns exist
#'
#' @param dt Data.table to check.
#' @param colnames A character vector. Column names to validate.
#' @param varname Character. Variable name for error messages.
#'
#' @returns Invisible TRUE if valid, stops with error otherwise
#' @keywords internal
validate_columns_exist <- function(dt, colnames, varname) {
  missing_cols <- setdiff(colnames, names(dt))

  if (length(missing_cols) > 0) {
    stop(
      "Columns not found in ",
      varname,
      ": ",
      paste(missing_cols, collapse = ", "),
      call. = FALSE
    )
  }

  return(invisible(TRUE))
}

#' Validate date format
#'
#' @param date Object to validate.
#' @param varname Character. Variable name for error messages.
#'
#' @returns Invisible TRUE if valid, stops with error otherwise
#' @keywords internal
validate_date_format <- function(date, varname) {
  # Accept both Date objects and character strings
  if (is.character(date)) {
    tryCatch(
      {
        date <- as.Date(date)
      },
      error = function(e) {
        stop(
          varname,
          " must be a valid date string (e.g., '2024-01-01') or Date object. ",
          "Error: ",
          e$message,
          call. = FALSE
        )
      }
    )
  }

  if (!inherits(date, "Date")) {
    stop(
      varname,
      " must be a Date object or date string (e.g., '2024-01-01')",
      call. = FALSE
    )
  }

  if (length(date) != 1) {
    stop(varname, " must be a single Date value", call. = FALSE)
  }

  if (is.na(date)) {
    stop(varname, " cannot be NA", call. = FALSE)
  }

  return(date)
}

# Support a renamed argument for one deprecation cycle.
#
# Returns the value for the new argument, warning if the caller supplied the
# old name instead. `old` defaults to NULL in the wrapping function, so a
# non-NULL value means the caller explicitly passed the deprecated argument.
#' @noRd
resolve_renamed_arg <- function(new, old, old_name, new_name) {
  if (is.null(old)) {
    return(new)
  }

  warning(
    "`", old_name, "` is deprecated and will be removed in a future release; ",
    "use `", new_name, "` instead.",
    call. = FALSE
  )

  # `new` may be a required formal the caller never supplied, so probe it
  # without letting the missing-argument error escape.
  supplied <- !inherits(
    tryCatch(force(new), error = function(e) e),
    "error"
  )

  if (supplied && !is.null(new)) {
    stop(
      "Supply either `", new_name, "` or `", old_name, "`, not both.",
      call. = FALSE
    )
  }

  old
}
