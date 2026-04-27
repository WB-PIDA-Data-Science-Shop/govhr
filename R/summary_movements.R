#' Calculate Tenure from Contract History
#'
#' @description
#' Computes total years of service for each personnel as of a reference date
#' using a vectorised interval-union algorithm based on \code{cummax()}.
#' Overlapping and nested contracts are correctly de-duplicated; gaps between
#' contracts are excluded from the total.
#'
#' The algorithm sorts each person's contracts by start date, then propagates
#' the "furthest right endpoint seen so far" with \code{cummax()}.  Three
#' cases cover all interval relationships:
#' \itemize{
#'   \item \strong{Case 1} (new span): start > lag_cummax → contributes \code{end - start}
#'   \item \strong{Case 2} (extension): end > lag_cummax ≥ start → contributes \code{end - lag_cummax}
#'   \item \strong{Case 3} (nested): end ≤ lag_cummax → contributes 0
#' }
#'
#' @param contract_dt data.table. Contract data (may contain panel observations)
#' @param ref_date Date. Reference date for tenure calculation
#' @param personnel_id_col Character. Name of personnel ID column (default: "personnel_id")
#' @param contract_id_col Character. Name of contract ID column (default: "contract_id")
#' @param start_date_col Character. Name of start date column (default: "start_date")
#' @param end_date_col Character. Name of end date column (default: "end_date")
#' @param contract_type_col Character. Name of contract type column (default: "contract_type_code")
#'
#' @return data.table with personnel_id, tenure_days, and tenure_years columns
#' @keywords internal
#'
#' @examples
#' \dontrun{
#' tenure_dt <- compute_tenure(
#'   contract_dt = contract_data,
#'   ref_date = as.Date("2025-01-01")
#' )
#' }
compute_tenure <- function(contract_dt,
                           ref_date,
                           personnel_id_col = "personnel_id",
                           contract_id_col = "contract_id",
                           start_date_col = "start_date",
                           end_date_col = "end_date",
                           contract_type_col = "contract_type_code") {
  
  ### ensure the contract dataset is a data.table
  contract_dt <- as.data.table(contract_dt)

  # Alias ref_date to a name that cannot be shadowed by a column named 'ref_date'
  # in panel data.tables (data.table resolves column names before env variables).
  # Coerce to Date so fifelse() type-matches Date columns (dates are stored as
  # doubles internally; character input causes a type mismatch error).
  .ref_date_ <- as.Date(ref_date)

  # 1. Filter inactive types — subset returns a new object, no copy() needed
  dt <- contract_dt[!get(contract_type_col) %in% c("inactive", "pensioner")]

  # 2. Keep only contracts that started on or before ref_date
  dt <- dt[get(start_date_col) <= .ref_date_]

  # 3. Cap open-ended / future contracts at ref_date
  dt[, .eff_end := data.table::fifelse(
    is.na(get(end_date_col)) | get(end_date_col) > .ref_date_,
    .ref_date_,
    get(end_date_col)
  )]

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
      tenure_days  = numeric(0),
      tenure_years = numeric(0)
    )
    data.table::setnames(empty, "personnel_id", personnel_id_col)
    return(empty[, c(personnel_id_col, "tenure_days", "tenure_years"), with = FALSE])
  }

  # 6. Sort by person then start — O(n log n)
  data.table::setorderv(dt, c(personnel_id_col, ".s"))

  # 7. Lagged cummax of end-dates within each person.
  #    fill = -1e15 (a numeric constant far outside any real date range) ensures
  #    the first interval per person is always classified as a new span without
  #    triggering integer overflow.
  dt[, .lag_max_e := data.table::shift(cummax(.e), fill = -1e15),
     by = c(personnel_id_col)]

  # 8. Classify each interval and compute its contribution to the union
  #    >= in Case 1: adjacent intervals (end_prev == start_curr) are new spans,
  #    not extensions and not nested.
  dt[, .contrib := data.table::fcase(
    .s >= .lag_max_e,  .e - .s,          # Case 1: new span (or exact-boundary adjacent)
    .e >  .lag_max_e,  .e - .lag_max_e,  # Case 2: partial extension
    default = 0                           # Case 3: nested
  )]

  # 9. Sum contributions per person
  result <- dt[,
    .(tenure_days = sum(.contrib, na.rm = TRUE)),
    by = .(personnel_id_val = get(personnel_id_col))
  ]
  result[, tenure_years := tenure_days / 365.25]
  data.table::setnames(result, "personnel_id_val", personnel_id_col)

  result[, c(personnel_id_col, "tenure_days", "tenure_years"), with = FALSE]
}



# ---------------------------------------------------------------------------
# Internal: process one consecutive snapshot pair for the movement baseline.
# Called by roll_snapshot_pairs() inside estimate_movement_baseline().
#
# @param snap_t0  data.table subset at time T0 (one snapshot).
# @param snap_t1  data.table subset at time T1 (next snapshot).
# @param group_cols,personnel_id_col,start_date_col,end_date_col,
#        contract_type_col  Same semantics as estimate_movement_baseline().
#
# @return data.table with columns from_group, to_group, n_moves, n_pop,
#         period_prob, t0_date, t1_date; or NULL when either snapshot is empty.
#' @keywords internal
.compute_transition_pair <- function(snap_t0,
                                     snap_t1,
                                     ref_date_col,
                                     group_cols,
                                     personnel_id_col,
                                     start_date_col,
                                     end_date_col,
                                     contract_type_col) {

  # Read snapshot dates from the known date column (passed explicitly so we
  # are robust to panels that contain multiple Date-class columns).
  t0_date <- snap_t0[[ref_date_col]][1L]
  t1_date <- snap_t1[[ref_date_col]][1L]

  # Active persons at T0
  active_t0 <- snap_t0[
    get(start_date_col) <= t0_date &
      (is.na(get(end_date_col)) | get(end_date_col) >= t0_date) &
      get(contract_type_col) != "inactive"
  ]

  if (nrow(active_t0) == 0L) return(NULL)

  state_t0 <- unique(active_t0[, c(personnel_id_col, group_cols), with = FALSE])
  state_t0 <- stats::na.omit(state_t0, cols = group_cols)
  state_t0[, from_group := do.call(paste, c(.SD, sep = "||")), .SDcols = group_cols]
  data.table::setnames(state_t0, personnel_id_col, ".pid")

  # Active persons at T1
  active_t1 <- snap_t1[
    get(start_date_col) <= t1_date &
      (is.na(get(end_date_col)) | get(end_date_col) >= t1_date) &
      get(contract_type_col) != "inactive"
  ]

  if (nrow(active_t1) == 0L) return(NULL)

  state_t1 <- unique(active_t1[, c(personnel_id_col, group_cols), with = FALSE])
  state_t1 <- stats::na.omit(state_t1, cols = group_cols)
  state_t1[, to_group := do.call(paste, c(.SD, sep = "||")), .SDcols = group_cols]
  data.table::setnames(state_t1, personnel_id_col, ".pid")

  # Persons present at both snapshots
  transitions <- state_t0[state_t1[, .(.pid, to_group)], on = ".pid", nomatch = NULL]

  if (nrow(transitions) == 0L) return(NULL)

  movement_counts <- transitions[, .(n_moves = .N), by = .(from_group, to_group)]
  pop_t0          <- state_t0[, .(n_pop = .N), by = from_group]

  period_trans <- movement_counts[pop_t0, on = "from_group", nomatch = NA]
  period_trans[is.na(n_moves), n_moves := 0L]
  period_trans[, period_prob := n_moves / n_pop]
  period_trans[, t0_date     := t0_date]
  period_trans[, t1_date     := t1_date]

  period_trans
}


#' Estimate Movement Baseline from Panel Data
#'
#' @description
#' Analyzes longitudinal panel data to compute empirical transition probabilities
#' for promotions and transfers. Compares consecutive snapshots (T0->T1, T1->T2,
#' etc.) and returns one row per \code{(from_group, to_group, from_period, to_period)}
#' pair. Only actual transitions (\code{from_group != to_group}) are returned;
#' stay rows and rows with NA in any group_col are dropped.
#'
#' To obtain a single averaged rate across all periods, aggregate the result:
#' \code{result[, .(movement_rate = mean(movement_rate)), by = .(from_group, to_group)]}
#'
#' @param contract_dt data.table. Contract data in long (panel) format.
#'   Must contain ref_date_col for panel identification.
#' @param group_cols Character vector. Columns defining movement states
#'   (e.g., c("est_id", "paygrade") or c("paygrade"))
#' @param personnel_id_col Character. Personnel ID column (default: "personnel_id")
#' @param ref_date_col Character. Reference date column (default: "ref_date")
#' @param start_date_col Character. Contract start date column (default: "start_date")
#' @param end_date_col Character. Contract end date column (default: "end_date")
#' @param contract_type_col Character. Contract type column (default: "contract_type_code")
#'
#' @return data.table with columns:
#'   \describe{
#'     \item{from_group}{Character. State at period start (concatenated group_cols)}
#'     \item{to_group}{Character. State at period end (concatenated group_cols)}
#'     \item{movement_rate}{Numeric. Transition probability for this specific period pair}
#'     \item{from_period}{Date. Start snapshot date (T0)}
#'     \item{to_period}{Date. End snapshot date (T1)}
#'     \item{n_pop}{Integer. Number of persons in from_group at T0}
#'     \item{n_moves}{Integer. Number of persons who moved from from_group to to_group}
#'   }
#' @keywords internal
estimate_movement_baseline <- function(contract_dt,
                                       group_cols,
                                       personnel_id_col = "personnel_id",
                                       ref_date_col = "ref_date",
                                       start_date_col = "start_date",
                                       end_date_col = "end_date",
                                       contract_type_col = "contract_type_code") {

  # Validate inputs
  if (!data.table::is.data.table(contract_dt)) {
    stop("contract_dt must be a data.table", call. = FALSE)
  }
  if (is.null(group_cols) || length(group_cols) == 0) {
    stop("group_cols must be specified for movement baseline estimation", call. = FALSE)
  }

  missing_cols <- setdiff(c(ref_date_col, personnel_id_col, group_cols,
                             start_date_col, end_date_col, contract_type_col),
                          names(contract_dt))
  if (length(missing_cols) > 0) {
    stop("Columns not found in contract_dt: ", paste(missing_cols, collapse = ", "),
         call. = FALSE)
  }

  # Get sorted unique reference dates
  all_dates <- sort(unique(contract_dt[[ref_date_col]]))
  all_dates <- all_dates[!is.na(all_dates)]

  if (length(all_dates) < 2) {
    stop("At least 2 panel snapshots required to estimate movement baseline. ",
         "Found ", length(all_dates), " snapshot(s).", call. = FALSE)
  }

  # For each consecutive pair of snapshots, compute transition counts.
  # roll_snapshot_pairs() sets setkeyv(contract_dt, ref_date_col) before
  # iterating — converting full O(N_total) scans into O(log N) binary
  # lookups per snapshot, which is the dominant cost at scale.
  all_periods <- roll_snapshot_pairs(
    panel_dt = contract_dt,
    date_col = ref_date_col,
    f        = .compute_transition_pair,
    # extra args forwarded to .compute_transition_pair:
    ref_date_col      = ref_date_col,
    group_cols        = group_cols,
    personnel_id_col  = personnel_id_col,
    start_date_col    = start_date_col,
    end_date_col      = end_date_col,
    contract_type_col = contract_type_col
  )
  # Attach a period index so we can count distinct periods later.
  if (nrow(all_periods) > 0L)
    all_periods[, period_key := .GRP, by = .(t0_date)]

  if (nrow(all_periods) == 0) {
    return(data.table::data.table(
      from_group    = character(0),
      to_group      = character(0),
      movement_rate = numeric(0),
      from_period   = as.Date(character(0)),
      to_period     = as.Date(character(0)),
      n_pop         = integer(0),
      n_moves       = integer(0)
    ))
  }

  # Rename to output schema: one row per (from_group, to_group, from_period, to_period)
  data.table::setnames(all_periods, c("t0_date", "t1_date", "period_prob"),
                                    c("from_period", "to_period", "movement_rate"))

  baseline_matrix <- all_periods[, .(from_group, to_group, movement_rate,
                                     from_period, to_period, n_pop, n_moves)]

  # Drop stay rows (from_group == to_group): we only want actual transitions
  baseline_matrix <- baseline_matrix[from_group != to_group]

  # Drop any rows where from_group or to_group encodes an NA value ("NA" string
  # or literal NA) — these arise when group_cols contains NAs in the data
  baseline_matrix <- baseline_matrix[
    !is.na(from_group) & !is.na(to_group) &
    from_group != "NA"  & to_group  != "NA"
  ]

  data.table::setkeyv(baseline_matrix, c("from_group", "to_group", "from_period", "to_period"))
  return(baseline_matrix)
}



#' Iterate Consecutive Snapshot Pairs in a Panel data.table
#'
#' @description
#' Sets a data.table key on \code{date_col} (enabling O(log N) binary-search
#' subsetting rather than O(N) full-table scans), then calls a user-supplied
#' function \code{f(snap_a, snap_b, ...)} for every consecutive pair of
#' distinct dates in the panel.  Results are collected and returned as a
#' single \code{data.table} via \code{rbindlist}.
#'
#' This helper enforces the key-setting pattern for all callers that need to
#' walk a longitudinal panel snapshot by snapshot.  At scale (50 M rows, 15
#' annual snapshots) the difference between an unkeyed and a keyed scan is
#' roughly 5–10×.
#'
#' @param panel_dt data.table.  Panel data containing all snapshots.  The key
#'   is set/updated in-place on entry; pass \code{data.table::copy()} if the
#'   caller must preserve the original key.
#' @param date_col Character scalar.  Name of the date column that identifies
#'   snapshots (e.g. \code{"ref_date"}).  \code{NA} values are silently dropped
#'   before iteration.
#' @param f Function.  Called as \code{f(snap_a, snap_b, ...)} where
#'   \code{snap_a} and \code{snap_b} are the T0 and T1 subsets respectively.
#'   Must return a \code{data.table} or \code{NULL}; \code{NULL} rows are
#'   skipped.
#' @param ... Additional arguments forwarded to \code{f} unchanged.
#'
#' @return A single \code{data.table} produced by
#'   \code{rbindlist(results, fill = TRUE, use.names = TRUE)} over all
#'   non-\code{NULL} results.  Returns an empty \code{data.table()} when all
#'   calls return \code{NULL} or the panel has fewer than two distinct dates.
#'
#' @examples
#' \dontrun{
#' library(data.table)
#' panel <- data.table(
#'   ref_date     = as.Date(c("2015-01-01","2015-01-01","2016-01-01","2016-01-01")),
#'   personnel_id = c("P1", "P2", "P1", "P2"),
#'   paygrade     = c("G1", "G2", "G2", "G2")
#' )
#'
#' count_movers <- function(a, b) {
#'   data.table(n_persons_t0 = nrow(a), n_persons_t1 = nrow(b))
#' }
#'
#' roll_snapshot_pairs(panel, date_col = "ref_date", f = count_movers)
#' }
#'
#' @keywords internal
roll_snapshot_pairs <- function(panel_dt, date_col, f, ...) {

  if (!data.table::is.data.table(panel_dt))
    stop("panel_dt must be a data.table.", call. = FALSE)

  if (!is.character(date_col) || length(date_col) != 1L)
    stop("date_col must be a single character string.", call. = FALSE)

  if (!date_col %in% names(panel_dt))
    stop("date_col '", date_col, "' not found in panel_dt.", call. = FALSE)

  # Set key for binary-search subsetting — this is the core performance lever.
  # Only re-key if needed to avoid unnecessary copies of the index.
  cur_key <- data.table::key(panel_dt)
  if (is.null(cur_key) || cur_key[1L] != date_col)
    data.table::setkeyv(panel_dt, date_col)

  all_dates <- sort(unique(panel_dt[[date_col]]))
  all_dates  <- all_dates[!is.na(all_dates)]

  if (length(all_dates) < 2L) {
    return(data.table::data.table())
  }

  n_pairs  <- length(all_dates) - 1L
  results  <- vector("list", n_pairs)

  for (k in seq_len(n_pairs)) {
    snap_a <- panel_dt[.(all_dates[k])]
    snap_b <- panel_dt[.(all_dates[k + 1L])]
    res_k  <- f(snap_a, snap_b, ...)
    if (!is.null(res_k)) results[[k]] <- res_k
  }

  non_null <- Filter(Negate(is.null), results)
  if (length(non_null) == 0L) return(data.table::data.table())

  data.table::rbindlist(non_null, fill = TRUE, use.names = TRUE)
}