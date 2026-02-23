## code to prepare `rules` dataset goes here
library(dplyr)

# Personnel validation rules
personnel_rules <- tibble::tibble(
  rule = c(
    "\"personnel_id\" %in% colnames(.)",
    "\"ref_date\" %in% colnames(.)",
    "\"birth_date\" %in% colnames(.)",
    "\"status\" %in% colnames(.)",
    "is_unique(personnel_id, ref_date)",
    "ref_date >= as.Date('1900-01-01') & ref_date <= Sys.Date()",
    "as.numeric(difftime(ref_date, birth_date, units = 'days')) / 365.25 >= 18 & as.numeric(difftime(ref_date, birth_date, units = 'days')) / 365.25 <= 70",
    "birth_date >= as.Date('1920-01-01') & birth_date <= Sys.Date()",
    "status %in% c('active', 'inactive', 'retired', 'terminated')"
  ),
  name = c(
    "personnel_has_personnel_id",
    "personnel_has_ref_date",
    "personnel_has_birth_date",
    "personnel_has_status",
    "personnel_unique_id",
    "personnel_ref_date_valid",
    "personnel_age_range",
    "personnel_birth_date",
    "personnel_status"
  ),
  description = c(
    "personnel_id column exists in the dataset",
    "ref_date column exists in the dataset",
    "birth_date column exists in the dataset",
    "status column exists in the dataset",
    "combination of personnel_id and ref_date is unique (no duplicate records)",
    "ref_date is a valid date (not in future, not before reasonable historical bound)",
    "age calculated from birth_date is within reasonable employment range (18-70 years)",
    "birth_date is reasonable if provided",
    "employment status has valid values if provided"
  ),
  label = c(
    "Has personnel_id",
    "Has ref_date",
    "Has birth_date",
    "Has status",
    "Unique ID",
    "Valid date",
    "Reasonable age",
    "Valid birthdate",
    "Valid status"
  )
)

# Contract validation rules
contract_rules <- tibble::tibble(
  rule = c(
    "\"contract_id\" %in% colnames(.)",
    "\"ref_date\" %in% colnames(.)",
    "\"gross_salary_lcu\" %in% colnames(.)",
    "\"base_salary_lcu\" %in% colnames(.)",
    "\"allowance_lcu\" %in% colnames(.)",
    "is_unique(contract_id, ref_date)",
    "is_unique(contract_id, personnel_id, ref_date)",
    "ref_date >= as.Date('1900-01-01') & ref_date <= Sys.Date()",
    "whours >= 1 & whours <= 168",
    "start_date <= ref_date",
    "gross_salary_lcu >= base_salary_lcu + allowance_lcu",
    "net_salary_lcu <= gross_salary_lcu",
    "gross_salary_lcu >= 1",
    "base_salary_lcu >= 1",
    "net_salary_lcu >= 1",
    "base_salary_lcu <= gross_salary_lcu",
    "allowance_lcu >= 1 | is.na(allowance_lcu)"
  ),
  name = c(
    "contract_has_contract_id",
    "contract_has_ref_date",
    "contract_has_gross_salary",
    "contract_has_base_salary",
    "contract_has_allowance",
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
    "contract_id column exists in the dataset",
    "ref_date column exists in the dataset",
    "gross_salary_lcu column exists in the dataset",
    "base_salary_lcu column exists in the dataset",
    "allowance_lcu column exists in the dataset",
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
    "Has contract_id",
    "Has ref_date",
    "Has gross_salary",
    "Has base_salary",
    "Has allowance",
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

# Export both rule sets separately
usethis::use_data(personnel_rules, overwrite = TRUE)
usethis::use_data(contract_rules, overwrite = TRUE)
