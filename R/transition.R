

#' Detect Personnel Reallocation Events
#'
#' Identifies reallocation events when a personnel's set of establishments changes
#' between consecutive reference dates. Removes hire events and only keeps
#' reallocation events after the earliest reference date for each personnel.
#'
#' @param data A data.frame or tibble containing at least the columns:
#'   - `personnel_id`: Unique personnel identifier.
#'   - `ref_date`: Reference date (Date or convertible to Date).
#'   - `est_id`: Establishment ID.
#' @param personnel_hire A data.frame or tibble containing hire events with columns
#'   `personnel_id` and `ref_date`.
#'
#' @return A tibble with columns:
#'   - `personnel_id`
#'   - `ref_date`
#'   - `est_id_nested`: List-column of establishment IDs for that personnel and date.
#'   - `type_event`: `"reallocation"` or `"no reallocation"`.
#'
#' @importFrom dplyr arrange select group_by mutate ungroup distinct filter anti_join lag
#' @importFrom tidyr nest
#' @importFrom purrr map2_chr
#'
#' @examples
#' \dontrun{
#' personnel_reallocation_df <- detect_reallocation(contract_rename_est_df, personnel_hire_df)
#' }
#' @export
detect_reallocation <- function(data, personnel_hire) {
  data_nested <- data %>%
    # Arrange by personnel, date, and org
    arrange(personnel_id, ref_date, est_id) %>%

    # Keep only relevant columns
    select(personnel_id, ref_date, est_id) %>%

    # Nest est_id by personnel_id and ref_date
    group_by(personnel_id, ref_date) %>%
    nest(.key = "est_id_nested")

  data_reallocation <- data_nested %>%

    # Detect reallocation events by comparing to previous ref_date
    group_by(personnel_id) %>%
    mutate(
      type_event = map2_chr(
        est_id_nested,
        lag(est_id_nested),
        ~ ifelse(!identical(.x, .y), "reallocation", "no reallocation")
      )
    ) %>%
    select(-est_id_nested) |>
    ungroup() %>%

    # Remove hire events
    anti_join(
      personnel_hire %>% distinct(personnel_id, ref_date),
      by = c("personnel_id", "ref_date")
    ) %>%

    # Keep only reallocation events after earliest ref_date
    group_by(personnel_id) %>%
    filter(ref_date > min(ref_date) & type_event == "reallocation") %>%
    ungroup()

  return(data_reallocation)
}

#' Detect Career Transitions Based on Contract Attributes
#'
#' @description
#' Identifies transitions in specified job-related attributes (e.g., pay grade, seniority)
#' for each personnel over time. The function first determines the "dominant" contract
#' per personnel and reference date based on a decision variable (e.g., highest base salary),
#' and then detects when the selected attributes change across time.
#'
#' @param contract_dt A `data.table`, `data.frame` object containing contract level records.
#' Must include columns for `personnel_id`, `ref_date`, the variables listed in `vars`,
#' and the `decision_var`.
#' @param vars A character vector of attribute names (column names) to monitor for changes
#' (e.g., `c("paygrade", "seniority")`).
#' @param decision_var A string specifying the column name used to identify the dominant
#' contract per personnel and date (e.g., `"base_salary_lcu"`).
#' @param decision_fn A function defining the decision rule for selecting the dominant
#' contract within each personnel-date group (default: `max`). Typically `max`, `min`, or
#' a custom summary function.
#'
#' @details
#' The function:
#' \enumerate{
#'   \item Sorts contracts by `personnel_id`, `ref_date`, and the decision variable.
#'   \item Selects the dominant contract per personnel-date combination using `decision_fn`.
#'   \item For each attribute in `vars`, compares its value to the previous record
#'   (by personnel) and detects any changes.
#'   \item Returns all transitions, including the attribute name, previous and new values,
#'   and the start and end dates for the transition.
#' }
#'
#' The function assumes that higher values of `decision_var` represent more dominant
#' contracts when `decision_fn = max`. If ties occur, the first instance is selected.
#'
#' @return A `data.table` with the following columns:
#' \describe{
#'   \item{personnel_id}{Unique personnel identifier.}
#'   \item{start_date}{Date of the previous contract before the change.}
#'   \item{ref_date}{Date when the new attribute value takes effect.}
#'   \item{attribute}{Name of the attribute that changed.}
#'   \item{from}{Previous value of the attribute.}
#'   \item{to}{New value of the attribute.}
#' }
#'
#' @examples
#' library(data.table)
#' dt <- data.table(
#'   personnel_id = c(1, 1, 1, 2, 2),
#'   ref_date = as.Date(c("2020-01-01", "2021-01-01", "2022-01-01",
#'                        "2020-06-01", "2021-06-01")),
#'   paygrade = c("A", "A", "B", "C", "D"),
#'   seniority = c(1, 2, 3, 1, 2),
#'   base_salary_lcu = c(50000, 55000, 60000, 40000, 42000)
#' )
#'
#' detect_career_transitions(
#'   contract_dt = dt,
#'   vars = c("paygrade", "seniority"),
#'   decision_var = "base_salary_lcu"
#' )
#'
#' @export
detect_career_transitions <- function(
  contract_dt,
  vars,
  decision_var,
  decision_fn = max
) {
  # Keep only needed columns
  contract_dt <- contract_dt[,
    c("personnel_id", "ref_date", vars, decision_var),
    with = FALSE
  ]

  # Sort by personnel, date, and decision variable
  setorderv(
    contract_dt,
    c("personnel_id", "ref_date", decision_var),
    order = c(1, 1, -1)
  )

  # Apply decision rule: pick the dominant job for each personnel-date
  # We assume decision_fn = max by default (i.e. highest of whatever decision_var)
  contract_main <- contract_dt[,
    .SD[get(decision_var) == decision_fn(get(decision_var))][1],
    by = .(personnel_id, ref_date)
  ]

  # Now detect transitions for each variable
  detect_transitions <- function(attr) {
    # Add previous value by personnel
    contract_main[,
      paste0(attr, "_prev") := shift(get(attr)),
      by = personnel_id
    ]

    # Keep rows where the attribute changed
    transitions <- contract_main[
      get(attr) != get(paste0(attr, "_prev")),
      .(
        personnel_id,
        start_date = shift(ref_date, 1L, type = "lag"),
        ref_date,
        attribute = attr,
        from = get(paste0(attr, "_prev")),
        to = get(attr)
      ),
      by = personnel_id
    ]

    return(transitions[])
  }

  # Apply transition detection across all attributes
  transitions_list <- lapply(vars, detect_transitions)

  # Combine all attributes into one long data.table
  transitions_dt <- data.table::rbindlist(transitions_list, use.names = TRUE)

  return(transitions_dt[])
}

#' Detect Career Transitions
#'
#' Collapses each entity's history into spells of consecutive periods in the
#' same group, then pairs each spell with the one that follows it. A row is
#' dated by `ref_date`, the period in which the entity is first observed in the
#' destination group, so a transition is counted when it happens. `from_date`
#' records when the origin spell began.
#'
#' Records must be uniquely identified by `id_col` and `ref_date`. An entity
#' holding more than one record in the same period has no well-defined position,
#' so every record for that entity is dropped with a warning reporting how many.
#'
#' @param .data Data frame containing a `ref_date` column, the identifier and
#'   the grouping columns.
#' @param id_col Character. Column identifying the entity whose career is
#'   tracked. Default `"contract_id"`.
#' @param group_cols Character vector of columns defining the career position
#'   (e.g. paygrade, department). Multiple columns are pasted into one label.
#' @param return_all Logical. Keep terminal spells, which have no destination
#'   and so carry `NA` in both `to` and `ref_date`. Default `FALSE`.
#'
#' @return A data table with the identifier, `from`, `to`, `from_date` and
#'   `ref_date`.
#'
#' @importFrom data.table as.data.table rleidv setnames setorderv shift
#' @importFrom stats complete.cases
#' @export
detect_career_transition <- function(
  .data, id_col = "contract_id", group_cols,
  return_all = FALSE
) {
  dt <- data.table::as.data.table(.data)

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

    warning(
      sprintf(
        paste(
          "%d record(s) are not uniquely identified by `%s` and `ref_date`;",
          "dropping all %d record(s) for the %d affected `%s` value(s)."
        ),
        sum(duplicate_keys),
        id_col,
        sum(violating_rows),
        length(violating_ids),
        id_col
      ),
      call. = FALSE
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

  out <- spells[
    , c(id_col, "from", "to", "from_date", "ref_date"), with = FALSE
  ]
  # terminal spells have no `ref_date`, so order on the always-present date
  data.table::setorderv(out, c(id_col, "from_date"))

  # if return_all is FALSE, remove non-transitions
  if (!return_all) {
    out <- out[!is.na(get("to"))]
  }

  out[]
}


#' Plot Transfer Heatmap
#'
#' Draws transfers between groups as a heatmap, origin groups on the y-axis and
#' destination groups on the x-axis.
#'
#' @param .data Data frame with `from`, `to` and `transfer` columns.
#'
#' @return A plotly object.
#'
#' @importFrom plotly layout plot_ly
#' @importFrom stats median
#' @keywords internal
plot_transfer_heatmap <- function(.data) {
  transfer <- .data[["transfer"]]

  plotly::plot_ly(
    data = .data,
    x = ~ .data[["to"]],
    y = ~ .data[["from"]],
    z = ~ .data[["transfer"]],
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

#' Plot Transition Network
#'
#' Draws career transitions as a directed graph, with edge width proportional to
#' the number of transitions and node size to degree centrality. Networks of ten
#' or more nodes are labelled by index rather than by name.
#'
#' @param .data Data frame with `from` and `to` columns, as returned by
#'   [detect_career_transition()].
#'
#' @return A ggiraph girafe object.
#'
#' @importFrom dplyr across mutate pull row_number
#' @importFrom ggplot2 aes coord_cartesian expansion margin scale_color_manual
#'   scale_size_identity scale_x_continuous scale_y_continuous theme theme_void
#' @importFrom govhr fastcount
#' @importFrom grDevices colorRampPalette
#' @importFrom tidygraph as_tbl_graph
#' @importFrom igraph gorder
#' @importFrom ggraph ggraph geom_edge_arc geom_node_point geom_node_text scale_edge_alpha_identity
#'   scale_edge_width_continuous
#' @importFrom ggiraph geom_point_interactive girafe opts_hover opts_sizing
#' 
#' @keywords internal
#' @export
plot_transition_network <- function(.data) {
  edges <- govhr::fastcount(.data, .data[["from"]], .data[["to"]], name = "weight") |>
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
    tidygraph::activate(
      .data[["nodes"]]
    ) |>
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
    graph_data |> tidygraph::activate(.data[["nodes"]]) |> dplyr::pull(.data[["degree"]]),
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
