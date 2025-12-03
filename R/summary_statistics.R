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
#' - The function can accept both unquoted column names or strings.
#' - To compute growth rates by group (e.g., country), use `group_by()` from `dplyr`.
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
#'   \item{education_profile}{Distribution of public sector personnels by education, gender, and occupation.}
#'   \item{mobilityprofile}{Distribution of public sector personnels by pay grade, seniority, gender, and occupation.}
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
                       cols = wage_vars,
                       macro_indicators = macro_indicators)

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


  ## educational profile of public sector personnels by gender and perhaps occupation (find out about which
  ## rates we need to compute)

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

#' Fast counting via dtplyr
#'
#' `fastcount()` delegates [dplyr::count()] to a `data.table` backend by
#' converting the input to a lazy `dtplyr` table first. This preserves the
#' familiar `count()` interface while exploiting `data.table` performance.
#'
#' @inheritParams dplyr::count
#' @param prop_by Optional. A grouping variable to compute proportions within each group.
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
