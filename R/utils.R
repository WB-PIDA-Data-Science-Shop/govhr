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

#' Check the inputs of estimate_progression_rates()
#'
#' Shared by every method, so the checks cannot drift apart. Uses
#' `colnames()`, which also lists a lazy database table's columns.
#'
#' Stops with an error if:
#' * `tenure_col` is not in `personnel` (pointing to the two ways to build it),
#' * a required column is missing from `personnel` or `contracts`,
#' * a group column is in both tables (ambiguous) or in neither.
#'
#' @param personnel,contracts The personnel and contract tables, as data
#'   frames or lazy database tables.
#' @param tenure_col,salary_col,status_col Character. The tenure (in
#'   `personnel`), pay (in `contracts`) and employment status (in
#'   `personnel`) columns.
#' @param group_cols Character vector or `NULL`. Group columns, each from
#'   exactly one of the two tables.
#' @param personnel_id_col,ref_date_col,contract_id_col Character. The
#'   person, snapshot date and contract id columns.
#'
#' @returns `NULL`, invisibly.
#' @keywords internal
.check_progression_args <- function(personnel, contracts, tenure_col,
                                    salary_col, group_cols, status_col,
                                    personnel_id_col, ref_date_col,
                                    contract_id_col) {
  if (!tenure_col %in% colnames(personnel)) {
    stop(
      "`personnel` has no tenure column `", tenure_col, "`. Add years of ",
      "service at each snapshot first: from contract history with ",
      "compute_tenure_panel(), or as the years between `ref_date` and ",
      "`first_employment_date`.",
      call. = FALSE
    )
  }

  check_required_cols(
    personnel, c(personnel_id_col, ref_date_col, status_col), "personnel"
  )
  check_required_cols(
    contracts, c(personnel_id_col, ref_date_col, contract_id_col, salary_col),
    "contracts"
  )

  .check_column_sources(group_cols, personnel, contracts, "group column")

  invisible(NULL)
}

#' Check that each column comes from exactly one of personnel and contracts
#'
#' Shared by Level 1's group columns and the survival panel's covariates.
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
#' Used by `estimate_progression_rates()` and `build_survival_panel()` to
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

#' Smooth and gap-fill the rates of a career table
#'
#' Puts each group on every whole tenure from its first to its last, and
#' replaces `px` and `pay_growth` with smoothed curves from
#' `.smooth_rate_curve()`: the exit rate `1 - px` weighted by exposure
#' (`pop`), and pay growth weighted by the stayers it was measured on
#' (`n_pay`). Exit rates are clipped to `[0, 1]`. The other columns of
#' `career_dt` are kept as observed, and are `NA` on a filled-in tenure.
#'
#' @param career_dt The output of `estimate_progression_rates()`.
#' @param tenure_col,group_cols As in `compute_career_table()`.
#' @param span The `loess()` span passed to `.smooth_rate_curve()`.
#'
#' @returns A data.table like `career_dt`, sorted by group and tenure, with
#'   no tenure gaps.
#' @keywords internal
.smooth_career_rates <- function(career_dt, tenure_col, group_cols, span) {
  smoothed_dt <- career_dt[,
    {
      tenure <- get(tenure_col)
      full_tenure <- seq.int(min(tenure), max(tenure))

      ### exit rates, as a probability
      exit_rate <- .smooth_rate_curve(tenure, 1 - px, pop, full_tenure, span)
      smoothed_px <- 1 - pmin(pmax(exit_rate, 0), 1)

      ### pay growth, from the years it was measured in
      has_growth <- !is.na(pay_growth)
      smoothed_growth <- if (any(has_growth)) {
        .smooth_rate_curve(
          tenure[has_growth], pay_growth[has_growth], n_pay[has_growth],
          full_tenure, span
        )
      } else {
        rep(NA_real_, length(full_tenure))
      }

      stats::setNames(
        list(full_tenure, smoothed_px, smoothed_growth),
        c(tenure_col, "px", "pay_growth")
      )
    },
    by = group_cols
  ]

  ### the observed columns, matched back by group and tenure
  observed_dt <- career_dt[, !c("px", "pay_growth")]
  smoothed_dt <- merge(
    smoothed_dt, observed_dt,
    by = c(group_cols, tenure_col), all.x = TRUE
  )
  setorderv(smoothed_dt, c(group_cols, tenure_col))

  smoothed_dt[]
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

#' Warn about duplicate person-snapshot rows in a survival panel
#'
#' Shared by both methods of `build_survival_panel()`, so the message is the
#' same for in-memory and database tables.
#'
#' @param n_dup Number. How many rows are duplicates.
#' @param personnel_id_col,ref_date_col Character. The person and snapshot
#'   date columns, named in the message.
#'
#' @returns The warning message, invisibly (called for its warning).
#' @keywords internal
.warn_survival_duplicates <- function(n_dup, personnel_id_col, ref_date_col) {
  warning(
    "`personnel` has ", n_dup, " duplicate rows at the ",
    personnel_id_col, "/", ref_date_col, " level, which should be unique. ",
    "Keeping one row per person and snapshot.",
    call. = FALSE
  )
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
      "would be wrong on the summed cells it fits.",
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
