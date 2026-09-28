#' Compute growth decomposition of wagebill
#'
#' @param data A data frame containing the data to be analyzed. It should include columns for the grouping variables, a column for the reference date, and a column for the measure of interest (e.g., gross salary).
#' @param group_cols A character vector specifying the names of the columns to group by.
#' @param measure_col A string specifying the name of the column containing the measure of interest (default is "gross_salary_lcu").
#' @param simplify Logical. If `TRUE` (default), return only `group_cols`,
#'   `ref_date`, `transition_type` and the effect columns
#'   (`employment_effect`, `compensation_effect`, `interaction_effect`,
#'   `entry_effect`, `exit_effect`, `total_effect`). If `FALSE`, also return
#'   the intermediate columns (headcount, compensation, wagebill, their lags
#'   and observation flags). `compute_wage_decomposition()` requires
#'   `simplify = FALSE`.
#'
#' @returns A data.table with one row per group x period, a `transition_type`
#'   label for each row: "start" (panel's first period for this group), "continuing" (observed this
#'   period and last), "entry" (observed this, but not in the last), or
#'   "exit" (not observed in this period but observed in the last period). In addition,
#'   employment, compensation and interaction effects on the wagebill.
#'
#' @details
#' The function explains how each group's wagebill changes from one period
#' to the next, decomposing the change into an effect due to headcount, an effect
#' due to average pay, and an effect due to both moving together.
#'
#' \strong{1. Building the panel.} Rows with a missing value in any of
#' `group_cols` are dropped, and rows with a missing `measure_col` are
#' ignored. For each group \eqn{g} (a combination of `group_cols`) and
#' period \eqn{t} (`ref_date`):
#' \itemize{
#'   \item headcount \eqn{N_{g,t}}: number of records;
#'   \item compensation \eqn{C_{g,t}}: mean of `measure_col`;
#'   \item wagebill \eqn{W_{g,t} = \sum_i w_i = N_{g,t} \, C_{g,t}}{W = sum(w_i) = N * C}.
#' }
#' Every group is then expanded to every period between the first and last
#' `ref_date` in the data, at the frequency detected by
#' `guess_date_frequency()` (year, quarter, month, ...). A group absent in
#' a period gets \eqn{N = 0}, \eqn{W = 0} and \eqn{C} = `NA`, so gaps are
#' explicit rather than silently skipped. Each row is compared with the
#' same group's previous period, \eqn{t-1}.
#'
#' \strong{2. Continuing groups} (observed at \eqn{t-1} and \eqn{t}). Write
#' \eqn{\Delta N = N_t - N_{t-1}}{dN = N_t - N_(t-1)} and
#' \eqn{\Delta C = C_t - C_{t-1}}{dC = C_t - C_(t-1)}. Since
#' \eqn{W_t = (N_{t-1} + \Delta N)(C_{t-1} + \Delta C)}{W_t = (N_(t-1) + dN) * (C_(t-1) + dC)},
#' expanding the product gives us the following identity:
#' \deqn{W_t - W_{t-1} = \underbrace{C_{t-1} \Delta N}_{\text{employment}} +
#'   \underbrace{N_{t-1} \Delta C}_{\text{compensation}} +
#'   \underbrace{\Delta N \, \Delta C}_{\text{interaction}}}{W_t - W_(t-1) = C_(t-1) * dN + N_(t-1) * dC + dN * dC}
#' \itemize{
#'   \item `employment_effect` \eqn{= C_{t-1} \Delta N}{= C_(t-1) * dN}: the
#'     change had pay stayed at last period's average and only headcount
#'     changed.
#'   \item `compensation_effect` \eqn{= N_{t-1} \Delta C}{= N_(t-1) * dC}:
#'     the change had headcount stayed at last period's level and only
#'     average pay changed.
#'   \item `interaction_effect` \eqn{= \Delta N \, \Delta C}{= dN * dC}: the
#'     extra change from both moving at once (new staff paid the new
#'     average).
#' }
#'
#' \strong{3. Entry and exit.} When a group is missing in one of the two
#' periods, \eqn{\Delta C}{dC} is undefined, so the three effects above are
#' `NA` and the entire change is attributed to entry or exit:
#' \itemize{
#'   \item entry (absent at \eqn{t-1}, present at \eqn{t}):
#'     `entry_effect` \eqn{= W_t}{= W_t}.
#'   \item exit (present at \eqn{t-1}, absent at \eqn{t}):
#'     `exit_effect` \eqn{= -W_{t-1}}{= -W_(t-1)}. Later periods in which
#'     the group stays absent are also labelled "exit" but carry
#'     `exit_effect` = 0, as nothing further changed. A group absent from
#'     the panel's first period is likewise "exit" with 0 until it enters.
#' }
#' A group that disappears and later reappears therefore shows one exit,
#' zero-effect "exit" rows during the gap, and one entry.
#'
#' \strong{4. Total effect.} `total_effect` is the sum of the effects that
#' apply to the row, so it always equals \eqn{W_t - W_{t-1}}{W_t - W_(t-1)}
#' (with \eqn{W = 0} when unobserved). It is `NA` in the panel's first
#' period ("start"), which has no baseline. Consequently, summing
#' `total_effect` over time for a group recovers its wagebill in the last
#' period minus its wagebill in the first period.
#'
#' @importFrom data.table .N := shift setorderv fcase fifelse
#' @importFrom tidyr complete nesting
#' @export
compute_growth_decomposition <- function(
  data,
  group_cols = NULL,
  measure_col = "gross_salary_lcu",
  simplify = TRUE
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

  # complete dataset with all combinations of group_cols and ref_date, filling in missing values
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

  if (simplify) {
    out_cols <- c(
      group_cols, "ref_date", "transition_type", "employment_effect",
      "compensation_effect", "interaction_effect", "entry_effect",
      "exit_effect", "total_effect"
    )
  }

  summary_table[, ..out_cols]
}

#' Decompose average-compensation growth
#'
#' Explains why average compensation across the whole workforce changes from
#' one period to the next: because pay changed inside groups, or because
#' staff shifted between higher- and lower-paid groups. This complements
#' [compute_growth_decomposition()], which explains each group's own
#' wagebill.
#'
#' @param growth_decomp Output of `compute_growth_decomposition(simplify = FALSE)`.
#' @param group_cols Optional character vector of columns identifying a
#'   higher-level unit (e.g. "country_code") within which the decomposition
#'   is computed separately. Must be a subset of the grouping columns used to
#'   build `growth_decomp`. `NULL` pools all groups into one workforce.
#' @param simplify Logical. If `TRUE` (default), return only `group_cols`,
#'   `ref_date` and the effect columns (`within_effect`, `between_effect`,
#'   `cross_effect`, `entry_effect`, `exit_effect`, `total_effect`). If
#'   `FALSE`, also return total headcount, total wagebill and average
#'   compensation, each for the current and the previous period
#'   (`total_headcount`, `total_headcount_lag`, `total_wagebill`,
#'   `total_wagebill_lag`, `avg_compensation`, `avg_compensation_lag`).
#'
#' @returns A data.table with one row per reference date (per unit of
#'   `group_cols`, if given) and the effects described in Details.
#'   `total_effect` is the change in average compensation; it is `NA` when
#'   either period has no employees, which includes the panel's first period.
#'
#' @details
#' \strong{Setup.} A group \eqn{g} is a row of `growth_decomp` (one
#' combination of the grouping columns used there). In period \eqn{t}, let
#' \eqn{N_{g,t}}{N_g,t} be the group's headcount, \eqn{C_{g,t}}{C_g,t} its
#' average compensation, \eqn{N_t = \sum_g N_{g,t}}{N_t = sum_g N_g,t} the
#' total headcount and \eqn{s_{g,t} = N_{g,t} / N_t}{s_g,t = N_g,t / N_t} the
#' group's share of headcount. Average compensation of the workforce is total
#' wagebill over total headcount, which is the share-weighted mean of group
#' averages:
#' \deqn{\bar{C}_t = \frac{W_t}{N_t} = \sum_g s_{g,t} \, C_{g,t}}{avgC_t = W_t / N_t = sum_g s_g,t * C_g,t}
#' As in [compute_growth_decomposition()], each group is continuing
#' (\eqn{g \in K}{g in K}: present in both periods), entering
#' (\eqn{g \in E}{g in E}: present only in \eqn{t}) or exiting
#' (\eqn{g \in X}{g in X}: present only in \eqn{t-1}).
#'
#' \strong{Decomposition.} Following Foster, Haltiwanger and Krizan (2001),
#' with \eqn{\Delta}{d} the change from \eqn{t-1} to \eqn{t}:
#' \deqn{\Delta \bar{C}_t =
#'   \underbrace{\sum_{g \in K} s_{g,t-1} \Delta C_g}_{\text{within}} +
#'   \underbrace{\sum_{g \in K} \Delta s_g (C_{g,t-1} - \bar{C}_{t-1})}_{\text{between}} +
#'   \underbrace{\sum_{g \in K} \Delta s_g \, \Delta C_g}_{\text{cross}} +
#'   \underbrace{\sum_{g \in E} s_{g,t} (C_{g,t} - \bar{C}_{t-1})}_{\text{entry}} -
#'   \underbrace{\sum_{g \in X} s_{g,t-1} (C_{g,t-1} - \bar{C}_{t-1})}_{\text{exit}}}{d avgC = within + between + cross + entry + exit}
#' \itemize{
#'   \item \strong{Within}
#'     (\eqn{\sum_K s_{g,t-1} \Delta C_g}{sum_K s_g,t-1 * dC_g}): pay growth
#'     inside continuing groups, weighted by their previous-period headcount
#'     shares. Pure pay effect.
#'   \item \strong{Between}
#'     (\eqn{\sum_K \Delta s_g (C_{g,t-1} - \bar{C}_{t-1})}{sum_K ds_g * (C_g,t-1 - avgC_t-1)}):
#'     movement of headcount toward groups paid above the previous period's
#'     overall average (positive) or below it (negative), at previous-period
#'     pay. Pure composition effect.
#'   \item \strong{Cross}
#'     (\eqn{\sum_K \Delta s_g \, \Delta C_g}{sum_K ds_g * dC_g}): positive
#'     when the groups gaining headcount share are also the ones whose pay
#'     grows fastest.
#'   \item \strong{Entry}
#'     (\eqn{\sum_E s_{g,t} (C_{g,t} - \bar{C}_{t-1})}{sum_E s_g,t * (C_g,t - avgC_t-1)}):
#'     new groups raise the average if they pay more than the previous
#'     period's overall average.
#'   \item \strong{Exit}
#'     (\eqn{-\sum_X s_{g,t-1} (C_{g,t-1} - \bar{C}_{t-1})}{-sum_X s_g,t-1 * (C_g,t-1 - avgC_t-1)}):
#'     departing groups raise the average if they were paid less than the
#'     previous period's overall average.
#' }
#'
#' \strong{Proof of identity.} Shares sum to one in each period, so
#' subtracting the previous period's average compensation from every group
#' average leaves the change unaltered:
#' \deqn{\Delta \bar{C}_t = \sum_{g \in K \cup E} s_{g,t} (C_{g,t} - \bar{C}_{t-1}) -
#'   \sum_{g \in K \cup X} s_{g,t-1} (C_{g,t-1} - \bar{C}_{t-1})}{d avgC = sum_(K,E) s_g,t (C_g,t - avgC_t-1) - sum_(K,X) s_g,t-1 (C_g,t-1 - avgC_t-1)}
#' Substituting \eqn{s_{g,t} = s_{g,t-1} + \Delta s_g}{s_g,t = s_g,t-1 + ds_g}
#' and \eqn{C_{g,t} = C_{g,t-1} + \Delta C_g}{C_g,t = C_g,t-1 + dC_g} for
#' continuing groups yields the within, between and cross terms; the entry
#' and exit terms are what remain. Measuring against the previous period's
#' average is what gives the between, entry and exit terms their meaning:
#' moving staff raises the average only if they move to groups that are
#' paid above average.
#'
#' @references Foster, L., Haltiwanger, J. and Krizan, C. J. (2001).
#'   Aggregate productivity growth: lessons from microeconomic evidence. In
#'   Hulten, C. R., Dean, E. R. and Harper, M. J. (eds.), *New Developments
#'   in Productivity Analysis*, pp. 303-372. University of Chicago Press.
#'
#' @importFrom data.table := fifelse
#' @export
compute_wage_decomposition <- function(
  growth_decomp,
  group_cols = NULL,
  simplify = TRUE
) {

  dt <- data.table::copy(data.table::as.data.table(growth_decomp))
  validate_columns_exist(
    dt,
    c("headcount", "headcount_lag", "wagebill", "wagebill_lag", "compensation",
      "compensation_lag", "delta_compensation", "observed_lag"),
    "growth_decomp (use compute_growth_decomposition(simplify = FALSE))"
  )
  agg_by <- c(group_cols, "ref_date")

  dt[, `:=`(
    total_headcount     = sum(headcount),
    total_headcount_lag = sum(headcount_lag, na.rm = TRUE),
    total_wagebill      = sum(wagebill),
    total_wagebill_lag  = sum(wagebill_lag, na.rm = TRUE)
  ), by = agg_by]

  dt[, `:=`(
    avg_compensation     = data.table::fifelse(
      total_headcount > 0, total_wagebill / total_headcount, NA_real_
    ),
    avg_compensation_lag = data.table::fifelse(
      total_headcount_lag > 0, total_wagebill_lag / total_headcount_lag, NA_real_
    )
  )]

  dt[, `:=`(
    share     = data.table::fifelse(
      total_headcount > 0, headcount / total_headcount, NA_real_
    ),
    share_lag = data.table::fifelse(
      total_headcount_lag > 0, headcount_lag / total_headcount_lag, NA_real_
    )
  )]
  dt[, delta_share := share - share_lag]

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
    total_headcount      = total_headcount[1],
    total_headcount_lag  = total_headcount_lag[1],
    total_wagebill       = total_wagebill[1],
    total_wagebill_lag   = total_wagebill_lag[1],
    avg_compensation     = avg_compensation[1],
    avg_compensation_lag = avg_compensation_lag[1],
    within_effect  = sum(within_term),
    between_effect = sum(between_term),
    cross_effect   = sum(cross_term),
    entry_effect   = sum(entry_term),
    exit_effect    = sum(exit_term)
  ), by = agg_by]

  period_decomp[, total_effect := data.table::fifelse(
    is.na(avg_compensation) | is.na(avg_compensation_lag), NA_real_,
    within_effect + between_effect + cross_effect + entry_effect + exit_effect
  )]

  if (simplify) {
    out_cols <- c(
      group_cols, "ref_date", "within_effect", "between_effect",
      "cross_effect", "entry_effect", "exit_effect", "total_effect"
    )
    period_decomp <- period_decomp[, ..out_cols]
  }

  period_decomp[]
}
