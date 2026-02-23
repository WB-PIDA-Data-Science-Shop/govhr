#' Validate personnel data
#'
#' @description
#' Defines validation rules using the `validator` package for assessing
#' personnel data quality. Rules cover coverage (minimum requirements) and 
#' consistency (logical integrity) checks for workforce dimensions.
#'
#' @return A validator object containing personnel validation rules.
#'
#' @examples
#' \dontrun{
#' library(validate)
#' rules <- validate_personnel()
#' confront(personnel_dt, rules)
#' }
#'
#' @importFrom validate validator
#' @export
validate_personnel <- function() {
  validate::validator(
      
    # (a) ref_date is a valid date (not in future, not before reasonable historical bound)
    personnel_consistency_ref_date_valid = ref_date >= as.Date("1900-01-01") & ref_date <= Sys.Date(),
    
    # (b) age is within reasonable employment range (if age available)
    personnel_consistency_age_range = if_available(age, age >= 18 & age <= 70),
    
    # (c) birth_date is reasonable if provided
    personnel_consistency_birth_date = if_available(birth_date, 
                                                     birth_date >= as.Date("1920-01-01") & 
                                                     birth_date <= Sys.Date()),
    
    # (d) employment status has valid values if provided
    personnel_consistency_status = if_available(status,
                                                status %in% c("active", "inactive", "retired", "terminated"))
  )
}

#' Validate contract data
#'
#' @description
#' Defines validation rules using the `validator` package for assessing
#' contract data quality. Rules cover coverage (completeness) and 
#' consistency (logical integrity) checks for wage bill and contract dimensions.
#'
#' @return A validator object containing contract validation rules.
#'
#' @examples
#' \dontrun{
#' library(validate)
#' rules <- validate_contract()
#' confront(contract_dt, rules)
#' }
#'
#' @importFrom validate validator
#' @export
validate_contract <- function() {
  validate::validator(
    
    # Coverage checks --------------------------------------------------------
    
    # (a) contract_id is present and not missing
    contract_coverage_contract_id = !is.na(contract_id),
    
    # (b) ref_date is present and not missing
    contract_coverage_ref_date = !is.na(ref_date),
    
    # (c) occupation information is present
    contract_coverage_occupation = !is.na(occupation_native) | !is.na(occupation_iscocode),
    
    # (d) gross salary is present and not missing
    wagebill_coverage_gross_salary = !is.na(gross_salary_lcu),
    
    # (e) base salary is present and not missing
    wagebill_coverage_base_salary = !is.na(base_salary_lcu),
    
    # (f) net salary is present and not missing
    wagebill_coverage_net_salary = !is.na(net_salary_lcu),
    
    # Consistency checks -----------------------------------------------------
    
    ## Contract consistency
    # (a) ref_date is a valid date (not in future, not before reasonable historical bound)
    contract_consistency_ref_date_valid = ref_date >= as.Date("1900-01-01") & ref_date <= Sys.Date(),
    
    # (b) seniority is non-negative
    contract_consistency_seniority = if_available(seniority, seniority >= 0),
    
    # (c) working hours are positive and reasonable
    contract_consistency_whours = if_available(whours, whours > 0 & whours <= 168),
    
    # (d) employment status is valid (active contracts have start_date <= ref_date)
    contract_consistency_status = if_available(start_date, 
                                                is.na(start_date) | start_date <= ref_date),
    
    # (e) paygrade is positive if provided
    contract_consistency_paygrade = if_available(paygrade, paygrade > 0),
    
    ## Wage bill consistency
    # (a) gross salary is consistent with base salary + allowance
    wagebill_consistency_gross_composition = if_available(allowance_lcu,
      gross_salary_lcu >= base_salary_lcu + allowance_lcu
    ),
    
    # (b) net salary is less than or equal to gross salary
    wagebill_consistency_net_le_gross = net_salary_lcu <= gross_salary_lcu,
    
    # (c) gross salary is positive
    wagebill_consistency_gross_positive = gross_salary_lcu >= 1,
    
    # (d) base salary is positive
    wagebill_consistency_base_positive = base_salary_lcu >= 1,
    
    # (e) net salary is positive
    wagebill_consistency_net_positive = net_salary_lcu >= 1,
    
    # (f) base salary does not exceed gross salary
    wagebill_consistency_base_le_gross = base_salary_lcu <= gross_salary_lcu,
    
    # (g) base salary does not exceed net salary
    wagebill_consistency_base_le_net = base_salary_lcu <= net_salary_lcu,
    
    # (h) allowance is non-negative if provided
    wagebill_consistency_allowance = if_available(allowance_lcu, allowance_lcu >= 0)
  )
}