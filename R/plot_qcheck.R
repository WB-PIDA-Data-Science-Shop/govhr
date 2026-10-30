#' Plot coverage over time
#'
#' Plots coverage for each reference date, one line per group, from coverage
#' already computed.
#'
#' @param data Data frame with `ref_date`, `coverage` and the column named in
#'   `group_col`, such as the output of
#'   `compute_coverage(include_ref_date = TRUE, aggregate = TRUE)`.
#' @param group_col Character. Column to draw one line per group, or
#'   `"ref_date"` (default) for a single line.
#' @param toggle_growth Logical. Show coverage as a baseline index, with each
#'   group's first date at 100. Default `FALSE`.
#'
#' @returns A ggplot2 object.
#'
#' @seealso [compute_coverage()], which computes the coverage.
#'
#' @examples
#' hr <- data.frame(
#'   ref_date = as.Date(c("2020-01-01", "2020-01-01", "2021-01-01")),
#'   gender = c("F", NA, "M")
#' )
#' hr |>
#'   compute_coverage(include_ref_date = TRUE, aggregate = TRUE) |>
#'   plot_coverage_trend()
#'
#' @importFrom dplyr rename
#' @export
plot_coverage_trend <- function(
  data,
  group_col = "ref_date",
  toggle_growth = FALSE
) {
  # apply_baseline_index() and plot_trend() read the measure from `value`
  coverage <- dplyr::rename(data, value = "coverage")

  if (toggle_growth) {
    coverage <- apply_baseline_index(coverage, group_col = group_col)
  }

  plot_trend(
    coverage,
    group_col = group_col,
    toggle_growth = toggle_growth,
    y_label = "Coverage"
  )
}

#' Plot coverage by variable
#'
#' Plots one bar per variable with its coverage, coloured by coverage tier,
#' from coverage already computed.
#'
#' @param data Data frame with `variable` and `coverage`, such as the output
#'   of [compute_coverage()] without grouping.
#'
#' @returns A ggplot2 object.
#'
#' @details
#' Coverage below 50% is low, from 50% to 79% medium, and from 80% high.
#'
#' @seealso [compute_coverage()], which computes the coverage.
#'
#' @examples
#' hr <- data.frame(gender = c("F", NA, "M"), grade = c(NA, NA, "G1"))
#' plot_coverage_bar(compute_coverage(hr))
#'
#' @importFrom dplyr case_when filter mutate
#' @importFrom ggplot2 aes geom_col ggplot labs scale_fill_manual
#'   scale_x_continuous
#' @importFrom scales label_percent
#' @importFrom stats reorder setNames
#' @importFrom stringr str_wrap
#' @export
plot_coverage_bar <- function(data) {
  coverage_tiers <- c("Low (<50%)", "Medium (50-79%)", "High (>=80%)")

  data |>
    dplyr::filter(!is.na(.data[["coverage"]])) |>
    dplyr::mutate(
      coverage_tier = dplyr::case_when(
        .data[["coverage"]] < 50 ~ coverage_tiers[1],
        .data[["coverage"]] < 80 ~ coverage_tiers[2],
        TRUE ~ coverage_tiers[3]
      ),
      coverage_tier = factor(.data[["coverage_tier"]], levels = coverage_tiers)
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
      values = stats::setNames(
        c("#d32f2f", "#f9a825", "#388e3c"),
        coverage_tiers
      ),
      drop = FALSE
    ) +
    ggplot2::labs(x = "Coverage", y = "", fill = "Coverage")
}

#' Plot coverage by variable and group
#'
#' Plots a heatmap of coverage, with groups across and variables down, from
#' coverage already computed.
#'
#' @param data Data frame with `variable`, `coverage` and the column named in
#'   `group_col`, such as the output of `compute_coverage(group_cols =
#'   group_col)`.
#' @param group_col Character. Column whose values run across the heatmap.
#'   Default `"ref_date"`.
#'
#' @returns A plotly object.
#'
#' @seealso [compute_coverage()], which computes the coverage.
#'
#' @examples
#' hr <- data.frame(
#'   ref_date = as.Date(c("2020-01-01", "2020-01-01", "2021-01-01")),
#'   gender = c("F", NA, "M")
#' )
#' plot_coverage_heatmap(compute_coverage(hr, group_cols = "ref_date"))
#'
#' @importFrom dplyr mutate
#' @export
plot_coverage_heatmap <- function(data, group_col = "ref_date") {
  data |>
    dplyr::mutate(coverage = .data[["coverage"]] / 100) |>
    plot_quality_heatmap(
      group_col = group_col,
      value_col = "coverage",
      value_label = "Coverage"
    )
}

#' Plot consistency over time
#'
#' Plots record or value consistency for each reference date, one line per
#' group, from consistency already computed.
#'
#' @param data Data frame or lazy table (`tbl_dbi`) with `ref_date`, the
#'   column named in `group_col` and `record_consistency` or
#'   `value_consistency`, such as the output of [compute_record_consistency()]
#'   or [compute_value_consistency()] grouped by `group_col` and `ref_date`. A
#'   lazy table is brought into memory first.
#' @param group_col Character. Column to draw one line per group, or
#'   `"ref_date"` (default) for a single line.
#' @param type_plot Character. `"record"` (default) or `"value"`, the kind of
#'   consistency in `data`.
#' @param toggle_growth Logical. Show consistency as a baseline index, with
#'   each group's first date at 100. Default `FALSE`.
#'
#' @returns A ggplot2 object.
#'
#' @seealso [compute_record_consistency()] and
#'   [compute_value_consistency()], which compute the consistency.
#'
#' @examples
#' hr <- data.frame(
#'   personnel_id = c("a", "a", "b", "a"),
#'   ref_date = as.Date(c(rep("2020-01-01", 3), "2021-01-01"))
#' )
#' hr |>
#'   compute_record_consistency("personnel_id", group_cols = "ref_date") |>
#'   plot_consistency_trend()
#'
#' @importFrom dplyr collect rename
#' @export
plot_consistency_trend <- function(
  data,
  group_col = "ref_date",
  type_plot = c("record", "value"),
  toggle_growth = FALSE
) {
  type_plot <- match.arg(type_plot)
  consistency_col <- paste0(type_plot, "_consistency")

  # plot_trend() sizes its group colours from `data[[group_col]]`, which is
  # NULL on a lazy table, hence the collect(). apply_baseline_index() and
  # plot_trend() read the measure from `value`
  consistency <- data |>
    dplyr::collect() |>
    dplyr::rename(value = dplyr::all_of(consistency_col))

  if (toggle_growth) {
    consistency <- apply_baseline_index(
      consistency,
      group_col = group_col
    )
  }

  plot_trend(
    consistency,
    group_col = group_col,
    toggle_growth = toggle_growth,
    y_label = "Consistency"
  )
}

#' Plot value consistency by variable and group
#'
#' Plots a heatmap of value consistency, with groups across and variables
#' down, from consistency already computed.
#'
#' @param data Data frame with `variable`, `value_consistency` and the column
#'   named in `group_col`: one row per group and variable, such as
#'   [compute_value_consistency()] results for several value columns stacked
#'   with a `variable` column naming each.
#' @param group_col Character. Column whose values run across the heatmap.
#'   Default `"ref_date"`.
#'
#' @returns A plotly object.
#'
#' @seealso [compute_value_consistency()], which computes the consistency.
#'
#' @examples
#' hr <- data.frame(
#'   personnel_id = c("a", "a", "b"),
#'   ref_date = as.Date(c("2020-01-01", "2021-01-01", "2020-01-01")),
#'   birth_date = as.Date(c("1980-01-01", "1981-01-01", "1990-01-01"))
#' )
#' hr |>
#'   compute_value_consistency("personnel_id", "birth_date", group_cols = "ref_date") |>
#'   transform(variable = "birth_date") |>
#'   plot_consistency_heatmap()
#'
#' @importFrom dplyr mutate
#' @export
plot_consistency_heatmap <- function(data, group_col = "ref_date") {
  data |>
    dplyr::mutate(value_consistency = .data[["value_consistency"]] / 100) |>
    plot_quality_heatmap(
      group_col = group_col,
      value_col = "value_consistency",
      value_label = "Consistency"
    )
}

# a share heatmap with groups across, variables down and a red-to-green
# scale, shared by plot_coverage_heatmap() and plot_consistency_heatmap()
#' @importFrom plotly layout plot_ly
#' @importFrom stats as.formula
#' @keywords internal
#' @noRd
plot_quality_heatmap <- function(data, group_col, value_col, value_label) {
  plotly::plot_ly(
    data = data,
    x = stats::as.formula(paste0("~`", group_col, "`")),
    y = ~variable,
    z = stats::as.formula(paste0("~`", value_col, "`")),
    type = "heatmap",
    colorscale = list(c(0, "#d32f2f"), c(0.5, "#f9a825"), c(1, "#388e3c")),
    zmin = 0,
    zmax = 1,
    xgap = 2,
    ygap = 2,
    hovertemplate = paste0(
      "Group: %{x}<br>",
      "Variable: %{y}<br>",
      value_label, ": %{z:.0%}",
      "<extra></extra>"
    ),
    colorbar = list(title = value_label, tickformat = ".0%")
  ) |>
    plotly::layout(
      xaxis = list(title = "Group"),
      yaxis = list(title = "Variable")
    )
}
