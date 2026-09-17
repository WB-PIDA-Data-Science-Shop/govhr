#' Plot Coverage Over Time
#'
#' Computes coverage using [compute_coverage()] (with `ref_date` always
#' included, aggregated across variables) and renders a trend line via
#' [plot_trend()].
#'
#' @param data A data frame. Typically the contract, personnel, or
#'   establishment dataset for the active module.
#' @param group_col A string. Grouping variable inherited from the
#'   `coverage_group` UI input (e.g. `"ref_date"`, `"grade_id"`).
#' @param toggle_growth Logical. When `TRUE` the y-axis switches to a
#'   baseline-index view (first period = 100). Defaults to `FALSE`.
#' @param group Deprecated. Use `group_col` instead.
#'
#' @returns A ggplot2 object.
#'
#' @export
plot_coverage_trend <- function(data, group_col, toggle_growth = FALSE, group = NULL) {
  group_col <- resolve_renamed_arg(group_col, group, "group", "group_col")
  coverage_data <- compute_coverage(
    data,
    group_cols = group_col,
    include_ref_date = TRUE,
    aggregate = TRUE
  )

  plot_trend(
    coverage_data,
    y_col = "coverage",
    group_col = group_col,
    toggle_growth = toggle_growth,
    y_label = "Coverage"
  )
}

#' Plot consistency over time
#'
#' @param data A data frame.
#' @param id_col A string. The column name of the unique identifier for each record.
#' @param group_col A string. The column name of the grouping variable (e.g., "ref_date").
#' @param value_col A string. The column name of the value to be checked for consistency.
#' @param type_plot A string. The type of consistency plot ("record" or "value").
#' @param toggle_growth Logical. When `TRUE` the y-axis switches to a baseline-index view (first period = 100). Defaults to `FALSE`.
#' @param group Deprecated. Use `group_col` instead.
#'
#' @returns A ggplot2 object.
#'
#' @export
plot_consistency_trend <- function(
  data,
  id_col,
  group_col,
  value_col,
  type_plot,
  toggle_growth = FALSE,
  group = NULL
) {
  group_col <- resolve_renamed_arg(group_col, group, "group", "group_col")
  # add ref_date to the group if not already included
  group_with_ref_date <- unique(
    c(
      group_col,
      "ref_date"
    )
  )

  consistency_col <- switch(
    type_plot,
    record = "record_consistency",
    value = "value_consistency",
    stop(
      "Invalid type_plot argument. Must be 'record' or 'value'.",
      call. = FALSE
    )
  )

  plot_trend(
    data,
    y_col = consistency_col,
    group_col = group_col,
    toggle_growth = toggle_growth,
    y_label = "Consistency"
  )
}

#' Plot coverage by group (coloured bar chart)
#'
#' Computes per-group coverage using [compute_coverage()] (without
#' `ref_date`, not aggregated) and renders a horizontal bar chart coloured
#' green-yellow-red according to the same cutpoints used by the value boxes:
#'
#' * **High (>=80%)** — green (`#388e3c`)
#' * **Medium (50-79%)** — yellow (`#f9a825`)
#' * **Low (<50%)** — red (`#d32f2f`)
#'
#' @param data A data frame. Typically the contract, personnel, or
#'   establishment dataset for the active module.
#'
#' @returns A ggplot2 object.
#'
#' @import ggplot2
#' @importFrom dplyr filter mutate case_when
#' @importFrom stats reorder
#' @importFrom stringr str_wrap
#' @importFrom scales label_percent
#'
#' @export
plot_coverage_bar <- function(data) {
  # compute coverage by variable and group, when chosen
  coverage_data <- compute_coverage(
    data,
    include_ref_date = FALSE,
    aggregate = FALSE
  ) |>
    dplyr::mutate(
      coverage_tier = dplyr::case_when(
        .data[["coverage"]] < 50 ~ "Low (<50%)",
        .data[["coverage"]] < 80 ~ "Medium (50-79%)",
        TRUE ~ "High (>=80%)"
      ),
      coverage_tier = factor(
        .data[["coverage_tier"]],
        levels = c("Low (<50%)", "Medium (50-79%)", "High (>=80%)")
      )
    )

  coverage_data |>
    dplyr::filter(
      !is.na(
        .data[["coverage"]]
      )
    ) |>
    ggplot2::ggplot(
      ggplot2::aes(
        x = .data[["coverage"]],
        y = stats::reorder(
          stringr::str_wrap(.data[["variable"]], width = 30),
          .data[["coverage"]]
        ),
        fill = .data[["coverage_tier"]]
      )
    ) +
    ggplot2::geom_col() +
    ggplot2::scale_x_continuous(
      labels = scales::label_percent(scale = 1),
      limits = c(0, 100)
    ) +
    ggplot2::scale_fill_manual(
      values = c(
        "Low (<50%)" = "#d32f2f",
        "Medium (50-79%)" = "#f9a825",
        "High (>=80%)" = "#388e3c"
      ),
      drop = FALSE
    ) +
    ggplot2::labs(x = "Coverage", y = "", fill = "Coverage")
}

#' Plot coverage heatmap by group
#'
#' @param data A data frame.
#' @param group_col A string. Grouping variable.
#' @param group Deprecated. Use `group_col` instead.
#'
#' @importFrom plotly plot_ly layout
#' @importFrom dplyr mutate
#' @importFrom scales label_percent
#'
#' @returns A plotly object representing a heatmap of coverage values by group and variable.
#' @export
plot_coverage_heatmap <- function(data, group_col = NULL, group = NULL) {
  group_col <- resolve_renamed_arg(group_col, group, "group", "group_col")
  if (is.null(group_col) || group_col == "none") {
    group_col <- "ref_date"
  }

  coverage_data <- compute_coverage(
    data,
    group_cols = group_col,
    aggregate = FALSE
  ) |>
    dplyr::mutate(
      coverage = .data[["coverage"]] / 100
    )

  # plot heatmap
  plotly::plot_ly(
    data = coverage_data,
    x = ~ .data[[group_col]],
    y = ~variable,
    z = ~coverage,
    type = "heatmap",
    colorscale = list(c(0, "#d32f2f"), c(0.5, "#f9a825"), c(1, "#388e3c")),
    zmin = 0,
    zmax = 1,
    xgap = 2,
    ygap = 2,
    hovertemplate = paste0(
      "Group: %{x}<br>",
      "Variable: %{y}<br>",
      "Coverage: %{z:.0%}",
      "<extra></extra>"
    ),
    colorbar = list(
      title = "Coverage",
      tickformat = ".0%"
    )
  ) |>
    plotly::layout(
      xaxis = list(title = "Group"),
      yaxis = list(title = "Variable")
    )
}

#' Plot consistency heatmap by group
#'
#' @param data A data frame.
#' @param id_col A string. The column name of the unique identifier for each record.
#' @param group_cols A string. The column name of the grouping variable (e.g., "ref_date").
#' @param group Deprecated. Use `group_cols` instead.
#'
#' @importFrom plotly plot_ly layout
#' @importFrom dplyr mutate
#' @importFrom scales label_percent
#' @importFrom purrr map_dfr
#'
#' @returns A plotly heatmap object representing consistency values by group and variable.
#' @export
plot_consistency_heatmap <- function(data, id_col, group_cols, group = NULL) {
  group_cols <- resolve_renamed_arg(group_cols, group, "group", "group_cols")
  value_cols <- setdiff(names(data), c(id_col, group_cols))

  consistency_data <- purrr::map_dfr(
    value_cols,
    ~ compute_value_consistency(
      data,
      id_col = id_col,
      value_col = .x,
      group_cols = group_cols
    ) |>
      dplyr::mutate(
        variable = .x,
        value_consistency = .data[["value_consistency"]] / 100
      )
  )

  plotly::plot_ly(
    data = consistency_data,
    x = ~ .data[[group_cols]],
    y = ~variable,
    z = ~value_consistency,
    type = "heatmap",
    colorscale = list(c(0, "#d32f2f"), c(0.5, "#f9a825"), c(1, "#388e3c")),
    zmin = 0,
    zmax = 1,
    xgap = 2,
    ygap = 2,
    hovertemplate = paste0(
      "Group: %{x}<br>",
      "Variable: %{y}<br>",
      "Consistency: %{z:.0%}",
      "<extra></extra>"
    ),
    colorbar = list(
      title = "Consistency",
      tickformat = ".0%"
    )
  ) |>
    plotly::layout(
      xaxis = list(title = "Group"),
      yaxis = list(title = "Variable")
    )
}
