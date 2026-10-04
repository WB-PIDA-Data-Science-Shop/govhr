
#' Compute the percentile of a measure
#'
#' Bins `measure_col` at a fixed width and reports each bin's share and
#' cumulative share of observations within each group, filling empty bins with
#' zero so the distribution is gap-free.
#'
#' @param data Data frame or remote table (`tbl_dbi`) containing the measure,
#'   the grouping columns and, if `latest_measure = TRUE`, a `ref_date` column.
#' @param measure_col Character. Numeric column to bin.
#' @param group_cols Character vector of columns to group by, or `NULL` for no
#'   grouping.
#' @param binwidth Positive whole number. Width of each bin. Default `1`.
#' @param latest_measure Logical. Restrict to the latest reference date.
#'   Default `FALSE`.
#' @param ... Arguments passed to methods.
#'
#' @returns A data.table (a lazy table for `tbl_dbi` input) with the grouping
#'   columns, `bin` (the lower edge of each bin), `count`, `pct` and `cum_pct`.
#'   Bins span the range of `measure_col` across all groups.
#'
#' @details Rows with a missing `measure_col` are dropped. Missing values in
#'   `group_cols` are kept as their own group.
#'
#'   `binwidth` must be a whole number because bins are assigned with
#'   `floor(measure_col / binwidth)`, and fractional widths are not exact in
#'   floating point: `0.3 / 0.1` is `2.9999...`, which would put 0.3 in the
#'   0.2 bin.
#'
#' @export
compute_percentile <- function(data, ...) {
  UseMethod("compute_percentile")
}

#' @rdname compute_percentile
#' @importFrom data.table .N .SD := as.data.table data.table setnames setorderv
#' @export
compute_percentile.data.frame <- function(
  data,
  measure_col,
  group_cols = NULL,
  binwidth = 1,
  latest_measure = FALSE,
  ...
) {
  check_binwidth(binwidth)

  if (latest_measure) {
    data <- data[which(data[["ref_date"]] == max(data[["ref_date"]], na.rm = TRUE)), ]
  }

  dt <- data.table::as.data.table(data)
  dt[, bin := floor(get(measure_col) / binwidth) * binwidth]
  dt <- dt[!is.na(bin)]

  if (nrow(dt) == 0) {
    stop("`", measure_col, "` has no non-missing values")
  }

  binned <- dt[, .(count = .N), by = c(group_cols, "bin")]

  # full grid of every bin in range, crossed with every group present
  all_bins <- seq(min(dt$bin), max(dt$bin), by = binwidth)

  full_grid <- if (is.null(group_cols)) {
    data.table::data.table(bin = all_bins)
  } else {
    unique(dt[, ..group_cols])[, .(bin = all_bins), by = group_cols]
  }

  binned <- merge(full_grid, binned, by = c(group_cols, "bin"), all.x = TRUE)
  binned[is.na(count), count := 0L]

  data.table::setorderv(binned, c(group_cols, "bin"))

  binned <- binned[,
    c(
      .SD,
      list(
        pct = count / sum(count),
        cum_pct = cumsum(count) / sum(count)
      )
    ),
    by = group_cols
  ]

  binned[]
}

#' @rdname compute_percentile
#' @importFrom dplyr all_of coalesce collect inner_join join_by left_join
#'   mutate n rename select semi_join summarise
#' @importFrom rlang sym syms
#' @importFrom tibble tibble
#' @export
compute_percentile.tbl_dbi <- function(
  data,
  measure_col,
  group_cols = NULL,
  binwidth = 1,
  latest_measure = FALSE,
  ...
) {
  check_binwidth(binwidth)

  measure <- rlang::sym(measure_col)

  if (latest_measure) {
    latest_date <- data |>
      dplyr::summarise(
        ref_date = max(ref_date, na.rm = TRUE)
      )

    data <- data |>
      dplyr::semi_join(
        latest_date,
        by = "ref_date"
      )
  }

  data <- data |>
    drop_missing(measure_col) |>
    dplyr::select(
      dplyr::all_of(c(group_cols, measure_col))
    )

  measure_range <- data |>
    dplyr::summarise(
      n_records = dplyr::n(),
      lower = min(!!measure, na.rm = TRUE),
      upper = max(!!measure, na.rm = TRUE)
    ) |>
    dplyr::collect()

  if (measure_range$n_records == 0) {
    stop("`", measure_col, "` has no non-missing values")
  }

  # bin edges, as in govhr. the outer edges are open, so that rounding
  # errors in the range join cannot drop the lowest or highest records
  bin_index <- seq(
    floor(measure_range$lower / binwidth),
    floor(measure_range$upper / binwidth)
  )

  bins <- tibble::tibble(
    key = 1,
    bin_id = seq_along(bin_index),
    bin = bin_index * binwidth,
    bin_lower = c(-Inf, bin[-1]),
    bin_upper = c(bin[-1], Inf)
  )

  binned <- data |>
    dplyr::inner_join(
      bins |> dplyr::select(bin_id, bin_lower, bin_upper),
      by = dplyr::join_by(!!measure >= bin_lower, !!measure < bin_upper),
      copy = TRUE
    ) |>
    dplyr::summarise(
      count = dplyr::n(),
      .by = dplyr::all_of(c(group_cols, "bin_id"))
    )

  # complete the group x bin grid, crossing through a constant key, as in
  # compute_wagebill()
  group_values <- binned |>
    dplyr::summarise(
      n_bins = dplyr::n(),
      .by = dplyr::all_of(group_cols)
    ) |>
    dplyr::mutate(key = 1)

  grid <- group_values |>
    dplyr::inner_join(
      bins |> dplyr::select(key, bin_id, bin),
      by = "key",
      copy = TRUE,
      relationship = "many-to-many"
    ) |>
    dplyr::select(
      dplyr::all_of(c(group_cols, "bin_id", "bin"))
    )

  # bins below the group's lowest record have no match, so a zero count
  cumulative <- grid |>
    dplyr::inner_join(
      binned |> dplyr::rename(bin_id_below = bin_id, count_below = count),
      by = dplyr::join_by(!!!rlang::syms(group_cols), bin_id >= bin_id_below),
      na_matches = "na"
    ) |>
    dplyr::summarise(
      cum_count = sum(count_below, na.rm = TRUE),
      .by = dplyr::all_of(c(group_cols, "bin_id"))
    )

  grid |>
    dplyr::left_join(
      binned,
      by = c(group_cols, "bin_id"),
      na_matches = "na"
    ) |>
    dplyr::left_join(
      cumulative,
      by = c(group_cols, "bin_id"),
      na_matches = "na"
    ) |>
    dplyr::mutate(
      count = dplyr::coalesce(count, 0),
      cum_count = dplyr::coalesce(cum_count, 0)
    ) |>
    dplyr::mutate(
      total = sum(count, na.rm = TRUE),
      .by = dplyr::all_of(group_cols)
    ) |>
    dplyr::mutate(
      pct = count / total,
      cum_pct = cum_count / total
    ) |>
    dplyr::select(
      dplyr::all_of(group_cols), bin, count, pct, cum_pct
    )
}

# fractional widths are not exact in floating point, see compute_percentile()
check_binwidth <- function(binwidth) {
  if (
    !is.numeric(binwidth) || length(binwidth) != 1 || is.na(binwidth) ||
      binwidth < 1 || binwidth != round(binwidth)
  ) {
    stop("`binwidth` must be a positive whole number.")
  }
}

#' Compute Deciles of a Measure
#'
#' Assigns rows to deciles of `measure_col` within each group and reference
#' date, then reports the median and mean of the measure in each decile.
#'
#' @param data Data frame containing a `ref_date` column and the measure.
#' @param group_cols Character vector of columns to group by, or `NULL` for no
#'   grouping.
#' @param measure_col Character. Numeric column to rank into deciles.
#' @param latest_measure Logical. Restrict to the latest reference date and drop
#'   `ref_date` from the grouping. Default `FALSE`.
#'
#' @returns A data frame with the grouping columns, `decile`, `median_value` and
#'   `mean_value`.
#'
#' @importFrom data.table as.data.table setorderv
#' @importFrom dplyr ntile
#' @importFrom stats median
#' @export
compute_decile <- function(
  data,
  group_cols = NULL,
  measure_col,
  latest_measure = FALSE
) {
  dt <- data.table::as.data.table(data)

  by_cols <- if (latest_measure) {
    group_cols
  } else {
    c(group_cols, "ref_date")
  }

  if (latest_measure) {
    dt <- dt[ref_date == max(ref_date, na.rm = TRUE)]
  }

  dt[, decile := dplyr::ntile(get(measure_col), 10), by = by_cols]

  out <- dt[
    !is.na(decile),
    .(
      median_value = stats::median(get(measure_col), na.rm = TRUE),
      mean_value = mean(get(measure_col), na.rm = TRUE)
    ),
    keyby = c(by_cols, "decile")
  ]

  data.table::setorderv(out, c(by_cols, "decile"))

  out[]
}
