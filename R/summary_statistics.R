#' Compute grouped summary statistics for multiple variables
#'
#' @description
#' A flexible wrapper around `dplyr::summarise()` and `dplyr::across()` that
#' computes one or more summary statistics for a set of numeric variables,
#' optionally grouped by one or more categorical variables. Users can choose
#' from built-in summary functions defined in [define_fns()] or supply their own.
#'
#' @param data A data frame or tibble containing the variables to summarize.
#'
#' @param cols A character vector of variable names to summarize, or a list
#'   with an element `vars` (e.g., `list(vars = c("var1", "var2"))`).
#'
#' @param fns Optional. A specification of the summary functions to apply:
#'   - `NULL` (default): applies all default functions returned by [define_fns()].
#'   - A **character vector** of function names (e.g., `c("mean", "sd")`)
#'     referring to defaults in [define_fns()].
#'   - A **list** of formulas (e.g., `list(mean = ~mean(.x, na.rm = TRUE))`)
#'     or a mix of character names and formulas.
#'
#' @param groups A character vector of grouping variables used for aggregation.
#'
#' @param output Character, either `"long"` or `"wide"`. If `"long"`, reshapes
#'   the results into a tidy format with columns `indicator` and `value`.
#'   Defaults to `"long"`.
#'
#' @return
#' A tibble containing grouped summary statistics.
#' - If `output = "wide"`, each statistic appears as a separate column.
#' - If `output = "long"`, the data are in tidy (long) format with one row per
#'   group-variable-statistic combination.
#'
#' @details
#' This function simplifies grouped summaries by handling:
#' - Flexible function definitions (`fns`) using formula notation `~expr(.x)`.
#' - Integration with user-defined functions via [define_fns()].
#' - Optional long/wide reshaping for tidy analysis workflows.
#'
#' @section Default Functions:
#' The default functions are defined in [define_fns()] and typically include:
#' `sum`, `mean`, `median`, `cv`, and `cp_ratio`. These can be customized or
#' extended by modifying `define_fns()`.
#'
#' @examples
#' df <- tibble::tibble(
#'   country = rep(c("A", "B"), each = 5),
#'   year = rep(2020:2021, times = 5),
#'   income = runif(10, 1000, 2000),
#'   expenditure = runif(10, 500, 1500)
#' )
#'
#'  # Default summaries by country and year
#' compute_summary(data = df,
#'                 cols = c("income", "expenditure"),
#'                 groups = c("country", "year"),
#'                 fns = "mean")
#'
#'  # Select specific functions
#'  compute_summary(data = df,
#'                 cols = c("income"),
#'                 groups = c("country"),
#'                 fns = c("mean", "sd"),
#'                 output = "wide")
#'
#'  # Custom function
#'  compute_summary(df,
#'                 cols = "income",
#'                 groups = "country",
#'                 fns = list("cv",
#'                            q90 = ~quantile(.x, 0.9, na.rm = TRUE)))
#'
#' @seealso [define_fns()], [dplyr::summarise()], [tidyr::pivot_longer()]
#' @importFrom dplyr group_by summarise across all_of n_distinct
#' @importFrom tidyr pivot_longer
#' @importFrom glue glue
#' @importFrom rlang is_formula
#' @export

compute_summary <- function(data,
                            cols,
                            fns = NULL,
                            groups = NULL,
                            output = c("long", "wide")) {

  # --- 0. Match output argument ---
  output <- match.arg(output)

  # --- 1. Define default summary functions ---
  default_fns <- define_fns()

  # --- 2. Resolve which functions to use ---
  if (is.null(fns)) {
    # No functions specified → use all defaults
    selected_fns <- default_fns

  } else if (is.character(fns)) {
    # Character vector → use named defaults
    unknown <- setdiff(fns, names(default_fns))
    if (length(unknown) > 0) {
      stop(glue::glue("Unknown function name(s): {toString(unknown)}"))
    }
    selected_fns <- default_fns[fns]

  } else if (is.list(fns)) {
    # List of formulas or a mix (character names + formulas)
    char_fns <- fns[sapply(fns, is.character)]
    formula_fns <- fns[sapply(fns, rlang::is_formula)]

    # Add default functions where names are characters
    selected_fns <- c(
      default_fns[intersect(unlist(char_fns), names(default_fns))],
      formula_fns
    )
  } else {
    stop("`fns` must be NULL, a character vector, or a list of formulas.")
  }

  # --- 3. Handle cols input (list or character vector) ---
  if (is.list(cols) && !is.null(cols$vars)) {
    summary_vars <- cols$vars
  } else if (is.character(cols)) {
    summary_vars <- cols
  } else {
    stop("`cols` must be a character vector or a list with element `vars`.")
  }

  # --- 4. Identify grouping variables ---
  group_vars <- groups

  # --- 5. Compute summaries ---
  stats_df <-
    data |>
    dplyr::group_by(dplyr::across(dplyr::all_of(group_vars))) |>
    dplyr::summarise(
      dplyr::across(
        dplyr::all_of(summary_vars),
        selected_fns,
        .names = "{.col}_{.fn}"
      ),
      .groups = "drop"
    )

  # --- 6. Reshape output if requested ---
  if (output == "long") {
    stats_df <- stats_df |>
      tidyr::pivot_longer(
        cols = tidyselect::matches(paste(summary_vars,
                                         collapse = "|")),
        names_to = "indicator",
        values_to = "value"
      )
  }

  return(stats_df)
}


#' Fast Summary Statistics by Group
#'
#' Computes summary statistics for specified numeric columns in a data frame or data.table,
#' optionally grouped by one or more categorical variables. This function supports both
#' predefined summary functions (e.g., mean, sum) and user-specified formulas. It returns
#' results in either long or wide format, and can optionally convert the output to a tibble.
#'
#' @param data A data.table or data.frame containing the data to summarize.
#' @param cols A character vector specifying the names of numeric columns to summarize.
#' @param fns Optional. A character vector or list of formulas specifying the summary functions
#' to apply. If NULL, default functions defined by define_fns() are used.
#' - If a character vector, function names must match those in the defaults (e.g., "mean", "sum").
#' - If a list, can contain formulas or a mix of character names and formulas.
#' @param groups A character vector specifying one or more grouping variables.
#' @param output A character string specifying the output format. Must be one of:
#' - "long": produces a tall table with an indicator column and a value column.
#' - "wide": produces a wide table with one column per statistic.
#' @param tbl Logical. If TRUE, converts the resulting data.table into a tibble.
#'
#' @details
#' The function first matches the output argument, loads default summary functions from
#' define_fns(), and determines which functions to apply based on user input. It uses
#' efficient data.table operations for grouped computation, and optionally reshapes the
#' output to long format with data.table::melt().
#'
#' @return A data.table (or tibble if tbl = TRUE) containing summary statistics by group,
#' either in long or wide format.
#'
#' @examples
#' \dontrun{
#' # Example usage:
#' compute_fastsummary(
#' data = contract_harmonized |> as.data.table(),
#' cols = c("base_salary_lcu", "gross_salary_lcu"),
#' fns = c("mean", "sum"),
#' groups = c("occupation_isconame", "year"),
#' output = "long"
#' )
#' }
#'
#' @seealso [define_fns()], [data.table::melt()], [tibble::as_tibble()]
#'
#' @importFrom data.table as.data.table melt :=
#' @importFrom tibble as_tibble
#' @importFrom glue glue
#' @importFrom rlang is_formula
#' @importFrom stats setNames
#'
#' @export


compute_fastsummary <- function(data,
                                cols,
                                fns = NULL,
                                groups,
                                output = c("long", "wide"),
                                tbl = FALSE){

  # --- 0. Match output argument ---
  output <- match.arg(output)

  # --- 1. Define default summary functions ---
  default_fns <- define_fns()

  # --- 2. Resolve which functions to use ---
  if (is.null(fns)) {
    # No functions specified → use all defaults
    selected_fns <- default_fns

  } else if (is.character(fns)) {
    # Character vector → use named defaults
    unknown <- setdiff(fns, names(default_fns))
    if (length(unknown) > 0) {
      stop(glue::glue("Unknown function name(s): {toString(unknown)}"))
    }
    selected_fns <- default_fns[fns]

  } else if (is.list(fns)) {
    # List of formulas or a mix (character names + formulas)
    char_fns <- fns[sapply(fns, is.character)]
    formula_fns <- fns[sapply(fns, rlang::is_formula)]

    # Add default functions where names are characters
    selected_fns <- c(
      default_fns[intersect(unlist(char_fns), names(default_fns))],
      formula_fns
    )
  } else {
    stop("`fns` must be NULL, a character vector, or a list of formulas.")
  }

  stats_dt <- data[, lapply_at(.SD, fns), .SDcols = cols, by = groups]

  # # --- compute summaries ---
  # stats_dt <- data[, lapply(.SD, function(col)
  #   sapply(selected_fns, function(fn) fn(col))),
  #   .SDcols = cols,
  #   by = groups]


  # --- 3. Optionally pivot to long format ---
  if (output == "long") {
    stats_dt <- data.table::melt(stats_dt,
                                 id.vars = groups,
                                 variable.name = "indicator",
                                 value.name = "value")
  }

  # --- 4. Quick transformation into tbl if needed

  if (tbl == TRUE){

    stats_dt <- stats_dt |> as_tibble()

  }

  return(stats_dt)

}

# compute_fastsummary <- function(data,
#                                  cols,
#                                  fns = NULL,
#                                  groups,
#                                  output = c("long", "wide"),
#                                  tbl = FALSE) {
#
#   output <- match.arg(output)
#   default_fns <- define_fns()
#
#   # --- resolve which functions to use ---
#   if (is.null(fns)) {
#     selected_fns <- default_fns
#   } else if (is.character(fns)) {
#     unknown <- setdiff(fns, names(default_fns))
#     if (length(unknown) > 0)
#       stop(glue::glue("Unknown function name(s): {toString(unknown)}"))
#     selected_fns <- default_fns[fns]
#   } else if (is.list(fns)) {
#     char_fns <- fns[sapply(fns, is.character)]
#     formula_fns <- fns[sapply(fns, rlang::is_formula)]
#     selected_fns <- c(
#       default_fns[intersect(unlist(char_fns), names(default_fns))],
#       formula_fns
#     )
#   } else stop("`fns` must be NULL, a character vector, or a list of formulas.")
#
#   # --- convert formulas into actual functions ---
#   selected_fns <- lapply(selected_fns, rlang::as_function)
#
#   # --- compute summaries ---
#   stats_dt <- data[, lapply(.SD, function(col)
#     sapply(selected_fns, function(fn) fn(col))),
#     .SDcols = cols,
#     by = groups]
#
#   if (output == "long") {
#     stats_dt <- data.table::melt(stats_dt,
#                                  id.vars = groups,
#                                  variable.name = "indicator",
#                                  value.name = "value")
#   }
#
#   if (tbl) stats_dt <- tibble::as_tibble(stats_dt)
#   return(stats_dt)
# }







#' Compute Shares of Summary Indicators Relative to Macro Indicators
#'
#' This function calculates the ratio (share) of summarized microdata indicators
#' to macro-level indicators (e.g., GDP, total population, etc.). It automatically
#' detects common join keys between the micro-level summary and macro-level data,
#' merges them, and computes the ratios for all possible combinations of
#' summarized and macro variables.
#'
#' @param data A data frame containing the microdata to be summarized.
#' @param macro_data A data frame containing macro-level indicators. Defaults to
#'   \code{macro_indicators} if available in the environment.
#' @param macro_cols A character vector specifying the names of the macro
#'   indicator columns in \code{macro_data} to use for share computation.
#' @param cols A named list passed to \code{compute_summary()}, specifying
#'   which variables to summarize (e.g. \code{list(vars = "varname")}).
#' @param groups A character vector specifying the grouping variables common to
#'   both datasets. Defaults to \code{c("country_code", "ref_date")}.
#' @param fns A list of summary functions passed to \code{compute_summary()},
#'   typically defined as formulas (e.g. \code{list(mean = ~mean(.x, na.rm = TRUE))}).
#' @param output Character string indicating the desired output format:
#'   \code{"long"} (default) for a tidy data frame with one row per share, or
#'   \code{"wide"} for a data frame with one column per computed indicator.
#'
#' @details
#' The function proceeds in five steps:
#' \enumerate{
#'   \item Summarizes the microdata using \code{compute_summary()}.
#'   \item Automatically detects join keys shared between the summary and macro data.
#'   \item Merges the summarized and macro data on those join keys.
#'   \item Computes the ratio of each summarized indicator to each macro indicator.
#'   \item Formats the output as either long or wide form, depending on the \code{output} argument.
#' }
#'
#' The output always includes the computed shares (e.g. \code{employment_per_GDP}),
#' as well as the underlying macro and summary values used to compute them.
#'
#' @return
#' A data frame containing the computed ratios (shares).
#' If \code{output = "long"}, columns include:
#' \itemize{
#'   \item Grouping variables (e.g., \code{country_code}, \code{ref_date})
#'   \item \code{macro_var}, \code{macro_value}
#'   \item \code{summary_var}, \code{summary_value}
#'   \item \code{indicator} – constructed name of the ratio
#'   \item \code{value} – computed share
#' }
#' If \code{output = "wide"}, each ratio indicator is returned as a separate column.
#'
#' @examples
#' \dontrun{
#' # Example usage
#' compute_share(data = contract_harmonized,
#'               macro_cols = c("gdp_lcu", "prevenue_lcu"),
#'               cols = c("gross_salary_lcu", "net_salary_lcu"),
#'               fns = c("mean", "sum"),
#'               output = "wide")
#' }
#'
#' @seealso \code{\link{compute_summary}}
#'
#' @importFrom dplyr left_join select mutate distinct
#' @importFrom tidyr pivot_longer pivot_wider
#' @export

compute_share <- function(data,
                          macro_data = macro_indicators,
                          macro_cols,
                          cols,
                          groups,
                          fns,
                          output = c("long", "wide")) {
  ## ensure valid argument
  output <- match.arg(output)

  # --- 1. Compute summarized data ---
  summary_df <- compute_summary(data = data,
                                cols = cols,
                                fns = fns,
                                groups = groups,
                                output = "wide")

  # --- 2. Detect join keys automatically ---
  join_vars <- intersect(names(summary_df), names(macro_data))
  if (length(join_vars) == 0)
    stop("No common grouping variables found between data and macro_data.")

  # --- 3. Merge with macro data ---
  merged_df <-
    summary_df |>
    left_join(macro_data |>
                select(all_of(c(join_vars, macro_cols))),
              by = join_vars)

  # --- 4. Compute shares (always work in long form internally) ---
  ratio_df <-
    merged_df |>
    pivot_longer(cols = all_of(macro_cols),
                 names_to = "macro_var",
                 values_to = "macro_value") |>
    pivot_longer(cols = setdiff(names(summary_df), join_vars),
                 names_to = "summary_var",
                 values_to = "summary_value") |>
    mutate(indicator = paste0(summary_var, "_per_", macro_var),
           value = summary_value / macro_value) |>
    select(all_of(join_vars), macro_var, macro_value,
           summary_var, summary_value, indicator, value)

  # --- 5. Format output ---
  if (output == "wide") {

    keep_df <-
      left_join(ratio_df |>
                  dplyr::select(all_of(join_vars),
                                macro_var,
                                macro_value) |>
                  unique() |>
                  pivot_wider(names_from = macro_var,
                              values_from = macro_value),
                ratio_df |>
                  dplyr::select(all_of(join_vars),
                                summary_var,
                                summary_value) |>
                  unique() |>
                  pivot_wider(names_from = summary_var,
                              values_from = summary_value),
                by = join_vars)


    ratio_df <-
      ratio_df |>
      distinct() |>  # prevent duplicates
      dplyr::select(all_of(join_vars), indicator, value) |>
      pivot_wider(names_from = indicator,
                  values_from = value) |>
      left_join(keep_df, by = join_vars)

  }


  return(ratio_df)
}


#' Compute ratio indicators of summarized variables over macro indicators
#'
#' `compute_fastshare()` summarizes selected numeric columns by specified groups,
#' merges the result with macroeconomic indicators, computes ratios
#' of summarized variables per macro variable, and returns either a
#' long or wide-format data.table.
#'
#' @param data A data.frame or data.table containing the raw data to summarize.
#' @param macro_data A data.frame or data.table containing macro-level indicators.
#'   Must share at least one common grouping variable with `data`. Default is `macro_indicators`.
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
#' @return A `data.table` containing:
#' - In `"long"` format: group variables, `macro_var`, `macro_value`, `summary_var`, `summary_value`, `indicator`, and `value`.
#' - In `"wide"` format: group variables, one column per indicator (`summary_var` per `macro_var`), and original macro and summary values.
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
#'   groups = c("country_code", "year")
#' )
#' }
#'
#' @importFrom data.table as.data.table melt dcast merge.data.table := setkeyv
#' @importFrom stats as.formula
#' @export


compute_fastshare <- function(data,
                              macro_data = macro_indicators |> as.data.table(),
                              macro_cols,
                              cols,
                              groups = c("country_code", "year"),
                              fns,
                              output = c("long", "wide")) {
  output <- match.arg(output)

  # --- 1. Compute summarized data ---
  summary_dt <- compute_fastsummary(
    data = data,
    cols = cols,
    fns = fns,
    groups = groups,
    output = "wide"
  )

  # --- 2. Detect join keys automatically ---
  join_vars <- intersect(names(summary_dt), names(macro_data))
  if (length(join_vars) == 0)
    stop("No common grouping variables found between data and macro_data.")

  setkeyv(summary_dt, join_vars)
  setkeyv(macro_data, join_vars)

  merged_dt <- macro_data[summary_dt]

  # --- 4. Compute shares (always work in long form internally) ---
  long_macro <- melt(
    merged_dt,
    measure.vars = macro_cols,
    variable.name = "macro_var",
    value.name = "macro_value"
  )

  long_summary <- melt(
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

  # --- 5. Format output ---
  if (output == "wide") {
    keep_macro <- unique(ratio_dt[, c(join_vars, "macro_var", "macro_value"), with = FALSE])
    keep_macro <- dcast(
      keep_macro,
      as.formula(paste(paste(join_vars, collapse = " + "), "~ macro_var")),
      value.var = "macro_value"
    )

    keep_summary <- unique(ratio_dt[, c(join_vars, "summary_var", "summary_value"), with = FALSE])
    keep_summary <- dcast(
      keep_summary,
      as.formula(paste(paste(join_vars, collapse = " + "), "~ summary_var")),
      value.var = "summary_value"
    )

    keep_dt <- merge(keep_macro, keep_summary, by = join_vars, all = TRUE)

    ratio_dt <- unique(ratio_dt[, c(join_vars, "indicator", "value"), with = FALSE])
    ratio_dt <- dcast(
      ratio_dt,
      as.formula(paste(paste(join_vars, collapse = " + "), "~ indicator")),
      value.var = "value"
    )

    ratio_dt <- merge(ratio_dt, keep_dt, by = join_vars, all.x = TRUE)
  }

  return(ratio_dt)
}

#' Compute Year-over-Year Growth for a Numeric Column
#'
#' This function calculates the year-over-year growth rate for a specified numeric
#' column in a data frame or tibble. It automatically completes missing time periods
#' based on the range of the date column, ensuring continuous sequences before
#' computing growth. Growth is computed only for consecutive years where both
#' the current and previous values are available. If a year is missing in the sequence,
#' the growth for the next available year is set to `NA`.
#'
#' @param data A data frame or tibble containing the variables of interest.
#' @param col The numeric column for which to compute growth (unquoted).
#' @param date_col The date or year column used to order and complete the data (unquoted).
#'
#' @details
#' The function uses `tidyr::complete()` to fill missing time periods between
#' `min(date_col)` and `max(date_col)`, and `dplyr::mutate()` to compute growth as:
#' \deqn{growth_t = \frac{x_t}{x_{t-1}} - 1}
#'
#' However, growth is only computed when the difference between consecutive
#' periods equals 1 (i.e., consecutive years). If the time gap is greater than one year,
#' the growth value is set to `NA`.
#'
#' @return
#' A tibble containing the original columns plus a new column that
#' holds the computed year-over-year growth rates.
#'
#' @importFrom dplyr arrange mutate if_else lag
#' @importFrom tidyr complete
#' @importFrom tibble tibble
#'
#' @examples
#' # Example data
#' df <- tibble::tibble(
#'   year = c(2020, 2021, 2023),
#'   gdp = c(100, 110, 130)
#' )
#'
#' # Compute year-over-year growth
#' compute_change(df, gdp, year)
#'
#'
#' @export
compute_change <- function(data, col, date_col) {
  col_name <- deparse(substitute(col))

  tbl <-
  data %>%
    tidyr::complete({{ date_col }} := full_seq(min({{ date_col }}):max({{ date_col }}), 1)) %>%
    dplyr::arrange({{ date_col }}) %>%
    dplyr::mutate(
      "{col_name}_growth" := {{ col }} / dplyr::lag({{ col }}) - 1
    )

  return(tbl)
}

#' Calculate year-over-year growth for a numeric column (data.table version)
#'
#' @description
#' Computes the year-over-year growth rate for a numeric column in a data.table.
#' The function ensures a complete sequence of years between the minimum and maximum
#' in the date column, fills in any missing years, and calculates the growth rate
#' using lagged values.
#'
#' @param data A data.table containing the data.
#' @param col A numeric column (either unquoted or as a string) for which the
#'   year-over-year growth rate will be calculated.
#' @param date_col A date or numeric column (either unquoted or as a string)
#'   used to order the data and define the time sequence (typically a year column).
#'
#' @return A data.table with:
#' \itemize{
#'   \item The completed `date_col` sequence.
#'   \item A new column named `"growth_<col>"` containing the year-over-year growth rates.
#' }
#'
#' @details
#' - Missing years in the sequence are added automatically.
#' - Missing values in `col` result in `NA` for the corresponding growth rate.
#' - The first observation (or any row where the lag is missing) will have `NA`.
#' - The function can accept both unquoted column names or strings.
#' - To compute growth rates by group (e.g., country), subset or loop by group before calling this function.
#'
#' @examples
#' library(data.table)
#'
#' dt <- data.table(
#'   year = c(2020, 2021, 2023),
#'   gdp = c(100, 110, 130)
#' )
#'
#'
#' # Using strings
#' compute_fastchange(dt, "gdp", "year")
#'
#' @importFrom data.table as.data.table setnames := shift
#'
#' @export


compute_fastchange <- function(data, col, date_col) {
  dt <- as.data.table(data)

  # if col/date_col are symbols, convert to strings
  if (!is.character(col)) col <- deparse(substitute(col))
  if (!is.character(date_col)) date_col <- deparse(substitute(date_col))

  # Generate full year sequence
  years_full <- seq(min(dt[[date_col]], na.rm = TRUE),
                    max(dt[[date_col]], na.rm = TRUE))

  # Complete the table
  dt_full <- data.table(years_full)
  setnames(dt_full, "years_full", date_col)
  dt_full <- merge(dt_full, dt[, .SD, .SDcols = c(date_col, col)],
                   by = date_col, all.x = TRUE)

  # Compute year-over-year growth
  growth_col <- paste0(col, "_growth")
  dt_full[, (growth_col) := get(col) / shift(get(col)) - 1]

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



































































































