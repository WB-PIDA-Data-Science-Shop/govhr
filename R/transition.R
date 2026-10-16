#' Compute career transitions
#'
#' Tracks how people (or contracts) move between groups, such as paygrades or
#' departments, over time. A move happens when an entity joins a group it did
#' not hold in its previous period, and pairs each group it held then with
#' each group it joins, giving one row per move.
#'
#' @param data Data frame or remote database table (`tbl_dbi`) with a
#'   `ref_date` column, the identifier column and the grouping columns.
#' @param id_col Character. Column identifying whose career is tracked, such as
#'   a person or a contract. Default `"personnel_id"`.
#' @param group_cols Character vector of columns defining a career position
#'   (e.g. paygrade, department). Several columns are combined into one label,
#'   such as `"G1 | Finance"`.
#' @param return_all Logical. Also keep the groups held in the last period of
#'   each career, which have no next group, so their `to` and `ref_date` are
#'   `NA`. This includes entities that never move. Default `FALSE`.
#' @param summarize Logical. Count moves by origin, destination and date
#'   instead of returning one row per move. Default `FALSE`.
#' @param drop_duplicates Logical. Drop every entity with more than one record
#'   on the same `ref_date`, with a warning, so that each entity holds a single
#'   group per period. Default `FALSE`, which keeps entities holding several
#'   groups at once. See Details.
#' @param across_separations Logical. Count moves made across a separation,
#'   i.e. between the groups an entity held before leaving the data and those
#'   it holds on its return. Default `FALSE`, which treats the return as the
#'   start of a new career. See Details.
#' @param ... Arguments passed to methods.
#'
#' @returns
#' With `summarize = FALSE`, one row per move with the identifier, `from` (a
#' group held in the period before the move), `to` (a group joined),
#' `from_date` (when the entity began holding `from` without a break) and
#' `ref_date` (when the entity was first seen in `to`).
#'
#' With `summarize = TRUE`, one row per `from`, `to` and `ref_date`, with
#' `transitions`, the number of moves, and `transition_rate`, those moves
#' divided by the headcount in `from` on the previous date in the data, as in
#' [compute_movement()].
#'
#' A data.table for data frame input; a lazy table for `tbl_dbi` input (use
#' [dplyr::collect()] to bring it into memory).
#'
#' @details
#' Each move is dated when it happens: `ref_date` is the first period the
#' entity is seen in its new group. Dating it by when the entity entered its
#' previous group would instead push every first move back to the start of the
#' data.
#'
#' An entity may hold several groups on the same date, such as two
#' occupations. Each group it held in its previous period is paired with each
#' group it joins, so holding `A` and `B` and then `A` and `C` gives two moves,
#' `A -> C` and `B -> C`. Leaving a group without joining another, such as
#' holding `A` and `B` and then only `A`, is not a move. Several records in the
#' same group, such as two contracts in the same paygrade, hold it once.
#'
#' With `drop_duplicates = TRUE`, an entity with more than one record on a
#' date, even in the same group, is dropped entirely, with a warning saying
#' how many records were removed.
#'
#' An entity missing on the next date in the data has separated, for instance
#' from the public sector, and may later return. By default its return starts
#' a new career: the groups it held before leaving are the last of the old
#' career, and the groups it returns to are not moves. Pass only the records in
#' which entities are active, such as active contracts, so that inactive
#' periods count as separations. With `across_separations = TRUE`, separations
#' are ignored, so a move can span dates on which the entity is missing.
#' `transition_rate` still divides by the headcount on the previous date in
#' the data, which such an entity is not part of.
#'
#' Rows with a missing identifier or group are dropped.
#'
#' @seealso [plot_transition_network()] to draw the moves as a network.
#'
#' @examples
#' careers <- data.frame(
#'   personnel_id = c("a", "a", "a", "b", "b", "b", "b"),
#'   ref_date = as.Date(c(
#'     "2020-01-01", "2021-01-01", "2022-01-01",
#'     "2020-01-01", "2020-01-01", "2021-01-01", "2021-01-01"
#'   )),
#'   paygrade = c("G1", "G1", "G2", "A", "B", "A", "C")
#' )
#' compute_transition(careers, group_cols = "paygrade")
#' compute_transition(careers, group_cols = "paygrade", summarize = TRUE)
#'
#' # b holds two paygrades at once, so is dropped
#' compute_transition(careers, group_cols = "paygrade", drop_duplicates = TRUE)
#'
#' # c leaves after 2020 and returns to a different paygrade in 2022
#' returns <- data.frame(
#'   personnel_id = "c",
#'   ref_date = as.Date(c("2020-01-01", "2022-01-01")),
#'   paygrade = c("G1", "G2")
#' )
#' compute_transition(rbind(careers, returns), group_cols = "paygrade")
#' compute_transition(
#'   rbind(careers, returns),
#'   group_cols = "paygrade",
#'   across_separations = TRUE
#' )
#'
#' @export
compute_transition <- function(data, ...) {
  UseMethod("compute_transition")
}

#' @rdname compute_transition
#' @importFrom data.table .N .SD := as.data.table fifelse setkey setnames
#'   setorderv shift
#' @importFrom rlang check_dots_empty
#' @importFrom stats complete.cases
#' @export
compute_transition.data.frame <- function(
  data,
  id_col = "personnel_id",
  group_cols,
  return_all = FALSE,
  summarize = FALSE,
  drop_duplicates = FALSE,
  across_separations = FALSE,
  ...
) {
  rlang::check_dots_empty()

  key_cols <- c(id_col, "ref_date")

  dt <- data.table::as.data.table(data)[, c(key_cols, group_cols), with = FALSE]

  dt <- dt[
    stats::complete.cases(dt[, c(id_col, group_cols), with = FALSE])
  ]

  # checked after the complete.cases filter, so records already dropped for
  # missingness are not counted as violations
  if (drop_duplicates) {
    duplicate_keys <- duplicated(dt[, key_cols, with = FALSE])

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
  }

  # if necessary, combine group cols into a single column
  if (length(group_cols) > 1) {
    dt[, "from" := do.call(paste, c(.SD, sep = " | ")), .SDcols = group_cols]
  } else {
    data.table::setnames(dt, group_cols, "from")
  }

  positions <- unique(dt[, c(key_cols, "from"), with = FALSE])

  periods <- unique(positions[, key_cols, with = FALSE])
  data.table::setorderv(periods, key_cols)
  periods[, prev_date := data.table::shift(ref_date)]
  periods[, next_date := data.table::shift(ref_date, type = "lead")]
  periods[!same_as_neighbour(periods, id_col), prev_date := NA]
  periods[!same_as_neighbour(periods, id_col, type = "lead"), next_date := NA]

  dates <- sort(unique(periods[["ref_date"]]))

  # an entity missing on the next date in the data has separated, so the
  # periods on either side of the gap are not neighbours: the earlier one ends
  # a career and the later one starts the next, with no move between them
  if (!across_separations) {
    date_index <- match(periods[["ref_date"]], dates)
    periods[
      prev_date != data.table::shift(dates)[date_index],
      prev_date := NA
    ]
    periods[
      next_date != data.table::shift(dates, type = "lead")[date_index],
      next_date := NA
    ]
  }

  positions[
    periods,
    on = key_cols,
    c("prev_date", "next_date") := .(i.prev_date, i.next_date)
  ]

  # a group was held in the entity's previous period if its record before, in
  # the same group, is exactly that period
  data.table::setorderv(positions, c(id_col, "from", "ref_date"))
  held_before <- same_as_neighbour(positions, c(id_col, "from")) &
    data.table::shift(positions[["ref_date"]]) == positions[["prev_date"]]
  held_before <- !is.na(held_before) & held_before

  # each record is dated by the latest record of its group not held before,
  # where the entity began holding it. a running maximum of row numbers finds
  # it in one pass, where grouping by entity and group would run once per
  # group
  run_start <- cummax(
    data.table::fifelse(held_before, 0L, seq_len(nrow(positions)))
  )
  positions[, from_date := ref_date[run_start]]

  # a group not held in the previous period was joined then. the first period
  # has nothing before it
  destinations <- positions[
    !is.na(prev_date) & !held_before,
    c(id_col, "prev_date", "ref_date", "from"),
    with = FALSE
  ]
  data.table::setnames(destinations, c("prev_date", "from"), c("origin_date", "to"))

  origins <- positions[
    , c(id_col, "ref_date", "next_date", "from", "from_date"),
    with = FALSE
  ]
  data.table::setnames(origins, "ref_date", "origin_date")

  # every group held before a move is paired with every group joined in it
  transitions <- merge(
    origins,
    destinations,
    by = c(id_col, "origin_date"),
    all.x = return_all,
    allow.cartesian = TRUE
  )

  # a period followed only by leaving a group is no move, and is kept only if
  # it is the last of its career
  if (return_all) {
    transitions <- transitions[!is.na(to) | is.na(next_date)]
  }

  transitions <- transitions[
    , c(id_col, "from", "to", "from_date", "ref_date"), with = FALSE
  ]
  data.table::setkey(transitions, NULL)
  data.table::setorderv(
    transitions,
    c(id_col, "ref_date", "from", "to"),
    na.last = TRUE
  )

  if (summarize) {
    transitions <- transitions[
      , .(transitions = .N),
      by = c("from", "to", "ref_date")
    ]

    # each group's headcount moves forward to the next date, whose moves it is
    # the origin for
    group_headcount <- positions[
      , .(prev_headcount = .N),
      by = c("ref_date", "from")
    ]
    group_headcount[, ref_date := dates[match(ref_date, dates) + 1L]]

    # the last date has no next date, and its NA would match the undated rows
    # of return_all
    transitions[
      group_headcount[!is.na(ref_date)],
      on = c("from", "ref_date"),
      transition_rate := transitions / i.prev_headcount
    ]
    data.table::setorderv(
      transitions,
      c("ref_date", "from", "to"),
      na.last = TRUE
    )
  }

  transitions[]
}

# shifting within `by` groups runs once per group, which is far slower than one
# vectorised comparison when there are millions of entities. `dt` must already
# be sorted by `cols`
same_as_neighbour <- function(dt, cols, type = "lag") {
  matches <- lapply(
    cols,
    function(col) dt[[col]] == data.table::shift(dt[[col]], type = type)
  )
  same <- Reduce(`&`, matches)

  !is.na(same) & same
}

#' @rdname compute_transition
#' @importFrom dplyr across all_of anti_join collect distinct filter if_else
#'   inner_join lag lead left_join mutate n n_distinct rename row_number select
#'   semi_join summarise
#' @importFrom rlang .data check_dots_empty
#' @export
compute_transition.tbl_dbi <- function(
  data,
  id_col = "personnel_id",
  group_cols,
  return_all = FALSE,
  summarize = FALSE,
  drop_duplicates = FALSE,
  across_separations = FALSE,
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
  if (drop_duplicates) {
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

    if (violations[["n_ids"]] > 0) {
      warn_duplicate_records(
        n_duplicates = violations[["n_duplicates"]],
        n_rows = violations[["n_rows"]],
        n_ids = violations[["n_ids"]],
        id_col = id_col
      )

      entity_group <- entity_group |>
        anti_join(
          violating_ids,
          by = id_col
        )
    }
  }

  # if necessary, combine group cols into a single label. paste() cannot be
  # translated, so labels are built in base R for the distinct group values
  # and joined back
  if (length(group_cols) > 1) {
    group_labels <- entity_group |>
      select(all_of(group_cols)) |>
      distinct() |>
      collect()

    group_labels[["from"]] <- do.call(
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

  positions <- entity_group |>
    select(
      all_of(key_cols), from
    ) |>
    distinct()

  periods <- positions |>
    distinct(
      across(all_of(key_cols))
    ) |>
    mutate(
      prev_date = lag(ref_date, order_by = ref_date),
      next_date = lead(ref_date, order_by = ref_date),
      period = row_number(ref_date),
      .by = all_of(id_col)
    )

  # an entity missing on the next date in the data has separated, so the
  # periods on either side of the gap are not neighbours. numbering periods by
  # their place in the calendar, not among the entity's own dates, also breaks
  # each run of a group at the gap
  if (!across_separations) {
    calendar <- build_calendar(periods) |>
      mutate(
        calendar_period = row_number(ref_date)
      ) |>
      rename(
        calendar_prev = prev_date,
        calendar_next = next_date
      )

    periods <- periods |>
      left_join(
        calendar,
        by = "ref_date"
      ) |>
      mutate(
        prev_date = if_else(prev_date == calendar_prev, prev_date, NA),
        next_date = if_else(next_date == calendar_next, next_date, NA),
        period = calendar_period
      ) |>
      select(
        all_of(key_cols), prev_date, next_date, period
      )
  }

  # records held in consecutive periods of the entity keep the same gap between
  # the entity's period number and the group's record number, which marks each
  # unbroken run in a group. SQL has no ordered running maximum without
  # dbplyr::window_order(), hence this rather than the data.table approach
  runs <- positions |>
    inner_join(
      periods,
      by = key_cols
    ) |>
    mutate(
      run = period - row_number(ref_date),
      .by = all_of(c(id_col, "from"))
    ) |>
    mutate(
      from_date = min(ref_date, na.rm = TRUE),
      .by = all_of(c(id_col, "from", "run"))
    )

  # a run that starts after the entity's first period is a group joined then
  destinations <- runs |>
    filter(
      !is.na(prev_date),
      ref_date == from_date
    ) |>
    select(
      all_of(id_col), origin_date = prev_date, ref_date, to = from
    )

  origins <- runs |>
    select(
      all_of(id_col), origin_date = ref_date, next_date, from, from_date
    )

  # every group held before a move is paired with every group joined in it. a
  # period followed only by leaving a group is no move, and is kept only if it
  # is the last of its career
  if (return_all) {
    transitions <- origins |>
      left_join(
        destinations,
        by = c(id_col, "origin_date")
      ) |>
      filter(
        !is.na(to) | is.na(next_date)
      )
  } else {
    transitions <- origins |>
      inner_join(
        destinations,
        by = c(id_col, "origin_date")
      )
  }

  transitions <- transitions |>
    select(
      all_of(id_col), from, to, from_date, ref_date
    )

  if (summarize) {
    # each group's headcount moves forward to the next date, whose moves it is
    # the origin for
    group_headcount <- positions |>
      summarise(
        prev_headcount = n(),
        .by = c("ref_date", "from")
      ) |>
      inner_join(
        build_calendar(positions),
        by = "ref_date"
      ) |>
      select(
        from, ref_date = next_date, prev_headcount
      )

    transitions <- transitions |>
      summarise(
        transitions = n(),
        .by = all_of(c("from", "to", "ref_date"))
      ) |>
      left_join(
        group_headcount,
        by = c("from", "ref_date")
      ) |>
      # some databases divide integers with integer division
      mutate(
        transition_rate = as.numeric(transitions) / prev_headcount
      ) |>
      select(
        from, to, ref_date, transitions, transition_rate
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
