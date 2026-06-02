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

# #' @importFrom pointblank specially
# add_pb_note <- function(agent, label) {
#   pointblank::specially(agent, fn = ~ TRUE, label = label)
# }

# #' A simple function to compute missingness indicators
# #' 
# #' @param x a vector of numeric values
# #' 
# #' @return a list with three elements, the number of observations,
# #' the number of missing observations and the missing rate

# compute_missingness <- function(x) {
#   ## Standalone worker: N, n_missing, pct_missing for a single vector.
#   ## Compute is.na once for efficiency.
#   na   <- is.na(x)
#   N    <- length(x)
#   list(N = N, n_missing = sum(na), pct_missing = sum(na) / N)
# }

#' Compute Missingness for All Variables by All Non-Numeric Group Variables
#'
#' For a given data.table, identifies non-numeric columns as group variables
#' and numeric columns as target variables, then computes \code{n_missing},
#' \code{N}, and \code{pct_missing} for every target × group-value combination
#' using a fast double-melt + join approach.
#'
#' @param dt A data.frame or data.table.
#' @param module Optional character scalar (e.g. \code{"contract"}) added as a
#'   \code{module} column to the result for downstream \code{rbindlist}.
#' @param group_cols Character vector of column names to use as grouping
#'   variables. Glob patterns (e.g. \code{"country_*"}) are resolved against
#'   the actual column names in \code{dt}. When \code{NULL} (the default),
#'   missingness is computed for each variable across the whole dataset with no
#'   grouping, returning one row per variable.
#'
#' @return When \code{group_cols = NULL}: a data.table with columns
#'   \code{target_var}, \code{n_missing}, \code{N}, \code{pct_missing}.
#'   Otherwise: a data.table with columns \code{group_var}, \code{group_val},
#'   \code{target_var}, \code{n_missing}, \code{N}, \code{pct_missing}, and
#'   (if \code{module} is supplied) \code{module}.
#'
#' @keywords internal
compute_missingness <- function(dt, 
                                module = NULL,
                                group_cols = NULL) {

  dt <- data.table::as.data.table(dt)

  ## NULL group_cols → overall (whole-dataset) missingness per variable
  if (is.null(group_cols)) {
    all_cols <- names(dt)
    result <- data.table::data.table(
      target_var  = all_cols,
      n_missing   = vapply(dt, function(x) sum(is.na(x)), integer(1)),
      N           = nrow(dt),
      pct_missing = vapply(dt, function(x) mean(is.na(x)), numeric(1))
    )
    if (!is.null(module)) result[, module := module]
    return(result[])
  }

  ## row index for joining — added before capturing column names so we can
  ## explicitly exclude it from both group and target measure.vars
  dt[, .row_id := .I]

  ## resolve group_cols to those actually present; exclude .row_id
  group_cols <- intersect(group_cols, setdiff(names(dt), ".row_id"))
  all_cols   <- setdiff(names(dt), ".row_id")

  if (length(group_cols) == 0) {
    dt[, .row_id := NULL]
    return(data.table::data.table())
  }

  ## pre-convert Date/POSIXt group columns to character so melt doesn't
  ## fall back to their integer representation when coercing to a common type
  date_group_cols <- group_cols[vapply(dt[, group_cols, with = FALSE],
                                       function(x) inherits(x, c("Date", "POSIXct", "POSIXlt")),
                                       logical(1))]
  if (length(date_group_cols) > 0) {
    tmp <- data.table::copy(dt)
    tmp[, (date_group_cols) := lapply(.SD, as.character), .SDcols = date_group_cols]
  } else {
    tmp <- dt
  }

  ## melt group cols → long: one row per (row_id, group_var, group_val)
  grp_long <- suppressWarnings(
    data.table::melt(
      tmp, id.vars = ".row_id", measure.vars = group_cols,
      variable.name = "group_var", value.name = "group_val",
      variable.factor = FALSE
    )
  )
  grp_long[, group_val := as.character(group_val)]

  ## melt ALL non-.row_id columns as targets
  ## suppressWarnings: mixed-type coercion to character is intentional;
  ## val is only ever passed to is.na()
  target_long <- suppressWarnings(
    data.table::melt(
      dt, id.vars = ".row_id", measure.vars = all_cols,
      variable.name = "target_var", value.name = "val",
      variable.factor = FALSE
    )
  )

  ## cross-join on row_id, exclude self-pairs (group_var == target_var),
  ## then aggregate
  result <- grp_long[
    target_long, on = ".row_id", allow.cartesian = TRUE
  ][group_var != target_var,
    .(n_missing = sum(is.na(val)), N = .N, pct_missing = mean(is.na(val))),
    by = .(group_var, group_val, target_var)]

  ## clean up row index from the original table
  dt[, .row_id := NULL]

  if (nrow(result) == 0) return(data.table::data.table())
  if (!is.null(module)) result[, module := module]

  result
}




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
#'   \item \code{missing_in_data}: Variables present in the dictionary but not in the dataset.
#'   \item \code{extra_in_data}: Variables in the dataset that are not in the dictionary.
#'   \item \code{formatted}: A formatted character output according to \code{output_format}.
#' }
#'
#' @export
compare_to_dictionary <- function(data, dict_names, output_format = "simple") {
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

check_key_uniqueness <- function(dt, keys) {
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
#' @export
check_orphan_id <- function(parent_dt,
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
check_salary <- function(dt,
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
  