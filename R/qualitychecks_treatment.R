# ==============================================================================
# Data Quality Treatment Functions
# ==============================================================================
# 
# This module provides functions to address violations identified by the
# validation rules defined in govhr::personnel_rules and govhr::contract_rules.
# 
# Each function corresponds to specific validation rules and offers different
# strategies for handling violations (flagging, filtering, correcting).
# 
# Design philosophy:
# - Explicit over implicit: Functions require user to choose correction strategy
# - Non-destructive by default: Prefer flagging over automatic deletion
# - Composable: Functions can be chained in a cleaning pipeline
# - Auditable: Master function (clean_hr_data) provides verbose logging
# ==============================================================================

# 1. HANDLE DUPLICATE RECORDS ================================================

#' Remove Duplicate Personnel Records
#'
#' @title Address Violations of Personnel ID Uniqueness Rule
#'
#' @description
#' Addresses violations of the `personnel_unique_id` rule by removing duplicate
#' personnel_id + ref_date combinations. This function provides three strategies
#' for handling duplicates: keep first occurrence, keep last occurrence, or
#' remove all duplicated records.
#'
#' @param data A data.frame or data.table containing personnel records with
#'   columns `personnel_id` and `ref_date`.
#' @param keep Character, which duplicate to keep:
#'   \itemize{
#'     \item `"first"` (default): Keep the first occurrence of each duplicate group
#'     \item `"last"`: Keep the last occurrence of each duplicate group
#'     \item `"none"`: Remove all records involved in duplication (conservative approach)
#'   }
#'
#' @return A data.frame with duplicates handled according to the `keep` parameter.
#'   Row count will be reduced if duplicates were present.
#'
#' @details
#' **Why duplicates occur:** Data entry errors, system glitches during uploads,
#' or merging multiple data sources without proper reconciliation.
#' 
#' **Strategy guidance:**
#' - Use `keep = "first"` when earlier records are more reliable (e.g., original entry)
#' - Use `keep = "last"` when later records contain corrections/updates
#' - Use `keep = "none"` when you cannot determine which record is correct and
#'   need to manually review all duplicates
#'
#' @examples
#' \dontrun{
#' # Keep first occurrence (default)
#' clean_personnel <- remove_duplicate_personnel(
#'   personnel_df, 
#'   keep = "first"
#' )
#' 
#' # Remove all duplicates for manual review
#' flagged_duplicates <- remove_duplicate_personnel(
#'   personnel_df,
#'   keep = "none"
#' )
#' }
#'
#' @seealso 
#' \code{\link{personnel_rules}} for the validation rule definition
#' \code{\link{remove_duplicate_contracts}} for handling contract duplicates
#'
#' @importFrom dplyr group_by slice_head slice_tail ungroup filter n
#' @export
remove_duplicate_personnel <- function(data, keep = c("first", "last", "none")) {
  keep <- match.arg(keep)
  
  # Group by uniqueness constraint: personnel_id + ref_date
  data_grouped <- data |>
    dplyr::group_by(.data[["personnel_id"]], .data[["ref_date"]])
  
  # Apply deduplication strategy
  if (keep == "first") {
    # Keep earliest record per group (by row order)
    data_grouped |>
      dplyr::slice_head(n = 1) |>
      dplyr::ungroup()
      
  } else if (keep == "last") {
    # Keep latest record per group (by row order)
    data_grouped |>
      dplyr::slice_tail(n = 1) |>
      dplyr::ungroup()
      
  } else {
    # Remove all records that have duplicates (conservative)
    # Only keeps records where n() == 1 (no duplicates)
    data_grouped |>
      dplyr::filter(dplyr::n() == 1) |>
      dplyr::ungroup()
  }
}

#' Remove Duplicate Contract Records
#'
#' @title Address Violations of Contract Uniqueness Rules
#'
#' @description
#' Addresses violations of `contract_unique_id` and `contract_unique_personnel`
#' rules by removing duplicate contract records. Offers two deduplication levels:
#' contract-level (contract_id + ref_date) or assignment-level (contract_id +
#' personnel_id + ref_date).
#'
#' @param data A data.frame or data.table containing contract records with
#'   columns `contract_id`, `personnel_id`, and `ref_date`.
#' @param level Character, deduplication level:
#'   \itemize{
#'     \item `"contract"`: Remove duplicates based on contract_id + ref_date
#'       (addresses `contract_unique_id` rule)
#'     \item `"assignment"`: Remove duplicates based on contract_id + personnel_id +
#'       ref_date (addresses `contract_unique_personnel` rule)
#'   }
#' @param keep Character, which duplicate to keep: `"first"`, `"last"`, or `"none"`
#'   (see \code{\link{remove_duplicate_personnel}} for details)
#'
#' @return A data.frame with duplicates removed according to specified level and
#'   keep strategy.
#'
#' @details
#' **Deduplication level guidance:**
#' - Use `level = "contract"` when each contract should appear once per period
#'   (most common for payroll records)
#' - Use `level = "assignment"` when multiple personnel can be assigned to the
#'   same contract, but each person-contract pair should be unique per period
#'
#' @examples
#' \dontrun{
#' # Remove duplicate contracts (contract-level)
#' clean_contracts <- remove_duplicate_contracts(
#'   contract_df,
#'   level = "contract",
#'   keep = "first"
#' )
#' 
#' # Remove duplicate assignments (assignment-level)
#' clean_assignments <- remove_duplicate_contracts(
#'   contract_df,
#'   level = "assignment",
#'   keep = "last"
#' )
#' }
#'
#' @seealso 
#' \code{\link{contract_rules}} for the validation rule definitions
#'
#' @importFrom dplyr group_by slice_head slice_tail ungroup filter n
#' @export
remove_duplicate_contracts <- function(data, 
                                       level = c("contract", "assignment"),
                                       keep = c("first", "last", "none")) {
  level <- match.arg(level)
  keep <- match.arg(keep)
  
  # Group by appropriate uniqueness constraint
  if (level == "contract") {
    # Contract-level: contract_id + ref_date
    data_grouped <- data |>
      dplyr::group_by(.data[["contract_id"]], .data[["ref_date"]])
  } else {
    # Assignment-level: contract_id + personnel_id + ref_date
    data_grouped <- data |>
      dplyr::group_by(.data[["contract_id"]], 
                      .data[["personnel_id"]], 
                      .data[["ref_date"]])
  }
  
  # Apply deduplication strategy (same logic as personnel)
  if (keep == "first") {
    data_grouped |>
      dplyr::slice_head(n = 1) |>
      dplyr::ungroup()
  } else if (keep == "last") {
    data_grouped |>
      dplyr::slice_tail(n = 1) |>
      dplyr::ungroup()
  } else {
    data_grouped |>
      dplyr::filter(dplyr::n() == 1) |>
      dplyr::ungroup()
  }
}

# 2. FIX DATE ISSUES ==========================================================

#' Fix Invalid Reference Dates
#'
#' @title Address Violations of Reference Date Validity Rules
#'
#' @description
#' Addresses violations of `personnel_ref_date_valid` and `contract_ref_date_valid`
#' rules by correcting reference dates that fall outside the acceptable range
#' (default: 1900-01-01 to today).
#'
#' @param data A data.frame with a `ref_date` column (Date class).
#' @param min_date Minimum valid date (default: 1900-01-01). Dates before this
#'   are considered invalid.
#' @param max_date Maximum valid date (default: today via \code{Sys.Date()}).
#'   Future dates are considered invalid.
#' @param action Character, correction strategy:
#'   \itemize{
#'     \item `"na"`: Set invalid dates to NA (preserves record, flags missing data)
#'     \item `"clamp"`: Set dates below min to min_date, dates above max to max_date
#'       (assumes typos in year entry)
#'   }
#'
#' @return A data.frame with corrected `ref_date` values.
#'
#' @details
#' **Why dates are invalid:** Data entry errors (typos in year), system date bugs,
#' or date parsing issues during data imports.
#' 
#' **Action guidance:**
#' - Use `action = "na"` when you want to preserve records but flag date issues
#'   for manual review
#' - Use `action = "clamp"` when you believe most invalid dates are typos
#'   (e.g., 2203 instead of 2023) and the min/max bounds represent the true intent
#'
#' @examples
#' \dontrun{
#' # Set invalid dates to NA
#' clean_data <- fix_invalid_dates(
#'   personnel_df,
#'   action = "na"
#' )
#' 
#' # Clamp dates to valid range
#' clean_data <- fix_invalid_dates(
#'   contract_df,
#'   min_date = as.Date("2000-01-01"),
#'   action = "clamp"
#' )
#' }
#'
#' @seealso 
#' \code{\link{fix_invalid_birthdates}} for birth date correction
#'
#' @importFrom dplyr mutate case_when
#' @export
fix_invalid_dates <- function(data, 
                              min_date = as.Date("1900-01-01"),
                              max_date = Sys.Date(),
                              action = c("na", "clamp")) {
  action <- match.arg(action)
  
  data |>
    dplyr::mutate(
      ref_date = dplyr::case_when(
        # Already NA: keep as NA
        is.na(.data[["ref_date"]]) ~ .data[["ref_date"]],
        
        # Action: set invalid to NA
        action == "na" & (.data[["ref_date"]] < min_date | .data[["ref_date"]] > max_date) ~ as.Date(NA),
        
        # Action: clamp to minimum
        action == "clamp" & .data[["ref_date"]] < min_date ~ min_date,
        
        # Action: clamp to maximum
        action == "clamp" & .data[["ref_date"]] > max_date ~ max_date,
        
        # Valid dates: keep as-is
        TRUE ~ .data[["ref_date"]]
      )
    )
}

#' Fix Invalid Birth Dates
#'
#' @title Address Violations of Birth Date Validity Rule
#'
#' @description
#' Addresses violations of `personnel_birth_date` rule by correcting or removing
#' impossible birth dates (before 1920 or in the future).
#'
#' @param data A data.frame with a `birth_date` column (Date class).
#' @param min_date Minimum valid birth date (default: 1920-01-01). Assumes no
#'   active workers born before this date.
#' @param max_date Maximum valid birth date (default: today). Future birth dates
#'   are impossible.
#' @param action Character, correction strategy: `"na"` or `"clamp"` (see
#'   \code{\link{fix_invalid_dates}} for details).
#'
#' @return A data.frame with corrected `birth_date` values.
#'
#' @details
#' The default `min_date` of 1920-01-01 assumes no workers over ~105 years old
#' are actively employed. Adjust this parameter if your data includes very long
#' tenure or historical records.
#'
#' @examples
#' \dontrun{
#' clean_personnel <- fix_invalid_birthdates(
#'   personnel_df,
#'   action = "na"
#' )
#' }
#'
#' @seealso 
#' \code{\link{personnel_rules}} for the validation rule definition
#'
#' @importFrom dplyr mutate case_when
#' @export
fix_invalid_birthdates <- function(data,
                                   min_date = as.Date("1920-01-01"),
                                   max_date = Sys.Date(),
                                   action = c("na", "clamp")) {
  action <- match.arg(action)
  
  data |>
    dplyr::mutate(
      birth_date = dplyr::case_when(
        is.na(.data[["birth_date"]]) ~ .data[["birth_date"]],
        action == "na" & (.data[["birth_date"]] < min_date | .data[["birth_date"]] > max_date) ~ as.Date(NA),
        action == "clamp" & .data[["birth_date"]] < min_date ~ min_date,
        action == "clamp" & .data[["birth_date"]] > max_date ~ max_date,
        TRUE ~ .data[["birth_date"]]
      )
    )
}

# 3. FIX AGE-RELATED ISSUES ==================================================

#' Flag or Remove Underage Workers
#'
#' @title Address Violations of Minimum Working Age Rule
#'
#' @description
#' Addresses violations of `personnel_minimum_age` rule by identifying workers
#' below the minimum working age (default: 18 years) based on birth_date and
#' ref_date. This is critical for child labor compliance.
#'
#' @param data A data.frame with `birth_date` and `ref_date` columns (Date class).
#' @param min_age Minimum working age in years (default: 18). Adjust based on
#'   local labor laws.
#' @param action Character, handling strategy:
#'   \itemize{
#'     \item `"flag"`: Add `underage_flag` column (TRUE for underage workers)
#'     \item `"filter"`: Remove underage worker records entirely
#'     \item `"adjust_status"`: Set status to "inactive" for underage active workers
#'   }
#'
#' @return A data.frame with underage workers handled according to `action`.
#'   If `action = "flag"`, adds an `underage_flag` column.
#'
#' @details
#' **Age calculation:** Uses the formula 
#' `age = difftime(ref_date, birth_date, units = "days") / 365.25` to account
#' for leap years.
#' 
#' **Action guidance:**
#' - Use `"flag"` for initial data quality assessment (non-destructive)
#' - Use `"filter"` if underage records are definitively errors to be removed
#' - Use `"adjust_status"` if records are valid but status needs correction
#'   (e.g., interns misclassified as active employees)
#'
#' @examples
#' \dontrun{
#' # Flag underage workers for review
#' flagged_data <- fix_underage_workers(
#'   personnel_df,
#'   action = "flag"
#' )
#' 
#' # Adjust status to inactive
#' clean_data <- fix_underage_workers(
#'   personnel_df,
#'   min_age = 16,  # Adjust for jurisdiction
#'   action = "adjust_status"
#' )
#' }
#'
#' @seealso 
#' \code{\link{personnel_rules}} for the validation rule definition
#' \code{\link{fix_retirement_age}} for maximum age handling
#'
#' @importFrom dplyr mutate filter case_when select starts_with
#' @export
fix_underage_workers <- function(data, 
                                 min_age = 18,
                                 action = c("flag", "filter", "adjust_status")) {
  action <- match.arg(action)
  
  # Calculate age and identify underage workers
  # Use temporary columns (prefixed with .) to avoid namespace conflicts
  data <- data |>
    dplyr::mutate(
      .age = as.numeric(difftime(.data[["ref_date"]], 
                                  .data[["birth_date"]], 
                                  units = "days")) / 365.25,
      .underage = .data[[".age"]] < min_age & !is.na(.data[[".age"]])
    )
  
  # Apply correction strategy
  if (action == "flag") {
    # Add flag column, remove temporary columns
    data |>
      dplyr::mutate(underage_flag = .data[[".underage"]]) |>
      dplyr::select(-dplyr::starts_with("."))
      
  } else if (action == "filter") {
    # Remove underage records
    data |>
      dplyr::filter(!.data[[".underage"]]) |>
      dplyr::select(-dplyr::starts_with("."))
      
  } else {
    # Adjust status: set active underage to inactive
    data |>
      dplyr::mutate(
        status = dplyr::case_when(
          .data[[".underage"]] & .data[["status"]] == "active" ~ "inactive",
          TRUE ~ .data[["status"]]
        )
      ) |>
      dplyr::select(-dplyr::starts_with("."))
  }
}

#' Flag or Adjust Over-Retirement-Age Workers
#'
#' @title Address Violations of Maximum Working Age Rule
#'
#' @description
#' Addresses violations of `personnel_maximum_age` rule by handling active
#' workers over the retirement age (default: 65 years).
#'
#' @param data A data.frame with `birth_date`, `ref_date`, and `status` columns.
#' @param max_age Maximum retirement age in years (default: 65). Adjust based on
#'   organizational or national retirement policies.
#' @param action Character, handling strategy:
#'   \itemize{
#'     \item `"flag"`: Add `over_retirement_flag` column (TRUE for active workers
#'       over retirement age)
#'     \item `"adjust_status"`: Set status to "retired" for active workers over
#'       retirement age
#'   }
#'
#' @return A data.frame with over-retirement-age workers handled according to
#'   `action`. If `action = "flag"`, adds an `over_retirement_flag` column.
#'
#' @details
#' This function only targets workers with `status == "active"`. Workers already
#' marked as "retired" or "inactive" are not flagged/adjusted.
#'
#' @examples
#' \dontrun{
#' # Flag active workers over retirement age
#' flagged_data <- fix_retirement_age(
#'   personnel_df,
#'   action = "flag"
#' )
#' 
#' # Auto-adjust status to retired
#' clean_data <- fix_retirement_age(
#'   personnel_df,
#'   max_age = 70,  # Custom retirement age
#'   action = "adjust_status"
#' )
#' }
#'
#' @seealso 
#' \code{\link{personnel_rules}} for the validation rule definition
#'
#' @importFrom dplyr mutate case_when select starts_with
#' @export
fix_retirement_age <- function(data,
                               max_age = 65,
                               action = c("flag", "adjust_status")) {
  action <- match.arg(action)
  
  # Calculate age and identify over-retirement-age active workers
  data <- data |>
    dplyr::mutate(
      .age = as.numeric(difftime(.data[["ref_date"]], 
                                  .data[["birth_date"]], 
                                  units = "days")) / 365.25,
      .over_retirement = .data[["status"]] == "active" & 
                          .data[[".age"]] > max_age & 
                          !is.na(.data[[".age"]])
    )
  
  if (action == "flag") {
    data |>
      dplyr::mutate(over_retirement_flag = .data[[".over_retirement"]]) |>
      dplyr::select(-dplyr::starts_with("."))
  } else {
    # Adjust status to retired
    data |>
      dplyr::mutate(
        status = dplyr::case_when(
          .data[[".over_retirement"]] ~ "retired",
          TRUE ~ .data[["status"]]
        )
      ) |>
      dplyr::select(-dplyr::starts_with("."))
  }
}

# 4. FIX WORKING HOURS ISSUES ================================================

#' Fix Invalid Working Hours
#'
#' @title Address Violations of Working Hours Range Rule
#'
#' @description
#' Addresses violations of `contract_whours` rule by correcting working hours
#' outside the valid range (0-168 hours per week).
#'
#' @param data A data.frame with a `whours` column (numeric).
#' @param action Character, correction strategy:
#'   \itemize{
#'     \item `"na"`: Set invalid hours to NA
#'     \item `"clamp"`: Set negative hours to 0, hours >168 to 168
#'     \item `"flag"`: Add `invalid_hours_flag` column
#'   }
#'
#' @return A data.frame with corrected working hours. If `action = "flag"`,
#'   adds an `invalid_hours_flag` column.
#'
#' @details
#' **Valid range rationale:** Maximum of 168 hours per week (7 days × 24 hours).
#' Negative hours or hours exceeding this are impossible.
#' 
#' **Action guidance:**
#' - Use `"na"` when invalid hours indicate missing/corrupted data
#' - Use `"clamp"` when values slightly outside range are likely data entry errors
#' - Use `"flag"` for initial assessment or when manual review is needed
#'
#' @examples
#' \dontrun{
#' # Clamp working hours to valid range
#' clean_contracts <- fix_working_hours(
#'   contract_df,
#'   action = "clamp"
#' )
#' }
#'
#' @seealso 
#' \code{\link{contract_rules}} for the validation rule definition
#'
#' @importFrom dplyr mutate case_when
#' @export
fix_working_hours <- function(data, action = c("na", "clamp", "flag")) {
  action <- match.arg(action)
  
  if (action == "flag") {
    # Flag invalid hours (outside 0-168 or NA)
    data |>
      dplyr::mutate(
        invalid_hours_flag = .data[["whours"]] < 0 | 
                             .data[["whours"]] > 168 | 
                             is.na(.data[["whours"]])
      )
      
  } else if (action == "na") {
    # Set invalid hours to NA
    data |>
      dplyr::mutate(
        whours = dplyr::case_when(
          .data[["whours"]] < 0 | .data[["whours"]] > 168 ~ NA_real_,
          TRUE ~ .data[["whours"]]
        )
      )
      
  } else {
    # Clamp to valid range [0, 168]
    data |>
      dplyr::mutate(
        whours = dplyr::case_when(
          .data[["whours"]] < 0 ~ 0,
          .data[["whours"]] > 168 ~ 168,
          TRUE ~ .data[["whours"]]
        )
      )
  }
}

# 5. FIX WAGE BILL INCONSISTENCIES ===========================================

#' Fix Salary Component Inconsistencies
#'
#' @title Address Violations of Wage Bill Composition Rules
#'
#' @description
#' Addresses violations of wage bill consistency rules by correcting relationships
#' between salary components (gross, base, net, allowance). Common issues include
#' net exceeding gross, base exceeding gross, or incorrect gross calculation.
#'
#' @param data A data.frame with salary columns: `gross_salary_lcu`, 
#'   `base_salary_lcu`, `net_salary_lcu`, `allowance_lcu`.
#' @param strategy Character, correction strategy:
#'   \itemize{
#'     \item `"recalculate_gross"`: Set gross = base + allowance (assumes base
#'       and allowance are correct)
#'     \item `"cap_net"`: Set net = min(net, gross) (assumes gross is correct,
#'       net has data entry error)
#'     \item `"cap_base"`: Set base = min(base, gross) (assumes gross is correct,
#'       base has data entry error)
#'     \item `"flag"`: Add violation flag columns without correction
#'   }
#'
#' @return A data.frame with corrected salary components. If `strategy = "flag"`,
#'   adds columns: `gross_composition_flag`, `net_exceeds_gross_flag`,
#'   `base_exceeds_gross_flag`.
#'
#' @details
#' **Salary component relationships (expected):**
#' - Gross = Base + Allowance
#' - Net ≤ Gross (after deductions)
#' - Base ≤ Gross (base cannot exceed total compensation)
#' 
#' **Strategy guidance:**
#' - Use `"recalculate_gross"` when base and allowance are from reliable source
#'   (e.g., payroll system) and gross is calculated field prone to errors
#' - Use `"cap_net"` when deductions are processed correctly but net has typos
#' - Use `"cap_base"` when organizational pay structure ensures base should not
#'   exceed gross
#' - Use `"flag"` for initial assessment before deciding on correction approach
#'
#' @examples
#' \dontrun{
#' # Recalculate gross from components
#' clean_contracts <- fix_salary_components(
#'   contract_df,
#'   strategy = "recalculate_gross"
#' )
#' 
#' # Flag inconsistencies for review
#' flagged_contracts <- fix_salary_components(
#'   contract_df,
#'   strategy = "flag"
#' )
#' }
#'
#' @seealso 
#' \code{\link{contract_rules}} for wage bill validation rules
#' \code{\link{fix_negative_salaries}} for handling negative values
#'
#' @importFrom dplyr mutate case_when if_else
#' @export
fix_salary_components <- function(data, 
                                  strategy = c("recalculate_gross", 
                                             "cap_net", 
                                             "cap_base",
                                             "flag")) {
  strategy <- match.arg(strategy)
  
  if (strategy == "recalculate_gross") {
    # Recalculate gross = base + allowance (treating NA allowance as 0)
    data |>
      dplyr::mutate(
        gross_salary_lcu = .data[["base_salary_lcu"]] + 
          dplyr::if_else(
            is.na(.data[["allowance_lcu"]]), 
            0, 
            .data[["allowance_lcu"]]
          )
      )
      
  } else if (strategy == "cap_net") {
    # Cap net salary at gross (net cannot exceed gross)
    data |>
      dplyr::mutate(
        net_salary_lcu = dplyr::case_when(
          .data[["net_salary_lcu"]] > .data[["gross_salary_lcu"]] ~ .data[["gross_salary_lcu"]],
          TRUE ~ .data[["net_salary_lcu"]]
        )
      )
      
  } else if (strategy == "cap_base") {
    # Cap base salary at gross (base cannot exceed gross)
    data |>
      dplyr::mutate(
        base_salary_lcu = dplyr::case_when(
          .data[["base_salary_lcu"]] > .data[["gross_salary_lcu"]] ~ .data[["gross_salary_lcu"]],
          TRUE ~ .data[["base_salary_lcu"]]
        )
      )
      
  } else {
    # Flag violations without correction
    data |>
      dplyr::mutate(
        gross_composition_flag = .data[["gross_salary_lcu"]] < 
          (.data[["base_salary_lcu"]] + dplyr::if_else(is.na(.data[["allowance_lcu"]]), 0, .data[["allowance_lcu"]])),
        net_exceeds_gross_flag = .data[["net_salary_lcu"]] > .data[["gross_salary_lcu"]],
        base_exceeds_gross_flag = .data[["base_salary_lcu"]] > .data[["gross_salary_lcu"]]
      )
  }
}

#' Fix Negative Salary Values
#'
#' @title Address Violations of Positive Salary Rules
#'
#' @description
#' Addresses violations of positive salary rules (`wagebill_*_positive`) by
#' handling negative salary values, which are mathematically impossible.
#'
#' @param data A data.frame with salary columns.
#' @param columns Character vector of salary column names to fix. Default checks
#'   gross, base, and net salary.
#' @param action Character, correction strategy:
#'   \itemize{
#'     \item `"na"`: Set negative values to NA (treat as missing data)
#'     \item `"abs"`: Take absolute value (assumes sign error in data entry)
#'     \item `"zero"`: Set negative values to 0 (conservative, treats as unpaid)
#'   }
#'
#' @return A data.frame with corrected salary values in specified columns.
#'
#' @details
#' **Why negative salaries occur:** Data entry errors (wrong sign), system bugs
#' during calculations, or incorrect handling of deductions/refunds.
#' 
#' **Action guidance:**
#' - Use `"na"` when negative values indicate corrupted/missing data
#' - Use `"abs"` when you believe the magnitude is correct but sign is wrong
#'   (e.g., -5000 should be 5000)
#' - Use `"zero"` for conservative approach in official reporting (avoids
#'   overestimating wage bill)
#'
#' @examples
#' \dontrun{
#' # Take absolute value of negative salaries
#' clean_contracts <- fix_negative_salaries(
#'   contract_df,
#'   columns = c("gross_salary_lcu", "base_salary_lcu"),
#'   action = "abs"
#' )
#' }
#'
#' @seealso 
#' \code{\link{contract_rules}} for wage bill validation rules
#'
#' @importFrom dplyr mutate across all_of case_when
#' @export
fix_negative_salaries <- function(data,
                                  columns = c("gross_salary_lcu", 
                                            "base_salary_lcu", 
                                            "net_salary_lcu"),
                                  action = c("na", "abs", "zero")) {
  action <- match.arg(action)
  
  # Apply correction across all specified salary columns
  data |>
    dplyr::mutate(
      dplyr::across(
        dplyr::all_of(columns),
        ~ dplyr::case_when(
          action == "na" & . < 0 ~ NA_real_,
          action == "abs" & . < 0 ~ abs(.),
          action == "zero" & . < 0 ~ 0,
          TRUE ~ .
        )
      )
    )
}

# 6. MASTER CLEANING FUNCTION ================================================

#' Apply Standard Data Cleaning Pipeline
#'
#' @title Master Function for HR Data Quality Treatment
#'
#' @description
#' Applies a comprehensive suite of cleaning functions to address common validation
#' violations in HR data. This convenience function chains multiple cleaning steps
#' in a recommended order, with options to enable/disable specific treatments.
#'
#' @param data A data.frame containing personnel or contract records.
#' @param data_type Character, type of data: `"personnel"` or `"contract"`.
#'   Determines which cleaning functions are applied.
#' @param remove_duplicates Logical, remove duplicate records? (default: TRUE)
#' @param fix_dates Logical, fix invalid dates? (default: TRUE)
#' @param fix_ages Logical, fix age-related issues? (default: TRUE, personnel only)
#' @param fix_salaries Logical, fix salary inconsistencies? (default: TRUE, contract only)
#' @param verbose Logical, print cleaning summary messages? (default: FALSE)
#'
#' @return A cleaned data.frame with violations addressed according to enabled
#'   options and default correction strategies.
#'
#' @details
#' **Cleaning pipeline order:**
#' 1. Remove duplicates (personnel: by personnel_id+ref_date, contract: by contract_id+ref_date)
#' 2. Fix invalid dates (ref_date, birth_date)
#' 3. Fix age issues (personnel: underage → inactive, over-retirement → retired)
#' 4. Fix salary issues (contract: clamp hours, abs(negative salaries), recalculate gross)
#' 
#' **Default strategies:**
#' - Duplicates: Keep first occurrence
#' - Invalid dates: Set to NA
#' - Underage workers: Adjust status to inactive
#' - Over-retirement workers: Adjust status to retired
#' - Working hours: Clamp to [0, 168]
#' - Negative salaries: Take absolute value
#' - Gross salary: Recalculate from base + allowance
#' 
#' **When to use this function:**
#' - Initial data cleaning before analysis
#' - Automated ETL pipelines with standard quality rules
#' - Batch processing of multiple datasets
#' 
#' **When NOT to use this function:**
#' - When you need custom correction strategies (use individual functions instead)
#' - When you want to flag issues without automatic correction
#' - When manual review of violations is required before correction
#'
#' @examples
#' \dontrun{
#' # Clean personnel data with verbose output
#' clean_personnel <- clean_hr_data(
#'   personnel_df,
#'   data_type = "personnel",
#'   verbose = TRUE
#' )
#' 
#' # Clean contract data, skip salary fixes
#' clean_contracts <- clean_hr_data(
#'   contract_df,
#'   data_type = "contract",
#'   fix_salaries = FALSE
#' )
#' 
#' # Custom pipeline using individual functions
#' custom_clean <- contract_df |>
#'   remove_duplicate_contracts(level = "assignment", keep = "last") |>
#'   fix_invalid_dates(action = "clamp") |>
#'   fix_working_hours(action = "na") |>
#'   fix_salary_components(strategy = "cap_net")
#' }
#'
#' @seealso 
#' Individual treatment functions:
#' \code{\link{remove_duplicate_personnel}},
#' \code{\link{remove_duplicate_contracts}},
#' \code{\link{fix_invalid_dates}},
#' \code{\link{fix_underage_workers}},
#' \code{\link{fix_retirement_age}},
#' \code{\link{fix_working_hours}},
#' \code{\link{fix_salary_components}},
#' \code{\link{fix_negative_salaries}}
#'
#' @export
clean_hr_data <- function(data,
                         data_type = c("personnel", "contract"),
                         remove_duplicates = TRUE,
                         fix_dates = TRUE,
                         fix_ages = TRUE,
                         fix_salaries = TRUE,
                         verbose = FALSE) {
  
  data_type <- match.arg(data_type)
  n_original <- nrow(data)
  
  if (verbose) message("Starting HR data cleaning pipeline...")
  
  # Step 1: Remove duplicates ------------------------------------------------
  if (remove_duplicates) {
    if (data_type == "personnel") {
      data <- remove_duplicate_personnel(data, keep = "first")
    } else {
      data <- remove_duplicate_contracts(data, level = "contract", keep = "first")
    }
    if (verbose) message("  - Removed ", n_original - nrow(data), " duplicate records")
  }
  
  # Step 2: Fix dates --------------------------------------------------------
  if (fix_dates) {
    data <- fix_invalid_dates(data, action = "na")
    if (data_type == "personnel") {
      data <- fix_invalid_birthdates(data, action = "na")
    }
    if (verbose) message("  - Fixed invalid dates (set out-of-bounds to NA)")
  }
  
  # Step 3: Fix age issues (personnel only) ----------------------------------
  if (fix_ages && data_type == "personnel") {
    data <- fix_underage_workers(data, action = "adjust_status")
    data <- fix_retirement_age(data, action = "adjust_status")
    if (verbose) message("  - Adjusted age-related statuses (underage → inactive, over-retirement → retired)")
  }
  
  # Step 4: Fix salary issues (contract only) --------------------------------
  if (fix_salaries && data_type == "contract") {
    data <- fix_working_hours(data, action = "clamp")
    data <- fix_negative_salaries(data, action = "abs")
    data <- fix_salary_components(data, strategy = "recalculate_gross")
    if (verbose) message("  - Fixed salary inconsistencies (clamped hours, abs(negatives), recalculated gross)")
  }
  
  # Summary ------------------------------------------------------------------
  if (verbose) {
    n_final <- nrow(data)
    message("Cleaning complete. ", n_final, " records retained (",
            n_original - n_final, " removed).")
  }
  
  data
}