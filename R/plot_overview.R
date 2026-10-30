#' Orange gradient colour scale for grouped series
#'
#' Builds the package's standard sequential orange scale, sized to the number
#' of distinct groups present in the data.
#'
#' @param values Vector of group values. Distinct non-missing values determine
#'   the number of colours.
#'
#' @returns A ggplot2 manual colour scale.
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

#' Plot time trend
#'
#' Draws a line-and-point chart of the measure over `ref_date`, one coloured
#' series per group. When `toggle_growth` is `TRUE` the y-axis is formatted as a
#' baseline index with a dashed reference line at 100.
#'
#' @param data Data frame with `ref_date` and the y-axis column, as returned by
#'   [compute_trend_summary()] and optionally [govhr::apply_baseline_index()].
#' @param group_col Character. Column to group by, or `"ref_date"` for no
#'   grouping.
#' @param toggle_growth Logical. Format the y-axis as a baseline index. Default
#'   `FALSE`.
#' @param y_col Character. Column to plot on the y-axis. Default `"value"`.
#' @param y_label Character. y-axis label, used when `toggle_growth` is `FALSE`.
#'   Default `"Value"`.
#'
#' @returns A ggplot2 object.
#'
#' @importFrom ggplot2 aes geom_hline geom_line geom_point ggplot scale_y_continuous xlab ylab
#' @importFrom scales cut_short_scale label_number
#' @export
plot_trend <- function(
  data,
  group_col,
  toggle_growth = FALSE,
  y_col = "value",
  y_label = "Value"
) {
  plot <- data |>
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
      group_color_scale(data[[group_col]])
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

#' Plot totals by group
#'
#' Draws a horizontal bar chart with groups ordered by the plotted value. Rows
#' missing either the value or the group label are dropped.
#'
#' @param data Data frame with the grouping column and the x-axis column, as
#'   returned by [compute_cross_section_summary()].
#' @param group_col Character. Column to group by.
#' @param x_col Character. Column to plot on the x-axis. Default `"value"`.
#' @param x_label Character. x-axis label. Default `"Value"`.
#'
#' @returns A ggplot2 object.
#'
#' @importFrom dplyr filter
#' @importFrom ggplot2 aes geom_col ggplot guide_axis labs scale_x_continuous scale_y_discrete
#' @importFrom scales cut_short_scale label_number
#' @importFrom stats reorder
#' @importFrom stringr str_wrap
#' @export
plot_bar_total <- function(data, group_col, x_col = "value", x_label = "Value") {
  data |>
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

#' Plot growth rates by group
#'
#' Draws a horizontal bar chart with groups ordered by `growth_rate`, with a
#' dashed reference line at zero separating growth from decline.
#'
#' @param data Data frame with the grouping column and a `growth_rate` column,
#'   as returned by [compute_growth()].
#' @param group_col Character. Column to group by.
#'
#' @returns A ggplot2 object.
#'
#' @importFrom ggplot2 aes geom_col geom_vline ggplot guide_axis labs scale_x_continuous scale_y_discrete
#' @importFrom scales cut_short_scale label_number
#' @importFrom stats reorder
#' @importFrom stringr str_wrap
#' @export
plot_bar_growth <- function(data, group_col) {
  data |>
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
