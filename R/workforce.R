#' Compute standard workforce indicators
#'
#' Produces a standard set of workforce indicators in one call: how many
#' people work in government, where they work, how many join and leave, and
#' how many move between establishments. Each indicator comes from an existing
#' govhr function, so the results match what those functions return on their
#' own.
#'
#' @param data Data frame or remote database table (`tbl_dbi`) with one row
#'   per person (or contract) and reference date. Must contain `personnel_id`,
#'   `ref_date`, `est_id` and `employment_status` (with `"active"` marking
#'   people currently employed). Contract and personnel data usually need to be
#'   joined first.
#'
#' @returns A named list of tables:
#' \describe{
#'   \item{headcount}{Headcount for each `ref_date`, from [compute_headcount()].}
#'   \item{headcount_by_est}{Headcount and share of the total for each
#'     establishment and `ref_date`, from [compute_headcount()].}
#'   \item{movement}{Headcount, hires, separations and their rates for each
#'     `ref_date`, from [compute_movement()]. Hires are `NA` on the first date
#'     and separations on the last, since there is nothing to compare with.}
#'   \item{transitions}{Number of people moving between establishments, by
#'     origin (`from`), destination (`to`) and the date they arrived
#'     (`ref_date`), from [compute_transition()].}
#' }
#' Each table has the class its function returns for `data`: data.tables for
#' data frame input, lazy tables for `tbl_dbi` input (use [dplyr::collect()] to
#' bring them into memory).
#'
#' @details
#' `data` is passed as is to each indicator function, which picks the method
#' for its class, so a database table is processed in the database.
#'
#' Hires and separations are counted per person, so someone holding several
#' contracts on the same date is counted once.
#'
#' A person recorded in more than one establishment on the same date has no
#' single position that period, so [compute_transition()] leaves them out of
#' `transitions` and warns about it.
#'
#' @examples
#' workforce <- data.frame(
#'   personnel_id = rep(1:3, each = 3),
#'   ref_date = rep(as.Date(c("2020-01-01", "2021-01-01", "2022-01-01")), times = 3),
#'   est_id = c("A", "A", "A", "B", "B", "A", "A", "A", "B"),
#'   employment_status = c(
#'     "active", "active", "active",
#'     "inactive", "active", "active",
#'     "active", "active", "inactive"
#'   )
#' )
#' compute_workforce_analytics(workforce)
#'
#' @export
compute_workforce_analytics <- function(data){
  required_cols <- c("personnel_id", "ref_date", "est_id", "employment_status")
  # colnames() rather than names(), which does not list a tbl_dbi's columns
  missing_cols <- setdiff(required_cols, colnames(data))
  if(length(missing_cols) > 0){
    stop("`data` is missing required columns: ", paste(missing_cols, collapse = ", "))
  }

  # 1.1. headcount: overall
  headcount <- compute_headcount(data)

  # 1.2. headcount: by establishment
  headcount_by_est <- compute_headcount(data, group_cols = "est_id")

  # 2.1. hires and separations: overall
  movement <- compute_movement(data)

  # 2.2. transitions: by establishment
  transitions <- compute_transition(
    data,
    id_col = "personnel_id",
    group_cols = "est_id",
    summarize = TRUE
  )

  list(
    headcount = headcount,
    headcount_by_est = headcount_by_est,
    movement = movement,
    transitions = transitions
  )
}
