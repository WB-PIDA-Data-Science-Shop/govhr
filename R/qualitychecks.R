#' Quality Checks for Harmonized HRMIS Contract Data
#'
#' @param contract_tbl A harmonized HRMIS contract tibble (e.g. contract_alagoas_tbl)
#' @param required_vars A character vector of required variable names (from dictionary)
#'
#' @return A pointblank agent with a battery of test results
#' @export
#'
#' @import dplyr tidyr stringr purrr
#' @importFrom pointblank create_agent col_exists rows_distinct action_levels
#' @importFrom pointblank col_is_character col_is_date col_is_numeric
#' @importFrom pointblank col_vals_between col_vals_lte col_vals_gte
#' @importFrom pointblank col_vals_regex interrogate
#' @importFrom stats quantile
#'

qualitycheck_contractmod <- function(contract_tbl,
                                     required_vars = NULL) {

  # Define default required variables if not passed in
  if (is.null(required_vars)) {
   
    required_vars <- 
      harmonization_dict |> 
      dplyr::filter(Module == "Contract") |> 
      dplyr::pull(VariableID) 


  }

  # # variables in dictionary but missing from harmonization
  # missing_contract_vars <- setdiff(required_vars, colnames(contract_tbl))

  # # variables in harmonization but missing from dictionary
  # missing_dictionary_vars <- setdiff(colnames(contract_tbl), required_vars)

  # # flag whether the sets match
  # vars_match <- length(missing_contract_vars) == 0 && length(missing_dictionary_vars) == 0

  # # convert the differences to printable strings for pointblank output
  # missing_str <- ifelse(length(missing_contract_vars)==0,
  #                       "None",
  #                       paste(missing_contract_vars, collapse = ", "))

  # extra_str <- ifelse(length(missing_dictionary_vars)==0,
  #                     "None",
  #                     paste(missing_dictionary_vars, collapse = ", "))
  
  comp_list <- compare_names_qc(x = required_vars,
                                y = colnames(contract_tbl),
                                output_format = "simple")

  # Coerce salary fields to numeric
  salary_vars <- c("base_salary_lcu", "gross_salary_lcu", "net_salary_lcu")

  contract_tbl <-
    contract_tbl %>%
    mutate(across(all_of(salary_vars), ~ suppressWarnings(as.numeric(.))))

  # Compute IQR bounds for outlier detection
  compute_outlier <- function(x) {

    q1 <- quantile(x, 0.25, na.rm = TRUE)
    q3 <- quantile(x, 0.75, na.rm = TRUE)
    iqr <- q3 - q1
    lower <- q1 - (1.5 * iqr)
    upper <- q3 + (1.5 * iqr)

    ob_obj <- list(lower = lower, upper = upper)

    return(ob_obj)

  }


  bounds_list <- purrr::map(contract_tbl %>%
                             select(all_of(salary_vars)),
                            compute_outlier)

  al <- action_levels(warn_at = 1)

  isco <-
    isco %>%
    dplyr::mutate(across(where(is.character),
                         ~iconv(.x, from = "", to = "UTF-8", sub = "")))

  # Create pointblank agent and run checks
  agent <-
    contract_tbl %>%
    create_agent(label = "QCheck for Contract Module",
                 actions = al) %>%
   # variables inside harmonized data not in the dictionary
  specially(
    fn = function(tbl) TRUE,
    label = paste0("Variables missing from the harmonization: ", comp_list$missing)
    ) %>% 
  
  specially(
    fn = function(tbl) TRUE,
    label = paste0("Variables created but not in dictionary: ", comp_list$extra)
  ) %>%
      rows_distinct(label = "Unique at the contract-year level",
                  columns = vars(contract_id, ref_date)) %>%
    # Type checks
    col_is_character(label = "Character variables are the correct type",
                     vars(contract_id, personnel_id, est_id, country_code,
                          occupation_isconame, occupation_iscocode,
                          occupation_native, occupation_english,
                          country_name)) %>%
    col_is_date(label = "Date variables are the appropriate type",
                vars(ref_date, start_date, end_date)) %>%
    col_is_numeric(label = "Numeric variables are the right class",
                   columns = c(base_salary_lcu,
                               gross_salary_lcu,
                               net_salary_lcu,
                               whours)) %>%
    #### logical salary checks
    col_vals_between(label = "Base salary is within the expected range",
                     base_salary_lcu,
                     left = bounds_list$base_salary_lcu$lower,
                     right = bounds_list$base_salary_lcu$upper) %>%
    col_vals_between(label = "Gross salary is within the expected range",
                     gross_salary_lcu,
                     left = bounds_list$gross_salary_lcu$lower,
                     right = bounds_list$gross_salary_lcu$upper) %>%
    col_vals_between(label = "Net salary is within the expected range",
                     net_salary_lcu,
                     left = bounds_list$net_salary_lcu$lower,
                     right = bounds_list$net_salary_lcu$upper) %>%
    col_vals_lte(label = "Hours worked is less than 60",
                 whours, value = 60) %>%
    col_vals_gte(label = "Hours worked is greater than 0",
                 whours, value = 0) %>%
    # ISO3 country code format
    col_vals_regex(label = "Country Code is the 3 letters",
                   columns = vars(country_code),
                   regex = "^[A-Z]{3}$") %>%
    # check isco names and isco codes are part of the official ISCO classifications
    col_vals_in_set(label = "All `occupation_isconame` values are valid",
                    columns = vars(occupation_isconame),
                    preconditions = ~ . %>% dplyr::filter(!is.na(occupation_isconame)),
                    set = isco$description) %>%
    col_vals_in_set(label = "All `occupation_iscocode` values are valid",
                    columns = vars(occupation_iscocode),
                    preconditions = ~ . %>% dplyr::filter(!is.na(occupation_iscocode)),
                    set = isco$unit) %>%
    interrogate()

  # Return agent and summary

  return(agent)

}

#' Quality Check for Harmonized Establishment Module
#'
#' @param est_tbl A data.frame or tibble containing the harmonized establishment module
#'
#' @return A pointblank agent object
#' @export
#'
#' @import dplyr pointblank countrycode
#' @importFrom stats na.omit
#'
qualitycheck_estmod <- function(est_tbl) {

  required_vars <- c(
    "est_name_native", "est_id", "country_code", "country_name",
    "adm1_name", "adm1_code", "est_parent", "est_child", "est_name_en"
  )

  # Check required columns exist
  missing_vars <- setdiff(required_vars, names(est_tbl))
  if (length(missing_vars) > 0) {
    stop("Missing required variables: ", paste(missing_vars, collapse = ", "))
  }

  al <- action_levels(warn_at = 1)
  # Begin pointblank checks
  agent <-
    est_tbl |>
    create_agent(label = "QCheck for Establishment Module",
                 actions = al) |>
    col_exists(columns = all_of(required_vars),
               label = "All required variables were harmonized") |>
    rows_distinct(columns = vars(est_id),
                  label = "Data is unique at the establishment level") |>
    col_vals_not_null(columns = all_of(required_vars),
                      label = "Column values are not null") |>
    col_is_character(columns = all_of(required_vars),
                     label = "Character variables are properly type set") |>
    col_vals_in_set(columns = vars(country_code),
                    set = unique(na.omit(countrycode::codelist$iso3c)),
                    label = "the country_code variable belongs to the official ISO-3 codes")

  agent <- agent %>% interrogate()

  return(agent)
}

#' Quality checks for Personnel Module data
#'
#' This function runs a set of data quality checks on a personnel dataset
#' using the \pkg{pointblank} framework. It verifies that all required
#' columns are present, personnel IDs are unique, and that values are valid
#' and within expected ranges.
#'
#' @param personnel_tbl A data frame or tibble containing personnel module data.
#'   Must include the following columns:
#'   \itemize{
#'     \item \code{ref_date} – Reference date
#'     \item \code{personnel_id} – Unique personnel identifier
#'     \item \code{birth_date} – Date of birth
#'     \item \code{gender} – Gender
#'     \item \code{educat7} – Education (7-category classification)
#'     \item \code{tribe} – Tribe
#'     \item \code{race} – Race
#'     \item \code{status} – Employment or marital status
#'   }
#'
#' @return A \code{pointblank_agent} object with the results of the
#'   quality checks, after interrogation.
#'
#' @details
#' The following checks are performed:
#' \enumerate{
#'   \item All required columns exist in the input data.
#'   \item \code{personnel_id} is unique for each \code{ref_date}.
#'   \item Required columns are not missing.
#'   \item \code{birth_date} falls between 1900-01-01 and 2000-01-01.
#' }
#'
#' The checks use \pkg{pointblank} validation steps and produce warnings
#' when violations are found.
#'
#' @importFrom lubridate as_date
#' @importFrom pointblank action_levels create_agent col_exists
#'   rows_distinct col_vals_not_null col_vals_between interrogate
#'
#' @examples
#' \dontrun{
#' library(dplyr)
#' test_tbl <- tibble::tibble(
#'   ref_date = as.Date("2020-01-01") + 0:2,
#'   personnel_id = 1:3,
#'   birth_date = as.Date(c("1980-01-01", "1990-01-01", "1975-01-01")),
#'   gender = c("M", "F", "M"),
#'   educat7 = c("Primary", "Secondary", "Tertiary"),
#'   tribe = c("A", "B", "C"),
#'   race = c("X", "Y", "Z"),
#'   status = c("Employed", "Unemployed", "Employed")
#' )
#'
#' qualitycheck_personnel(test_tbl)
#' }
#'
#' @export

qualitycheck_personnel <- function(personnel_tbl){

  required_vars <- c(
    "ref_date", "personnel_id", "birth_date", "gender", "educat7", "tribe",
    "race", "status"
  )

  al <- action_levels(warn_at = 1)

  agent <-
    personnel_tbl |>
    create_agent(
      label = "Quality check for Personnel Module",
      actions = al
    ) |>
    col_exists(
      label = "All required columns are present",
      columns = vars(!!!syms(required_vars))
    ) |>
    rows_distinct(
      label = "Personnel ID is unique.",
      columns = c(personnel_id, ref_date),
    ) |>
    col_vals_not_null(
      label = "Values are not missing.",
      columns = vars(!!!syms(required_vars))
    ) |>
    col_vals_between(
      "Date of birth is valid",
      columns = vars(birth_date),
      as_date("1900-01-01"), as_date("2000-01-01")
    )

  agent %>% interrogate()
}


#' Compute Missingness Summary
#'
#' @description
#' Computes variable-level, row-level, grouped, and structural missingness
#' summaries using data.table for high performance. Designed for admin data
#' modules such as contracts, personnel, and establishments.
#'
#' @param dt A data.table containing the module data.
#' @param by Optional character vector of grouping variables (e.g. "ministry").
#' @param structural_rules Optional data.table with columns:
#'   \itemize{
#'     \item variable – character variable name in dt
#'     \item condition – an expression as a string (e.g. "status == 'active'")
#'     \item expected_missing – TRUE/FALSE indicating whether missing is allowed
#'   }
#'
#' @return A list with:
#' \describe{
#'   \item{var_missing}{Variable-level missing count and percentage}
#'   \item{row_missing}{Row-level missing count and percentage}
#'   \item{group_missing}{Grouped missingness summary (if by supplied)}
#'   \item{structural_missing}{Check of expected vs unexpected missingness (if rules supplied)}
#' }
#' @export
#'
compute_missingness <- function(dt,
                                by = NULL,
                                structural_rules = NULL) {

  stopifnot(is.data.table(dt))

  # ---------------------------
  # Variable-level missingness
  # ---------------------------
  var_missing <- dt[, lapply(.SD, function(x) sum(is.na(x))), .SDcols = names(dt)]
  var_missing <- melt(var_missing, measure.vars = names(var_missing),
                      variable.name = "variable",
                      value.name = "n_missing")

  var_missing[, pct_missing := n_missing / nrow(dt)]

  # # ---------------------------
  # # Row-level missingness
  # # ---------------------------
  # row_missing <- dt[, {
  #   n_miss <- rowSums(is.na(.SD))
  #   list(
  #     n_missing = n_miss,
  #     pct_missing = n_miss / ncol(.SD)
  #   )
  # }]

  # ---------------------------
  # Group-level missingness (optional)
  # ---------------------------
  if (!is.null(by)) {
    stopifnot(all(by %in% names(dt)))

    group_missing <- dt[, lapply(.SD, function(x) sum(is.na(x))), 
                        by = by,
                        .SDcols = names(dt)]
    group_missing <- melt(group_missing,
                          id.vars = by,
                          variable.name = "variable",
                          value.name = "n_missing")
    group_missing[, pct_missing := n_missing / dt[, .N, by][, N]]
  } else {
    group_missing <- NULL
  }

  # ---------------------------
  # Structural Missingness (optional)
  # ---------------------------
  if (!is.null(structural_rules)) {
    stopifnot(is.data.table(structural_rules))
    stopifnot(all(c("variable", "condition", "expected_missing") %in% names(structural_rules)))

    structural_list <- list()

    for (i in seq_len(nrow(structural_rules))) {
      v <- structural_rules$variable[i]
      cond <- structural_rules$condition[i]
      exp_miss <- structural_rules$expected_missing[i]

      # Evaluate condition inside dt
      dt[, cond_eval := eval(parse(text = cond))]

      structural_dt <- dt[, .(
        n_missing = sum(is.na(get(v)) & cond_eval),
        n_unexpected_missing = sum(is.na(get(v)) & cond_eval & !exp_miss),
        n_expected_missing = sum(is.na(get(v)) & cond_eval & exp_miss)
      )][, variable := v]

      structural_list[[i]] <- structural_dt
      dt[, cond_eval := NULL]
    }

    structural_missing <- rbindlist(structural_list, fill = TRUE)
  } else {
    structural_missing <- NULL
  }

  # ---------------------------
  # Return list
  # ---------------------------
  return(list(
    var_missing = var_missing,
    # row_missing = row_missing,
    group_missing = group_missing,
    structural_missing = structural_missing
  ))
}
