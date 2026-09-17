#' Compute growth decomposition of wagebill
#'
#' @param data A data frame containing the data to be analyzed. It should include columns for the grouping variables, a column for the reference date, and a column for the measure of interest (e.g., gross salary).
#' @param group_cols A character vector specifying the names of the columns to group by.
#' @param measure_col A string specifying the name of the column containing the measure of interest (default is "gross_salary_lcu").
#'
#' @returns A data.table with headcount, compensation, wagebill, wagebill_lag,
#'   the continuing-period decomposition (employment/compensation/interaction
#'   effects), entry/exit effects, is_observed, and a `transition_type` label
#'   for each row: "start" (panel's first period for this group -- left-
#'   censored, no baseline available), "continuing" (observed this period
#'   and last), "entry" (observed now, not last period -- a genuinely new
#'   group_cols combination, or a reappearance after any length of absence),
#'   or "exit" (not observed now -- covers both the period a group first
#'   disappears, which carries the real dollar effect, and every subsequent
#'   period it remains absent, which correctly carries a zero effect since
#'   nothing further changed).
#'
#' @importFrom data.table .N := shift setorderv fcase fifelse
#' @importFrom tidyr complete nesting
#' @export
compute_growth_decomposition <- function(
  data,
  group_cols = NULL,
  measure_col = "gross_salary_lcu"
) {
  dt <- data.table::as.data.table(data)

  if (!is.null(group_cols)) {
    keep <- rowSums(is.na(dt[, ..group_cols])) == 0
    dt <- dt[keep]
  }

  by_cols <- c(group_cols, "ref_date")

  summary_table <- dt[
    !is.na(get(measure_col)),
    .(
      headcount    = .N,
      compensation = mean(get(measure_col)),
      wagebill     = sum(get(measure_col))
    ),
    by = by_cols
  ]

  summary_table[, is_observed := TRUE]

  min_date <- min(data$ref_date)
  max_date <- max(data$ref_date)
  date_interval <- guess_date_frequency(data)

  # explicit date sequence (not just observed dates) so a period missing
  # for EVERY group still gets a row, rather than silently vanishing
  if (!is.null(group_cols)) {
    summary_table <- summary_table |>
      tidyr::complete(
        tidyr::nesting(!!!rlang::syms(group_cols)),
        ref_date = seq(min_date, max_date, by = date_interval),
        fill = list(headcount = 0, compensation = NA_real_)
      )
  } else {
    summary_table <- summary_table |>
      tidyr::complete(
        ref_date = seq(min_date, max_date, by = date_interval),
        fill = list(headcount = 0, compensation = NA_real_)
      )
  }

  summary_table <- data.table::as.data.table(summary_table)
  summary_table[is.na(is_observed), is_observed := FALSE]
  summary_table[is.na(wagebill), wagebill := 0]  # unobserved periods contribute $0

  data.table::setorderv(summary_table, by_cols)

  summary_table[,
    `:=`(
      headcount_lag    = data.table::shift(headcount, type = "lag"),
      compensation_lag = data.table::shift(compensation, type = "lag"),
      wagebill_lag     = data.table::shift(wagebill, type = "lag"),
      observed_lag     = data.table::shift(is_observed, type = "lag")
    ),
    by = group_cols
  ]

  # only two non-continuing states now: entry and exit. Every unobserved
  # row is "exit" -- the boundary row and every row of continued absence
  # after it both get the label; they're distinguished below by whether
  # exit_effect is zero or not, not by a separate transition_type.
  summary_table[, transition_type := data.table::fcase(
    is.na(observed_lag) & is_observed,   "start",
    !observed_lag & is_observed,         "entry",
    is.na(observed_lag) & !is_observed,  "exit",
    observed_lag & !is_observed,         "exit",
    !observed_lag & !is_observed,        "exit",
    observed_lag & is_observed,          "continuing"
  )]

  summary_table[, `:=`(
    delta_headcount    = headcount - headcount_lag,
    delta_compensation = compensation - compensation_lag
  )]

  summary_table[, `:=`(
    employment_effect   = compensation_lag * delta_headcount,
    compensation_effect = headcount_lag * delta_compensation,
    interaction_effect  = delta_headcount * delta_compensation
  )]

  summary_table[
    transition_type != "continuing",
    `:=`(
      delta_headcount = NA_real_, delta_compensation = NA_real_,
      employment_effect = NA_real_, compensation_effect = NA_real_,
      interaction_effect = NA_real_
    )
  ]

  summary_table[, `:=`(entry_effect = NA_real_, exit_effect = NA_real_)]
  summary_table[transition_type == "entry", entry_effect := wagebill]
  # nonzero only at the true boundary (observed last period, not this one);
  # every subsequent absent period gets 0 -- it was already gone
  summary_table[
    transition_type == "exit",
    exit_effect := data.table::fifelse(observed_lag %in% TRUE, -wagebill_lag, 0)
  ]

  summary_table[, total_effect := data.table::fcase(
    transition_type == "continuing",
    employment_effect + compensation_effect + interaction_effect,
    transition_type == "entry", entry_effect,
    transition_type == "exit", exit_effect,
    default = NA_real_  # "start": genuinely unknown baseline
  )]

  out_cols <- c(
    group_cols, "ref_date", "transition_type", "headcount", "headcount_lag",
    "compensation", "compensation_lag", "employment_effect",
    "compensation_effect", "interaction_effect", "entry_effect", "delta_compensation",
    "exit_effect", "total_effect", "wagebill", "wagebill_lag", "is_observed", "observed_lag"
  )

  summary_table[, ..out_cols]
}

#' Decompose aggregate average-compensation growth into within, between,
#' cross, entry, and exit effects (Foster-Haltiwanger-Krizan style)
#'
#' Takes the per-group output of compute_growth_decomposition() and answers
#' a different question than that function does: not "why did group i's own
#' wagebill change" but "why did average compensation across ALL groups
#' combined change" -- specifically, how much is pay growth within groups
#' versus a shift in headcount share toward higher- or lower-paid groups.
#'
#' @param growth_decomp Output of compute_growth_decomposition()
#' @param group_cols Optional character vector of columns identifying a higher-level
#'   unit (e.g. "country_code") within which shares/composition are computed
#'   separately. NULL pools all rows into one global composition per ref_date.
#'
#' @returns A data.table, one row per ref_date (or per ref_date x `group_cols`),
#'   with avg_compensation, avg_compensation_lag, within_effect,
#'   between_effect, cross_effect, entry_effect, exit_effect, and total_effect
#'   (which equals avg_compensation - avg_compensation_lag by construction,
#'   except at the panel's first period, which is NA -- no lagged baseline).
#'
#' @importFrom data.table := fifelse
#' @export
compute_wage_decomposition <- function(growth_decomp, group_cols = NULL) {

  dt <- data.table::copy(data.table::as.data.table(growth_decomp))
  agg_by <- c(group_cols, "ref_date")

  # totals at t and t-1, computed within `by` x ref_date. Summing headcount_lag
  # across this period's rows correctly reconstructs total headcount at t-1,
  # since every group has a row for every ref_date (from the nesting-complete
  # grid upstream) -- the roster is stable even though membership isn't.
  dt[, `:=`(
    total_headcount      = sum(headcount),
    total_headcount_prev = sum(headcount_lag, na.rm = TRUE),
    total_wagebill       = sum(wagebill),
    total_wagebill_prev  = sum(wagebill_lag, na.rm = TRUE)
  ), by = agg_by]

  dt[, `:=`(
    avg_compensation     = total_wagebill / total_headcount,
    avg_compensation_lag = data.table::fifelse(
      total_headcount_prev > 0, total_wagebill_prev / total_headcount_prev, NA_real_
    )
  )]

  dt[, `:=`(
    share     = headcount / total_headcount,
    share_lag = data.table::fifelse(
      total_headcount_prev > 0, headcount_lag / total_headcount_prev, NA_real_
    )
  )]
  dt[, delta_share := share - share_lag]

  # row-level terms; 0 wherever the transition type doesn't apply, rather
  # than NA, so they sum cleanly without na.rm masking real problems
  dt[, `:=`(
    within_term  = data.table::fifelse(
      transition_type == "continuing", share_lag * delta_compensation, 0
    ),
    between_term = data.table::fifelse(
      transition_type == "continuing", delta_share * (compensation_lag - avg_compensation_lag), 0
    ),
    cross_term   = data.table::fifelse(
      transition_type == "continuing", delta_share * delta_compensation, 0
    ),
    entry_term   = data.table::fifelse(
      transition_type == "entry", share * (compensation - avg_compensation_lag), 0
    ),
    exit_term    = data.table::fifelse(
      transition_type == "exit" & observed_lag %in% TRUE,
      -share_lag * (compensation_lag - avg_compensation_lag), 0
    )
  )]

  period_decomp <- dt[, .(
    avg_compensation     = avg_compensation[1],
    avg_compensation_lag = avg_compensation_lag[1],
    within_effect  = sum(within_term),
    between_effect = sum(between_term),
    cross_effect   = sum(cross_term),
    entry_effect   = sum(entry_term),
    exit_effect    = sum(exit_term)
  ), by = agg_by]

  period_decomp[, total_effect := data.table::fifelse(
    is.na(avg_compensation_lag), NA_real_,
    within_effect + between_effect + cross_effect + entry_effect + exit_effect
  )]

  period_decomp[]
}
