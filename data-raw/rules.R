## code to prepare `rules` dataset goes here
##
## This script defines validation rules for HR data quality checks.
## Rules are structured as tibbles with four columns:
##   - rule: R expression to evaluate (as string)
##   - name: unique identifier for the rule
##   - description: detailed explanation for audit reports
##   - label: short label for visualizations
##
## These rules are exported as lazy-loaded datasets (.rda) and consumed
## by validate_data() function for runtime data quality assessment.

library(dplyr)

# ============================================================================
# Personnel Validation Rules
# ============================================================================
# These rules check personnel records for:
#   1. Uniqueness constraints (no duplicate records)
#   2. Date validity (temporal bounds and chronological consistency)
#   3. Age constraints (minimum working age, retirement age)
#   4. Categorical validity (employment status)
#
# Design decision: Age is calculated from birth_date + ref_date rather than
# stored as a variable to ensure temporal consistency across panel data.

personnel_rules <- tibble::tibble(
  rule = c(
    "is_unique(personnel_id, ref_date)",
    "ref_date >= as.Date('1900-01-01') & ref_date <= Sys.Date()",
    "as.numeric(difftime(ref_date, birth_date, units = 'days')) / 365.25 >= 18",
    "status == 'active' & as.numeric(difftime(ref_date, birth_date, units = 'days')) / 365.25 <= 65",
    "birth_date >= as.Date('1920-01-01') & birth_date <= Sys.Date()",
    "status %in% c('active', 'inactive', 'retired', 'terminated')"
  ),
  name = c(
    "personnel_unique_id",
    "personnel_ref_date_valid",
    "personnel_minimum_age",
    "personnel_maximum_age",
    "personnel_birth_date",
    "personnel_status"
  ),
  description = c(
    "combination of personnel_id and ref_date is unique (no duplicate records)",
    "ref_date is a valid date (not in future, not before reasonable historical bound)",
    "worker age is above minimum age (18)",
    "worker age is below maximum retirement age (65)",
    "birth_date is reasonable if provided",
    "employment status has valid values if provided"
  ),
  label = c(
    "Unique ID",
    "Valid date",
    "Minimum age",
    "Maximum age",
    "Valid birthdate",
    "Valid status"
  )
)

# ============================================================================
# Contract Validation Rules
# ============================================================================
# These rules check contract/payroll records for:
#   1. Uniqueness constraints (contract-level and assignment-level)
#   2. Date validity (temporal bounds)
#   3. Working hours reasonableness (1-168 hours per week)
#   4. Contract chronology (start_date <= ref_date for active contracts)
#   5. Wage bill integrity (component consistency and hierarchy)
#
# Design decision: Wage bill rules allow for missing allowances (NA) but
# require all salary components to be positive when present. This handles
# both simple payroll systems (base salary only) and complex systems
# (base + allowance + other components).

contract_rules <- tibble::tibble(
  rule = c(
    "is_unique(contract_id, ref_date)",
    "is_unique(contract_id, personnel_id, ref_date)",
    "ref_date >= as.Date('1900-01-01') & ref_date <= Sys.Date()",
    "whours >= 0 & whours <= 168",
    "start_date <= ref_date",
    "gross_salary_lcu >= base_salary_lcu + allowance_lcu",
    "net_salary_lcu <= gross_salary_lcu",
    "gross_salary_lcu >= 0",
    "base_salary_lcu >= 0",
    "net_salary_lcu >= 0",
    "base_salary_lcu <= gross_salary_lcu",
    "allowance_lcu >= 0 | is.na(allowance_lcu)"
  ),
  name = c(
    "contract_unique_id",
    "contract_unique_personnel",
    "contract_ref_date_valid",
    "contract_whours",
    "contract_status",
    "wagebill_gross_composition",
    "wagebill_net_le_gross",
    "wagebill_gross_positive",
    "wagebill_base_positive",
    "wagebill_net_positive",
    "wagebill_base_le_gross",
    "wagebill_allowance"
  ),
  description = c(
    "combination of contract_id and ref_date is unique (no duplicate contract records)",
    "combination of contract_id, personnel_id, and ref_date is unique (no duplicate assignments)",
    "ref_date is a valid date (not in future, not before reasonable historical bound)",
    "working hours are positive and reasonable",
    "employment status is valid (active contracts have start_date <= ref_date)",
    "gross salary is consistent with base salary + allowance",
    "net salary is less than or equal to gross salary",
    "gross salary is positive",
    "base salary is positive",
    "net salary is positive",
    "base salary does not exceed gross salary",
    "allowance is non-negative if provided"
  ),
  label = c(
    "Unique contract",
    "Unique assignment",
    "Valid date",
    "Reasonable hours",
    "Valid status",
    "Gross composition",
    "Net vs gross",
    "Positive gross",
    "Positive base",
    "Positive net",
    "Base vs gross",
    "Valid allowance"
  )
)

# ============================================================================
# Export Rule Sets
# ============================================================================
# Export as lazy-loaded datasets in data/ directory
# These are documented in R/data.R and accessible as govhr::personnel_rules
# and govhr::contract_rules after package installation.

usethis::use_data(personnel_rules, overwrite = TRUE)
usethis::use_data(contract_rules, overwrite = TRUE)
