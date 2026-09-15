#' Compute growth decomposition of wagebill
#'
#' @param .data A data frame containing the data to be analyzed. It should include columns for the grouping variables, a column for the reference date, and a column for the measure of interest (e.g., gross salary).
#' @param group_cols A character vector specifying the names of the columns to group by.
#' @param measure_col A character string specifying the name of the column containing the measure of interest (default is "gross_salary_lcu").
#' 
#' @return A data.table with headcount, compensation, wagebill, the
#'   continuing-period decomposition (employment/compensation/interaction
#'   effects), entry/exit effects for panel gaps, and a `transition_type`
#'   label for each row: "start" (first period observed, no baseline),
#'   "continuing" (both this period and the prior period observed),
#'   "entry" (reappears after a gap, or a genuinely new group_cols
#'   combination), "exit" (last observed period before a gap begins), or
#'   "gap" (an unobserved period that is not itself a boundary).
#'
#' @importFrom data.table .N .SD := shift setorderv fcase
#' @importFrom dplyr all_of select
#' @importFrom tidyr complete nesting
#' @export
compute_growth_decomposition <- function(
  .data,
  group_cols = NULL,
  measure_col = "gross_salary_lcu"
) {
  dt <- data.table::as.data.table(.data)

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

  min_ref_date <- min(.data$ref_date)
  max_ref_date <- max(.data$ref_date)
  date_interval <- guess_date_frequency(.data)

  # nesting() preserves only observed group_cols combinations, so a group
  # that starts reporting mid-panel gets real "entry" rows, not fabricated
  # combinations that never existed
  if (!is.null(group_cols)) {
    summary_table <- summary_table |>
      tidyr::complete(
        tidyr::nesting(!!!rlang::syms(group_cols)),
        ref_date = seq(min_ref_date, max_ref_date, by = date_interval),
        fill = list(headcount = 0, compensation = NA_real_)
      )
  } else {
    summary_table <- summary_table |>
      tidyr::complete(ref_date, fill = list(headcount = 0, compensation = NA_real_))
  }

  summary_table <- data.table::as.data.table(summary_table)
  summary_table[is.na(is_observed), is_observed := FALSE]

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

  # classify every row's relationship to the prior period
  summary_table[, transition_type := data.table::fcase(
    is.na(observed_lag) & is_observed,   "start",
    is.na(observed_lag) & !is_observed,  "gap",
    observed_lag & is_observed,          "continuing",
    observed_lag & !is_observed,         "exit",
    !observed_lag & is_observed,         "entry",
    !observed_lag & !is_observed,        "gap"
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

  # these three effects only mean something when comparing two real
  # observations -- null them out everywhere else so an entry/exit/gap
  # row can't masquerade as ordinary continuing-period growth
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
  summary_table[transition_type == "exit", exit_effect := -wagebill_lag]

  summary_table[, total_effect := data.table::fcase(
    transition_type == "continuing",
    employment_effect + compensation_effect + interaction_effect,
    transition_type == "entry", entry_effect,
    transition_type == "exit", exit_effect,
    default = NA_real_
  )]

  out_cols <- c(
    group_cols, "ref_date", "transition_type", "headcount", "headcount_lag",
    "compensation", "compensation_lag", "employment_effect",
    "compensation_effect", "interaction_effect", "entry_effect",
    "exit_effect", "total_effect", "wagebill", "transition_type"
  )

  summary_table[, ..out_cols] |>
    data.table::as.data.table()
}