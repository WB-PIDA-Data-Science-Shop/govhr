#' Plot decile summary
#'
#' @param data A data frame produced by `compute_decile()`, containing columns `decile`, `mean_value`, and optionally a grouping column.
#' @param group_col Character. A column to draw one panel per group, or
#'   `"ref_date"` for no grouping.
#' @param group_cols `r lifecycle::badge("deprecated")` Use `group_col`
#'   instead.
#'
#' @returns A ggplot2 object representing the decile summary.
#'
#' @importFrom ggplot2 ggplot aes geom_col labs scale_x_continuous facet_wrap
#'
#' @export
#'
#' @examples
#' govhr::compute_decile(
#'   govhr::bra_hrmis_contract,
#'   measure_col = "gross_salary_lcu",
#'   group_cols = "paygrade"
#' ) |>
#'   govhr::plot_decile(group_col = "paygrade")
plot_decile <- function(data, group_col, group_cols = lifecycle::deprecated()) {
  if (lifecycle::is_present(group_cols)) {
    lifecycle::deprecate_warn(
      when = "0.4.2",
      what = "plot_decile(group_cols)",
      with = "plot_decile(group_col)"
    )
    group_col <- group_cols
  }

  plot <- data |>
    ggplot2::ggplot(
      ggplot2::aes(x = .data[["decile"]], y = .data[["mean_value"]])
    ) +
    ggplot2::geom_col(
      fill = "#C34729"
    ) +
    ggplot2::labs(
      x = "Decile",
      y = "Median by Decile"
    ) +
    ggplot2::scale_x_continuous(
      breaks = 1:10,
      labels = 1:10
    )

  if (group_col != "ref_date") {
    plot <- plot +
      ggplot2::facet_wrap(
        ggplot2::vars(.data[[group_col]]),
        labeller = ggplot2::label_wrap_gen(width = 20)
      )
  }

  plot
}

#' Plot density as percentage share
#'
#' @param data A data frame produced by `compute_histogram()` or `compute_cumulative()`, containing columns `bin`, `pct`, and optionally a grouping column.
#' @param plot_type A string indicating the type of plot: "histogram" or "cumulative".
#' @param group_col The column name to group by.
#'
#' @import ggplot2
#' @importFrom grDevices colorRampPalette
#'
#' @returns A ggplot2 object.
#' @export
plot_histogram <- function(data, plot_type = "histogram", group_col = NULL) {
  plot_type <- match.arg(plot_type, c("histogram", "cumulative"))

  y_var <- switch(
    plot_type,
    histogram = "pct",
    cumulative = "cum_pct"
  )

  plot <- data |>
    ggplot2::ggplot(ggplot2::aes(x = bin, y = .data[[y_var]])) +
    ggplot2::geom_col() +
    ggplot2::scale_y_continuous(labels = scales::label_percent()) +
    ggplot2::labs(x = "", y = "Percentage Share")

  if (!(is.null(group_col) || group_col == "ref_date")) {
    plot <- plot +
      ggplot2::facet_wrap(
        ggplot2::vars(.data[[group_col]]),
        labeller = ggplot2::label_wrap_gen(width = 20)
      )
  }

  plot
}

#' Plot compression ratio
#'
#' @param data A data frame containing the compression ratio data produced by `compute_compression_ratio()`.
#' @param group_col Character. A column to draw one range per group, or
#'   `NULL` (default) or `"ref_date"` for one range per reference date.
#' @param group_cols `r lifecycle::badge("deprecated")` Use `group_col`
#'   instead.
#'
#' @returns A ggplot2 object representing the compression ratio.
#'
#' @importFrom ggplot2 ggplot aes geom_point geom_linerange labs scale_color_manual
#' @importFrom dplyr n_distinct
#' @importFrom grDevices colorRampPalette
#'
#' @export
plot_compression_ratio <- function(
  data,
  group_col = NULL,
  group_cols = lifecycle::deprecated()
) {
  if (lifecycle::is_present(group_cols)) {
    lifecycle::deprecate_warn(
      when = "0.4.2",
      what = "plot_compression_ratio(group_cols)",
      with = "plot_compression_ratio(group_col)"
    )
    group_col <- group_cols
  }

  group_col <- if (is.null(group_col)) "ref_date" else group_col

  # plot as a line range between percentile_10 and percentile_90, with a point at percentile_50
  # and the y-axis is the group_col, and the x-axis is the percentile values
  plot <- data |>
    ggplot2::ggplot(
      ggplot2::aes(
        x = .data[["percentile_50"]],
        y = .data[[group_col]],
        xmin = .data[["percentile_lower"]],
        xmax = .data[["percentile_upper"]]
      )
    ) +
    ggplot2::geom_point(
      size = 3,
      color = "#C34729"
    ) +
    ggplot2::geom_linerange(
      color = "#C34729"
    ) +
    ggplot2::labs(
      x = "Wage Compression Ratio (10th to 90th Percentile)",
      y = ""
    )

  if (group_col != "ref_date") {
    n_groups <- dplyr::n_distinct(
      data[[group_col]],
      na.rm = TRUE
    )
    orange_palette <- colorRampPalette(c("#C34729", "#F5C6A0"))(n_groups)
    plot <- plot +
      aes(
        color = .data[[group_col]],
        group = .data[[group_col]]
      ) +
      ggplot2::scale_color_manual(values = orange_palette)
  }

  plot
}
