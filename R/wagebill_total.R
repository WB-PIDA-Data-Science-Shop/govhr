#' Compute the wagebill
#'
#' Computes the wagebill (total pay) for each group within each reference
#' group, usually a reference date. It also reports each group's share of its
#' reference group's total wagebill, and how much the wagebill grew since the
#' previous reference group.
#'
#' @param data Data frame or remote database table (`tbl_dbi`) with the
#'   column named in `reference_group_col` and the pay column named in
#'   `measure_col`.
#' @param measure_col Character. Name of the pay column to add up. Default
#'   `"gross_salary_lcu"`.
#' @param group_cols Character vector of columns to group by, or `NULL` to
#'   add up everyone together. Must not include `reference_group_col`.
#' @param reference_group_col Character. Name of the column that defines the
#'   reference groups, usually a date. Shares are computed within each
#'   reference group, and growth compares each reference group with the one
#'   before it in sorted order. Default `"ref_date"`.
#' @param ... Arguments passed to methods.
#'
#' @returns A table with the grouping columns, `reference_group_col`,
#'   `wagebill`, `share_wagebill` (the group's share of its reference group's
#'   total, between 0 and 1; only when `group_cols` is given) and
#'   `wagebill_growth` (the change from the previous reference group as a
#'   proportion, so `0.1` means 10% growth). A data.table for data frame
#'   input; a lazy table for `tbl_dbi` input (use [dplyr::collect()] to bring
#'   it into memory).
#'
#' @details
#' Missing wage values are skipped when adding up. If every wage value for a
#' group in a reference group is missing, its wagebill is `NA` rather than 0,
#' so missing data is not mistaken for zero pay.
#'
#' When `group_cols` is given, every group appears in every reference group
#' in `data`. A group with no records in a reference group gets
#' `wagebill = NA`, so gaps stay visible instead of disappearing. Rows with a
#' missing group value are kept as their own group.
#'
#' `wagebill_growth` is `NA` in the first reference group, and whenever the
#' current or previous wagebill is `NA`.
#'
#' @seealso [compute_growth_decomposition()] to split wagebill changes into
#'   the part due to headcount and the part due to average pay.
#'
#' @examples
#' compute_wagebill(
#'   bra_hrmis_contract,
#'   group_cols = "contract_type",
#'   reference_group_col = "ref_date"
#' )
#'
#' @export
compute_wagebill <- function(data, ...) {
  UseMethod("compute_wagebill")
}

#' @rdname compute_wagebill
#' @importFrom data.table := as.data.table setorderv shift
#' @importFrom rlang check_dots_empty
#' @export
compute_wagebill.data.frame <- function(
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
  # no total here and gets wagebill = NA from the panel below (as SQL's SUM()
  # does in the tbl_dbi method)
  wagebill <- dt[
    !is.na(get(measure_col)),
    .(wagebill = sum(get(measure_col))),
    by = by_cols
  ]

  if (!is.null(group_cols)) {
    wagebill[,
      share_wagebill := wagebill / sum(wagebill, na.rm = TRUE),
      by = reference_group_col
    ]
  }

  # complete the group x period panel, as in the tbl_dbi method, so a group
  # absent in a period gets wagebill = NA instead of being dropped
  reference_values <- unique(dt[, ..reference_group_col])
  panel <- reference_values

  if (!is.null(group_cols)) {
    # repeat every reference value for every group
    panel <- unique(dt[, ..group_cols])[,
      as.list(reference_values),
      by = group_cols
    ]
  }

  wagebill <- wagebill[panel, on = by_cols]

  data.table::setorderv(wagebill, by_cols)

  wagebill[,
    wagebill_lag := data.table::shift(wagebill, type = "lag"),
    by = group_cols
  ]
  wagebill[, wagebill_growth := (wagebill - wagebill_lag) / wagebill_lag]
  wagebill[, wagebill_lag := NULL]

  wagebill[]
}

#' @rdname compute_wagebill
#' @importFrom dplyr across all_of distinct everything inner_join lag left_join
#'   mutate select summarise
#' @importFrom rlang check_dots_empty .data
#' @export
compute_wagebill.tbl_dbi <- function(
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

  wagebill <- data |>
    summarise(
      # SQL's SUM() skips missing pay, and is NULL (NA) when all pay is missing
      wagebill = sum(.data[[measure_col]], na.rm = TRUE),
      .by = all_of(by_cols)
    )

  if (!is.null(group_cols)) {
    wagebill <- wagebill |>
      mutate(
        share_wagebill = wagebill / sum(wagebill, na.rm = TRUE),
        .by = all_of(reference_group_col)
      )

    # complete the group x period panel, crossing through a constant key, so
    # a group absent in a period gets wagebill = NA instead of being dropped
    reference_values <- data |>
      distinct(across(all_of(reference_group_col)))

    group_values <- data |>
      select(all_of(group_cols)) |>
      distinct()

    wagebill <- reference_values |>
      mutate(key = 1) |>
      inner_join(
        group_values |> mutate(key = 1),
        by = "key"
      ) |>
      select(-key) |>
      # keep missing groups: sql joins do not match NA keys by default
      left_join(
        wagebill,
        by = by_cols,
        na_matches = "na"
      )
  }

  wagebill |>
    mutate(
      wagebill_lag = lag(wagebill, order_by = .data[[reference_group_col]]),
      wagebill_growth = (wagebill - wagebill_lag) / wagebill_lag,
      .by = all_of(group_cols)
    ) |>
    select(
      all_of(by_cols), 
      everything(), 
      -wagebill_lag
    )
}
