
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
#' @param binwidth Positive whole number. Width of each bin. Default `NULL`
#'   picks a width from the data; see Details.
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
#'   When `binwidth` is `NULL`, it is chosen with the Freedman-Diaconis rule,
#'   which is based on the spread of the middle half of the values, so a few
#'   extreme values do not throw it off. The width is then adjusted so that
#'   the bulk of the values (1st to 99th percentile) spans 20 to 60 bins, and
#'   rounded up to 1, 2 or 5 times a power of ten. With `latest_measure =
#'   TRUE`, it is based on the latest reference date only.
#'
#' @export
compute_percentile <- function(data, ...) {
  UseMethod("compute_percentile")
}

#' @rdname compute_percentile
#' @importFrom data.table .N .SD := as.data.table data.table setnames setorderv
#' @importFrom rlang check_dots_empty
#' @export
compute_percentile.data.frame <- function(
  data,
  measure_col,
  group_cols = NULL,
  binwidth = NULL,
  latest_measure = FALSE,
  ...
) {
  rlang::check_dots_empty()

  if (latest_measure) {
    data <- data[which(data[["ref_date"]] == max(data[["ref_date"]], na.rm = TRUE)), ]
  }

  # estimated from the rows being binned, so after the latest_measure filter
  if (is.null(binwidth)) {
    binwidth <- estimate_binwidth(data, measure_col)
  }
  check_binwidth(binwidth)

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
#' @importFrom rlang check_dots_empty sym syms
#' @importFrom tibble tibble
#' @export
compute_percentile.tbl_dbi <- function(
  data,
  measure_col,
  group_cols = NULL,
  binwidth = NULL,
  latest_measure = FALSE,
  ...
) {
  rlang::check_dots_empty()

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

  # estimated from the rows being binned, so after the latest_measure filter
  if (is.null(binwidth)) {
    binwidth <- estimate_binwidth(data, measure_col)
  }
  check_binwidth(binwidth)

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

#' Estimate a bin width for a pay distribution
#'
#' Picks a bin width with the Freedman-Diaconis rule, which is based on the
#' spread of the middle half of the data (the interquartile range), so a few
#' very high salaries do not distort it. Because that rule gives ever narrower
#' bins as the data grows, the width is then kept so that the bulk of the
#' distribution (1st to 99th percentile) spans between `min_bins` and
#' `max_bins` bins. Finally it is rounded up to a readable width: 1, 2 or 5
#' times a power of ten.
#'
#' @param data Data frame or remote database table (`tbl_dbi`).
#' @param measure_col Character. Name of the pay column.
#' @param min_bins,max_bins Whole numbers. Fewest and most bins allowed between
#'   the 1st and 99th percentile, before rounding. Default 20 and 60.
#'
#' @returns A positive whole number, usable as `binwidth` in
#'   [compute_percentile()].
#'
#' @keywords internal
#' @importFrom dplyr collect filter n summarise
#' @importFrom stats quantile
estimate_binwidth <- function(data, measure_col, min_bins = 20, max_bins = 60) {
  pay <- data |>
    filter(!is.na(.data[[measure_col]])) |>
    summarise(
      n_records = n(),
      p01 = quantile(.data[[measure_col]], 0.01, na.rm = TRUE),
      p25 = quantile(.data[[measure_col]], 0.25, na.rm = TRUE),
      p75 = quantile(.data[[measure_col]], 0.75, na.rm = TRUE),
      p99 = quantile(.data[[measure_col]], 0.99, na.rm = TRUE)
    ) |>
    collect()

  if (pay$n_records == 0) {
    stop("`", measure_col, "` has no non-missing values")
  }

  freedman_diaconis <- 2 * (pay$p75 - pay$p25) / pay$n_records^(1 / 3)

  # keep the bulk of the distribution between min_bins and max_bins bins
  bulk <- pay$p99 - pay$p01
  binwidth <- min(max(freedman_diaconis, bulk / max_bins), bulk / min_bins)

  # pay that barely varies would give a width below 1, which
  # compute_percentile() does not accept
  if (binwidth < 1) {
    return(1)
  }

  # round up to 1, 2 or 5 times a power of ten
  magnitude <- 10^floor(log10(binwidth))
  steps <- c(1, 2, 5, 10) * magnitude
  steps[steps >= binwidth][1]
}

#' Compute deciles of a measure
#'
#' Splits the records of each group and reference date into ten equally sized
#' deciles of `measure_col`, and reports the median and mean of the measure in
#' each decile.
#'
#' @param data Data frame or remote database table (`tbl_dbi`) containing
#'   `ref_date` and the columns named in `measure_col` and `group_cols`.
#' @param measure_col Character. Numeric column to rank into deciles.
#' @param group_cols Character vector of columns to group by, or `NULL`
#'   (default) for no grouping. Must not include `ref_date`.
#' @param latest_measure Logical. Restrict to the latest reference date and
#'   drop `ref_date` from the grouping. Default `FALSE`.
#' @param ... Arguments passed to methods.
#'
#' @returns A table with one row per group, reference date and decile,
#'   containing the grouping columns, `ref_date` (unless `latest_measure` is
#'   `TRUE`), `decile` (1 to 10), `median_value` and `mean_value`. A
#'   data.table for data frame input; a lazy table for `tbl_dbi` input (use
#'   [dplyr::collect()] to bring it into memory).
#'
#' @details
#' Records with a missing `measure_col` are left out before ranking. Decile
#' sizes differ by at most one record, with the larger deciles first, so a
#' group with fewer than ten records fills only the first deciles. Records
#' with the same value may fall on either side of a decile boundary, which
#' leaves the medians and means unchanged.
#'
#' With `latest_measure = TRUE`, the latest date is the latest across all of
#' `data`, not within each group. Missing groups are kept as their own group.
#'
#' @seealso [compute_percentile()], which bins the measure at a fixed width
#'   instead. [plot_decile()], which draws the result.
#'
#' @examples
#' hr <- data.frame(
#'   ref_date = as.Date("2020-01-01"),
#'   wage = 1:20
#' )
#' compute_decile(hr, measure_col = "wage")
#'
#' @export
compute_decile <- function(data, ...) {
  UseMethod("compute_decile")
}

#' @rdname compute_decile
#' @importFrom data.table := as.data.table setorderv
#' @importFrom dplyr ntile
#' @importFrom rlang check_dots_empty
#' @importFrom stats median
#' @export
compute_decile.data.frame <- function(
  data,
  measure_col,
  group_cols = NULL,
  latest_measure = FALSE,
  ...
) {
  rlang::check_dots_empty()

  if ("ref_date" %in% group_cols) {
    stop("`ref_date` should not be included in `group_cols`")
  }

  dt <- data.table::as.data.table(data)

  if (latest_measure) {
    dt <- dt[ref_date == max(ref_date, na.rm = TRUE)]
  }

  by_cols <- if (latest_measure) group_cols else c(group_cols, "ref_date")

  # selecting columns copies the data, so the decile column below is never
  # added by reference to a data.table passed in
  measured <- dt[
    !is.na(get(measure_col)),
    c(by_cols, measure_col),
    with = FALSE
  ]
  measured[, decile := dplyr::ntile(get(measure_col), 10), by = by_cols]

  decile <- measured[
    , .(
      median_value = stats::median(get(measure_col)),
      mean_value = mean(get(measure_col))
    ),
    by = c(by_cols, "decile")
  ]

  data.table::setorderv(decile, c(by_cols, "decile"))

  decile[]
}

#' @rdname compute_decile
#' @importFrom dplyr all_of filter mutate ntile summarise
#' @importFrom rlang .data check_dots_empty
#' @importFrom stats median
#' @export
compute_decile.tbl_dbi <- function(
  data,
  measure_col,
  group_cols = NULL,
  latest_measure = FALSE,
  ...
) {
  rlang::check_dots_empty()

  if ("ref_date" %in% group_cols) {
    stop("`ref_date` should not be included in `group_cols`")
  }

  if (latest_measure) {
    data <- data |>
      dplyr::filter(ref_date == max(ref_date, na.rm = TRUE))
  }

  by_cols <- if (latest_measure) group_cols else c(group_cols, "ref_date")

  data |>
    # left out before ranking, so missing values do not take up a decile
    dplyr::filter(!is.na(.data[[measure_col]])) |>
    dplyr::mutate(
      decile = dplyr::ntile(.data[[measure_col]], 10),
      .by = dplyr::all_of(by_cols)
    ) |>
    dplyr::summarise(
      median_value = median(.data[[measure_col]], na.rm = TRUE),
      mean_value = mean(.data[[measure_col]], na.rm = TRUE),
      .by = dplyr::all_of(c(by_cols, "decile"))
    )
}
