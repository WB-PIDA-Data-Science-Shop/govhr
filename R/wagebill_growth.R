#' Compute growth decomposition of wagebill
#'
#' @param data Data frame or remote table (`tbl_dbi`) containing a `ref_date`
#'   column, the grouping columns and the measure.
#' @param group_cols Character vector of columns to group by, or `NULL` for no
#'   grouping. Must not include `ref_date`.
#' @param measure_col Character. Numeric column to decompose. Default
#'   `"gross_salary_lcu"`.
#' @param simplify Logical. If `TRUE` (default), return only `group_cols`,
#'   `ref_date`, `transition_type` and the effect columns
#'   (`employment_effect`, `wage_effect`, `interaction_effect`,
#'   `entry_effect`, `exit_effect`, `total_effect`). If `FALSE`, also return
#'   the intermediate columns (`headcount`, `wage`, `wagebill`, their lags,
#'   `delta_wage`, `is_observed` and `observed_lag`).
#'   [compute_wage_decomposition()] requires `simplify = FALSE`.
#' @param ... Arguments passed to methods.
#'
#' @returns A data.table (a lazy table for `tbl_dbi` input) with one row per
#'   group x reference date, containing the grouping columns, `ref_date`,
#'   `transition_type` and the columns selected by `simplify`.
#'   `transition_type` is "start" (panel's first period), "continuing"
#'   (observed this period and last), "entry" (observed this period but not
#'   last) or "exit" (not observed this period).
#'
#' @details
#' The function explains how each group's wagebill changes from one period
#' to the next, decomposing the change into an effect due to headcount, an effect
#' due to average pay, and an effect due to both moving together.
#'
#' \strong{1. Building the panel.} Rows with a missing value in `measure_col`
#' or any of `group_cols` are dropped. For each group \eqn{g} (a combination
#' of `group_cols`) and period \eqn{t} (`ref_date`):
#' \itemize{
#'   \item headcount \eqn{N_{g,t}}: number of records;
#'   \item wage \eqn{C_{g,t}}: mean of `measure_col`;
#'   \item wagebill \eqn{W_{g,t} = \sum_i w_i = N_{g,t} \, C_{g,t}}{W = sum(w_i) = N * C}.
#' }
#' Every group is then expanded to every `ref_date` in `data`. A group absent
#' in a period gets \eqn{N = 0}, \eqn{W = 0} and \eqn{C} = `NA`, so gaps are
#' explicit rather than silently skipped. Reference dates absent from the
#' whole of `data` are not added. Each row is compared with the same group's
#' previous reference date, \eqn{t-1}.
#'
#' \strong{2. Continuing groups} (observed at \eqn{t-1} and \eqn{t}). Write
#' \eqn{\Delta N = N_t - N_{t-1}}{dN = N_t - N_(t-1)} and
#' \eqn{\Delta C = C_t - C_{t-1}}{dC = C_t - C_(t-1)} (`delta_wage`). Since
#' \eqn{W_t = (N_{t-1} + \Delta N)(C_{t-1} + \Delta C)}{W_t = (N_(t-1) + dN) * (C_(t-1) + dC)},
#' expanding the product gives us the following identity:
#' \deqn{W_t - W_{t-1} = \underbrace{C_{t-1} \Delta N}_{\text{employment}} +
#'   \underbrace{N_{t-1} \Delta C}_{\text{wage}} +
#'   \underbrace{\Delta N \, \Delta C}_{\text{interaction}}}{W_t - W_(t-1) = C_(t-1) * dN + N_(t-1) * dC + dN * dC}
#' \itemize{
#'   \item `employment_effect` \eqn{= C_{t-1} \Delta N}{= C_(t-1) * dN}: the
#'     change had pay stayed at last period's average and only headcount
#'     changed.
#'   \item `wage_effect` \eqn{= N_{t-1} \Delta C}{= N_(t-1) * dC}:
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
#' @export
compute_growth_decomposition <- function(data, ...) {
  UseMethod("compute_growth_decomposition")
}

#' @rdname compute_growth_decomposition
#' @importFrom data.table .N := shift setorderv fcase fifelse fcoalesce
#' @export
compute_growth_decomposition.data.frame <- function(
  data,
  group_cols = NULL,
  measure_col = "gross_salary_lcu",
  simplify = TRUE,
  ...
) {
  if ("ref_date" %in% group_cols) {
    stop("`ref_date` should not be included in `group_cols`")
  }

  by_cols <- c(group_cols, "ref_date")

  dt <- data.table::as.data.table(data)
  calendar <- unique(dt[, "ref_date"])

  keep <- stats::complete.cases(dt[, c(measure_col, group_cols), with = FALSE])

  wagebill <- dt[
    keep,
    .(
      headcount = .N,
      wagebill  = sum(get(measure_col)),
      wage      = mean(get(measure_col))
    ),
    by = by_cols
  ]

  # complete the group x date panel, as in the tbl_dbi method, so shift()
  # always refers to the previous period of the calendar
  panel <- calendar

  if (!is.null(group_cols)) {
    panel <- unique(wagebill[, ..group_cols])[
      ,
      .(ref_date = calendar$ref_date),
      by = group_cols
    ]
  }

  panel <- wagebill[panel, on = by_cols]

  panel[, `:=`(
    is_observed = !is.na(headcount),
    headcount   = data.table::fcoalesce(as.numeric(headcount), 0),
    wagebill    = data.table::fcoalesce(wagebill, 0)
  )]

  data.table::setorderv(panel, by_cols)

  panel[,
    `:=`(
      headcount_lag = data.table::shift(headcount, type = "lag"),
      wage_lag      = data.table::shift(wage, type = "lag"),
      wagebill_lag  = data.table::shift(wagebill, type = "lag"),
      observed_lag  = data.table::shift(is_observed, type = "lag")
    ),
    by = group_cols
  ]

  panel[, transition_type := data.table::fcase(
    !is_observed,        "exit",
    is.na(observed_lag), "start",
    observed_lag,        "continuing",
    default = "entry"
  )]

  # deltas are only defined for continuing groups, NA propagates to the
  # employment, wage and interaction effects
  panel[, `:=`(
    delta_headcount = data.table::fifelse(
      transition_type == "continuing", headcount - headcount_lag, NA_real_
    ),
    delta_wage = data.table::fifelse(
      transition_type == "continuing", wage - wage_lag, NA_real_
    )
  )]

  panel[, `:=`(
    employment_effect  = wage_lag * delta_headcount,
    wage_effect        = headcount_lag * delta_wage,
    interaction_effect = delta_headcount * delta_wage,
    entry_effect = data.table::fifelse(
      transition_type == "entry", wagebill, NA_real_
    ),
    exit_effect = data.table::fifelse(
      transition_type == "exit",
      data.table::fifelse(observed_lag %in% TRUE, -wagebill_lag, 0),
      NA_real_
    )
  )]

  # entry and exit effects are exclusive, and both are NA at start
  panel[, total_effect := data.table::fifelse(
    transition_type == "continuing",
    employment_effect + wage_effect + interaction_effect,
    data.table::fcoalesce(entry_effect, exit_effect)
  )]

  out_cols <- c(
    by_cols, "transition_type", "headcount", "headcount_lag", "wage",
    "wage_lag", "employment_effect", "wage_effect", "interaction_effect",
    "entry_effect", "delta_wage", "exit_effect", "total_effect", "wagebill",
    "wagebill_lag", "is_observed", "observed_lag"
  )

  if (simplify) {
    out_cols <- c(
      by_cols, "transition_type", "employment_effect", "wage_effect",
      "interaction_effect", "entry_effect", "exit_effect", "total_effect"
    )
  }

  panel[, ..out_cols]
}

#' @rdname compute_growth_decomposition
#' @export
compute_growth_decomposition.tbl_dbi <- function(
  data,
  group_cols = NULL,
  measure_col = "gross_salary_lcu",
  simplify = TRUE,
  ...
) {
  if("ref_date" %in% group_cols){
    stop("`ref_date` should not be included in `group_cols`")
  }

  group_cols_with_date <- c(group_cols, "ref_date")
  measure <- rlang::sym(measure_col)

  wagebill <- data |>
    drop_missing(
      c(measure_col, group_cols)
    ) |>
    summarise(
      headcount = n(),
      wagebill = sum(!!measure, na.rm = TRUE),
      wage = mean(!!measure, na.rm = TRUE),
      .by = all_of(group_cols_with_date)
    )

  # complete the group x date panel, as in compute_wagebill(), so lag()
  # always refers to the previous period of the calendar
  calendar <- data |>
    distinct(ref_date)

  panel <- calendar

  if(!is.null(group_cols)){
    group_values <- wagebill |>
      select(all_of(group_cols)) |>
      distinct()

    panel <- calendar |>
      mutate(key = 1) |>
      inner_join(
        group_values |> mutate(key = 1),
        by = "key"
      ) |>
      select(-key)
  }

  decomposition <- panel |>
    left_join(
      wagebill,
      by = group_cols_with_date
    ) |>
    mutate(
      is_observed = !is.na(headcount),
      headcount = coalesce(headcount, 0),
      wagebill = coalesce(wagebill, 0)
    ) |>
    mutate(
      headcount_lag = lag(headcount, order_by = ref_date),
      wage_lag = lag(wage, order_by = ref_date),
      wagebill_lag = lag(wagebill, order_by = ref_date),
      observed_lag = lag(is_observed, order_by = ref_date),
      .by = all_of(group_cols)
    ) |>
    mutate(
      transition_type = if_else(
        !is_observed, "exit",
        if_else(
          is.na(observed_lag), "start",
          if_else(observed_lag, "continuing", "entry")
        )
      )
    ) |>
    mutate(
      # deltas are only defined for continuing groups, NA propagates to the
      # employment, wage and interaction effects
      delta_headcount = if_else(transition_type == "continuing", headcount - headcount_lag, NA_real_),
      delta_wage = if_else(transition_type == "continuing", wage - wage_lag, NA_real_),
      employment_effect = wage_lag * delta_headcount,
      wage_effect = headcount_lag * delta_wage,
      interaction_effect = delta_headcount * delta_wage,
      entry_effect = if_else(transition_type == "entry", wagebill, NA_real_),
      exit_effect = if_else(
        transition_type == "exit",
        if_else(coalesce(observed_lag, FALSE), -wagebill_lag, 0),
        NA_real_
      ),
      # entry and exit effects are exclusive, and both are NA at start
      total_effect = if_else(
        transition_type == "continuing",
        employment_effect + wage_effect + interaction_effect,
        coalesce(entry_effect, exit_effect)
      )
    ) |>
    select(
      all_of(group_cols_with_date),
      transition_type, headcount, headcount_lag, wage, wage_lag,
      employment_effect, wage_effect, interaction_effect, entry_effect,
      delta_wage, exit_effect, total_effect, wagebill, wagebill_lag,
      is_observed, observed_lag
    )

  if (simplify) {
    decomposition <- decomposition |>
      select(
        all_of(group_cols_with_date),
        transition_type, employment_effect, wage_effect, interaction_effect,
        entry_effect, exit_effect, total_effect
      )
  }

  decomposition
}

#' Decompose average-wage growth
#'
#' Explains why the average wage across the whole workforce changes from
#' one period to the next: because pay changed inside groups, or because
#' staff shifted between higher- and lower-paid groups. This complements
#' [compute_growth_decomposition()], which explains each group's own
#' wagebill.
#'
#' @param growth_decomp Output of
#'   `compute_growth_decomposition(simplify = FALSE)`.
#' @param group_cols Optional character vector of columns identifying a
#'   higher-level unit (e.g. "country_code") within which the decomposition
#'   is computed separately. Must be a subset of the grouping columns used to
#'   build `growth_decomp`. `NULL` pools all groups into one workforce.
#' @param simplify Logical. If `TRUE` (default), return only `group_cols`,
#'   `ref_date` and the effect columns (`within_effect`, `between_effect`,
#'   `cross_effect`, `entry_effect`, `exit_effect`, `total_effect`). If
#'   `FALSE`, also return total headcount, total wagebill and average
#'   wage, each for the current and the previous period
#'   (`total_headcount`, `total_headcount_lag`, `total_wagebill`,
#'   `total_wagebill_lag`, `avg_wage`, `avg_wage_lag`).
#'
#' @returns A data.table with one row per reference date (per unit of
#'   `group_cols`, if given) and the effects described in Details.
#'   `total_effect` is the change in average wage; it is `NA` when
#'   either period has no employees, which includes the panel's first period.
#'
#' @details
#' \strong{Setup.} A group \eqn{g} is a row of `growth_decomp` (one
#' combination of the grouping columns used there). In period \eqn{t}, let
#' \eqn{N_{g,t}}{N_g,t} be the group's headcount, \eqn{C_{g,t}}{C_g,t} its
#' average wage (`wage`), \eqn{N_t = \sum_g N_{g,t}}{N_t = sum_g N_g,t} the
#' total headcount and \eqn{s_{g,t} = N_{g,t} / N_t}{s_g,t = N_g,t / N_t} the
#' group's share of headcount. The average wage of the workforce is total
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
#' subtracting the previous period's average wage from every group
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
    c("headcount", "headcount_lag", "wagebill", "wagebill_lag", "wage",
      "wage_lag", "delta_wage", "observed_lag"),
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
    avg_wage     = data.table::fifelse(
      total_headcount > 0, total_wagebill / total_headcount, NA_real_
    ),
    avg_wage_lag = data.table::fifelse(
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
      transition_type == "continuing", share_lag * delta_wage, 0
    ),
    between_term = data.table::fifelse(
      transition_type == "continuing", delta_share * (wage_lag - avg_wage_lag), 0
    ),
    cross_term   = data.table::fifelse(
      transition_type == "continuing", delta_share * delta_wage, 0
    ),
    entry_term   = data.table::fifelse(
      transition_type == "entry", share * (wage - avg_wage_lag), 0
    ),
    exit_term    = data.table::fifelse(
      transition_type == "exit" & observed_lag %in% TRUE,
      -share_lag * (wage_lag - avg_wage_lag), 0
    )
  )]

  period_decomp <- dt[, .(
    total_headcount      = total_headcount[1],
    total_headcount_lag  = total_headcount_lag[1],
    total_wagebill       = total_wagebill[1],
    total_wagebill_lag   = total_wagebill_lag[1],
    avg_wage     = avg_wage[1],
    avg_wage_lag = avg_wage_lag[1],
    within_effect  = sum(within_term),
    between_effect = sum(between_term),
    cross_effect   = sum(cross_term),
    entry_effect   = sum(entry_term),
    exit_effect    = sum(exit_term)
  ), by = agg_by]

  period_decomp[, total_effect := data.table::fifelse(
    is.na(avg_wage) | is.na(avg_wage_lag), NA_real_,
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
