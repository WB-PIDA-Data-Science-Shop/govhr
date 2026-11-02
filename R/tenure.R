
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
#' @details
#' **Overlaps.** Contracts are sorted by start date, and each counts only the
#' part not already covered by the person's earlier ones (the union of the
#' intervals). This is \eqn{O(n \log n)}, dominated by the sort; the running
#' maximum of earlier end dates is one vectorised pass for data frames and a
#' window function in the database.
#'
#' **A contract seen more than once** (e.g. at several snapshots of a panel)
#' counts once, from its start to its latest recorded end. With
#' \code{group_cols}, a contract seen in several groups (e.g. paygrades)
#' counts in each.
#'
#' **Missing contract types** count as active.
#'
#' @param contracts The contract history, as a data frame or a lazy database
#'   table (`tbl_dbi`). Must include personnel identifiers, contract start
#'   and end dates, contract types, and any grouping variables supplied in
#'   \code{group_cols}.
#' @param ref_date Date. Reference date at which tenure is calculated.
#' @param personnel_id_col Character. Name of the personnel identifier column.
#'   Default is \code{"personnel_id"}.
#' @param contract_id_col Character. Not used: a contract seen more than once
#'   counts once without it. Kept so existing calls still work.
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
#' @param ... Not used.
#'
#' @returns One row per unique combination of \code{personnel_id} and
#'   optional \code{group_cols} (a data.table for a data frame, a lazy table
#'   for a `tbl_dbi`), containing:
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
#'   contracts = contract_data,
#'   ref_date = as.Date("2025-01-01")
#' )
#' }
#'
#' @export
compute_tenure <- function(contracts, ...) {
  UseMethod("compute_tenure")
}

#' @rdname compute_tenure
#' @export
compute_tenure.data.frame <- function(contracts,
                                      ref_date,
                                      personnel_id_col = "personnel_id",
                                      contract_id_col = "contract_id",
                                      start_date_col = "start_date",
                                      end_date_col = "end_date",
                                      contract_type_col = "contract_type",
                                      group_cols = NULL,
                                      ...) {
  rlang::check_dots_empty()
  keys <- c(personnel_id_col, group_cols)
  .check_tenure_args(contracts, c(keys, start_date_col, end_date_col, contract_type_col))

  .tenure_days(
    contracts, keys, as.Date(ref_date),
    start_date_col, end_date_col, contract_type_col
  )
}

#' @rdname compute_tenure
#' @export
compute_tenure.tbl_dbi <- function(contracts,
                                   ref_date,
                                   personnel_id_col = "personnel_id",
                                   contract_id_col = "contract_id",
                                   start_date_col = "start_date",
                                   end_date_col = "end_date",
                                   contract_type_col = "contract_type",
                                   group_cols = NULL,
                                   ...) {
  rlang::check_dots_empty()
  keys <- c(personnel_id_col, group_cols)
  .check_tenure_args(contracts, c(keys, start_date_col, end_date_col, contract_type_col))

  ### the date as a typed SQL literal, so it compares and mixes with date
  ### columns as a date
  ref <- dplyr::sql(paste0("CAST('", format(as.Date(ref_date)), "' AS DATE)"))
  .tenure_days_db(contracts, keys, ref, start_date_col, end_date_col, contract_type_col)
}

#' @rdname compute_tenure
#' @export
compute_tenure.default <- function(contracts, ...) {
  stop_unsupported_data(contracts, "contracts")
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
#' \code{group_cols}, and \code{ref_date}, from the contracts listed at that
#' reference date.
#'
#' @details
#' As in [compute_tenure()], each snapshot's contracts count only the part
#' not already covered by the person's earlier-starting ones, a contract
#' listed twice in a snapshot counts once (to its latest end), and missing
#' contract types count as active.
#'
#' @inheritParams compute_tenure
#' @param contracts The stacked contract panel, as a data frame or a lazy
#'   database table (`tbl_dbi`). Must include personnel identifiers, contract
#'   start and end dates, reference dates, contract types, and any grouping
#'   variables supplied in \code{group_cols}.
#' @param ref_date_col Character. Name of the reference date column.
#'   Default is \code{"ref_date"}.
#'
#' @returns One row per unique combination of \code{personnel_id}, optional
#'   \code{group_cols}, and \code{ref_date} (a data.table for a data frame, a
#'   lazy table for a `tbl_dbi`), containing:
#'   \describe{
#'     \item{tenure_days}{Total employment tenure in days.}
#'     \item{tenure_years}{Total employment tenure in years, calculated as
#'     tenure days divided by 365.25.}
#'   }
#'
#' @export
compute_tenure_panel <- function(contracts, ...) {
  UseMethod("compute_tenure_panel")
}

#' @rdname compute_tenure_panel
#' @export
compute_tenure_panel.data.frame <- function(contracts,
                                            personnel_id_col = "personnel_id",
                                            ref_date_col = "ref_date",
                                            contract_id_col = "contract_id",
                                            start_date_col = "start_date",
                                            end_date_col = "end_date",
                                            contract_type_col = "contract_type",
                                            group_cols = NULL,
                                            ...) {
  rlang::check_dots_empty()
  keys <- c(personnel_id_col, group_cols, ref_date_col)
  .check_tenure_args(contracts, c(keys, start_date_col, end_date_col, contract_type_col))

  .tenure_days(
    contracts, keys, contracts[[ref_date_col]],
    start_date_col, end_date_col, contract_type_col
  )
}

#' @rdname compute_tenure_panel
#' @export
compute_tenure_panel.tbl_dbi <- function(contracts,
                                         personnel_id_col = "personnel_id",
                                         ref_date_col = "ref_date",
                                         contract_id_col = "contract_id",
                                         start_date_col = "start_date",
                                         end_date_col = "end_date",
                                         contract_type_col = "contract_type",
                                         group_cols = NULL,
                                         ...) {
  rlang::check_dots_empty()
  keys <- c(personnel_id_col, group_cols, ref_date_col)
  .check_tenure_args(contracts, c(keys, start_date_col, end_date_col, contract_type_col))

  .tenure_days_db(
    contracts, keys, rlang::sym(ref_date_col),
    start_date_col, end_date_col, contract_type_col
  )
}

#' @rdname compute_tenure_panel
#' @export
compute_tenure_panel.default <- function(contracts, ...) {
  stop_unsupported_data(contracts, "contracts")
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
#' snapshot.
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
#' @inheritParams compute_tenure_panel
#' @param contracts The stacked contract panel, as passed to
#'   \code{\link{compute_tenure_panel}}: a data frame or a lazy database
#'   table (`tbl_dbi`).
#'
#' @returns One row per unique combination of \code{personnel_id} and
#'   \code{group_cols} (a data.table for a data frame, a lazy table for a
#'   `tbl_dbi`), containing:
#'   \describe{
#'     \item{ref_date}{The last reference date at which the person was
#'     observed in this \code{group_cols} state.}
#'     \item{spell_years}{Total cumulative tenure, in years, accrued in
#'     this state as of that date.}
#'   }
#'
#' @seealso \code{\link{compute_tenure_panel}}
#' @keywords internal
#' @export
compute_employment_spells <- function(contracts, ...) {
  UseMethod("compute_employment_spells")
}

#' @rdname compute_employment_spells
#' @export
compute_employment_spells.data.frame <- function(contracts,
                                                 personnel_id_col = "personnel_id",
                                                 ref_date_col = "ref_date",
                                                 contract_id_col = "contract_id",
                                                 start_date_col = "start_date",
                                                 end_date_col = "end_date",
                                                 contract_type_col = "contract_type",
                                                 group_cols = NULL,
                                                 ...) {
  rlang::check_dots_empty()
  tenure_dt <- compute_tenure_panel(
    contracts,
    personnel_id_col = personnel_id_col,
    ref_date_col = ref_date_col,
    start_date_col = start_date_col,
    end_date_col = end_date_col,
    contract_type_col = contract_type_col,
    group_cols = group_cols
  )

  ### the panel is sorted by person, group and date, so each person and
  ### group's last snapshot is its last row
  spells <- unique(tenure_dt, by = c(personnel_id_col, group_cols), fromLast = TRUE)
  data.table::setnames(spells, "tenure_years", "spell_years")
  spells[, c(personnel_id_col, group_cols, ref_date_col, "spell_years"), with = FALSE]
}

#' @rdname compute_employment_spells
#' @importFrom dplyr all_of filter group_by select ungroup
#' @importFrom rlang .data
#' @export
compute_employment_spells.tbl_dbi <- function(contracts,
                                              personnel_id_col = "personnel_id",
                                              ref_date_col = "ref_date",
                                              contract_id_col = "contract_id",
                                              start_date_col = "start_date",
                                              end_date_col = "end_date",
                                              contract_type_col = "contract_type",
                                              group_cols = NULL,
                                              ...) {
  rlang::check_dots_empty()
  compute_tenure_panel(
    contracts,
    personnel_id_col = personnel_id_col,
    ref_date_col = ref_date_col,
    start_date_col = start_date_col,
    end_date_col = end_date_col,
    contract_type_col = contract_type_col,
    group_cols = group_cols
  ) |>
    ### each person and group's last snapshot: the latest date over the whole
    ### group (an explicit order and a frame covering every row)
    group_by(dplyr::across(all_of(c(personnel_id_col, group_cols)))) |>
    dbplyr::window_order(.data[[ref_date_col]]) |>
    dbplyr::window_frame(-Inf, Inf) |>
    filter(.data[[ref_date_col]] == max(.data[[ref_date_col]], na.rm = TRUE)) |>
    ungroup() |>
    select(all_of(c(personnel_id_col, group_cols, ref_date_col)), spell_years = "tenure_years")
}

#' @rdname compute_employment_spells
#' @export
compute_employment_spells.default <- function(contracts, ...) {
  stop_unsupported_data(contracts, "contracts")
}
