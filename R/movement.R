#' Calculate time intervals between reference dates
#'
#' This function computes the time interval between consecutive values
#' in a reference date column, optionally within groups.
#'
#' @param data A data frame or tibble.
#' @param ref_date Name of the column containing reference dates.
#' @param group_vars Optional grouping variables (e.g., `id`, `country`, or `c(id, country)`).
#'
#' @return The original data with an additional set of columns indicating the
#'   difference between consecutive reference dates.
#' @examples
#' library(tibble)
#'
#' df <- tibble(id = c(1, 1, 1, 2, 2),
#'              ref_date = as.Date(c("2020-01-01", "2021-01-01", "2023-01-01",
#'                                   "2020-06-01", "2020-12-01")))
#' calculate_date_intervals(df, "ref_date", "id")
#'
#' @importFrom data.table setDT setorderv copy shift
#' @export
calculate_date_intervals <- function(data, ref_date, group_vars = NULL) {
  # Ensure the input is a data.table for efficient modification
  data.table::setDT(data)

  # Sort by group and then by the date column to ensure correct lagged values
  data.table::setorderv(data, c(group_vars, ref_date))

  # Calculate the interval using get() and shift()
  data_out <- data[,
    .(
      interval_days = as.numeric(ref_date) -
        as.numeric(data.table::shift(ref_date, type = "lag"))
    ),
    by = group_vars
  ]

  data_out <- data.table::copy(data)

  return(data_out)
}

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

#' Add Contract Information to Event Records
#'
#' @description
#' This function merges contract information into an event dataset (such as hires, terminations, or transfers)
#' by matching on `personnel_id` and `ref_date`. It ensures that selected variables from the contract dataset
#' are attached to corresponding events without duplicating records.
#'
#' @param event_dt A data.table containing personnel event records. Must include the columns
#'   `personnel_id` and `ref_date`.
#' @param contract_dt A data.table containing contract information, also including `personnel_id`
#'   and `ref_date`. The contract dataset provides additional attributes describing the personnel's
#'   contractual context on each reference date.
#' @param keep_vars A character vector of variable names in `contract_dt` to be merged into the
#'   event dataset. These typically describe contract-level attributes such as position, department,
#'   or employment type.
#'
#' @return
#' A data.table identical to `event_dt`, but with the specified variables from `contract_dt`
#' joined in by matching on `personnel_id` and `ref_date`.
#'
#' @details
#' The function performs a *right join* operation of the `contract_dt` onto `event_dt`
#' (via `data.table`'s `on` syntax). Only unique combinations of `personnel_id`, `ref_date`,
#' and `keep_vars` are retained from the contract dataset prior to the join, preventing
#' duplicate key matches.
#'
#' This function is particularly useful when enriching HR event logs with contextual information
#' about the employee’s contract at the time of each event.
#'
#' @examples
#' \dontrun{
#' library(data.table)
#'
#' event_dt <- data.table(
#'   personnel_id = c(1, 2, 3),
#'   ref_date = as.IDate(c("2020-01-01", "2020-02-01", "2020-03-01")),
#'   type_event = c("hire", "fire", "hire")
#' )
#'
#' contract_dt <- data.table(
#'   personnel_id = c(1, 2, 3),
#'   ref_date = as.IDate(c("2020-01-01", "2020-02-01", "2020-03-01")),
#'   department = c("Finance", "HR", "IT"),
#'   contract_type = c("permanent", "temporary", "consultant")
#' )
#'
#' enriched_events <- add_contract_to_event(
#'   event_dt,
#'   contract_dt,
#'   keep_vars = c("department", "contract_type")
#' )
#' }
#'
#' @seealso [data.table::merge()], [data.table::unique()]
#' @export

add_contract_to_event <- function(event_dt, contract_dt, keep_vars) {
  contract_dt <- unique(contract_dt[,
    c("personnel_id", "ref_date", keep_vars),
    with = FALSE
  ])

  event_dt <- contract_dt[event_dt, on = c("personnel_id", "ref_date")]

  return(event_dt)
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
detect_career_transitions <- function(contract_dt,
                                      vars,
                                      decision_var,
                                      decision_fn = max) {
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

#' Classify Personnel Movements
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
#' @importFrom data.table setDT fcase copy
#' @importFrom lubridate ymd
#' @importFrom govhr detect_personnel_event
#'
#' @export
#' @return A data frame with an additional column indicating the type of movement for each personnel record.
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
