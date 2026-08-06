#' Plot grouped line chart with labeled points
#'
#' This function creates a line plot with labeled points, showing how a variable
#' (y) evolves along another variable (x).
#'
#' @param data A data frame or tibble containing the variables to plot.
#' @param x Column to be mapped to the x-axis.
#' @param y Column to be mapped to the y-axis.
#' @param group Column specifying the grouping variable (mapped to color).
#' @param label Column specifying the labels for each point (optional).
#' @param ... Any other arguments passed to \code{aes()}.
#'
#' @return A \code{ggplot} object representing the grouped line chart.
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
#' @importFrom ggthemes scale_color_few
#' @importFrom rlang enquo
#' @importFrom scales pretty_breaks
#'
#' @export
ggplot_point_line <- function(data, x, y, group = NULL, label = NULL, ...) {
  plot <- ggplot(
    data,
    aes(x = {{ x }}, y = {{ y }}, color = {{ group }}, ...)
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

  if (!rlang::quo_is_null(rlang::enquo(group))) {
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
#' @param .data A data.frame or tibble.
#' @param col Unquoted numeric column (values).
#' @param group Unquoted grouping column.
#'
#' @return A ggplot object.
#' @examples
#' \dontrun{
#'    ggplot_segment(df, salary, occupation)
#' }
#' @export
#' @importFrom rlang enquo as_label sym
#' @importFrom dtplyr lazy_dt
#' @importFrom tibble as_tibble
#' @importFrom dplyr group_by summarise mutate arrange pull desc
#' @importFrom ggplot2 ggplot geom_segment geom_point position_jitter scale_y_discrete labs theme_minimal arrow
#' @importFrom grid unit
#' @importFrom stats median
ggplot_segment <- function(.data, col, group) {
  colq <- rlang::enquo(col)
  gq <- rlang::enquo(group)

  col_name <- rlang::as_label(colq)
  g_name <- rlang::as_label(gq)

  df <- .data

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
#' @param coef A character string of coefficient name to plot. It can be a regular expression (e.g., "^term").
#' @return A ggplot object showing coefficients with error bars.
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


#' Plot Time Trend
#'
#' Produces a ggplot2 line and point chart of `value` over `ref_date`. When a
#' grouping variable is present, each group receives its own line coloured with
#' an orange palette. When `toggle_growth` is `TRUE`, the y-axis is formatted
#' for a baseline index (first period = 100) with a reference line at 100;
#' otherwise raw values are shown with short-scale labels.
#'
#' @param data A data frame with columns `ref_date` and `value`, as returned by
#'   [compute_trend_summary()] and optionally [apply_baseline_index()].
#' @param group Character string naming the grouping column, or `"ref_date"` for
#'   no grouping.
#' @param toggle_growth Logical. If `TRUE`, format the y-axis as a baseline
#'   index and add a dashed reference line at 100. Default `FALSE`.
#' @param y_col Character string of the column to plot on the y-axis. Default `"value"`.
#' @param y_label Character string for the y-axis label used when
#'   `toggle_growth` is `FALSE`. Default `"Value"`.
#'
#' @return A ggplot2 object.
#'
#' @importFrom ggplot2 ggplot aes geom_point geom_line xlab ylab scale_y_continuous geom_hline scale_color_manual
#' @importFrom dplyr n_distinct ungroup
#' @importFrom grDevices colorRampPalette
#' @importFrom scales label_number cut_short_scale
#' @export
plot_trend <- function(
  data,
  group,
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

  if (group != "ref_date") {
    n_groups <- dplyr::n_distinct(data[[group]], na.rm = TRUE)
    orange_palette <- grDevices::colorRampPalette(c("#C34729", "#F5C6A0"))(
      n_groups
    )
    plot <- plot +
      ggplot2::aes(
        color = .data[[group]],
        group = .data[[group]]
      ) +
      ggplot2::scale_color_manual(values = orange_palette)
  }

  if (toggle_growth) {
    plot <- plot +
      ggplot2::scale_y_continuous(
        labels = scales::label_number(accuracy = 0.1)
      ) +
      ggplot2::ylab("Baseline index (first period = 100)") +
      ggplot2::geom_hline(yintercept = 100, linetype = "dashed", color = "red3")
  } else {
    plot <- plot +
      ggplot2::scale_y_continuous(
        labels = scales::label_number(scale_cut = scales::cut_short_scale())
      ) +
      ggplot2::ylab(y_label)
  }

  plot
}

#' Plot Horizontal Bar Chart of Totals by Group
#'
#' Produces a ggplot2 horizontal bar chart with groups ordered by `value`.
#' Missing values in either `value` or the group column are dropped. The x-axis
#' uses short-scale number formatting (e.g. 1K, 1M) and the y-axis uses
#' `guide_axis(n.dodge = 2)` to prevent overlapping labels.
#'
#' @param data A data frame with the grouping column and a `value` column, as
#'   returned by [compute_cross_section_summary()].
#' @param group Character string naming the grouping column.
#' @param x_col Character string of the column to plot on the x-axis. Default `"value"`.
#' @param x_label Character string for the x-axis label. Default `"Value"`.
#'
#' @return A ggplot2 object.
#'
#' @importFrom ggplot2 ggplot aes geom_col scale_x_continuous scale_y_discrete guide_axis labs
#' @importFrom dplyr filter
#' @importFrom stats reorder
#' @importFrom stringr str_wrap
#' @importFrom scales label_number cut_short_scale
#' @export
plot_bar_total <- function(data, group, x_col = "value", x_label = "Value") {
  data |>
    dplyr::filter(
      !is.na(.data[[x_col]]) & !is.na(.data[[group]])
    ) |>
    ggplot2::ggplot(
      ggplot2::aes(
        x = .data[[x_col]],
        y = stats::reorder(
          stringr::str_wrap(.data[[group]], width = 30),
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

#' Plot Horizontal Bar Chart of Growth Rates by Group
#'
#' Produces a ggplot2 horizontal bar chart with groups ordered by `growth_rate`.
#' A dashed vertical line is drawn at zero to distinguish positive from negative
#' growth. The x-axis uses short-scale number formatting and the y-axis uses
#' `guide_axis(n.dodge = 2)`.
#'
#' @param data A data frame with the grouping column and a `growth_rate` column,
#'   as returned by [compute_growth_summary()].
#' @param group Character string naming the grouping column.
#'
#' @return A ggplot2 object.
#'
#' @importFrom ggplot2 ggplot aes geom_col geom_vline scale_x_continuous scale_y_discrete guide_axis labs
#' @importFrom stats reorder
#' @importFrom stringr str_wrap
#' @importFrom scales label_number cut_short_scale
#' @export
plot_bar_growth <- function(data, group) {
  data |>
    ggplot2::ggplot(
      ggplot2::aes(
        x = .data[["growth_rate"]],
        y = stats::reorder(
          stringr::str_wrap(.data[[group]], width = 30),
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

#' Create a Segment Plot with Jittered Points
#'
#' Produces a ggplot2 visualization showing the range (min to max) and distribution
#' of values for a numeric variable across different groups. Groups are ordered by
#' their median values in descending order.
#'
#' @param .data A data frame containing the variables to plot.
#' @param col Character string specifying the name of the numeric column to plot
#'   on the x-axis.
#' @param group Character string specifying the name of the grouping column for
#'   the y-axis.
#'
#' @return A ggplot2 object displaying:
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
#' plot_segment(mtcars, col = "mpg", group = "cyl")
#'
#' @importFrom dplyr group_by summarise mutate arrange pull
#' @importFrom ggplot2 ggplot aes geom_segment geom_jitter scale_y_discrete labs
#' @importFrom tibble tibble
#'
#' @export
plot_segment <- function(.data, col, group) {
  df <- .data

  # Calculate summary statistics using .data[[]]
  summary_df <- df |>
    dplyr::summarise(
      xmin = min(.data[[col]], na.rm = TRUE),
      xmax = max(.data[[col]], na.rm = TRUE),
      mean = mean(.data[[col]], na.rm = TRUE),
      .by = .data[[group]]
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
    dplyr::pull(.data[[group]]) |>
    as.character()

  # Apply factor ordering for plotting
  summary_df[[group]] <- factor(
    as.character(summary_df[[group]]),
    levels = rev(ordered_levels)
  )

  plot_data <- df |>
    dplyr::mutate(
      !!group := factor(
        as.character(.data[[group]]),
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
        y = .data[[group]],
        yend = .data[[group]]
      ),
      color = "grey70",
      linewidth = 1
    ) +
    ggplot2::geom_jitter(
      data = plot_data,
      ggplot2::aes(x = .data[[col]], y = .data[[group]]),
      height = 0.1,
      width = 0.1,
      alpha = 0.7,
      size = 2.5,
      shape = 1
    ) +
    ggplot2::scale_y_discrete() +
    ggplot2::labs(x = col, y = group)
}

#' Plot Personnel Movement Over Time
#'
#' @param .data A data frame containing the movement data with columns `ref_date`, `indicator`, and optionally a grouping column.
#' @param movement_type A character string indicating the type of movement: "hire", "fire", or "turnover".
#' @param measurement_type A character string indicating the measurement type: "count" or "rate".
#' @param group_cols A character string indicating the grouping column, or "ref_date" for no grouping.
#'
#' @return A ggplot2 object representing the personnel movement over time.
#'
#' @importFrom ggplot2 ggplot aes geom_point geom_line labs scale_y_continuous
#' @importFrom dplyr n_distinct
#' @importFrom grDevices colorRampPalette
#'
#' @export
plot_movement <- function(.data, movement_type, measurement_type, group_cols) {
  plot <- .data |>
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
      .data[[group_cols]],
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
        x = as.Date(max(.data[["ref_date"]])) -
          (as.Date(max(.data[["ref_date"]])) -
            as.Date(min(.data[["ref_date"]]))) *
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

#' Plot Decile Summary
#'
#' @param .data A data frame produced by `compute_decile()`, containing columns `decile`, `mean_value`, and optionally a grouping column.
#' @param group_cols A character string indicating the grouping column, or "ref_date" for no grouping.
#'
#' @return A ggplot2 object representing the decile summary.
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
plot_decile <- function(.data, group_cols) {
  plot <- .data |>
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

#' Plot Density as Percentage Share
#'
#' @param .data A data frame produced by `compute_histogram()` or `compute_cumulative()`, containing columns `bin`, `pct`, and optionally a grouping column.
#' @param plot_type A character string indicating the type of plot: "histogram" or "cumulative".
#' @param group_col The column name to group by.
#'
#' @import ggplot2
#' @importFrom grDevices colorRampPalette
#'
#' @return A ggplot2 object.
plot_histogram <- function(.data, plot_type = "histogram", group_col = NULL) {
  plot_type <- match.arg(plot_type, c("histogram", "cumulative"))

  y_var <- switch(
    plot_type,
    histogram = "pct",
    cumulative = "cum_pct"
  )

  plot <- .data |>
    ggplot2::ggplot(ggplot2::aes(x = bin, y = .data[[y_var]])) +
    ggplot2::geom_col() +
    ggplot2::scale_y_continuous(labels = scales::label_percent()) +
    ggplot2::labs(x = "", y = "Percentage Share")

  if (!is.null(group_col)) {
    plot <- plot +
      ggplot2::facet_wrap(
        ggplot2::vars(.data[[group_col]]),
        labeller = ggplot2::label_wrap_gen(width = 20)
      )
  }

  plot
}

#' Plot Compression Ratio
#'
#' @param .data A data frame containing the compression ratio data produced by `compute_compression_ratio()`.
#' @param group_cols A character string indicating the grouping column, or "ref_date"
#' for no grouping.
#'
#' @return A ggplot2 object representing the compression ratio.
#'
#' @importFrom ggplot2 ggplot aes geom_point geom_linerange labs scale_color_manual
#' @importFrom dplyr n_distinct
#' @importFrom grDevices colorRampPalette
#'
#' @export
plot_compression_ratio <- function(.data, group_cols) {
  group_cols <- if (is.null(group_cols)) "ref_date" else group_cols

  # plot as a line range between percentile_10 and percentile_90, with a point at percentile_50
  # and the y-axis is the group_cols, and the x-axis is the percentile values
  plot <- .data |>
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
      .data[[group_cols]],
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

#' Plot Movement Cost
#'
#' @param .data A data frame containing the movement cost data with columns `movement_cost` and optionally a grouping column.
#' @param group_cols A character string indicating the grouping column, or "ref_date" for no grouping.
#'
#' @return A ggplot2 object representing the movement cost.
#'
#' @importFrom ggplot2 ggplot aes geom_col labs scale_color_manual
#' @importFrom dplyr n_distinct
#' @importFrom grDevices colorRampPalette
#'
#' @export
plot_movement_cost <- function(.data, group_cols) {
  group_cols <- if (is.null(group_cols)) "ref_date" else group_cols

  plot <- .data |>
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
      .data[[group_cols]],
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
