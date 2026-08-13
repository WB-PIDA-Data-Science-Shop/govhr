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
