#' Detect transitions
#'
#' Tracks how entities move between groups, such as paygrades or
#' departments, over time. A move happens when an entity joins a group it did
#' not hold in its previous period, and pairs each group it held then with
#' each group it joins, returning one record per transition
#'
#' @param data Data frame or remote database table (`tbl_dbi`) with a
#'   `ref_date` column, the identifier column and the grouping column.
#' @param id_col Character. Column identifying whose career is tracked, such as
#'   a person or a contract. Default `"personnel_id"`.
#' @param group_col Character. Column defining a group, such as a
#'   paygrade or a department. To track a combination of groups, such as
#'   paygrade within department, combine them into one column beforehand 
#'   (e.g., `paste(paygrade, department, sep = "|")`).
#' @param drop_duplicates Logical. Drop every entity with more than one record
#'   on the same `ref_date`, with a warning, so that each entity belongs to a single
#'   group per period. Default `FALSE`, which keeps entities belonging to several
#'   groups at once. See Details.
#' @param across_separations Logical. Count moves made across a separation,
#'   i.e. between the groups an entity held before leaving the public sector and those
#'   it holds on its return. Default `FALSE`, which treats the return as the
#'   start of a new career. See Details.
#' @param ... Arguments passed to methods.
#'
#' @returns One row per move with the identifier, `from` (a group held in the
#'   period before the move), `to` (a group joined), `from_date` (when the
#'   entity began holding `from` without a break) and `ref_date` (when the
#'   entity was first seen in `to`). A data.table for data frame input; a lazy
#'   table for `tbl_dbi` input (use [dplyr::collect()] to bring it into
#'   memory).
#'
#' @details
#' Each move is dated when it happens: `ref_date` is the first period the
#' entity is seen in its new group. Dating it by when the entity entered its
#' previous group would instead push every first move back to the start of the
#' data.
#'
#' An entity may belong to several groups on the same date, such as two
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
#' An entity may separate itself from the public sector and return later in time.
#' By default its return starts a new career: the groups it held before leaving 
#' are the last of the old career, and the groups it returns to are not moves. 
#' Pass only the records in which entities are active, such as active contracts, 
#' so that inactive periods count as separations. With `across_separations = TRUE`, 
#' separations are ignored, so a move can span dates on which the entity is missing.
#'
#' Rows with a missing identifier or group are silently dropped.
#'
#' @seealso [compute_transition()], which counts these moves.
#'   [plot_transition_network()] to draw them as a network.
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
#' detect_transition(careers, group_col = "paygrade")
#'
#' # b holds two paygrades at once, so is dropped
#' detect_transition(careers, group_col = "paygrade", drop_duplicates = TRUE)
#'
#' # c leaves after 2020 and returns to a different paygrade in 2022
#' returns <- data.frame(
#'   personnel_id = "c",
#'   ref_date = as.Date(c("2020-01-01", "2022-01-01")),
#'   paygrade = c("G1", "G2")
#' )
#' detect_transition(rbind(careers, returns), group_col = "paygrade")
#' detect_transition(
#'   rbind(careers, returns),
#'   group_col = "paygrade",
#'   across_separations = TRUE
#' )
#'
#' @export
detect_transition <- function(data, ...) {
  UseMethod("detect_transition")
}

#' @rdname detect_transition
#' @export
detect_transition.data.frame <- function(
  data,
  id_col = "personnel_id",
  group_col,
  drop_duplicates = FALSE,
  across_separations = FALSE,
  ...
) {
  rlang::check_dots_empty()

  if (length(group_col) != 1) {
    stop("`group_col` must be a single column name.", call. = FALSE)
  }

  key_cols <- c(id_col, "ref_date")

  dt <- data.table::as.data.table(data)[, c(key_cols, group_col), with = FALSE]

  dt <- dt[
    stats::complete.cases(dt[, c(id_col, group_col), with = FALSE])
  ]

  # checked after the missingness filter, so records already dropped for
  # missingness are not counted as violations
  if (drop_duplicates) {
    dt <- drop_duplicate(dt, id_col = id_col)
  }

  data.table::setnames(dt, group_col, "from")

  positions <- unique(dt)

  periods <- unique(positions[, key_cols, with = FALSE])
  data.table::setorderv(periods, key_cols)
  periods[, prev_date := data.table::shift(ref_date)]
  periods[!same_as_neighbour(periods, id_col), prev_date := NA]

  # an entity missing on the next date in the data has separated, so the
  # periods on either side of the gap are not neighbours: the earlier one ends
  # a career and the later one starts the next, with no move between them
  if (!across_separations) {
    dates <- sort(unique(periods[["ref_date"]]))
    date_index <- match(periods[["ref_date"]], dates)
    periods[
      prev_date != data.table::shift(dates)[date_index],
      prev_date := NA
    ]
  }

  positions[periods, on = key_cols, prev_date := i.prev_date]

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
    , c(id_col, "ref_date", "from", "from_date"),
    with = FALSE
  ]
  data.table::setnames(origins, "ref_date", "origin_date")

  # every group held before a move is paired with every group joined in it. a
  # period followed only by leaving a group finds no destination, so is no move
  transitions <- merge(
    origins,
    destinations,
    by = c(id_col, "origin_date"),
    allow.cartesian = TRUE
  )

  transitions <- transitions[
    , c(id_col, "from", "to", "from_date", "ref_date"), with = FALSE
  ]
  data.table::setkey(transitions, NULL)
  data.table::setorderv(transitions, c(id_col, "ref_date", "from", "to"))

  transitions[]
}

#' @rdname detect_transition
#' @export
detect_transition.tbl_dbi <- function(
  data,
  id_col = "personnel_id",
  group_col,
  drop_duplicates = FALSE,
  across_separations = FALSE,
  ...
) {
  rlang::check_dots_empty()

  if (length(group_col) != 1) {
    stop("`group_col` must be a single column name.", call. = FALSE)
  }

  key_cols <- c(id_col, "ref_date")

  positions <- data |>
    drop_missing(
      c(id_col, group_col)
    ) |>
    dplyr::select(
      dplyr::all_of(key_cols),
      from = dplyr::all_of(group_col)
    )

  # checked after the missingness filter, so records already dropped for
  # missingness are not counted as violations
  if (drop_duplicates) {
    positions <- drop_duplicate(positions, id_col = id_col)
  }

  positions <- positions |>
    dplyr::distinct()

  # periods refer to the entity's own sequence of reference dates,
  # so that each entity's career is tracked independently.
  periods <- positions |>
    dplyr::distinct(
      dplyr::across(dplyr::all_of(key_cols))
    ) |>
    dplyr::mutate(
      prev_date = dplyr::lag(ref_date, order_by = ref_date),
      period = dplyr::row_number(ref_date),
      .by = dplyr::all_of(id_col)
    )

  # an entity missing on the next date in the data has separated from the public sector.
  # numbering periods by their place with reference to the calendar
  # induces a break in their run.
  if (!across_separations) {
    calendar <- build_calendar(periods) |>
      dplyr::mutate(
        calendar_period = dplyr::row_number(ref_date)
      ) |>
      dplyr::select(
        ref_date, calendar_prev = prev_date, calendar_period
      )

    periods <- periods |>
      dplyr::left_join(
        calendar,
        by = "ref_date"
      ) |>
      dplyr::mutate(
        prev_date = dplyr::if_else(prev_date == calendar_prev, prev_date, NA),
        period = calendar_period
      ) |>
      dplyr::select(
        dplyr::all_of(key_cols), prev_date, period
      )
  }

  # records held in consecutive periods of the entity keep the same gap between
  # the entity's period number and the group's record number by entity,
  # defining the entity's contiguous run within a group.
  runs <- positions |>
    dplyr::inner_join(
      periods,
      by = key_cols
    ) |>
    dplyr::mutate(
      run = period - dplyr::row_number(ref_date),
      .by = dplyr::all_of(c(id_col, "from"))
    ) |>
    dplyr::mutate(
      from_date = min(ref_date, na.rm = TRUE),
      .by = dplyr::all_of(c(id_col, "from", "run"))
    )

  # a run that starts after the entity's first period is a group joined then
  destinations <- runs |>
    dplyr::filter(
      !is.na(prev_date),
      ref_date == from_date
    ) |>
    dplyr::select(
      dplyr::all_of(id_col),
      origin_date = prev_date,
      ref_date,
      to = from
    )

  origins <- runs |>
    dplyr::select(
      dplyr::all_of(id_col),
      origin_date = ref_date,
      from,
      from_date
    )

  # every group held before a move is paired with every group joined in it. a
  # period followed only by leaving a group finds no destination, so is no move
  origins |>
    dplyr::inner_join(
      destinations,
      by = c(id_col, "origin_date")
    ) |>
    dplyr::select(
      dplyr::all_of(id_col), from, to, from_date, ref_date
    )
}

#' Compute career transitions
#'
#' Counts, for each reference date, how many entities moved from one group to
#' another since the previous date, and what share of the origin group they
#' make up.
#'
#' @inheritParams detect_transition
#'
#' @returns A table with one row per `from`, `to` and `ref_date`, containing:
#' \describe{
#'   \item{transitions}{Number of moves from `from` to `to` dated `ref_date`,
#'     as detected by [detect_transition()].}
#'   \item{transition_rate}{`transitions` divided by the headcount in `from`
#'     on the previous date in the data, as in [compute_movement()].}
#' }
#' A data.table for data frame input; a lazy table for `tbl_dbi` input (use
#' [dplyr::collect()] to bring it into memory).
#'
#' @details
#' Moves are found and dated as in [detect_transition()], so an entity holding
#' several groups moves from each group it held to each group it joins.
#'
#' The headcount is the number of distinct entities in each group on each
#' date, from [count_entity()], so each entity counts once in every group it
#' holds. It is counted on the same records as the moves: rows with a missing
#' identifier or group, and with `drop_duplicates = TRUE` the entities dropped
#' as duplicates, are left out of both.
#'
#' With `across_separations = TRUE`, a move can span dates on which the entity
#' is missing, but `transition_rate` still divides by the headcount on the
#' previous date in the data, which such an entity is not part of.
#'
#' @seealso [detect_transition()], which finds each move.
#'   [compute_movement()], which counts hires and separations.
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
#' compute_transition(careers, group_col = "paygrade")
#'
#' @export
compute_transition <- function(data, ...) {
  UseMethod("compute_transition")
}

#' @rdname compute_transition
#' @export
compute_transition.data.frame <- function(
  data,
  id_col = "personnel_id",
  group_col,
  drop_duplicates = FALSE,
  across_separations = FALSE,
  ...
) {
  rlang::check_dots_empty()

  key_cols <- c(id_col, "ref_date")

  # drop missing group_col and id_col
  records <- data.table::as.data.table(data)[, c(key_cols, group_col), with = FALSE]

  records <- records[
    stats::complete.cases(records[, c(id_col, group_col), with = FALSE])
  ]

  if (drop_duplicates) {
    records <- drop_duplicate(records, id_col = id_col)
  }

  # duplicates are already dropped, so detect_transition() has none left
  transitions <- detect_transition(
    records,
    id_col = id_col,
    group_col = group_col,
    drop_duplicates = FALSE,
    across_separations = across_separations
  )

  transitions <- transitions[
    , .(transitions = .N),
    by = c("from", "to", "ref_date")
  ]

  group_headcount <- count_entity(
    records,
    id_col = id_col,
    group_cols = c("ref_date", group_col)
  )

  data.table::setnames(
    group_headcount,
    c(group_col, "count"),
    c("from", "prev_headcount")
  )

  # each group's headcount moves forward to the next date, whose moves it is
  # the origin for
  dates <- sort(unique(group_headcount[["ref_date"]]))
  group_headcount[, ref_date := dates[match(ref_date, dates) + 1L]]

  transitions[
    group_headcount,
    on = c("from", "ref_date"),
    transition_rate := transitions / i.prev_headcount
  ]

  data.table::setorderv(transitions, c("ref_date", "from", "to"))

  transitions[]
}

#' @rdname compute_transition
#' @export
compute_transition.tbl_dbi <- function(
  data,
  id_col = "personnel_id",
  group_col,
  drop_duplicates = FALSE,
  across_separations = FALSE,
  ...
) {
  rlang::check_dots_empty()

  key_cols <- c(id_col, "ref_date")

  records <- data |>
    drop_missing(
      c(id_col, group_col)
    ) |>
    dplyr::select(
      dplyr::all_of(c(key_cols, group_col))
    )

  if (drop_duplicates) {
    records <- drop_duplicate(records, id_col = id_col)
  }

  group_headcount <- records |>
    count_entity(
      id_col = id_col,
      group_cols = c("ref_date", group_col)
    ) |>
    dplyr::rename(
      from = dplyr::all_of(group_col),
      prev_headcount = count
    )

  # each group's headcount moves forward to the next date, whose moves it is
  # the origin for
  group_headcount <- group_headcount |>
    dplyr::inner_join(
      build_calendar(group_headcount),
      by = "ref_date"
    ) |>
    dplyr::select(
      from, ref_date = next_date, prev_headcount
    )

  # duplicates are already dropped, so detect_transition() has none left
  transitions <- records |>
    detect_transition(
      id_col = id_col,
      group_col = group_col,
      drop_duplicates = FALSE,
      across_separations = across_separations
    )
    
  transitions <- transitions |>
    dplyr::summarise(
      transitions = dplyr::n(),
      .by = dplyr::all_of(c("from", "to", "ref_date"))
    ) |>
    dplyr::left_join(
      group_headcount,
      by = c("from", "ref_date")
    ) |>
    # some databases divide integers with integer division
    dplyr::mutate(
      transition_rate = as.numeric(transitions) / prev_headcount
    ) |>
    dplyr::select(
      from, to, ref_date, transitions, transition_rate
    )

  transitions
}

#' Compute transitions in and out of each group
#'
#' Adds up, for each group and reference date, the moves into the group and
#' the moves out of it.
#'
#' @param data Output of [compute_transition()], with `from`, `to`,
#'   `ref_date` and `transitions` columns.
#' @param ... Arguments passed to methods.
#'
#' @returns A table with one row per group and `ref_date`, containing `group`,
#'   `ref_date`, `transitions_inflow` (moves into the group) and
#'   `transitions_outflow` (moves out of it). A data.table for data frame
#'   input; a lazy table for `tbl_dbi` input (use [dplyr::collect()] to bring
#'   it into memory).
#'
#' @details A group that only received or only sent people on a date has 0
#'   moves the other way, rather than being left out.
#'
#' @seealso [plot_transition_flows()] to draw these flows.
#'
#' @examples
#' careers <- data.frame(
#'   personnel_id = c("a", "a", "b", "b", "c", "c"),
#'   ref_date = as.Date(rep(c("2020-01-01", "2021-01-01"), times = 3)),
#'   unit = c("A", "B", "A", "C", "B", "A")
#' )
#' compute_transition(careers, group_col = "unit") |>
#'   compute_transition_flows()
#'
#' @export
compute_transition_flows <- function(data, ...) {
  UseMethod("compute_transition_flows")
}

#' @rdname compute_transition_flows
#' @export
compute_transition_flows.data.frame <- function(data, ...) {
  rlang::check_dots_empty()

  dt <- data.table::as.data.table(data)

  # moves out of a group are counted by their origin, and moves in by their
  # destination
  outflow <- dt[
    , .(transitions_outflow = sum(transitions)),
    by = .(group = from, ref_date)
  ]
  inflow <- dt[
    , .(transitions_inflow = sum(transitions)),
    by = .(group = to, ref_date)
  ]

  flows <- merge(
    inflow,
    outflow,
    by = c("group", "ref_date"),
    all = TRUE
  )

  flows[is.na(transitions_inflow), transitions_inflow := 0L]
  flows[is.na(transitions_outflow), transitions_outflow := 0L]

  data.table::setkey(flows, NULL)
  data.table::setorderv(flows, c("group", "ref_date"))

  flows[]
}

#' @rdname compute_transition_flows
#' @export
compute_transition_flows.tbl_dbi <- function(data, ...) {
  rlang::check_dots_empty()

  # moves out of a group are counted by their origin, and moves in by their
  # destination
  outflow <- data |>
    dplyr::summarise(
      transitions_outflow = sum(transitions, na.rm = TRUE),
      .by = c("from", "ref_date")
    ) |>
    dplyr::rename(group = from)

  inflow <- data |>
    dplyr::summarise(
      transitions_inflow = sum(transitions, na.rm = TRUE),
      .by = c("to", "ref_date")
    ) |>
    dplyr::rename(group = to)

  inflow |>
    dplyr::full_join(
      outflow,
      by = c("group", "ref_date")
    ) |>
    dplyr::mutate(
      transitions_inflow = dplyr::coalesce(transitions_inflow, 0),
      transitions_outflow = dplyr::coalesce(transitions_outflow, 0)
    ) |>
    dplyr::select(group, ref_date, transitions_inflow, transitions_outflow)
}

#' Compare each row with its neighbour
#'
#' Flags the rows whose values in `cols` all equal those of the row before (or
#' after) it. Used to find runs of rows belonging to the same entity and group
#' in [detect_transition()].
#'
#' @param dt A data.table already sorted by `cols`.
#' @param cols Character vector of the columns to compare.
#' @param type Character. `"lag"` (default) compares each row with the row
#'   before it, `"lead"` with the row after it.
#'
#' @return A logical vector with one element per row of `dt`: `TRUE` if the row
#'   matches its neighbour in every column of `cols`, and `FALSE` otherwise,
#'   including the first (or last) row, which has no neighbour.
#'
#' @details
#' Shifting within `by` groups runs once per group, which is far slower than
#' one vectorised comparison when there are millions of entities.
#'
#' @keywords internal
same_as_neighbour <- function(dt, cols, type = "lag") {
  matches <- lapply(
    cols,
    function(col) dt[[col]] == data.table::shift(dt[[col]], type = type)
  )
  same <- Reduce(`&`, matches)

  !is.na(same) & same
}
