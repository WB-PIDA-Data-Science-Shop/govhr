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
#' @param status_col a column within `data` object for the employment status of personnel
#' @param end_date Optional end date for the full date sequence
#'   (default: `"2018-01-01"`).
#' @param freq Frequency for the sequence of dates (default: `"year"`).
#'   Can be any valid value for \code{seq.Date(by = ...)}.
#'
#' @return A dataset with event types detected (e.g., hire or fire).
#'
#' @importFrom data.table as.data.table copy setorderv shift
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
detect_personnel_event <- function(data,
                                   id_col,
                                   event_type,
                                   start_date,
                                   end_date,
                                   status_col,
                                   freq = "year") {
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
        type_event = fifelse(
          get(status_col) == "active" & is.na(data.table::shift(get(status_col), type = "lag")),
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
        type_event = fifelse(
          get(status_col) == "active" & is.na(data.table::shift(get(status_col), type = "lead")),
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

#' Detect Personnel Retirement Events
#'
#' Identifies personnel who retired, i.e., whose status changed from "active" to "inactive".
#'
#' @param data A data.frame or data.table with columns `personnel_id`, `ref_date`, and `status`.
#'
#' @return A data.table with `personnel_id`, `ref_date`, and `type_event = "retire"`.
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


#' Classify Personnel Movement Events
#'
#' This function classifies the personnel module into three types of movements: hires, fires, or retirements.
#'
#' @param .data A data frame containing personnel data.
#' @param id_col The name of the column representing personnel IDs.
#' @param event_type The type of movement to classify (e.g., "hire", "fire", and "retirement").
#' @param start_date The start date for the classification period.
#' @param end_date The end date for the classification period.
#' @param status_col The name of the column representing employment status.
#' @param freq The frequency of the reference dates (default is "year").
#'
#' @return A data frame with an additional column indicating the type of movement for each personnel record.
#' 
#' @importFrom data.table setDT fcase copy
#' @importFrom lubridate ymd
#'
#' @export
classify_personnel_event <- function(
  .data,
  id_col,
  event_type,
  start_date,
  end_date,
  status_col,
  freq = "year"
) {
  if (event_type %in% c("hire", "fire")) {
    personnel_event <- detect_personnel_event(
      data = .data,
      event_type = event_type,
      id_col = id_col,
      start_date = start_date,
      end_date = end_date,
      status_col = status_col,
      freq = freq
    )
  } else if (event_type == "retirement") {
    personnel_event <- detect_retirement(.data)
  }

  .data <- data.table::copy(setDT(.data))
  personnel_event <- data.table::setDT(personnel_event)

  .data[personnel_event, on = c(id_col, "ref_date"), type_event := i.type_event]

  .data[,
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
    .data <- .data[ref_date > start_ref_date]
  } else if (event_type == "fire") {
    .data <- .data[ref_date < end_ref_date]
  }

  .data[]
}

#' Function to compute the total cost associated with personnel movements.
#'
#' @param .data A data frame containing the data to be processed.
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
#' @return A data frame containing the movement cost for each requested event type within the specified groups and reference dates.
compute_movement_cost <- function(
  .data,
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
  dt <- data.table::as.data.table(.data)

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
        .data = dt,
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

# NOTE: consider renaming this function
#' Function to generate movement data for hires, fires, retirement, or turnover
#'
#' @param .data A data frame containing personnel data.
#' @param movement_type A character string indicating the type of movement: "hire", "fire", "retirement", or "turnover".
#' @param measurement_type A character string indicating the measurement type: "count" or "rate". Ignored for turnover, which is a ratio.
#' @param group_cols A character string indicating the grouping column, or "ref_date" for no grouping.
#'
#' @return A data.table containing the aggregated movement data.
#'
#' @importFrom data.table as.data.table setDT
#'
#' @details The function generates movement data based on the specified movement type and measurement type. For hires, fires, and retirements, it calculates either the count or rate of events. For turnover, it calculates the ratio of hires to separations (including retirements). The data is grouped by the specified columns.
#' @export
generate_movement_data <- function(
  .data,
  movement_type,
  measurement_type,
  group_cols
) {
  dt <- as.data.table(.data)

  min_date <- as.character(min(dt[["ref_date"]]))
  max_date <- as.character(max(dt[["ref_date"]]))

  if (!measurement_type %in% c("count", "rate")) {
    stop("Invalid measurement_type. Must be 'count' or 'rate'.")
  }

  freq_ref_date <- guess_date_frequency(dt)
  by_cols <- unique(c("ref_date", group_cols))

  if (movement_type %in% c("hire", "fire", "retirement")) {
    movement_dt <- govhr::classify_personnel_event(
      dt,
      event_type = movement_type,
      id_col = "personnel_id",
      start_date = min_date,
      end_date = max_date,
      status_col = "employment_status",
      freq = freq_ref_date
    )
    setDT(movement_dt)
    
    movement_data <- if (measurement_type == "count") {
      movement_dt[, .(indicator = sum(type_event == movement_type)), by = by_cols]
    } else {
      movement_dt[, .(indicator = mean(type_event == movement_type)), by = by_cols]
    }

  } else if (movement_type == "turnover") {
    hire_dt <- govhr::detect_personnel_event(
      dt,
      event_type = "hire",
      id_col = "personnel_id",
      start_date = min_date,
      end_date = max_date,
      status_col = "employment_status",
      freq = freq_ref_date
    )

    setDT(hire_dt)
    
    hire_data <- dt[hire_dt, on = c("personnel_id", "ref_date")][
      , .(hires = .N), by = by_cols
    ]

    fire_dt <- govhr::detect_personnel_event(
      dt,
      event_type = "fire",
      id_col = "personnel_id",
      start_date = min_date,
      end_date = max_date,
      status_col = "employment_status",
      freq = freq_ref_date
    )

    retirement_dt <- govhr::detect_retirement(dt)

    # combine fired and retired personnel for turnover calculation
    separations_dt <- rbind(fire_dt, retirement_dt)
    setDT(separations_dt)
    separations_dt <- dt[separations_dt, on = c("personnel_id", "ref_date")][
      , .(separations = .N), by = by_cols
    ]

    movement_data <- merge(hire_data, separations_dt, by = by_cols, all = TRUE)
    movement_data[, indicator := hires / separations]

    movement_data <- movement_data[!is.na(indicator)]
  }

  movement_data[]
}

#' Estimate Historical Non-Retirement Exit Rates from Panel Data
#'
#' @description
#' Uses \code{govhr::detect_personnel_event(event_type = "fire")} to identify
#' non-retirement attrition events (voluntary resignation, dismissal, contract
#' non-renewal) across the full historical panel.  Computes
#' \code{exit_rate = n_exits / n_active} per group per panel snapshot, then
#' returns the mean rate per group.
#'
#' @param contract_dt data.table.  Full panel of contract data (all
#'   \code{ref_date} snapshots).
#' @param personnel_dt data.table.  Full panel of personnel data.
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
#' @param status_col Character.  Default \code{"status"}.
#'
#' @return data.table with \code{group_cols} (if specified) and
#'   \code{exit_rate} column.
#' @export
estimate_exit_rates <- function(
  contract_dt,
  personnel_dt,
  group_cols = NULL,
  freq = "year",
  ref_date = NULL,
  personnel_id_col = "personnel_id",
  ref_date_col = "ref_date",
  start_date_col = "start_date",
  contract_type_col = "contract_type",
  end_date_col = "end_date",
  status_col = "employment_status"
) {
  panel_contract_dt <- data.table::as.data.table(contract_dt)
  panel_personnel_dt <- data.table::as.data.table(personnel_dt)

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
      "Columns not found in contract_dt: ",
      paste(missing_c, collapse = ", "),
      call. = FALSE
    )
  }
  if (length(missing_p) > 0) {
    stop(
      "Columns not found in personnel_dt: ",
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
      "personnel_dt must contain at least 2 distinct ref_date snapshots. ",
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
#' Complete Panel Data by Identifier and Reference Dates
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
#' @return A \code{data.table} containing all possible combinations of identifiers
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
complete_dates <- function(data,
                           id_col,
                           start_date,
                           end_date,
                           freq = "year") {
  # Convert to data.table
  dt <- data.table::as.data.table(data)

  dt[,
    expanded := FALSE
  ]

  # Build full date range and unique identifiers
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
