#' Compute the Wagebill
#'
#' Sums `measure_col` within each group and reference date, and reports each
#' group's share of the total wagebill and its growth from the previous
#' reference date.
#'
#' @param data Data frame containing a `ref_date` column and the measure.
#' @param measure_col Character. Numeric column to sum. Default
#'   `"gross_salary_lcu"`.
#' @param group_cols Character vector of columns to group by, or `NULL` for no
#'   grouping. Must not include `ref_date`.
#'
#' @returns A data frame with the grouping columns, `ref_date`, `wagebill`,
#'   `share_wagebill` (only when `group_cols` is not `NULL`) and
#'   `wagebill_growth`.
#'
#' @details
#' Missing values in `measure_col` are ignored. When `group_cols` is not
#' `NULL`, every group is expanded to every `ref_date` in `data`, so a group
#' absent in a period gets `wagebill = NA` rather than being dropped; groups
#' with `NA` in `group_cols` are kept. `wagebill_growth` is the relative change
#' from the group's previous reference date, and is `NA` in the first period
#' or when either period's wagebill is `NA`.
#'
#' @seealso [compute_growth_decomposition()] to decompose wagebill changes into
#'   employment and compensation effects.
#'
#' @examples
#' compute_wagebill(
#'   bra_hrmis_contract,
#'   group_cols = "contract_type"
#' )
#'
#' @export
compute_wagebill <- function(
  data,
  measure_col = "gross_salary_lcu",
  group_cols = NULL
) {
  if ("ref_date" %in% group_cols) {
    stop("`ref_date` should not be included in `group_cols`")
  }

  group_cols_with_date <- c(group_cols, "ref_date")

  wagebill <- data |>
    summarise(
      wagebill = sum(!!rlang::sym(measure_col), na.rm = TRUE),
      .by = all_of(
        group_cols_with_date
      )
    )

  if (!is.null(group_cols)) {
    wagebill <- wagebill |>
      mutate(
        share_wagebill = wagebill / sum(wagebill, na.rm = TRUE),
        .by = "ref_date"
      )

    # complete implicit missing reference dates
    calendar <- data |>
      distinct(ref_date)

    group_values <- data |>
      select(all_of(group_cols)) |>
      distinct()

    wagebill <- calendar |>
      mutate(key = 1) |>
      inner_join(
        group_values |> mutate(key = 1),
        by = "key"
      ) |>
      select(-key) |>
      # keep missing groups: sql joins do not match NA keys by default
      left_join(
        wagebill,
        by = group_cols_with_date,
        na_matches = "na"
      )
  }

  wagebill <- wagebill |>
    mutate(
      wagebill_lag = lag(wagebill, order_by = ref_date),
      wagebill_growth = (wagebill - wagebill_lag) / wagebill_lag,
      .by = all_of(group_cols)
    ) |>
    select(-wagebill_lag)

  wagebill
}
