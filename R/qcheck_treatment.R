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
# - Explicit over implicit: Functions require user to choose type of treatment.
# - Non-destructive by default: Prefer flagging over automatic deletion
# - Composable: Functions can be chained in a cleaning pipeline
# - Auditable: Master function (clean_hr_data) provides verbose logging
# ==============================================================================

# 1. HANDLE DUPLICATE RECORDS ================================================

#' Remove Duplicate Personnel Records
#'
#' @description
#' Removes duplicate `personnel_id` + `ref_date` combinations, addressing
#' violations of the `personnel_unique_id` rule.
#'
#' @param data A data.frame with columns `personnel_id` and `ref_date`.
#' @param keep Which record to keep per duplicate group: `"first"` (default),
#'   `"last"`, or `"none"` (drops all records in a duplicate group).
#'
#' @return A data.frame with duplicates removed.
#'
#' @examples
#' \dontrun{
#' remove_duplicate_personnel(personnel_df, keep = "first")
#' remove_duplicate_personnel(personnel_df, keep = "none")
#' }
#'
#' @seealso \code{\link{personnel_rules}}, \code{\link{remove_duplicate_contracts}}
#' @importFrom dplyr group_by slice_head slice_tail ungroup filter n
#' @export
remove_duplicate_personnel <- function(
  data,
  keep = c("first", "last", "none")
) {
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
#' @description
#' Removes duplicate contract records, addressing violations of `contract_unique_id`
#' (contract-level) and `contract_unique_personnel` (assignment-level) rules.
#'
#' @param data A data.frame with columns `contract_id`, `personnel_id`, and `ref_date`.
#' @param level Deduplication scope:
#'   \itemize{
#'     \item `"contract"`: Deduplicate on `contract_id` + `ref_date`
#'     \item `"assignment"`: Deduplicate on `contract_id` + `personnel_id` + `ref_date`
#'   }
#' @param keep Which record to keep: `"first"`, `"last"`, or `"none"`.
#'   See \code{\link{remove_duplicate_personnel}}.
#'
#' @return A data.frame with duplicates removed.
#'
#' @examples
#' \dontrun{
#' remove_duplicate_contracts(contract_df, level = "contract", keep = "first")
#' remove_duplicate_contracts(contract_df, level = "assignment", keep = "last")
#' }
#'
#' @seealso \code{\link{contract_rules}}, \code{\link{remove_duplicate_personnel}}
#' @importFrom dplyr group_by slice_head slice_tail ungroup filter n
#' @export
remove_duplicate_contracts <- function(
  data,
  level = c("contract", "assignment"),
  keep = c("first", "last", "none")
) {
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
      dplyr::group_by(
        .data[["contract_id"]],
        .data[["personnel_id"]],
        .data[["ref_date"]]
      )
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
#' @description
#' Corrects `ref_date` values outside the valid range, addressing violations of
#' `personnel_ref_date_valid` and `contract_ref_date_valid` rules.
#'
#' @param data A data.frame with a `ref_date` column (Date class).
#' @param min_date Minimum valid date (default: `1900-01-01`).
#' @param max_date Maximum valid date (default: `Sys.Date()`).
#' @param treatment Correction strategy:
#'   \itemize{
#'     \item `"na"`: Set invalid dates to `NA`
#'     \item `"clamp"`: Replace out-of-range dates with `min_date` or `max_date`
#'     \item `"filter"`: Remove records with invalid dates
#'   }
#'
#' @return A data.frame with corrected `ref_date` values.
#'
#' @examples
#' \dontrun{
#' fix_invalid_dates(personnel_df, treatment = "na")
#' fix_invalid_dates(contract_df, min_date = as.Date("2000-01-01"), treatment = "clamp")
#' }
#'
#' @seealso \code{\link{fix_invalid_birthdates}}
#' @importFrom dplyr mutate case_when filter
#' @export
fix_invalid_dates <- function(
  data,
  min_date = as.Date("1900-01-01"),
  max_date = Sys.Date(),
  treatment = c("na", "clamp", "filter")
) {
  treatment <- match.arg(treatment)

  if (treatment == "filter") {
    # Remove records with invalid dates
    data |>
      dplyr::filter(
        !is.na(.data[["ref_date"]]) &
          .data[["ref_date"]] >= min_date &
          .data[["ref_date"]] <= max_date
      )
  } else {
    data |>
      dplyr::mutate(
        ref_date = dplyr::case_when(
          # Already NA: keep as NA
          is.na(.data[["ref_date"]]) ~ .data[["ref_date"]],

          # Treatment: set invalid to NA
          treatment == "na" &
            (.data[["ref_date"]] < min_date |
              .data[["ref_date"]] > max_date) ~ as.Date(NA),

          # Treatment: clamp to minimum
          treatment == "clamp" & .data[["ref_date"]] < min_date ~ min_date,

          # Treatment: clamp to maximum
          treatment == "clamp" & .data[["ref_date"]] > max_date ~ max_date,

          # Valid dates: keep as-is
          TRUE ~ .data[["ref_date"]]
        )
      )
  }
}

#' Fix Invalid Birth Dates
#'
#' @description
#' Corrects `birth_date` values outside the valid range, addressing violations
#' of the `personnel_birth_date` rule. Defaults assume no active worker was born
#' before 1920 or in the future.
#'
#' @param data A data.frame with a `birth_date` column (Date class).
#' @param min_date Minimum valid birth date (default: `1920-01-01`).
#' @param max_date Maximum valid birth date (default: `Sys.Date()`).
#' @param treatment Correction strategy: `"na"`, `"clamp"`, or `"filter"`.
#'   See \code{\link{fix_invalid_dates}}.
#'
#' @return A data.frame with corrected `birth_date` values.
#'
#' @examples
#' \dontrun{
#' fix_invalid_birthdates(personnel_df, treatment = "na")
#' }
#'
#' @seealso \code{\link{personnel_rules}}, \code{\link{fix_invalid_dates}}
#' @importFrom dplyr mutate case_when filter
#' @importFrom lubridate years
#' @export
fix_invalid_birthdates <- function(
  data,
  min_date = as.Date("1920-01-01"),
  max_date = Sys.Date(),
  treatment = c("na", "clamp", "filter")
) {
  treatment <- match.arg(treatment)

  if (treatment == "filter") {
    # Remove records with invalid birth dates
    data |>
      dplyr::filter(
        !is.na(.data[["birth_date"]]) &
          .data[["birth_date"]] >= min_date &
          .data[["birth_date"]] <= max_date
      )
  } else {
    data |>
      dplyr::mutate(
        birth_date = dplyr::case_when(
          is.na(.data[["birth_date"]]) ~ .data[["birth_date"]],
          treatment == "na" &
            (.data[["birth_date"]] < min_date |
              .data[["birth_date"]] > max_date) ~ as.Date(NA),
          treatment == "clamp" & .data[["birth_date"]] < min_date ~ min_date,
          treatment == "clamp" & .data[["birth_date"]] > max_date ~ max_date,
          TRUE ~ .data[["birth_date"]]
        )
      )
  }
}

# 3. FIX AGE-RELATED ISSUES ==================================================

#' Flag or Remove Underage Workers
#'
#' @description
#' Addresses violations of the `personnel_minimum_age` rule. Workers below
#' `min_age` (default: 18) are identified using `birth_date` and `ref_date`.
#' Age is calculated as `difftime(ref_date, birth_date, units = "days") / 365.25`.
#'
#' @param data A data.frame with `birth_date` and `ref_date` columns (Date class).
#' @param min_age Minimum working age in years (default: 18).
#' @param treatment Handling strategy:
#'   \itemize{
#'     \item `"flag"`: Add `underage_flag` column (TRUE for underage workers)
#'     \item `"filter"`: Remove underage worker records
#'   }
#'
#' @return A data.frame with underage workers handled according to `treatment`.
#'
#' @examples
#' \dontrun{
#' fix_underage_workers(personnel_df, treatment = "flag")
#' fix_underage_workers(personnel_df, min_age = 16, treatment = "filter")
#' }
#'
#' @seealso \code{\link{personnel_rules}}, \code{\link{fix_retirement_age}}
#' @importFrom dplyr mutate filter case_when select starts_with
#' @export
fix_underage_workers <- function(
  data,
  min_age = 18,
  treatment = c("flag", "filter")
) {
  treatment <- match.arg(treatment)

  # Calculate age and identify underage workers
  # Use temporary columns (prefixed with .) to avoid namespace conflicts
  data <- data |>
    dplyr::mutate(
      .age = as.numeric(difftime(
        .data[["ref_date"]],
        .data[["birth_date"]],
        units = "days"
      )) /
        365.25,
      .underage = .data[[".age"]] < min_age & !is.na(.data[[".age"]])
    )

  # Apply correction strategy
  if (treatment == "flag") {
    # Add flag column, remove temporary columns
    data |>
      dplyr::mutate(underage_flag = .data[[".underage"]]) |>
      dplyr::select(
        -all_of(c(".age", ".underage"))
      )
  } else if (treatment == "filter") {
    # Remove underage records
    data |>
      dplyr::filter(!.data[[".underage"]]) |>
      dplyr::select(
        -all_of(c(".age", ".underage"))
      )
  }
}

#' Flag or Adjust Over-Retirement-Age Workers
#'
#' @description
#' Addresses violations of the `personnel_maximum_age` rule. Only targets
#' workers with `status == "active"`; retired or inactive workers are ignored.
#'
#' @param data A data.frame with `birth_date`, `ref_date`, and `status` columns.
#' @param max_age Retirement age threshold in years (default: 65).
#' @param treatment Handling strategy:
#'   \itemize{
#'     \item `"flag"`: Add `over_retirement_flag` column
#'     \item `"adjust_status"`: Set `status` to `"retired"` for affected workers
#'   }
#'
#' @return A data.frame with over-retirement-age workers handled according to
#'   `treatment`.
#'
#' @examples
#' \dontrun{
#' fix_retirement_age(personnel_df, treatment = "flag")
#' fix_retirement_age(personnel_df, max_age = 70, treatment = "adjust_status")
#' }
#'
#' @seealso \code{\link{personnel_rules}}, \code{\link{fix_underage_workers}}
#' @importFrom dplyr mutate case_when select starts_with
#' @export
fix_retirement_age <- function(
  data,
  max_age = 65,
  treatment = c("flag", "adjust_status")
) {
  treatment <- match.arg(treatment)

  # Calculate age and identify over-retirement-age active workers
  data <- data |>
    dplyr::mutate(
      .age = as.numeric(difftime(
        .data[["ref_date"]],
        .data[["birth_date"]],
        units = "days"
      )) /
        365.25,
      .over_retirement = .data[["status"]] == "active" &
        .data[[".age"]] > max_age &
        !is.na(.data[[".age"]])
    )

  if (treatment == "flag") {
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
#' @description
#' Corrects `whours` values outside the valid range [0, 168], addressing
#' violations of the `contract_whours` rule. The maximum of 168 reflects
#' 5 days × 8 hours per week.
#'
#' @param data A data.frame with a `whours` column (numeric).
#' @param treatment Correction strategy:
#'   \itemize{
#'     \item `"na"`: Set invalid hours to `NA`
#'     \item `"clamp"`: Clamp to `[0, 40]`
#'     \item `"flag"`: Add `invalid_hours_flag` column (also flags `NA`)
#'   }
#'
#' @return A data.frame with corrected working hours.
#'
#' @examples
#' \dontrun{
#' fix_working_hours(contract_df, treatment = "clamp")
#' }
#'
#' @seealso \code{\link{contract_rules}}
#' @importFrom dplyr mutate case_when
#' @export
fix_working_hours <- function(data, treatment = c("na", "clamp", "flag")) {
  treatment <- match.arg(treatment)

  if (treatment == "flag") {
    # Flag invalid hours (outside 0-40 or NA)
    data |>
      dplyr::mutate(
        invalid_hours_flag = .data[["whours"]] < 0 |
          .data[["whours"]] > 40 |
          is.na(.data[["whours"]])
      )
  } else if (treatment == "na") {
    # Set invalid hours to NA
    data |>
      dplyr::mutate(
        whours = dplyr::case_when(
          .data[["whours"]] < 0 | .data[["whours"]] > 40 ~ NA_real_,
          TRUE ~ .data[["whours"]]
        )
      )
  } else {
    # Clamp to valid range [0, 40]
    data |>
      dplyr::mutate(
        whours = dplyr::case_when(
          .data[["whours"]] < 0 ~ 0,
          .data[["whours"]] > 40 ~ 40,
          TRUE ~ .data[["whours"]]
        )
      )
  }
}

# 5. FIX WAGE BILL INCONSISTENCIES ===========================================

#' Fix Salary Component Inconsistencies
#'
#' @description
#' Corrects violations of wage bill consistency rules: gross ≥ base + allowance,
#' gross ≥ net, gross ≥ base.
#'
#' @param data A data.frame with columns `gross_salary_lcu`, `base_salary_lcu`,
#'   `net_salary_lcu`, `allowance_lcu`.
#' @param strategy Correction strategy:
#'   \itemize{
#'     \item `"recalculate_gross"`: Set `gross = base + allowance`
#'     \item `"cap_net"`: Cap net at gross
#'     \item `"cap_base"`: Cap base at gross
#'     \item `"flag"`: Add flag columns `gross_composition_flag`,
#'       `net_exceeds_gross_flag`, `base_exceeds_gross_flag`
#'   }
#'
#' @return A data.frame with corrected salary components.
#'
#' @examples
#' \dontrun{
#' fix_salary_components(contract_df, strategy = "recalculate_gross")
#' fix_salary_components(contract_df, strategy = "flag")
#' }
#'
#' @seealso \code{\link{contract_rules}}, \code{\link{fix_negative_salaries}}
#' @importFrom dplyr mutate case_when if_else
#' @export
fix_salary_components <- function(
  data,
  strategy = c("recalculate_gross", "cap_net", "cap_base", "flag")
) {
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
          .data[["net_salary_lcu"]] > .data[["gross_salary_lcu"]] ~ .data[[
            "gross_salary_lcu"
          ]],
          TRUE ~ .data[["net_salary_lcu"]]
        )
      )
  } else if (strategy == "cap_base") {
    # Cap base salary at gross (base cannot exceed gross)
    data |>
      dplyr::mutate(
        base_salary_lcu = dplyr::case_when(
          .data[["base_salary_lcu"]] > .data[["gross_salary_lcu"]] ~ .data[[
            "gross_salary_lcu"
          ]],
          TRUE ~ .data[["base_salary_lcu"]]
        )
      )
  } else {
    # Flag violations without correction
    data |>
      dplyr::mutate(
        gross_composition_flag = .data[["gross_salary_lcu"]] <
          (.data[["base_salary_lcu"]] +
            dplyr::if_else(
              is.na(.data[["allowance_lcu"]]),
              0,
              .data[["allowance_lcu"]]
            )),
        net_exceeds_gross_flag = .data[["net_salary_lcu"]] >
          .data[["gross_salary_lcu"]],
        base_exceeds_gross_flag = .data[["base_salary_lcu"]] >
          .data[["gross_salary_lcu"]]
      )
  }
}

#' Fix Negative Salary Values
#'
#' @description
#' Addresses violations of positive salary rules (`wagebill_*_positive`) by
#' handling negative values across salary columns.
#'
#' @param data A data.frame with salary columns.
#' @param columns Salary columns to fix (default: `gross_salary_lcu`,
#'   `base_salary_lcu`, `net_salary_lcu`).
#' @param treatment Correction strategy:
#'   \itemize{
#'     \item `"na"`: Set negative values to `NA`
#'     \item `"abs"`: Take absolute value
#'     \item `"zero"`: Set negative values to `0`
#'   }
#'
#' @return A data.frame with corrected salary values in the specified columns.
#'
#' @examples
#' \dontrun{
#' fix_negative_salaries(contract_df, treatment = "abs")
#' fix_negative_salaries(contract_df, columns = "gross_salary_lcu", treatment = "na")
#' }
#'
#' @seealso \code{\link{contract_rules}}, \code{\link{fix_salary_components}}
#' @importFrom dplyr mutate across all_of case_when
#' @export
fix_negative_salaries <- function(
  data,
  columns = c("gross_salary_lcu", "base_salary_lcu", "net_salary_lcu"),
  treatment = c("na", "abs", "zero")
) {
  treatment <- match.arg(treatment)

  # Apply correction across all specified salary columns
  data |>
    dplyr::mutate(
      dplyr::across(
        dplyr::all_of(columns),
        ~ dplyr::case_when(
          treatment == "na" & . < 0 ~ NA_real_,
          treatment == "abs" & . < 0 ~ abs(.),
          treatment == "zero" & . < 0 ~ 0,
          TRUE ~ .
        )
      )
    )
}

# 6. MASTER CLEANING FUNCTION ================================================

#' Apply Standard HR Data Cleaning Pipeline
#'
#' @description
#' Chains the treatment functions in a recommended order. Steps applied per
#' `data_type`:
#' \enumerate{
#'   \item **Both**: Remove duplicates (keep first); fix `ref_date` → `NA`
#'   \item **Personnel**: Fix `birth_date` → `NA`; flag underage and
#'     over-retirement-age workers
#'   \item **Contract**: Clamp `whours`; abs(negative salaries);
#'     recalculate gross = base + allowance
#' }
#' Use individual functions directly when you need custom strategies.
#'
#' @param data A data.frame containing personnel or contract records.
#' @param data_type `"personnel"` or `"contract"`.
#' @param remove_duplicates Logical (default: `TRUE`).
#' @param fix_dates Logical (default: `TRUE`).
#' @param fix_ages Logical, personnel only (default: `TRUE`).
#' @param fix_salaries Logical, contract only (default: `TRUE`).
#' @param verbose Logical, print step-level messages (default: `FALSE`).
#'
#' @return A cleaned data.frame.
#'
#' @examples
#' \dontrun{
#' clean_hr_data(personnel_df, data_type = "personnel", verbose = TRUE)
#' clean_hr_data(contract_df, data_type = "contract", fix_salaries = FALSE)
#'
#' # Custom pipeline
#' contract_df |>
#'   remove_duplicate_contracts(level = "assignment", keep = "last") |>
#'   fix_invalid_dates(treatment = "clamp") |>
#'   fix_working_hours(treatment = "na") |>
#'   fix_salary_components(strategy = "cap_net")
#' }
#'
#' @seealso
#' \code{\link{remove_duplicate_personnel}}, \code{\link{remove_duplicate_contracts}},
#' \code{\link{fix_invalid_dates}}, \code{\link{fix_underage_workers}},
#' \code{\link{fix_retirement_age}}, \code{\link{fix_working_hours}},
#' \code{\link{fix_salary_components}}, \code{\link{fix_negative_salaries}}
#' @export
clean_hr_data <- function(
  data,
  data_type = c("personnel", "contract"),
  remove_duplicates = TRUE,
  fix_dates = TRUE,
  fix_ages = TRUE,
  fix_salaries = TRUE,
  verbose = FALSE
) {
  data_type <- match.arg(data_type)
  n_original <- nrow(data)

  if (verbose) {
    message("Starting HR data cleaning pipeline...")
  }

  # Step 1: Remove duplicates ------------------------------------------------
  if (remove_duplicates) {
    if (data_type == "personnel") {
      data <- remove_duplicate_personnel(data, keep = "first")
    } else {
      data <- remove_duplicate_contracts(
        data,
        level = "contract",
        keep = "first"
      )
    }
    if (verbose) {
      message("  - Removed ", n_original - nrow(data), " duplicate records")
    }
  }

  # Step 2: Fix dates --------------------------------------------------------
  if (fix_dates) {
    data <- fix_invalid_dates(data, treatment = "na")
    if (data_type == "personnel") {
      data <- fix_invalid_birthdates(data, treatment = "na")
    }
    if (verbose) message("  - Fixed invalid dates (set out-of-bounds to NA)")
  }

  # Step 3: Fix age issues (personnel only) ----------------------------------
  if (fix_ages && data_type == "personnel") {
    data <- fix_underage_workers(data, treatment = "flag")
    data <- fix_retirement_age(data, treatment = "flag")
    if (verbose) {
      message("  - Handled age issues (flagged underage and over-retirement)")
    }
  }

  # Step 4: Fix salary issues (contract only) --------------------------------
  if (fix_salaries && data_type == "contract") {
    data <- fix_working_hours(data, treatment = "clamp")
    data <- fix_negative_salaries(data, treatment = "abs")
    data <- fix_salary_components(data, strategy = "recalculate_gross")
    if (verbose) {
      message(
        "  - Fixed salary inconsistencies (clamped hours, abs(negatives), recalculated gross)"
      )
    }
  }

  # Summary ------------------------------------------------------------------
  if (verbose) {
    n_final <- nrow(data)
    message(
      "Cleaning complete. ",
      n_final,
      " records retained (",
      n_original - n_final,
      " removed)."
    )
  }

  data
}
