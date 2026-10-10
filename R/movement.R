#' Detect Personnel Events
#'
#' Expands a dataset of personnel and reference dates to include all possible
#' personnel–date combinations, fills missing periods, and identifies "hire" or
#' "fire" events based on changes in status over time.
#'
#' @param data A data.table or data.frame containing at least the columns:
#'   - `personnel_id`: Unique identifier for personnel.
#'   - `ref_date`: Reference date (must be coercible to Date).
#'   - `employment_status`: Personnel status (e.g., "active", "pensioner", "inactive").
#' @param id_col Character. Name of the identifier column (e.g., `"personnel_id"`).
#' @param event_type Character. Either `"hire"` or `"fire"`, controlling which event to detect.
#' @param start_date Optional start date for the full date sequence
#'   (default: `"2007-09-01"`).
#' @param status_col A column within `data` object for the employment status of personnel.
#' @param end_date Optional end date for the full date sequence
#'   (default: `"2018-01-01"`).
#' @param freq Frequency for the sequence of dates (default: `"year"`).
#'   Can be any valid value for \code{seq.Date(by = ...)}.
#'
#' @returns A dataset with event types detected (e.g., hire or fire).
#'
#' @importFrom data.table as.data.table copy setorderv shift fifelse
#' @importFrom lubridate ymd
#'
#' @examples
#' \dontrun{
#' hires <- detect_personnel_event(personnel_df, id_col = "personnel_id", start_date = "2007-09-01",
#'                        end_date = "2018-01-01", event_type = "hire")
#'
#' fires <- detect_personnel_event(personnel_df, id_col = "personnel_id", start_date = "2007-09-01",
#'                        end_date = "2018-01-01", event_type = "fire")
#' }
#' @export
detect_personnel_event <- function(
  data,
  id_col,
  event_type,
  start_date,
  end_date,
  status_col,
  freq = "year"
) {
  # Convert to data.table
  dt <- data.table::as.data.table(data)

  # Filter for active personnel
  active_personnel_dt <- dt[get(status_col) == "active"]

  # Build full date range and unique personnel IDs
  expanded_active_personnel_dt <- active_personnel_dt |>
    complete_dates(
      id_col,
      start_date,
      end_date,
      freq
    ) |>
    data.table::copy()

  # Sort by personnel and date
  data.table::setorderv(
    expanded_active_personnel_dt,
    cols = c(id_col, "ref_date")
  )

  # Add lag/lead and event detection
  if (event_type == "hire") {
    expanded_active_personnel_dt <- expanded_active_personnel_dt[,
      .(
        personnel_id = get(id_col),
        ref_date,
        get(status_col),
        type_event = data.table::fifelse(
          get(status_col) == "active" &
            is.na(data.table::shift(get(status_col), type = "lag")),
          "hire",
          "no hire"
        )
      ),
      by = id_col
    ]

    expanded_active_personnel_dt <- expanded_active_personnel_dt[
      ref_date > lubridate::ymd(start_date)
    ]
  } else {
    expanded_active_personnel_dt <- expanded_active_personnel_dt[,
      .(
        personnel_id = get(id_col),
        ref_date,
        get(status_col),
        type_event = data.table::fifelse(
          get(status_col) == "active" &
            is.na(data.table::shift(get(status_col), type = "lead")),
          "fire",
          "no fire"
        )
      ),
      by = id_col
    ]

    expanded_active_personnel_dt <- expanded_active_personnel_dt[
      ref_date < lubridate::ymd(end_date)
    ]
  }

  expanded_active_personnel_dt <- expanded_active_personnel_dt[
    type_event %in% c("hire", "fire"),
    c(id_col, "ref_date", "type_event"),
    with = FALSE
  ]

  data_out <- convert_data(expanded_active_personnel_dt, data)

  return(data_out)
}

#' Detect hires and separations
#'
#' Flags, for each active person and reference date, whether they were hired
#' since the previous date and whether they are gone by the next date.
#'
#' @param data Data frame or remote database table (`tbl_dbi`) with one row
#'   per person-record. Must contain `personnel_id`, `ref_date` and the column
#'   named in `status_col`.
#' @param status_col Character. Column holding employment status. Only rows
#'   equal to `"active"` are considered. Default `"employment_status"`.
#' @param ... Arguments passed to methods.
#'
#' @returns A table with one row per active person and `ref_date`, containing:
#' \describe{
#'   \item{personnel_id, ref_date}{The person and date.}
#'   \item{prev_date, next_date}{The neighbouring dates found in the data,
#'     which the person's status is compared with. `NA` on the first and last
#'     date.}
#'   \item{hire}{`TRUE` if the person was not active on `prev_date`. `NA` on
#'     the first date, which has nothing to compare with.}
#'   \item{separation}{`TRUE` if the person is not active on `next_date`. `NA`
#'     on the last date.}
#' }
#' A data.table for data frame input; a lazy table for `tbl_dbi` input (use
#' [dplyr::collect()] to bring it into memory).
#'
#' @details
#' The previous and next dates are the neighbouring dates found in the data,
#' so the dates do not need to be evenly spaced. People with several contracts
#' on a date appear once. A separation is any exit from active status,
#' including retirement.
#'
#' @seealso [compute_movement()], which counts these hires and separations.
#'   [detect_retirement()], which flags the retirements among the separations.
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
#' @importFrom data.table := as.data.table data.table fifelse setorderv shift
#' @importFrom rlang check_dots_empty
#' @export
detect_movement.data.frame <- function(
  data,
  status_col = "employment_status",
  ...
) {
  rlang::check_dots_empty()

  dt <- data.table::as.data.table(data)

  # one row per person and date, so people with several contracts count once
  person_dates <- unique(
    dt[get(status_col) == "active", .(personnel_id, ref_date)]
  )

  # previous and next date for each date in the data
  dates <- sort(unique(person_dates[["ref_date"]]))
  calendar <- data.table::data.table(
    ref_date = dates,
    prev_date = data.table::shift(dates),
    next_date = data.table::shift(dates, type = "lead")
  )

  movement <- calendar[person_dates, on = "ref_date"]

  # hired: no active record on the previous date. NA when there is no
  # previous date to compare with
  movement[, hire := data.table::fifelse(is.na(prev_date), NA, TRUE)]
  movement[
    person_dates,
    on = .(personnel_id, prev_date = ref_date),
    hire := FALSE
  ]

  # separated: no active record on the next date
  movement[, separation := data.table::fifelse(is.na(next_date), NA, TRUE)]
  movement[
    person_dates,
    on = .(personnel_id, next_date = ref_date),
    separation := FALSE
  ]

  data.table::setorderv(movement, c("ref_date", "personnel_id"))

  movement[, .(personnel_id, ref_date, prev_date, next_date, hire, separation)]
}

#' @rdname detect_movement
#' @importFrom dplyr all_of anti_join distinct filter if_else inner_join
#'   join_by left_join mutate select
#' @importFrom rlang .data check_dots_empty
#' @export
detect_movement.tbl_dbi <- function(
  data,
  status_col = "employment_status",
  ...
) {
  rlang::check_dots_empty()

  # one row per person and date, so people with several contracts count once
  person_dates <- data |>
    filter(.data[[status_col]] == "active") |>
    select(all_of(c("personnel_id", "ref_date"))) |>
    distinct()

  movement <- person_dates |>
    inner_join(build_calendar(person_dates), by = "ref_date")

  # hired: no active record on the previous date
  hires <- movement |>
    filter(!is.na(prev_date)) |>
    anti_join(person_dates, by = join_by(personnel_id, prev_date == ref_date)) |>
    select(all_of(c("personnel_id", "ref_date"))) |>
    mutate(hired = 1)

  # separated: no active record on the next date
  separations <- movement |>
    filter(!is.na(next_date)) |>
    anti_join(person_dates, by = join_by(personnel_id, next_date == ref_date)) |>
    select(all_of(c("personnel_id", "ref_date"))) |>
    mutate(separated = 1)

  movement |>
    left_join(hires, by = c("personnel_id", "ref_date")) |>
    left_join(separations, by = c("personnel_id", "ref_date")) |>
    # NA when there is no previous (next) date to compare with
    mutate(
      hire = if_else(is.na(prev_date), NA, !is.na(hired)),
      separation = if_else(is.na(next_date), NA, !is.na(separated))
    ) |>
    select(personnel_id, ref_date, prev_date, next_date, hire, separation)
}

#' Detect retirements
#'
#' Flags, for each active person and reference date, whether they leave active
#' status by the next date into a pension, i.e. whether their next status
#' after leaving is pensioner.
#'
#' @inheritParams detect_movement
#' @param status_col Character. Column holding employment status, with active
#'   personnel recorded as `"active"` and retirees as `"pensioner"`. Default
#'   `"employment_status"`.
#'
#' @returns A table with one row per active person and `ref_date`, containing
#'   `personnel_id`, `ref_date`, `next_date` (the next date found in the data)
#'   and `retirement`: `TRUE` if the person retires by `next_date`, and `NA` on
#'   the last date, which has nothing to compare with. A data.table for data
#'   frame input; a lazy table for `tbl_dbi` input (use [dplyr::collect()] to
#'   bring it into memory).
#'
#' @details
#' A retirement is a separation whose next status is pensioner. A pension
#' drawn alongside an active contract is therefore not a retirement.
#'
#' Pension registration can lag the exit, so the pensioner record may appear
#' at any later date, not only the next one. A retirement is dated by the exit,
#' not by the registration. A person who returns to active work before any
#' pensioner record is not retired at the earlier exit. There is no limit on
#' the lag, so an exit followed years later by a deferred pension also counts
#' as a retirement.
#'
#' As in [detect_movement()], only dates with active personnel are compared,
#' so pensioner records dated before the next such date are not seen, and an
#' exit on the last such date is `NA`.
#'
#' @seealso [compute_retirement()], which counts these retirements.
#'   [detect_movement()], which flags the separations they are drawn from.
#'
#' @examples
#' hr <- data.frame(
#'   personnel_id = c(1, 2, 1, 2, 2),
#'   ref_date = as.Date(c(
#'     "2020-01-01", "2020-01-01", "2021-01-01", "2021-01-01", "2022-01-01"
#'   )),
#'   employment_status = c("active", "active", "pensioner", "active", "active")
#' )
#' detect_retirement(hr)
#'
#' @export
detect_retirement <- function(data, ...) {
  UseMethod("detect_retirement")
}

#' @rdname detect_retirement
#' @importFrom data.table := as.data.table fifelse
#' @importFrom rlang check_dots_empty
#' @export
detect_retirement.data.frame <- function(
  data,
  status_col = "employment_status",
  ...
) {
  rlang::check_dots_empty()

  dt <- data.table::as.data.table(data)
  movement <- detect_movement(dt, status_col = status_col)

  person_dates <- movement[, .(personnel_id, ref_date)]
  pensioner_dates <- unique(
    dt[get(status_col) == "pensioner", .(personnel_id, ref_date)]
  )

  # pension registration can lag the exit, so roll forward to the first
  # pensioner and active records from the next date onwards rather than
  # looking at the next date only
  next_pension <- pensioner_dates[
    movement,
    on = .(personnel_id, ref_date = next_date),
    roll = -Inf,
    x.ref_date
  ]
  next_return <- person_dates[
    movement,
    on = .(personnel_id, ref_date = next_date),
    roll = -Inf,
    x.ref_date
  ]

  # NA when there is no next date to compare with. a pension that starts by
  # the time the person returns, e.g. a retiree rehired on contract, still
  # marks the exit as a retirement
  movement[
    , retirement := data.table::fifelse(
      is.na(next_date),
      NA,
      separation &
        !is.na(next_pension) &
        (is.na(next_return) | next_pension <= next_return)
    )
  ]

  movement[, .(personnel_id, ref_date, next_date, retirement)]
}

#' @rdname detect_retirement
#' @importFrom dplyr all_of distinct filter if_else inner_join join_by
#'   left_join mutate rename select summarise
#' @importFrom rlang .data check_dots_empty
#' @export
detect_retirement.tbl_dbi <- function(
  data,
  status_col = "employment_status",
  ...
) {
  rlang::check_dots_empty()

  movement <- detect_movement(data, status_col = status_col)

  person_dates <- movement |>
    select(all_of(c("personnel_id", "ref_date")))

  pensioner_dates <- data |>
    filter(.data[[status_col]] == "pensioner") |>
    select(all_of(c("personnel_id", "ref_date"))) |>
    distinct()

  separations <- movement |>
    filter(separation)

  # pension registration can lag the exit, so take the first pensioner and
  # active records from the next date onwards. SQL has no rolling join, hence
  # the inequality join and min()
  first_record_after_exit <- function(records, name) {
    separations |>
      inner_join(
        records |> rename(record_date = "ref_date"),
        by = join_by(personnel_id, next_date <= record_date)
      ) |>
      summarise(
        !!name := min(record_date, na.rm = TRUE),
        .by = all_of(c("personnel_id", "ref_date"))
      )
  }

  retired <- separations |>
    inner_join(
      first_record_after_exit(pensioner_dates, "next_pension"),
      by = c("personnel_id", "ref_date")
    ) |>
    left_join(
      first_record_after_exit(person_dates, "next_return"),
      by = c("personnel_id", "ref_date")
    ) |>
    # a pension that starts by the time the person returns, e.g. a retiree
    # rehired on contract, still marks the exit as a retirement
    filter(is.na(next_return) | next_pension <= next_return) |>
    select(all_of(c("personnel_id", "ref_date"))) |>
    mutate(retired = 1)

  movement |>
    left_join(retired, by = c("personnel_id", "ref_date")) |>
    # NA when there is no next date to compare with
    mutate(retirement = if_else(is.na(next_date), NA, !is.na(retired))) |>
    select(personnel_id, ref_date, next_date, retirement)
}

#' Classify personnel movement events
#'
#' This function classifies the personnel module into three types of movements: hires, fires, or retirements.
#'
#' This function is deprecated and will be removed in a future release. Use
#' [detect_movement()] to flag hires and separations, and
#' [detect_retirement()] to flag retirements.
#'
#' @param data A data frame containing personnel data.
#' @param id_col The name of the column representing personnel IDs.
#' @param event_type The type of movement to classify (e.g., "hire", "fire", and "retirement").
#' @param start_date The start date for the classification period.
#' @param end_date The end date for the classification period.
#' @param status_col The name of the column representing employment status.
#' @param freq The frequency of the reference dates (default is "year").
#'
#' @returns A data frame with an additional column indicating the type of movement for each personnel record.
#'
#' @importFrom data.table setDT fcase copy
#' @importFrom lubridate ymd
#'
#' @export
classify_personnel_event <- function(
  data,
  id_col,
  event_type,
  start_date,
  end_date,
  status_col,
  freq = "year"
) {
  .Deprecated(
    msg = paste0(
      "`classify_personnel_event()` is deprecated and will be removed in a ",
      "future release; use `detect_movement()` or `detect_retirement()` ",
      "instead."
    )
  )

  if (event_type %in% c("hire", "fire")) {
    personnel_event <- detect_personnel_event(
      data = data,
      event_type = event_type,
      id_col = id_col,
      start_date = start_date,
      end_date = end_date,
      status_col = status_col,
      freq = freq
    )
  } else if (event_type == "retirement") {
    personnel_event <- detect_retirement(data, status_col = status_col)[
      retirement %in% TRUE,
      .(personnel_id, ref_date, type_event = "retire")
    ]
  }

  data <- data.table::copy(setDT(data))
  personnel_event <- data.table::setDT(personnel_event)

  data[personnel_event, on = c(id_col, "ref_date"), type_event := i.type_event]

  data[,
    type_event := fcase(
      type_event == "hire"   , "hire"       ,
      type_event == "fire"   , "fire"       ,
      type_event == "retire" , "retirement" ,
      default = "stayed"
    )
  ]

  # exclude minimum ref_date when movement_type is hire
  # and exclude maximum ref_date when movement_type is fire
  start_ref_date <- lubridate::ymd(start_date)
  end_ref_date <- lubridate::ymd(end_date)

  if (event_type == "hire") {
    data <- data[ref_date > start_ref_date]
  } else if (event_type == "fire") {
    data <- data[ref_date < end_ref_date]
  }

  data[]
}

#' Compute the cost of hires and separations
#'
#' Adds up, for each reference date, the pay of the people who are hired or
#' separate at that date.
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
#' @param status_col Character. Column holding employment status. Only rows
#'   equal to `"active"` are considered. Default `"employment_status"`.
#' @param ... Arguments passed to methods.
#'
#' @returns A table with one row per `ref_date`, group and movement type,
#'   containing `movement_type` (one of `event_type`) and `movement_cost`, the
#'   movers' pay. `movement_cost` is 0 when nobody moved, and `NA` on the date
#'   with nothing to compare with: the first date for hires, the last for
#'   separations. A data.table for data frame input; a lazy table for
#'   `tbl_dbi` input (use [dplyr::collect()] to bring it into memory).
#'
#' @details
#' Hires are costed at their pay on the date they are hired, and separations
#' at their pay on their last active date. The pay on all of a mover's active
#' records that date is added up, so people with several contracts are costed
#' in full; pay recorded alongside, such as a pension, is not. Missing pay
#' counts as 0.
#'
#' With `group_cols`, each mover's pay is counted in the group of the record it
#' comes from. Every group with active personnel on a date appears for that
#' date.
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
#' @importFrom data.table as.data.table fcoalesce fifelse rbindlist setorderv
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

  flags <- detect_movement(dt, status_col = status_col)[
    , .(personnel_id, ref_date, hire, separation)
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

  by_cols <- c("ref_date", group_cols)

  costs <- lapply(event_type, function(movement) {
    # flags are NA on a date with nothing to compare with, which carries
    # through to the cost
    cost <- records[
      , .(
        movement_type = movement,
        movement_cost = sum(
          data.table::fifelse(
            get(movement),
            data.table::fcoalesce(as.numeric(get(measure_col)), 0),
            0
          )
        )
      ),
      by = by_cols
    ]

    data.table::setorderv(cost, by_cols)

    cost
  })

  data.table::rbindlist(costs)
}

#' @rdname compute_movement_cost
#' @importFrom dplyr all_of coalesce filter if_else inner_join mutate select
#'   summarise union_all
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

  flags <- detect_movement(data, status_col = status_col) |>
    select(personnel_id, ref_date, hire, separation)

  # every active record carries its person's flags, so a mover's pay is added
  # up over all their contracts that date
  records <- data |>
    filter(.data[[status_col]] == "active") |>
    select(all_of(c(keys, group_cols, measure_col))) |>
    inner_join(flags, by = keys)

  # flags are NULL on a date with nothing to compare with, so the SUM() is
  # NULL there too
  event_type |>
    purrr::map(
      \(movement) {
        records |>
          summarise(
            movement_cost = sum(
              if_else(.data[[movement]], coalesce(.data[[measure_col]], 0), 0),
              na.rm = TRUE
            ),
            .by = all_of(c("ref_date", group_cols))
          ) |>
          mutate(movement_type = !!movement)
      }
    ) |>
    purrr::reduce(union_all) |>
    select(ref_date, all_of(group_cols), movement_type, movement_cost)
}

#' Compute the cost of retirements
#'
#' Adds up, for each reference date, the pay of the people who retire at that
#' date.
#'
#' @inheritParams compute_movement_cost
#' @param status_col Character. Column holding employment status, with active
#'   personnel recorded as `"active"` and retirees as `"pensioner"`. Default
#'   `"employment_status"`.
#'
#' @returns A table with one row per `ref_date` and group, containing
#'   `retirement_cost`, the retirees' pay. `retirement_cost` is 0 when nobody
#'   retired, and `NA` on the last date, which has nothing to compare with. A
#'   data.table for data frame input; a lazy table for `tbl_dbi` input (use
#'   [dplyr::collect()] to bring it into memory).
#'
#' @details
#' Retirees are costed at their pay on their last active date. The pay on all
#' of a retiree's active records that date is added up, so people with several
#' contracts are costed in full; pay recorded alongside, such as a pension, is
#' not. Missing pay counts as 0.
#'
#' With `group_cols`, each retiree's pay is counted in the group of the record
#' it comes from. Every group with active personnel on a date appears for that
#' date.
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
#' @importFrom data.table as.data.table fcoalesce fifelse setorderv
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
    , .(personnel_id, ref_date, retirement)
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

  by_cols <- c("ref_date", group_cols)

  # the flag is NA on the last date, which carries through to the cost
  cost <- records[
    , .(
      retirement_cost = sum(
        data.table::fifelse(
          retirement,
          data.table::fcoalesce(as.numeric(get(measure_col)), 0),
          0
        )
      )
    ),
    by = by_cols
  ]

  data.table::setorderv(cost, by_cols)

  cost[]
}

#' @rdname compute_retirement_cost
#' @importFrom dplyr all_of coalesce filter if_else inner_join select summarise
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

  flags <- detect_retirement(data, status_col = status_col) |>
    select(personnel_id, ref_date, retirement)

  # every active record carries its person's flag, so a retiree's pay is
  # added up over all their contracts that date
  data |>
    filter(.data[[status_col]] == "active") |>
    select(all_of(c(keys, group_cols, measure_col))) |>
    inner_join(flags, by = keys) |>
    # the flag is NULL on the last date, so the SUM() is NULL there too
    summarise(
      retirement_cost = sum(
        if_else(retirement, coalesce(.data[[measure_col]], 0), 0),
        na.rm = TRUE
      ),
      .by = all_of(c("ref_date", group_cols))
    )
}

#' Compute movements as hires and separations
#'
#' Counts, for each reference date, how many people are active, how many
#' joined since the previous date (hires) and how many are gone by the next
#' date (separations). Hire, separation, and replacement rates are also returned.
#'
#' @param data Data frame or remote database table (`tbl_dbi`) with one row
#'   per person-record. Must contain `personnel_id`, `ref_date` and the column
#'   named in `status_col`.
#' @param group_cols Character vector of columns to group by, such as
#'   `"est_id"`, or `NULL` (default) for the whole workforce. Must not include
#'   `ref_date`.
#' @param status_col Character. Column holding employment status. Only rows
#'   equal to `"active"` are counted. Default `"employment_status"`.
#' @param ... Arguments passed to methods.
#'
#' @returns A table with one row per `ref_date` and group, containing:
#' \describe{
#'   \item{headcount}{Number of active people.}
#'   \item{hires}{People active on this date but not on the previous one. `NA`
#'     on the first date, which has nothing to compare with.}
#'   \item{separations}{People active on this date but not on the next one. `NA`
#'     on the last date.}
#'   \item{hire_rate, separation_rate}{`hires` and `separations` divided by
#'     `headcount`.}
#' }
#' A data.table for data frame input; a lazy table for `tbl_dbi` input (use
#' [dplyr::collect()] to bring it into memory).
#'
#' @details
#' The previous and next dates are the neighbouring dates found in the data,
#' so the dates do not need to be evenly spaced.
#'
#' People are counted once per date, even if they hold several contracts. A
#' separation is any exit from active status, including retirement.
#'
#' With `group_cols`, each person is counted in the group they belong to on
#' that date. Moving from one group to another is neither a hire nor a
#' separation; use [compute_transition()] to count those moves.
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

  # one row per person, date and group, so people with several contracts
  # count once
  person_groups <- unique(
    dt[
      get(status_col) == "active",
      c("personnel_id", "ref_date", group_cols),
      with = FALSE
    ]
  )

  movement <- detect_movement(dt, status_col = status_col)[
    person_groups,
    on = c("personnel_id", "ref_date")
  ][
    , .(
      headcount = .N,
      hires = sum(hire),
      separations = sum(separation)
    ),
    by = c("ref_date", group_cols)
  ][
    , `:=`(
      hire_rate = hires / headcount,
      separation_rate = separations / headcount,
      replacement_rate = hires / separations
    )
  ]

  data.table::setorderv(movement, c("ref_date", group_cols))

  movement[]
}

#' @rdname compute_movement
#' @importFrom dplyr all_of distinct filter if_else inner_join mutate n select
#'   summarise
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

  # one row per person, date and group, so people with several contracts
  # count once
  person_groups <- data |>
    filter(.data[[status_col]] == "active") |>
    select(all_of(c("personnel_id", "ref_date", group_cols))) |>
    distinct()

  person_groups |>
    inner_join(
      detect_movement(data, status_col = status_col),
      by = c("personnel_id", "ref_date")
    ) |>
    # hire (separation) is NULL on the first (last) date, so its SUM() stays
    # NULL there. counted as doubles, since some backends, such as SQLite,
    # divide integers without the fraction in the rates
    summarise(
      headcount = n(),
      hires = sum(if_else(hire, 1, 0), na.rm = TRUE),
      separations = sum(if_else(separation, 1, 0), na.rm = TRUE),
      .by = all_of(c("ref_date", group_cols))
    ) |>
    mutate(
      hire_rate = hires / headcount,
      separation_rate = separations / headcount,
      replacement_rate = hires / separations
    ) |>
    select(
      all_of(c("ref_date", group_cols)),
      headcount, hires, separations, hire_rate, separation_rate, replacement_rate
    )
}

#' Compute retirements
#'
#' Counts, for each reference date, how many people are active and how many of
#' them leave active status by the next date into a pension, i.e. whose next
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
#'   \item{retirements}{Active people who are no longer active on the next
#'     date and are next recorded as pensioners. `NA` on the last date, which
#'     has nothing to compare with.}
#'   \item{retirement_rate}{`retirements` divided by `headcount`.}
#' }
#' A data.table for data frame input; a lazy table for `tbl_dbi` input (use
#' [dplyr::collect()] to bring it into memory).
#'
#' @details
#' The next date is the neighbouring date found in the data, so the dates do
#' not need to be evenly spaced. People are counted once per date, even if they
#' hold several contracts. With `group_cols`, each person is counted in the
#' group they belong to on that date.
#'
#' Pension registration can lag the exit, so the pensioner record may appear
#' at any later date, not only the next one. A retirement is dated by the exit,
#' not by the registration. A person who returns to active work before any
#' pensioner record counts as a separation, not a retirement, at the earlier
#' exit. There is no limit on the lag, so an exit followed years later by a
#' deferred pension also counts as a retirement.
#'
#' @seealso [compute_movement()], whose separations include these retirements
#'   and whose rates share their denominator. [detect_retirement()], which
#'   flags the retirements of each person.
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

  retirement <- detect_retirement(dt, status_col = status_col)[
    person_groups,
    on = c("personnel_id", "ref_date")
  ][
    , .(
      headcount = .N,
      retirements = sum(retirement)
    ),
    by = c("ref_date", group_cols)
  ][
    , retirement_rate := retirements / headcount
  ]

  data.table::setorderv(retirement, c("ref_date", group_cols))

  retirement[]
}

#' @rdname compute_retirement
#' @importFrom dplyr all_of distinct filter if_else inner_join mutate n select
#'   summarise
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

  person_groups |>
    inner_join(
      detect_retirement(data, status_col = status_col),
      by = c("personnel_id", "ref_date")
    ) |>
    # retirement is NULL on the last date, so its SUM() stays NULL there.
    # counted as doubles, since some backends, such as SQLite, divide integers
    # without the fraction in retirement_rate
    summarise(
      headcount = n(),
      retirements = sum(if_else(retirement, 1, 0), na.rm = TRUE),
      .by = all_of(c("ref_date", group_cols))
    ) |>
    mutate(retirement_rate = retirements / headcount) |>
    select(
      all_of(
        c("ref_date", group_cols, "headcount", "retirements", "retirement_rate")
      )
    )
}

#' Estimate historical non-retirement exit rates from panel data
#'
#' @description
#' Uses \code{govhr::detect_personnel_event(event_type = "fire")} to identify
#' non-retirement attrition events (voluntary resignation, dismissal, contract
#' non-renewal) across the full historical panel.  Computes
#' \code{exit_rate = n_exits / n_active} per group per panel snapshot, then
#' returns the mean rate per group.
#'
#' @param contracts Data.table.  Full panel of contract data (all
#'   \code{ref_date} snapshots).
#' @param personnel Data.table.  Full panel of personnel data.
#' @param group_cols Character vector or \code{NULL}.  Columns to group by
#'   (e.g. \code{"est_id"}).  Pass \code{NULL} for an overall (ungrouped) rate.
#' @param freq Character.  Frequency passed to
#'   \code{govhr::detect_personnel_event()}.  Default \code{"year"}.
#' @param personnel_id_col Character.  Default \code{"personnel_id"}.
#' @param ref_date Date or character. Optional reference date (currently unused;
#'   included to prevent partial argument matching against \code{ref_date_col}).
#' @param ref_date_col Character.  Default \code{"ref_date"}.
#' @param start_date_col Character.  Default \code{"start_date"}.
#' @param end_date_col Character.  Default \code{"end_date"}.
#' @param contract_type_col Character.  Default \code{"contract_type_code"}.
#' @param status_col Character.  Default \code{"employment_status"}.
#' @param contract_dt Deprecated. Use `contracts` instead.
#' @param personnel_dt Deprecated. Use `personnel` instead.
#'
#' @returns data.table with \code{group_cols} (if specified) and
#'   \code{exit_rate} column.
#' @export
estimate_exit_rates <- function(
  contracts,
  personnel,
  group_cols = NULL,
  freq = "year",
  ref_date = NULL,
  personnel_id_col = "personnel_id",
  ref_date_col = "ref_date",
  start_date_col = "start_date",
  contract_type_col = "contract_type",
  end_date_col = "end_date",
  status_col = "employment_status",
  contract_dt = NULL,
  personnel_dt = NULL
) {
  contracts <- resolve_renamed_arg(contracts, contract_dt, "contract_dt", "contracts")
  personnel <- resolve_renamed_arg(personnel, personnel_dt, "personnel_dt", "personnel")
  panel_contract_dt <- data.table::as.data.table(contracts)
  panel_personnel_dt <- data.table::as.data.table(personnel)

  # Validate required columns exist before any downstream operations
  required_contract <- unique(c(
    ref_date_col,
    personnel_id_col,
    contract_type_col,
    if (!is.null(group_cols)) group_cols
  ))
  required_personnel <- c(ref_date_col, personnel_id_col)
  missing_c <- setdiff(required_contract, names(panel_contract_dt))
  missing_p <- setdiff(required_personnel, names(panel_personnel_dt))
  if (length(missing_c) > 0) {
    stop(
      "Columns not found in contracts: ",
      paste(missing_c, collapse = ", "),
      call. = FALSE
    )
  }
  if (length(missing_p) > 0) {
    stop(
      "Columns not found in personnel: ",
      paste(missing_p, collapse = ", "),
      call. = FALSE
    )
  }

  # Coerce ref_date to Date in both panels (may be stored as integer after
  # as.data.table() if the original was a Date column in a data.frame).
  # as.Date() on an integer requires origin = "1970-01-01"; on a Date it is a no-op.
  .rdc <- ref_date_col
  safe_as_date <- function(x) {
    if (inherits(x, "Date")) x else as.Date(x, origin = "1970-01-01")
  }
  panel_personnel_dt[, (.rdc) := safe_as_date(get(.rdc))]
  panel_contract_dt[, (.rdc) := safe_as_date(get(.rdc))]

  panel_dates <- sort(unique(panel_personnel_dt[[ref_date_col]]))
  panel_dates <- panel_dates[!is.na(panel_dates)]

  if (length(panel_dates) < 2L) {
    stop(
      "personnel must contain at least 2 distinct ref_date snapshots. ",
      "Found ",
      length(panel_dates),
      ".",
      call. = FALSE
    )
  }

  start_str <- format(min(panel_dates))
  end_str <- format(max(panel_dates))

  # Detect non-retirement exit events across the full panel
  fire_events <- govhr::detect_personnel_event(
    data = panel_personnel_dt,
    id_col = personnel_id_col,
    event_type = "fire",
    start_date = start_str,
    end_date = end_str,
    freq = freq,
    status_col = status_col
  )
  # fire_events columns: personnel_id_col, ref_date, type_event

  # Join to contract panel to retrieve group_cols per exit
  if (!is.null(group_cols) && length(group_cols) > 0) {
    contract_groups <- unique(
      panel_contract_dt[,
        c(personnel_id_col, ref_date_col, group_cols),
        with = FALSE
      ]
    )
    fire_events <- contract_groups[
      fire_events,
      on = c(personnel_id_col, ref_date_col)
    ]

    complete_rows <- Reduce(
      `&`,
      lapply(group_cols, function(g) !is.na(fire_events[[g]]))
    )
    exit_counts <- fire_events[
      complete_rows,
      .(n_exits = .N),
      by = c(ref_date_col, group_cols)
    ]
  } else {
    exit_counts <- fire_events[, .(n_exits = .N), by = ref_date_col]
  }

  active_types <- c("fixed-term", "permanent", "short-term")
  stock_dt <-
    panel_contract_dt[,
      .(
        current_stock = data.table::uniqueN(
          get(personnel_id_col)[get(contract_type_col) %in% active_types]
        )
      ),
      by = c(group_cols, ref_date_col)
    ]

  join_keys <- if (!is.null(group_cols) && length(group_cols) > 0) {
    c(ref_date_col, group_cols)
  } else {
    ref_date_col
  }

  rate_dt <- exit_counts[stock_dt, on = join_keys]
  rate_dt[is.na(n_exits), n_exits := 0L]
  rate_dt[,
    exit_rate := data.table::fifelse(
      current_stock > 0,
      n_exits / current_stock,
      0
    )
  ]

  if (!is.null(group_cols) && length(group_cols) > 0) {
    result <- rate_dt[,
      .(exit_rate = mean(exit_rate, na.rm = TRUE)),
      by = group_cols
    ]
    result[is.nan(exit_rate), exit_rate := 0]
  } else {
    avg <- mean(rate_dt$exit_rate, na.rm = TRUE)
    result <- data.table::data.table(exit_rate = if (is.nan(avg)) 0 else avg)
  }

  result
}

# helpers ----------------------------------------------------------------

#' Complete panel data by identifier and reference dates
#'
#' Expands a dataset to include all combinations of identifiers and reference
#' dates within a specified start–end range. This is useful for ensuring that
#' each identifier has a record for every time point, even if data are missing.
#'
#' @param data A data.frame or data.table containing at least an identifier column.
#' @param id_col Character. Name of the identifier column (e.g., `"personnel_id"`).
#' @param start_date Character or Date. Start of the full date sequence
#'   (e.g., `"2007-09-01"`).
#' @param end_date Character or Date. End of the full date sequence
#'   (e.g., `"2018-01-01"`).
#' @param freq Character. Interval for date sequence passed to
#'   \code{seq.Date(by = ...)}. Default is `"year"`.
#'
#' @returns A \code{data.table} containing all possible combinations of identifiers
#'   and reference dates between the given start and end points, merged with
#'   the original data.
#'
#' @details
#' This function generates a complete identifier–date grid using
#' \code{seq.Date()} between \code{start_date} and \code{end_date}, then merges
#' it with the original dataset using a left join (\code{all.x = TRUE}).
#'
#' @importFrom data.table as.data.table data.table setnames
#' @importFrom lubridate ymd
#' @importFrom dplyr mutate if_else
#'
#' @examples
#' \dontrun{
#' complete_dt <- complete_dates(
#'   data = personnel_df,
#'   id_col = "personnel_id",
#'   start_date = "2007-09-01",
#'   end_date = "2018-01-01",
#'   freq = "year"
#' )
#' }
#' @export
complete_dates <- function(data, id_col, start_date = NULL, end_date = NULL, freq = "year") {
  # Convert to data.table
  dt <- data.table::as.data.table(data)

  dt[,
    expanded := FALSE
  ]

  # Build full date range and unique identifiers
  if(is.null(start_date)) {
    start_date <- as.character(min(dt[["ref_date"]]))
  }

  if(is.null(end_date)) {
    end_date <- as.character(max(dt[["ref_date"]]))
  }

  full_dates <- lubridate::ymd(start_date) %>%
    seq(lubridate::ymd(end_date), by = freq)

  unique_id <- unique(dt[[id_col]])

  # Create complete identifier–date grid
  full_grid <- data.table::data.table(
    id = rep(unique_id, each = length(full_dates)),
    ref_date = rep(full_dates, length(unique_id))
  )

  # Merge grid with original data (dynamic column name assignment)
  expanded_dt <- merge(
    full_grid,
    dt,
    by.x = c("id", "ref_date"),
    by.y = c(id_col, "ref_date"),
    all.x = TRUE
  )

  # Rename id column back to its original name
  data.table::setnames(expanded_dt, "id", id_col)

  expanded_dt <- convert_data(
    expanded_dt,
    data
  ) |>
    dplyr::mutate(
      expanded = dplyr::if_else(
        is.na(.data[["expanded"]]),
        TRUE,
        .data[["expanded"]]
      )
    )

  return(expanded_dt)
}
