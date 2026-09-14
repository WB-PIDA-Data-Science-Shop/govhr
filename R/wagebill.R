#' Decompose wage bill growth into headcount, wage, composition, entry,
#' exit, and interaction effects
#'
#' @details
#' Rows are classified per transition as continuing
#' (\eqn{n_{g,t-1}>0}{n_g,t-1>0} and \eqn{n_{g,t}>0}{n_g,t>0}), entrant
#' (\eqn{n_{g,t-1}=0}{n_g,t-1=0}), or exiter (\eqn{n_{g,t}=0}{n_g,t=0}).
#'
#' Entry and exit are self-contained (need only that group's own row):
#' \deqn{\text{entry\_effect} = \sum_{g \in B} n_{g,t} w_{g,t} \qquad \text{exit\_effect} = -\sum_{g \in D} n_{g,t-1} w_{g,t-1}}
#'
#' For continuing groups \eqn{C}, define shares \eqn{s_{g,t} = n_{g,t}/N^C_t}{s_g,t = n_g,t/N^C_t}
#' with \eqn{N^C_t = \sum_{g \in C} n_{g,t}}{N^C_t = sum_{g in C} n_g,t} and
#' \eqn{\bar w^C_t = \sum_{g \in C} s_{g,t} w_{g,t}}{w_bar^C_t = sum s_g,t*w_g,t}.
#' \strong{Only the headcount effect is a pure totals quantity with no
#' group-level counterpart; wage and composition are sums of per-group
#' terms, but the composition term requires the shares (hence the totals)
#' to be computed first:}
#' \deqn{\Delta N^C \bar w^C_{t-1} \;+\; \sum_{g \in C} n_{g,t-1}\,\Delta w_g \;+\; \sum_{g \in C} N^C_{t-1}\,\Delta s_g\, w_{g,t-1} \;+\; \left[\Delta N^C \Delta \bar w^C + \sum_{g \in C} N^C_{t-1}\,\Delta s_g\,\Delta w_g\right]}
#' i.e. headcount_effect + wage_effect + composition_effect + interaction_effect,
#' in that order. Summing the *raw* group identity
#' (\eqn{\Delta n_g w_{g,t-1} + n_{g,t-1}\Delta w_g + \Delta n_g \Delta w_g}{delta_n_g*w_g,t-1 + ...})
#' across groups is a different, valid decomposition of the same total, but
#' it does NOT isolate composition -- the raw headcount term silently
#' contains part of what the share-based version calls composition. Only
#' wage_effect is identical either way (\eqn{n_{g,t-1} \Delta w_g}{n_g,t-1*delta_w_g}
#' happens to need no share correction, since \eqn{n_{g,t-1}=N^C_{t-1}s_{g,t-1}}{n_g,t-1 = N^C_t-1 * s_g,t-1} exactly).
#'
#' \code{summary$component_sum == summary$actual_delta_w} by construction.
#'
#' @param dt data.table of employee-level micro-data, one row per employee
#'   per \code{ref_date}. Must contain \code{ref_date}, \code{id_col},
#'   \code{group_cols}, and \code{wage_col}.
#' @param id_col employee id column (character name).
#' @param group_cols character vector of grouping columns.
#' @param wage_col individual wage column (character name).
#'
#' @return list(by_group, summary). \code{by_group} carries \code{status_grp},
#'   \code{group_wagebill_change} (always valid), and \code{wage_effect_grp}/
#'   \code{composition_effect_grp}/\code{entry_effect_grp}/\code{exit_effect_grp}
#'   where applicable. There is no \code{headcount_effect_grp} column --
#'   the headcount effect exists only at the transition (aggregate) level;
#'   see Details.
#' @importFrom data.table as.data.table setnames setorderv shift fifelse melt
#' @export
compute_wagebill_decomposition <- function(dt, id_col, group_cols, wage_col) {

  dt <- data.table::as.data.table(dt)

  # aggregate once to group x ref_date
  agg <- dt[, .(n = data.table::uniqueN(get(id_col)),
                w = mean(get(wage_col), na.rm = TRUE)),
            by = c(group_cols, "ref_date")]

  # complete the panel: every group x every ref_date; absent = n := 0
  group_keys <- unique(agg[, ..group_cols])
  dates_dt   <- data.table::data.table(ref_date = sort(unique(agg$ref_date)))
  full <- group_keys[rep(seq_len(.N), each = nrow(dates_dt))]
  full[, ref_date := rep(dates_dt$ref_date, times = nrow(group_keys))]
  full <- merge(full, agg, by = c(group_cols, "ref_date"), all.x = TRUE)
  full[is.na(n), n := 0]
  data.table::setorderv(full, c(group_cols, "ref_date"))

  # lag onto the same row (replaces looping over date pairs)
  full[, `:=`(n0 = data.table::shift(n, 1L, type = "lag"),
              w0 = data.table::shift(w, 1L, type = "lag"),
              ref_date_from = data.table::shift(ref_date, 1L, type = "lag")),
       by = group_cols]
  full <- full[!is.na(ref_date_from)]
  data.table::setnames(full, c("n", "w", "ref_date"), c("n1", "w1", "ref_date_to"))

  full[, status_grp := data.table::fifelse(n0 > 0 & n1 > 0, "continuing",
                        data.table::fifelse(n0 == 0 & n1 > 0, "entrant", "exiter"))]
  full[, group_wagebill_change := n1 * data.table::fifelse(is.na(w1), 0, w1) -
                                   n0 * data.table::fifelse(is.na(w0), 0, w0)]

  # continuing-group totals and shares, broadcast onto every continuing row
  # within its own transition -- this is the step the previous version skipped
  full[status_grp == "continuing", `:=`(N0_C = sum(n0), N1_C = sum(n1)),
       by = .(ref_date_from, ref_date_to)]
  full[status_grp == "continuing", `:=`(s0 = n0 / N0_C, s1 = n1 / N1_C)]
  full[status_grp == "continuing", delta_s := s1 - s0]

  # self-contained effects (no shares needed)
  full[, wage_effect_grp := data.table::fifelse(status_grp == "continuing", n0 * (w1 - w0), NA_real_)]
  full[, entry_effect_grp := data.table::fifelse(status_grp == "entrant", n1 * w1, NA_real_)]
  full[, exit_effect_grp := data.table::fifelse(status_grp == "exiter", -n0 * w0, NA_real_)]

  # composition needs shares -- only computable once N0_C/N1_C are attached
  full[, composition_effect_grp := data.table::fifelse(status_grp == "continuing",
                                                         N0_C * delta_s * w0, NA_real_)]

  # transition-level aggregation: headcount effect and the totals-only part
  # of interaction have no group-level counterpart at all
  summary_wide <- full[status_grp == "continuing", .(
    N0_C = N0_C[1], N1_C = N1_C[1],
    wbar0 = sum(s0 * w0), wbar1 = sum(s1 * w1),
    wage_effect = sum(n0 * (w1 - w0)),
    composition_effect = sum(N0_C * delta_s * w0),
    interaction_group_part = sum(N0_C * delta_s * (w1 - w0))
  ), by = .(ref_date_from, ref_date_to)]
  summary_wide[, headcount_effect := (N1_C - N0_C) * wbar0]
  summary_wide[, interaction_effect := (N1_C - N0_C) * (wbar1 - wbar0) + interaction_group_part]
  summary_wide[, c("N0_C", "N1_C", "wbar0", "wbar1", "interaction_group_part") := NULL]

  entry_exit <- full[, .(entry_effect = sum(entry_effect_grp, na.rm = TRUE),
                          exit_effect = sum(exit_effect_grp, na.rm = TRUE)),
                      by = .(ref_date_from, ref_date_to)]
  summary_wide <- merge(summary_wide, entry_exit, by = c("ref_date_from", "ref_date_to"))

  summary_wide[, component_sum := headcount_effect + wage_effect + composition_effect +
                                   interaction_effect + entry_effect + exit_effect]
  summary_wide <- merge(summary_wide,
    full[, .(actual_delta_w = sum(group_wagebill_change)), by = .(ref_date_from, ref_date_to)],
    by = c("ref_date_from", "ref_date_to"))

  summary <- data.table::melt(summary_wide, id.vars = c("ref_date_from", "ref_date_to"),
                               variable.name = "component", value.name = "value")

  list(by_group = full[], summary = summary[])
}