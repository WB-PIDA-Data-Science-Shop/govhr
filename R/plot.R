#' Plot Height for a Grouped Bar Chart
#'
#' Scales chart height with the number of bars so category labels stay legible.
#'
#' @param data Data frame in which each row becomes one bar.
#'
#' @returns Numeric height in pixels, never below 350.
#'
#' @export
scale_plot_height <- function(data) {
  max(350, nrow(data) * 35 + 100)
}

#' Plot changes as bars above or below zero
#'
#' Draws a proportional change, such as a growth rate, as one bar per value of
#' `x_col`, blue when it is zero or above and orange when it is below.
#'
#' @param data Data frame with the columns named in `x_col`, `y_col` and
#'   `group_cols`.
#' @param x_col Character. Column for the x-axis, usually `"ref_date"`.
#' @param y_col Character. Column holding the change as a proportion, so
#'   `0.1` means 10%.
#' @param group_cols Character vector of columns to split the plot into one
#'   panel per group, or `NULL` (default) for a single panel.
#' @param x_lab,y_lab Character. Axis labels, or `NULL` (default) for none.
#'
#' @returns A ggplot2 object.
#'
#' @details Rows with a missing change, such as the first date, which has no
#'   earlier value to change from, are left out. When `x_col` is `"ref_date"`,
#'   it must be a Date, and the axis is labelled by year.
#'
#' @examples
#' growth <- data.frame(
#'   ref_date = as.Date(c("2020-01-01", "2021-01-01", "2022-01-01")),
#'   wage_growth = c(NA, 0.05, -0.02)
#' )
#' plot_change(growth, x_col = "ref_date", y_col = "wage_growth", y_lab = "Wage growth")
#'
#' @export
plot_change <- function(
  data,
  x_col,
  y_col,
  group_cols = NULL,
  x_lab = NULL,
  y_lab = NULL
) {
  change_data <- data |>
    # the first period has no prior value to change from, and its NA sign
    # would otherwise fall outside the fill scale
    dplyr::filter(
      !is.na(.data[[y_col]])
    ) |>
    dplyr::mutate(
      change_sign = dplyr::if_else(.data[[y_col]] >= 0, "positive", "negative")
    )

  plot <- change_data |>
    ggplot2::ggplot() +
    ggplot2::geom_col(
      ggplot2::aes(
        x = .data[[x_col]],
        y = .data[[y_col]],
        fill = .data[["change_sign"]]
      )
    ) +
    ggplot2::geom_hline(
      yintercept = 0,
      linetype = "dashed",
      colour = "gray"
    ) +
    ggplot2::theme(
      legend.position = "none"
    ) +
    # blue for growth, orange for decline, as in plot_movement()
    ggplot2::scale_fill_manual(
      values = c(
        "positive" = "#202d85",
        "negative" = "#de4500"
      )
    ) +
    ggplot2::labs(
      x = x_lab,
      y = y_lab
    ) +
    ggplot2::scale_y_continuous(
      labels = scales::percent_format(accuracy = 0.1)
    )

  if (x_col == "ref_date") {
    plot <- plot +
      ggplot2::scale_x_date(
        date_breaks = "1 year",
        date_labels = "%Y"
      )
  }

  if (!is.null(group_cols)) {
    plot <- facet_by_group(
      plot,
      change_data,
      group_cols
    )
  }

  plot
}

#' Plot stacked areas over time
#'
#' Draws `y_col` over time as stacked areas, one per value of `fill_col`, such
#' as headcount by contract type.
#'
#' @param data Data frame with the columns named in `x_col`, `y_col` and
#'   `fill_col`.
#' @param x_col Character. Date column for the x-axis. Default `"ref_date"`.
#' @param y_col Character. Column to stack.
#' @param fill_col Character. Column whose values each get their own area, or
#'   `NULL` (default) for a single area.
#' @param x_lab,y_lab Character. Axis labels, or `NULL` (default) for none.
#'
#' @returns A ggplot2 object.
#'
#' @details The x-axis is labelled by year, so `x_col` must be a Date.
#'
#' @examples
#' headcount <- data.frame(
#'   ref_date = as.Date(rep(c("2020-01-01", "2021-01-01"), each = 2)),
#'   contract_type = rep(c("permanent", "temporary"), times = 2),
#'   headcount = c(80, 20, 85, 25)
#' )
#' plot_area(headcount, y_col = "headcount", fill_col = "contract_type", y_lab = "Headcount")
#'
#' @export
plot_area <- function(
  data,
  x_col = "ref_date",
  y_col,
  fill_col = NULL,
  x_lab = NULL,
  y_lab = NULL
) {
  area_aes <- if (is.null(fill_col)) {
    ggplot2::aes(x = .data[[x_col]], y = .data[[y_col]])
  } else {
    ggplot2::aes(x = .data[[x_col]], y = .data[[y_col]], fill = .data[[fill_col]])
  }

  data |>
    ggplot2::ggplot() +
    ggplot2::geom_area(
      area_aes,
      position = "stack"
    ) +
    ggplot2::scale_x_date(
      date_breaks = "1 year",
      date_labels = "%Y"
    ) +
    ggplot2::labs(
      x = x_lab,
      y = y_lab,
      fill = NULL
    ) +
    ggplot2::theme(
      legend.position = "bottom",
      legend.key.width = ggplot2::unit(1, "lines"),
      legend.key.height = ggplot2::unit(1, "lines")
    ) +
    ggplot2::guides(
      fill = ggplot2::guide_legend(
        title.position = "top",
        ncol = 3,
        override.aes = list(linewidth = 6)
      )
    )
}

#' Split a plot into one panel per group
#'
#' Adds a [ggplot2::facet_wrap()] by `group_cols` to `plot`, after checking that
#' `data` has those columns. Used by [plot_change()].
#'
#' @param plot A ggplot2 object.
#' @param data The data drawn in `plot`, checked for `group_cols`.
#' @param group_cols Character vector of the columns to split by.
#'
#' @returns `plot` with the facets added.
#'
#' @keywords internal
facet_by_group <- function(plot, data, group_cols) {
  missing_cols <- setdiff(group_cols, names(data))

  if (length(missing_cols) > 0) {
    rlang::abort(
      paste0("`group_cols` not found in data: ", paste(missing_cols, collapse = ", "))
    )
  }

  plot +
    ggplot2::facet_wrap(
      ggplot2::vars(!!!rlang::syms(group_cols)),
      # occupation group names run long enough to overlap neighbouring strips
      labeller = ggplot2::label_wrap_gen(width = 30)
    )
}
