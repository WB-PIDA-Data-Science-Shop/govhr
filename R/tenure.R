
#' Compute employment tenure from contract history
#'
#' Computes cumulative employment tenure for each personnel member as of a
#' specified reference date while avoiding double-counting overlapping
#' contracts. Contracts with type \code{"inactive"} or
#' \code{"pensioner"} are excluded. Open-ended contracts are truncated at
#' the reference date before overlapping contract periods are merged to
#' calculate total tenure.
#'
#' Tenure is calculated independently for each personnel member and,
#' optionally, within additional grouping variables supplied through
#' \code{group_cols}. Gaps between contracts are excluded from the total
#' tenure.
#'
#' The implementation uses an interval-union algorithm based on
#' \code{cummax()} to efficiently merge overlapping contract periods,
#' resulting in an \eqn{O(n \log n)} algorithm dominated by the initial
#' sorting step.
#'
#' @param contract_dt data.table containing the contract history. Must include
#'   personnel identifiers, contract identifiers, contract start and end
#'   dates, contract types, and any grouping variables supplied in
#'   \code{group_cols}.
#' @param ref_date Date. Reference date at which tenure is calculated.
#' @param personnel_id_col Character. Name of the personnel identifier column.
#'   Default is \code{"personnel_id"}.
#' @param contract_id_col Character. Name of the contract identifier column.
#'   Default is \code{"contract_id"}.
#' @param start_date_col Character. Name of the contract start date column.
#'   Default is \code{"start_date"}.
#' @param end_date_col Character. Name of the contract end date column.
#'   Default is \code{"end_date"}.
#' @param contract_type_col Character. Name of the contract type column.
#'   Default is \code{"contract_type"}.
#' @param group_cols Optional character vector of additional variables over
#'   which tenure should be calculated independently (for example,
#'   establishment, occupation, or organization). Default is
#'   \code{NULL}.
#'
#' @return A data.table with one row per unique combination of
#'   \code{personnel_id} and optional \code{group_cols}, containing:
#'   \describe{
#'     \item{tenure_days}{Total employment tenure in days.}
#'     \item{tenure_years}{Total employment tenure in years, calculated as
#'     tenure days divided by 365.25.}
#'   }
#'
#' @keywords internal
#'
#' @examples
#' \dontrun{
#' tenure_dt <- compute_tenure(
#'   contract_dt = contract_data,
#'   ref_date = as.Date("2025-01-01")
#' )
#' }
#'
compute_tenure <- function(
  contract_dt,
  ref_date,
  personnel_id_col = "personnel_id",
  contract_id_col = "contract_id",
  start_date_col = "start_date",
  end_date_col = "end_date",
  contract_type_col = "contract_type",
  group_cols = NULL
) {
  # 0. always ensure data.table
  contract_dt <- as.data.table(contract_dt)

  if (is.null(group_cols) == FALSE) {
    validate_columns_exist(dt = contract_dt, colnames = group_cols)
  }

  # Alias ref_date to a name that cannot be shadowed by a column named 'ref_date'
  # in panel data.tables (data.table resolves column names before env variables).
  .ref_date_ <- if (inherits(ref_date, "Date")) ref_date else as.Date(ref_date)

  # 1. Filter inactive types — subset returns a new object, no copy() needed
  dt <- contract_dt[!get(contract_type_col) %in% c("inactive", "pensioner")]

  # 2. Keep only contracts that started on or before ref_date
  dt <- dt[get(start_date_col) <= .ref_date_]

  # 3. Cap open-ended / future contracts at ref_date
  dt[,
    .eff_end := data.table::fifelse(
      is.na(get(end_date_col)) | get(end_date_col) > .ref_date_,
      .ref_date_,
      get(end_date_col)
    )
  ]

  # 4. Deduplicate panel snapshots: one row per (contract_id, start_date)
  dt <- dt[dt[, .I[1L], by = c(contract_id_col, start_date_col)]$V1]

  # 5. Work on numeric days — use numeric (not integer) to avoid overflow when
  #    subtracting the sentinel fill value from real date integers.
  dt[, .s := as.numeric(get(start_date_col))]
  dt[, .e := as.numeric(.eff_end)]

  # Drop zero-length contracts (start == end contributes nothing)
  dt <- dt[.e > .s]

  if (nrow(dt) == 0L) {
    empty <- data.table::data.table(
      personnel_id = character(0),
      tenure_days = numeric(0),
      tenure_years = numeric(0)
    )
    data.table::setnames(empty, "personnel_id", personnel_id_col)
    return(empty[,
      c(personnel_id_col, "tenure_days", "tenure_years"),
      with = FALSE
    ])
  }

  # 6. Sort by person then start — O(n log n)
  data.table::setorderv(dt, c(personnel_id_col, group_cols, ".s"))

  # 7. Lagged cummax of end-dates within each person.
  #    fill = -1e15 (a numeric constant far outside any real date range) ensures
  #    the first interval per person is always classified as a new span without
  #    triggering integer overflow.
  dt[,
    .lag_max_e := data.table::shift(cummax(.e), fill = -1e15),
    by = c(personnel_id_col, group_cols)
  ]

  # 8. Classify each interval and compute its contribution to the union
  #    >= in Case 1: adjacent intervals (end_prev == start_curr) are new spans,
  #    not extensions and not nested.
  dt[,
    .contrib := data.table::fcase(
      .s >= .lag_max_e , .e - .s         , # Case 1: new span (or exact-boundary adjacent)
      .e > .lag_max_e  , .e - .lag_max_e , # Case 2: partial extension
      default = 0 # Case 3: nested
    )
  ]

  # 9. Sum contributions per person
  # result <- dt[,
  #   .(tenure_days = sum(.contrib, na.rm = TRUE)),
  #   by = .(personnel_id_val = get(personnel_id_col))
  # ]

  result <- dt[,
    .(tenure_days = sum(.contrib, na.rm = TRUE)),
    by = c(personnel_id_col, group_cols)
  ]

  result[, tenure_years := tenure_days / 365.25]
  # data.table::setnames(result, "personnel_id_val", personnel_id_col)

  result[,
    c(personnel_id_col, group_cols, "tenure_days", "tenure_years"),
    with = FALSE
  ]
}

#' Compute employment tenure from a stacked contract panel
#'
#' Computes cumulative employment tenure for each personnel member at each
#' reference date while avoiding double-counting overlapping contracts.
#' Contracts with type \code{"inactive"} or \code{"pensioner"} are excluded.
#' Open-ended contracts are truncated at the corresponding reference date,
#' after which overlapping contract periods are merged before calculating
#' total tenure.
#'
#' Tenure is calculated independently within each combination of
#' \code{personnel_id}, optional grouping variables supplied through
#' \code{group_cols}, and \code{ref_date}.
#'
#' @param contract_dt data.table containing the stacked contract panel.
#'   Must include personnel identifiers, contract identifiers, contract
#'   start and end dates, reference dates, contract types, and any grouping
#'   variables supplied in \code{group_cols}.
#' @param personnel_id_col Character. Name of the personnel identifier column.
#'   Default is \code{"personnel_id"}.
#' @param ref_date_col Character. Name of the reference date column.
#'   Default is \code{"ref_date"}.
#' @param contract_id_col Character. Name of the contract identifier column.
#'   Default is \code{"contract_id"}.
#' @param start_date_col Character. Name of the contract start date column.
#'   Default is \code{"start_date"}.
#' @param end_date_col Character. Name of the contract end date column.
#'   Default is \code{"end_date"}.
#' @param contract_type_col Character. Name of the contract type column.
#'   Default is \code{"contract_type"}.
#' @param group_cols Optional character vector of additional variables over
#'   which tenure should be calculated independently (for example,
#'   establishment, occupation, or organization). Default is \code{NULL}.
#'
#' @return A data.table with one row per unique combination of
#'   \code{personnel_id}, optional \code{group_cols}, and
#'   \code{ref_date}, containing:
#'   \describe{
#'     \item{tenure_days}{Total employment tenure in days.}
#'     \item{tenure_years}{Total employment tenure in years, calculated as
#'     tenure days divided by 365.25.}
#'   }
#'
#' @keywords internal
compute_tenure_panel <- function(
  contract_dt,
  personnel_id_col = "personnel_id",
  ref_date_col = "ref_date",
  contract_id_col = "contract_id",
  start_date_col = "start_date",
  end_date_col = "end_date",
  contract_type_col = "contract_type",
  group_cols = NULL
) {
  # 0. Quick set up ensuring data.table and to define a grouping key once at the start
  contract_dt <- as.data.table(contract_dt)

  if (is.null(group_cols) == FALSE) {
    validate_columns_exist(dt = contract_dt, colnames = group_cols)
  }

  by_cols <- c(personnel_id_col, group_cols, ref_date_col)

  # 1. Filter: active types only, started on or before each row's ref_date
  dt <- contract_dt[
    get(start_date_col) <= get(ref_date_col) &
      !get(contract_type_col) %in% c("inactive", "pensioner")
  ]

  # 2. Cap open-ended / future contracts at each row's ref_date
  dt[,
    .eff_end := data.table::fifelse(
      is.na(get(end_date_col)) | get(end_date_col) > get(ref_date_col),
      get(ref_date_col),
      get(end_date_col)
    )
  ]

  # 3. Dedup panel snapshots: one row per (contract_id, start_date, ref_date)
  dt <- dt[
    dt[, .I[1L], by = c(contract_id_col, start_date_col, ref_date_col)]$V1
  ]

  # 4. Numeric days for arithmetic; drop zero-length contracts
  dt[, .s := as.numeric(get(start_date_col))]
  dt[, .e := as.numeric(.eff_end)]
  dt <- dt[.e > .s]

  if (nrow(dt) == 0L) {
    empty <- data.table::data.table(
      .pid = character(0),
      .refdt = as.Date(character(0)),
      tenure_years = numeric(0)
    )
    data.table::setnames(
      empty,
      c(".pid", ".refdt"),
      c(personnel_id_col, ref_date_col)
    )
    return(empty)
  }

  # 5. Sort by (person, snapshot, start) then apply cummax within each group
  data.table::setorderv(dt, c(personnel_id_col, ref_date_col, ".s"))
  dt[, .lag_max_e := data.table::shift(cummax(.e), fill = -1e15), by = by_cols]

  # 6. Classify and sum contributions
  dt[,
    .contrib := data.table::fcase(
      .s >= .lag_max_e , .e - .s         ,
      .e > .lag_max_e  , .e - .lag_max_e ,
      default = 0
    )
  ]

  result <- dt[,
    .(
      tenure_years = sum(.contrib, na.rm = TRUE) / 365.25,
      tenure_days = sum(.contrib, na.rm = TRUE)
    ),
    by = by_cols
  ]

  result[,
    c(
      personnel_id_col,
      group_cols,
      ref_date_col,
      "tenure_days",
      "tenure_years"
    ),
    with = FALSE
  ]
}

#' Compute total time spent in each specific group per person (eg paygrade, occupation)
#'
#' @description
#' Derives, for each person and (optionally) each grouping variable such as
#' paygrade, the total cumulative tenure accrued in that state, taken from
#' the most recent panel snapshot at which the person is still observed in
#' that state. Built on top of \code{\link{compute_tenure_panel}}, which
#' computes overlap-safe cumulative tenure at every reference date; this
#' function collapses that panel down to one row per
#' \code{personnel_id}/\code{group_cols} combination by keeping only the
#' latest \code{ref_date} at which the combination appears.
#'
#' @details
#' A \code{group_cols} combination (e.g. \code{paygrade}, or
#' \code{contract_id} + \code{paygrade}) stops appearing in the underlying
#' tenure panel once the person's recorded state changes, so the last
#' \code{ref_date} at which a combination is observed marks the end of that
#' spell. \code{spell_years} is the cumulative tenure value at that final
#' snapshot, summed across any residual duplicate rows for the same
#' combination and date.
#'
#' Two caveats affect interpretation:
#' \itemize{
#'   \item If \code{contract_id} is included in \code{group_cols} and a
#'   person is renewed onto a new contract while remaining on the same
#'   paygrade, this will be treated as two separate spells rather than one
#'   continuous spell, understating true time-in-grade for that person.
#'   \item If a person leaves a given \code{group_cols} state and later
#'   returns to it (e.g. paygrade A -> B -> A) under the same grouping
#'   combination, the two non-contiguous stints are combined into a single
#'   spell, and \code{spell_years} will reflect their combined duration
#'   rather than just the most recent stint.
#' }
#'
#' This function does not distinguish spells that ended because the person
#' transitioned to a new state from spells that are still ongoing as of the
#' last available panel snapshot (right-censored spells); both are treated
#' identically.
#'
#' @param contract_dt data.table. Stacked contract panel, as passed to
#'   \code{\link{compute_tenure_panel}}.
#' @param personnel_id_col Character. Name of the personnel identifier
#'   column. Default is \code{"personnel_id"}.
#' @param ref_date_col Character. Name of the reference date column.
#'   Default is \code{"ref_date"}.
#' @param contract_id_col Character. Name of the contract identifier column.
#'   Default is \code{"contract_id"}.
#' @param start_date_col Character. Name of the contract start date column.
#'   Default is \code{"start_date"}.
#' @param end_date_col Character. Name of the contract end date column.
#'   Default is \code{"end_date"}.
#' @param contract_type_col Character. Name of the contract type column.
#'   Default is \code{"contract_type"}.
#' @param group_cols Optional character vector of additional variables
#'   over which tenure should be calculated independently (for example,
#'   establishment, occupation, or organization). Default is \code{NULL}.
#'
#' @return A data.table with one row per unique combination of
#'   \code{personnel_id} and \code{group_cols}, containing:
#'   \describe{
#'     \item{ref_date}{The last reference date at which the person was
#'     observed in this \code{group_cols} state.}
#'     \item{spell_years}{Total cumulative tenure, in years, accrued in
#'     this state as of that date.}
#'   }
#'
#' @seealso \code{\link{compute_tenure_panel}}
#' @keywords internal
compute_employment_spells <- function(
  contract_dt,
  personnel_id_col = "personnel_id",
  ref_date_col = "ref_date",
  contract_id_col = "contract_id",
  start_date_col = "start_date",
  end_date_col = "end_date",
  contract_type_col = "contract_type",
  group_cols = NULL
) {
  ### first use the compute_tenure_panel function to figure out tenure
  ### at each ref_date
  tenure_dt <-
    compute_tenure_panel(
      contract_dt = contract_dt,
      personnel_id_col = personnel_id_col,
      ref_date_col = ref_date_col,
      contract_id_col = contract_id_col,
      start_date_col = start_date_col,
      end_date_col = end_date_col,
      contract_type_col = contract_type_col,
      group_cols = group_cols
    )

  ### get the tenure at the last snapshot for each group_col personel_id combination
  tenure_dt <-
    tenure_dt[,
      max_date := data.table::fifelse(ref_date == max(ref_date, na.rm = TRUE), 1, 0),
      by = c(personnel_id_col, group_cols)
    ]

  ### keep only the latest dates
  tenure_dt <- tenure_dt[max_date == 1, ]

  ### get total spell for each personnel_id group_cols combination
  spell_dt <- tenure_dt[,
    spell_years := sum(tenure_years, na.rm = TRUE),
    by = c(personnel_id_col, group_cols)
  ]

  return(spell_dt[,
    c(personnel_id_col, group_cols, ref_date_col, "spell_years"),
    with = FALSE
  ])
}
