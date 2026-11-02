
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
#' pair.
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
#' @export
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
