#' Compute standard wagebill indicators
#'
#' Produces a standard set of wagebill indicators in one call: how much
#' government spends on pay, where that spending goes, how average pay
#' evolves, what pay is made of, and how pay is distributed. Each indicator
#' comes from an existing govhr function, so the results match what those
#' functions return on their own.
#'
#' @param data Data frame or remote database table (`tbl_dbi`) with one row
#'   per contract and reference date. Must contain `ref_date`, `est_id`, and
#'   the columns named in `measure_col` and `wage_component_cols`.
#' @param binwidth Positive whole number. Width of the pay bins used for the
#'   wage distribution, in the same currency as `measure_col` (for example
#'   `1e6` for wages in the millions). See [compute_percentile()].
#' @param measure_col Character. Pay column used for totals, averages and the
#'   distribution. Default `"gross_salary_lcu"`.
#' @param wage_component_cols Character vector of wage columns that add up to total
#'   pay, used for the composition of the wages. Default
#'   `c("base_salary_lcu", "allowance_lcu")`.
#'
#' @returns A named list of tables:
#' \describe{
#'   \item{wagebill}{Wagebill and its growth for each `ref_date`, from
#'     [compute_wagebill()].}
#'   \item{wagebill_by_est}{Wagebill, share of the total and growth for each
#'     establishment and `ref_date`, from [compute_wagebill()].}
#'   \item{wage}{Average wage and its growth for each `ref_date`, from
#'     [compute_wage()].}
#'   \item{wage_by_est}{Average wage and its growth for each establishment
#'     and `ref_date`, from [compute_wage()].}
#'   \item{composition}{Wagebill, share and growth of each pay component
#'     (`component`) for each `ref_date`, from [compute_wagebill()].}
#'   \item{distribution}{Share of contracts in each pay bin, from
#'     [compute_percentile()].}
#' }
#' Each table has the class its function returns for `data`: data.tables for
#' data frame input, lazy tables for `tbl_dbi` input (use [dplyr::collect()] to
#' bring them into memory).
#'
#' @details
#' `data` is passed as is to each indicator function, which picks the method
#' for its class, so a database table is processed in the database.
#'
#' Pay is used as given. To compare pay across years, convert it to real
#' terms first, for example with [deflate_to_real()].
#'
#' In `composition`, each component's share is of the sum of
#' `component_cols`, so the shares add up to 1 within each `ref_date`.
#'
#' The `distribution` pools contracts from all reference dates. Filter `data`
#' to one date first to see a single year.
#'
#' @examples
#' contracts <- data.frame(
#'   ref_date = as.Date(rep(c("2020-01-01", "2021-01-01"), each = 3)),
#'   est_id = c("A", "A", "B", "A", "B", "B"),
#'   base_salary_lcu = c(800, 900, 1000, 850, 950, 1100),
#'   allowance_lcu = c(200, 100, 300, 250, 150, 200)
#' )
#' contracts$gross_salary_lcu <- contracts$base_salary_lcu + contracts$allowance_lcu
#'
#' compute_wagebill_analytics(contracts, binwidth = 100)
#'
#' @importFrom dplyr all_of mutate select union_all
#' @export
compute_wagebill_analytics <- function(
  data,
  binwidth,
  measure_col = "gross_salary_lcu",
  wage_component_cols = c("base_salary_lcu", "allowance_lcu")
){
  required_cols <- unique(c("ref_date", "est_id", measure_col, component_cols))
  # colnames() rather than names(), which does not list a tbl_dbi's columns
  missing_cols <- setdiff(required_cols, colnames(data))
  if(length(missing_cols) > 0){
    stop("`data` is missing required columns: ", paste(missing_cols, collapse = ", "))
  }

  # 1. wagebill and its growth: overall and by establishment
  wagebill <- compute_wagebill(data, measure_col = measure_col)
  wagebill_by_est <- compute_wagebill(
    data,
    measure_col = measure_col,
    group_cols = "est_id"
  )

  # 2. average wage and its growth: overall and by establishment
  wage <- compute_wage(data, measure_col = measure_col)
  wage_by_est <- compute_wage(
    data,
    measure_col = measure_col,
    group_cols = "est_id"
  )

  # 3. wage composition: one wagebill per pay component, stacked into a long table.
  # union_all() rather than bind_rows(), which does not accept database tables
  wage_composition <- wage_component_cols |>
    purrr::map(
      \(component_col) compute_wagebill(data, measure_col = component_col) |>
        mutate(component = component_col)
    ) |>
    purrr::reduce(union_all) |>
    mutate(
      share_wagebill = wagebill / sum(wagebill, na.rm = TRUE),
      .by = all_of("ref_date")
    ) |>
    select(
      all_of(c(
        "ref_date", "component", "wagebill", "share_wagebill", "wagebill_growth"
      ))
    )

  # 4. distribution of pay, pooled over all reference dates
  distribution <- compute_percentile(
    data,
    measure_col = measure_col,
    binwidth = binwidth
  )

  list(
    wagebill = wagebill,
    wagebill_by_est = wagebill_by_est,
    wage = wage,
    wage_by_est = wage_by_est,
    composition = composition,
    distribution = distribution
  )
}
