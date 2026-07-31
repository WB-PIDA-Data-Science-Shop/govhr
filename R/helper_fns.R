#' Sample groups and return all rows for those groups
#'
#' sample_group() randomly samples a specified number of unique values from a
#' grouping column and returns all rows belonging to the sampled groups.
#'
#' @param .data A data.frame, tibble, or data.table.
#' @param group Unquoted column name used to define groups.
#' @param n Integer; number of distinct groups to sample. If greater than the
#'   number of available groups, all groups are returned.
#'
#' @return An object of the same class as `.data` (tibble -> tibble,
#'   data.table -> data.table, data.frame -> data.frame) containing only rows
#'   whose group value was sampled.
#'
#' @examples
#' df <- tibble::tibble(id = 1:8, grp = rep(letters[1:4], each = 2))
#' sample_group(df, grp, 2)
#'
#' @export
#' @importFrom data.table as.data.table is.data.table
#' @importFrom rlang ensym as_string
#' @importFrom tibble is_tibble as_tibble
sample_group <- function(.data, group, n) {
  dt <- data.table::as.data.table(.data)
  group_sym <- rlang::ensym(group)
  group_col <- rlang::as_string(group_sym)

  uniq_vals <- unique(dt[[group_col]])
  if (length(uniq_vals) == 0 || as.integer(n) <= 0) {
    return(dt[0]) # empty result with same cols (data.table)
  }

  n_draw <- min(length(uniq_vals), as.integer(n))
  sampled_vals <- sample(uniq_vals, size = n_draw)

  res_dt <- dt[get(group_col) %in% sampled_vals]

  # return in same "type" the user passed: tibble -> tibble, data.frame -> data.frame, data.table -> data.table
  if (tibble::is_tibble(.data)) {
    tibble::as_tibble(res_dt)
  } else if (data.table::is.data.table(.data)) {
    res_dt
  } else {
    as.data.frame(res_dt)
  }
}

#' Convert Data to Match Original Class
#'
#' Converts a dataset to have the same class as another reference dataset.
#' This is useful for ensuring consistent output formats when performing
#' operations that temporarily convert data structures (e.g., between
#' `data.table`, `data.frame`, or `tibble`).
#'
#' @param data A dataset to be converted. Typically a `data.table` or `data.frame`.
#' @param data_original The original dataset whose class should be matched.
#'
#' @return The input \code{data} converted to the same class as \code{data_original}.
#'
#' @details
#' The function checks the class of \code{data_original} in the following order:
#' \itemize{
#'   \item If it is a tibble (`tbl_df`), \code{data} is converted using
#'     \code{tibble::as_tibble()}.
#'   \item If it is a base data frame but not a data.table, \code{data} is converted
#'     using \code{as.data.frame()}.
#'   \item Otherwise, \code{data} is returned unchanged (e.g., for data.table input).
#' }
#'
#' @examples
#' \dontrun{
#' df <- data.frame(x = 1:3)
#' dt <- data.table::as.data.table(df)
#'
#' # Convert dt back to data.frame to match df
#' convert_data(dt, df)
#'
#' # Convert to tibble if original was tibble
#' convert_data(dt, tibble::as_tibble(df))
#' }
#'
#' @importFrom tibble as_tibble
#'
convert_data <- function(data, data_original) {
  if ("tbl_df" %in% class(data_original)) {
    data <- tibble::as_tibble(data)
  } else if (
    "data.frame" %in%
      class(data_original) &&
      !"data.table" %in% class(data_original)
  ) {
    data <- as.data.frame(data)
  }
  return(data)
}

#' Guess the Reporting Frequency of the Reference Dates
#'
#' Evaluates a vector of reference dates and returns a single
#' string representing the data's reporting interval (e.g., "year", "month").
#' The function calculates the median day difference between consecutive dates.
#'
#' @param .data A dataset containing a column named \code{ref_date} with date values.
#'
#' @return A single character scalar: \code{"year"}, \code{"quarter"},
#'   \code{"month"}, \code{"week"}, or \code{"day"}.
#'
#' @export
#'
#' @examples
#' # Monthly reporting dates
#' data <- data.frame(
#'  ref_date = seq(as.Date("2020-01-01"), as.Date("2020-12-01"), by = "months")
#' )
#'
#' guess_date_frequency(data)
#' #> [1] "month"
#' @importFrom stats median
guess_date_frequency <- function(.data) {
  ref_date <- .data[["ref_date"]] |>
    unique() |>
    sort()

  median_days <- median(diff(as.Date(ref_date)), na.rm = TRUE)

  if (median_days >= 360) {
    return("year")
  }
  if (median_days >= 80) {
    return("quarter")
  }
  if (median_days >= 27) {
    return("month")
  }
  if (median_days >= 6) {
    return("week")
  }
  return("day")
}