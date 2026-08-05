#' Compute Fast Summary Statistics by Group
#'
#' `compute_fastsummary()` computes summary statistics for selected columns
#' of a dataset, optionally grouped by one or more variables. It allows
#' the user to specify a set of functions to apply, either from a predefined
#' set or custom formulas/functions.
#'
#' @param data A `data.table`, `data.frame`, or tibble. The dataset on which to compute the summaries.
#'   If not a `data.table`, it will be converted internally for computation.
#'   The result will be returned in the same class as the input (unless `tbl = TRUE`).
#' @param cols A character vector. Names of the columns to summarize.
#' @param fns Optional. Either:
#'   \itemize{
#'     \item `NULL` (default): use all default functions defined by
#'       `define_fns()`.
#'     \item A character vector of function names matching `define_fns()`.
#'     \item A list of functions or formulas, possibly mixed with character
#'       names referring to `define_fns()`.
#'   }
#' @param groups A character vector. Column(s) by which to group the data
#'   before computing the summary statistics.
#' @param output Character. Either `"long"` (default) or `"wide"` to specify
#'   the output format. `"long"` returns one row per group per summary
#'   statistic, `"wide"` returns one row per group with multiple columns for
#'   each summary statistic.
#' @param tbl Logical. If `TRUE`, converts the result to a tibble (`tibble::as_tibble()`).
#'
#' @return A dataset containing the summary statistics for the selected columns.
#'   The output will be either long or wide depending on the `output` argument.
#'   The returned object will match the class of the input `data` (unless `tbl = TRUE`).
#'
#' @details
#' The function constructs the summary calls efficiently using `bquote()`
#' and evaluates them within the `data.table` environment. This allows for
#' fast computation even with large datasets. Custom functions can be
#' supplied as formulas (e.g., `~ mean(.x, na.rm = TRUE)`) or as
#' pre-defined function names from `define_fns()`.
#'
#' @examples
#' \dontrun{
#' library(data.table)
#' dt <- data.table(x = rnorm(100), y = rnorm(100), group = sample(1:2, 100, TRUE))
#' # Compute mean and sd by group
#' compute_fastsummary(dt, cols = c("x", "y"), fns = c("mean", "sd"), groups = "group")
#'
#' # Use a custom function
#' compute_fastsummary(
#'   dt,
#'   cols = "x",
#'   fns = list(mean = ~mean(.x, na.rm = TRUE)),
#'   groups = "group",
#'   output = "long",
#'   tbl = TRUE
#' )
#' }
#'
#' @importFrom data.table is.data.table as.data.table melt
#' @importFrom tibble as_tibble
#' @importFrom rlang is_formula as_function
#' @importFrom glue glue
#'
#' @export
compute_fastsummary <- function(data,
                                cols,
                                fns = NULL,
                                groups,
                                output = c("long", "wide"),
                                tbl = FALSE) {

  output <- match.arg(output)
  orig_class <- class(data)
  if (!data.table::is.data.table(data)) data <- data.table::as.data.table(data)

  default_fns <- define_fns()

  # resolve fns -> selected_fns : named list of functions/formulas
  if (is.null(fns)) {
    selected_fns <- default_fns
  } else if (is.character(fns)) {
    unknown <- setdiff(fns, names(default_fns))
    if (length(unknown) > 0) stop(glue::glue("Unknown function name(s): {toString(unknown)}"))
    selected_fns <- default_fns[fns]
  } else if (is.list(fns)) {
    char_fns <- fns[sapply(fns, is.character)]
    formula_fns <- fns[sapply(fns, rlang::is_formula)]
    selected_fns <- c(default_fns[intersect(unlist(char_fns), names(default_fns))], formula_fns)
  } else stop("`fns` must be NULL, character vector, or a list")

  # Build call list (fast)
  calls <- list()
  for (v in cols) {
    for (fname in names(selected_fns)) {
      fn <- selected_fns[[fname]]
      if (rlang::is_formula(fn)) fn <- rlang::as_function(fn)
      calls[[paste(v, fname, sep = "_")]] <- bquote(.(fn)(.(as.name(v))))
    }
  }

  j_call <- as.call(c(as.name("list"), calls))
  stats_dt <- data[, eval(j_call), by = groups]

  if (output == "long") {
    stats_dt <- data.table::melt(stats_dt,
                                 id.vars = groups,
                                 variable.name = "indicator",
                                 value.name = "value")
  }
  if (tbl) stats_dt <- tibble::as_tibble(stats_dt)

  # Convert back to original class if needed
  if (!tbl) {
    if ("tbl_df" %in% orig_class) {
      stats_dt <- tibble::as_tibble(stats_dt)
    } else if ("data.frame" %in% orig_class && !"data.table" %in% orig_class) {
      stats_dt <- as.data.frame(stats_dt)
    }
    # If original was data.table, do nothing
  }
  stats_dt
}

#' Compute ratio indicators of summarized variables over macro indicators
#'
#' `compute_fastshare()` summarizes selected numeric columns by specified groups,
#' merges the result with macroeconomic indicators, computes ratios
#' of summarized variables per macro variable, and returns either a
#' long or wide-format dataset.
#'
#' @param data A dataset containing the raw data to summarize.
#' @param macro_data A `data.frame`, `data.table`, or tibble containing macro-level indicators.
#'   Must share at least one common grouping variable with `data`. Default is `macro_indicators`.
#'   The result will be returned in the same class as the input.
#' @param macro_cols A character vector of column names in `macro_data` to use as denominators
#'   for ratio calculations.
#' @param cols A character vector of column names in `data` to summarize.
#' @param groups A character vector of column names in `data` to group by.
#'   Typically includes country and date/year variables. Default is `c("country_code", "year")`.
#' @param fns A character vector of summary functions to apply to `cols`.
#'   Examples: `"sum"`, `"mean"`, `"median"`.
#' @param output Either `"long"` or `"wide"` (default `"long"`).
#'   - `"long"` returns a tidy table with columns: group variables, `macro_var`, `summary_var`, `indicator`, and `value`.
#'   - `"wide"` returns a table with one column per indicator and original macro/summary values.
#'
#' @return A dataset containing:
#' - In `"long"` format: group variables, `macro_var`, `macro_value`, `summary_var`, `summary_value`, `indicator`, and `value`.
#' - In `"wide"` format: group variables, one column per indicator (`summary_var` per `macro_var`), and original macro and summary values.
#'   The returned object will match the class of the input `data`.
#'
#' @details
#' The function works as follows:
#' 1. Summarizes `cols` by `groups` using the functions in `fns`.
#' 2. Automatically detects common join variables between `summary_dt` and `macro_data`.
#' 3. Merges the summarized data with macro indicators.
#' 4. Computes ratio indicators (`summary_value / macro_value`) for all combinations of summarized columns and macro columns.
#' 5. Optionally reshapes the result into wide format with one column per indicator.
#'
#' @examples
#'
#' \dontrun{
#'
#' dt <- contract_harmonized |> mutate(year = year(est_date)) |> as.data.table()
#'
#' compute_fastshare(
#'   data = dt,
#'   macro_cols = c("gdp_lcu", "pexpenditure_lcu"),
#'   cols = c("gross_salary_lcu", "net_salary_lcu", "base_salary_lcu"),
#'   fns = c("sum", "mean"),
#'   output = "long",
#'   groups = c("country_code", "year")
#' )
#'
#' ## produce results in wide format
#' compute_fastshare(
#'   data = dt,
#'   macro_cols = c("gdp_lcu", "pexpenditure_lcu"),
#'   cols = c("gross_salary_lcu", "net_salary_lcu", "base_salary_lcu"),
#'   fns = c("sum", "mean"),
#'   output = "wide",
#'   groups = c("country_code", "year"))
#'
#' }
#'
#' @importFrom data.table as.data.table melt dcast setkeyv merge.data.table
#' @importFrom stats as.formula
#' @importFrom tibble as_tibble
#' @export
compute_fastshare <- function(data,
                              macro_data = macro_indicators |> data.table::as.data.table(),
                              macro_cols,
                              cols,
                              groups,
                              fns,
                              output = c("long", "wide")) {
  output <- match.arg(output)
  orig_class <- class(data)
  orig_macro_class <- class(macro_data)
  if (!data.table::is.data.table(data)) data <- data.table::as.data.table(data)
  if (!data.table::is.data.table(macro_data)) macro_data <- data.table::as.data.table(macro_data)

  summary_dt <- compute_fastsummary(
    data = data,
    cols = cols,
    fns = fns,
    groups = groups,
    output = "wide"
  )

  join_vars <- intersect(names(summary_dt), names(macro_data))
  if (length(join_vars) == 0)
    stop("No common grouping variables found between data and macro_data.")

  data.table::setkeyv(summary_dt, join_vars)
  data.table::setkeyv(macro_data, join_vars)

  merged_dt <- data.table::merge.data.table(macro_data, summary_dt)

  long_macro <- data.table::melt(
    merged_dt,
    measure.vars = macro_cols,
    variable.name = "macro_var",
    value.name = "macro_value"
  )

  long_summary <- data.table::melt(
    summary_dt,
    measure.vars = setdiff(names(summary_dt), join_vars),
    variable.name = "summary_var",
    value.name = "summary_value"
  )

  ratio_dt <- merge(long_macro, long_summary,
                    by = join_vars,
                    allow.cartesian = TRUE)[
                      , c("indicator", "value") := .(
                        paste0(summary_var, "_per_", macro_var),
                        summary_value / macro_value
                      )
                    ][
                      , .SD,
                      .SDcols = c(join_vars, "macro_var", "macro_value",
                                  "summary_var", "summary_value", "indicator", "value")
                    ]

  if (output == "wide") {
    keep_macro <- unique(ratio_dt[, c(join_vars, "macro_var", "macro_value"), with = FALSE])
    keep_macro <- data.table::dcast(
      keep_macro,
      stats::as.formula(paste(paste(join_vars, collapse = " + "), "~ macro_var")),
      value.var = "macro_value"
    )

    keep_summary <- unique(ratio_dt[, c(join_vars, "summary_var", "summary_value"), with = FALSE])
    keep_summary <- data.table::dcast(
      keep_summary,
      stats::as.formula(paste(paste(join_vars, collapse = " + "), "~ summary_var")),
      value.var = "summary_value"
    )

    keep_dt <- merge(keep_macro, keep_summary, by = join_vars, all = TRUE)

    ratio_dt <- unique(ratio_dt[, c(join_vars, "indicator", "value"), with = FALSE])
    ratio_dt <- data.table::dcast(
      ratio_dt,
      stats::as.formula(paste(paste(join_vars, collapse = " + "), "~ indicator")),
      value.var = "value"
    )

    ratio_dt <- merge(ratio_dt, keep_dt, by = join_vars, all.x = TRUE)
  }

  # Convert back to original class if needed
  if ("tbl_df" %in% orig_class) {
    ratio_dt <- tibble::as_tibble(ratio_dt)
  } else if ("data.frame" %in% orig_class && !"data.table" %in% orig_class) {
    ratio_dt <- as.data.frame(ratio_dt)
  }
  ratio_dt
}

#' Calculate year-over-year growth for a numeric column
#'
#' Computes the year-over-year growth rate for a numeric column in a dataset.
#' The function ensures a complete sequence of years between the minimum and maximum
#' in the date column, fills in any missing years, and calculates the growth rate
#' using lagged values.
#'
#' @param data A dataset.
#' @param col A numeric column (either unquoted or as a string) for which the
#'   year-over-year growth rate will be calculated.
#' @param date_col A date or numeric column (either unquoted or as a string)
#'   used to order the data and define the time sequence (typically a year column).
#'
#' @return A dataset with:
#' \itemize{
#'   \item The completed `date_col` sequence.
#'   \item A new column named `"growth_<col>"` containing the year-over-year growth rates.
#' }
#'   The returned object will match the class of the input `data`.
#'
#' @details
#' - Missing years in the sequence are added automatically.
#' - Missing values in `col` result in `NA` for the corresponding growth rate.
#' - The first observation (or any row where the lag is missing) will have `NA`.
#'
#' @examples
#' library(data.table)
#'
#' dt <- data.table::data.table(
#'   year = c(2020, 2021, 2023),
#'   gdp = c(100, 110, 130)
#' )
#'
#' # Using strings
#' compute_fastchange(dt, "gdp", "year")
#'
#' @importFrom data.table as.data.table setnames shift
#' @export
compute_fastchange <- function(data, col, date_col) {
  orig_class <- class(data)
  dt <- data.table::as.data.table(data)

  # if col/date_col are symbols, convert to strings
  if (!is.character(col)) col <- deparse(substitute(col))
  if (!is.character(date_col)) date_col <- deparse(substitute(date_col))

  # Generate full year sequence
  years_full <- seq(min(dt[[date_col]], na.rm = TRUE),
                    max(dt[[date_col]], na.rm = TRUE))

  # Complete the table
  dt_full <- data.table::data.table(years_full)
  data.table::setnames(dt_full, "years_full", date_col)
  dt_full <- merge(dt_full, dt[, .SD, .SDcols = c(date_col, col)],
                   by = date_col, all.x = TRUE)

  # Compute year-over-year growth
  growth_col <- paste0(col, "_growth")
  dt_full[, (growth_col) := get(col) / data.table::shift(get(col)) - 1]

  # Convert back to original class if needed
  if ("tbl_df" %in% orig_class) {
    dt_full <- tibble::as_tibble(dt_full)
  } else if ("data.frame" %in% orig_class && !"data.table" %in% orig_class) {
    dt_full <- as.data.frame(dt_full)
  }

  return(dt_full)
}


################################################################################
##################### PUBLIC SECTOR REPORTING FUNCTIONS ########################
################################################################################

#' Compute Core HRMIS Analytical Tables
#'
#' This function generates a suite of standardized analytical tables for HRMIS (Human Resource Management Information System) reports.
#' It combines contract-level, personnel-level, and establishmental data to compute wage bill summaries, employment shares, decompositions,
#' and profiles by occupation, pay grade, establishment, education, and seniority.
#'
#' @param contract_dt A `data.table` containing individual employment contracts with variables such as `personnel_id`, `ref_date`,
#' wage variables (`gross_salary_lcu`, `net_salary_lcu`, `base_salary_lcu`), and job attributes.
#' @param personnel_dt A `data.table` containing personnel-level panel data, including `personnel_id`, `ref_date`, demographic and employment information.
#' @param est_dt A `data.table` containing establishmental information (e.g., institution identifiers, types, or sectors).
#' @param macro_indicators A data frame containing macro indicators.
#'
#' @return A named list of `data.table` objects containing:
#' \describe{
#'   \item{wagebill_shares}{Wage bill components as shares of macro indicators.}
#'   \item{publicemployment_share}{Public employment as a share of total employment.}
#'   \item{wagebill_occupisco}{Wage bill decomposition by ISCO occupation group.}
#'   \item{wagebill_occupnative}{Wage bill decomposition by native occupational titles.}
#'   \item{wagebill_estdecomp}{Wage bill decomposition by establishment.}
#'   \item{wagebill_allowshare_paygrade}{Allowance rate by pay grade.}
#'   \item{wagebill_allowshare_seniority}{Allowance rate by seniority.}
#'   \item{personnelevent}{Personnel-level hiring, firing, and retirement events over time.}
#'   \item{employment_decomp}{Employment decomposition by occupation and ISCO group.}
#'   \item{est_decomp}{Employment decomposition by establishment.}
#'   \item{education_profile}{Distribution of public sector personnel by education, gender, and occupation.}
#'   \item{mobilityprofile}{Distribution of public sector personnel by pay grade, seniority, gender, and occupation.}
#' }
#'
#' @details
#' The function integrates contract, personnel, and establishmental datasets to compute a standardized HRMIS statistical report.
#' It relies on supporting helper functions such as:
#' \code{convert_constant_ppp()}, \code{compute_fastshare()}, \code{compute_fastsummary()},
#' \code{detect_personnel_event()}, and \code{detect_retirement()}.
#'
#' Each sub-table in the output list can be used directly in dashboards, reports, or further analytical aggregation.
#'
#' @examples
#' \dontrun{
#' hrm_stats <- compute_hrmreport_stats(contract_dt = contract_data,
#'                                      personnel_dt = personnel_data,
#'                                      est_dt = est_data)
#' names(hrm_stats)
#' }
#'
#' @importFrom lubridate year
#' @importFrom data.table :=
#' @importFrom data.table fifelse
#' @importFrom data.table setnames
#' @importFrom dplyr rename
#' @importFrom dplyr bind_rows
#'
#' @export

compute_hrmreport_stats <- function(contract_dt,
                                    personnel_dt,
                                    est_dt,
                                    macro_indicators){

  ## convert to data.table
  contract_dt <-  as.data.table(contract_dt)
  personnel_dt <- as.data.table(personnel_dt)
  est_dt <- as.data.table(est_dt)


  ### 3.1
  wage_vars <- c("gross_salary_lcu",
                 "net_salary_lcu",
                 "base_salary_lcu")

  lcu_vars <- colnames(macro_indicators)[grepl("_lcu",
                                               colnames(macro_indicators))]

  contract_dt[, year := lubridate::year(ref_date)]

  ### compute ppp variables
  contract_dt <-
  convert_constant_ppp(data = contract_dt,
                       cols = wage_vars)

  ppp_vars <- colnames(contract_dt)[grepl("_ppp", colnames(contract_dt))]


  wagebill_shares_dt <-
    compute_fastshare(data = contract_dt,
                      cols = wage_vars,
                      macro_cols = lcu_vars,
                      groups = c("country_code", "year"),
                      fns = "sum",
                      output = "long")

  ### public sector employment as a share of total employment
  personnel_dt[, year := lubridate::year(ref_date)]

  pubempshare_dt <-
    compute_fastshare(data = contract_dt,
                      macro_cols = "labor_force_total",
                      cols = "personnel_id",
                      groups = c("country_code", "year"),
                      fns = "count_unique",
                      output = "long")


  wagebill_annual_dt <-
    compute_fastsummary(data = contract_dt,
                        cols = c(wage_vars, ppp_vars),
                        fns = c("sum", "mean", "median"),
                        groups = c("year"),
                        output = "long")

  wagebill_iscodecomp_dt <-
    compute_fastsummary(data = contract_dt,
                        cols = c(wage_vars, ppp_vars),
                        fns = c("sum", "mean", "cp_ratio", "cv"),
                        groups = c("occupation_isconame", "occupation_iscocode", "year"),
                        output = "long")

  wagebill_occupdecomp_dt <-
    compute_fastsummary(data = contract_dt,
                        cols = c(wage_vars, ppp_vars),
                        fns = c("sum", "mean"),
                        groups = c("occupation_native", "occupation_english", "year"),
                        output = "long")

  wagebill_estdecomp_dt <-
    compute_fastsummary(data = contract_dt,
                        cols = c(wage_vars, ppp_vars),
                        fns = c("sum", "mean"),
                        groups = c("est_id", "year"),
                        output = "long")

  wagebill_paygrade_dt <-
    compute_fastsummary(data = contract_dt,
                        cols = c(wage_vars, ppp_vars),
                        fns = "sum",
                        groups = "paygrade")

  wagebill_seniority_dt <-
    compute_fastsummary(data = contract_dt,
                        cols = c(wage_vars, ppp_vars),
                        fns = "sum",
                        groups = "seniority")

  ## lets look into allowance a little
  contract_dt[, allowance_ind := fifelse(allowance_lcu > 0, 1, 0)]

  wagebill_allowpaygrade_dt <-
    contract_dt[, mean(allowance_ind, na.rm = T), by = c("paygrade", "year")] |>
    setnames(old = "V1", new = "allowance_rate")

  wagebill_allowseniority_dt <-
    contract_dt[, mean(allowance_ind, na.rm = T), by = c("seniority", "year")] |>
    setnames(old = "V1", new = "allowance_rate")

  ### allowance as a share of each salary type
  allowsalary_share_dt <-
    contract_dt[, allowshare := allowance_lcu / base_salary_lcu] %>%
    .[, mean(allowshare, na.rm = TRUE), by = c("country_code", "year", "paygrade")]


  ### compute annual recruitment patterns over time (still need to compute the reallocations, ask Gali!)

  hire_dt <- detect_personnel_event(data = personnel_dt,
                                 id_col = "personnel_id",
                                 event_type = "hire",
                                 start_date = min(personnel_dt$ref_date, na.rm = TRUE),
                                 end_date = max(personnel_dt$ref_date, na.rm = TRUE))


  personnel_active_dt <- personnel_dt[status == "active"]

  contract_rename_est_dt <- merge(contract_dt,
                                  personnel_active_dt,
                                  by = c("personnel_id", "ref_date"),
                                  allow.cartesian = TRUE)

  personnel_reallocation_dt <- detect_reallocation(data = contract_rename_est_dt,
                                                personnel_hire = hire_dt)

  personnelevent_dt <-
    bind_rows(hire_dt,
              detect_personnel_event(data = personnel_dt,
                                  id_col = "personnel_id",
                                  event_type = "fire",
                                  start_date = min(personnel_dt$ref_date, na.rm = TRUE),
                                  end_date = max(personnel_dt$ref_date, na.rm = TRUE)),
              detect_retirement(data = personnel_dt))



  ## decomposition of public sector employment by industry and occupational group

  empdecomp_dt <-
    compute_fastsummary(data = contract_dt,
                        cols = "personnel_id",
                        groups = c("year", "occupation_isconame", "occupation_iscocode"),
                        output = "long",
                        fns = "count_unique") |>
    merge(isco,
          by.y = c("unit", "description"),
          by.x = c("occupation_iscocode", "occupation_isconame"),
          all.x = TRUE) |>
    rename(count = "value") %>%
    .[, prop := count / sum(count, na.rm = TRUE), by = "year"]

  orgdecomp_dt <-
    compute_fastsummary(data = contract_dt,
                        cols = "personnel_id",
                        groups = c("year", "est_id"),
                        output = "long",
                        fns = "count_unique") |>
    rename(count = "value") %>%
    .[, prop := count / sum(count, na.rm = TRUE), by = "year"]


  ## Educational profile of public sector personnel by gender and occupation

  combine_dt <- personnel_dt[contract_dt, on = c("personnel_id", "ref_date", "year")]

  educprofile_dt <- combine_dt[, .N, by = .(year, gender, educat7,
                                            occupation_iscocode, occupation_native)]

  ## distribution of public sector personnels by pay grade
  mobilityprofile_dt <- combine_dt[, .N, by = .(year, gender, paygrade, seniority, occupation_native, occupation_iscocode)]



  hrm_list <- list(wagebill_shares = wagebill_shares_dt,
                   publicemployment_share = pubempshare_dt,
                   wagebill = list(
                     wagebill_annual = wagebill_annual_dt,
                     wagebill_occupisco = wagebill_iscodecomp_dt,
                     wagebill_occupnative = wagebill_occupdecomp_dt,
                     wagebill_estdecomp = wagebill_estdecomp_dt,
                     wagebill_allowshare_paygrade = wagebill_allowpaygrade_dt,
                     wagebill_allowshare_seniority = wagebill_allowseniority_dt
                   ),
                   personnel_movements = personnelevent_dt,
                   employment_decomp = empdecomp_dt,
                   est_decomp = orgdecomp_dt,
                   education_profile = educprofile_dt,
                   mobilityprofile = mobilityprofile_dt)

  return(hrm_list)
}




#' Compute Volatility Measures Over Time
#'
#' @description
#' Computes a variety of volatility statistics (e.g., percent change, 
#' rolling standard deviation, coefficient of variation) for a variable 
#' aggregated over time and optionally by grouping variables.  
#' Missing time periods are automatically filled for all groups, ensuring 
#' consistent temporal coverage before volatility is calculated.
#'
#' @details
#' This function first summarizes the input data using 
#' [compute_fastsummary()], aggregating `col` using `agg_fn` for each 
#' combination of `groups` and `time`.  
#'
#' After aggregation, the function constructs a full grid of all time periods 
#' crossed with all unique group combinations using `data.table::CJ()`, filling 
#' implicit missing time–group combinations with `NA`.  
#'
#' Volatility measures are computed by calling an internal registry of 
#' volatility functions defined in [`define_vol_fns()`].  
#'
#' Available volatility methods include:
#'
#' * **pct_change** — period-to-period percent change  
#' * **sd** — standard deviation of the aggregated values over time  
#' * **cv** — coefficient of variation (`sd(x) / mean(x)`)  
#' * **rolling_sd** — rolling standard deviation using a fixed window  
#' * **rolling_cv** — rolling coefficient of variation  
#' * **rolling_pct_change** — percent change over a rolling window  
#'
#' @param data A data.frame or data.table containing the dataset.
#' @param col A character string specifying the column whose volatility 
#'   should be computed.
#' @param agg_fn A character string specifying the aggregation function 
#'   to apply before volatility is calculated. Must match a function 
#'   name available to `compute_fastsummary()`.
#' @param vol_fn A character string specifying the volatility measure 
#'   to compute. Options are:
#'   `"pct_change"`, `"sd"`, `"cv"`, `"rolling_sd"`, `"rolling_cv"`,
#'   `"rolling_pct_change"`.
#' @param time A character string representing the time variable. Must be 
#'   sortable (e.g., Date, year, numeric).
#' @param groups A character vector of grouping variables. Use `NULL` to 
#'   compute volatility for the entire dataset without grouping.
#' @param window_size Integer window length for rolling volatility functions. 
#'   Required when `vol_fn` is one of the rolling variants.
#'
#' @return 
#' A `data.table` containing:
#' * grouping variables (if provided),  
#' * the time variable (for rolling and period-based volatility), and  
#' * the computed volatility statistic, named using `vol_fn`.  
#'
#' For non-rolling aggregate volatility functions (`sd`, `cv`), the function 
#' returns one row per group.
#' 
#' @importFrom data.table as.data.table setorderv CJ merge.data.table setnames shift frollapply
#' @importFrom stats sd
#'
#' @examples
#' \dontrun{
#' # Percent change in base salary by occupation over time
#' compute_volatility(
#'   data      = bra_hrmis_contract,
#'   col       = "base_salary_lcu",
#'   agg_fn    = "sum",
#'   vol_fn    = "pct_change",
#'   time      = "ref_date",
#'   groups    = "occupation_isconame"
#' )
#'
#' # Rolling 3-period coefficient of variation
#' compute_volatility(
#'   data      = bra_hrmis_contract,
#'   col       = "whours",
#'   agg_fn    = "mean",
#'   vol_fn    = "rolling_cv",
#'   time      = "ref_date",
#'   groups    = "occupation_native",
#'   window_size = 3
#' )
#' }
#'
#' @seealso 
#' * [`define_vol_fns()`] for the internal volatility function registry  
#' * [`compute_fastsummary()`] for the aggregation step  
#'
#' @export


compute_volatility <- function(data, 
                               col,
                               agg_fn , 
                               vol_fn = c("pct_change", "sd", "cv", 
                                          "rolling_sd", "rolling_cv", 
                                          "rolling_pct_change"),
                               time,  
                               groups,
                               window_size = NULL) {
  
  vol_fn <- match.arg(vol_fn)


  agg_dt <- 
    compute_fastsummary(data = data |> as.data.table(),
                        cols = col,
                        fns = agg_fn,
                        groups = c(groups, time)) 
  
  data.table::setorderv(agg_dt, c(groups, time))
  
  ## fill in the implicit missing values
  ## Grid must include the indicator dimension so that imputed NA rows
  ## are correctly associated with their indicator, not left as indicator = NA.

  time_list      <- sort(unique(agg_dt[[time]]))
  indicator_list <- as.character(unique(agg_dt[["indicator"]]))

  if (is.null(groups)){

    grid_dt <- data.table::CJ(indicator = indicator_list, ref = time_list)
    data.table::setnames(grid_dt, "ref", time)

  } else {

    group_values <- unique(agg_dt[, ..groups])

    ## construct the inputs for data.table::CJ function and wrap in a do.call
    cj_inputs <- c(as.list(group_values),
                   list(indicator = indicator_list, ref = time_list))

    grid_dt <- do.call(data.table::CJ, c(cj_inputs, list(unique = TRUE)))

    data.table::setnames(grid_dt, "ref", time)

  }

  ## coerce indicator back to factor to match agg_dt
  agg_dt[, indicator := as.character(indicator)]

  ### compute volatility based on selected method
  agg_dt <- data.table::merge.data.table(
    grid_dt, agg_dt,
    by = c(groups, "indicator", time),
    all.x = TRUE
  )
  agg_dt[, indicator := factor(indicator)]

  ### compare registry of volatility functions to selected functions
  vol_fns <- define_vol_fns(window_size = window_size)

  fn <- vol_fns[[vol_fn]]

  if (is.null(fn)) stop("Volatility function not defined: ", vol_fn)
  
  ### lets apply the function now
  if (vol_fn %in% c("pct_change", "rolling_sd", 
                    "rolling_cv", "rolling_pct_change")) {
    
    agg_dt[, (vol_fn) := fn(value), by = c(groups, "indicator")]

  } else if (vol_fn %in% c("sd", "cv")) {

    agg_dt <- agg_dt[, fn(value), by = groups]

    data.table::setnames(agg_dt, "V1", vol_fn)


  } else {

    stop("Volatility function not recognized: ", vol_fn)

  }
  
  return(agg_dt[])
}


#' Internal: Registry of Volatility Functions
#'
#' @description
#' Creates and returns a named list of volatility functions used internally by 
#' [`compute_volatility()`]. Each element of the list corresponds to a volatility 
#' method such as percent change, standard deviation, coefficient of variation, 
#' or rolling variants of these measures.
#'
#' @details
#' The returned list maps volatility function names (e.g., `"pct_change"`, 
#' `"rolling_sd"`) to functions that operate on numeric vectors.  
#' Rolling functions rely on `data.table::frollapply()` and require 
#' that the calling function supply a `window_size`.
#'
#' This function is not exported and is intended for internal use only.
#'
#' @param window_size Integer window length for rolling statistics. Defaults to 
#'   `NULL` but must be provided when calling any rolling volatility function.
#'
#' @return A named list of functions used by `compute_volatility()`.
#'
#' @keywords internal
#' @noRd



define_vol_fns <- function(window_size = NULL) {

  list(pct_change = function(x) {

        (x - shift(x)) / shift(x)
      },

      sd = function(x) {
        stats::sd(x, na.rm = TRUE)
      },

      cv = function(x) {
        stats::sd(x, na.rm = TRUE) / mean(x, na.rm = TRUE)
      },

      rolling_sd = function(x) {
        data.table::frollapply(x, n = window_size, FUN = sd, fill = NA)
      },

      rolling_cv = function(x) {
        data.table::frollapply(x,
                               n = window_size,
                               FUN = function(w) stats::sd(w, na.rm = TRUE) / mean(w, na.rm = TRUE), 
                               fill = NA)
      },
      rolling_pct_change = function(x) {
        data.table::frollapply(x,
                               n = window_size,
                               FUN = function(w) (w[length(w)] - w[1]) / w[1],
                               fill = NA)
      }
    )
}



#' Fast counting via dtplyr
#'
#' `fastcount()` delegates [dplyr::count()] to a `data.table` backend by
#' converting the input to a lazy `dtplyr` table first. This preserves the
#' familiar `count()` interface while exploiting `data.table` performance.
#'
#' @inheritParams dplyr::count
#' 
#' @return A tibble with one row per group and a count column.
#'
#' @examples
#' df <- tibble::tibble(group = c("a", "a", "b"))
#' fastcount(df, group)
#'
#' @importFrom dtplyr lazy_dt
#' @import dplyr
#' @importFrom tibble as_tibble
#' 
#' @export
fastcount <- function(x, ..., wt = NULL, sort = FALSE, name = NULL) {
  count_dt <- dtplyr::lazy_dt(x, immutable = TRUE) |>
    dplyr::count(..., wt = {{ wt }}, sort = sort, name = name) |>
    tibble::as_tibble()

  count_dt
}

#' Compute group-wise proportions from counts
#'
#' fastprop() computes the proportion of counts within groups.
#' It expects the input to already contain a count column named `n`
#' (for example the output of `dplyr::count()` or `fastcount()`).
#'
#' @param .data A data frame or tibble containing a count column `n`.
#' @param ... Grouping variables. Proportions are
#'   computed within the combinations of these variables.
#'
#' @return A tibble with the same columns as `.data` plus a numeric
#'   `prop` column giving the group share (0–1). Missing `n` values are
#'   ignored in the denominator via `na.rm = TRUE`.
#'
#' @examples
#' library(dplyr)
#' df <- tibble::tibble(group = c("a","a","b"))
#' df |> count(group) |> fastprop(group)
#'
#' @seealso dplyr::count, fastcount
#' @export
fastprop <- function(.data, ...){
  group_vars <- rlang::ensyms(...)

  prop_dt <- .data |>
    dtplyr::lazy_dt() |> 
    dplyr::group_by(!!!group_vars) |>
    dplyr::mutate(prop = n / sum(n, na.rm = TRUE)) |>
    dplyr::ungroup() |> 
    as_tibble()

  prop_dt
}

#' Compute wage bill aggregates with optional macro-fiscal shares
#'
#' @description
#' Computes aggregate wage bill statistics from contract-level salary data.
#' The function converts salary variables to constant purchasing power parity
#' (PPP) using macro indicators, then aggregates by specified grouping variables.
#' Optionally computes wage bill shares relative to macro-fiscal aggregates
#' (e.g., GDP, public expenditure, revenue).
#'
#' @param contract_df A data.frame or tibble containing contract-level salary data.
#'   Must include the columns specified in `wage_vars` and `groups`.
#' @param wage_vars Character vector of salary column names to aggregate.
#'   Defaults to `c("gross_salary_lcu", "net_salary_lcu", "base_salary_lcu")`.
#' @param groups Character vector of grouping columns for aggregation.
#'   Defaults to `c("country_code", "year")`.
#' @param share_macro Logical; if `TRUE`, computes wage bill shares relative
#'   to macro-fiscal aggregates specified in `macro_vars`. Defaults to `FALSE`.
#' @param macro_vars Character vector of macro indicator column names to use
#'   as denominators when `share_macro = TRUE`. Defaults to
#'   `c("gdp_lcu", "pexpenditure_lcu", "prevenue_lcu", "taxrevenue_lcu")`.
#' @param drop_na Logical; if `TRUE`, removes `NA` values before aggregation.
#'   Defaults to `TRUE`.
#'
#' @return A wage bill table with optional grouping variables,
#'   an `indicator` column (describing the wage variable and level of analysis),
#'   and a `value` column. When `share_macro = TRUE`, values represent
#'   shares (wage bill / macro aggregate).
#' 
#' @examples
#' # Compute wage bill totals by country and year
#' \dontrun{
#' compute_wagebill(
#'   contract_df = govhr::bra_hrmis_contract,
#'   wage_vars = c("gross_salary_lcu"),
#'   groups = c("country_code", "year")
#' )
#'
#' # Compute wage bill as share of GDP and public expenditure
#' compute_wagebill(
#'   contract_df = govhr::bra_hrmis_contract,
#'   wage_vars = c("gross_salary_lcu", "net_salary_lcu"),
#'   groups = c("country_code", "year"),
#'   share_macro = TRUE,
#'   macro_vars = c("gdp_lcu", "pexpenditure_lcu")
#' ) 
#' }
#' 
#' @seealso
#' \code{\link{convert_constant_ppp}} for PPP conversion
#' \code{\link{compute_fastsummary}} for general aggregation
#' \code{\link{compute_fastshare}} for share computation (when `share_macro = TRUE`)
#'
#' @export
compute_wagebill <- function(
  contract_df, 
  wage_vars = c("gross_salary_lcu", "net_salary_lcu", "base_salary_lcu"),
  groups = c("country_code", "year"),
  share_macro = FALSE,
  macro_vars = c("gdp_lcu", "pexpenditure_lcu", "prevenue_lcu", "taxrevenue_lcu"),
  drop_na = TRUE
) {  
  data_ppp <- contract_df |>
    convert_constant_ppp(
      cols = wage_vars
    )
  
  if(share_macro) {
    data_ppp |> 
      compute_fastshare(
        cols = wage_vars,
        macro_cols = macro_vars,
        groups = groups,
        fns = "sum",
        output = "long"
      )
  } else {
    data_ppp |> 
      compute_fastsummary(
        cols = wage_vars,
        groups = groups,
        fns = "sum",
        output = "long"
      )
  }
}

#' Compute index values relative to base year
#'
#' @description
#' Computes index values for specified columns where the earliest year value
#' is set to 100. All subsequent values are expressed as a percentage of the
#' base year value. This is useful for comparing growth trends across multiple
#' time series on a common scale.
#'
#' @param .data A data.frame or tibble containing the time series data.
#' @param date_col Unquoted column name containing the time/year variable.
#' @param ... Unquoted column names to compute indices for. Each selected
#'   column must be numeric.
#'
#' @return A tibble with the date column and computed index columns. Index
#'   column names are formed by appending "_index" to the original column names.
#'
#' @examples
#' \dontrun{
#' # Compute indices for headcount and labor force
#' contract_df |>
#'   compute_baseline_index(year, total_headcount, labor_force_total)
#' }
#'
#' @importFrom rlang enquo as_name enquos expr
#' @importFrom tidyselect eval_select
#' @importFrom tibble as_tibble
#' @importFrom dplyr select all_of
#'
#' @export
compute_baseline_index <- function(.data, date_col, ...) {
  date_quo <- rlang::enquo(date_col)
  date_name <- rlang::as_name(date_quo)
  
  cols_quos <- rlang::enquos(...)
  if (length(cols_quos) == 0) {
    stop("At least one column must be specified for indexing.", call. = FALSE)
  }
  
  # resolve column names
  cols_sel <- tidyselect::eval_select(rlang::expr(c(!!!cols_quos)), .data)
  cols_names <- names(cols_sel)
  
  # compute indices for each column
  indexed_df <- .data
  for (col in cols_names) {
    base_val <- indexed_df[[col]][indexed_df[[date_name]] == min(indexed_df[[date_name]], na.rm = TRUE)]
    if (length(base_val) == 0 || is.na(base_val[1])) {
      warning(sprintf("Base year value for '%s' is NA or missing; index will be NA.", col), call. = FALSE)
      indexed_df[[paste0(col, "_index")]] <- NA_real_
    } else {
      indexed_df[[paste0(col, "_index")]] <- (indexed_df[[col]] / base_val[1]) * 100
    }
  }

  indexed_df
}

#' Function to compute quantiles of a measure column within groups and reference dates.
#'
#' @param .data A data frame containing the data to be processed.
#' @param group_cols A character vector of column names to group the data by.
#' @param measure_col The name of the column for which quantiles will be computed.
#' @param latest_measure A logical value indicating whether to return only the measures for the latest reference date's quantiles (default is FALSE).
#' @param n_quantiles The number of quantiles to compute (default is 10 for deciles).
#' 
#' @return A data frame containing the quantiles, median values, and mean values for the specified measure column within the specified groups and reference dates.
#'
#' @importFrom data.table as.data.table setorderv
#' @importFrom dplyr ntile
#'
#' @export
compute_quantile <- function(
  .data,
  group_cols = NULL,
  measure_col,
  latest_measure = FALSE,
  n_quantiles = 10
) {
  dt <- data.table::as.data.table(.data)

  # change group_cols based on the choice of latest measure
  if (latest_measure) {
    by_cols <- group_cols
    dt <- dt[ref_date == max(ref_date)]

    dt[, decile := dplyr::ntile(get(measure_col), n_quantiles)]
  } else {
    by_cols <- c(group_cols, "ref_date")

    dt[, decile := dplyr::ntile(get(measure_col), n_quantiles), by = by_cols]
  }  

  out <- dt[
    !is.na(decile),
    .(
      median_value = stats::median(get(measure_col), na.rm = TRUE),
      mean_value = mean(get(measure_col), na.rm = TRUE)
    ),
    keyby = c(by_cols, "decile")
  ]

  data.table::setorderv(out, c(by_cols, "decile"))

  out[]
}

#' Function to compute the compression ratio
#'
#' @param .data A data frame.
#' @param group_cols A character vector of column names to group the data by.
#' @param percentiles A numeric vector of length 3 indicating the upper, middle, and lower percentiles to compute (default is c(0.9, 0.5, 0.1)).
#' @param measure_col The name of the column for which the compression ratio will be computed.
#' @param latest_measure A logical value indicating whether to return only the measures for the latest reference date.
#'
#' @return A data frame containing the 90th, 50th, and 10th percentiles for the specified measure column within the specified groups and reference dates.
#'
#' @importFrom data.table as.data.table setorderv
#' @importFrom collapse fquantile
#'
#' @export
compute_compression_ratio <- function(
  .data,
  group_cols = NULL,
  percentiles = c(0.9, 0.5, 0.1),
  measure_col,
  latest_measure = FALSE
) {
  # consider generalizing this function to compute any percentile, not just 90th, 50th, and 10th
  dt <- data.table::as.data.table(.data)

  by_cols <- c(group_cols, "ref_date")

  out <- dt[
    !is.na(get(measure_col)),
    .(
      percentile_upper = collapse::fquantile(
        get(measure_col),
        probs = percentiles[1],
        na.rm = TRUE
      ),
      percentile_50 = collapse::fquantile(
        get(measure_col),
        probs = percentiles[2],
        na.rm = TRUE
      ),
      percentile_lower = collapse::fquantile(
        get(measure_col),
        probs = percentiles[3],
        na.rm = TRUE
      )
    ),
    keyby = by_cols
  ]

  if (latest_measure && group_cols != "ref_date") {
    out <- out[ref_date == max(ref_date)]
  }

  data.table::setorderv(out, by_cols)

  out[]
}

#' Function to compute the distribution function of a variable.
#'
#' @param .data A data frame.
#' @param group_col A character vector of column names to group the data by.
#' @param measure_col The name of the column for which the percentile values will be computed.
#' @param binwidth The width of the bins for grouping the measure values (default is 1).
#' @param latest_measure A logical value indicating whether to return only the measures for the latest reference date.
#'
#' @return A data frame with the distribution function, where `pct` denotes the percentage of observations in each bin and `cum_pct` denotes the cumulative percentage.
#' 
#' @importFrom data.table as.data.table setorderv
#' @importFrom collapse fquantile
#' 
#' @export
compute_density <- function(
  .data,
  group_col = NULL,
  measure_col,
  binwidth = 1,
  latest_measure = FALSE
) {
  if (latest_measure) {
    .data <- .data[.data[["ref_date"]] == max(.data[["ref_date"]]), ]
  }

  dt <- data.table::as.data.table(.data)
  dt[, bin := floor(get(measure_col) / binwidth) * binwidth]
  dt <- dt[!is.na(bin)]

  binned <- dt[, .(count = .N), by = c(group_col, "bin")]

  # full grid of every bin in range, crossed with every group present
  all_bins <- seq(min(dt$bin), max(dt$bin), by = binwidth)

  full_grid <- if (is.null(group_col)) {
    data.table::data.table(bin = all_bins)
  } else {
    data.table::CJ(
      unique(dt[[group_col]]),
      all_bins,
      sorted = FALSE
    ) |>
      data.table::setnames(c(group_col, "bin"))
  }

  binned <- merge(full_grid, binned, by = c(group_col, "bin"), all.x = TRUE)
  binned[is.na(count), count := 0L]

  data.table::setorderv(binned, c(group_col, "bin"))

  binned <- binned[,
    c(
      .SD,
      list(
        pct = count / sum(count),
        cum_pct = cumsum(count) / sum(count)
      )
    ),
    by = group_col
  ]

  binned[]
}

#' Compute time trend 
#'
#' Summarizes data over time by grouping variable, producing a tidy data frame
#' with `ref_date`, optional group column, and `value`.
#'
#' When `measure_col` is `NULL`, counts rows per period (headcount). When a
#' column name is supplied, sums that column per period (wage bill).
#'
#' @param .data A data frame containing at least a `ref_date` column.
#' @param group Character string naming the grouping column, or `"ref_date"` for
#'   no grouping.
#' @param measure_col Character string naming the numeric column to sum, or
#'   `NULL` to count rows.
#'
#' @return A summarized data frame with columns `ref_date`, optionally `group`, and `value`. Value denotes either a sum or headcount (if `measure_col` is `NULL`).
#'
#' @importFrom data.table as.data.table
#' @importFrom govhr compute_fastsummary
#' 
#' @export
compute_time_trend <- function(.data, group, measure_col = NULL) {
  .data_dt <- data.table::as.data.table(.data)

  groups <- if (group == "ref_date") "ref_date" else c("ref_date", group)

  if (is.null(measure_col)) {
    # headcount by group
    .data_dt <- .data_dt[, .(value = .N), by = groups]

    # order by groups
    data.table::setorderv(.data_dt, groups)

    .data_dt
  } else {
    .data_dt |>
      compute_fastsummary(
        cols = measure_col,
        fns = "sum",
        groups = groups
      )
  }
}

#' Rescale to Baseline Index
#'
#' Rescales the `value` column so that the first observation equals 100,
#' producing a baseline index. When a grouping variable is present, the
#' rescaling is applied within each group.
#'
#' @param data A data frame with columns `ref_date` and `value`, as returned by
#'   [compute_time_trend()].
#' @param group Character string naming the grouping column, or `"ref_date"` for
#'   no grouping.
#'
#' @return The input data frame with `value` rescaled to a baseline index.
#'
#' @importFrom dplyr arrange mutate across all_of ungroup first
#' 
#' @export
rescale_baseline <- function(data, group) {
  if (group == "ref_date") {
    data |>
      dplyr::arrange(.data[["ref_date"]]) |>
      dplyr::mutate(
        value = .data[["value"]] / dplyr::first(.data[["value"]]) * 100
      )
  } else {
    data |>
      dplyr::arrange(.data[["ref_date"]]) |>
      dplyr::mutate(
        value = .data[["value"]] / dplyr::first(.data[["value"]]) * 100,
        .by = dplyr::all_of(group)
      )
  }
}

#' Compute Cross-Section Summary Table
#'
#' Filters to the latest reference date within each group, then aggregates to
#' produce a per-group `value`. Used as the data source for total-by-group bar
#' charts.
#'
#' When `measure_col` is `NULL`, counts rows (headcount). When a column name is
#' supplied, sums that column (wage bill).
#'
#' @param data A data frame containing a `ref_date` column and the grouping
#'   column.
#' @param group Character string naming the grouping column.
#' @param measure_col Character string naming the numeric column to sum, or
#'   `NULL` to count rows.
#'
#' @return A data frame with the grouping column and a `value` column.
#'
#' @importFrom dplyr group_by across all_of filter ungroup summarise n
#' @importFrom govhr compute_fastsummary
#' 
#' @export
compute_cross_section <- function(data, group, measure_col = NULL) {
  # only consider latest reference date
  data_latest <- data |>
    dplyr::filter(
      .data[["ref_date"]] == max(.data[["ref_date"]]),
      .by = dplyr::all_of(group)
    )

  if (is.null(measure_col)) {
    data_latest |>
      dplyr::summarise(value = dplyr::n(), .by = dplyr::all_of(group))
  } else {
    data_latest |>
      compute_fastsummary(
        cols = measure_col,
        fns = "sum",
        groups = group
      )
  }
}

#' Compute Growth Rate Summary Table
#'
#' Filters to the first and last reference date within each group and computes
#' the percentage change from first `ref_date` to last `ref_date`.
#'
#' When `measure_col` is `NULL`, counts rows per date-group cell (headcount).
#' When a column name is supplied, sums that column (wage bill).
#'
#' @param .data A data frame with `ref_date` and the grouping column.
#' @param group Character string naming the grouping column.
#' @param measure_col Character string naming the numeric column to sum, or
#'   `NULL` to count rows.
#'
#' @return A data frame with the grouping column and a `growth_rate` column
#'   (percentage points, e.g. 12.5 for +12.5%).
#'
#' @importFrom dplyr group_by across all_of filter ungroup summarise n first last
#' @importFrom govhr compute_fastsummary
#' 
#' @export
compute_growth <- function(.data, group, measure_col = NULL) {
  endpoints <- .data |>
    dplyr::filter(
      .data[["ref_date"]] %in%
        c(max(.data[["ref_date"]]), min(.data[["ref_date"]])),
      .by = dplyr::all_of(group)
    ) |>
    dplyr::arrange(.data[["ref_date"]])

  summarized <- if (is.null(measure_col)) {
    endpoints |>
      dplyr::summarise(
        value = dplyr::n(),
        .by = dplyr::all_of(c("ref_date", group))
      )
  } else {
    endpoints |>
      compute_fastsummary(
        cols = measure_col,
        fns = "sum",
        groups = c("ref_date", group)
      )
  }

  summarized |>
    dplyr::filter(!is.na(.data[[group]])) |>
    dplyr::summarise(
      growth_rate = round(
        dplyr::last(.data[["value"]]) / dplyr::first(.data[["value"]]) - 1,
        3
      ) *
        100,
      .by = dplyr::all_of(group)
    ) |>
    dplyr::filter(!is.na(.data[["growth_rate"]]))
}

#' Function to compute deciles of a measure column within groups and reference dates.
#'
#' @param .data A data frame containing the data to be processed.
#' @param group_cols A character vector of column names to group the data by.
#' @param measure_col The name of the column for which deciles will be computed.
#' @param latest_measure A logical value indicating whether to return only the measures for the latest reference date's deciles (default is FALSE).
#'
#' @return A data frame containing the deciles, median values, and mean values for the specified measure column within the specified groups and reference dates.
#'
#' @importFrom data.table as.data.table setorderv
#' @importFrom dplyr ntile
#'
#' @export
compute_decile <- function(
  .data,
  group_cols = NULL,
  measure_col,
  latest_measure = FALSE
) {
  dt <- data.table::as.data.table(.data)

  by_cols <- if (latest_measure) {
    group_cols
  } else {
    c(group_cols, "ref_date")
  }

  if (latest_measure) {
    dt <- dt[ref_date == max(ref_date)]
  }

  dt[, decile := dplyr::ntile(get(measure_col), 10), by = by_cols]

  out <- dt[
    !is.na(decile),
    .(
      median_value = stats::median(get(measure_col), na.rm = TRUE),
      mean_value = mean(get(measure_col), na.rm = TRUE)
    ),
    keyby = c(by_cols, "decile")
  ]

  data.table::setorderv(out, c(by_cols, "decile"))

  out[]
}

#' Function to compute the percentile values
#'
#' @param .data A data frame.
#' @param group_col A character vector of column names to group the data by.
#' @param measure_col The name of the column for which the percentile values will be computed.
#' @param binwidth The width of the bins for grouping the measure values (default is 1).
#' @param latest_measure A logical value indicating whether to return only the measures for the latest reference date.
#'
#' @importFrom data.table as.data.table setorderv
#' @importFrom collapse fquantile
#'
#' @return A data frame containing the 90th, 50th, and 10th percentiles for the specified measure column within the specified groups and reference dates.
compute_percentile <- function(
  .data,
  group_col = NULL,
  measure_col,
  binwidth = 1,
  latest_measure = FALSE
) {
  if (latest_measure) {
    .data <- .data[.data[["ref_date"]] == max(.data[["ref_date"]]), ]
  }

  dt <- data.table::as.data.table(.data)
  dt[, bin := floor(get(measure_col) / binwidth) * binwidth]
  dt <- dt[!is.na(bin)]

  binned <- dt[, .(count = .N), by = c(group_col, "bin")]

  # full grid of every bin in range, crossed with every group present
  all_bins <- seq(min(dt$bin), max(dt$bin), by = binwidth)

  full_grid <- if (is.null(group_col)) {
    data.table::data.table(bin = all_bins)
  } else {
    data.table::CJ(
      unique(dt[[group_col]]),
      all_bins,
      sorted = FALSE
    ) |>
      data.table::setnames(c(group_col, "bin"))
  }

  binned <- merge(full_grid, binned, by = c(group_col, "bin"), all.x = TRUE)
  binned[is.na(count), count := 0L]

  data.table::setorderv(binned, c(group_col, "bin"))

  binned <- binned[,
    c(
      .SD,
      list(
        pct = count / sum(count),
        cum_pct = cumsum(count) / sum(count)
      )
    ),
    by = group_col
  ]

  binned[]
}
