
# Make sure data.table knows we know we're using it
#' @noRd
.datatable.aware = TRUE


if (getRversion() >= "2.15.1"){

  utils::globalVariables(c(
    "contract_id", "est_date", "personnel_id", "est_id", "country_code",
    "start_date", "end_date", "base_salary_lcu", "gross_salary_lcu",
    "net_salary_lcu", "whours", "cpi", "year", "ppp", "ppp_2017",
    "REF_AREA", "TIME_PERIOD", "OBS_VALUE", "INDICATOR", "n_records",
    "ref_date", "birth_date", "na.omit", "multisession", "plan",
    "ppp_2021", "occupation_isconame", "occupation_iscocode",
    "occupation_native", "occupation_english", "country_name",
    "govcount", "indicator", "isco", "isco_share", "macro_indicators",
    "macro_value", "macro_var", "num_teachers", "total", "totals",
    "ts_ratio", "value", "wage_value", "wage_var", ".", "sd",
    "summary_value", "summary_var", ".groups", ":=", "val", "N",
    "allowance_ind", "allowance_lcu", "allowshare", "gender", "educat7",
    "paygrade", "seniority", "from", "est_to", "paygrade", "seniority",
    "Module", "VariableID", "dictionary", "..groups", "n_missing",
    "pct_missing", ".contrib", ".e", ".eff_end", ".lag_max_e", ".pid",
    ".s", "current_stock", "exit_rate", "from_group", "from_period", 
    "movement_rate", "n_exits", "n_moves", "n_pop", "period_key",
    "period_prob", "t0_date", "tenure_days", "tenure_years", "to_group", 
    "to_period", ".grp_base", ".ind_base", "group_val", "group_var",
    "stat_type", "variable_id", "variable_name", "vol_fn", ".row_id",
    "group_label", "target_label", "target_var", "module", "variable",
    "name", "items", "passes", "fails", "error", "label_clean", "class_label",
    "tf", "idf", "df", "tfidf", "text", "class_id", "score", "head", "tfidf_c",
    "tfidf_t", "dot", "norm_c", "norm_t", "id", "employment_status", "..active_cols",
    "..active_cols", "last_salary", "max_date", "mean_salary_change",
    "mean_salary_pct_change", "mean_salary_t0", "mean_salary_t1",
    "median_salary_change", "replacement_rate", "salary_change", "salary_pct_change",
    "spell_years"

  ))

}


#' Validate Column Exists in Data Table
#'
#' @param dt data.table to check
#' @param colname Character. Column name to validate
#' @param varname Character. Variable name for error messages
#'
#' @return Invisible TRUE if valid, stops with error otherwise
#' @keywords internal
validate_column_exists <- function(dt, colname, varname) {
  if (!colname %in% names(dt)) {
    stop(
      "Column '", colname, "' not found in ", varname,
      call. = FALSE
    )
  }
  
  return(invisible(TRUE))
}

#' Validate Multiple Columns Exist
#'
#' @param dt data.table to check
#' @param colnames Character vector. Column names to validate
#' @param varname Character. Variable name for error messages
#'
#' @return Invisible TRUE if valid, stops with error otherwise
#' @keywords internal
validate_columns_exist <- function(dt, colnames, varname) {
  missing_cols <- setdiff(colnames, names(dt))
  
  if (length(missing_cols) > 0) {
    stop(
      "Columns not found in ", varname, ": ",
      paste(missing_cols, collapse = ", "),
      call. = FALSE
    )
  }
  
  return(invisible(TRUE))
}

#' Validate Date Format
#'
#' @param date Object to validate
#' @param varname Character. Variable name for error messages
#'
#' @return Invisible TRUE if valid, stops with error otherwise
#' @keywords internal
validate_date_format <- function(date, varname) {
  # Accept both Date objects and character strings
  if (is.character(date)) {
    tryCatch({
      date <- as.Date(date)
    }, error = function(e) {
      stop(varname, " must be a valid date string (e.g., '2024-01-01') or Date object. ",
           "Error: ", e$message, call. = FALSE)
    })
  }
  
  if (!inherits(date, "Date")) {
    stop(varname, " must be a Date object or date string (e.g., '2024-01-01')", call. = FALSE)
  }
  
  if (length(date) != 1) {
    stop(varname, " must be a single Date value", call. = FALSE)
  }
  
  if (is.na(date)) {
    stop(varname, " cannot be NA", call. = FALSE)
  }
  
  return(date)
}