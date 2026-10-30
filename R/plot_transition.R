#' Plot transition heatmap
#'
#' Draws transitions between groups as a heatmap, origin groups on the y-axis
#' and destination groups on the x-axis, from red for no moves through yellow
#' for a typical number of moves to green for the most.
#'
#' @param data Data frame with `from`, `to` and `transitions` columns, such as
#'   the output of [compute_transition()]. Moves are added up over all
#'   reference dates.
#'
#' @returns A plotly object.
#'
#' @keywords internal
plot_transition_heatmap <- function(data) {
  transition_data <- data |>
    tidyr::complete(
      .data[["from"]],
      .data[["to"]],
      fill = list(transitions = 0)
    ) |>
    dplyr::summarise(
      transitions = sum(.data[["transitions"]], na.rm = TRUE),
      .by = c("from", "to")
    ) |>
    dplyr::mutate(
      transitions = dplyr::coalesce(.data[["transitions"]], 0)
    )
  
  transition <- transition_data[["transitions"]]
  transition_min <- min(transition, na.rm = TRUE)
  transition_max <- max(transition, na.rm = TRUE)

  # pairs without moves are filled with 0 above and usually outnumber the
  # rest, so the median of every cell would sit at 0. the midpoint colour
  # marks a typical flow among the pairs that have one
  typical <- stats::median(transition[transition > 0], na.rm = TRUE)

  # plotly places colour stops on a 0 to 1 scale, not on the values themselves
  midpoint <- if (transition_max > transition_min && !is.na(typical)) {
    (typical - transition_min) / (transition_max - transition_min)
  } else {
    0.5
  }

  plotly::plot_ly(
    data = transition_data,
    x = ~ transition_data[["to"]],
    y = ~ transition_data[["from"]],
    z = ~ transition_data[["transitions"]],
    type = "heatmap",
    colorscale = list(
      list(0, "#d32f2f"),
      list(midpoint, "#f9a825"),
      list(1, "#388e3c")
    ),
    zmin = transition_min,
    zmax = transition_max,
    xgap = 2,
    ygap = 2,
    hovertemplate = paste0(
      "Group (to): %{x}<br>",
      "Group (from): %{y}<br>",
      "Transitions: %{z}",
      "<extra></extra>"
    ),
    colorbar = list(title = "Transitions")
  ) |>
    plotly::layout(
      xaxis = list(title = "Group (to)"),
      yaxis = list(title = "Group (from)")
    )
}

#' Plot transitions as a network
#'
#' Draws moves between groups as a directed graph: one numbered node per group
#' and one arrow per origin and destination, as wide as the number of moves.
#' Nodes are numbered from the group with the most moves in and out, and the
#' legend matches each number to its group.
#'
#' @param data Data frame with `from` and `to` columns: one row per move, as
#'   returned by [detect_transition()], or one row per origin and destination
#'   with a count, as returned by [compute_transition()]. Bring a lazy table
#'   (`tbl_dbi`) into memory first with [dplyr::collect()], ideally after
#'   counting the moves with [compute_transition()].
#' @param weight_col Character. Column counting the moves on each row, such as
#'   `"transitions"` for [compute_transition()] output, or `NULL` (default) to
#'   count each row as one move.
#' @param legend Logical. Show the legend matching node numbers to groups.
#'   Default `TRUE`.
#' @param interactive Logical. If `TRUE`, return an interactive chart that
#'   shows each group's name on hover. If `FALSE` (default), return a static
#'   ggplot, for outputs such as Word that cannot show interactive charts.
#'
#' @returns A ggplot object, or a ggiraph girafe object when
#'   `interactive = TRUE`.
#'
#' @details
#' A node's area is proportional to the number of moves in and out of its
#' group, with a minimum size so that the number drawn on it stays legible.
#'
#' The plot takes its font and colours from the active ggplot2 theme, to match
#' the figures around it.
#'
#' @seealso [plot_transition_flows()] for moves in and out of each group over
#'   time.
#'
#' @examples
#' careers <- data.frame(
#'   personnel_id = c("a", "a", "b", "b", "c", "c"),
#'   ref_date = as.Date(rep(c("2020-01-01", "2021-01-01"), times = 3)),
#'   unit = c("A", "B", "A", "C", "B", "A")
#' )
#' transitions <- compute_transition(careers, group_col = "unit")
#' plot_transition(transitions, weight_col = "transitions")
#'
#' @export
plot_transition <- function(
  data,
  weight_col = NULL,
  legend = TRUE,
  interactive = FALSE
) {
  node_colour <- "#C34729"
  legend_node_size <- 8
  max_node_size <- 16
  # strictly proportional sizing would shrink the quietest groups below the
  # width of their number, which is drawn in white and would vanish
  min_node_size <- 5

  weight <- if (is.null(weight_col)) NULL else rlang::sym(weight_col)

  edges <- data |>
    dplyr::count(
      .data[["from"]],
      .data[["to"]],
      wt = !!weight,
      name = "weight"
    ) |>
    # as_tbl_graph() only creates a `name` column from character ids
    dplyr::mutate(
      dplyr::across(c("from", "to"), as.character)
    )

  graph_data <- tidygraph::as_tbl_graph(edges, directed = TRUE) |>
    tidygraph::activate("nodes") |>
    tidygraph::mutate(
      strength = tidygraph::centrality_degree(
        weights = .data[["weight"]],
        mode = "all"
      )
    ) |>
    # numbering by volume of moves makes node 1 the busiest group, so the
    # legend doubles as a ranking
    tidygraph::arrange(dplyr::desc(.data[["strength"]]), .data[["name"]]) |>
    tidygraph::mutate(
      node_id = factor(dplyr::row_number()),
      # point size sets the diameter, so taking the square root makes node
      # area, not width, proportional to the volume of moves in and out
      size = pmax(
        max_node_size * sqrt(.data[["strength"]] / max(.data[["strength"]])),
        min_node_size
      ),
      # a point of size s is about 0.75 * s mm wide; capping edges just past
      # each node's own radius keeps arrowheads visible on large nodes
      cap = 0.375 * .data[["size"]] + 1
    )

  nodes <- graph_data |>
    tidygraph::activate("nodes") |>
    tidygraph::as_tibble()

  node_ids <- levels(nodes[["node_id"]])
  node_labels <- nodes[["name"]]

  # node size is mapped through an identity scale, which has no legend, so
  # point keys would otherwise fall back to the default size and hide the number
  draw_key_node <- function(data, params, size) {
    data[["size"]] <- legend_node_size
    ggplot2::draw_key_point(data, params, size)
  }

  active_theme <- ggplot2::theme_get()

  plot <- ggraph::ggraph(graph_data, layout = "stress") +
    ggraph::geom_edge_arc(
      ggplot2::aes(
        edge_width = .data[["weight"]],
        start_cap = ggraph::circle(.data[["node1.cap"]], "mm"),
        end_cap = ggraph::circle(.data[["node2.cap"]], "mm")
      ),
      # a slight bend separates the two directions between a pair of nodes
      strength = 0.2,
      colour = "#4a5568",
      edge_alpha = 0.5,
      arrow = grid::arrow(length = grid::unit(3, "mm"), type = "closed")
    ) +
    ggraph::geom_node_point(
      ggplot2::aes(
        size = .data[["size"]],
        colour = .data[["node_id"]]
      ),
      key_glyph = draw_key_node
    ) +
    ggraph::geom_node_text(
      ggplot2::aes(label = .data[["node_id"]]),
      colour = "white",
      size = 3.5,
      fontface = "bold"
    ) +
    ggiraph::geom_point_interactive(
      ggplot2::aes(
        x = .data[["x"]],
        y = .data[["y"]],
        size = .data[["size"]],
        tooltip = .data[["name"]],
        data_id = .data[["node_id"]]
      ),
      alpha = 0.01,
      show.legend = FALSE
    ) +
    ggraph::scale_edge_width_continuous(range = c(0.2, 3), guide = "none") +
    ggplot2::scale_size_identity() +
    ggplot2::scale_colour_manual(
      name = NULL,
      values = rep(node_colour, length(node_ids)),
      breaks = node_ids,
      labels = node_labels
    ) +
    ggplot2::scale_discrete_identity(
      aesthetics = "label",
      name = NULL,
      breaks = node_ids,
      labels = node_labels,
      guide = "legend"
    ) +
    ggplot2::scale_x_continuous(expand = ggplot2::expansion(mult = 0.08)) +
    ggplot2::scale_y_continuous(expand = ggplot2::expansion(mult = 0.08)) +
    ggplot2::coord_cartesian(clip = "off") +
    # the active theme may set axis children such as axis.text.x, which would
    # survive blanking their parents, so start from theme_void() and carry
    # over only its font and colours to match the surrounding figures;
    # theme_void() alone would also leave the background transparent
    ggplot2::theme_void(
      base_size = active_theme[["text"]][["size"]],
      base_family = active_theme[["text"]][["family"]],
      ink = active_theme[["geom"]][["ink"]],
      paper = active_theme[["geom"]][["paper"]]
    ) +
    ggplot2::theme(
      legend.position = if (legend) "bottom" else "none",
      plot.margin = ggplot2::margin(10, 10, 10, 10)
    )

  if (!interactive) {
    return(plot)
  }

  ggiraph::girafe(
    ggobj = plot,
    width_svg = 10,
    height_svg = 6,
    options = list(
      # the overlay's alpha also fades its stroke, so restore full opacity
      ggiraph::opts_hover(
        css = "stroke:#2d224e;stroke-width:2px;stroke-opacity:1;"
      ),
      ggiraph::opts_sizing(rescale = TRUE, width = 1)
    )
  )
}

#' Plot transition network
#'
#' @description
#' `r lifecycle::badge("deprecated")`
#'
#' This function is deprecated. Use [plot_transition()] instead, which also
#' takes the counts returned by [compute_transition()] through `weight_col`.
#'
#' @param data Data frame with one row per move and `from` and `to` columns,
#'   as returned by [detect_transition()].
#' @param interactive Logical. If `TRUE` (default), return an interactive
#'   chart that shows each group's name on hover. If `FALSE`, return a static
#'   ggplot.
#'
#' @returns A ggiraph girafe object, or a ggplot object when
#'   `interactive = FALSE`.
#'
#' @keywords internal
#' @export
plot_transition_network <- function(data, interactive = TRUE) {
  lifecycle::deprecate_warn(
    when = "0.4.2",
    what = "plot_transition_network()",
    with = "plot_transition()"
  )

  plot_transition(data, interactive = interactive)
}

#' Plot transitions in and out of each group
#'
#' Draws, for each group and reference date, the moves into the group as blue
#' bars above zero and the moves out of it as orange bars below zero, with one
#' panel per group.
#'
#' @param data Data frame output of [compute_transition_flows()]. Bring a lazy
#'   table (`tbl_dbi`) into memory first with [dplyr::collect()].
#'
#' @returns A ggplot2 object.
#'
#' @seealso [plot_transition()] for the moves between groups as a network.
#'
#' @examples
#' careers <- data.frame(
#'   personnel_id = c("a", "a", "b", "b", "c", "c"),
#'   ref_date = as.Date(rep(c("2020-01-01", "2021-01-01"), times = 3)),
#'   unit = c("A", "B", "A", "C", "B", "A")
#' )
#' compute_transition(careers, group_col = "unit") |>
#'   compute_transition_flows() |>
#'   plot_transition_flows()
#'
#' @export
plot_transition_flows <- function(data) {
  # outflows are drawn below zero, so in and out read as one bar per date
  flows <- data |>
    dplyr::mutate(transitions_outflow = -.data[["transitions_outflow"]])

  flows |>
    ggplot2::ggplot(
      ggplot2::aes(x = .data[["ref_date"]])
    ) +
    ggplot2::geom_col(
      ggplot2::aes(
        y = .data[["transitions_inflow"]],
        fill = "Transitions in"
      )
    ) +
    ggplot2::geom_col(
      ggplot2::aes(
        y = .data[["transitions_outflow"]],
        fill = "Transitions out"
      )
    ) +
    ggplot2::geom_hline(
      yintercept = 0,
      linetype = "dashed",
      colour = "gray"
    ) +
    # blue for coming in, orange for going out, as in plot_movement()
    ggplot2::scale_fill_manual(
      name = NULL,
      values = c(
        "Transitions in" = "#202d85",
        "Transitions out" = "#de4500"
      )
    ) +
    ggplot2::scale_x_date(
      date_breaks = "1 year",
      date_labels = "%Y"
    ) +
    ggplot2::scale_y_continuous(
      labels = scales::comma
    ) +
    ggplot2::labs(
      x = "Year",
      y = "Transitions"
    ) +
    ggplot2::theme(
      legend.position = "bottom"
    ) +
    ggplot2::facet_wrap(
      ggplot2::vars(.data[["group"]]),
      ncol = 2,
      # group names such as occupations run long enough to overlap
      # neighbouring strips
      labeller = ggplot2::label_wrap_gen(width = 30)
    )
}
