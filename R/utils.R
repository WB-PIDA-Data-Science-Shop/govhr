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

#' Drop entities with duplicated records
#'
#' Drops every record of each entity holding more than one record on the same
#' `ref_date`, even if those records are otherwise identical, and warns how
#' many records were removed. Used to keep a single record per entity and
#' period, e.g. a single group per period in [detect_transition()].
#'
#' @param data A data frame or lazy database table (`tbl_dbi`) with `ref_date`
#'   and the column named in `id_col`.
#' @param id_col Character. Column identifying the entity, such as a person or
#'   a contract.
#' @param ... Arguments passed to methods.
#'
#' @return `data` without the records of the entities holding several records
#'   on a date. A data.table for data frame input; a lazy table for `tbl_dbi`
#'   input.
#'
#' @keywords internal
drop_duplicate <- function(data, ...) {
  UseMethod("drop_duplicate")
}

#' @rdname drop_duplicate
#' @export
drop_duplicate.data.frame <- function(data, id_col, ...) {
  rlang::check_dots_empty()

  # as.data.table() copies, which is wasted on a data.table input
  dt <- if (data.table::is.data.table(data)) {
    data
  } else {
    data.table::as.data.table(data)
  }

  duplicate_keys <- duplicated(dt, by = c(id_col, "ref_date"))

  if (!any(duplicate_keys)) {
    return(dt)
  }

  violating_ids <- unique(dt[[id_col]][duplicate_keys])
  violating_rows <- dt[[id_col]] %in% violating_ids

  warn_duplicate_records(
    n_duplicates = sum(duplicate_keys),
    n_rows = sum(violating_rows),
    n_ids = length(violating_ids),
    id_col = id_col
  )

  dt[!violating_rows]
}

#' @rdname drop_duplicate
#' @export
drop_duplicate.tbl_dbi <- function(data, id_col, ...) {
  rlang::check_dots_empty()

  key_counts <- data |>
    dplyr::summarise(
      n_records = dplyr::n(),
      .by = dplyr::all_of(c(id_col, "ref_date"))
    )

  violating_ids <- key_counts |>
    dplyr::filter(
      n_records > 1
    ) |>
    dplyr::select(dplyr::all_of(id_col)) |>
    dplyr::distinct()

  violations <- key_counts |>
    dplyr::semi_join(
      violating_ids,
      by = id_col
    ) |>
    dplyr::summarise(
      n_duplicates = sum(n_records - 1, na.rm = TRUE),
      n_rows = sum(n_records, na.rm = TRUE),
      n_ids = dplyr::n_distinct(.data[[id_col]])
    ) |>
    dplyr::collect()

  if (violations[["n_ids"]] == 0) {
    return(data)
  }

  warn_duplicate_records(
    n_duplicates = violations[["n_duplicates"]],
    n_rows = violations[["n_rows"]],
    n_ids = violations[["n_ids"]],
    id_col = id_col
  )

  data |>
    dplyr::anti_join(
      violating_ids,
      by = id_col
    )
}

#' Warn about records dropped as duplicates
#'
#' Raises the warning of [drop_duplicate()], shared by its methods so that
#' both backends word it identically.
#'
#' @param n_duplicates Number of surplus records, i.e. records beyond the
#'   first for each entity and `ref_date`.
#' @param n_rows Number of records dropped, all records of the affected
#'   entities.
#' @param n_ids Number of entities dropped.
#' @param id_col Character. Column identifying the entity.
#'
#' @return `NULL`, invisibly. Called for its warning.
#'
#' @keywords internal
warn_duplicate_records <- function(n_duplicates, n_rows, n_ids, id_col) {
  warning(
    sprintf(
      paste(
        "%d record(s) are not uniquely identified by `%s` and `ref_date`;",
        "dropping all %d record(s) for the %d affected `%s` value(s)."
      ),
      as.integer(n_duplicates),
      id_col,
      as.integer(n_rows),
      as.integer(n_ids),
      id_col
    ),
    call. = FALSE
  )
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
