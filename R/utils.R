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
#' @export
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
#' @export
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
#' @export
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
#' @export
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
#' @export
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
#' @export
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
#' @export
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
#' @export
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
#' @export
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

#' Support a renamed argument for one deprecation cycle
#'
#' Returns the value for the new argument, warning if the caller supplied the
#' old name instead. `old` defaults to `NULL` in the wrapping function, so a
#' non-`NULL` value means the caller explicitly passed the deprecated argument.
#'
#' @param new The value of the new argument.
#' @param old The value of the deprecated argument.
#' @param old_name,new_name The names of the deprecated and new arguments,
#'   used in the messages.
#'
#' @returns `new` if `old` is `NULL`; otherwise `old`, with a deprecation
#'   warning. An error if both were supplied.
#'
#' @keywords internal
#' @export
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

#' Check that each column comes from exactly one of personnel and contracts
#'
#' Used for the survival panel's covariates (see `.check_survival_args()`).
#' Stops with an error if a column is in both tables (ambiguous) or in
#' neither.
#'
#' @param cols Character vector of column names, or `NULL`.
#' @param personnel,contracts The two tables.
#' @param noun What the columns are called in the error, e.g.
#'   `"group column"`.
#'
#' @returns `NULL`, invisibly.
#' @keywords internal
.check_column_sources <- function(cols, personnel, contracts, noun) {
  in_personnel <- cols %in% colnames(personnel)
  in_contracts <- cols %in% colnames(contracts)

  if (any(in_personnel & in_contracts)) {
    stop(
      paste0("`", cols[in_personnel & in_contracts], "`", collapse = ", "),
      " is in both `personnel` and `contracts`; rename one copy so each ",
      noun, " comes from one table.",
      call. = FALSE
    )
  }

  if (any(!in_personnel & !in_contracts)) {
    stop(
      paste0("`", cols[!in_personnel & !in_contracts], "`", collapse = ", "),
      " is in neither `personnel` nor `contracts`.",
      call. = FALSE
    )
  }

  invisible(NULL)
}

#' Total pay per person and snapshot, with contract columns from one contract
#'
#' Used by `build_survival_panel()` to
#' turn contracts into one row per person and snapshot:
#' * `.pay` is the total across the person's contracts, leaving out a
#'   contract with missing pay (`NA` only if all of them are missing);
#' * `contract_cols` (e.g. occupation) come from the one contract that
#'   `.choose_contract()` picks.
#'
#' @param contracts The contract table (any data frame).
#' @param person_year The person and snapshot columns.
#' @param contract_id_col,salary_col The contract id and pay columns.
#' @param contract_cols Columns to take from the chosen contract, or empty.
#' @param select_contract `"highest_paid"` or `"lowest_paid"`.
#'
#' @returns A data.table with one row per person and snapshot: `person_year`,
#'   `contract_cols` and `.pay`.
#' @keywords internal
.pay_by_person_snapshot <- function(contracts, person_year, contract_id_col,
                                    salary_col, contract_cols,
                                    select_contract) {
  contract_dt <- as.data.table(contracts)[,
    c(person_year, contract_id_col, salary_col, contract_cols),
    with = FALSE
  ]

  pay_dt <- contract_dt[,
    .(.pay = if (all(is.na(get(salary_col)))) {
      NA_real_
    } else {
      sum(get(salary_col), na.rm = TRUE)
    }),
    by = person_year
  ]

  if (length(contract_cols) > 0L) {
    chosen_dt <- .choose_contract(
      contract_dt, person_year, salary_col, contract_id_col, select_contract
    )[, c(person_year, contract_cols), with = FALSE]
    pay_dt <- chosen_dt[pay_dt, on = person_year]
  }

  pay_dt
}

#' Pick one contract per person and snapshot
#'
#' The highest-paid (or lowest-paid) contract, ties going to the lowest
#' contract id, and a contract with missing pay only if all of them are
#' missing. One sort and a pass keeping each group's first row, both in C,
#' which is several times faster than a grouped `max()` filter on large
#' panels (and needs no separate tie-break).
#'
#' @param contract_dt A data.table of contracts. **Sorted by reference.**
#' @param person_year The person and snapshot columns.
#' @param salary_col,contract_id_col The pay and contract id columns.
#' @param select_contract `"highest_paid"` or `"lowest_paid"`.
#'
#' @returns The chosen rows of `contract_dt`, one per person and snapshot.
#' @keywords internal
.choose_contract <- function(contract_dt, person_year, salary_col,
                             contract_id_col, select_contract) {
  pay_order <- if (select_contract == "highest_paid") -1L else 1L
  setorderv(
    contract_dt,
    c(person_year, salary_col, contract_id_col),
    order = c(1L, 1L, pay_order, 1L),
    na.last = TRUE
  )

  contract_dt[!duplicated(contract_dt, by = person_year)]
}

#' Name the groups of a table in a message
#'
#' Labels each row of `dt` by its group values, e.g. `"gender = F,
#' occupation = nurse"`, for warnings that name the groups affected. Used by
#' `compute_service_table()`.
#'
#' @param dt A data frame with the `group_cols` columns, one row per group to
#'   name.
#' @param group_cols A character vector of group columns, or `NULL`.
#'
#' @returns A character vector with one label per row of `dt`, or
#'   `"the table"` when `group_cols` is empty.
#' @keywords internal
.group_labels <- function(dt, group_cols) {
  if (length(group_cols) == 0L) {
    return("the table")
  }
  do.call(paste, c(
    lapply(group_cols, function(col) paste(col, "=", dt[[col]])),
    sep = ", "
  ))
}

#' The rarely needed settings of compute_service_table()
#'
#' `compute_service_table()` takes `radix`, `smooth` and `span` through `...`,
#' since few users need them. This gives each its default and stops on any
#' other name, so a misspelt setting (e.g. `smoth = TRUE`) is not silently
#' ignored.
#'
#' @param ... The `...` of `compute_service_table()`.
#'
#' @returns A list with `radix`, `smooth` and `span`.
#' @keywords internal
.service_table_settings <- function(...) {
  settings <- list(radix = 100000, smooth = FALSE, span = 0.75)
  dots <- list(...)

  ### names2() gives "" for an unnamed argument, which is unknown too
  unknown <- setdiff(rlang::names2(dots), names(settings))
  if (length(unknown) > 0L) {
    stop(
      "compute_service_table() got an unknown argument: ",
      paste0("`", unknown, "`", collapse = ", "),
      ". Its `...` takes only `smooth`, `span` and `radix`.",
      call. = FALSE
    )
  }

  settings[names(dots)] <- dots
  settings
}

#' Build a service table from pooled decrement rates
#'
#' The shared engine of both methods of `compute_service_table()`, which only
#' differ in how they get the rates (in memory, or collected from the
#' database): the stay rate at every duration (`.stay_rates()`), chained into
#' `lx`, `Lx`, `Tx` and `ex` (`.chain_service_table()`).
#'
#' @param decrement_dt A data.table from `estimate_decrement_rates()`. Its
#'   duration and status columns are renamed by reference.
#' @param duration_col,status_col,group_cols,include_all As in
#'   `compute_service_table()`.
#' @param settings The list from `.service_table_settings()`.
#'
#' @returns A `service_table` (see `compute_service_table()`).
#' @importFrom data.table setattr
#' @keywords internal
.service_table_from_rates <- function(decrement_dt, duration_col, status_col,
                                      group_cols, include_all, settings) {
  smooth <- isTRUE(settings$smooth)

  ### fixed names for the duration and status, so the steps below can name
  ### them directly; the duration gets its own name back at the end
  setnames(decrement_dt, c(duration_col, status_col), c(".duration", ".status"))

  stay_dt <- .stay_rates(decrement_dt, duration_col, group_cols, smooth, settings$span)
  service_dt <- .chain_service_table(stay_dt, duration_col, group_cols, settings$radix, smooth)

  keep_cols <- if (isTRUE(include_all)) {
    c(".duration", group_cols, "pop", "px", "lx", "lx_next", "Lx", "Tx", "ex")
  } else {
    c(".duration", group_cols, "px", "ex")
  }
  service_dt <- service_dt[, keep_cols, with = FALSE]
  setnames(service_dt, ".duration", duration_col)

  ### a service_table, so plot() knows how to draw it
  setattr(service_dt, "duration_col", duration_col)
  setattr(service_dt, "group_cols", group_cols)
  setattr(service_dt, "class", c("service_table", class(service_dt)))
  service_dt[]
}

#' The stay rate at every duration of a service table
#'
#' Part of `.service_table_from_rates()`. Leaves out person-snapshots with no
#' duration, with a warning, and takes the stay rate `px` (the `"active"`
#' rows) with the people it rests on (`pop`). The chain needs a stay rate at
#' every duration, so the rates are smoothed if asked, or if a group is missing
#' a duration (then every group, so they stay comparable, with a warning).
#'
#' @param rates Pooled decrement rates with the columns `.duration`,
#'   `.status`, `group_cols`, `pop` and `decrement_rate`.
#' @param duration_col The original duration column name, for the warnings.
#' @param group_cols As in `compute_service_table()`.
#' @param smooth,span Whether and how much to smooth.
#'
#' @returns A data.table with `.duration`, `group_cols`, `pop` (`NA` where
#'   smoothing filled in a duration) and `px`, sorted by group and duration.
#' @keywords internal
.stay_rates <- function(rates, duration_col, group_cols, smooth, span) {
  n_missing <- rates[is.na(.duration) & .status == "active", sum(pop)]
  if (n_missing > 0L) {
    warning(
      n_missing, " active person-snapshot(s) have no `", duration_col, "` and ",
      "are left out of the table.",
      call. = FALSE
    )
    rates <- rates[!is.na(.duration)]
  }

  observed <- rates[.status == "active", c(".duration", group_cols, "pop", "decrement_rate"), with = FALSE]
  setorderv(observed, c(group_cols, ".duration"))
  has_gap <- observed[, .(gap = any(diff(.duration) != 1L)), by = group_cols][, any(gap)]
  if (has_gap && !smooth) {
    warning(
      "Some durations have no one in service in a group, so the stay rates ",
      "have been smoothed to fill the gap; set smooth = TRUE to smooth them ",
      "up front.",
      call. = FALSE
    )
  }

  stay <- observed
  if (smooth || has_gap) {
    stay <- smooth_decrement_rates(rates, ".duration", ".status", group_cols, span = span)
    stay <- stay[.status == "active"]
    stay[observed, pop := i.pop, on = c(".duration", group_cols)]
  }

  stay <- stay[, c(".duration", group_cols, "pop", "decrement_rate"), with = FALSE]
  setnames(stay, "decrement_rate", "px")
  setorderv(stay, c(group_cols, ".duration"))
}

#' Chain stay rates into expected years of service
#'
#' Part of `.service_table_from_rates()`. Follows `radix` people from each
#' group's lowest duration: `lx` are those still in service, `Lx` the years
#' they serve in the year (someone who leaves counts half), `Tx` the years from
#' there to the end of the table, and `ex = Tx / lx`. After a duration everyone
#' left (`px = 0`) no one is left, so `ex` is `NA` there, with a warning.
#'
#' @param stay_dt The output of `.stay_rates()`, sorted by group and duration.
#' @param duration_col The original duration column name, for the warning.
#' @param group_cols As in `compute_service_table()`.
#' @param radix The size of the imaginary group.
#' @param smooth Whether the rates were smoothed (the warning only suggests
#'   smoothing if not).
#'
#' @returns `stay_dt` with `lx`, `lx_next`, `Lx`, `Tx` and `ex` added.
#' @keywords internal
.chain_service_table <- function(stay_dt, duration_col, group_cols, radix, smooth) {
  stay_dt[, lx := radix * cumprod(shift(px, fill = 1)), by = group_cols]
  stay_dt[, lx_next := lx * px]
  stay_dt[, Lx := (lx + lx_next) / 2]
  stay_dt[, Tx := rev(cumsum(rev(Lx))), by = group_cols]
  stay_dt[, ex := Tx / lx]

  if (any(stay_dt$lx == 0)) {
    stay_dt[lx == 0, ex := NA_real_]
    ended <- stay_dt[lx == 0, .(end = min(.duration)), by = group_cols]
    where <- paste0(
      .group_labels(ended, group_cols), " (from ", duration_col, " ", ended$end, ")",
      collapse = "; "
    )
    advice <- if (smooth) "" else " Set smooth = TRUE to smooth the rates across durations."
    warning(
      "Everyone in service left at some duration in some groups, so `ex` is ",
      "NA after it: ", where, ".", advice,
      call. = FALSE
    )
  }

  stay_dt
}

#' Check the inputs of build_survival_panel()
#'
#' Shared by the data.frame and tbl_dbi methods, so the checks cannot drift
#' apart. Stops with an error if a required column is missing from
#' `personnel` or `contracts`, or if a covariate is in both tables
#' (ambiguous) or in neither.
#'
#' @param personnel,contracts The personnel and contract tables, as data
#'   frames or lazy database tables.
#' @param tenure_col,salary_col,status_col Character. The tenure (in
#'   `personnel`), pay (in `contracts`) and employment status (in
#'   `personnel`, or `NULL`) columns.
#' @param covariate_cols Character vector or `NULL`. Covariates, each from
#'   exactly one of the two tables.
#' @param personnel_id_col,ref_date_col,contract_id_col Character. The
#'   person, snapshot date and contract id columns.
#'
#' @returns `NULL`, invisibly.
#' @keywords internal
.check_survival_args <- function(personnel, contracts, tenure_col, salary_col,
                                 status_col, covariate_cols, personnel_id_col,
                                 ref_date_col, contract_id_col) {
  check_required_cols(
    personnel, c(personnel_id_col, ref_date_col, status_col, tenure_col),
    "personnel"
  )
  check_required_cols(
    contracts, c(contract_id_col, personnel_id_col, ref_date_col, salary_col),
    "contracts"
  )
  .check_column_sources(covariate_cols, personnel, contracts, "covariate")

  invisible(NULL)
}

#' Pair each snapshot date with the next one
#'
#' Used by both methods of `build_survival_panel()`, so in-memory and
#' database panels measure intervals the same way. The last date has no
#' next one, so it is not in the calendar: joining the calendar drops the
#' last snapshot, which is censored.
#'
#' @param dates A sorted vector of distinct snapshot dates.
#'
#' @returns A data frame with one row per date but the last: `.ref` (the
#'   date), `next_date` (the next one) and `.interval` (the years between
#'   them).
#' @keywords internal
.survival_calendar <- function(dates) {
  n_dates <- length(dates)
  data.frame(
    .ref = dates[-n_dates],
    next_date = dates[-1L],
    .interval = lubridate::time_length(
      lubridate::interval(dates[-n_dates], dates[-1L]), "year"
    )
  )
}

#' Warn about duplicate person-snapshot rows in a personnel panel
#'
#' Shared by both methods of `estimate_decrement_rates()` and
#' `build_survival_panel()`, which
#' all keep the same row, so the message is the same everywhere.
#'
#' @param n_dup Number. How many rows are duplicates.
#' @param personnel_id_col,ref_date_col Character. The person and snapshot
#'   date columns, named in the message.
#'
#' @returns The warning message, invisibly (called for its warning).
#' @keywords internal
.warn_duplicates <- function(n_dup, personnel_id_col, ref_date_col) {
  warning(
    "`personnel` has ", n_dup, " duplicate rows at the ",
    personnel_id_col, "/", ref_date_col, " level, which should be unique. ",
    "Keeping one row per person and snapshot: the first by status, with a ",
    "missing status last.",
    call. = FALSE
  )
}

#' Keep one row per person and snapshot of a lazy personnel table
#'
#' The database counterpart of the de-duplication in the data.frame methods
#' of `estimate_decrement_rates()` and `build_survival_panel()`: if any
#' person has several rows at one snapshot, warns with their number and keeps
#' the first by status, with a missing status last. The missing-last order is
#' spelled out, because databases differ in where they sort NULLs.
#'
#' @param panel A lazy table (`tbl_dbi`) with the columns `.pid`, `.ref` and
#'   `.status`.
#' @param personnel_id_col,ref_date_col Character. The original person and
#'   snapshot date column names, for the warning.
#'
#' @returns `panel`, lazily filtered to one row per `.pid` and `.ref`, or
#'   unchanged if there were no duplicates. Counting them runs one query.
#' @keywords internal
.dedupe_person_snapshot_dbi <- function(panel, personnel_id_col, ref_date_col) {
  n_dup <- panel |>
    count(.pid, .ref, name = ".n") |>
    filter(.n > 1L) |>
    summarise(.n_dup = sum(.n - 1L, na.rm = TRUE)) |>
    pull(.n_dup)
  if (!isTRUE(n_dup > 0)) {
    return(panel)
  }

  ### window_order() takes columns only, so the missing flag (0/1, which
  ### sorts the same on every database) gets a column of its own
  .warn_duplicates(n_dup, personnel_id_col, ref_date_col)
  panel |>
    mutate(.status_missing = if_else(is.na(.status), 1L, 0L)) |>
    group_by(.pid, .ref) |>
    dbplyr::window_order(.status_missing, .status) |>
    filter(row_number() == 1L) |>
    ungroup() |>
    select(-".status_missing")
}

#' Tag a panel as a survival_panel
#'
#' Adds the `survival_panel` class and stores the column arguments the panel
#' was built with as attributes, so `fit_survival_model()` needs no column
#' arguments. A data.table is tagged by reference, which a copying
#' `attr<-` would break.
#'
#' @param panel The panel, as a data.table or a lazy database table.
#' @param tenure_col,salary_col,covariate_cols,personnel_id_col,ref_date_col
#'   The column arguments of `build_survival_panel()`.
#'
#' @returns `panel`, with class `survival_panel` prepended and one attribute
#'   per column argument.
#' @keywords internal
.new_survival_panel <- function(panel, tenure_col, salary_col, covariate_cols,
                                personnel_id_col, ref_date_col) {
  settings <- list(
    tenure_col = tenure_col, salary_col = salary_col,
    covariate_cols = covariate_cols, personnel_id_col = personnel_id_col,
    ref_date_col = ref_date_col
  )
  ### by reference on a data.table, which a copying attr<- would break
  if (is.data.table(panel)) {
    for (name in names(settings)) setattr(panel, name, settings[[name]])
    setattr(panel, "class", c("survival_panel", class(panel)))
  } else {
    for (name in names(settings)) attr(panel, name) <- settings[[name]]
    class(panel) <- c("survival_panel", class(panel))
  }

  panel
}

#' Check the inputs of fit_survival_model()
#'
#' Shared by the data.frame and tbl_dbi methods, so the checks cannot drift
#' apart. Stops with an error if `panel` is not a `survival_panel`, if a
#' covariate is not one of its columns, if `band_width` is not a single
#' positive number, or if `...` holds an argument of [fixest::fepois()] that
#' `fit_survival_model()` sets itself or that would be wrong on summed cells
#' (`weights`, `cluster`). Runs before the cells are summed, so a database
#' panel is not queried for a call that would fail.
#'
#' @param panel The `panel` argument of `fit_survival_model()`.
#' @param covariate_cols Character vector. The covariates to model.
#' @param band_width Number. The width of the tenure bands, in years.
#' @param dot_names Character vector or `NULL`. The names of the arguments in
#'   `fit_survival_model()`'s `...`, from `...names()`.
#'
#' @returns `NULL`, invisibly.
#' @keywords internal
.check_survival_model_args <- function(panel, covariate_cols, band_width,
                                       dot_names = NULL) {
  if (!inherits(panel, "survival_panel")) {
    stop(
      "`panel` must be a survival_panel: the output of build_survival_panel().",
      call. = FALSE
    )
  }
  missing_cols <- setdiff(covariate_cols, colnames(panel))
  if (length(missing_cols) > 0L) {
    stop(
      paste0("`", missing_cols, "`", collapse = ", "),
      " is not a column of the panel; build it with that covariate.",
      call. = FALSE
    )
  }
  if (!is.numeric(band_width) || length(band_width) != 1L || !(band_width > 0)) {
    stop("`band_width` must be a single positive number of years.", call. = FALSE)
  }
  reserved <- intersect(
    dot_names,
    c("fml", "data", "offset", "vcov", "ssc", "weights", "cluster")
  )
  if (length(reserved) > 0L) {
    stop(
      paste0("`", reserved, "`", collapse = ", "),
      " cannot be passed through `...`: fit_survival_model() sets `fml`, ",
      "`data`, `offset`, `vcov` and `ssc` itself, and `weights` or `cluster` ",
      "would be wrong once people are added up into groups.",
      call. = FALSE
    )
  }

  invisible(NULL)
}

#' Fit the Poisson survival model on summed cells
#'
#' The fit shared by both methods of `fit_survival_model()`. Fits one model
#' per exit type, with `log(exposure)` as an offset and fixed effects for
#' tenure band (and calendar year if `period_effects`). An exit type no one
#' had cannot be fitted, so it is left out with a warning.
#'
#' @param cells A data.table of cells with exit counts (`exit_retired`,
#'   `exit_other`), years at risk (`exposure`), tenure band (`.band`),
#'   snapshot (`.ref`) and `covariate_cols`. **Modified by reference**: sorted,
#'   and a `.year` column is added.
#' @param panel The `survival_panel` the cells were summed from, for the
#'   column names it remembers.
#' @param covariate_cols Character vector. The covariates to model, or empty
#'   for tenure (and year) effects only.
#' @param exit_types Character vector. Any of `"retired"` and `"other"`.
#' @param band_width Number. The width of the tenure bands, in years.
#' @param period_effects Logical. Whether to add calendar year fixed effects.
#' @param make_tidy_output Logical. Whether to return the table of hazard
#'   ratios from `tidy.survival_model()` instead of the model.
#' @param ... Further arguments passed to [fixest::fepois()], already checked
#'   by `.check_survival_model_args()`.
#'
#' @returns A `survival_model`: the output of [fixest::fepois()] (a
#'   `fixest_multi` with one model per exit type, or a `fixest` if only one
#'   is fitted) with class `survival_model` prepended, and two attributes
#'   for `predict.survival_model()`: `cells` (the cells it was fitted on)
#'   and `survival_settings` (the panel's columns, `band_width`,
#'   `period_effects`, the exit types asked for and those no one had). Or,
#'   if `make_tidy_output`, its table of hazard ratios. Stops with an error
#'   if no exit type has any exits.
#' @keywords internal
.fit_survival_cells <- function(cells,
                                panel,
                                covariate_cols,
                                exit_types,
                                band_width,
                                period_effects,
                                make_tidy_output,
                                ...) {
  ### an exit type no one had cannot be fitted: leave it out
  has_exits <- vapply(
    exit_types,
    function(type) sum(cells[[paste0("exit_", type)]], na.rm = TRUE) > 0,
    logical(1)
  )
  for (type in exit_types[!has_exits]) {
    warning(
      "No `", type, "` exits in the panel, so no model is fitted for them.",
      call. = FALSE
    )
  }
  if (!any(has_exits)) {
    stop("The panel has no exits of the types asked for.", call. = FALSE)
  }
  exit_cols <- paste0("exit_", exit_types[has_exits])

  ### a fixed order, so predict() gives the cells the same way whichever
  ### backend summed them
  setorderv(cells, c(".ref", ".band", covariate_cols))
  cells[, .year := lubridate::year(.ref)]
  lhs <- if (length(exit_cols) == 1L) {
    exit_cols
  } else {
    paste0("c(", paste(exit_cols, collapse = ", "), ")")
  }
  rhs <- if (length(covariate_cols) > 0L) {
    paste0("`", covariate_cols, "`", collapse = " + ")
  } else {
    "1"
  }
  fixed_effects <- if (isTRUE(period_effects)) ".band + .year" else ".band"

  ### the model's own standard errors, with no small-sample adjustment: it
  ### depends on the number of rows, which summing to cells changes
  fit <- fixest::fepois(
    stats::as.formula(paste(lhs, "~", rhs, "|", fixed_effects)),
    data = cells,
    offset = ~ log(exposure),
    vcov = "iid",
    ssc = fixest::ssc(K.adj = FALSE, K.fixef = "none"),
    ...
  )

  ### a class of our own, so tidy() gives hazard ratios; fixest's own
  ### methods (coef, fixef, summary, etable) still work on the class below
  class(fit) <- c("survival_model", class(fit))

  ### what predict() needs: the cells (small: one row per band, snapshot
  ### and covariates) and how to turn new data into bands and years
  attr(fit, "cells") <- cells
  attr(fit, "survival_settings") <- list(
    tenure_col = attr(panel, "tenure_col"),
    ref_date_col = attr(panel, "ref_date_col"),
    covariate_cols = covariate_cols,
    band_width = band_width,
    period_effects = isTRUE(period_effects),
    exit_types = exit_types,
    zero_types = exit_types[!has_exits]
  )

  ### the table of hazard ratios if asked for, otherwise the model itself
  if (isTRUE(make_tidy_output)) tidy(fit) else fit
}

#' Split a survival model into one fixest model per exit type
#'
#' Shared by `tidy.survival_model()` and `predict.survival_model()`. Drops
#' the `survival_model` class first, so the methods they call on each model
#' (`broom::tidy()`, `predict()`) reach fixest's own instead of ours.
#'
#' @param x A `survival_model` from `fit_survival_model()`.
#'
#' @returns A list of `fixest` models, named by the exit type each one's
#'   outcome counts (`exit_other` is `"other"`).
#' @keywords internal
.survival_models <- function(x) {
  class(x) <- setdiff(class(x), "survival_model")
  models <- if (inherits(x, "fixest_multi")) as.list(x) else list(x)
  names(models) <- vapply(
    models,
    function(model) sub("^exit_", "", deparse(model$fml[[2L]])),
    character(1)
  )

  models
}

#' Predict exits from one exit type's model, with 0 where fixest dropped a level
#'
#' The prediction shared by both uses of `predict.survival_model()`: the
#' expected exits, `exp()` of the band, year and covariate effects times the
#' `exposure` in `model_data`. With `exposure = 1` that is the hazard per
#' year.
#'
#' fixest drops a tenure band or year in which no one left, since its effect
#' is minus infinity: it predicts `NA` there. The model's estimate is 0
#' exits, so a band or year seen in the cells but dropped gets 0. One never
#' seen, a covariate level never seen, or a missing value stays `NA`.
#'
#' @param model One `fixest` model from `.survival_models()`.
#' @param model_data A data.table with `.band`, `.year` (if the model has
#'   year effects), the covariates and `exposure`.
#' @param cells The cells the model was fitted on, for the bands and years
#'   seen.
#'
#' @returns A numeric vector, one value per row of `model_data`.
#' @keywords internal
.predict_exits <- function(model, model_data, cells) {
  pred <- stats::predict(model, newdata = model_data)

  fe <- fixest::fixef(model)
  dropped <- model_data$.band %in% cells$.band &
    !model_data$.band %in% names(fe$.band)
  if (!is.null(fe$.year)) {
    dropped <- dropped |
      (model_data$.year %in% cells$.year & !model_data$.year %in% names(fe$.year))
  }
  ### a missing band, year or covariate is not a dropped level
  pred[dropped & stats::complete.cases(model_data)] <- 0

  pred
}

#' Expected exits in each cell a survival model was fitted on
#'
#' `predict.survival_model()` without `newdata`: the cells, with the expected
#' exits of each exit type next to the exits seen. The cells' own exposure is
#' in the offset, so the prediction is on the scale of the outcome.
#'
#' @param object A `survival_model`.
#'
#' @returns A data.table: the snapshot date (named as in the panel),
#'   `tenure_band`, the covariates, `exposure`, and `exit_<type>` and
#'   `pred_<type>` for each exit type modelled.
#' @keywords internal
.predict_survival_cells <- function(object) {
  settings <- attr(object, "survival_settings")
  cells <- attr(object, "cells")
  models <- .survival_models(object)
  out <- copy(cells)

  for (type in names(models)) {
    set(out, j = paste0("pred_", type), value = .predict_exits(models[[type]], cells, cells))
  }
  ### an exit type no one had: no model, and 0 expected exits
  for (type in settings$zero_types) {
    set(out, j = paste0("pred_", type), value = 0)
  }

  ### the panel's names instead of fixest's; the year is in the date. Each
  ### exit type's seen and expected exits side by side (rbind() pairs them)
  setnames(out, c(".ref", ".band"), c(settings$ref_date_col, "tenure_band"))
  types <- settings$exit_types
  out[, c(
    settings$ref_date_col, "tenure_band", settings$covariate_cols, "exposure",
    rbind(paste0("exit_", types), paste0("pred_", types))
  ), with = FALSE]
}

#' Hazards and exit probabilities for new data from a survival model
#'
#' `predict.survival_model()` with `newdata`: one row per row of `newdata`
#' (e.g. one per person), with the hazard of each exit type and, if every
#' exit type is covered, the chance of each exit and of staying within
#' `horizon` years.
#'
#' The hazard is constant within a tenure band, so the chance of leaving
#' within `horizon` is `1 - exp(-total hazard * horizon)`, split between the
#' exit types in proportion to their hazards. This holds for any horizon (a
#' month, a year, several), and the three chances always add up to 1.
#'
#' @param object A `survival_model`.
#' @param newdata A data frame with the panel's tenure column, its covariates
#'   and (if the model has year effects) its snapshot date column, or a lazy
#'   database table with them (collected).
#' @param horizon Number. The years ahead the exit chances are for.
#'
#' @returns `newdata` as a data.table with `hazard_<type>` for each exit
#'   type modelled (per year), and `prob_retired`, `prob_other` and
#'   `prob_stay` if both exit types were modelled or had no exits.
#' @keywords internal
.predict_survival_newdata <- function(object, newdata, horizon) {
  settings <- attr(object, "survival_settings")
  if (!is.numeric(horizon) || length(horizon) != 1L || !(horizon > 0)) {
    stop("`horizon` must be a single positive number of years.", call. = FALSE)
  }
  check_required_cols(
    newdata,
    c(
      settings$tenure_col, settings$covariate_cols,
      if (settings$period_effects) settings$ref_date_col
    ),
    "newdata"
  )
  ### a copy, so newdata stays untouched (as.data.table() hands back a
  ### data.table as it is, and set() below works by reference)
  out <- if (is.data.table(newdata)) copy(newdata) else as.data.table(collect(newdata))

  ### fixest's band and year from the panel's columns, and exposure = 1 so
  ### the prediction is the hazard per year
  model_data <- out[, settings$covariate_cols, with = FALSE]
  model_data[, .band := floor(out[[settings$tenure_col]] / settings$band_width) * settings$band_width]
  if (settings$period_effects) {
    model_data[, .year := lubridate::year(out[[settings$ref_date_col]])]
  }
  model_data[, exposure := 1]

  models <- .survival_models(object)
  cells <- attr(object, "cells")
  for (type in names(models)) {
    set(out, j = paste0("hazard_", type), value = .predict_exits(models[[type]], model_data, cells))
  }
  for (type in settings$zero_types) {
    set(out, j = paste0("hazard_", type), value = 0)
  }

  ### the chances need every exit type: one not asked for has an unknown
  ### hazard, which would make leaving look less likely than it is
  if (all(c("retired", "other") %in% settings$exit_types)) {
    total <- (out$hazard_retired + out$hazard_other) * horizon
    leave <- 1 - exp(-total)
    ### split by hazard; with no hazard at all, no one leaves
    share_retired <- fifelse(total > 0, out$hazard_retired * horizon / total, 0)
    out[, `:=`(
      prob_retired = share_retired * leave,
      prob_other = (1 - share_retired) * leave,
      prob_stay = 1 - leave
    )]
  }

  out[]
}

#' Check the inputs of the tenure functions
#'
#' Shared by every method of `compute_tenure()`, `compute_tenure_panel()` and
#' `compute_employment_spells()`. Uses `check_required_cols()`, which also
#' lists a lazy database table's columns.
#'
#' @param contracts The contract table.
#' @param cols Character vector. The columns the function needs.
#'
#' @returns `contracts`, invisibly. Stops with an error naming any missing
#'   column.
#' @keywords internal
.check_tenure_args <- function(contracts, cols) {
  check_required_cols(contracts, cols, "contracts")
}

#' Tenure as the union of contract intervals, for a data frame
#'
#' The calculation behind the data frame methods of `compute_tenure()` and
#' `compute_tenure_panel()`: per key (person, groups and, for a panel, the
#' snapshot), the days covered by at least one active contract up to the
#' reference date.
#'
#' Each contract counts only the part not already covered by the key's
#' earlier-starting contracts: `max(0, end - max(start, latest earlier end))`.
#' The latest earlier end is a running maximum within each key. Rather than a
#' grouped `cummax()` (one R call per key, slow with millions of keys), it is
#' one vectorised pass: after sorting, each key's end dates are lifted by
#' `key number * step`, with `step` wider than the span of all dates, so the
#' running maximum can never carry over from the key before.
#'
#' Only the needed columns of the kept rows are copied, so `contracts` stays
#' untouched.
#'
#' @param contracts A data frame of contracts.
#' @param keys Character vector. The columns to compute tenure by.
#' @param ref A `Date`: one for every row, or one per row (a panel's
#'   snapshot dates).
#' @param start_date_col,end_date_col,contract_type_col Character. The
#'   contract start date, end date and type columns.
#'
#' @returns A data.table with `keys`, `tenure_days` and `tenure_years`, sorted
#'   by `keys`.
#' @importFrom data.table := data.table fifelse rleidv setDT setorderv shift
#' @keywords internal
.tenure_days <- function(contracts, keys, ref, start_date_col, end_date_col,
                         contract_type_col) {
  start <- contracts[[start_date_col]]
  ### an all-NA end column is logical: as.Date() makes it the missing dates
  ### it means. Open or later ends stop at the reference date
  end <- as.Date(contracts[[end_date_col]])
  end <- fifelse(is.na(end) | end > ref, ref, end)

  ### active contracts (a missing type counts as active), started by the
  ### reference date, with some time in them
  keep <- which(
    !contracts[[contract_type_col]] %in% c("inactive", "pensioner") &
      start <= ref & end > start
  )

  intervals <- setDT(lapply(
    stats::setNames(keys, keys),
    function(col) contracts[[col]][keep]
  ))
  intervals[, `:=`(.start = as.numeric(start[keep]), .end = as.numeric(end[keep]))]
  setorderv(intervals, c(keys, ".start"))

  ### the latest end among the key's earlier contracts (see Details); -Inf
  ### for each key's first contract
  if (nrow(intervals) > 0L) {
    key_id <- rleidv(intervals, cols = keys)
    step <- max(intervals$.end) - min(intervals$.end) + 1
    lift <- key_id * step
    intervals[, .prev_end := shift(cummax(.end + lift)) - lift]
    intervals[c(TRUE, key_id[-1L] != key_id[-length(key_id)]), .prev_end := -Inf]
  } else {
    intervals[, .prev_end := numeric(0)]
  }

  ### the part of each contract not already covered
  intervals[, .days := pmax(.end - pmax(.start, .prev_end), 0)]

  out <- intervals[, .(tenure_days = sum(.days)), by = keys]
  out[, tenure_years := tenure_days / 365.25][]
}

#' Tenure as the union of contract intervals, in a database
#'
#' The database version of `.tenure_days()`, as dplyr verbs that dbplyr
#' turns into SQL. The latest end among the key's earlier contracts is a
#' window function, `MAX(end) OVER (PARTITION BY keys ORDER BY start ROWS
#' BETWEEN UNBOUNDED PRECEDING AND 1 PRECEDING)`, and days are differences of
#' dates (`DATE - DATE`, a number of days in DuckDB and PostgreSQL). Contracts
#' with the same start add up to their latest end whatever order the window
#' puts them in, so the result matches `.tenure_days()`.
#'
#' @param contracts A lazy table of contracts.
#' @param keys Character vector. The columns to compute tenure by.
#' @param ref The reference date, as an expression for `mutate()`: a column
#'   symbol (a panel's snapshot date) or a SQL date literal.
#' @param start_date_col,end_date_col,contract_type_col Character. The
#'   contract start date, end date and type columns.
#'
#' @returns A lazy table with `keys`, `tenure_days` and `tenure_years`.
#' @importFrom dplyr across all_of coalesce filter group_by if_else mutate
#'   summarise ungroup
#' @importFrom rlang .data !!
#' @keywords internal
.tenure_days_db <- function(contracts, keys, ref, start_date_col, end_date_col,
                            contract_type_col) {
  contracts |>
    mutate(
      .ref = !!ref,
      .start = .data[[start_date_col]],
      .end = .data[[end_date_col]],
      .type = .data[[contract_type_col]]
    ) |>
    ### open or later ends stop at the reference date
    mutate(.end = if_else(is.na(.end) | .end > .ref, .ref, .end)) |>
    ### active contracts (NOT IN drops a missing type, so keep it explicitly),
    ### started by the reference date, with some time in them
    filter(
      (is.na(.type) | !.type %in% c("inactive", "pensioner")) &
        .start <= .ref & .end > .start
    ) |>
    group_by(across(all_of(keys))) |>
    dbplyr::window_order(.start) |>
    dbplyr::window_frame(-Inf, -1) |>
    mutate(.prev_end = max(.end, na.rm = TRUE)) |>
    ### clear the order and frame, which would otherwise stay on the table
    ### and apply to later window functions (e.g. a max() by group)
    dbplyr::window_order() |>
    dbplyr::window_frame() |>
    ungroup() |>
    ### the part of each contract not already covered; a key's first
    ### contract has no earlier end
    mutate(.days = pmax(.end - pmax(.start, coalesce(.prev_end, .start), na.rm = TRUE), 0, na.rm = TRUE)) |>
    summarise(tenure_days = as.numeric(sum(.days, na.rm = TRUE)), .by = all_of(keys)) |>
    mutate(tenure_years = tenure_days / 365.25)
}
