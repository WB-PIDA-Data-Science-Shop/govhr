##############################################################################
############ FUNCTIONS TO SUPPORT THE ANALYTICS APPLICATIONS #################
##############################################################################

#' Compute Ratio of Last Salary to First Pension for Retired Workers
#'
#' For each individual who has retired, computes the ratio of their first
#' pension payment to their last active salary.
#'
#' @param personnel_dt A data.table (or tibble/data.frame) containing at minimum
#'   the columns named in `id_col`, `status_col`, and `date_col`.
#' @param contract_dt A data.table (or tibble/data.frame) containing at minimum
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
#'   
#'
#' @return A data.table with one row per retiring individual containing
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
#' 
compute_pension_ratio <- function(personnel_dt,
                                  contract_dt,
                                  salary_col,
                                  personnel_id_col = "personnel_id",
                                  status_col = "employment_status",
                                  date_col = "ref_date",
                                  pensioner_value = "pensioner",
                                  keep_vars = NULL) {

  ## ensure we have data.tables
  personnel_dt <- data.table::as.data.table(personnel_dt)
  contract_dt  <- data.table::as.data.table(contract_dt)
  
  stopifnot(
    salary_col %in% names(contract_dt),
    status_col %in% names(personnel_dt),
    personnel_id_col %in% names(personnel_dt),
    personnel_id_col %in% names(contract_dt),
    date_col %in% names(personnel_dt),
    date_col %in% names(contract_dt)
  )

  # Identify pensioner IDs
  retiree_ids <- unique(personnel_dt[get(status_col) == pensioner_value, get(personnel_id_col)])

  # Tag retiree contracts with employment_status from personnel table
  retiree_tagged <- merge(
    contract_dt[get(personnel_id_col) %in% retiree_ids],
    personnel_dt[, c(personnel_id_col, status_col, date_col), with = FALSE],
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
  last_active <- govhr::add_contract_to_event(
    event_dt    = last_active,
    contract_dt = contract_dt,
    keep_vars   = keep_vars
  )
  data.table::setorderv(last_active, c(personnel_id_col, date_col, salary_col), order = c(1L, 1L, -1L))
  last_active <- last_active[, .SD[1L], by = c(personnel_id_col, date_col)]

  first_pension <- govhr::add_contract_to_event(
    event_dt    = first_pension,
    contract_dt = contract_dt,
    keep_vars   = keep_vars
  )
  data.table::setorderv(first_pension, c(personnel_id_col, date_col, salary_col), order = c(1L, 1L, -1L))
  first_pension <- first_pension[, .SD[1L], by = c(personnel_id_col, date_col)]

  # Compute replacement rate
  # keep_vars are carried from last_active only (i.e. the individual's
  # attributes at the point of retirement) to avoid .x/.y name collisions
  # with first_pension, which typically has the same static attributes anyway.
  active_cols <- c(personnel_id_col, date_col, salary_col, keep_vars)
  active <- last_active[status == "last_active", ..active_cols]
  data.table::setnames(active, c(date_col, salary_col), c("ref_date_active", "last_salary"))

  pension <- first_pension[status == "first_pension", c(personnel_id_col, date_col, salary_col), with = FALSE]
  data.table::setnames(pension, c(date_col, salary_col), c("ref_date_pension", "first_pension"))

  ratio_dt <- merge(active, pension, by = personnel_id_col)
  ratio_dt[, replacement_rate := first_pension / last_salary]
  ratio_dt <- ratio_dt[is.finite(replacement_rate)]

  return(ratio_dt)

}



