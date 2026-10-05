#' Compute career transitions
#'
#' Tracks how people (or contracts) move between groups, such as paygrades or
#' departments, over time. Each entity's history is collapsed into spells: runs
#' of consecutive periods in the same group. Each spell is then paired with the
#' one that follows it, giving one row per move.
#'
#' @param data Data frame or remote database table (`tbl_dbi`) with a
#'   `ref_date` column, the identifier column and the grouping columns.
#' @param id_col Character. Column identifying whose career is tracked, such as
#'   a person or a contract. Default `"contract_id"`.
#' @param group_cols Character vector of columns defining a career position
#'   (e.g. paygrade, department). Several columns are combined into one label,
#'   such as `"G1 | Finance"`.
#' @param return_all Logical. Also keep each entity's last spell, which has no
#'   next group, so its `to` and `ref_date` are `NA`. This includes entities
#'   that never move. Default `FALSE`.
#' @param summarize Logical. Count moves by origin, destination and date
#'   instead of returning one row per move. Default `FALSE`.
#' @param ... Arguments passed to methods.
#'
#' @returns
#' With `summarize = FALSE`, one row per move with the identifier, `from` (the
#' group left), `to` (the group joined), `from_date` (when the spell in `from`
#' began) and `ref_date` (when the entity was first seen in `to`).
#'
#' With `summarize = TRUE`, one row per `from`, `to` and `ref_date`, with
#' `transitions`, the number of moves.
#'
#' A data.table for data frame input; a lazy table for `tbl_dbi` input (use
#' [dplyr::collect()] to bring it into memory).
#'
#' @details
#' Each move is dated when it happens: `ref_date` is the first period the
#' entity is seen in its new group. Dating it by when the previous spell began
#' would instead push every first move back to the start of the data.
#'
#' Rows with a missing identifier or group are dropped. Each entity must have
#' at most one record per `ref_date`, otherwise its position in that period is
#' unclear. Entities that break this rule are dropped entirely, with a warning
#' saying how many records were removed.
#'
#' @seealso [plot_transition_network()] to draw the moves as a network.
#'
#' @examples
#' careers <- data.frame(
#'   contract_id = c("a", "a", "a", "b", "b"),
#'   ref_date = as.Date(c(
#'     "2020-01-01", "2021-01-01", "2022-01-01", "2020-01-01", "2021-01-01"
#'   )),
#'   paygrade = c("G1", "G1", "G2", "G5", "G5")
#' )
#' compute_transition(careers, group_cols = "paygrade")
#' compute_transition(careers, group_cols = "paygrade", summarize = TRUE)
#'
#' @export
compute_transition <- function(data, ...) {
  UseMethod("compute_transition")
}

#' @rdname compute_transition
#' @importFrom data.table .N .SD := as.data.table rleidv setnames setorderv
#'   shift
#' @importFrom rlang check_dots_empty
#' @importFrom stats complete.cases
#' @export
compute_transition.data.frame <- function(
  data,
  id_col = "contract_id",
  group_cols,
  return_all = FALSE,
  summarize = FALSE,
  ...
) {
  rlang::check_dots_empty()

  dt <- data.table::as.data.table(data)

  dt <- dt[
    stats::complete.cases(dt[, c(id_col, group_cols), with = FALSE])
  ]

  # spells assume one position per entity per period. an entity holding several
  # records in the same period has no well-defined position, so drop the entity
  # outright rather than pick one of its records arbitrarily. checked after the
  # complete.cases filter, so records already dropped for missingness are not
  # counted as violations
  duplicate_keys <- duplicated(dt[, c(id_col, "ref_date"), with = FALSE])

  if (any(duplicate_keys)) {
    violating_ids <- unique(dt[[id_col]][duplicate_keys])
    violating_rows <- dt[[id_col]] %in% violating_ids

    warn_duplicate_records(
      n_duplicates = sum(duplicate_keys),
      n_rows = sum(violating_rows),
      n_ids = length(violating_ids),
      id_col = id_col
    )

    dt <- dt[!violating_rows]
  }

  # if necessary, combine group cols into a single column
  if (length(group_cols) > 1) {
    dt[, grouping := do.call(paste, c(.SD, sep = " | ")), .SDcols = group_cols]

    group_cols <- "grouping"
  }

  data.table::setorderv(dt, c(id_col, "ref_date"))

  # collapse to spell, i.e., when an entity stays in the same group for
  # consecutive periods
  dt[, ".spell_id" := data.table::rleidv(.SD), by = id_col, .SDcols = group_cols]

  spells <- unique(dt, by = c(id_col, ".spell_id"))[
    , c(id_col, group_cols, "ref_date"), with = FALSE
  ]

  data.table::setnames(
    spells,
    c(group_cols, "ref_date"),
    c("from", "from_date")
  )

  # date the transition by the destination spell, not the origin one: dating it
  # by the start of the `from` spell backdates every move to the period the
  # entity entered its previous group, which piles all first moves onto the
  # earliest date in the panel
  spells[
    ,
    c("to", "ref_date") := list(
      data.table::shift(get("from"), type = "lead"),
      data.table::shift(get("from_date"), type = "lead")
    ),
    by = id_col
  ]

  transitions <- spells[
    , c(id_col, "from", "to", "from_date", "ref_date"), with = FALSE
  ]
  # terminal spells have no `ref_date`, so order on the always-present date
  data.table::setorderv(transitions, c(id_col, "from_date"))

  # if return_all is FALSE, remove terminal spells (non-transitions)
  if (!return_all) {
    transitions <- transitions[!is.na(get("to"))]
  }

  if (summarize) {
    transitions <- transitions[
      , .(transitions = .N),
      by = c("from", "to", "ref_date")
    ]
    data.table::setorderv(transitions, c("ref_date", "from", "to"))
  }

  transitions[]
}

#' @rdname compute_transition
#' @importFrom dplyr all_of anti_join collect distinct filter lag lead left_join
#'   mutate n n_distinct select semi_join summarise
#' @importFrom rlang .data check_dots_empty
#' @export
compute_transition.tbl_dbi <- function(
  data,
  id_col = "contract_id",
  group_cols,
  return_all = FALSE,
  summarize = FALSE,
  ...
) {
  rlang::check_dots_empty()

  key_cols <- c(id_col, "ref_date")

  entity_group <- data |>
    drop_missing(
      c(id_col, group_cols)
    ) |>
    select(
      all_of(c(key_cols, group_cols))
    )

  # drop entities holding several records in the same period, even if those
  # records share the same group. checked after the missingness filter, so
  # dropped records are not counted as violations
  key_counts <- entity_group |>
    summarise(
      n_records = n(),
      .by = all_of(key_cols)
    )

  violating_ids <- key_counts |>
    filter(
      n_records > 1
    ) |>
    select(all_of(id_col)) |>
    distinct()

  violations <- key_counts |>
    semi_join(
      violating_ids,
      by = id_col
    ) |>
    summarise(
      n_duplicates = sum(n_records - 1, na.rm = TRUE),
      n_rows = sum(n_records, na.rm = TRUE),
      n_ids = n_distinct(.data[[id_col]])
    ) |>
    collect()

  if (violations$n_ids > 0) {
    warn_duplicate_records(
      n_duplicates = violations$n_duplicates,
      n_rows = violations$n_rows,
      n_ids = violations$n_ids,
      id_col = id_col
    )

    entity_group <- entity_group |>
      anti_join(
        violating_ids,
        by = id_col
      )
  }

  # if necessary, combine group cols into a single label. paste() cannot be
  # translated, so labels are built in base R for the distinct group values
  # and joined back
  if (length(group_cols) > 1) {
    group_labels <- entity_group |>
      select(all_of(group_cols)) |>
      distinct() |>
      collect()

    group_labels$from <- do.call(
      paste,
      c(group_labels[group_cols], sep = " | ")
    )

    entity_group <- entity_group |>
      left_join(
        group_labels,
        by = group_cols,
        copy = TRUE
      )
  } else {
    entity_group <- entity_group |>
      mutate(
        from = .data[[group_cols]]
      )
  }

  # a spell starts whenever the group differs from the previous observation
  spells <- entity_group |>
    mutate(
      prev_group = lag(from, order_by = ref_date),
      .by = all_of(id_col)
    ) |>
    filter(
      is.na(prev_group) | prev_group != from
    ) |>
    select(
      all_of(id_col), from, from_date = ref_date
    )

  # date the transition by the destination spell, not the origin one
  transitions <- spells |>
    mutate(
      to = lead(from, order_by = from_date),
      ref_date = lead(from_date, order_by = from_date),
      .by = all_of(id_col)
    ) |>
    select(
      all_of(id_col), from, to, from_date, ref_date
    )

  # if return_all is FALSE, remove terminal spells (non-transitions)
  if (!return_all) {
    transitions <- transitions |>
      filter(
        !is.na(to)
      )
  }

  if (summarize) {
    transitions <- transitions |>
      summarise(
        transitions = n(),
        .by = all_of(c("from", "to", "ref_date"))
      )
  }

  transitions
}

# shared by both compute_transition() methods, so they warn identically
warn_duplicate_records <- function(n_duplicates, n_rows, n_ids, id_col) {
  warning(
    sprintf(
      paste(
        "%d record(s) are not uniquely identified by `%s` and `ref_date`;",
        "dropping all %d record(s) for the %d affected `%s` value(s)."
      ),
      as.integer(n_duplicates),
      id_col,
      as.integer(n_rows),
      as.integer(n_ids),
      id_col
    ),
    call. = FALSE
  )
}

#' Plot transfer heatmap
#'
#' Draws transfers between groups as a heatmap, origin groups on the y-axis and
#' destination groups on the x-axis.
#'
#' @param data Data frame with `from`, `to` and `transfer` columns.
#'
#' @returns A plotly object.
#'
#' @importFrom plotly layout plot_ly
#' @importFrom stats median
#' @keywords internal
plot_transfer_heatmap <- function(data) {
  transfer <- data[["transfer"]]

  plotly::plot_ly(
    data = data,
    x = ~ data[["to"]],
    y = ~ data[["from"]],
    z = ~ data[["transfer"]],
    type = "heatmap",
    colorscale = list(
      c(min(transfer, na.rm = TRUE), "#d32f2f"),
      c(stats::median(transfer, na.rm = TRUE), "#f9a825"),
      c(max(transfer, na.rm = TRUE), "#388e3c")
    ),
    zmin = min(transfer, na.rm = TRUE),
    zmax = max(transfer, na.rm = TRUE),
    xgap = 2,
    ygap = 2,
    hovertemplate = paste0(
      "Group (to): %{x}<br>",
      "Group (from): %{y}<br>",
      "Transfers: %{z}",
      "<extra></extra>"
    ),
    colorbar = list(title = "Transfers")
  ) |>
    plotly::layout(
      xaxis = list(title = "Group (to)"),
      yaxis = list(title = "Group (from)")
    )
}

#' Plot transition network
#'
#' Draws career transitions as a directed graph, with edge width proportional to
#' the number of transitions and node size to degree centrality. Networks of ten
#' or more nodes are labelled by index rather than by name.
#'
#' @param data Data frame with one row per move and `from` and `to` columns,
#'   as returned by [compute_transition()] with `summarize = FALSE`.
#' @param interactive Logical. If `TRUE` (default), return an interactive
#'   chart that shows each establishment's name on hover. If `FALSE`, return a
#'   static ggplot, for outputs such as Word that cannot show interactive
#'   charts.
#'
#' @returns A ggiraph girafe object, or a ggplot object when
#'   `interactive = FALSE`.
#'
#' @importFrom dplyr across mutate pull row_number
#' @importFrom ggplot2 aes coord_cartesian expansion margin scale_color_manual
#'   scale_size_identity scale_x_continuous scale_y_continuous theme theme_void
#' @importFrom grDevices colorRampPalette
#' @importFrom tidygraph as_tbl_graph
#' @importFrom igraph gorder
#' @importFrom ggraph ggraph geom_edge_arc geom_node_point geom_node_text scale_edge_alpha_identity
#'   scale_edge_width_continuous
#' @importFrom ggiraph geom_point_interactive girafe opts_hover opts_sizing
#' 
#' @keywords internal
#' @export
plot_transition_network <- function(data, interactive = TRUE) {
  edges <- govhr::fastcount(data, .data[["from"]], .data[["to"]], name = "weight") |>
    # coerce to character to ensure that as_tble_graph produces a `name` column
    dplyr::mutate(
      dplyr::across(
        c("from", "to"), 
        as.character
      )
    )

  graph_data <- tidygraph::as_tbl_graph(edges, directed = TRUE)

  n_nodes <- igraph::gorder(graph_data)
  many_nodes <- n_nodes >= 10
  orange_palette <- grDevices::colorRampPalette(c("#C34729", "#F5C6A0"))(n_nodes)

  graph_data <- graph_data |>
    tidygraph::activate(nodes) |>
    tidygraph::mutate(
      node_id = as.character(dplyr::row_number()),
      node_id = factor(
        .data[["node_id"]],
        levels = as.character(sort(as.integer(.data[["node_id"]])))
      ),
      label = if (many_nodes) .data[["node_id"]] else .data[["name"]],
      degree = tidygraph::centrality_degree(mode = "all")
    )

  point_size <- scales::rescale(
    graph_data |> tidygraph::activate(nodes) |> dplyr::pull(.data[["degree"]]),
    to = if (many_nodes) c(6, 14) else c(20, 30)
  )

  plot <- ggraph::ggraph(graph_data, layout = "stress") +
    ggraph::geom_edge_arc(
      ggplot2::aes(edge_width = .data[["weight"]], edge_alpha = 0.5),
      color = "#4a5568",
      arrow = grid::arrow(length = grid::unit(3, "mm"), type = "closed"),
      end_cap = ggraph::circle(4, "mm"),
      start_cap = ggraph::circle(4, "mm")
    ) +
    ggraph::geom_node_point(
      ggplot2::aes(
        size = point_size,
        color = if (many_nodes) .data[["node_id"]] else "#C34729"
      )
    ) +
    ggraph::geom_node_text(
      ggplot2::aes(label = if (many_nodes) .data[["node_id"]] else .data[["name"]]),
      color = if (many_nodes) "white" else "#2d224e",
      size = if (many_nodes) 3 else 8,
      fontface = "bold"
    ) +
    ggiraph::geom_point_interactive(
      ggplot2::aes(
        x = .data[["x"]],
        y = .data[["y"]],
        size = point_size,
        tooltip = .data[["name"]],
        data_id = .data[["node_id"]]
      ),
      alpha = 0.01
    ) +
    ggraph::scale_edge_width_continuous(range = c(0.2, 3), guide = "none") +
    ggraph::scale_edge_alpha_identity(guide = "none") +
    ggplot2::scale_size_identity(guide = "none") +
    ggplot2::scale_color_manual(values = orange_palette, guide = "none") +
    # the layout pushes nodes to the extremes, so pad the panel and disable
    # clipping to keep the outermost points and labels whole
    ggplot2::scale_x_continuous(expand = ggplot2::expansion(mult = 0.12)) +
    ggplot2::scale_y_continuous(expand = ggplot2::expansion(mult = 0.12)) +
    ggplot2::coord_cartesian(clip = "off") +
    ggplot2::theme_void() +
    ggplot2::theme(
      legend.position = "none",
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
      ggiraph::opts_hover(css = "stroke:#2d224e;stroke-width:2px;"),
      ggiraph::opts_sizing(rescale = TRUE, width = 1)
    )
  )
}
