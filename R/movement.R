#' Detect personnel events
#'
#' @description
#' `r lifecycle::badge("deprecated")`
#'
#' This function is deprecated. Use [detect_movement()] to flag hires
#' (`event_type = "hire"`). A fire (`event_type = "fire"`) is any exit, which
#' is either a separation, flagged by [detect_movement()], or a retirement,
#' flagged by [detect_retirement()].
#'
#' Flags when each person becomes active (a hire) or stops being active (a
#' fire), comparing every date from `start_date` to `end_date`, spaced by
#' `freq`.
#'
#' @param data A data frame with `ref_date`, the identifier column and the
#'   status column.
#' @param id_col Character. Name of the identifier column, such as
#'   `"personnel_id"`.
#' @param event_type Character. `"hire"` or `"fire"`.
#' @param start_date,end_date Character or Date. First and last date of the
#'   date sequence.
#' @param status_col Character. Column holding employment status. Only rows
#'   equal to `"active"` are considered.
#' @param freq Character. Spacing of the date sequence, passed to
#'   [seq.Date()] as `by`. Default `"year"`.
#'
#' @returns A table with one row per event: the identifier, `ref_date` and
#'   `type_event` (`"hire"` or `"fire"`). It has the class of `data`: a
#'   data.table, tibble or data frame.
#'
#' @details
#' A hire is dated on the first date a person is active after a date they were
#' not, and a fire on the last date they are active before a date they are
#' not. A person missing from `data` on a date of the sequence is not active
#' then. Hires on `start_date` and fires on `end_date` have nothing to compare
#' with, so are left out.
#'
#' @seealso [detect_movement()] and [detect_retirement()], which replace it.
#'
#' @examples
#' personnel <- data.frame(
#'   personnel_id = c(1, 1, 2, 2),
#'   ref_date = as.Date(c("2020-01-01", "2021-01-01", "2021-01-01", "2022-01-01")),
#'   employment_status = "active"
#' )
#' suppressWarnings(
#'   detect_personnel_event(
#'     personnel,
#'     id_col = "personnel_id",
#'     event_type = "hire",
#'     start_date = "2020-01-01",
#'     end_date = "2022-01-01",
#'     status_col = "employment_status"
#'   )
#' )
#'
#' @export
detect_personnel_event <- function(
  data,
  id_col,
  event_type = c("hire", "fire"),
  start_date,
  end_date,
  status_col,
  freq = "year"
) {
  event_type <- match.arg(event_type)

  lifecycle::deprecate_warn(
    when = "0.4.2",
    what = "detect_personnel_event()",
    with = "detect_movement()",
    details = switch(
      event_type,
      hire = "For `event_type = \"hire\"`, use the `hire` column of `detect_movement()`.",
      fire = paste(
        "For `event_type = \"fire\"`, use the `separation` column of",
        "`detect_movement()` and the `retirement` column of",
        "`detect_retirement()`, which together flag every exit."
      )
    )
  )

  start_date <- lubridate::ymd(start_date)
  end_date <- lubridate::ymd(end_date)

  # several active records on a date are one active person
  active <- unique(
    data.table::as.data.table(data)[
      get(status_col) == "active",
      c(id_col, "ref_date"),
      with = FALSE
    ]
  )
  active[, is_active := TRUE]

  # every person on every date of the sequence, so a date a person is missing
  # from counts as not active, even if nobody was recorded on it
  panel <- data.table::CJ(
    id = unique(active[[id_col]]),
    ref_date = seq(start_date, end_date, by = freq)
  )
  data.table::setnames(panel, "id", id_col)

  panel <- active[panel, on = c(id_col, "ref_date")]
  data.table::setorderv(panel, c(id_col, "ref_date"))

  # a hire is not active the date before, a fire not active the date after
  neighbour <- if (event_type == "hire") "lag" else "lead"
  panel[
    , is_event := !is.na(is_active) &
      is.na(data.table::shift(is_active, type = neighbour)),
    by = id_col
  ]

  # the first (last) date has nothing before (after) it to compare with
  events <- if (event_type == "hire") {
    panel[is_event & ref_date > start_date]
  } else {
    panel[is_event & ref_date < end_date]
  }

  events <- events[, c(id_col, "ref_date"), with = FALSE]
  events[, type_event := event_type]

  if (inherits(data, "tbl_df")) {
    tibble::as_tibble(events)
  } else if (!data.table::is.data.table(data)) {
    as.data.frame(events)
  } else {
    events[]
  }
}

#' Detect hires and separations
#'
#' Flags, for each active person and reference date, whether they were hired
#' since the previous date and whether they leave active status, other than
#' into retirement, by the next date.
#'
#' @param data Data frame or remote database table (`tbl_dbi`) with one row
#'   per person-record. Must contain `personnel_id`, `ref_date` and the column
#'   named in `status_col`.
#' @param status_col Character. Column holding employment status. Rows equal
#'   to `"active"` are the active workforce, and rows equal to `"pensioner"`
#'   mark exits as retirements. Default `"employment_status"`.
#' @param ... Arguments passed to methods.
#'
#' @returns A table with one row per active person and `ref_date`, containing:
#' \describe{
#'   \item{personnel_id, ref_date}{The person and date.}
#'   \item{prev_date, next_date}{The neighbouring dates with active
#'     personnel, which the person's status is compared with. `NA` on the
#'     first and last date.}
#'   \item{hire}{`TRUE` if the person was not active on `prev_date`. `NA` on
#'     the first date, which has nothing to compare with.}
#'   \item{separation}{`TRUE` if the person is not active on `next_date` and
#'     did not retire. `NA` on the last date.}
#' }
#' A data.table for data frame input; a lazy table for `tbl_dbi` input (use
#' [dplyr::collect()] to bring it into memory).
#'
#' @details
#' The previous and next dates are the neighbouring dates with active
#' personnel, however far apart, so the dates do not need to be evenly spaced
#' and a date missing for everyone is not a gap. Dates holding only other
#' statuses, such as pensioner, are skipped. People with several contracts on
#' a date appear once.
#'
#' A separation is any exit from active status other than a retirement, such
#' as a resignation or a dismissal. An exit whose next status is pensioner is
#' a retirement, flagged by [detect_retirement()] instead, so every exit is
#' either a separation or a retirement, never both. Without pensioner records
#' in `data`, every exit is a separation.
#'
#' A separation is flagged on the person's last active date, which holds their
#' pay and group, but happens by `next_date`, the first date they are absent.
#' [compute_movement()] counts it on `next_date`.
#'
#' @seealso [compute_movement()], which counts these hires and separations.
#'   [detect_retirement()], which flags the retirements.
#'
#' @examples
#' hr <- data.frame(
#'   personnel_id = c(1, 2, 1, 3, 1, 3),
#'   ref_date = as.Date(rep(c("2020-01-01", "2021-01-01", "2022-01-01"), each = 2)),
#'   employment_status = "active"
#' )
#' detect_movement(hr)
#'
#' @export
detect_movement <- function(data, ...) {
  UseMethod("detect_movement")
}

#' @rdname detect_movement
#' @importFrom rlang check_dots_empty
#' @export
detect_movement.data.frame <- function(
  data,
  status_col = "employment_status",
  ...
) {
  rlang::check_dots_empty()

  detect_workforce_flows(data, status_col = status_col)[
    , .(personnel_id, ref_date, prev_date, next_date, hire, separation)
  ]
}

#' @rdname detect_movement
#' @importFrom rlang check_dots_empty
#' @export
detect_movement.tbl_dbi <- function(
  data,
  status_col = "employment_status",
  ...
) {
  rlang::check_dots_empty()

  detect_workforce_flows(data, status_col = status_col) |>
    dplyr::select(
      dplyr::all_of(
        c("personnel_id", "ref_date", "prev_date", "next_date", "hire", "separation")
      )
    )
}

#' Compute the cost of hires and separations
#'
#' Adds up, for each reference date, the pay of the people who were hired or
#' separated since the previous date. Retirements are not separations, and are
#' costed by [compute_retirement_cost()].
#'
#' @param data Data frame or remote database table (`tbl_dbi`) with one row
#'   per person-record. Must contain `personnel_id`, `ref_date` and the
#'   columns named in `measure_col` and `status_col`.
#' @param event_type Character vector of the movements to cost: `"hire"`,
#'   `"separation"` or both. Default both.
#' @param measure_col Character. Name of the pay column to add up.
#' @param group_cols Character vector of columns to group by, such as
#'   `"est_id"`, or `NULL` (default) for the whole workforce. Must not include
#'   `ref_date`.
#' @inheritParams detect_movement
#' @param ... Arguments passed to methods.
#'
#' @returns A table with one row per `ref_date`, group and movement type,
#'   containing `movement_type` (one of `event_type`) and `movement_cost`, the
#'   movers' pay. `movement_cost` is 0 when nobody moved, and `NA` on the
#'   first date, which has nothing to compare with, and for the separations of
#'   a group with nobody active on the previous date. A data.table for data frame
#'   input; a lazy table for `tbl_dbi` input (use [dplyr::collect()] to bring
#'   it into memory).
#'
#' @details
#' As in [compute_movement()], hires are counted on the date they are hired,
#' and separations on the first date the person is absent. Hires are costed at
#' their pay on the date they are hired, and separations at their pay on their
#' last active date. The pay on all of a mover's active records that date is
#' added up, so people with several contracts are costed in full; pay recorded
#' alongside, such as a pension, is not. Missing pay counts as 0.
#'
#' With `group_cols`, each mover's pay is counted in the group of the record it
#' comes from. Every group with active personnel on a date appears for that
#' date, and a group that everyone left still appears on the next date.
#'
#' @seealso [detect_movement()], which flags the movers.
#'   [compute_movement()], which counts them.
#'   [compute_retirement_cost()], which costs the retirements.
#'
#' @examples
#' hr <- data.frame(
#'   personnel_id = c(1, 1, 1, 2, 2),
#'   ref_date = as.Date(c(
#'     "2019-01-01", "2020-01-01", "2021-01-01", "2020-01-01", "2021-01-01"
#'   )),
#'   employment_status = "active",
#'   wage = c(100, 100, 100, 250, 250)
#' )
#' compute_movement_cost(hr, event_type = "hire", measure_col = "wage")
#'
#' @export
compute_movement_cost <- function(data, ...) {
  UseMethod("compute_movement_cost")
}

#' @rdname compute_movement_cost
#' @importFrom data.table := as.data.table fcoalesce fifelse melt
#' @importFrom rlang arg_match check_dots_empty
#' @export
compute_movement_cost.data.frame <- function(
  data,
  event_type = c("hire", "separation"),
  measure_col,
  group_cols = NULL,
  status_col = "employment_status",
  ...
) {
  rlang::check_dots_empty()
  event_type <- rlang::arg_match(event_type, multiple = TRUE)

  if ("ref_date" %in% group_cols) {
    stop("`ref_date` should not be included in `group_cols`")
  }

  dt <- data.table::as.data.table(data)
  keys <- c("personnel_id", "ref_date")
  by_cols <- c("ref_date", group_cols)

  flags <- detect_movement(dt, status_col = status_col)[
    , .(personnel_id, ref_date, next_date, hire, separation)
  ]

  # every active record carries its person's flags, so a mover's pay is added
  # up over all their contracts that date
  records <- flags[
    dt[
      get(status_col) == "active",
      c(keys, group_cols, measure_col),
      with = FALSE
    ],
    on = keys
  ]
  records[, pay := data.table::fcoalesce(as.numeric(get(measure_col)), 0)]

  # hire is NA on the first date, which carries through to its cost.
  # next_date is the same for everyone on a date, so grouping by it only
  # carries it along
  costs <- records[
    , .(
      active_records = .N,
      hire = sum(data.table::fifelse(hire, pay, 0)),
      separation = sum(data.table::fifelse(separation, pay, 0))
    ),
    by = c(by_cols, "next_date")
  ]

  # as in compute_movement(), a separation moves down to the next date
  previous <- costs[
    !is.na(next_date),
    c(group_cols, "next_date", "separation"),
    with = FALSE
  ]
  data.table::setnames(previous, "next_date", "ref_date")

  # a full join keeps a group that everyone left, which has no active records,
  # and so no hires, on the date its separations move to
  costs <- merge(
    costs[, c(by_cols, "active_records", "hire"), with = FALSE],
    previous,
    by = by_cols,
    all = TRUE
  )
  costs[is.na(active_records), hire := 0]

  data.table::melt(
    costs,
    id.vars = by_cols,
    measure.vars = event_type,
    variable.name = "movement_type",
    value.name = "movement_cost",
    variable.factor = FALSE
  )
}

#' @rdname compute_movement_cost
#' @importFrom dplyr all_of coalesce filter full_join if_else inner_join mutate
#'   n select summarise union_all
#' @importFrom purrr map reduce
#' @importFrom rlang .data arg_match check_dots_empty
#' @export
compute_movement_cost.tbl_dbi <- function(
  data,
  event_type = c("hire", "separation"),
  measure_col,
  group_cols = NULL,
  status_col = "employment_status",
  ...
) {
  rlang::check_dots_empty()
  event_type <- rlang::arg_match(event_type, multiple = TRUE)

  if ("ref_date" %in% group_cols) {
    stop("`ref_date` should not be included in `group_cols`")
  }

  keys <- c("personnel_id", "ref_date")
  by_cols <- c("ref_date", group_cols)

  flags <- detect_movement(data, status_col = status_col) |>
    select(personnel_id, ref_date, next_date, hire, separation)

  # every active record carries its person's flags, so a mover's pay is added
  # up over all their contracts that date
  records <- data |>
    filter(.data[[status_col]] == "active") |>
    select(all_of(c(keys, group_cols, measure_col))) |>
    inner_join(flags, by = keys) |>
    mutate(pay = coalesce(.data[[measure_col]], 0))

  # hire is NULL on the first date, so the SUM() is NULL there too. next_date
  # is the same for everyone on a date, so grouping by it only carries it
  # along
  costs <- records |>
    summarise(
      active_records = n(),
      hire = sum(if_else(hire, pay, 0), na.rm = TRUE),
      separation = sum(if_else(separation, pay, 0), na.rm = TRUE),
      .by = all_of(c(by_cols, "next_date"))
    )

  # as in compute_movement(), a separation moves down to the next date
  previous <- costs |>
    filter(!is.na(next_date)) |>
    select(all_of(group_cols), ref_date = next_date, separation)

  # a full join keeps a group that everyone left, which has no active records,
  # and so no hires, on the date its separations move to
  costs <- costs |>
    select(all_of(by_cols), active_records, hire) |>
    full_join(previous, by = by_cols, na_matches = "na") |>
    mutate(hire = if_else(is.na(active_records), 0, hire))

  event_type |>
    purrr::map(
      \(movement) {
        costs |>
          mutate(
            movement_type = !!movement,
            movement_cost = .data[[movement]]
          )
      }
    ) |>
    purrr::reduce(union_all) |>
    select(ref_date, all_of(group_cols), movement_type, movement_cost)
}

#' Compute the cost of retirements
#'
#' Adds up, for each reference date, the pay of the people who retired since
#' the previous date.
#'
#' @inheritParams compute_movement_cost
#' @param status_col Character. Column holding employment status, with active
#'   personnel recorded as `"active"` and retirees as `"pensioner"`. Default
#'   `"employment_status"`.
#'
#' @returns A table with one row per `ref_date` and group, containing
#'   `retirement_cost`, the retirees' pay. `retirement_cost` is 0 when nobody
#'   retired, and `NA` on the first date, which has nothing to compare with,
#'   and for a group with nobody active on the previous date. A
#'   data.table for data frame input; a lazy table for `tbl_dbi` input (use
#'   [dplyr::collect()] to bring it into memory).
#'
#' @details
#' As in [compute_retirement()], retirements are counted on the first date the
#' person is absent. Retirees are costed at their pay on their last active
#' date. The pay on all of a retiree's active records that date is added up, so
#' people with several contracts are costed in full; pay recorded alongside,
#' such as a pension, is not. Missing pay counts as 0.
#'
#' With `group_cols`, each retiree's pay is counted in the group of the record
#' it comes from. Every group with active personnel on a date appears for
#' that date, and a group that everyone left still appears on the next date.
#'
#' @seealso [detect_retirement()], which flags the retirees.
#'   [compute_retirement()], which counts them. [compute_movement_cost()],
#'   which costs the hires and separations.
#'
#' @examples
#' hr <- data.frame(
#'   personnel_id = c(1, 2, 1, 2),
#'   ref_date = as.Date(rep(c("2020-01-01", "2021-01-01"), each = 2)),
#'   employment_status = c("active", "active", "pensioner", "active"),
#'   wage = c(100, 250, 60, 250)
#' )
#' compute_retirement_cost(hr, measure_col = "wage")
#'
#' @export
compute_retirement_cost <- function(data, ...) {
  UseMethod("compute_retirement_cost")
}

#' @rdname compute_retirement_cost
#' @importFrom data.table := as.data.table fcoalesce fifelse setkey setnames
#' @importFrom rlang check_dots_empty
#' @export
compute_retirement_cost.data.frame <- function(
  data,
  measure_col,
  group_cols = NULL,
  status_col = "employment_status",
  ...
) {
  rlang::check_dots_empty()

  if ("ref_date" %in% group_cols) {
    stop("`ref_date` should not be included in `group_cols`")
  }

  dt <- data.table::as.data.table(data)
  keys <- c("personnel_id", "ref_date")

  flags <- detect_retirement(dt, status_col = status_col)[
    , .(personnel_id, ref_date, next_date, retirement)
  ]

  # every active record carries its person's flag, so a retiree's pay is
  # added up over all their contracts that date
  records <- flags[
    dt[
      get(status_col) == "active",
      c(keys, group_cols, measure_col),
      with = FALSE
    ],
    on = keys
  ]
  records[, pay := data.table::fcoalesce(as.numeric(get(measure_col)), 0)]

  by_cols <- c("ref_date", group_cols)

  # next_date is the same for everyone on a date, so grouping by it only
  # carries it along
  costs <- records[
    , .(retirement_cost = sum(data.table::fifelse(retirement, pay, 0))),
    by = c(by_cols, "next_date")
  ]

  # as in compute_retirement(), a retirement moves down to the next date
  previous <- costs[
    !is.na(next_date),
    c(group_cols, "next_date", "retirement_cost"),
    with = FALSE
  ]
  data.table::setnames(previous, "next_date", "ref_date")

  # a full join keeps a group that everyone left, which has no row on the date
  # its retirements move to
  costs <- merge(
    costs[, by_cols, with = FALSE],
    previous,
    by = by_cols,
    all = TRUE
  )
  data.table::setkey(costs, NULL)

  costs[]
}

#' @rdname compute_retirement_cost
#' @importFrom dplyr all_of coalesce filter full_join if_else inner_join select
#'   summarise
#' @importFrom rlang .data check_dots_empty
#' @export
compute_retirement_cost.tbl_dbi <- function(
  data,
  measure_col,
  group_cols = NULL,
  status_col = "employment_status",
  ...
) {
  rlang::check_dots_empty()

  if ("ref_date" %in% group_cols) {
    stop("`ref_date` should not be included in `group_cols`")
  }

  keys <- c("personnel_id", "ref_date")
  by_cols <- c("ref_date", group_cols)

  flags <- detect_retirement(data, status_col = status_col) |>
    select(personnel_id, ref_date, next_date, retirement)

  # every active record carries its person's flag, so a retiree's pay is
  # added up over all their contracts that date. next_date is the same for
  # everyone on a date, so grouping by it only carries it along
  costs <- data |>
    filter(.data[[status_col]] == "active") |>
    select(all_of(c(keys, group_cols, measure_col))) |>
    inner_join(flags, by = keys) |>
    summarise(
      retirement_cost = sum(
        if_else(retirement, coalesce(.data[[measure_col]], 0), 0),
        na.rm = TRUE
      ),
      .by = all_of(c(by_cols, "next_date"))
    )

  # as in compute_retirement(), a retirement moves down to the next date
  previous <- costs |>
    filter(!is.na(next_date)) |>
    select(all_of(group_cols), ref_date = next_date, retirement_cost)

  # a full join keeps a group that everyone left, which has no row on the date
  # its retirements move to. missing groups match each other, as they do in
  # data.table joins
  costs |>
    select(all_of(by_cols)) |>
    full_join(previous, by = by_cols, na_matches = "na")
}

#' Compute movements as hires and separations
#'
#' Counts, for each reference date, how many people are active, how many
#' joined since the previous date (hires) and how many left since the previous
#' date (separations). Hire, separation, and replacement rates are also
#' returned.
#'
#' @param data Data frame or remote database table (`tbl_dbi`) with one row
#'   per person-record. Must contain `personnel_id`, `ref_date` and the column
#'   named in `status_col`.
#' @param group_cols Character vector of columns to group by, such as
#'   `"est_id"`, or `NULL` (default) for the whole workforce. Must not include
#'   `ref_date`.
#' @inheritParams detect_movement
#' @param ... Arguments passed to methods.
#'
#' @returns A table with one row per `ref_date` and group, containing:
#' \describe{
#'   \item{headcount}{Number of active people.}
#'   \item{hires}{People active on this date but not on the previous one.}
#'   \item{separations}{People active on the previous date but not on this
#'     one, other than retirees, whom [compute_retirement()] counts.}
#'   \item{hire_rate, separation_rate}{`hires` and `separations` divided by
#'     the headcount on the previous date.}
#'   \item{replacement_rate}{`hires` divided by `separations`.}
#' }
#' Hires, separations and rates are `NA` on the first date, which has nothing
#' to compare with. A data.table for data frame input; a lazy table for
#' `tbl_dbi` input (use [dplyr::collect()] to bring it into memory).
#'
#' @details
#' The previous date is the neighbouring date found in the data, so the dates
#' do not need to be evenly spaced.
#'
#' Hires, separations and retirements all cover the time since the previous
#' date, so on every date after the first, `headcount` equals the previous
#' date's `headcount` plus `hires` minus `separations` and the `retirements`
#' of [compute_retirement()].
#'
#' People are counted once per date, even if they hold several contracts. A
#' separation is any exit from active status other than a retirement, as in
#' [detect_movement()]. Without pensioner records in `data`, every exit is a
#' separation.
#'
#' With `group_cols`, each person is counted in the group they belong to on
#' that date, and each separation in the group the person left. A group that
#' everyone left still appears on the next date, with a `headcount` of 0. A
#' group with nobody active on the previous date has no headcount to compare
#' with, so its separations and rates are `NA`.
#' Moving from one group to another is neither a hire nor a separation, so the
#' headcount of a group adds up only once those moves are counted too; use
#' [compute_transition()] to count them.
#'
#' @examples
#' hr <- data.frame(
#'   personnel_id = c(1, 2, 1, 3, 1, 3),
#'   ref_date = as.Date(rep(c("2020-01-01", "2021-01-01", "2022-01-01"), each = 2)),
#'   employment_status = "active"
#' )
#' compute_movement(hr)
#'
#' @export
compute_movement <- function(data, ...) {
  UseMethod("compute_movement")
}

#' @rdname compute_movement
#' @importFrom data.table := .N as.data.table setorderv
#' @importFrom rlang check_dots_empty
#' @export
compute_movement.data.frame <- function(
  data,
  group_cols = NULL,
  status_col = "employment_status",
  ...
) {
  rlang::check_dots_empty()

  if ("ref_date" %in% group_cols) {
    stop("`ref_date` should not be included in `group_cols`")
  }

  dt <- data.table::as.data.table(data)
  by_cols <- c("ref_date", group_cols)

  # one row per person, date and group, so people with several contracts
  # count once
  person_groups <- unique(
    dt[
      get(status_col) == "active",
      c("personnel_id", "ref_date", group_cols),
      with = FALSE
    ]
  )

  people <- detect_movement(dt, status_col = status_col)[
    person_groups,
    on = c("personnel_id", "ref_date")
  ]

  # next_date is the same for everyone on a date, so grouping by it only
  # carries it along
  movement <- people[
    , .(
      headcount = .N,
      hires = sum(hire),
      separations = sum(separation)
    ),
    by = c(by_cols, "next_date")
  ]

  # a separation is flagged on the last active date, so it moves down to the
  # next date, with the headcount it left, to cover the same period as that
  # date's hires
  previous <- movement[
    !is.na(next_date),
    c(group_cols, "next_date", "headcount", "separations"),
    with = FALSE
  ]

  data.table::setnames(
    previous,
    c("next_date", "headcount"),
    c("ref_date", "prev_headcount")
  )

  # a full join keeps a group that everyone left, which has no active
  # personnel, and so no row, on the date its separations move to
  movement <- merge(
    movement[, c(by_cols, "headcount", "hires"), with = FALSE],
    previous,
    by = by_cols,
    all = TRUE
  )

  movement[is.na(headcount), c("headcount", "hires") := 0L]

  movement[
    , `:=`(
      hire_rate = hires / prev_headcount,
      separation_rate = separations / prev_headcount,
      replacement_rate = hires / separations
    )
  ]
  movement[, prev_headcount := NULL]
  data.table::setkey(movement, NULL)

  movement[]
}

#' @rdname compute_movement
#' @importFrom dplyr all_of coalesce distinct filter full_join if_else
#'   inner_join mutate n select summarise
#' @importFrom rlang .data check_dots_empty
#' @export
compute_movement.tbl_dbi <- function(
  data,
  group_cols = NULL,
  status_col = "employment_status",
  ...
) {
  rlang::check_dots_empty()

  if ("ref_date" %in% group_cols) {
    stop("`ref_date` should not be included in `group_cols`")
  }

  by_cols <- c("ref_date", group_cols)

  # one row per person, date and group
  person_groups <- data |>
    filter(.data[[status_col]] == "active") |>
    select(
      all_of(
        c("personnel_id", "ref_date", group_cols)
      )
    ) |>
    distinct()

  people <- person_groups |>
    inner_join(
      detect_movement(data, status_col = status_col),
      by = c("personnel_id", "ref_date")
    )
  
  # next_date is the same for everyone on a date, so
  # grouping by it only carries it along
  movement <- people |>
    summarise(
      headcount = n(),
      hires = sum(if_else(hire, 1, 0), na.rm = TRUE),
      separations = sum(if_else(separation, 1, 0), na.rm = TRUE),
      .by = all_of(c(by_cols, "next_date"))
    )

  # a separation is flagged on the last active date, so it moves down to the
  # next date, with the headcount it left, to cover the same period as that
  # date's hires
  previous <- movement |>
    filter(!is.na(next_date)) |>
    select(
      all_of(group_cols),
      ref_date = next_date,
      prev_headcount = headcount,
      separations
    )

  # a full join keeps a group that everyone left, which has no active
  # personnel, and so no row, on the date its separations move to. missing
  # groups match each other, as they do in data.table joins
  movement |>
    select(all_of(by_cols), headcount, hires) |>
    full_join(previous, by = by_cols, na_matches = "na") |>
    mutate(
      hires = if_else(is.na(headcount), 0, hires),
      headcount = coalesce(headcount, 0),
      hire_rate = hires / prev_headcount,
      separation_rate = separations / prev_headcount,
      replacement_rate = hires / separations
    ) |>
    select(
      all_of(c("ref_date", group_cols)),
      headcount, hires, separations, hire_rate, separation_rate, replacement_rate
    )
}

#' Compute retirements
#'
#' Counts, for each reference date, how many people are active and how many
#' left active status since the previous date into a pension, i.e. whose next
#' status after leaving is pensioner.
#'
#' @param data Data frame or remote database table (`tbl_dbi`) with one row
#'   per person-record. Must contain `personnel_id`, `ref_date` and the column
#'   named in `status_col`.
#' @param group_cols Character vector of columns to group by, such as
#'   `"est_id"`, or `NULL` (default) for the whole workforce. Must not include
#'   `ref_date`.
#' @param status_col Character. Column holding employment status, with active
#'   personnel recorded as `"active"` and retirees as `"pensioner"`. Default
#'   `"employment_status"`.
#' @param ... Arguments passed to methods.
#'
#' @returns A table with one row per `ref_date` and group, containing:
#' \describe{
#'   \item{headcount}{Number of active people.}
#'   \item{retirements}{People active on the previous date who are no longer
#'     active on this one and are next recorded as pensioners. `NA` on the
#'     first date, which has nothing to compare with.}
#'   \item{retirement_rate}{`retirements` divided by the headcount on the
#'     previous date, as `separation_rate` in [compute_movement()].}
#' }
#' A data.table for data frame input; a lazy table for `tbl_dbi` input (use
#' [dplyr::collect()] to bring it into memory).
#'
#' @details
#' The previous date is the neighbouring date found in the data, so the dates
#' do not need to be evenly spaced. People are counted once per date, even if
#' they hold several contracts. With `group_cols`, each person is counted in
#' the group they belong to on that date, and each retirement in the group the
#' person left. A group that everyone left still appears on the next date,
#' with a `headcount` of 0. A group with nobody active on the previous date has
#' no headcount to compare with, so its retirements and rate are `NA`.
#'
#' Pension registration can lag the exit, so the pensioner record may appear
#' at any later date, not only the next one. A retirement is dated by the exit,
#' the first date the person is absent, not by the registration. A person who
#' returns to active work before any
#' pensioner record counts as a separation, not a retirement, at the earlier
#' exit. There is no limit on the lag, so an exit followed years later by a
#' deferred pension also counts as a retirement.
#'
#' @seealso [compute_movement()], whose separations are the exits other than
#'   these retirements, and whose rates share their denominator.
#'   [detect_retirement()], which flags the retirements of each person.
#'
#' @examples
#' hr <- data.frame(
#'   personnel_id = c(1, 2, 1, 2, 2),
#'   ref_date = as.Date(c(
#'     "2020-01-01", "2020-01-01", "2021-01-01", "2021-01-01", "2022-01-01"
#'   )),
#'   employment_status = c("active", "active", "pensioner", "active", "active")
#' )
#' compute_retirement(hr)
#'
#' @export
compute_retirement <- function(data, ...) {
  UseMethod("compute_retirement")
}

#' @rdname compute_retirement
#' @importFrom data.table := .N as.data.table setorderv
#' @importFrom rlang check_dots_empty
#' @export
compute_retirement.data.frame <- function(
  data,
  group_cols = NULL,
  status_col = "employment_status",
  ...
) {
  rlang::check_dots_empty()

  if ("ref_date" %in% group_cols) {
    stop("`ref_date` should not be included in `group_cols`")
  }

  dt <- data.table::as.data.table(data)

  # one row per person, date and group, so people with several contracts
  # count once
  person_groups <- unique(
    dt[
      get(status_col) == "active",
      c("personnel_id", "ref_date", group_cols),
      with = FALSE
    ]
  )

  by_cols <- c("ref_date", group_cols)

  people <- detect_retirement(dt, status_col = status_col)[
    person_groups,
    on = c("personnel_id", "ref_date")
  ]

  # next_date is the same for everyone on a date, so grouping by it only
  # carries it along
  retirement <- people[
    , .(
      headcount = .N,
      retirements = sum(retirement)
    ),
    by = c(by_cols, "next_date")
  ]

  # as separations in compute_movement(), a retirement moves down to the next
  # date, with the headcount it left
  previous <- retirement[
    !is.na(next_date),
    c(group_cols, "next_date", "headcount", "retirements"),
    with = FALSE
  ]
  data.table::setnames(
    previous,
    c("next_date", "headcount"),
    c("ref_date", "prev_headcount")
  )

  # a full join keeps a group that everyone left, which has no row on the date
  # its retirements move to
  retirement <- merge(
    retirement[, c(by_cols, "headcount"), with = FALSE],
    previous,
    by = by_cols,
    all = TRUE
  )
  retirement[is.na(headcount), headcount := 0L]

  retirement[, retirement_rate := retirements / prev_headcount]
  retirement[, prev_headcount := NULL]
  data.table::setkey(retirement, NULL)

  retirement[]
}

#' @rdname compute_retirement
#' @importFrom dplyr all_of coalesce distinct filter full_join if_else
#'   inner_join mutate n select summarise
#' @importFrom rlang .data check_dots_empty
#' @export
compute_retirement.tbl_dbi <- function(
  data,
  group_cols = NULL,
  status_col = "employment_status",
  ...
) {
  rlang::check_dots_empty()

  if ("ref_date" %in% group_cols) {
    stop("`ref_date` should not be included in `group_cols`")
  }

  # one row per person, date and group, so people with several contracts
  # count once
  person_groups <- data |>
    filter(.data[[status_col]] == "active") |>
    select(all_of(c("personnel_id", "ref_date", group_cols))) |>
    distinct()

  by_cols <- c("ref_date", group_cols)

  people <- person_groups |>
    inner_join(
      detect_retirement(data, status_col = status_col),
      by = c("personnel_id", "ref_date")
    )

  # counted as doubles, since some backends, such as SQLite, divide integers
  # without the fraction in retirement_rate. next_date is the same for
  # everyone on a date, so grouping by it only carries it along
  retirement <- people |>
    summarise(
      headcount = n(),
      retirements = sum(if_else(retirement, 1, 0), na.rm = TRUE),
      .by = all_of(c(by_cols, "next_date"))
    )

  # as separations in compute_movement(), a retirement moves down to the next
  # date, with the headcount it left
  previous <- retirement |>
    filter(!is.na(next_date)) |>
    select(
      all_of(group_cols),
      ref_date = next_date,
      prev_headcount = headcount,
      retirements
    )

  # a full join keeps a group that everyone left, which has no row on the date
  # its retirements move to. missing groups match each other, as they do in
  # data.table joins
  retirement |>
    select(all_of(by_cols), headcount) |>
    full_join(previous, by = by_cols, na_matches = "na") |>
    mutate(
      headcount = coalesce(headcount, 0),
      retirement_rate = retirements / prev_headcount
    ) |>
    select(
      all_of(
        c("ref_date", group_cols, "headcount", "retirements", "retirement_rate")
      )
    )
}
