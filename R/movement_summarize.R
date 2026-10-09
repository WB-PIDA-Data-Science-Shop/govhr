
#' Estimate movement baseline from panel data
#'
#' @description
#' Analyzes longitudinal panel data to compute empirical transition probabilities
#' for promotions and transfers. Compares every pair of consecutive snapshots
#' (T0 -> T1, T1 -> T2, etc.) and returns one row per
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
#' @param contracts A data frame (data.table, data.frame or tibble) or a remote
#'   database table (\code{tbl_dbi}, e.g. DuckDB) of contract data in long
#'   (panel) format. Must contain \code{ref_date_col} for panel snapshot
#'   identification.
#' @param group_cols A character vector. One or more columns defining the movement
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
#'   \code{contracts}. When provided, salary summary columns are appended to
#'   the output (see Value). Default: \code{NULL}.
#' @param ... Arguments passed to methods.
#'
#' @returns A table with one row per
#'   \code{(from_group, to_group, from_period, to_period)} transition pair --
#'   a \code{data.table} keyed on those four columns for data frame input, or
#'   a lazy table sorted by them for \code{tbl_dbi} input (use
#'   \code{dplyr::collect()} to bring it into memory). Has no rows if no
#'   valid transitions are found. Columns:
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
#' @details
#' \strong{How it works.} A contract counts on a snapshot date if it has
#' started, has not ended (or has no end date) and its type is not
#' \code{"inactive"}. Each person's position on a snapshot is their
#' \code{group_cols} value(s) on such a contract. Snapshots are numbered, and
#' every person's positions at snapshot k are joined to their positions at
#' k + 1 in a single pass over the panel, rather than one join per snapshot
#' pair (as \code{roll_snapshot_pairs()} + \code{.compute_transition_pair()}
#' do; that pair-by-pair version gives the same result and is kept as a
#' reference).
#'
#' \strong{Several contracts at once.} A person holding positions in several
#' groups on the same snapshot counts in each: they are at risk in every
#' \code{from_group} they hold, and every pairing of a T0 position with a
#' T1 position is a transition. Someone in G1 and G2 at T0 and only G2 at T1
#' moves G1 -> G2 (and stays in G2).
#'
#' \strong{Entries, exits and gaps.} Only people present (on an active
#' contract) at both T0 and T1 can move. Leavers still count in
#' \code{n_pop}; entrants do not. A person missing from a snapshot and back
#' later is a leaver and then an entrant, never a move across the gap.
#'
#' \strong{Salaries.} With \code{salary_col}, a person's salaries within one
#' position are summed (missing values ignored), and the statistics are taken
#' over the transitions in each \code{(from_group, to_group)} pair. A
#' percentage change from a T0 salary of 0 is \code{Inf}, or undefined (and
#' left out of the mean) if the T1 salary is also 0.
#'
#' For a \code{tbl_dbi}, the same steps run inside the database as SQL, and
#' the result is returned lazily. Two small queries run straight away: the
#' snapshot dates, and the distinct \code{group_cols} values (to build the
#' group labels, which SQL cannot paste).
#'
#' @keywords internal
estimate_movement_rates <- function(contracts, ...) {
  UseMethod("estimate_movement_rates")
}

#' @rdname estimate_movement_rates
#' @importFrom data.table := as.data.table setnames setkeyv
#' @importFrom rlang check_dots_empty
#' @importFrom stats complete.cases median
#' @export
estimate_movement_rates.data.frame <- function(
  contracts,
  group_cols,
  personnel_id_col = "personnel_id",
  ref_date_col = "ref_date",
  start_date_col = "start_date",
  end_date_col = "end_date",
  contract_type_col = "contract_type",
  salary_col = NULL,
  ...
) {
  rlang::check_dots_empty()
  .check_movement_args(
    contracts, group_cols,
    c(ref_date_col, personnel_id_col, group_cols, start_date_col,
      end_date_col, contract_type_col),
    salary_col
  )

  ### work on a subset copy holding only the columns we need, so the
  ### caller's table is never modified
  panel <- as.data.table(contracts)[
    !is.na(get(ref_date_col)),
    unique(c(personnel_id_col, ref_date_col, group_cols, start_date_col,
             end_date_col, contract_type_col, salary_col)),
    with = FALSE
  ]

  all_dates <- sort(unique(panel[[ref_date_col]]))
  n_snaps <- length(all_dates)
  .check_panel_snapshots(n_snaps, arg = "contracts", ref_date_col = ref_date_col)

  ### contracts active on their own snapshot date: started, not ended, and
  ### not inactive. rows with a missing group value can't be placed
  active <- panel[
    get(start_date_col) <= get(ref_date_col) &
      (is.na(get(end_date_col)) | get(end_date_col) >= get(ref_date_col)) &
      get(contract_type_col) != "inactive"
  ]
  active <- active[stats::complete.cases(active[, group_cols, with = FALSE])]

  ### number the snapshots so "the next snapshot" is simply .snap + 1
  active[, .snap := match(get(ref_date_col), all_dates)]
  data.table::setnames(active, personnel_id_col, ".pid")

  ### one state per person, snapshot and group -- a person on several
  ### contracts in different groups has several states. with salary_col,
  ### salaries are summed within a state
  ### (summaries below are plain calls on fixed column names, e.g.
  ### sum(.salary_raw), so data.table's GForce runs them as one grouped C
  ### pass -- get() or a {} block would evaluate R code once per group)
  by_state <- c(".pid", ".snap", group_cols)
  states <- if (is.null(salary_col)) {
    unique(active[, by_state, with = FALSE])
  } else {
    data.table::setnames(active, salary_col, ".salary_raw")
    active[, .(.salary = sum(.salary_raw, na.rm = TRUE)), by = by_state]
  }

  ### label each distinct group combination once (e.g. "E1||G2") rather
  ### than pasting on every row, then join the labels back
  labels <- unique(states[, group_cols, with = FALSE])
  labels[, .group := do.call(paste, c(.SD, sep = "||")), .SDcols = group_cols]
  states <- labels[states, on = group_cols][
    , c(".pid", ".snap", ".group", if (!is.null(salary_col)) ".salary"),
    with = FALSE
  ]

  ### the population at risk: states at each snapshot, by group
  pop <- states[, .(n_pop = .N), by = .(.snap, from_group = .group)]

  ### every state at snapshot k paired with the same person's states at
  ### k + 1, all snapshot pairs in one join. many-to-many by design: a
  ### person in G1 and G2 at k and G2 at k + 1 gives G1 -> G2 and G2 -> G2
  from <- states[.snap < n_snaps]
  data.table::setnames(from, c(".group", ".salary"), c("from_group", ".salary_t0"),
                       skip_absent = TRUE)
  to <- states[.snap > 1L][, .snap := .snap - 1L]
  data.table::setnames(to, c(".group", ".salary"), c("to_group", ".salary_t1"),
                       skip_absent = TRUE)
  moves <- to[from, on = c(".pid", ".snap"), nomatch = NULL, allow.cartesian = TRUE]

  by_move <- c(".snap", "from_group", "to_group")
  out <- if (is.null(salary_col)) {
    moves[, .(n_moves = .N), by = by_move]
  } else {
    moves[, .change := .salary_t1 - .salary_t0]
    moves[, .pct := .change / .salary_t0]
    moves[, .(
      n_moves = .N,
      mean_salary_t0 = mean(.salary_t0, na.rm = TRUE),
      mean_salary_t1 = mean(.salary_t1, na.rm = TRUE),
      mean_salary_change = mean(.change, na.rm = TRUE),
      median_salary_change = median(.change, na.rm = TRUE),
      mean_salary_pct_change = mean(.pct, na.rm = TRUE)
    ), by = by_move]
  }

  ### keep actual moves only. a literal "NA" group value is dropped too, as
  ### the per-pair implementation always did
  out <- out[from_group != to_group & from_group != "NA" & to_group != "NA"]

  out[pop, n_pop := i.n_pop, on = c(".snap", "from_group")]
  out[, `:=`(
    movement_rate = n_moves / n_pop,
    from_period = all_dates[.snap],
    to_period = all_dates[.snap + 1L]
  )]

  out <- out[, .movement_output_cols(salary_col), with = FALSE]
  data.table::setkeyv(out, c("from_group", "to_group", "from_period", "to_period"))
  out[]
}

#' @rdname estimate_movement_rates
#' @importFrom dplyr across all_of any_of arrange case_when coalesce collect
#'   count distinct filter group_by inner_join left_join mutate n pull rename
#'   select summarise
#' @importFrom rlang .data check_dots_empty
#' @importFrom stats median
#' @export
estimate_movement_rates.tbl_dbi <- function(
  contracts,
  group_cols,
  personnel_id_col = "personnel_id",
  ref_date_col = "ref_date",
  start_date_col = "start_date",
  end_date_col = "end_date",
  contract_type_col = "contract_type",
  salary_col = NULL,
  ...
) {
  rlang::check_dots_empty()
  .check_movement_args(
    contracts, group_cols,
    c(ref_date_col, personnel_id_col, group_cols, start_date_col,
      end_date_col, contract_type_col),
    salary_col
  )

  con <- dbplyr::remote_con(contracts)
  panel <- contracts |>
    filter(!is.na(.data[[ref_date_col]]))

  ### the snapshot dates: a small query, brought into R to number them and
  ### to check there are enough
  all_dates <- panel |>
    distinct(.ref = .data[[ref_date_col]]) |>
    collect() |>
    pull(.ref) |>
    sort()
  n_snaps <- length(all_dates)
  .check_panel_snapshots(n_snaps, arg = "contracts", ref_date_col = ref_date_col)

  ### small lookup tables go to the database inline (copy_inline()), so no
  ### write access is needed
  snaps <- dbplyr::copy_inline(
    con, stats::setNames(data.frame(all_dates, seq_len(n_snaps)), c(ref_date_col, ".snap"))
  )
  periods <- dbplyr::copy_inline(con, data.frame(
    .snap = seq_len(n_snaps - 1L),
    from_period = all_dates[-n_snaps],
    to_period = all_dates[-1L]
  ))

  ### contracts active on their own snapshot date, as in the data.frame
  ### method (a NULL in any comparison drops the row, as NA does there)
  active <- panel |>
    filter(
      .data[[start_date_col]] <= .data[[ref_date_col]],
      is.na(.data[[end_date_col]]) | .data[[end_date_col]] >= .data[[ref_date_col]],
      .data[[contract_type_col]] != "inactive"
    ) |>
    drop_missing(group_cols) |>
    inner_join(snaps, by = ref_date_col) |>
    rename(.pid = all_of(personnel_id_col))

  ### one state per person, snapshot and group. SQL's SUM() of only missing
  ### values is NULL where R's sum(na.rm = TRUE) is 0, hence coalesce()
  by_state <- c(".pid", ".snap", group_cols)
  states <- if (is.null(salary_col)) {
    active |>
      select(all_of(by_state)) |>
      distinct()
  } else {
    active |>
      group_by(across(all_of(by_state))) |>
      summarise(
        .salary = coalesce(sum(.data[[salary_col]], na.rm = TRUE), 0),
        .groups = "drop"
      )
  }

  ### group labels: paste() cannot be translated to SQL, so labels are built
  ### in R for the distinct group values and sent back inline
  label_df <- states |>
    select(all_of(group_cols)) |>
    distinct() |>
    collect()
  label_df$.group <- do.call(paste, c(as.list(label_df[group_cols]), sep = "||"))
  labels <- dbplyr::copy_inline(con, as.data.frame(label_df))

  states <- states |>
    inner_join(labels, by = group_cols) |>
    select(all_of(c(".pid", ".snap", ".group", if (!is.null(salary_col)) ".salary")))

  pop <- states |>
    count(.snap, from_group = .group, name = "n_pop") |>
    mutate(n_pop = as.integer(n_pop))

  ### every state at snapshot k paired with the same person's states at k + 1
  from <- states |>
    filter(.snap < !!n_snaps) |>
    rename(from_group = .group, any_of(c(.salary_t0 = ".salary")))
  to <- states |>
    filter(.snap > 1L) |>
    mutate(.snap = .snap - 1L) |>
    rename(to_group = .group, any_of(c(.salary_t1 = ".salary")))
  moves <- inner_join(from, to, by = c(".pid", ".snap"))

  out <- if (is.null(salary_col)) {
    moves |>
      group_by(.snap, from_group, to_group) |>
      summarise(n_moves = as.integer(n()), .groups = "drop")
  } else {
    ### salaries as doubles, so x / 0 is Inf as in R (integer division by
    ### zero is NULL in SQL). 0 / 0 is NaN, which mean(na.rm = TRUE) drops in
    ### R but AVG() would keep, so it is made NULL
    moves |>
      mutate(
        .change = as.double(.salary_t1) - as.double(.salary_t0),
        .pct = case_when(
          .salary_t0 == 0 & .salary_t1 == 0 ~ NA_real_,
          TRUE ~ .change / as.double(.salary_t0)
        )
      ) |>
      group_by(.snap, from_group, to_group) |>
      summarise(
        n_moves = as.integer(n()),
        mean_salary_t0 = mean(.salary_t0, na.rm = TRUE),
        mean_salary_t1 = mean(.salary_t1, na.rm = TRUE),
        mean_salary_change = mean(.change, na.rm = TRUE),
        median_salary_change = median(.change, na.rm = TRUE),
        mean_salary_pct_change = mean(.pct, na.rm = TRUE),
        .groups = "drop"
      )
  }

  out |>
    filter(from_group != to_group, from_group != "NA", to_group != "NA") |>
    left_join(pop, by = c(".snap", "from_group")) |>
    inner_join(periods, by = ".snap") |>
    mutate(movement_rate = as.double(n_moves) / n_pop) |>
    select(all_of(.movement_output_cols(salary_col))) |>
    arrange(from_group, to_group, from_period, to_period)
}

#' @rdname estimate_movement_rates
#' @export
estimate_movement_rates.default <- function(contracts, ...) {
  stop_unsupported_data(contracts, "contracts")
}

### shared by the data.frame and tbl_dbi methods, so they validate and shape
### their output identically

#' @noRd
.check_movement_args <- function(contracts, group_cols, required_cols, salary_col) {
  if (is.null(group_cols) || length(group_cols) == 0) {
    stop(
      "group_cols must be specified for movement baseline estimation",
      call. = FALSE
    )
  }

  # colnames() rather than names(), which does not list a tbl_dbi's columns
  missing_cols <- setdiff(required_cols, colnames(contracts))
  if (length(missing_cols) > 0) {
    stop(
      "Columns not found in contracts: ",
      paste(missing_cols, collapse = ", "),
      call. = FALSE
    )
  }

  if (!is.null(salary_col) && !salary_col %in% colnames(contracts)) {
    stop(sprintf("salary_col '%s' not found in contracts", salary_col), call. = FALSE)
  }
}

#' @noRd
.movement_output_cols <- function(salary_col) {
  c(
    "from_group", "to_group", "movement_rate", "from_period", "to_period",
    "n_pop", "n_moves",
    if (!is.null(salary_col)) {
      c("mean_salary_t0", "mean_salary_t1", "mean_salary_change",
        "median_salary_change", "mean_salary_pct_change")
    }
  )
}

#' Iterate consecutive snapshot pairs in a panel data.table
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
#' @param panel_dt Data.table.  Panel data containing all snapshots.  The key
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
#' @returns A single \code{data.table} produced by
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


#' Compute transition counts for a single consecutive snapshot pair
#'
#' @description
#' Single-pair reference implementation of the counts that
#' \code{estimate_movement_rates()} computes for all pairs at once. It can be
#' driven by \code{roll_snapshot_pairs()} (as \code{estimate_movement_rates()}
#' did up to govhr 0.4.1), and is kept for that and for tests and benchmarks
#' (\code{data-raw/bench/movement_rates.R}). Given two consecutive panel snapshots
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
#' @param snap_t0 Data.table. Subset of the full panel at snapshot T0, already
#'   filtered to a single reference date. Must contain \code{ref_date_col},
#'   \code{personnel_id_col}, \code{group_cols}, \code{start_date_col},
#'   \code{end_date_col}, and \code{contract_type_col}.
#' @param snap_t1 Data.table. Subset of the full panel at snapshot T1 (the
#'   period immediately following T0). Same column requirements as
#'   \code{snap_t0}.
#' @param ref_date_col Character. Name of the reference date column used to
#'   extract T0 and T1 dates from the snapshots.
#' @param group_cols A character vector. Columns whose concatenated values define
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
#' @returns A \code{data.table} with one row per \code{(from_group, to_group)}
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
      group_cols = c(personnel_id_col, group_cols),
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
      group_cols = c(personnel_id_col, group_cols),
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
