#' Project retirements of the current workforce
#'
#' Projects, for each year ahead, how many people in the current workforce
#' reach the retirement age, what share of the current headcount they make up
#' and, optionally, what their retirement costs are. The current workforce is
#' everyone active on the latest reference date.
#'
#' @param data Data frame or remote database table (`tbl_dbi`) with one row
#'   per person-record. Must contain `personnel_id`, `ref_date` and the
#'   columns named in `birth_col` and `status_col`, and in `measure_col` if
#'   given.
#' @param threshold_age Whole number. Age at which people retire. Default
#'   `60`.
#' @param birth_col Character. Column holding dates of birth. Default
#'   `"birth_date"`.
#' @param group_cols Character vector of columns to group by, such as
#'   `"est_id"`, or `NULL` (default) for the whole workforce. Must not include
#'   `ref_date`.
#' @param measure_col Character. Pay column used to cost the retirements, or
#'   `NULL` (default) to only count them.
#' @param status_col Character. Column holding employment status, with active
#'   personnel recorded as `"active"`. Default `"employment_status"`.
#' @param retirement_coefficient Number. Share of their pay that retirees go
#'   on receiving as a pension, used to cost the retirements. Default `0.6`.
#' @param horizon Whole number. How many years past the latest reference date
#'   to project. Default `10`.
#' @param ... Arguments passed to methods.
#'
#' @returns A table with one row per projected year and group, containing:
#' \describe{
#'   \item{ref_date}{The last day of the year in which people reach
#'     `threshold_age`.}
#'   \item{headcount}{Number of people in the current workforce.}
#'   \item{projected_retirements}{People in the current workforce who reach
#'     `threshold_age` that year.}
#'   \item{projected_retirement_rate}{`projected_retirements` divided by
#'     `headcount`.}
#'   \item{projected_cost}{Only with `measure_col`: the retirees' pay on the
#'     latest date, times `retirement_coefficient`.}
#' }
#' A data.table for data frame input; a lazy table for `tbl_dbi` input (use
#' [dplyr::collect()] to bring it into memory).
#'
#' @details
#' Only people active on the latest date are projected: people who left
#' earlier, or whose record that date is not active, are no longer in the
#' workforce. Nor are people who reached `threshold_age` by the latest date,
#' even if they are still active.
#'
#' The projected years are those whose last day falls after the latest date
#' and at most `horizon` years after it. Every group in the current workforce
#' appears in every year, with zero retirements when nobody reaches
#' `threshold_age`.
#'
#' People are counted once, even if they hold several contracts, and the pay
#' on all their contracts is costed. With `group_cols`, each person is counted
#' in the group they belong to on the latest date. People with a missing
#' `personnel_id` are not counted, as in [compute_headcount()].
#'
#' @seealso [compute_retirement()], which counts the retirements that already
#'   happened.
#'
#' @examples
#' hr <- data.frame(
#'   personnel_id = c(1, 2, 3, 1, 2, 3),
#'   ref_date = as.Date(rep(c("2020-01-01", "2021-01-01"), each = 3)),
#'   employment_status = c(rep("active", 5), "pensioner"),
#'   birth_date = as.Date(rep(c("1962-05-01", "1990-01-01", "1950-01-01"), 2)),
#'   gross_salary_lcu = c(100, 200, 300, 110, 210, 90)
#' )
#' project_retirement(hr, measure_col = "gross_salary_lcu")
#'
#' @export
project_retirement <- function(data, ...) {
  UseMethod("project_retirement")
}

#' @rdname project_retirement
#' @importFrom data.table := as.data.table setcolorder setnafill setorderv
#'   uniqueN
#' @importFrom lubridate add_with_rollback years
#' @importFrom rlang check_dots_empty
#' @export
project_retirement.data.frame <- function(
  data,
  threshold_age = 60,
  birth_col = "birth_date",
  group_cols = NULL,
  measure_col = NULL,
  status_col = "employment_status",
  retirement_coefficient = 0.6,
  horizon = 10,
  ...
) {
  rlang::check_dots_empty()

  if ("ref_date" %in% group_cols) {
    stop("`ref_date` should not be included in `group_cols`")
  }

  dt <- data.table::as.data.table(data)
  latest_date <- max(dt[["ref_date"]], na.rm = TRUE)
  calendar <- data.table::as.data.table(
    retirement_calendar(latest_date, horizon)
  )

  workforce <- dt[ref_date == latest_date & get(status_col) == "active"]

  headcount <- compute_headcount(workforce, group_cols = group_cols)[
    , c(group_cols, "headcount"), with = FALSE
  ]

  # people born after this date reach threshold_age after the latest date
  # this takes into account people who are already past the threshold age
  # but are still active and removes them from the projection
  born_after <- lubridate::add_with_rollback(
    latest_date,
    -lubridate::years(threshold_age)
  )

  retirees <- workforce[
    get(birth_col) > born_after,
    c("personnel_id", birth_col, group_cols, measure_col),
    with = FALSE
  ]
  retirees[, retirement_year := data.table::year(get(birth_col)) + threshold_age]

  # the calendar drops the years beyond the horizon and dates the rest
  retirees <- calendar[retirees, on = "retirement_year", nomatch = NULL]

  by_cols <- c("ref_date", group_cols)

  projected <- if (is.null(measure_col)) {
    retirees[
      , .(projected_retirements = uniqueN(personnel_id, na.rm = TRUE)),
      by = by_cols
    ]
  } else {
    retirees[
      , .(
        projected_retirements = uniqueN(personnel_id, na.rm = TRUE),
        projected_cost = sum(get(measure_col), na.rm = TRUE) *
          retirement_coefficient
      ),
      by = by_cols
    ]
  }

  # every group in the current workforce appears in every projected year:
  # grouping by all of headcount's columns repeats each of its rows per year
  grid <- headcount[, .(ref_date = calendar[["ref_date"]]), by = names(headcount)]

  projection <- projected[grid, on = by_cols]

  data.table::setnafill(
    projection,
    fill = 0,
    cols = intersect(
      c("projected_retirements", "projected_cost"),
      names(projection)
    )
  )
  projection[, projected_retirement_rate := projected_retirements / headcount]

  data.table::setcolorder(
    projection,
    c(by_cols, "headcount", "projected_retirements", "projected_retirement_rate")
  )
  data.table::setorderv(projection, by_cols)

  projection[]
}

#' @rdname project_retirement
#' @importFrom dplyr across all_of any_of coalesce cross_join filter
#'   inner_join left_join mutate n_distinct pull select summarise
#' @importFrom lubridate add_with_rollback year years
#' @importFrom rlang .data check_dots_empty exprs sym
#' @export
project_retirement.tbl_dbi <- function(
  data,
  threshold_age = 60,
  birth_col = "birth_date",
  group_cols = NULL,
  measure_col = NULL,
  status_col = "employment_status",
  retirement_coefficient = 0.6,
  horizon = 10,
  ...
) {
  rlang::check_dots_empty()

  if ("ref_date" %in% group_cols) {
    stop("`ref_date` should not be included in `group_cols`")
  }

  # the projected years and the age cut-off both hang on the latest date, so
  # that single value is read into memory
  latest_date <- data |>
    dplyr::summarise(ref_date = max(ref_date, na.rm = TRUE)) |>
    dplyr::pull(ref_date)

  # copy_inline() sends the calendar as part of the query, so no write access
  # to the database is needed
  calendar <- dbplyr::copy_inline(
    dbplyr::remote_con(data),
    retirement_calendar(latest_date, horizon)
  )

  workforce <- data |>
    dplyr::filter(
      ref_date == !!latest_date,
      .data[[status_col]] == "active"
    )

  headcount <- workforce |>
    compute_headcount(group_cols = group_cols) |>
    dplyr::select(dplyr::all_of(c(group_cols, "headcount")))

  # people born after this date reach threshold_age after the latest date
  # this takes into account people who are already past the threshold age
  # but are still active and removes them from the projection
  born_after <- lubridate::add_with_rollback(
    latest_date,
    -lubridate::years(threshold_age)
  )

  cost <- if (!is.null(measure_col)) {
    rlang::exprs(
      projected_cost = sum(!!rlang::sym(measure_col), na.rm = TRUE) *
        !!retirement_coefficient
    )
  }

  projected <- workforce |>
    dplyr::filter(.data[[birth_col]] > !!born_after) |>
    dplyr::select(
      dplyr::all_of(c("personnel_id", birth_col, group_cols, measure_col))
    ) |>
    dplyr::mutate(
      retirement_year = lubridate::year(.data[[birth_col]]) + !!threshold_age
    ) |>
    # the calendar drops the years beyond the horizon and dates the rest
    dplyr::inner_join(calendar, by = "retirement_year") |>
    dplyr::summarise(
      projected_retirements = dplyr::n_distinct(personnel_id, na.rm = TRUE),
      !!!cost,
      .by = dplyr::all_of(c("ref_date", group_cols))
    )

  # every group in the current workforce appears in every projected year
  headcount |>
    dplyr::cross_join(dplyr::select(calendar, ref_date)) |>
    # keep missing groups: sql joins do not match NA keys by default
    dplyr::left_join(
      projected,
      by = c("ref_date", group_cols),
      na_matches = "na"
    ) |>
    dplyr::mutate(
      dplyr::across(
        dplyr::any_of(c("projected_retirements", "projected_cost")),
        \(x) dplyr::coalesce(x, 0)
      ),
      projected_retirement_rate = projected_retirements / headcount
    ) |>
    dplyr::select(
      ref_date,
      dplyr::all_of(group_cols),
      headcount,
      projected_retirements,
      projected_retirement_rate,
      dplyr::any_of("projected_cost")
    )
}

# the projected years are those whose last day falls after the latest date and
# at most `horizon` years after it, each dated by that last day
#' @importFrom lubridate add_with_rollback year years
#' @keywords internal
#' @noRd
retirement_calendar <- function(latest_date, horizon) {
  last_date <- lubridate::add_with_rollback(
    latest_date,
    lubridate::years(horizon)
  )

  retirement_year <- seq(
    lubridate::year(latest_date),
    lubridate::year(last_date)
  )
  year_end <- as.Date(paste0(retirement_year, "-12-31"))
  in_horizon <- year_end > latest_date & year_end <= last_date

  data.frame(
    retirement_year = retirement_year[in_horizon],
    ref_date = year_end[in_horizon]
  )
}

#' Compute ratio of last salary to first pension for retired workers
#'
#' For each individual who has retired, computes the ratio of their first
#' pension payment to their last active salary.
#'
#' @param personnel A data.table (or tibble/data.frame) containing at minimum
#'   the columns named in `id_col`, `status_col`, and `date_col`.
#' @param contracts A data.table (or tibble/data.frame) containing at minimum
#'   the columns named in `id_col`, `date_col`, and `salary_col`.
#' @param salary_col A single string naming the compensation column to use,
#'   e.g. `"gross_salary_def"` (default), `"base_salary_lcu"`, etc.
#' @param personnel_id_col A single string naming the personnel identifier column.
#'   Defaults to `"personnel_id"`.
#' @param status_col A single string naming the employment status column inside
#' `personnel_dt`.
#'   Defaults to `"employment_status"`.
#' @param date_col A single string naming the snapshot/reference date column.
#'   Defaults to `"ref_date"`.
#' @param pensioner_value A single string giving the value of `status_col`
#'   that identifies a pensioner record. Defaults to `"pensioner"`.
#' @param keep_vars A character vector of additional contract-level columns
#'   to attach via `govhr::add_contract_to_event()`. Defaults to NULL
#' @param personnel_dt Deprecated. Use `personnel` instead.
#' @param contract_dt Deprecated. Use `contracts` instead.
#'
#'
#' @returns A data.table with one row per retiring individual containing
#'   the `id_col` identifier, `ref_date_active` (last active date),
#'   `last_salary`, `ref_date_pension` (first pension date),
#'   `first_pension`, and `replacement_rate`.
#'
#' @details
#' The replacement rate is a standard diagnostic in public sector pension
#' and workforce analysis, and it matters here for a few distinct reasons:
#'
#' \itemize{
#'   \item \strong{Fiscal sustainability}: Aggregated across occupation or
#'     paygrade, replacement rates feed directly into pension liability
#'     projections.
#'   \item \strong{Retirement incentive / take-up behavior}: Low replacement
#'     rates help explain deferred retirement, relevant to calibrating
#'     \code{ANNUAL_TAKE_UP} rather than assuming 100\% take-up at
#'     eligibility.
#'   \item \strong{Equity diagnostics}: Comparing rates across paygrade,
#'     occupation, or establishment can surface structural inequities in
#'     how the pension formula interacts with career trajectories.
#'   \item \strong{Policy reform simulation}: Because the function is
#'     column-name agnostic, it can be re-run under counterfactual salary
#'     or pension formulas or against differently structured client
#'     datasets without code changes.
#' }
#'
#' @export
compute_pension_ratio <- function(
  personnel,
  contracts,
  salary_col,
  personnel_id_col = "personnel_id",
  status_col = "employment_status",
  date_col = "ref_date",
  pensioner_value = "pensioner",
  keep_vars = NULL,
  personnel_dt = NULL,
  contract_dt = NULL
) {
  personnel <- resolve_renamed_arg(personnel, personnel_dt, "personnel_dt", "personnel")
  contracts <- resolve_renamed_arg(contracts, contract_dt, "contract_dt", "contracts")
  ## ensure we have data.tables
  personnel <- data.table::as.data.table(personnel)
  contracts <- data.table::as.data.table(contracts)

  stopifnot(
    salary_col %in% names(contracts),
    status_col %in% names(personnel),
    personnel_id_col %in% names(personnel),
    personnel_id_col %in% names(contracts),
    date_col %in% names(personnel),
    date_col %in% names(contracts)
  )

  # Identify pensioner IDs
  retiree_ids <- unique(personnel[
    get(status_col) == pensioner_value,
    get(personnel_id_col)
  ])

  # Tag retiree contracts with employment_status from personnel table
  retiree_tagged <- merge(
    contracts[get(personnel_id_col) %in% retiree_ids],
    personnel[, c(personnel_id_col, status_col, date_col), with = FALSE],
    by = c(personnel_id_col, date_col),
    all.x = TRUE
  )

  # Helper: drop rows where salary_col is NA
  not_na_salary <- !is.na(retiree_tagged[[salary_col]])

  # Last active contract (non-pensioner) per person
  last_active <- retiree_tagged[
    get(status_col) != pensioner_value & not_na_salary
  ]
  last_active <- last_active[
    last_active[, .I[which.max(get(date_col))], by = personnel_id_col]$V1
  ]
  last_active[, status := "last_active"]

  # First pension contract per person
  first_pension <- retiree_tagged[
    get(status_col) == pensioner_value & !is.na(retiree_tagged[[salary_col]])
  ]
  first_pension <- first_pension[
    first_pension[, .I[which.min(get(date_col))], by = personnel_id_col]$V1
  ]
  first_pension[, status := "first_pension"]

  # Add contract details
  last_active <- add_contract_to_event(
    events = last_active,
    contracts = contracts,
    keep_vars = keep_vars
  )
  data.table::setorderv(
    last_active,
    c(personnel_id_col, date_col, salary_col),
    order = c(1L, 1L, -1L)
  )
  last_active <- last_active[, .SD[1L], by = c(personnel_id_col, date_col)]

  first_pension <- add_contract_to_event(
    events = first_pension,
    contracts = contracts,
    keep_vars = keep_vars
  )
  data.table::setorderv(
    first_pension,
    c(personnel_id_col, date_col, salary_col),
    order = c(1L, 1L, -1L)
  )
  first_pension <- first_pension[, .SD[1L], by = c(personnel_id_col, date_col)]

  # Compute replacement rate
  # keep_vars are carried from last_active only (i.e. the individual's
  # attributes at the point of retirement) to avoid .x/.y name collisions
  # with first_pension, which typically has the same static attributes anyway.
  active_cols <- c(personnel_id_col, date_col, salary_col, keep_vars)
  active <- last_active[status == "last_active", ..active_cols]
  data.table::setnames(
    active,
    c(date_col, salary_col),
    c("ref_date_active", "last_salary")
  )

  pension <- first_pension[
    status == "first_pension",
    c(personnel_id_col, date_col, salary_col),
    with = FALSE
  ]
  data.table::setnames(
    pension,
    c(date_col, salary_col),
    c("ref_date_pension", "first_pension")
  )

  ratio_dt <- merge(active, pension, by = personnel_id_col)
  ratio_dt[, replacement_rate := first_pension / last_salary]
  ratio_dt <- ratio_dt[is.finite(replacement_rate)]

  return(ratio_dt)
}

# helpers ----------------------------------------------------------------

#' Add contract information to event records
#'
#' @description
#' This function merges contract information into an event dataset (such as hires, terminations, or transfers)
#' by matching on `personnel_id` and `ref_date`. It ensures that selected variables from the contract dataset
#' are attached to corresponding events without duplicating records.
#'
#' @param events A data.table containing personnel event records. Must include the columns
#'   `personnel_id` and `ref_date`.
#' @param contracts A data.table containing contract information, also including `personnel_id`
#'   and `ref_date`. The contract dataset provides additional attributes describing the personnel's
#'   contractual context on each reference date.
#' @param keep_vars A character vector of variable names in `contract_dt` to be merged into the
#'   event dataset. These typically describe contract-level attributes such as position, department,
#'   or employment type.
#' @param event_dt Deprecated. Use `events` instead.
#' @param contract_dt Deprecated. Use `contracts` instead.
#'
#' @return
#' A data.table identical to `event_dt`, but with the specified variables from `contract_dt`
#' joined in by matching on `personnel_id` and `ref_date`.
#'
#' @details
#' The function performs a *right join* operation of the `contract_dt` onto `event_dt`
#' (via `data.table`'s `on` syntax). Only unique combinations of `personnel_id`, `ref_date`,
#' and `keep_vars` are retained from the contract dataset prior to the join, preventing
#' duplicate key matches.
#'
#' This function is particularly useful when enriching HR event logs with contextual information
#' about the employee’s contract at the time of each event.
#'
#' @examples
#' \dontrun{
#' library(data.table)
#'
#' event_dt <- data.table(
#'   personnel_id = c(1, 2, 3),
#'   ref_date = as.IDate(c("2020-01-01", "2020-02-01", "2020-03-01")),
#'   type_event = c("hire", "fire", "hire")
#' )
#'
#' contract_dt <- data.table(
#'   personnel_id = c(1, 2, 3),
#'   ref_date = as.IDate(c("2020-01-01", "2020-02-01", "2020-03-01")),
#'   department = c("Finance", "HR", "IT"),
#'   contract_type = c("permanent", "temporary", "consultant")
#' )
#'
#' enriched_events <- add_contract_to_event(
#'   event_dt,
#'   contract_dt,
#'   keep_vars = c("department", "contract_type")
#' )
#' }
#'
#' @seealso [data.table::merge()], [data.table::unique()]
#' @export
add_contract_to_event <- function(events, contracts, keep_vars, event_dt = NULL, contract_dt = NULL) {
  events <- resolve_renamed_arg(events, event_dt, "event_dt", "events")
  contracts <- resolve_renamed_arg(contracts, contract_dt, "contract_dt", "contracts")
  contracts <- unique(contracts[,
    c("personnel_id", "ref_date", keep_vars),
    with = FALSE
  ])

  events <- contracts[events, on = c("personnel_id", "ref_date")]

  return(events)
}
