#' Validate Personnel Data Quality
#'
#' @description
#' Validates personnel data against a set of consistency rules covering
#' date validity, age ranges, birth dates, and employment status. Returns
#' a confrontation object with validation results.
#'
#' @param data A data.frame or data.table containing personnel data with
#'   columns: `ref_date`, `age`, `birth_date`, `status`.
#'
#' @return A `confrontation` object (from the `validate` package) containing
#'   validation results. Use `summary()` to view pass/fail counts.
#'
#' @details
#' The function checks the following rules:
#' \itemize{
#'   \item \strong{personnel_ref_date_valid}: Reference date is between 
#'     1900-01-01 and today
#'   \item \strong{personnel_age_range}: Age is between 18 and 70
#'   \item \strong{personnel_birth_date}: Birth date is between 1920-01-01 
#'     and today
#'   \item \strong{personnel_status}: Employment status is one of "active", 
#'     "inactive", "retired", or "terminated"
#' }
#'
#' @examples
#' library(validate)
#' 
#' validate_personnel(personnel_dt)
#'
#' @importFrom validate validator confront
#' @export
validate_personnel <- function(data) {
  rules <- validate::validator(
      
    # (a) ref_date is a valid date (not in future, not before reasonable historical bound)
    personnel_ref_date_valid = ref_date >= as.Date("1900-01-01") & ref_date <= Sys.Date(),
    
    # (b) age is within reasonable employment range (if age available)
    personnel_age_range = age >= 18 & age <= 70,
    
    # (c) birth_date is reasonable if provided
    personnel_birth_date = birth_date >= as.Date("1920-01-01") & birth_date <= Sys.Date(),
    
    # (d) employment status has valid values if provided
    personnel_status = status %in% c("active", "inactive", "retired", "terminated")
  )

  validate::confront(data, rules)
}

#' Validate Contract Data Quality
#'
#' @description
#' Validates contract data against a set of consistency rules covering
#' date validity, working hours, employment status, and wage bill logic
#' (salary component relationships). Returns a confrontation object with
#' validation results.
#'
#' @param data A data.frame or data.table containing contract data with
#'   columns: `ref_date`, `whours`, `start_date`, `gross_salary_lcu`, 
#'   `base_salary_lcu`, `net_salary_lcu`, `allowance_lcu`.
#'
#' @return A `confrontation` object (from the `validate` package) containing
#'   validation results. Use `summary()` to view pass/fail counts.
#'
#' @details
#' The function checks the following rules:
#' 
#' \strong{Contract consistency:}
#' \itemize{
#'   \item \strong{contract_ref_date_valid}: Reference date is between 
#'     1900-01-01 and today
#'   \item \strong{contract_whours}: Working hours are between 1 and 168 
#'     per week
#'   \item \strong{contract_status}: Start date is on or before reference date
#' }
#' 
#' \strong{Wage bill consistency:}
#' \itemize{
#'   \item \strong{wagebill_gross_composition}: Gross salary ≥ base salary + 
#'     allowance
#'   \item \strong{wagebill_net_le_gross}: Net salary ≤ gross salary
#'   \item \strong{wagebill_gross_positive}: Gross salary ≥ 1
#'   \item \strong{wagebill_base_positive}: Base salary ≥ 1
#'   \item \strong{wagebill_net_positive}: Net salary ≥ 1
#'   \item \strong{wagebill_base_le_gross}: Base salary ≤ gross salary
#'   \item \strong{wagebill_allowance}: Allowance ≥ 1
#' }
#'
#' @examples
#' \dontrun{
#' library(validate)
#' 
#' # Run validation
#' results <- validate_contract(contract_dt)
#' 
#' # View summary
#' summary(results)
#' 
#' # Extract violations
#' violations <- violating(contract_dt, results)
#' 
#' # Check specific rule
#' failing_gross <- contract_dt[!values(results)$wagebill_gross_positive, ]
#' }
#'
#' @importFrom validate validator confront
#' @export
validate_contract <- function(data) {
  rules <- validate::validator(
    # (a) ref_date is a valid date (not in future, not before reasonable historical bound)
    contract_ref_date_valid = ref_date >= as.Date("1900-01-01") & ref_date <= Sys.Date(),
    
    # (b) working hours are positive and reasonable
    contract_whours = whours >= 1 & whours <= 168,
    
    # (c) employment status is valid (active contracts have start_date <= ref_date)
    contract_status = start_date <= ref_date,
    
    ## Wage bill consistency
    # (a) gross salary is consistent with base salary + allowance
    wagebill_gross_composition = 
      gross_salary_lcu >= base_salary_lcu + allowance_lcu,
    
    # (b) net salary is less than or equal to gross salary
    wagebill_net_le_gross = net_salary_lcu <= gross_salary_lcu,
    
    # (c) gross salary is positive
    wagebill_gross_positive = gross_salary_lcu >= 1,
    
    # (d) base salary is positive
    wagebill_base_positive = base_salary_lcu >= 1,
    
    # (e) net salary is positive
    wagebill_net_positive = net_salary_lcu >= 1,
    
    # (f) base salary does not exceed gross salary
    wagebill_base_le_gross = base_salary_lcu <= gross_salary_lcu,
    
    # (g) allowance is non-negative if provided
    wagebill_allowance = allowance_lcu >= 1
  )

  validate::confront(data, rules)
}