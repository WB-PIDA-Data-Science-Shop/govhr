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