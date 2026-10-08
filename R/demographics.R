#' Compute Decrement Outcome Counts for a Single Consecutive Snapshot Pair
#'
#' @description
#' Single-pair reference implementation of the counts that
#' \code{estimate_decrement_rates()} computes for all pairs at once. It can be
#' driven by \code{roll_snapshot_pairs()}, mirroring the role
#' \code{.compute_transition_pair()} plays for movement rates, and is kept
#' for tests and benchmarks (\code{data-raw/bench/decrement_rates.R}). Given two
#' consecutive panel snapshots (\code{snap_t0} at T0 and \code{snap_t1} at
#' T1), this function:
#'
#' \enumerate{
#'   \item Defines the exposure cohort as every person with
#'         \code{status_col == "active"} at T0, and tabulates exposure by
#'         \code{age_col}/\code{group_cols} using each person's T0 age and
#'         group -- ages are never shifted, since individuals are tracked by
#'         identity rather than aggregated independently per snapshot.
#'   \item Looks up each cohort member's \code{status_col} value at T1 via a
#'         native data.table join (\code{x[i, on =]}) on
#'         \code{personnel_id_col}. Anyone absent from \code{snap_t1}
#'         altogether (i.e. dropped out of the panel) is assigned the
#'         synthetic outcome \code{"non-retirement-exit"}.
#'   \item Builds the outcome vocabulary from whatever \code{status_col}
#'         values actually appear in \code{snap_t1} (e.g. \code{"active"},
#'         \code{"pensioner"}, \code{"deceased"}, ...), unioned with
#'         \code{"non-retirement-exit"}, which is always included since it is
#'         synthesized rather than drawn from the data. No status values are
#'         hardcoded.
#'   \item Counts, per \code{age_col}/\code{group_cols}/\code{status_col}
#'         combination, how many cohort members ended up with each outcome at
#'         T1 -- including \code{"active"} (i.e. stayed), so the resulting
#'         rates for a given age/group sum to 1 across all outcome types.
#'   \item Expands the result to a complete grid of every exposure
#'         age/group crossed with every outcome type, filling \code{exits = 0}
#'         where a combination had no occurrences, so no age/group ever
#'         collapses into an ambiguous \code{NA}-status row.
#' }
#'
#' @param snap_t0 Data.table. Subset of the full personnel panel at snapshot
#'   T0, already filtered to a single reference date. Must contain
#'   \code{age_col}, \code{status_col}, \code{personnel_id_col},
#'   \code{ref_date_col}, and \code{group_cols}.
#' @param snap_t1 Data.table. Subset of the full personnel panel at snapshot
#'   T1 (the period immediately following T0). Same column requirements as
#'   \code{snap_t0}.
#' @param age_col Character. Name of the (integer or coercible-to-integer)
#'   age column. Exposure and outcome counts are keyed by each person's T0
#'   age.
#' @param status_col Character. Name of the employment status column (e.g.
#'   \code{"employment_status"}). The literal value \code{"active"} defines
#'   the T0 exposure cohort; every other value observed at T1, plus the
#'   synthesized \code{"non-retirement-exit"}, forms the outcome vocabulary.
#' @param personnel_id_col Character. Name of the personnel identifier
#'   column, used to join each cohort member's T0 record to their T1 status.
#' @param ref_date_col Character. Name of the reference date column used to
#'   extract the T0 and T1 dates attached to the output.
#' @param group_cols A character vector. Additional columns (e.g. gender,
#'   service type) to stratify exposure and outcome counts by, alongside
#'   \code{age_col}.
#'
#' @returns A \code{data.table} with one row per
#'   \code{(age_col, group_cols, status_col)} combination observed in the T0
#'   exposure cohort. Columns:
#'   \describe{
#'     \item{age_col}{Integer. T0 age (column name taken from \code{age_col}).}
#'     \item{group_cols}{The stratifying columns, taken directly from T0.}
#'     \item{status_col}{Character. The T1 outcome type (column name taken
#'       from \code{status_col}), e.g. \code{"active"}, \code{"pensioner"},
#'       \code{"non-retirement-exit"}.}
#'     \item{pop}{Integer. Number of active persons at T0 in this age/group
#'       (the exposure, and the denominator for \code{decrement_rate}).}
#'     \item{exits}{Integer. Number of cohort members in this age/group who
#'       had this outcome at T1. \code{0L} where the combination had no
#'       occurrences.}
#'     \item{decrement_rate}{Numeric. \eqn{exits / pop} for this
#'       age/group/outcome combination.}
#'     \item{t0_date}{Date. Reference date of the T0 snapshot.}
#'     \item{t1_date}{Date. Reference date of the T1 snapshot.}
#'   }
#'
#' @seealso \code{\link{.compute_transition_pair}}, \code{\link{roll_snapshot_pairs}}
#' @keywords internal
.compute_decrement_pair <- function(snap_t0,
                                    snap_t1,
                                    age_col,
                                    status_col,
                                    personnel_id_col,
                                    ref_date_col,
                                    group_cols){

  ## ensure we are working with data.tables
  snap_t0 <- as.data.table(snap_t0)
  snap_t1 <- as.data.table(snap_t1)

  ### get the reference dates of interest
  t0_date <- snap_t0[[ref_date_col]][1L]
  t1_date <- snap_t1[[ref_date_col]][1L]

  ### ensure we are using integer ages for classes
  snap_t0[, (age_col) := as.integer(get(age_col))]

  ### the cohort of interest: everyone active at t0. exposure/age/group are
  ### always taken at t0, so there is no need to shift ages when we later
  ### bring in t1 status -- we are tracking the same individuals, not
  ### aggregating two snapshots independently
  cohort_t0 <- snap_t0[get(status_col) == "active"]

  ### exposure counts by age/group
  pop_dt <- cohort_t0[, .(pop = .N), by = c(age_col, group_cols)]

  ### each cohort member's status at t1; anyone absent from the t1 snapshot
  ### altogether has left the organization outside of retirement.
  ### native data.table join (x[i, on=]) rather than merge() -- it keeps all
  ### rows/columns of i (the cohort) plus matched columns of x, via a
  ### binary-search join, without merge()'s extra sorting/attribute overhead
  t1_status <- unique(snap_t1[, c(personnel_id_col, status_col), with = FALSE])

  ### the outcome vocabulary is whatever status values are actually present
  ### in status_col (e.g. "active", "pensioner", "deceased",
  ### "transferred-out", ...) -- we stay agnostic to it rather than
  ### hardcoding specific statuses, and we keep "active" (the stay outcome)
  ### as a row rather than dropping it, so the table reports a rate for
  ### every possible t1 outcome, not just exits. "non-retirement-exit" is
  ### the one type that's always included regardless of what's in the data:
  ### it's synthesized below for anyone who drops out of the panel entirely
  ### rather than showing up with an explicit status at t1
  observed_types <- unique(t1_status[[status_col]])
  observed_types <- observed_types[!is.na(observed_types)]
  outcome_types <- union(observed_types, "non-retirement-exit")

  data.table::setnames(t1_status, status_col, ".status_t1")

  cohort_ids <- cohort_t0[, c(personnel_id_col, age_col, group_cols), with = FALSE]
  cohort_dt <- t1_status[cohort_ids, on = personnel_id_col]
  cohort_dt[is.na(.status_t1), .status_t1 := "non-retirement-exit"]

  ### count every t1 outcome (stay or exit), keyed by each person's t0
  ### age/group -- only cohort members (active at t0) can contribute to the
  ### count, so someone who was already a pensioner at t0 and remains one
  ### at t1 is never counted as a new exit
  exits_dt <- cohort_dt[
    .status_t1 %in% outcome_types,
    .(exits = .N),
    by = c(age_col, group_cols, ".status_t1")
  ]
  data.table::setnames(exits_dt, ".status_t1", status_col)

  ### every age/group in the exposure population should report a rate for
  ### each outcome type, even where the count is 0 -- otherwise an
  ### age/group with no exits at all collapses into a single ambiguous
  ### NA-status row instead of explicit zero rows, which breaks both the
  ### per-outcome-type qx downstream and pooling across period-pairs later
  grid_dt <- pop_dt[,
    c(list(pop = pop), stats::setNames(list(outcome_types), status_col)),
    by = c(age_col, group_cols)
  ]

  ### bring exits onto the full grid (native join, all grid_dt rows/cols kept)
  all_dt <- exits_dt[grid_dt, on = c(age_col, group_cols, status_col)]
  all_dt[is.na(exits), exits := 0]
  all_dt[, decrement_rate := exits / pop]

  ### attach the period pair, matching the convention used by
  ### .compute_transition_pair() for later pooling across period-pairs
  all_dt[, t0_date := t0_date]
  all_dt[, t1_date := t1_date]

  ### lets sort the data.table by age and group columns
  all_dt <- all_dt[, c(age_col, group_cols, status_col, 
                       "pop", "exits", "decrement_rate", 
                       "t0_date", "t1_date"), 
                       with = FALSE]
  setorderv(all_dt, c(age_col, group_cols))

  

  return(all_dt[])
}


#' Estimate empirical decrement rates from a personnel panel
#'
#' @description
#' Estimates, for each age (and any grouping columns you supply), the
#' empirical probability that a person active in one snapshot ends up in
#' each possible employment status by the next snapshot -- retirement,
#' another kind of exit, or simply staying active. These are the raw
#' ingredients (\code{qx}-style decrement rates) for building an actuarial
#' life table, e.g. with a life-table function that chains them across age.
#'
#' The function covers every consecutive pair of snapshots in
#' \code{personnel}, tracks the same individuals from one snapshot to the
#' next, and pools the results into one stable rate per age/group/outcome
#' using all of the data available, rather than relying on any single pair
#' of snapshots (which can be noisy for ages with few people).
#'
#' @param personnel A data frame (data.table, data.frame or tibble) or a
#'   remote database table (\code{tbl_dbi}, e.g. DuckDB) containing the
#'   personnel panel: multiple snapshots of the same population over time,
#'   identified by \code{ref_date_col}. Must contain at least two distinct,
#'   non-missing reference dates.
#' @param age_col A single string naming the (integer, or coercible to
#'   integer) age column.
#' @param status_col A single string naming the employment status column,
#'   e.g. \code{"employment_status"}. The value \code{"active"} identifies
#'   who is exposed to risk in each snapshot; every other value your data
#'   uses (e.g. \code{"pensioner"}, \code{"deceased"}) is picked up
#'   automatically as its own outcome type -- nothing needs to be
#'   hardcoded or registered in advance.
#' @param personnel_id_col A single string naming the personnel identifier
#'   column, used to track the same person across snapshots.
#' @param ref_date_col A single string naming the reference date column that
#'   identifies each snapshot.
#' @param group_cols A character vector of additional columns (e.g. gender,
#'   occupation, service type) to estimate separate rates by, alongside age.
#' @param ... Arguments passed to methods.
#' @param personnel_dt Deprecated. Use `personnel` instead.
#'
#' @returns A table with one row per age / \code{group_cols} / outcome
#'   type, pooled across every consecutive snapshot pair in
#'   \code{personnel} -- a data.table for data frame input, or a lazy table
#'   for \code{tbl_dbi} input (use \code{dplyr::collect()} to bring it into
#'   memory):
#'   \describe{
#'     \item{age_col, group_cols}{The age and grouping columns, as supplied.}
#'     \item{status_col}{The outcome type this row's rate applies to --
#'       \code{"active"} (stayed), an observed exit status (e.g.
#'       \code{"pensioner"}), or the synthetic \code{"non-retirement-exit"}
#'       (someone who dropped out of the panel without an explicit exit
#'       status). For a given age/group, these rows sum to 1.}
#'     \item{pop}{Total exposure: the number of person-periods active at the
#'       start of a snapshot pair, summed across every pair that contributed
#'       to this age/group.}
#'     \item{exits}{Total number of people in that exposure who had this
#'       outcome by the next snapshot, summed the same way.}
#'     \item{decrement_rate}{The pooled rate, \code{exits / pop}. This is the
#'       empirical \code{qx} (or \code{px}, for the \code{"active"} row) to
#'       feed into a life table.}
#'     \item{n_periods}{Number of distinct snapshot pairs in which this
#'       age/group had anyone at risk (the same for every outcome row of the
#'       age/group) -- a quick way to spot ages resting on very little data.}
#'   }
#'
#' @details
#' This section is for readers who want to know exactly how the rate is
#' computed, not just what it means.
#'
#' \strong{Two collapsing steps.} Estimating a life-table-ready rate means
#' collapsing two different axes, and this function only ever does the
#' first one:
#' \itemize{
#'   \item \emph{Time}, here: every consecutive snapshot pair in
#'     \code{personnel} (2015-2016, 2016-2017, ...) contributes its
#'     exposure/outcome counts, and these are pooled into one age-indexed
#'     rate. This function never chains
#'     anything across \emph{age} -- that is a separate step (a life-table
#'     function operating purely on this function's output).
#' }
#'
#' \strong{Pooling is exposure-weighted, not a mean of rates.} For a given
#' age/group/outcome, \code{pop} and \code{exits} are summed across every
#' contributing snapshot pair \emph{before} dividing. A period-pair with 500
#' people at risk therefore contributes proportionally more than one with 2
#' people at risk. A plain average of the per-period rates would let a
#' noisy, thin period swing the estimate just as much as a large one --
#' this deliberately avoids that.
#'
#' \strong{Cohort tracking, not independent aggregation.} Exposure and
#' outcomes follow the same individuals from T0 to T1 by
#' \code{personnel_id_col}, rather than aggregating each snapshot separately
#' and matching on age afterward. This matters: someone who was already a
#' pensioner at T0 and remains one at T1 is never miscounted as a newly
#' observed exit, and each person's age/group is taken from T0, so there is
#' no fragile assumption that snapshots are exactly one year apart.
#'
#' \strong{How each person's T1 status is found.} All snapshot pairs are
#' handled in one pass rather than one pair at a time. The panel is sorted
#' once by person and snapshot, so each person's next record is simply the
#' row below. A person active at T0 takes the status on that row as their
#' outcome if it belongs to the same person at the very next snapshot;
#' otherwise (no record at T1, or an \code{NA} status there) the outcome is
#' \code{"non-retirement-exit"}. This avoids joining every snapshot pair on
#' \code{personnel_id_col}, which dominates the run time on large panels
#' with character IDs. \code{.compute_decrement_pair()} computes the same
#' counts for a single pair and is kept as a reference implementation.
#'
#' \strong{The outcome vocabulary is derived from the data.} Aside from the
#' synthetic \code{"non-retirement-exit"} (assigned to anyone who drops out
#' of the panel between snapshots without an explicit status change), every
#' outcome type reported is simply whatever value \code{status_col} takes on
#' in your data -- including \code{"active"} itself, so you get a stay
#' probability alongside every exit-type probability. This means the
#' function keeps working unmodified if your data's status vocabulary
#' differs from what was used to build or test it (e.g. adding a
#' \code{"deceased"} status requires no code change). The vocabulary is
#' shared by all snapshot pairs: a status observed in only some years still
#' gets a (zero-count) row in every age/group, so all outcome rows of an
#' age/group pool over the same exposure and sum to 1.
#'
#' \strong{Database tables.} For a \code{tbl_dbi}, the same steps run inside
#' the database as SQL: each person's next record comes from a
#' \code{LEAD()} window over their snapshots, and only the pooled table is
#' returned, lazily. Nothing the size of the panel is brought into R, so
#' panels too large for memory can be processed (DuckDB spills to disk). A
#' few small queries do run straight away: the snapshot dates and statuses
#' (for the checks and the outcome vocabulary) and the duplicate count.
#'
#' \strong{Duplicates.} \code{personnel} is expected to be unique at the
#' \code{personnel_id_col}/\code{ref_date_col} level. If it is not, a
#' warning reports the number of duplicate rows and one row per person and
#' snapshot is kept.
#'
#' \strong{Caveat.} The literal string \code{"active"} is currently
#' hardcoded as the value of \code{status_col} that defines who is exposed
#' to risk -- unlike the exit-side vocabulary, this one value is assumed
#' rather than derived.
#'
#' @examples
#' \dontrun{
#' library(data.table)
#'
#' personnel_dt <- data.table(
#'   personnel_id = c("P1", "P2", "P1", "P2"),
#'   ref_date = as.Date(c("2020-01-01", "2020-01-01", "2021-01-01", "2021-01-01")),
#'   age = c(60L, 45L, 61L, 46L),
#'   employment_status = c("active", "active", "pensioner", "active"),
#'   gender = c("M", "F", "M", "F")
#' )
#'
#' estimate_decrement_rates(
#'   personnel_dt = personnel_dt,
#'   age_col = "age",
#'   status_col = "employment_status",
#'   personnel_id_col = "personnel_id",
#'   ref_date_col = "ref_date",
#'   group_cols = "gender"
#' )
#' }
#'
#' @seealso \code{\link{.compute_decrement_pair}}, \code{\link{smooth_decrement_rates}}
#' @export
estimate_decrement_rates <- function(personnel, ..., personnel_dt = NULL) {
  ### the deprecated name has to be resolved before dispatch, since
  ### dispatch looks at the class of `personnel`
  if (!is.null(personnel_dt)) {
    personnel <- resolve_renamed_arg(personnel, personnel_dt, "personnel_dt", "personnel")
    return(estimate_decrement_rates(personnel, ...))
  }

  UseMethod("estimate_decrement_rates")
}

#' @rdname estimate_decrement_rates
#' @importFrom data.table := as.data.table setnames setorderv shift fifelse setcolorder
#' @importFrom rlang check_dots_empty
#' @export
estimate_decrement_rates.data.frame <- function(personnel,
                                                age_col = "age",
                                                status_col = "employment_status",
                                                personnel_id_col = "personnel_id",
                                                ref_date_col = "ref_date",
                                                group_cols = NULL,
                                                ...) {
  rlang::check_dots_empty()

  by_cols <- c(age_col, group_cols)

  ### work on a subset copy holding only the columns we need, so the
  ### caller's table is never re-keyed or re-ordered by the sort below
  panel <- as.data.table(personnel)[
    !is.na(get(ref_date_col)),
    c(personnel_id_col, ref_date_col, status_col, by_cols),
    with = FALSE
  ]

  all_dates <- sort(unique(panel[[ref_date_col]]))
  .check_panel_snapshots(length(all_dates), arg = "personnel", ref_date_col = ref_date_col)

  ### number the snapshots 1, 2, 3, ... so "the next snapshot" is simply
  ### .snap + 1, whatever the actual spacing between reference dates
  data.table::setnames(panel, c(personnel_id_col, status_col), c(".pid", ".status"))
  panel[, .snap := match(get(ref_date_col), all_dates)] ## dates become integers
  panel[, (ref_date_col) := NULL] ##gets rid of the dates
  panel[, .status := as.character(.status)]

  ### sort once by person and snapshot: each person's records now sit
  ### together in date order, so their next record is just the row below.
  ### shift() copies the row below up one row -- a single linear pass, with
  ### none of the id matching a join would need (which is what makes this
  ### much faster than joining each snapshot pair on personnel_id_col).
  ### .next_gap is the number of snapshots to that row: 1 is the very next
  ### snapshot, 0 a duplicate, NA a different person (or no row at all)
  setorderv(panel, c(".pid", ".snap")) 
  add_next_gap <- function(dt) {
    dt[, .next_gap := data.table::fifelse(
      .pid == data.table::shift(.pid, type = "lead"),
      data.table::shift(.snap, type = "lead") - .snap,
      NA_integer_
    )]
  }
  add_next_gap(panel)

  ### the panel should be unique at personnel_id/ref_date level (enforced by
  ### QC upstream). once sorted, a duplicate is a row whose next row is the
  ### same person at the same snapshot -- detectable for free here. left in,
  ### a duplicate would be miscounted as a non-retirement-exit, so keep one
  ### row per person and snapshot
  dup_rows <- panel[, which(.next_gap == 0L)]
  if (length(dup_rows) > 0L) {
    .warn_decrement_duplicates(length(dup_rows), personnel_id_col, ref_date_col)
    panel <- panel[-dup_rows]
    add_next_gap(panel)
  }

  ### each row's outcome is the status on the row below if that row is the
  ### same person at the very next snapshot; otherwise (no record at the
  ### next snapshot, or an NA status there) they left outside of retirement
  panel[, .outcome := data.table::fifelse(
    .next_gap == 1L,
    data.table::shift(.status, type = "lead"),
    NA_character_
  )]
  panel[is.na(.outcome), .outcome := "non-retirement-exit"]

  ### the exposure cohort: everyone active in any snapshot but the last,
  ### keeping only the columns the counts below need
  cohort <- panel[
    .status == "active" & .snap < length(all_dates),
    c(".snap", by_cols, ".outcome"),
    with = FALSE
  ]
  cohort[, (age_col) := as.integer(get(age_col))]

  outcome_types <- .decrement_outcome_types(panel[.snap > 1L, .status])

  ### pool across every period-pair into one stable rate per
  ### age/group/outcome: sum exposure and events first, then divide --
  ### NOT a mean of the per-period rates. A mean would weight a period-pair
  ### with tiny exposure (e.g. pop = 2) the same as one with pop = 500;
  ### summing first lets each period-pair contribute in proportion to its
  ### actual exposure, which is the standard actuarial pooling approach
  pop_dt <- cohort[, .(pop = .N), by = c(".snap", by_cols)][
    , .(pop = sum(pop), n_periods = .N), by = by_cols
  ]
  exits_dt <- cohort[, .(exits = .N), by = c(by_cols, ".outcome")]
  data.table::setnames(exits_dt, ".outcome", status_col)

  ### every exposed age/group reports a rate for every outcome type, with
  ### explicit zeros where nobody had that outcome
  pooled_dt <- pop_dt[rep(seq_len(nrow(pop_dt)), each = length(outcome_types))]
  pooled_dt[, (status_col) := rep(outcome_types, times = nrow(pop_dt))]
  pooled_dt[, exits := 0L]
  pooled_dt[exits_dt, exits := i.exits, on = c(by_cols, status_col)]
  pooled_dt[, decrement_rate := exits / pop]

  data.table::setcolorder(
    pooled_dt,
    c(by_cols, status_col, "pop", "exits", "n_periods", "decrement_rate")
  )
  setorderv(pooled_dt, c(by_cols, status_col))

  return(pooled_dt[])
}

#' @rdname estimate_decrement_rates
#' @importFrom dplyr across all_of arrange case_when collect count cross_join
#'   distinct filter group_by if_else inner_join lead mutate n n_distinct pull
#'   rename row_number select summarise ungroup
#' @importFrom rlang .data !!! check_dots_empty
#' @export
estimate_decrement_rates.tbl_dbi <- function(personnel,
                                             age_col = "age",
                                             status_col = "employment_status",
                                             personnel_id_col = "personnel_id",
                                             ref_date_col = "ref_date",
                                             group_cols = NULL,
                                             ...) {
  rlang::check_dots_empty()

  by_cols <- c(age_col, group_cols)

  ### the same steps as the data.frame method, written as dplyr verbs that
  ### dbplyr turns into SQL -- the panel itself never leaves the database
  panel <- personnel |>
    filter(!is.na(.data[[ref_date_col]])) |>
    select(all_of(c(personnel_id_col, ref_date_col, status_col, by_cols))) |>
    rename(all_of(c(.pid = personnel_id_col, .ref = ref_date_col, .status = status_col)))

  ### the snapshot dates and the statuses seen on each: a small table
  ### (dates x statuses), brought into R for the checks below
  snap_status <- collect(distinct(panel, .ref, .status))
  all_dates <- sort(unique(snap_status$.ref))
  .check_panel_snapshots(length(all_dates), arg = "personnel", ref_date_col = ref_date_col)

  ### duplicates at the personnel_id/ref_date level: count the surplus rows,
  ### then keep one row per person and snapshot
  n_dup <- panel |>
    count(.pid, .ref, name = ".n") |>
    filter(.n > 1L) |>
    summarise(.n_dup = sum(.n - 1L, na.rm = TRUE)) |>
    pull(.n_dup)
  if (isTRUE(n_dup > 0)) {
    .warn_decrement_duplicates(n_dup, personnel_id_col, ref_date_col)
    panel <- panel |>
      group_by(.pid, .ref) |>
      dbplyr::window_order(.status) |>
      filter(row_number() == 1L) |>
      ungroup()
    snap_status <- collect(distinct(panel, .ref, .status))
  }

  outcome_types <- .decrement_outcome_types(
    snap_status$.status[snap_status$.ref > all_dates[1L]]
  )

  ### small lookup tables go to the database inline (copy_inline()), so no
  ### write access is needed: the snapshot number of each date, and the
  ### outcome vocabulary
  con <- dbplyr::remote_con(personnel)
  snaps <- dbplyr::copy_inline(
    con, data.frame(.ref = all_dates, .snap = seq_along(all_dates))
  )
  outcomes <- dbplyr::copy_inline(
    con, stats::setNames(data.frame(outcome_types), status_col)
  )

  ### number the snapshots, then read each person's next record with a
  ### LEAD() window ordered by snapshot -- the SQL counterpart of sorting by
  ### person and snapshot and looking at the row below. ages are floored
  ### before casting, matching as.integer() in R (a bare SQL cast rounds)
  n_snaps <- length(all_dates)
  cohort <- panel |>
    inner_join(snaps, by = ".ref") |>
    group_by(.pid) |>
    dbplyr::window_order(.snap) |>
    mutate(.next_snap = lead(.snap), .next_status = lead(.status)) |>
    ungroup() |>
    filter(.status == "active", .snap < !!n_snaps) |>
    mutate(
      !!age_col := as.integer(floor(.data[[age_col]])),
      .outcome = case_when(
        .next_snap == .snap + 1L & !is.na(.next_status) ~ .next_status,
        TRUE ~ "non-retirement-exit"
      )
    )

  ### aggregate the cohort once, to one row per age/group with its exposure
  ### and one exit count per outcome type (.exits_1, .exits_2, ...). the
  ### window above is expensive, and referencing `cohort` twice (once for
  ### exposure, once for exits) would make the database compute it twice.
  ### exposure is pooled across period-pairs before dividing (see the
  ### data.frame method)
  exit_cols <- paste0(".exits_", seq_along(outcome_types))
  count_exits <- stats::setNames(
    lapply(outcome_types, function(type) {
      rlang::expr(sum(if_else(.outcome == !!type, 1L, 0L), na.rm = TRUE))
    }),
    exit_cols
  )
  pooled <- cohort |>
    group_by(across(all_of(by_cols))) |>
    summarise(
      pop = as.integer(n()),
      n_periods = as.integer(n_distinct(.snap)),
      !!!count_exits,
      .groups = "drop"
    )

  ### one row per outcome type for every exposed age/group, taking that
  ### outcome's exit count (zero where nobody had it)
  pick_exits <- lapply(seq_along(outcome_types), function(i) {
    rlang::expr(.data[[!!status_col]] == !!outcome_types[i] ~ !!rlang::sym(exit_cols[i]))
  })

  pooled |>
    cross_join(outcomes) |>
    mutate(exits = as.integer(case_when(!!!pick_exits))) |>
    mutate(decrement_rate = as.double(exits) / pop) |>
    select(all_of(c(by_cols, status_col, "pop", "exits", "n_periods", "decrement_rate"))) |>
    arrange(across(all_of(c(by_cols, status_col))))
}

#' @rdname estimate_decrement_rates
#' @export
estimate_decrement_rates.default <- function(personnel, ...) {
  stop_unsupported_data(personnel, "personnel")
}

### checks and rules shared by the data.frame and tbl_dbi methods, so the two
### cannot drift apart

#' @noRd
.warn_decrement_duplicates <- function(n_dup, personnel_id_col, ref_date_col) {
  warning(
    "`personnel` has ", n_dup, " duplicate rows at the ",
    personnel_id_col, "/", ref_date_col, " level, which should be unique. ",
    "Keeping one row per person and snapshot; decrement counts for the ",
    "affected people depend on which row is kept.",
    call. = FALSE
  )
}

### the outcome vocabulary is every status observed at any snapshot that can
### be a t1 (i.e. all but the first), plus the synthetic
### "non-retirement-exit". it is shared by all snapshot pairs, so every
### outcome row of an age/group pools over the same exposure and the rates
### sum to 1 -- even for a status that only shows up in some years
#' @noRd
.decrement_outcome_types <- function(t1_statuses) {
  union(
    sort(unique(as.character(t1_statuses[!is.na(t1_statuses)]))),
    "non-retirement-exit"
  )
}



#' Graduate a single age curve onto a complete age grid
#'
#' @description
#' Internal single-curve workhorse called by \code{smooth_decrement_rates()}
#' once per \code{(group_cols, status_col)} combination. Given raw
#' \code{(age, rate)} observations for one specific outcome curve (e.g. "male
#' pensioner rate by age"), returns a smoothed rate for \emph{every} age in
#' \code{full_ages} -- including ages that had zero raw observations at all.
#'
#' The method used depends on how much data is actually available, since a
#' local regression needs enough support to be stable:
#' \itemize{
#'   \item Exactly one distinct age observed: there is no trend to fit from a
#'     single point, so that one rate is repeated flat across the whole grid.
#'   \item Two or three distinct ages: too few for a stable \code{loess} fit,
#'     so falls back to \code{stats::approx()} (piecewise linear
#'     interpolation). Ages in \code{full_ages} outside the observed range get
#'     the nearest boundary value (\code{rule = 2}) rather than \code{NA}.
#'   \item Four or more distinct ages: fits
#'     \code{stats::loess(rate ~ age, weights = weight, span = span, degree = 2)}
#'     and predicts it onto \code{full_ages}. \code{weight} (exposure) means an
#'     age with many people at risk pulls the local curve toward its raw rate
#'     harder than a thin, noisy age.
#' }
#'
#' @param age Numeric vector. Ages with an observed rate.
#' @param rate Numeric vector. The observed rate at each \code{age} (same
#'   length as \code{age}).
#' @param weight Numeric vector. Exposure weight at each \code{age} (same
#'   length as \code{age}), used as \code{loess()} weights.
#' @param full_ages Integer vector. The complete, gapless target age grid to
#'   return a smoothed rate for.
#' @param span Numeric. The \code{loess()} smoothing span (only used when
#'   there are at least 4 distinct ages); larger values produce a smoother,
#'   more global fit, smaller values track local features more closely.
#'
#' @returns A numeric vector of smoothed rates, one per element of
#'   \code{full_ages}, in the same order. Not clipped to \code{[0, 1]} --
#'   callers (e.g. \code{smooth_decrement_rates()}) are responsible for that.
#'
#' @seealso \code{\link{smooth_decrement_rates}}
#' @keywords internal
.smooth_rate_curve <- function(age, rate, weight, full_ages, span) {
  n_unique <- length(unique(age))

  if (n_unique == 1L) {
    return(rep(rate[1L], length(full_ages)))
  }

  if (n_unique < 4L) {
    return(stats::approx(x = age, y = rate, xout = full_ages, rule = 2)$y)
  }

  fit <- stats::loess(rate ~ age, weights = weight, span = span, degree = 2)
  as.numeric(stats::predict(fit, newdata = data.frame(age = full_ages)))
}

#' Graduate (smooth and gap-fill) empirical decrement rates
#'
#' @description
#' Takes the pooled output of \code{estimate_decrement_rates()} and returns a
#' version with no age gaps and much less small-cell noise -- both
#' prerequisites for \code{compute_service_table()}'s age-chaining recursion,
#' which needs a complete, stable \code{qx} curve to run at all.
#'
#' Each exit cause (every \code{status_col} value other than
#' \code{active_value}) is graduated independently via
#' \code{.smooth_rate_curve()}, weighted by exposure (\code{pop}) so ages with
#' more data pull their local curve harder than thin, noisy ages.
#' \code{active_value} (the "stayed" outcome) is deliberately never smoothed
#' on its own -- it is derived afterward as \code{1 - } the sum of the
#' smoothed exit rates, which is what guarantees every age/group's rates
#' still sum to exactly 1 after smoothing (independently smoothing every
#' outcome type would not preserve that).
#'
#' @param decrements A data frame or lazy database table (\code{tbl_dbi})
#'   shaped like the output of \code{estimate_decrement_rates()}: one row per
#'   age / \code{group_cols} / \code{status_col}, with a \code{pop}
#'   (exposure) and \code{decrement_rate} column. A lazy table is collected
#'   into memory first; it is small, and the smoothing runs in R.
#' @param age_col A single string naming the age column.
#' @param status_col A single string naming the outcome-type column.
#' @param group_cols A character vector of stratifying columns (e.g. gender),
#'   or \code{NULL} for no stratification.
#' @param active_value A single string giving the \code{status_col} value that
#'   represents "stayed" rather than an exit. Defaults to \code{"active"}.
#' @param span Numeric. The \code{loess()} smoothing span passed through to
#'   \code{.smooth_rate_curve()}. Defaults to \code{0.75}.
#' @param decrement_dt Deprecated. Use `decrements` instead.
#'
#' @returns A data.table (also for \code{tbl_dbi} input) with one row per
#'   age / \code{group_cols} / \code{status_col}, spanning the full observed
#'   age range within each group with no gaps:
#'   \describe{
#'     \item{age_col, group_cols}{As supplied.}
#'     \item{status_col}{The outcome type, including \code{active_value}.}
#'     \item{decrement_rate}{The graduated rate, clipped to \code{[0, 1]}.
#'       Sums to 1 across outcome types for a given age/group (up to the
#'       clamping caveat below).}
#'   }
#'   \code{pop}, \code{exits}, and \code{n_periods} from \code{decrement_dt}
#'   are not carried forward: an interpolated age never had a real headcount,
#'   so those columns would be fabricated rather than meaningful.
#'
#' @details
#' \strong{Age grid.} Each group's target age grid (\code{min(age)} to
#' \code{max(age)}) is computed once across \emph{all} outcome types in
#' \code{decrement_dt}, not separately per \code{status_col}, so every exit
#' cause ends up graduated onto exactly the same set of ages within a group.
#'
#' \strong{Clamping caveat.} If the smoothed exit rates for a given age/group
#' happen to sum to slightly more than 1 (possible when several causes are
#' each pushed up near a sparse edge), the derived \code{active_value} rate is
#' clamped to 0 rather than going negative. In that edge case the row then
#' sums to slightly less than 1 rather than exactly 1 -- a known imperfection
#' that is not further corrected.
#'
#' @seealso \code{\link{.smooth_rate_curve}}, \code{\link{estimate_decrement_rates}},
#'   \code{\link{compute_service_table}}
#' @export
smooth_decrement_rates <- function(decrements,
                                   age_col,
                                   status_col,
                                   group_cols,
                                   active_value = "active",
                                   span = 0.75, decrement_dt = NULL) {
  decrements <- resolve_renamed_arg(decrements, decrement_dt, "decrement_dt", "decrements")

  ### a lazy database table (e.g. the tbl_dbi output of
  ### estimate_decrement_rates()) is collected first: it is small (one row
  ### per age/group/status), and loess has to run in R anyway. collect() is
  ### a no-op for data frames
  decrements <- as.data.table(collect(decrements))

  ### the age grid to graduate onto: the full observed age range within
  ### each group, computed once across all outcome types (not per-status)
  ### so every exit cause ends up on exactly the same age sequence
  age_range_dt <- decrements[,
    .(min_age = min(get(age_col)), max_age = max(get(age_col))),
    by = group_cols
  ]

  exit_dt <- decrements[get(status_col) != active_value]

  ### when there are no group_cols, age_range_dt is a single global row --
  ### a join has no columns to match on in that case (data.table's `on =`
  ### requires a non-empty column vector), so broadcast it directly instead
  if (length(group_cols) > 0L) {
    exit_dt <- age_range_dt[exit_dt, on = group_cols]
  } else {
    exit_dt[, c("min_age", "max_age") := age_range_dt[, .(min_age, max_age)]]
  }

  smoothed_dt <- exit_dt[,
    {
      full_ages <- seq.int(min_age[1L], max_age[1L])
      smoothed_rate <- .smooth_rate_curve(
        age = get(age_col),
        rate = decrement_rate,
        weight = pop,
        full_ages = full_ages,
        span = span
      )
      ### clip to a valid probability range -- loess/linear interpolation
      ### can overshoot slightly, especially near sparse edges
      smoothed_rate <- pmin(pmax(smoothed_rate, 0), 1)
      stats::setNames(list(full_ages, smoothed_rate), c(age_col, "decrement_rate"))
    },
    by = c(group_cols, status_col)
  ]

  ### "active" is never smoothed directly -- it's derived as the complement
  ### of the smoothed exit rates, which is what guarantees every age/group's
  ### rates still sum to exactly 1 after smoothing (independently smoothing
  ### every outcome type, "active" included, would not preserve that)
  active_dt <- smoothed_dt[,
    .(decrement_rate = pmax(1 - sum(decrement_rate), 0)),
    by = c(age_col, group_cols)
  ]
  active_dt[, (status_col) := active_value]

  out_dt <- data.table::rbindlist(list(smoothed_dt, active_dt), use.names = TRUE)
  setorderv(out_dt, c(group_cols, age_col, status_col))

  return(out_dt[])
}


#' Compute an actuarial service table from a personnel panel
#'
#' @description
#' Builds a multiple-decrement service table: for each age (and any
#' \code{group_cols} you supply), the number of survivors (\code{lx}), person-
#' years of service (\code{Lx}, \code{Tx}), and expected remaining years of
#' service (\code{ex}) for a synthetic cohort experiencing today's
#' age-specific empirical decrement rates at every future age.
#'
#' This chains \code{estimate_decrement_rates()}'s pooled, age-indexed rates
#' across \emph{age} -- a different axis from the time-pooling that function
#' already did. By default the rates are graduated first via
#' \code{smooth_decrement_rates()}, since the chain below requires a
#' complete, gapless, reasonably stable \code{qx} curve to produce a sensible
#' result.
#'
#' @param personnel A data frame (data.table, data.frame or tibble) or a
#'   remote database table (\code{tbl_dbi}, e.g. DuckDB) containing the
#'   personnel panel. Passed straight through to
#'   \code{estimate_decrement_rates()}, so for a database table the heavy
#'   step runs in the database; its small pooled result is then collected
#'   and the life table is built in R.
#' @param age_col A single string naming the age column.
#' @param status_col A single string naming the employment status column. The
#'   value \code{"active"} identifies the "stayed" outcome that the survival
#'   chain is built from.
#' @param personnel_id_col A single string naming the personnel identifier
#'   column.
#' @param ref_date_col A single string naming the reference date column.
#' @param group_cols A character vector of additional columns (e.g. gender,
#'   service type) to compute a separate service table for, or \code{NULL}
#'   for a single table over the whole population.
#' @param radix Numeric. The size of the synthetic starting cohort at the
#'   youngest observed age. Purely a normalizing constant -- it cancels out
#'   of \code{ex} and does not represent real people. Defaults to
#'   \code{100000}.
#' @param smooth Logical. Whether to graduate the decrement rates via
#'   \code{smooth_decrement_rates()} before chaining. Defaults to
#'   \code{FALSE}: the raw pooled rates are chained directly, \emph{unless}
#'   a \code{group_cols} stratum has an age gap, in which case
#'   \code{compute_service_table()} smooths reactively (with a warning)
#'   regardless of this setting, since the chain cannot run on a gappy
#'   age sequence. Set to \code{TRUE} to always smooth up front, including
#'   for noise reduction on strata that have no gap at all.
#' @param span Numeric. Forwarded to \code{smooth_decrement_rates()} when
#'   \code{smooth = TRUE}. Defaults to \code{0.75}.
#' @param personnel_dt Deprecated. Use `personnel` instead.
#' @param include_all Logical. Whether to return the full life table
#'   (\code{TRUE}, the default) or only \code{age_col}, \code{group_cols},
#'   \code{px} and \code{ex} (\code{FALSE}).
#'
#' @returns A data.table (also for \code{tbl_dbi} input) with one row per
#'   age / \code{group_cols}. With \code{include_all = FALSE}, only the
#'   \code{age_col}, \code{group_cols}, \code{px} and \code{ex} columns are
#'   kept:
#'   \describe{
#'     \item{age_col, group_cols}{As supplied.}
#'     \item{px}{Probability of remaining active from age x to x+1.}
#'     \item{lx}{Survivors at age x, out of \code{radix} at the youngest age:
#'       \eqn{l(x) = radix \prod_{y<x} p(y)}.}
#'     \item{lx_next}{Survivors at age x+1: \eqn{l(x) \cdot p(x)}.}
#'     \item{Lx}{Person-years of service between age x and x+1:
#'       \eqn{(l(x) + l_{next}(x)) / 2} (trapezoidal approximation, assuming
#'       exits are spread uniformly across the year).}
#'     \item{Tx}{Total remaining person-years of service from age x onward:
#'       \eqn{\sum_{y \ge x} L(y)}.}
#'     \item{ex}{Expected remaining years of service at age x:
#'       \eqn{T(x) / l(x)}.}
#'   }
#'
#' @details
#' \strong{This is a stationary-cohort summary, not a projection of your real
#' workforce headcount.} \code{lx} describe a hypothetical synthetic cohort
#' that experiences today's cross-sectional age-specific rates at every
#' future age -- they are not a forecast of how many of your actual current
#' employees will retire in each future calendar year. For that, the raw
#' output of \code{estimate_decrement_rates()} (applied to your real current
#' headcount by age, stepped forward through calendar time) is the right
#' input, not this table.
#'
#' \strong{Caveat.} The literal string \code{"active"} is hardcoded as the
#' \code{status_col} value the survival chain is built from -- inherited
#' directly from \code{estimate_decrement_rates()} and
#' \code{.compute_decrement_pair()}, where the same caveat applies.
#'
#' @examples
#' \dontrun{
#' library(data.table)
#'
#' personnel_dt <- data.table(
#'   personnel_id = c("P1", "P2", "P1", "P2"),
#'   ref_date = as.Date(c("2020-01-01", "2020-01-01", "2021-01-01", "2021-01-01")),
#'   age = c(60L, 45L, 61L, 46L),
#'   employment_status = c("active", "active", "pensioner", "active"),
#'   gender = c("M", "F", "M", "F")
#' )
#'
#' compute_service_table(
#'   personnel_dt = personnel_dt,
#'   age_col = "age",
#'   status_col = "employment_status",
#'   personnel_id_col = "personnel_id",
#'   ref_date_col = "ref_date",
#'   group_cols = "gender"
#' )
#' }
#'
#' @seealso \code{\link{estimate_decrement_rates}}, \code{\link{smooth_decrement_rates}}
#' @export
compute_service_table <- function(personnel,
                                  age_col,
                                  status_col,
                                  personnel_id_col,
                                  ref_date_col,
                                  group_cols,
                                  radix = 100000,
                                  smooth = FALSE,
                                  span = 0.75, 
                                  personnel_dt = NULL,
                                  include_all = TRUE) {
  personnel <- resolve_renamed_arg(personnel, personnel_dt, "personnel_dt", "personnel")

  ## compute the decrement rates using the estimate_decrement_rates function
  ## across all time periods and groupings. for a database table this runs in
  ## the database and returns a lazy table; the pooled result is small, so
  ## collect() it (a no-op for data frames) for the data.table chain below
  decrement_dt <-
    estimate_decrement_rates(personnel = personnel,
                             age_col = age_col,
                             status_col = status_col,
                             personnel_id_col = personnel_id_col,
                             ref_date_col = ref_date_col,
                             group_cols = group_cols) |>
    collect() |>
    as.data.table()

  ### the chain below needs a complete, gapless, stable qx curve -- raw
  ### pooled counts don't guarantee that (an age with zero exposure
  ### anywhere in the panel is simply absent, and thin ages are noisy).
  ### smoothing fills gaps and grades away small-cell noise in one step
  if (isTRUE(smooth)) {
    decrement_dt <- smooth_decrement_rates(
      decrements = decrement_dt,
      age_col = age_col,
      status_col = status_col,
      group_cols = group_cols,
      span = span
    )
  }

  ### px = the probability of remaining active from age x to x+1. this is
  ### the only row of the decrement table the chain needs directly -- every
  ### other status_col value is an exit cause, already fully captured in
  ### px since all outcome rates for a given age/group sum to 1.
  ### wrapped in a closure since it needs to run twice below: once against
  ### whatever decrement_dt looks like now, and again after any reactive
  ### smoothing replaces decrement_dt with a gap-filled version
  .extract_survival <- function(dt) {
    out <- dt[
      get(status_col) == "active",
      c(age_col, group_cols, "decrement_rate"),
      with = FALSE
    ]
    data.table::setnames(out, "decrement_rate", "px")
    setorderv(out, c(group_cols, age_col))
    out
  }
  survival_dt <- .extract_survival(decrement_dt)

  ### if smoothing wasn't requested up front but the raw pooled rates have
  ### an age gap, smooth reactively instead of failing -- then re-extract
  ### survival_dt from the now gap-filled decrement_dt. skipping that
  ### re-extraction was the bug: the chain below would otherwise keep
  ### running on the stale, still-gappy survival_dt built above
  gap_dt <- survival_dt[, .(has_gap = any(diff(get(age_col)) != 1L)), by = group_cols]
  if (any(gap_dt$has_gap) && !isTRUE(smooth)) {

    warning(
      "compute_service_table() requires a contiguous (no-gap) age sequence ",
      "within each group_cols stratum. the survival probabilities will be smoothed,
       and gap-filled automatically if you set smooth = TRUE, see
       help(smooth_decrement_rates) for methodological details.",
      call. = FALSE
    )

    decrement_dt <- smooth_decrement_rates(
      decrements = decrement_dt,
      age_col = age_col,
      status_col = status_col,
      group_cols = group_cols,
      span = span
    )
    survival_dt <- .extract_survival(decrement_dt)

  }

  ### lx = radix * prod_{y < x} p(y), chained within each group_cols
  ### stratum via a lagged cumulative product -- shift() fills the first
  ### position with 1, so lx at the youngest age is exactly the radix
  survival_dt[,
    lx := radix * cumprod(data.table::shift(px, n = 1L, fill = 1)),
    by = group_cols
  ]
  survival_dt[, lx_next := lx * px]

  ### Lx = person-years of service between age x and x+1 (trapezoidal
  ### approximation: assumes exits are spread uniformly across the year)
  survival_dt[, Lx := (lx + lx_next) / 2]

  ### Tx = total remaining person-years of service from age x onward.
  ### rows are already sorted ascending by age within each group, so a
  ### reverse cumulative sum gives Tx without needing to re-sort
  survival_dt[, Tx := rev(cumsum(rev(Lx))), by = group_cols]

  ### ex = expected remaining years of service for someone currently age x
  survival_dt[, ex := Tx / lx]

  ### keep only the headline columns if asked; group_cols = NULL simply
  ### drops out of c()
  if (!isTRUE(include_all)) {
    survival_dt <- survival_dt[, c(age_col, group_cols, "px", "ex"), with = FALSE]
  }

  return(survival_dt[])
}
