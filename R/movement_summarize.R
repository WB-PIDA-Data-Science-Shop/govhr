
#' Estimate Movement Baseline from Panel Data
#'
#' @description
#' Analyzes longitudinal panel data to compute empirical transition probabilities
#' for promotions and transfers. Compares consecutive snapshots (T0 -> T1,
#' T1 -> T2, etc.) using \code{roll_snapshot_pairs()} and
#' \code{.compute_transition_pair()}, and returns one row per
#' \code{(from_group, to_group, from_period, to_period)} pair.
#'
#' Only actual transitions (\code{from_group != to_group}) are returned; stay
#' rows and rows where any \code{group_cols} value is \code{NA} (or the string
#' \code{"NA"}) are dropped.
#'
#' To obtain a single averaged rate across all periods, aggregate the result:
#' \preformatted{
#' result[, .(movement_rate = mean(movement_rate)), by = .(from_group, to_group)]
#' }
#'
#' @param contract_dt data.table. Contract data in long (panel) format.
#'   Must contain \code{ref_date_col} for panel snapshot identification.
#' @param group_cols Character vector. One or more columns defining the movement
#'   states between which transitions are measured
#'   (e.g., \code{c("est_id", "paygrade")} or \code{c("paygrade")}). Values
#'   are concatenated into a single state label when multiple columns are
#'   provided.
#' @param personnel_id_col Character. Name of the personnel identifier column.
#'   Default: \code{"personnel_id"}.
#' @param ref_date_col Character. Name of the reference (snapshot) date column
#'   used to identify panel periods. Default: \code{"ref_date"}.
#' @param start_date_col Character. Name of the contract start date column.
#'   Default: \code{"start_date"}.
#' @param end_date_col Character. Name of the contract end date column.
#'   Default: \code{"end_date"}.
#' @param contract_type_col Character. Name of the contract type column.
#'   Default: \code{"contract_type"}.
#' @param salary_col Character or \code{NULL}. Name of a compensation column in
#'   \code{contract_dt}. When provided, salary summary columns are appended to
#'   the output (see Value). Default: \code{NULL}.
#'
#' @return A \code{data.table} with one row per
#'   \code{(from_group, to_group, from_period, to_period)} transition pair,
#'   keyed on those four columns. Returns an empty \code{data.table} with the
#'   same schema if no valid transitions are found. Columns:
#'   \describe{
#'     \item{from_group}{Character. Concatenated \code{group_cols} state at the
#'       start of the period (T0).}
#'     \item{to_group}{Character. Concatenated \code{group_cols} state at the
#'       end of the period (T1).}
#'     \item{movement_rate}{Numeric. Empirical transition probability for this
#'       specific period pair: \eqn{n\_moves / n\_pop}.}
#'     \item{from_period}{Date. Snapshot date at the start of the period (T0).}
#'     \item{to_period}{Date. Snapshot date at the end of the period (T1).}
#'     \item{n_pop}{Integer. Number of persons in \code{from_group} at T0.}
#'     \item{n_moves}{Integer. Number of persons who moved from
#'       \code{from_group} to \code{to_group} between T0 and T1.}
#'   }
#'   When \code{salary_col} is not \code{NULL}, five additional columns are
#'   appended:
#'   \describe{
#'     \item{mean_salary_t0}{Numeric. Mean salary in \code{from_group} at T0.}
#'     \item{mean_salary_t1}{Numeric. Mean salary in \code{to_group} at T1.}
#'     \item{mean_salary_change}{Numeric. Absolute change in mean salary
#'       (T1 minus T0).}
#'     \item{median_salary_change}{Numeric. Median absolute salary change across
#'       movers.}
#'     \item{mean_salary_pct_change}{Numeric. Mean percentage salary change
#'       across movers.}
#'   }
#'
#' @keywords internal
estimate_movement_rates <- function(
  contract_dt,
  group_cols,
  personnel_id_col = "personnel_id",
  ref_date_col = "ref_date",
  start_date_col = "start_date",
  end_date_col = "end_date",
  contract_type_col = "contract_type",
  salary_col = NULL
) {
  # Validate inputs
  if (!data.table::is.data.table(contract_dt)) {
    stop("contract_dt must be a data.table", call. = FALSE)
  }
  if (is.null(group_cols) || length(group_cols) == 0) {
    stop(
      "group_cols must be specified for movement baseline estimation",
      call. = FALSE
    )
  }

  missing_cols <- setdiff(
    c(
      ref_date_col,
      personnel_id_col,
      group_cols,
      start_date_col,
      end_date_col,
      contract_type_col
    ),
    names(contract_dt)
  )
  if (length(missing_cols) > 0) {
    stop(
      "Columns not found in contract_dt: ",
      paste(missing_cols, collapse = ", "),
      call. = FALSE
    )
  }

  # Get sorted unique reference dates
  all_dates <- sort(unique(contract_dt[[ref_date_col]]))
  all_dates <- all_dates[!is.na(all_dates)]

  if (length(all_dates) < 2) {
    stop(
      "At least 2 panel snapshots required to estimate movement baseline. ",
      "Found ",
      length(all_dates),
      " snapshot(s).",
      call. = FALSE
    )
  }

  # For each consecutive pair of snapshots, compute transition counts.
  # roll_snapshot_pairs() sets setkeyv(contract_dt, ref_date_col) before
  # iterating — converting full O(N_total) scans into O(log N) binary
  # lookups per snapshot, which is the dominant cost at scale.
  all_periods <- roll_snapshot_pairs(
    panel_dt = contract_dt,
    date_col = ref_date_col,
    f = .compute_transition_pair,
    # extra args forwarded to .compute_transition_pair:
    ref_date_col = ref_date_col,
    group_cols = group_cols,
    personnel_id_col = personnel_id_col,
    start_date_col = start_date_col,
    end_date_col = end_date_col,
    contract_type_col = contract_type_col,
    salary_col = salary_col
  )
  # Attach a period index so we can count distinct periods later.
  if (nrow(all_periods) > 0L) {
    all_periods[, period_key := .GRP, by = .(t0_date)]
  }

  if (nrow(all_periods) == 0) {
    return(data.table::data.table(
      from_group = character(0),
      to_group = character(0),
      movement_rate = numeric(0),
      from_period = as.Date(character(0)),
      to_period = as.Date(character(0)),
      n_pop = integer(0),
      n_moves = integer(0)
    ))
  }

  # Rename to output schema: one row per (from_group, to_group, from_period, to_period)
  data.table::setnames(
    all_periods,
    c("t0_date", "t1_date", "period_prob"),
    c("from_period", "to_period", "movement_rate")
  )

  baseline_matrix <- all_periods[, .(
    from_group,
    to_group,
    movement_rate,
    from_period,
    to_period,
    n_pop,
    n_moves
  )]

  if (!is.null(salary_col)) {
    baseline_matrix <- all_periods[, .(
      from_group,
      to_group,
      movement_rate,
      from_period,
      to_period,
      n_pop,
      n_moves,
      mean_salary_t0,
      mean_salary_t1,
      mean_salary_change,
      median_salary_change,
      mean_salary_pct_change
    )]
  }

  # Drop stay rows (from_group == to_group): we only want actual transitions
  baseline_matrix <- baseline_matrix[from_group != to_group]

  # Drop any rows where from_group or to_group encodes an NA value ("NA" string
  # or literal NA) — these arise when group_cols contains NAs in the data
  baseline_matrix <- baseline_matrix[
    !is.na(from_group) &
      !is.na(to_group) &
      from_group != "NA" &
      to_group != "NA"
  ]

  data.table::setkeyv(
    baseline_matrix,
    c("from_group", "to_group", "from_period", "to_period")
  )
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
  if (!data.table::is.data.table(panel_dt)) {
    stop("panel_dt must be a data.table.", call. = FALSE)
  }

  if (!is.character(date_col) || length(date_col) != 1L) {
    stop("date_col must be a single character string.", call. = FALSE)
  }

  if (!date_col %in% names(panel_dt)) {
    stop("date_col '", date_col, "' not found in panel_dt.", call. = FALSE)
  }

  # Set key for binary-search subsetting — this is the core performance lever.
  # Only re-key if needed to avoid unnecessary copies of the index.
  cur_key <- data.table::key(panel_dt)
  if (is.null(cur_key) || cur_key[1L] != date_col) {
    data.table::setkeyv(panel_dt, date_col)
  }

  all_dates <- sort(unique(panel_dt[[date_col]]))
  all_dates <- all_dates[!is.na(all_dates)]

  if (length(all_dates) < 2L) {
    return(data.table::data.table())
  }

  n_pairs <- length(all_dates) - 1L
  results <- vector("list", n_pairs)

  for (k in seq_len(n_pairs)) {
    snap_a <- panel_dt[.(all_dates[k])]
    snap_b <- panel_dt[.(all_dates[k + 1L])]
    res_k <- f(snap_a, snap_b, ...)
    if (!is.null(res_k)) results[[k]] <- res_k
  }

  non_null <- Filter(Negate(is.null), results)
  if (length(non_null) == 0L) {
    return(data.table::data.table())
  }

  data.table::rbindlist(non_null, fill = TRUE, use.names = TRUE)
}

# helpers ----------------------------------------------------------------


#' Compute Transition Counts for a Single Consecutive Snapshot Pair
#'
#' @description
#' Internal workhorse called by \code{roll_snapshot_pairs()} inside
#' \code{estimate_movement_rates()}. Given two consecutive panel snapshots
#' (\code{snap_t0} at T0 and \code{snap_t1} at T1), this function:
#'
#' \enumerate{
#'   \item Filters each snapshot to \emph{active} contracts, defined as records
#'         where \code{start_date_col <= ref_date}, \code{end_date_col} >= \code{ref_date}
#'         (or \code{end_date} is \code{NA}), and \code{contract_type_col != "inactive"}.
#'   \item Constructs a state label per person at T0 (\code{from_group}) and T1
#'         (\code{to_group}) by concatenating \code{group_cols} values with
#'         \code{"||"} as separator. When \code{salary_col} is supplied, salary
#'         is first summed within each person-group combination via
#'         \code{compute_fastsummary()} to handle multi-contract persons before
#'         state labels are formed.
#'   \item Joins T0 and T1 states on person ID (inner join), so persons who
#'         exit between T0 and T1 are excluded from transition counts.
#'   \item Counts transitions per \code{(from_group, to_group)} pair and
#'         divides by the T0 population in \code{from_group} to obtain a
#'         period-specific transition probability. Groups with zero movers are
#'         retained with \code{n_moves = 0L}.
#'   \item When \code{salary_col} is supplied, computes salary summary
#'         statistics \emph{over movers only} (persons who appear in both
#'         snapshots), not over the full T0 population.
#' }
#'
#' @param snap_t0 data.table. Subset of the full panel at snapshot T0, already
#'   filtered to a single reference date. Must contain \code{ref_date_col},
#'   \code{personnel_id_col}, \code{group_cols}, \code{start_date_col},
#'   \code{end_date_col}, and \code{contract_type_col}.
#' @param snap_t1 data.table. Subset of the full panel at snapshot T1 (the
#'   period immediately following T0). Same column requirements as
#'   \code{snap_t0}.
#' @param ref_date_col Character. Name of the reference date column used to
#'   extract T0 and T1 dates from the snapshots.
#' @param group_cols Character vector. Columns whose concatenated values define
#'   the movement state for each person. Rows with \code{NA} in any of these
#'   columns are dropped via \code{na.omit()} before state labels are formed.
#' @param personnel_id_col Character. Name of the personnel identifier column.
#'   Internally renamed to \code{".pid"} during processing.
#' @param start_date_col Character. Name of the contract start date column,
#'   used in the active-contract filter.
#' @param end_date_col Character. Name of the contract end date column,
#'   used in the active-contract filter. \code{NA} values are treated as open-ended
#'   contracts (i.e., still active at the snapshot date).
#' @param contract_type_col Character. Name of the contract type column. Records
#'   with value \code{"inactive"} are excluded from both snapshots.
#' @param salary_col Character or \code{NULL}. Name of a compensation column.
#'   When provided, salary is summed per person-group via
#'   \code{compute_fastsummary(fns = "sum")} before state construction, and
#'   salary summary columns are appended to the output. Default: \code{NULL}.
#'
#' @return A \code{data.table} with one row per \code{(from_group, to_group)}
#'   pair observed in this period, or \code{NULL} if either snapshot contains
#'   no active contracts after filtering. Columns:
#'   \describe{
#'     \item{from_group}{Character. Concatenated \code{group_cols} state at T0.}
#'     \item{to_group}{Character. Concatenated \code{group_cols} state at T1.
#'       \code{NA} for T0 groups where no movers were observed (these rows
#'       carry \code{n_moves = 0L} and are filtered downstream).}
#'     \item{n_moves}{Integer. Number of persons who moved from
#'       \code{from_group} to \code{to_group} between T0 and T1. Set to
#'       \code{0L} for T0 groups with no observed movers.}
#'     \item{n_pop}{Integer. Number of active persons in \code{from_group}
#'       at T0 (the denominator for \code{period_prob}).}
#'     \item{period_prob}{Numeric. Transition probability for this pair in
#'       this period: \eqn{n\_moves / n\_pop}.}
#'     \item{t0_date}{Date. Reference date of the T0 snapshot.}
#'     \item{t1_date}{Date. Reference date of the T1 snapshot.}
#'   }
#'   When \code{salary_col} is not \code{NULL}, the following columns are
#'   prepended (computed over movers only, i.e., persons present in both
#'   snapshots):
#'   \describe{
#'     \item{mean_salary_t0}{Numeric. Mean of per-person salary sums in
#'       \code{from_group} at T0.}
#'     \item{mean_salary_t1}{Numeric. Mean of per-person salary sums in
#'       \code{to_group} at T1.}
#'     \item{mean_salary_change}{Numeric. Mean absolute salary change
#'       (T1 sum minus T0 sum) across movers.}
#'     \item{median_salary_change}{Numeric. Median absolute salary change
#'       across movers.}
#'     \item{mean_salary_pct_change}{Numeric. Mean percentage salary change
#'       (\eqn{(salary_{T1} - salary_{T0}) / salary_{T0}}) across movers.}
#'   }
#'
#' @seealso \code{\link{estimate_movement_rates}}, \code{\link{roll_snapshot_pairs}}
#' @keywords internal
.compute_transition_pair <- function(
  snap_t0,
  snap_t1,
  ref_date_col,
  group_cols,
  personnel_id_col,
  start_date_col,
  end_date_col,
  contract_type_col,
  salary_col = NULL
) {
  if (
    !is.null(salary_col) &&
      !(salary_col %in% names(snap_t0) && salary_col %in% names(snap_t1))
  ) {
    stop(sprintf(
      "salary_col '%s' not found in snap_t0 and/or snap_t1",
      salary_col
    ))
  }

  t0_date <- snap_t0[[ref_date_col]][1L]
  t1_date <- snap_t1[[ref_date_col]][1L]

  active_t0 <- snap_t0[
    get(start_date_col) <= t0_date &
      (is.na(get(end_date_col)) | get(end_date_col) >= t0_date) &
      get(contract_type_col) != "inactive"
  ]
  if (nrow(active_t0) == 0L) {
    return(NULL)
  }

  if (is.null(salary_col)) {
    state_t0 <- unique(active_t0[,
      c(personnel_id_col, group_cols),
      with = FALSE
    ])
  } else {
    state_t0 <- compute_fastsummary(
      data = active_t0,
      cols = salary_col,
      fns = "sum",
      groups = c(personnel_id_col, group_cols),
      output = "wide"
    )
  }
  state_t0 <- stats::na.omit(state_t0, cols = group_cols)
  state_t0[,
    from_group := do.call(paste, c(.SD, sep = "||")),
    .SDcols = group_cols
  ]
  data.table::setnames(state_t0, personnel_id_col, ".pid")

  active_t1 <- snap_t1[
    get(start_date_col) <= t1_date &
      (is.na(get(end_date_col)) | get(end_date_col) >= t1_date) &
      get(contract_type_col) != "inactive"
  ]
  if (nrow(active_t1) == 0L) {
    return(NULL)
  }

  if (is.null(salary_col)) {
    state_t1 <- unique(active_t1[,
      c(personnel_id_col, group_cols),
      with = FALSE
    ])
  } else {
    state_t1 <- compute_fastsummary(
      data = active_t1,
      cols = salary_col,
      fns = "sum",
      groups = c(personnel_id_col, group_cols),
      output = "wide"
    )
  }
  state_t1 <- stats::na.omit(state_t1, cols = group_cols)
  state_t1[,
    to_group := do.call(paste, c(.SD, sep = "||")),
    .SDcols = group_cols
  ]
  data.table::setnames(state_t1, personnel_id_col, ".pid")

  tag_vars <- if (is.null(salary_col)) {
    group_cols
  } else {
    c(group_cols, paste0(salary_col, "_sum"))
  }
  setnames(state_t0, tag_vars, paste0(tag_vars, "_t0"))
  setnames(state_t1, tag_vars, paste0(tag_vars, "_t1"))

  transitions <- state_t0[state_t1, on = ".pid", nomatch = NULL]
  if (nrow(transitions) == 0L) {
    return(NULL)
  }

  movement_counts <- transitions[,
    .(n_moves = .N),
    by = .(from_group, to_group)
  ]
  pop_t0 <- state_t0[, .(n_pop = .N), by = from_group]

  period_trans <- movement_counts[pop_t0, on = "from_group", nomatch = NA]
  period_trans[is.na(n_moves), n_moves := 0L]
  period_trans[, period_prob := n_moves / n_pop]
  period_trans[, t0_date := t0_date]
  period_trans[, t1_date := t1_date]

  if (!is.null(salary_col)) {
    sal_t0_col <- paste0(salary_col, "_sum_t0")
    sal_t1_col <- paste0(salary_col, "_sum_t1")

    transitions[, salary_change := get(sal_t1_col) - get(sal_t0_col)]
    transitions[, salary_pct_change := salary_change / get(sal_t0_col)]

    salary_by_pair <- transitions[,
      .(
        mean_salary_t0 = mean(get(sal_t0_col), na.rm = TRUE),
        mean_salary_t1 = mean(get(sal_t1_col), na.rm = TRUE),
        mean_salary_change = mean(salary_change, na.rm = TRUE),
        median_salary_change = stats::median(salary_change, na.rm = TRUE),
        mean_salary_pct_change = mean(salary_pct_change, na.rm = TRUE)
      ),
      by = .(from_group, to_group)
    ]

    period_trans <- salary_by_pair[
      period_trans,
      on = c("from_group", "to_group")
    ]
  }

  period_trans
}
