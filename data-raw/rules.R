## Code to prepare validation rules datasets
library(dplyr)
devtools::load_all()

# Personnel validation rules
personnel_rules <- tibble::tibble(
  rule = c(
    "is_unique(personnel_id, ref_date)",
    "ref_date >= as.Date('1900-01-01') & ref_date <= Sys.Date()",
    "as.numeric(difftime(ref_date, birth_date, units = 'days')) / 365.25 >= 18 & as.numeric(difftime(ref_date, birth_date, units = 'days')) / 365.25 <= 70",
    "birth_date >= as.Date('1920-01-01') & birth_date <= Sys.Date()",
    "status %in% c('active', 'inactive', 'retired', 'terminated')"
  ),
  name = c(
    "personnel_unique_id",
    "personnel_ref_date_valid",
    "personnel_age_range",
    "personnel_birth_date",
    "personnel_status"
  ),
  description = c(
    "combination of personnel_id and ref_date is unique (no duplicate records)",
    "ref_date is a valid date (not in future, not before reasonable historical bound)",
    "age calculated from birth_date is within reasonable employment range (18-70 years)",
    "birth_date is reasonable if provided",
    "employment status has valid values if provided"
  ),
  label = c(
    "Unique personnel ID",
    "Valid date",
    "Reasonable age",
    "Valid birthdate",
    "Valid status"
  )
)

# Contract validation rules
contract_rules <- tibble::tibble(
  rule = c(
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
    "allowance_lcu >= 1 | is.na(allowance_lcu)",
    "in_range(gross_salary_lcu, min = quantile(gross_salary_lcu, 0.25, na.rm = TRUE) - 1.5 * IQR(gross_salary_lcu, na.rm = TRUE), max = quantile(gross_salary_lcu, 0.75, na.rm = TRUE) + 1.5 * IQR(gross_salary_lcu, na.rm = TRUE))",
    "in_range(net_salary_lcu, min = quantile(net_salary_lcu, 0.25, na.rm = TRUE) - 1.5 * IQR(net_salary_lcu, na.rm = TRUE), max = quantile(net_salary_lcu, 0.75, na.rm = TRUE) + 1.5 * IQR(net_salary_lcu, na.rm = TRUE))",
    "in_range(base_salary_lcu, min = quantile(base_salary_lcu, 0.25, na.rm = TRUE) - 1.5 * IQR(base_salary_lcu, na.rm = TRUE), max = quantile(base_salary_lcu, 0.75, na.rm = TRUE) + 1.5 * IQR(base_salary_lcu, na.rm = TRUE))",
    "in_range(allowance_lcu, min = quantile(allowance_lcu, 0.25, na.rm = TRUE) - 1.5 * IQR(allowance_lcu, na.rm = TRUE), max = quantile(allowance_lcu, 0.75, na.rm = TRUE) + 1.5 * IQR(allowance_lcu, na.rm = TRUE)) | is.na(allowance_lcu)"
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
    "wagebill_allowance",
    "wagebill_gross_outlier",
    "wagebill_net_outlier",
    "wagebill_base_outlier",
    "wagebill_allowance_outlier"
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
    "allowance is non-negative if provided",
    "gross salary is not a statistical outlier (within IQR-based thresholds)",
    "net salary is not a statistical outlier (within IQR-based thresholds)",
    "base salary is not a statistical outlier (within IQR-based thresholds)",
    "allowance is not a statistical outlier (within IQR-based thresholds)"
  ),
  label = c(
    "Unique contract ID",
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
    "Valid allowance",
    "Gross outlier",
    "Net outlier",
    "Base outlier",
    "Allowance outlier"
  )
)

# Export both rule sets separately
usethis::use_data(personnel_rules, overwrite = TRUE)
usethis::use_data(contract_rules, overwrite = TRUE)
