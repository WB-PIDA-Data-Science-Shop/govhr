#' Compute average wage
#' 
#' Computes the average wage by group.
#' 
#' @param data Data frame containing a `ref_date` column and the measure.
#' @param measure_col Character. Numeric column to average. Default is `"gross_salary_lcu"`.
#' @param group_cols Character vector of columns to group by. Default is `NULL`.
#'
#' @return A data frame with the average wage by group and reference date.
#' 
#' @importFrom dplyr summarise mutate all_of
#' @importFrom rlang sym
#' 
#' @export
#' 
#' @examples
#' compute_wage(
#'   bra_hrmis_contract,
#'   measure_col = "gross_salary_lcu",
#'   group_cols = c("occupation_native")
#' )
#' 
compute_wage <- function(data, measure_col = "gross_salary_lcu", group_cols = NULL){
  wage <- data |>
    dplyr::summarise(
      wage = mean(!!rlang::sym(measure_col), na.rm = TRUE),
      .by = dplyr::all_of(
        group_cols
      )
    )

  wage
}
