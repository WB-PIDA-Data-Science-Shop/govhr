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

#' Detect personnel retirement events
#'
#' Identifies personnel who retired, i.e., whose status changed from "active" to "inactive".
#'
#' @param data A data.frame or data.table with columns `personnel_id`, `ref_date`, and `status`.
#'
#' @returns A data.table with `personnel_id`, `ref_date`, and `type_event = "retire"`.
#'
#' @importFrom data.table as.data.table shift
#'
#' @examples
#' \dontrun{
#' retire_events <- detect_retirement(personnel_df)
#' }
#' @export
detect_retirement <- function(data) {
  # Convert to data.table
  dt <- data.table::as.data.table(data)

  # Ensure ordering by personnel and date
  data.table::setorderv(dt, cols = c("personnel_id", "ref_date"))

  # Create lag_status within each personnel
  dt[,
    lead_status := data.table::shift(employment_status, type = "lead"),
    by = personnel_id
  ]

  # Filter for retire events
  retire_dt <- dt[
    lead_status == "pensioner" & employment_status == "active",
    .(personnel_id, ref_date)
  ]

  # Add event type
  retire_dt[, type_event := "retire"]

  retire_dt <- retire_dt |>
    convert_data(data)

  return(retire_dt)
}

#' Classify personnel movement events
#'
#' This function classifies the personnel module into three types of movements: hires, fires, or retirements.
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
    personnel_event <- detect_retirement(data)
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

#' Function to compute the total cost associated with personnel movements
#'
#' @param data A data frame containing the data to be processed.
#' @param id_col The name of the column representing personnel IDs (default is "personnel_id").
#' @param event_type A character vector indicating which movement event(s) to include (e.g., "hire", "fire", "retirement"). Multiple types can be supplied to compute costs for each type.
#' @param start_date The start date for the classification period. Defaults to the minimum reference date found in `.data`.
#' @param end_date The end date for the classification period. Defaults to the maximum reference date found in `.data`.
#' @param status_col The name of the column representing employment status (default is "employment_status").
#' @param freq The frequency of the reference dates. Defaults to a guess based on `.data`.
#' @param measure_col The name of the column containing the cost/measure to sum.
#' @param group_cols A character vector of column names to group the data by.
#' @param latest_measure A logical value indicating whether to return only the measures for the latest reference date.
#'
#' @importFrom data.table as.data.table setorderv rbindlist
#'
#' @export
#' @returns A data frame containing the movement cost for each requested event type within the specified groups and reference dates.
compute_movement_cost <- function(
  data,
  id_col = "personnel_id",
  event_type,
  start_date = NULL,
  end_date = NULL,
  status_col = "employment_status",
  freq = NULL,
  measure_col,
  group_cols = NULL,
  latest_measure = FALSE
) {
  dt <- data.table::as.data.table(data)

  if (is.null(start_date)) {
    start_date <- as.character(min(dt[["ref_date"]]))
  }
  if (is.null(end_date)) {
    end_date <- as.character(max(dt[["ref_date"]]))
  }
  if (is.null(freq)) {
    freq <- guess_date_frequency(dt)
  }

  by_cols <- c(group_cols, "ref_date")

  out <- data.table::rbindlist(
    lapply(event_type, function(type) {
      # classify personnel events
      classified <- classify_personnel_event(
        data = dt,
        id_col = id_col,
        event_type = type,
        start_date = start_date,
        end_date = end_date,
        status_col = status_col,
        freq = freq
      )

      # compute movement cost
      classified[
        type_event == type,
        .(
          movement_type = type,
          measurement = measure_col,
          movement_cost = sum(get(measure_col), na.rm = TRUE)
        ),
        keyby = by_cols
      ]
    })
  )

  data.table::setorderv(out, "ref_date")

  if (latest_measure) {
    latest_ref_date <- max(out[["ref_date"]])

    out <- out[ref_date == latest_ref_date]
  }

  out[]
}

#' Compute movements as hires and separations
#'
#' Counts, for each reference date, how many people are active, how many
#' joined since the previous date (hires) and how many are gone by the next
#' date (separations). Hire and separation rates are also returned.
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
#' @importFrom data.table := .N as.data.table data.table fifelse setorderv shift
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
  active <- dt[get(status_col) == "active"]

  # one row per person and date, so people with several contracts count once
  person_dates <- unique(active[, .(personnel_id, ref_date)])
  person_groups <- unique(
    active[, c("personnel_id", "ref_date", group_cols), with = FALSE]
  )

  # previous and next date for each date in the data
  dates <- sort(unique(person_dates$ref_date))
  calendar <- data.table::data.table(
    ref_date = dates,
    prev_date = data.table::shift(dates),
    next_date = data.table::shift(dates, type = "lead")
  )

  events <- calendar[person_dates, on = "ref_date"]

  # hired: no active record on the previous date. NA when there is no
  # previous date to compare with
  events[, hire := data.table::fifelse(is.na(prev_date), NA, TRUE)]
  events[person_dates, on = .(personnel_id, prev_date = ref_date), hire := FALSE]

  # separated: no active record on the next date
  events[, separation := data.table::fifelse(is.na(next_date), NA, TRUE)]
  events[
    person_dates,
    on = .(personnel_id, next_date = ref_date),
    separation := FALSE
  ]

  movement <- events[person_groups, on = c("personnel_id", "ref_date")][
    , .(
      headcount = .N,
      hires = sum(hire),
      separations = sum(separation)
    ),
    by = c("ref_date", group_cols)
  ][
    , `:=`(
      hire_rate = hires / headcount,
      separation_rate = separations / headcount
    )
  ]

  data.table::setorderv(movement, c("ref_date", group_cols))

  movement[]
}

#' @rdname compute_movement
#' @importFrom dplyr all_of anti_join coalesce distinct filter if_else inner_join
#'   join_by left_join mutate n select summarise
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

  active <- data |>
    filter(.data[[status_col]] == "active")

  # one row per person and date, so people with several contracts count once
  person_dates <- active |>
    select(all_of(c("personnel_id", "ref_date"))) |>
    distinct()

  person_groups <- active |>
    select(all_of(c("personnel_id", "ref_date", group_cols))) |>
    distinct()

  # previous and next date for each date in the data
  calendar <- build_calendar(person_dates)

  events <- person_dates |>
    inner_join(calendar, by = "ref_date")

  # hired: no active record on the previous date
  hires <- events |>
    filter(!is.na(prev_date)) |>
    anti_join(person_dates, by = join_by(personnel_id, prev_date == ref_date)) |>
    select(all_of(c("personnel_id", "ref_date"))) |>
    mutate(hire = 1)

  # separated: no active record on the next date
  separations <- events |>
    filter(!is.na(next_date)) |>
    anti_join(person_dates, by = join_by(personnel_id, next_date == ref_date)) |>
    select(all_of(c("personnel_id", "ref_date"))) |>
    mutate(separation = 1)

  person_groups |>
    inner_join(calendar, by = "ref_date") |>
    left_join(hires, by = c("personnel_id", "ref_date")) |>
    left_join(separations, by = c("personnel_id", "ref_date")) |>
    # SQL's SUM() returns NULL, not 0, when nobody was hired (separated), so
    # people without an event are counted as 0 first
    summarise(
      headcount = n(),
      hires = sum(coalesce(hire, 0), na.rm = TRUE),
      separations = sum(coalesce(separation, 0), na.rm = TRUE),
      .by = all_of(c("ref_date", "prev_date", "next_date", group_cols))
    ) |>
    # no previous (next) date to compare with, so hires (separations) are
    # unknown
    mutate(
      hires = if_else(is.na(prev_date), NA_real_, hires),
      separations = if_else(is.na(next_date), NA_real_, separations),
      hire_rate = hires / headcount,
      separation_rate = separations / headcount
    ) |>
    select(
      all_of(c("ref_date", group_cols)),
      headcount, hires, separations, hire_rate, separation_rate
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
