#' Compute the average wage
#'
#' Computes the average wage for each group within each reference group,
#' usually a reference date, and how much it grew since the previous
#' reference group.
#'
#' @param data Data frame or remote database table (`tbl_dbi`) with the
#'   column named in `reference_group_col` and the pay column named in
#'   `measure_col`.
#' @param measure_col Character. Name of the pay column to average. Default
#'   `"gross_salary_lcu"`.
#' @param group_cols Character vector of columns to group by, or `NULL` to
#'   average over everyone. Must not include `reference_group_col`.
#' @param reference_group_col Character. Name of the column that defines the
#'   reference groups, usually a date. Growth compares each reference group
#'   with the one before it in sorted order. Default `"ref_date"`.
#' @param ... Arguments passed to methods.
#'
#' @returns A table with the grouping columns, `reference_group_col`, `wage`
#'   (the average of `measure_col`) and `wage_growth` (the change from the
#'   previous reference group as a proportion, so `0.1` means 10% growth). A
#'   data.table for data frame input; a lazy table for `tbl_dbi` input (use
#'   [dplyr::collect()] to bring it into memory).
#'
#' @details
#' The average is taken over rows, so with contract data it is the average
#' pay per contract. Missing wage values are skipped. If every wage value for
#' a group in a reference group is missing, its wage is `NA`.
#'
#' As in [compute_wagebill()], every group appears in every reference group in
#' `data`. A group with no records in a reference group gets `wage = NA`, so
#' gaps stay visible and growth is never measured across a gap.
#'
#' `wage_growth` is `NA` in the first reference group, and whenever the
#' current or previous wage is `NA`.
#'
#' @examples
#' compute_wage(
#'   bra_hrmis_contract,
#'   group_cols = "contract_type"
#' )
#'
#' @export
compute_wage <- function(data, ...) {
  UseMethod("compute_wage")
}

#' @rdname compute_wage
#' @importFrom data.table := as.data.table setorderv shift
#' @importFrom rlang check_dots_empty
#' @export
compute_wage.data.frame <- function(
  data,
  measure_col = "gross_salary_lcu",
  group_cols = NULL,
  reference_group_col = "ref_date",
  ...
) {
  rlang::check_dots_empty()

  if (reference_group_col %in% group_cols) {
    stop("`", reference_group_col, "` should not be included in `group_cols`")
  }

  by_cols <- c(group_cols, reference_group_col)
  dt <- data.table::as.data.table(data)

  # leave out missing pay, so a group whose pay is all missing in a period has
  # no average here and gets wage = NA from the panel below
  wage <- dt[
    !is.na(get(measure_col)),
    .(wage = mean(get(measure_col))),
    by = by_cols
  ]

  # complete the group x period panel, as in the tbl_dbi method, so a group
  # absent in a period gets wage = NA instead of being dropped
  reference_values <- unique(dt[, ..reference_group_col])
  panel <- reference_values

  if (!is.null(group_cols)) {
    # repeat every reference value for every group
    panel <- unique(dt[, ..group_cols])[,
      as.list(reference_values),
      by = group_cols
    ]
  }

  wage <- wage[panel, on = by_cols]

  data.table::setorderv(wage, by_cols)

  wage[,
    wage_lag := data.table::shift(wage, type = "lag"),
    by = group_cols
  ]
  wage[, wage_growth := (wage - wage_lag) / wage_lag]
  wage[, wage_lag := NULL]

  wage[]
}

#' @rdname compute_wage
#' @importFrom dplyr across all_of distinct everything inner_join lag left_join
#'   mutate select summarise
#' @importFrom rlang check_dots_empty .data
#' @export
compute_wage.tbl_dbi <- function(
  data,
  measure_col = "gross_salary_lcu",
  group_cols = NULL,
  reference_group_col = "ref_date",
  ...
) {
  rlang::check_dots_empty()

  if (reference_group_col %in% group_cols) {
    stop("`", reference_group_col, "` should not be included in `group_cols`")
  }

  by_cols <- c(group_cols, reference_group_col)

  wage <- data |>
    summarise(
      # SQL's AVG() skips missing pay, and is NULL (NA) when all pay is missing
      wage = mean(.data[[measure_col]], na.rm = TRUE),
      .by = all_of(by_cols)
    )

  if (!is.null(group_cols)) {
    # complete the group x period panel, crossing through a constant key, so
    # a group absent in a period gets wage = NA instead of being dropped
    reference_values <- data |>
      distinct(across(all_of(reference_group_col)))

    group_values <- data |>
      select(all_of(group_cols)) |>
      distinct()

    wage <- reference_values |>
      mutate(key = 1) |>
      inner_join(
        group_values |> mutate(key = 1),
        by = "key"
      ) |>
      select(-key) |>
      # keep missing groups: sql joins do not match NA keys by default
      left_join(
        wage,
        by = by_cols,
        na_matches = "na"
      )
  }

  wage |>
    mutate(
      wage_lag = lag(wage, order_by = .data[[reference_group_col]]),
      wage_growth = (wage - wage_lag) / wage_lag,
      .by = all_of(group_cols)
    ) |>
    select(
      all_of(by_cols),
      everything(),
      -wage_lag
    )
}
