#' Compute coverage of non-missing values in a dataset.
#'
#' @param data A data frame.
#' @param group_cols A string specifying the column name to group by. If NULL, coverage is computed for the entire data set.
#' @param include_ref_date A logical value indicating whether to include the `ref_date` column in the grouping.
#' @param aggregate A logical value indicating whether to aggregate coverage values by the `group`.
#' @param group Deprecated. Use `group_cols` instead.
#'
#' @importFrom data.table as.data.table
#' @importFrom tibble as_tibble
#'
#' @returns A data frame with coverage values for each column, optionally grouped by the specified `group`.
#' 
#' @export
compute_coverage <- function(
  data,
  group_cols = NULL,
  include_ref_date = FALSE,
  aggregate = FALSE,
  group = NULL
) {
  group_cols <- resolve_renamed_arg(group_cols, group, "group", "group_cols")
  dt <- data.table::as.data.table(data)
  data_cols <- colnames(dt)

  if (include_ref_date) {
    group_cols <- unique(c("ref_date", group_cols))
  }

  summary_cols <- setdiff(data_cols, group_cols)

  # wide: one coverage value per summary column, one row per group
  if (is.null(group_cols)) {
    coverage_wide <- dt[,
      lapply(.SD, \(col) (sum(!is.na(col)) / length(col)) * 100),
      .SDcols = summary_cols
    ]
  } else {
    coverage_wide <- dt[,
      lapply(.SD, \(col) (sum(!is.na(col)) / length(col)) * 100),
      by = c(group_cols),
      .SDcols = summary_cols
    ]
  }

  # long: pivot summary_cols into variable/coverage pairs
  coverage_data <- data.table::melt(
    coverage_wide,
    id.vars = group_cols,
    measure.vars = summary_cols,
    variable.name = "variable",
    value.name = "coverage",
    variable.factor = FALSE
  )

  if (aggregate) {
    coverage_data <- coverage_data[,
      .(coverage = mean(coverage, na.rm = TRUE)),
      by = c(group_cols)
    ]
  }

  tibble::as_tibble(coverage_data)
}


#' a function to compute the proportion of missing values in a data frame
#' @param data A data frame.
#' @param digits An integer specifying the number of decimal places to round the result to. Default is 2.
#'
#' @returns A numeric value representing the proportion of missing values in the data frame.
#' 
#' @export
compute_global_coverage <- function(data, digits = 2) {
  coverage <- 100 * mean(!is.na(data))

  coverage |>
    round(digits)
}
