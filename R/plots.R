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

#' Plot hires or separations over time
#'
#' Draws hires or separations for each reference date, as counts or rates,
#' from the output of [compute_movement()].
#'
#' @param data Output of [compute_movement()]. A lazy table (`tbl_dbi`) is
#'   brought into memory first.
#' @param movement_type Character. `"hire"` (default) or `"separation"`.
#' @param measurement_type Character. `"count"` (default) or `"rate"`.
#' @param group_cols Character. A column to draw one line per group, such as
#'   `"gender"`. It should be one of the `group_cols` used in
#'   [compute_movement()]. `NULL` (default) or `"ref_date"` draws a single
#'   line.
#'
#' @returns A ggplot2 object.
#'
#' @details Dates with no hires or separations to compare with (`NA` in
#'   `data`), such as the first date, are left out of the plot.
#'
#' @examples
#' hr <- data.frame(
#'   personnel_id = c(1, 2, 1, 3, 1, 3),
#'   ref_date = as.Date(rep(c("2020-01-01", "2021-01-01", "2022-01-01"), each = 2)),
#'   employment_status = "active"
#' )
#' movement <- compute_movement(hr)
#' plot_movement(movement, movement_type = "separation", measurement_type = "rate")
#'
#' @importFrom ggplot2 ggplot aes geom_point geom_line labs scale_color_manual
#'   scale_y_continuous
#' @importFrom dplyr collect filter n_distinct
#' @importFrom grDevices colorRampPalette
#'
#' @export
plot_movement <- function(
  data,
  movement_type = c("hire", "separation"),
  measurement_type = c("count", "rate"),
  group_cols = NULL
) {
  movement_type <- match.arg(movement_type)
  measurement_type <- match.arg(measurement_type)

  if (length(group_cols) > 1) {
    stop("`group_cols` must be a single column")
  }

  # the compute_movement() column to plot, e.g. "hires" or "separation_rate"
  measure_col <- if (measurement_type == "count") {
    paste0(movement_type, "s")
  } else {
    paste0(movement_type, "_rate")
  }

  # collect() leaves in-memory data unchanged
  plot_data <- data |>
    collect() |>
    filter(!is.na(.data[[measure_col]]))

  plot <- plot_data |>
    ggplot(
      aes(.data[["ref_date"]], .data[[measure_col]])
    ) +
    geom_point() +
    geom_line() +
    labs(
      x = "Time",
      y = paste0(
        if (movement_type == "hire") "Hire" else "Separation",
        if (measurement_type == "count") "s" else " rate"
      )
    )

  if (measurement_type == "rate") {
    plot <- plot +
      scale_y_continuous(
        labels = scales::percent_format()
      )
  }

  if (!(is.null(group_cols) || group_cols == "ref_date")) {
    n_groups <- n_distinct(
      plot_data[[group_cols]],
      na.rm = TRUE
    )
    orange_palette <- colorRampPalette(c("#C34729", "#F5C6A0"))(n_groups)
    plot <- plot +
      aes(
        color = .data[[group_cols]],
        group = .data[[group_cols]]
      ) +
      scale_color_manual(values = orange_palette)
  }

  plot
}

#' Plot decile summary
#'
#' @param data A data frame produced by `compute_decile()`, containing columns `decile`, `mean_value`, and optionally a grouping column.
#' @param group_cols A character vector of columns to group by, or `"ref_date"` for no grouping.
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
#'   govhr::plot_decile(group_cols = "paygrade")
plot_decile <- function(data, group_cols) {
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

  if (group_cols != "ref_date") {
    plot <- plot +
      facet_wrap(
        ggplot2::vars(.data[[group_cols]]),
        scales = "fixed"
      )
  }

  # if group are present, facet the plot by group
  if (group_cols != "ref_date") {
    plot <- plot +
      ggplot2::facet_wrap(
        ggplot2::vars(.data[[group_cols]]),
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
#' @param group_cols A character vector of columns to group by, or `"ref_date"`
#' for no grouping.
#'
#' @returns A ggplot2 object representing the compression ratio.
#'
#' @importFrom ggplot2 ggplot aes geom_point geom_linerange labs scale_color_manual
#' @importFrom dplyr n_distinct
#' @importFrom grDevices colorRampPalette
#'
#' @export
plot_compression_ratio <- function(data, group_cols = NULL) {
  group_cols <- if (is.null(group_cols)) "ref_date" else group_cols

  # plot as a line range between percentile_10 and percentile_90, with a point at percentile_50
  # and the y-axis is the group_cols, and the x-axis is the percentile values
  plot <- data |>
    ggplot2::ggplot(
      ggplot2::aes(
        x = .data[["percentile_50"]],
        y = .data[[group_cols]],
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

  if (group_cols != "ref_date") {
    n_groups <- dplyr::n_distinct(
      data[[group_cols]],
      na.rm = TRUE
    )
    orange_palette <- colorRampPalette(c("#C34729", "#F5C6A0"))(n_groups)
    plot <- plot +
      aes(
        color = .data[[group_cols]],
        group = .data[[group_cols]]
      ) +
      ggplot2::scale_color_manual(values = orange_palette)
  }

  plot
}
