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

#' Plot grouped line chart with labeled points
#'
#' This function creates a line plot with labeled points, showing how a variable
#' (y) evolves along another variable (x).
#'
#' @param .data A data frame or tibble containing the variables to plot.
#' @param x Column to be mapped to the x-axis.
#' @param y Column to be mapped to the y-axis.
#' @param group_col Column specifying the grouping variable (mapped to color).
#' @param label Column specifying the labels for each point (optional).
#' @param ... Any other arguments passed to \code{aes()}.
#'
#' @returns A \code{ggplot} object representing the grouped line chart.
#'
#' @examples
#' \dontrun{
#' ggplot_point_line(
#'   data,
#'   x = year,
#'   y = median_base_salary_ppp,
#'   group = paygrade,
#'   label = year
#' )
#' }
#'
#' @import ggplot2
#' @importFrom ggrepel geom_text_repel
#' @importFrom ggthemes scale_colour_few
#' @importFrom rlang enquo
#' @importFrom scales pretty_breaks
#'
#' @export
ggplot_point_line <- function(.data, x, y, group_col = NULL, label = NULL, ...) {
  plot <- ggplot(
    .data,
    aes(x = {{ x }}, y = {{ y }}, color = {{ group_col }}, ...)
  ) +
    geom_line(linewidth = 3) +
    geom_point(size = 8) +
    scale_x_continuous(
      breaks = scales::pretty_breaks()
    )

  # Add labels if provided
  if (!rlang::quo_is_null(rlang::enquo(label))) {
    plot <- plot +
      ggrepel::geom_text_repel(
        aes(label = {{ label }}),
        size = 3.5,
        segment.linetype = 6,
        direction = "y",
        min.segment.length = 0,
        show.legend = FALSE,
        max.overlaps = Inf,
        color = "grey40"
      )
  }

  if (!rlang::quo_is_null(rlang::enquo(group_col))) {
    plot <- plot +
      ggthemes::scale_colour_few()
  }

  plot <- plot +
    theme(legend.position = "bottom")

  return(plot)
}

#' Plot segments overlaid with points, ordered by median
#'
#' Compute per-group min/max/median for a numeric column and plot one horizontal
#' segment per group with individual points overlaid. Groups are
#' ordered from highest median to lowest.
#'
#' @param data A data.frame or tibble.
#' @param col Unquoted numeric column (values).
#' @param group_col Unquoted grouping column.
#'
#' @returns A ggplot object.
#' @examples
#' \dontrun{
#'    ggplot_segment(df, salary, occupation)
#' }
#' @export
#' @importFrom rlang enquo as_label sym
#' @importFrom dtplyr lazy_dt
#' @importFrom tibble as_tibble
#' @importFrom dplyr group_by summarise mutate arrange pull desc
#' @importFrom ggplot2 ggplot geom_segment geom_point scale_y_discrete labs theme_minimal
#' @importFrom stats median
ggplot_segment <- function(data, col, group_col) {
  colq <- rlang::enquo(col)
  gq <- rlang::enquo(group_col)

  col_name <- rlang::as_label(colq)
  g_name <- rlang::as_label(gq)

  df <- data

  summary_df <- df |>
    dtplyr::lazy_dt() |>
    dplyr::group_by(!!gq) |>
    dplyr::summarise(
      xmin = min(!!colq, na.rm = TRUE),
      xmax = max(!!colq, na.rm = TRUE),
      median = stats::median(!!colq, na.rm = TRUE),
      .groups = "drop"
    ) |>
    dplyr::mutate(
      xmin = ifelse(is.infinite(.data[["xmin"]]), NA_real_, .data[["xmin"]]),
      xmax = ifelse(is.infinite(.data[["xmax"]]), NA_real_, .data[["xmax"]])
    ) |>
    tibble::as_tibble()

  ordered_levels <- summary_df |>
    dplyr::arrange(dplyr::desc(median)) |>
    dplyr::pull(!!gq) |>
    as.character()

  # ensure factor ordering for plotting
  summary_df[[g_name]] <- factor(
    as.character(summary_df[[g_name]]),
    levels = rev(ordered_levels)
  )
  plot_data <- df |>
    dplyr::mutate(
      !!g_name := factor(
        as.character(df[[g_name]]),
        levels = rev(ordered_levels)
      )
    )

  col_sym <- rlang::sym(col_name)
  group_sym <- rlang::sym(g_name)

  ggplot2::ggplot() +
    ggplot2::geom_segment(
      data = summary_df,
      ggplot2::aes(x = xmin, xend = xmax, y = !!group_sym, yend = !!group_sym),
      color = "grey70",
      linewidth = 1
    ) +
    ggplot2::geom_jitter(
      data = plot_data,
      ggplot2::aes(x = !!col_sym, y = !!group_sym),
      height = 0.1,
      width = 0.1,
      alpha = 0.7,
      size = 2.5,
      shape = 1 # a hollow circle shape
    ) +
    ggplot2::scale_y_discrete() +
    ggplot2::labs(x = col_name, y = g_name) +
    ggplot2::theme_minimal()
}

#' Plot model coefficients with confidence intervals
#' @param model A fitted model object (e.g., lm, glm).
#' @param coef A string of coefficient name to plot. It can be a regular expression (e.g., "^term").
#' @returns A ggplot object showing coefficients with error bars.
#' @examples
#' \dontrun{
#'   model <- lm(mpg ~ wt + hp, data = mtcars)
#'   ggplot_coef(model)
#' }
#' @importFrom broom tidy
#' @import ggplot2
#' @importFrom stringr str_detect
#' @importFrom dplyr filter
#'
#' @export
ggplot_coef <- function(model, coef) {
  model |>
    broom::tidy(conf.int = TRUE) |>
    dplyr::filter(
      stringr::str_detect(term, coef)
    ) |>
    ggplot2::ggplot(ggplot2::aes(x = estimate, y = term)) +
    ggplot2::geom_point() +
    ggplot2::geom_linerange(
      ggplot2::aes(xmin = conf.low, xmax = conf.high)
    ) +
    ggplot2::geom_vline(
      xintercept = 0,
      linetype = "dashed",
      color = "grey50"
    ) +
    ggplot2::labs(x = "Coefficient", y = "Estimate") +
    ggplot2::theme_minimal()
}


#' Create a segment plot with jittered points
#'
#' Produces a ggplot2 visualization showing the range (min to max) and distribution
#' of values for a numeric variable across different groups. Groups are ordered by
#' their median values in descending order.
#'
#' @param data A data frame containing the variables to plot.
#' @param col Character string specifying the name of the numeric column to plot
#'   on the x-axis.
#' @param group_col Character string specifying the name of the grouping column for
#'   the y-axis.
#' @param group Deprecated. Use `group_col` instead.
#'
#' @returns A ggplot2 object displaying:
#'   \itemize{
#'     \item Grey horizontal segments showing the range (min to max) for each group
#'     \item Jittered points showing the distribution of individual observations
#'     \item Groups ordered by median value (highest to lowest, top to bottom)
#'   }
#'
#' @details
#' The function:
#' \itemize{
#'   \item Computes min, max, and median for each group
#'   \item Handles infinite values by converting them to NA
#'   \item Orders groups by median in descending order
#'   \item Uses hollow circles (shape = 1) for points with 70% transparency
#'   \item Applies minimal theme styling
#' }
#'
#' @examples
#' plot_segment(mtcars, col = "mpg", group_col = "cyl")
#'
#' @importFrom dplyr group_by summarise mutate arrange pull
#' @importFrom ggplot2 ggplot aes geom_segment geom_jitter scale_y_discrete labs
#' @importFrom tibble tibble
#'
#' @export
plot_segment <- function(data, col, group_col, group = NULL) {
  group_col <- resolve_renamed_arg(group_col, group, "group", "group_col")
  df <- data

  # Calculate summary statistics using .data[[]]
  summary_df <- df |>
    dplyr::summarise(
      xmin = min(.data[[col]], na.rm = TRUE),
      xmax = max(.data[[col]], na.rm = TRUE),
      mean = mean(.data[[col]], na.rm = TRUE),
      .by = .data[[group_col]]
    ) |>
    # drop if any components are missing for a group
    na.omit() |>
    dplyr::mutate(
      xmin = ifelse(is.infinite(.data[["xmin"]]), NA_real_, .data[["xmin"]]),
      xmax = ifelse(is.infinite(.data[["xmax"]]), NA_real_, .data[["xmax"]])
    ) |>
    tibble::as_tibble()

  # Determine group ordering by median
  ordered_levels <- summary_df |>
    dplyr::arrange(dplyr::desc(.data[["mean"]])) |>
    dplyr::pull(.data[[group_col]]) |>
    as.character()

  # Apply factor ordering for plotting
  summary_df[[group_col]] <- factor(
    as.character(summary_df[[group_col]]),
    levels = rev(ordered_levels)
  )

  plot_data <- df |>
    dplyr::mutate(
      !!group_col := factor(
        as.character(.data[[group_col]]),
        levels = rev(ordered_levels)
      )
    )

  # Create the plot using .data[[]]
  ggplot2::ggplot() +
    ggplot2::geom_segment(
      data = summary_df,
      ggplot2::aes(
        x = .data[["xmin"]],
        xend = .data[["xmax"]],
        y = .data[[group_col]],
        yend = .data[[group_col]]
      ),
      color = "grey70",
      linewidth = 1
    ) +
    ggplot2::geom_jitter(
      data = plot_data,
      ggplot2::aes(x = .data[[col]], y = .data[[group_col]]),
      height = 0.1,
      width = 0.1,
      alpha = 0.7,
      size = 2.5,
      shape = 1
    ) +
    ggplot2::scale_y_discrete() +
    ggplot2::labs(x = col, y = group_col)
}

#' Plot personnel movement over time
#'
#' @param data A data frame containing the movement data with columns `ref_date`, `indicator`, and optionally a grouping column.
#' @param movement_type A string indicating the type of movement: "hire", "fire", or "turnover".
#' @param measurement_type A string indicating the measurement type: "count" or "rate".
#' @param group_cols A character vector of columns to group by, or `"ref_date"` for no grouping.
#'
#' @returns A ggplot2 object representing the personnel movement over time.
#'
#' @importFrom ggplot2 ggplot aes geom_point geom_line labs scale_y_continuous
#' @importFrom dplyr n_distinct
#' @importFrom grDevices colorRampPalette
#'
#' @export
plot_movement <- function(data, movement_type, measurement_type, group_cols) {
  plot <- data |>
    ggplot(
      aes(.data[["ref_date"]], .data[["indicator"]])
    ) +
    geom_point() +
    geom_line() +
    labs(
      x = "Time",
      y = ifelse(measurement_type == "rate", "Share", "Count")
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

  if (
    movement_type %in%
      c("hire", "fire", "retirement") &
      measurement_type == "rate"
  ) {
    plot <- plot +
      scale_y_continuous(
        labels = scales::percent_format()
      )
  } else if (movement_type == "turnover") {
    plot <- plot +
      scale_y_continuous(
        labels = scales::label_number(accuracy = 0.1)
      ) +
      geom_hline(
        yintercept = 1,
        linetype = "dashed",
        color = "#004181"
      ) +
      ggplot2::annotate(
        "text",
        x = as.Date(max(data[["ref_date"]])) -
          (as.Date(max(data[["ref_date"]])) -
            as.Date(min(data[["ref_date"]]))) *
            0.05,
        y = 1.15,
        label = "Replacement rate = 1",
        color = "#004181"
      ) +
      labs(
        y = "Replacement rate"
      )
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

#' Plot movement cost
#'
#' @param data A data frame containing the movement cost data with columns `movement_cost` and optionally a grouping column.
#' @param group_cols A character vector of columns to group by, or `"ref_date"` for no grouping.
#'
#' @returns A ggplot2 object representing the movement cost.
#'
#' @importFrom ggplot2 ggplot aes geom_col labs scale_color_manual
#' @importFrom dplyr n_distinct
#' @importFrom grDevices colorRampPalette
#'
#' @export
plot_movement_cost <- function(data, group_cols) {
  group_cols <- if (is.null(group_cols)) "ref_date" else group_cols

  plot <- data |>
    ggplot2::ggplot(
      ggplot2::aes(
        x = .data[["movement_cost"]],
        y = .data[[group_cols]]
      )
    ) +
    ggplot2::geom_col(
      fill = "#C34729"
    ) +
    ggplot2::labs(
      x = "Movement Cost",
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
