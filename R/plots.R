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
#' @importFrom ggthemes scale_color_solarized
#' @importFrom rlang enquo
#'
#' @export
ggplot_point_line <- function(data,
                              x,
                              y,
                              group = NULL,
                              label = NULL,
                              ...) {
  plot <- ggplot(data, aes(x = {{ x }}, y = {{ y }}, color = {{ group }}, ...)) +
    geom_line(linewidth = 1.2) +
    geom_point(size = 4)

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
      ggthemes::scale_colour_solarized()
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
  gq   <- rlang::enquo(group)

  col_name <- rlang::as_label(colq)
  g_name   <- rlang::as_label(gq)

  df <- .data

  summary_df <- df |>
    dtplyr::lazy_dt() |>
    dplyr::group_by(!!gq) |>
    dplyr::summarise(
      xmin   = min(!!colq, na.rm = TRUE),
      xmax   = max(!!colq, na.rm = TRUE),
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
  summary_df[[g_name]] <- factor(as.character(summary_df[[g_name]]), levels = rev(ordered_levels))
  plot_data <- df |>
    dplyr::mutate(!!g_name := factor(as.character(df[[g_name]]), levels = rev(ordered_levels)))

  col_sym   <- rlang::sym(col_name)
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
ggplot_coef <- function(model, coef){
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