
#' Count Unique Entities by Group
#' 
#' @param .data Data frame containing the data.
#' @param id_col Character. Column name of the unique identifier for the entity.
#' @param group_cols Character vector of column names to group by, or `NULL` for no grouping.
#' 
#' @return A data frame with the grouping columns and a `count` column representing the number of unique entities in each group.
#' 
#' @importFrom data.table as.data.table uniqueN setorderv
#' @export
count_entity <- function(.data, id_col, group_cols = NULL){
  dt <- data.table::as.data.table(.data)

  out <- dt[
    !is.na(get(id_col)),
    .(
      count = data.table::uniqueN(get(id_col))
    ),
    keyby = group_cols
  ]

  data.table::setorderv(out, c(group_cols, "count"))

  out[]
}


#' Compute Trend Summary
#'
#' Aggregates data over time into a tidy frame of `ref_date`, the optional
#' grouping column, and `value`. Counts rows when `measure_col` is `NULL`
#' (headcount) and sums the column otherwise (wage bill).
#'
#' @param .data Data frame containing at least a `ref_date` column.
#' @param group_col Character. Column to group by, or `"ref_date"` for no
#'   grouping.
#' @param measure_col Character. Numeric column to sum, or `NULL` to count rows.
#'
#' @return A data frame with `ref_date`, optionally `group_col`, and `value`.
#'
#' @importFrom dplyr across all_of
#' @export
compute_trend_summary <- function(.data, group_col, measure_col = NULL) {
  groups <- if (group_col == "ref_date") "ref_date" else c("ref_date", group_col)

  if (is.null(measure_col)) {
    fastcount(.data, dplyr::across(dplyr::all_of(groups)), name = "value")
  } else {
    compute_fastsummary(
      .data,
      cols = measure_col,
      fns = "sum",
      groups = groups
    )
  }
}

#' Apply Baseline Index to a Trend Summary
#'
#' Rescales `value` so the earliest observation equals 100. When a grouping
#' column is supplied the rescaling is applied independently within each group.
#'
#' @param .data Data frame with `ref_date` and `value`, as returned by
#'   [compute_trend_summary()].
#' @param group_col Character. Column to group by, or `"ref_date"` for no
#'   grouping.
#'
#' @return The input data frame with `value` rescaled to a baseline index.
#'
#' @importFrom dplyr arrange mutate all_of first
#' @export
apply_baseline_index <- function(.data, group_col) {
  indexed <- dplyr::arrange(.data, .data[["ref_date"]])

  if (group_col == "ref_date") {
    dplyr::mutate(
      indexed,
      value = .data[["value"]] / dplyr::first(.data[["value"]]) * 100
    )
  } else {
    dplyr::mutate(
      indexed,
      value = .data[["value"]] / dplyr::first(.data[["value"]]) * 100,
      .by = dplyr::all_of(group_col)
    )
  }
}

#' Compute Cross-Section Summary
#'
#' Keeps each group's latest reference date and aggregates it into a single
#' `value` per group. Counts rows when `measure_col` is `NULL` (headcount) and
#' sums the column otherwise (wage bill).
#'
#' @param .data Data frame containing `ref_date` and the grouping column.
#' @param group_col Character. Column to group by.
#' @param measure_col Character. Numeric column to sum, or `NULL` to count rows.
#'
#' @return A data frame with the grouping column and a `value` column.
#'
#' @importFrom dplyr all_of filter n summarise
#' @export
compute_cross_section_summary <- function(.data, group_col, measure_col = NULL) {
  # only consider each group's latest reference date
  data_latest <- dplyr::filter(
    .data,
    .data[["ref_date"]] == max(.data[["ref_date"]]),
    .by = dplyr::all_of(group_col)
  )

  if (is.null(measure_col)) {
    dplyr::summarise(
      data_latest,
      value = dplyr::n(),
      .by = dplyr::all_of(group_col)
    )
  } else {
    govhr::compute_fastsummary(
      data_latest,
      cols = measure_col,
      fns = "sum",
      groups = group_col
    )
  }
}

#' Compute Growth Rate Summary
#'
#' Keeps each group's first and last reference date and computes the percentage
#' change between them. Counts rows when `measure_col` is `NULL` (headcount) and
#' sums the column otherwise (wage bill).
#'
#' @param .data Data frame containing `ref_date` and the grouping column.
#' @param group_col Character. Column to group by.
#' @param measure_col Character. Numeric column to sum, or `NULL` to count rows.
#'
#' @return A data frame with the grouping column and a `growth_rate` column, in
#'   percentage points (e.g. `12.5` for +12.5%).
#'
#' @importFrom dplyr all_of arrange filter first last n summarise
#' @export
compute_growth_summary <- function(.data, group_col, measure_col = NULL) {
  labelled <- dplyr::filter(.data, !is.na(.data[[group_col]]))

  # aggregate every period once; picking endpoints out of the (small) aggregate
  # is cheaper than scanning the raw rows for each group's first and last date
  by_period <- if (is.null(measure_col)) {
    dplyr::summarise(
      labelled,
      value = dplyr::n(),
      .by = dplyr::all_of(c("ref_date", group_col))
    )
  } else {
    govhr::compute_fastsummary(
      labelled,
      cols = measure_col,
      fns = "sum",
      groups = c("ref_date", group_col)
    )
  }

  by_period |>
    dplyr::filter(
      .data[["ref_date"]] %in% range(.data[["ref_date"]]),
      .by = dplyr::all_of(group_col)
    ) |>
    dplyr::arrange(.data[["ref_date"]]) |>
    dplyr::summarise(
      growth_rate = round(
        dplyr::last(.data[["value"]]) / dplyr::first(.data[["value"]]) - 1,
        3
      ) *
        100,
      .by = dplyr::all_of(group_col)
    ) |>
    dplyr::filter(!is.na(.data[["growth_rate"]]))
}


#' Orange Gradient Colour Scale for Grouped Series
#'
#' Builds the package's standard sequential orange scale, sized to the number
#' of distinct groups present in the data.
#'
#' @param values Vector of group values. Distinct non-missing values determine
#'   the number of colours.
#'
#' @return A ggplot2 manual colour scale.
#'
#' @importFrom dplyr n_distinct
#' @importFrom ggplot2 scale_color_manual
#' @importFrom grDevices colorRampPalette
#' @keywords internal
group_color_scale <- function(values) {
  n_groups <- dplyr::n_distinct(values, na.rm = TRUE)

  ggplot2::scale_color_manual(
    values = grDevices::colorRampPalette(c("#C34729", "#F5C6A0"))(n_groups)
  )
}

#' Plot Time Trend
#'
#' Draws a line-and-point chart of the measure over `ref_date`, one coloured
#' series per group. When `toggle_growth` is `TRUE` the y-axis is formatted as a
#' baseline index with a dashed reference line at 100.
#'
#' @param .data Data frame with `ref_date` and the y-axis column, as returned by
#'   [compute_trend_summary()] and optionally [govhr::apply_baseline_index()].
#' @param group_col Character. Column to group by, or `"ref_date"` for no
#'   grouping.
#' @param toggle_growth Logical. Format the y-axis as a baseline index. Default
#'   `FALSE`.
#' @param y_col Character. Column to plot on the y-axis. Default `"value"`.
#' @param y_label Character. y-axis label, used when `toggle_growth` is `FALSE`.
#'   Default `"Value"`.
#'
#' @return A ggplot2 object.
#'
#' @importFrom ggplot2 aes geom_hline geom_line geom_point ggplot scale_y_continuous xlab ylab
#' @importFrom scales cut_short_scale label_number
#' @export
plot_trend <- function(
  .data,
  group_col,
  toggle_growth = FALSE,
  y_col = "value",
  y_label = "Value"
) {
  plot <- .data |>
    ggplot2::ggplot(
      ggplot2::aes(x = .data[["ref_date"]], y = .data[[y_col]])
    ) +
    ggplot2::geom_point() +
    ggplot2::geom_line() +
    ggplot2::xlab("Time")

  if (group_col != "ref_date") {
    plot <- plot +
      ggplot2::aes(
        color = .data[[group_col]],
        group = .data[[group_col]]
      ) +
      group_color_scale(.data[[group_col]])
  }

  if (toggle_growth) {
    plot +
      ggplot2::scale_y_continuous(
        labels = scales::label_number(accuracy = 0.1)
      ) +
      ggplot2::ylab("Baseline index (first period = 100)") +
      ggplot2::geom_hline(yintercept = 100, linetype = "dashed", color = "red3")
  } else {
    plot +
      ggplot2::scale_y_continuous(
        labels = scales::label_number(scale_cut = scales::cut_short_scale())
      ) +
      ggplot2::ylab(y_label)
  }
}

#' Plot Totals by Group
#'
#' Draws a horizontal bar chart with groups ordered by the plotted value. Rows
#' missing either the value or the group label are dropped.
#'
#' @param .data Data frame with the grouping column and the x-axis column, as
#'   returned by [compute_cross_section_summary()].
#' @param group_col Character. Column to group by.
#' @param x_col Character. Column to plot on the x-axis. Default `"value"`.
#' @param x_label Character. x-axis label. Default `"Value"`.
#'
#' @return A ggplot2 object.
#'
#' @importFrom dplyr filter
#' @importFrom ggplot2 aes geom_col ggplot guide_axis labs scale_x_continuous scale_y_discrete
#' @importFrom scales cut_short_scale label_number
#' @importFrom stats reorder
#' @importFrom stringr str_wrap
#' @export
plot_bar_total <- function(.data, group_col, x_col = "value", x_label = "Value") {
  .data |>
    dplyr::filter(
      !is.na(.data[[x_col]]) & !is.na(.data[[group_col]])
    ) |>
    ggplot2::ggplot(
      ggplot2::aes(
        x = .data[[x_col]],
        y = stats::reorder(
          stringr::str_wrap(.data[[group_col]], width = 30),
          .data[[x_col]]
        )
      )
    ) +
    ggplot2::geom_col() +
    ggplot2::scale_x_continuous(
      labels = scales::label_number(scale_cut = scales::cut_short_scale())
    ) +
    ggplot2::scale_y_discrete(guide = ggplot2::guide_axis(n.dodge = 2)) +
    ggplot2::labs(x = x_label, y = "")
}

#' Plot Growth Rates by Group
#'
#' Draws a horizontal bar chart with groups ordered by `growth_rate`, with a
#' dashed reference line at zero separating growth from decline.
#'
#' @param .data Data frame with the grouping column and a `growth_rate` column,
#'   as returned by [compute_growth_summary()].
#' @param group_col Character. Column to group by.
#'
#' @return A ggplot2 object.
#'
#' @importFrom ggplot2 aes geom_col geom_vline ggplot guide_axis labs scale_x_continuous scale_y_discrete
#' @importFrom scales cut_short_scale label_number
#' @importFrom stats reorder
#' @importFrom stringr str_wrap
#' @export
plot_bar_growth <- function(.data, group_col) {
  .data |>
    ggplot2::ggplot(
      ggplot2::aes(
        x = .data[["growth_rate"]],
        y = stats::reorder(
          stringr::str_wrap(.data[[group_col]], width = 30),
          .data[["growth_rate"]]
        )
      )
    ) +
    ggplot2::geom_col() +
    ggplot2::geom_vline(
      xintercept = 0,
      linewidth = 1.25,
      linetype = "dashed",
      color = "#2958c3"
    ) +
    ggplot2::scale_x_continuous(
      labels = scales::label_number(scale_cut = scales::cut_short_scale())
    ) +
    ggplot2::scale_y_discrete(guide = ggplot2::guide_axis(n.dodge = 2)) +
    ggplot2::labs(x = "Growth rate", y = "")
}
