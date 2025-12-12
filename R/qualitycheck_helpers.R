#' Flag outliers based on the IQR rule
#'
#' This function flags values in a numeric vector as outliers if they
#' fall below Q1 - 1.5 * IQR or above Q3 + 1.5 * IQR.
#'
#' @param x A numeric vector.
#'
#' @return A logical vector of the same length as `x`, where `TRUE`
#'   indicates the observation is an outlier.
#'
#' @examples
#' x <- c(1, 2, 2, 3, 4, 5, 100)
#' flag_outlier(x)
#' # Returns TRUE only for the value 100
#'
#' @export
flag_outlier <- function(x) {
  q1 <- quantile(x, 0.25, na.rm = TRUE)
  q3 <- quantile(x, 0.75, na.rm = TRUE)
  iqr <- q3 - q1

  lower <- q1 - (1.5 * iqr)
  upper <- q3 + (1.5 * iqr)

  x < lower | x > upper
}

#' Compare the contents of two character vectors
#'
#' This function compares two vectors and identifies:
#'
#' \itemize{
#'   \item Elements in \code{x} that are missing in \code{y}.
#'   \item Elements in \code{y} that are missing in \code{x}.
#' }
#'
#' It returns both the raw differences and formatted HTML output for use
#' in reports, Shiny apps, or pointblank validation messages.
#'
#' Three output formats are supported:
#'
#' \describe{
#'   \item{\code{"simple"}}{Colored comma-separated strings (HTML).}
#'   \item{\code{"bullet"}}{HTML unordered lists.}
#'   \item{\code{"badges"}}{Bootstrap-style colored badges.}
#' }
#'
#' @param x A vector of values to compare.
#' @param y A second vector of values to compare with \code{x}.
#' @param output_format Character string indicating the output format.
#'   Must be one of \code{"simple"}, \code{"bullet"}, or \code{"badges"}.
#'
#' @return A named list containing:
#'
#' \describe{
#'   \item{\code{missing}}{Formatted HTML showing values in \code{x} but not in \code{y}.}
#'   \item{\code{extra}}{Formatted HTML showing values in \code{y} but not in \code{x}.}
#'   \item{\code{x_missing_y}}{Raw vector of elements in \code{x} but not in \code{y}.}
#'   \item{\code{y_missing_x}}{Raw vector of elements in \code{y} but not in \code{x}.}
#' }
#'
#' @examples
#' x <- c("a", "b", "c")
#' y <- c("b", "c", "d")
#'
#' compare_names_qc(x, y)
#' compare_names_qc(x, y, output_format = "bullet")
#' compare_names_qc(x, y, output_format = "badges")
#'
#' @export



compare_names_qc <- function(x, y,
                             output_format = c("simple", "bullet", "badges")) {

  # match argument for output format
  output_format <- match.arg(output_format)

  # find differences
  x_missing_y <- setdiff(x, y) ## x but not y
  y_missing_x <- setdiff(y, x) ## y but not x

  # --- formatters -----------------------------------------------------------

  format_simple <- function(vec, empty_color = "green", color = "red") {
    if (length(vec) == 0) {
      sprintf("<span style='color:%s; font-weight:bold;'>None</span>", empty_color)
    } else {
      sprintf(
        "<span style='color:%s; font-weight:bold;'>%s</span>",
        color,
        paste(vec, collapse = ", ")
      )
    }
  }

  format_bullet <- function(vec) {
    if (length(vec) == 0) {
      "<span style='color:green; font-weight:bold;'>None</span>"
    } else {
      paste0(
        "<ul style='margin-left:0; padding-left:1em;'>",
        paste(sprintf("<li>%s</li>", vec), collapse = ""),
        "</ul>"
      )
    }
  }

  format_badges <- function(vec, empty_color = "#4caf50", color = "#d32f2f") {
    if (length(vec) == 0) {
      sprintf(
        "<span style='background:%s;color:white;padding:2px 6px;border-radius:4px;'>None</span>",
        empty_color
      )
    } else {
      sprintf(
        "<span style='background:%s;color:white;padding:2px 6px;border-radius:4px;'>%s</span>",
        color,
        paste(vec, collapse = ", ")
      )
    }
  }

  # --- choose output format -------------------------------------------------

  if (output_format == "simple") {
    missing_str <- format_simple(x_missing_y)
    extra_str   <- format_simple(y_missing_x, color = "orange")

  } else if (output_format == "bullet") {
    missing_str <- format_bullet(x_missing_y)
    extra_str   <- format_bullet(y_missing_x)

  } else if (output_format == "badges") {
    missing_str <- format_badges(x_missing_y, empty_color = "#4caf50", color = "#d32f2f")
    extra_str   <- format_badges(y_missing_x, empty_color = "#4caf50", color = "#ff9800")
  }

  # return a clean list
  mismatch_list <- list(missing = missing_str,
                        extra   = extra_str,
                        x_missing_y = x_missing_y,
                        y_missing_x = y_missing_x)

  return(mismatch_list)

}

add_pb_note <- function(agent, label) {
  specially(agent, fn = ~ TRUE, label = label)
}

#' Compute Missingness Counts and Percentages
#'
#' Computes the number and percentage of missing values for each variable
#' in a dataset. The function supports both overall missingness (when
#' \code{by = NULL}) and grouped missingness (when grouping variables are
#' supplied through the \code{by} argument).
#'
#' When \code{by = NULL}, the function returns one row per variable with the
#' total number of missing values and the percent missing out of all rows.
#' When \code{by} is provided, missingness is computed within each group,
#' and the percent missing is calculated relative to the group size.
#'
#' @param data A data.frame or data.table containing the dataset to analyze.
#' @param by Optional. A character vector of column names specifying grouping
#'   variables. If \code{NULL}, missingness is computed for the full dataset.
#'
#' @return A data.table in long format with columns:
#'   \describe{
#'     \item{\code{by}}{(if provided) Grouping variables.}
#'     \item{\code{variable}}{The variable name.}
#'     \item{\code{n_missing}}{Number of missing values.}
#'     \item{\code{pct_missing}}{Percentage of missingness within group or overall.}
#'   }
#'
#' @examples
#' \dontrun{
#' compute_missingness(df)                # overall missingness
#' compute_missingness(df, by = "contract_type_code") # missingness by contract type
#' }
#'
#' @importFrom data.table as.data.table melt merge.data.table
#' @export
compute_missingness <- function(data,
                                by = NULL) {

  ## convert to data.table
  dt <- as.data.table(data)

  ## if by = NULL, we treat it as having no groups
  if (is.null(by)) {

    ## overall missingness
    missing_dt <- dt[, lapply(.SD, function(x) sum(is.na(x)))]

    ## reshape to long
    missing_dt <- melt(
      missing_dt,
      measure.vars = names(missing_dt),
      variable.name = "variable",
      value.name = "n_missing"
    )

    ## add percent missing
    missing_dt[, pct_missing := n_missing / nrow(dt)]

    return(missing_dt[])

  } else {

    ## grouped missingness
    missing_dt <- dt[, lapply(.SD, function(x) sum(is.na(x))),
                     .SDcols = setdiff(names(dt), by),
                     by = by]

    ## melt long
    missing_dt <- melt(
      missing_dt,
      id.vars = by,
      variable.name = "variable",
      value.name = "n_missing"
    )

    ## group-specific denominator
    totals_dt <- dt[, .N, by = by]

    ## merge totals
    missing_dt <- data.table::merge.data.table(missing_dt, totals_dt, by = by, all.x = TRUE)

    ## compute group-wise percent missing
    missing_dt[, pct_missing := n_missing / N]

    ## drop the total count column
    missing_dt[, N := NULL]

    return(missing_dt[])
  }
}


## a few more helper functions to create quality control objects

#' Compare Dataset Variable Names Against a Dictionary
#'
#' This internal function checks whether all required variable names defined in a
#' harmonization dictionary exist in a module dataset. It returns differences in
#' a user-specified output format.
#'
#' @param data A data.frame or data.table to check.
#' @param dict_names A character vector of variable names expected in the dataset.
#' @param output_format Output format for reporting differences.
#'   Options are \code{"simple"}, \code{"bullet"}, or \code{"badges"}.
#'
#' @return A list containing:
#' \itemize{
#'   \item{\code{missing_in_data}}{ Variables present in the dictionary but not in the dataset.}
#'   \item{\code{extra_in_data}}{ Variables in the dataset that are not in the dictionary.}
#'   \item{\code{formatted}}{ A formatted character output according to \code{output_format}.}
#' }
#'
#' @keywords internal

qc_compare_names <- function(data, dict_names, output_format = "simple") {
  compare_names_qc(
    x = names(data),
    y = dict_names,
    output_format = output_format
  )
}

#' Check Primary Key Uniqueness in a Dataset
#'
#' This internal function tests whether a combination of variables uniquely
#' identifies rows in a dataset. It reports the number of duplicate keys and
#' returns the duplicate rows if any are found.
#'
#' @param dt A data.table containing the module to check.
#' @param keys A character vector specifying the primary key columns.
#'
#' @return A list with:
#'
#' \describe{
#'   \item{\code{n_duplicates}}{Number of duplicated key combinations.}
#'   \item{\code{duplicate_rows}}{A data.table of problematic records (if any).}
#' }
#'
#' @keywords internal

qc_primary_key_uniqueness <- function(dt, keys) {
  dt <- as.data.table(dt)

  dupe_rows <- dt[, .N, by = keys][N > 1]

  list(
    is_unique = nrow(dupe_rows) == 0,
    duplicate_groups = dupe_rows
  )
}

#' Detect Orphan Records Between Parent and Child Modules
#'
#' This internal function checks for referential integrity violations between
#' two datasets. It identifies child IDs that do not exist in the parent module.
#'
#' @param parent_dt A data.table representing the upstream (parent) dataset.
#' @param child_dt A data.table representing the downstream (child) dataset.
#' @param parent_id Name of the ID column in the parent dataset.
#' @param child_id Name of the ID column in the child dataset.
#'
#' @return A list containing:
#'
#' \describe{
#'   \item{\code{n_orphans}}{Number of child IDs not found in the parent.}
#'   \item{\code{orphan_ids}}{The vector of orphan IDs.}
#' }
#'
#' @keywords internal

qc_merge_check <- function(parent_dt,
                           child_dt,
                           parent_id,
                           child_id) {

  missing_ids <- setdiff(
    unique(child_dt[[child_id]]),
    unique(parent_dt[[parent_id]])
  )

  list(
    n_missing = length(missing_ids),
    missing_ids = missing_ids
  )
}

#' Validate Salary Variables for Logic and Numeric Integrity
#'
#' This internal function checks selected salary columns for numeric type,
#' non-negativity, and logical relationships (e.g., base salary ≤ gross salary).
#'
#' @param dt A data.table containing salary variables.
#' @param cols A character vector of salary-related column names to evaluate.
#'
#' @return A list with:
#'
#' \describe{
#'   \item{\code{variable_checks}}{Numeric type and negativity checks for each salary variable.}
#'   \item{\code{logical_salary_relationships}}{Counts of violations in salary ordering logic.}
#' }
#'
#' @keywords internal
qc_salary_checks <- function(dt,
                             cols) {

  dt <- as.data.table(dt)

  out <- list()

  # numeric / non-negative
  # num_vars <- c("base_salary_lcu",
  #               "gross_salary_lcu",
  #               "net_salary_lcu")

  # for (v in num_vars) {
  #   out[[v]] <- list(
  #     n_non_numeric = sum(!is.numeric(dt[[v]])),
  #     n_negative    = sum(dt[[v]] < 0, na.rm = TRUE),
  #     summary       = summary(dt[[v]])
  #   )
  # }

  out <- lapply(X = cols,
                FUN = function(x){

                  n_non_numeric <- sum(!is.numeric(dt[[x]]))
                  n_negative <- sum(dt[[x]] < 0, na.rm = TRUE)
                  summary <- summary(dt[[x]])

                  return(list(n_non_numeric,
                              n_negative,
                              summary))

                })

  # basic <= gross >= net checks
  out$logical_salary_relationships <- dt[, .(base_gt_gross = sum(base_salary_lcu > gross_salary_lcu,
                                                                 na.rm = TRUE),
                                             net_gt_gross  = sum(net_salary_lcu  > gross_salary_lcu,
                                                                 na.rm = TRUE))]

  return(out)
}


