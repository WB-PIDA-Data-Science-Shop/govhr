
#' Flag the flows of each active person and date
#'
#' Flags, for each active person and reference date, whether they were hired
#' since the previous date, and whether they leave active status by the next
#' date into a pension (a retirement) or exiting the public sector (a separation).
#'
#' @param data Data frame or remote database table (`tbl_dbi`) with one row
#'   per person-record. Must contain `personnel_id`, `ref_date` and the column
#'   named in `status_col`.
#' @param status_col Character. Column holding employment status. Rows equal
#'   to `"active"` are the active workforce, and rows equal to `"pensioner"`
#'   mark exits as retirements. Default `"employment_status"`.
#' @param ... Arguments passed to methods.
#'
#' @returns A table with one row per active person and `ref_date`, containing
#'   `personnel_id`, `ref_date`, `prev_date`, `next_date`, `hire`,
#'   `separation` and `retirement`. `hire` is `NA` on the first date, and
#'   `separation` and `retirement` on the last, which have nothing to compare
#'   with. A data.table for data frame input; a lazy table for `tbl_dbi` input.
#'
#' @details See [detect_movement()] and [detect_retirement()] for how hires,
#'   separations and retirements are defined.
#'
#' @export
detect_workforce_flows <- function(data, ...) {
  UseMethod("detect_workforce_flows")
}

#' @rdname detect_workforce_flows
#' @importFrom data.table := as.data.table data.table fifelse setorderv shift
#' @importFrom rlang check_dots_empty
#' @export
detect_workforce_flows.data.frame <- function(
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
  pensioner_dates <- unique(
    dt[get(status_col) == "pensioner", .(personnel_id, ref_date)]
  )

  # previous and next date for each date in the data
  dates <- sort(unique(person_dates[["ref_date"]]))
  calendar <- data.table::data.table(
    ref_date = dates,
    prev_date = data.table::shift(dates),
    next_date = data.table::shift(dates, type = "lead")
  )

  flows <- calendar[person_dates, on = "ref_date"]

  # hired: no active record on the previous date. NA when there is no
  # previous date to compare with
  flows[, hire := data.table::fifelse(is.na(prev_date), NA, TRUE)]
  flows[
    person_dates,
    on = .(personnel_id, prev_date = ref_date),
    hire := FALSE
  ]

  # exited: no active record on the next date. NA when there is no next date
  # to compare with
  flows[, exited := data.table::fifelse(is.na(next_date), NA, TRUE)]
  flows[
    person_dates,
    on = .(personnel_id, next_date = ref_date),
    exited := FALSE
  ]

  exits <- flows[exited %in% TRUE, .(personnel_id, ref_date, next_date)]

  # pension registration can lag the exit, so roll forward to the first
  # pensioner and active records from the next date onwards rather than
  # looking at the next date only
  next_pension <- pensioner_dates[
    exits,
    on = .(personnel_id, ref_date = next_date),
    roll = -Inf,
    x.ref_date
  ]
  next_return <- person_dates[
    exits,
    on = .(personnel_id, ref_date = next_date),
    roll = -Inf,
    x.ref_date
  ]

  # a pension that starts by the time the person returns, e.g. a retiree
  # rehired on contract, still marks the exit as a retirement
  retirees <- exits[
    !is.na(next_pension) & (is.na(next_return) | next_pension <= next_return),
    .(personnel_id, ref_date)
  ]

  flows[, retirement := data.table::fifelse(is.na(next_date), NA, FALSE)]
  flows[retirees, on = .(personnel_id, ref_date), retirement := TRUE]

  # an exit is either a retirement or a separation, never both
  flows[, separation := exited & !retirement]

  data.table::setorderv(flows, c("ref_date", "personnel_id"))

  flows[
    , .(personnel_id, ref_date, prev_date, next_date, hire, separation, retirement)
  ]
}

#' @rdname detect_workforce_flows
#' @importFrom rlang .data check_dots_empty
#' @export
detect_workforce_flows.tbl_dbi <- function(
  data,
  status_col = "employment_status",
  ...
) {
  rlang::check_dots_empty()

  # one row per person and date
  person_dates <- data |>
    dplyr::filter(.data[[status_col]] == "active") |>
    dplyr::select(
      dplyr::all_of(c("personnel_id", "ref_date"))
    ) |>
    dplyr::distinct()

  # renamed so they can be compared with each exit's dates
  pensioner_dates <- data |>
    dplyr::filter(
      .data[[status_col]] == "pensioner"
    ) |>
    dplyr::select(
      personnel_id, pension_date = ref_date
    ) |>
    dplyr::distinct()

  active_dates <- person_dates |>
    dplyr::select(
      personnel_id, active_date = ref_date
    )

  flows <- person_dates |>
    dplyr::inner_join(
      build_calendar(person_dates),
      by = "ref_date"
    )

  # hired: no active record on the previous date
  hires <- flows |>
    dplyr::filter(
      !is.na(prev_date)
    ) |>
    dplyr::anti_join(
      person_dates,
      by = dplyr::join_by(personnel_id, prev_date == ref_date)
    ) |>
    dplyr::select(
      dplyr::all_of(c("personnel_id", "ref_date"))
    ) |>
    dplyr::mutate(hired = 1)

  # separated: no active record on the next date
  separations <- flows |>
    dplyr::filter(
      !is.na(next_date)
    ) |>
    dplyr::anti_join(
      person_dates,
      by = dplyr::join_by(
        personnel_id, next_date == ref_date
      )
    ) |>
    dplyr::select(
      dplyr::all_of(
        c("personnel_id", "ref_date", "next_date")
      )
    )

  # pension registration can lag the exit, so take the first pensioner and
  # active records from the next date onwards. SQL has no rolling join, hence
  # the inequality join and min()
  next_pension <- separations |>
    dplyr::inner_join(
      pensioner_dates,
      by = dplyr::join_by(personnel_id, next_date <= pension_date)
    ) |>
    dplyr::summarise(
      next_pension = min(pension_date, na.rm = TRUE),
      .by = c("personnel_id", "ref_date")
    )

  next_return <- separations |>
    dplyr::inner_join(
      active_dates,
      by = dplyr::join_by(personnel_id, next_date <= active_date)
    ) |>
    dplyr::summarise(
      next_return = min(active_date, na.rm = TRUE),
      .by = c("personnel_id", "ref_date")
    )

  # a pension that starts by the time the person returns, e.g. a retiree
  # rehired on contract, still marks the exit as a retirement
  retirees <- separations |>
    dplyr::inner_join(
      next_pension,
      by = c("personnel_id", "ref_date")
    ) |>
    dplyr::left_join(
      next_return,
      by = c("personnel_id", "ref_date")
    ) |>
    dplyr::filter(
      is.na(next_return) | next_pension <= next_return
    ) |>
    dplyr::select(
      dplyr::all_of(c("personnel_id", "ref_date"))
    ) |>
    dplyr::mutate(retired = 1)

  flows <- flows |>
    dplyr::left_join(
      hires,
      by = c("personnel_id", "ref_date")
    ) |>
    dplyr::left_join(
      separations |>
        dplyr::select(dplyr::all_of(c("personnel_id", "ref_date"))) |>
        dplyr::mutate(separated = 1),
      by = c("personnel_id", "ref_date")
    ) |>
    dplyr::left_join(
      retirees,
      by = c("personnel_id", "ref_date")
    ) 
  
  flows |>
    dplyr::mutate(
      hire = dplyr::if_else(
        is.na(prev_date), NA, !is.na(hired)
      ),
      separation = dplyr::if_else(
        is.na(next_date), NA, !is.na(separated) & is.na(retired)
      ),
      retirement = dplyr::if_else(
        is.na(next_date), NA, !is.na(retired)
      )
    ) |>
    dplyr::select(
      dplyr::all_of(
        c(
          "personnel_id", "ref_date", "prev_date", "next_date",
          "hire", "separation", "retirement"
        )
      )
    )
}
