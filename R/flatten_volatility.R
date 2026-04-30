## Lookup table mapping vol_fn codes to human-readable labels.
## Add a row here whenever a new volatility function is added to define_vol_fns().
.vol_fn_labels <- data.table::data.table(
  vol_fn       = c("pct_change", "sd", "cv",
                   "rolling_sd", "rolling_cv", "rolling_pct_change"),
  vol_fn_label = c("Percent Change", "Standard Deviation", "Coefficient of Variation",
                   "Rolling Standard Deviation", "Rolling Coefficient of Variation",
                   "Rolling Percent Change")
)

#' Flatten a nested volatility list into a single labelled data.table
#'
#' @description
#' Takes the nested list produced by the volatility section of
#' [`compute_qualitycontrol()`] (or built manually from
#' [`compute_volatility()`] calls) and collapses it into a single tidy
#' `data.table`.  Dictionary labels are joined for the grouping variable and
#' the measured indicator, and a human-readable volatility-function label is
#' added via an internal lookup table.
#'
#' @param vol_list A named list (possibly nested) whose leaves are
#'   `data.table`s returned by [`compute_volatility()`].
#' @param dict A data.frame with at least columns `variable_id` and
#'   `variable_name` used to look up human labels.  Defaults to
#'   `govhr::dictionary`.
#'
#' @return A `data.table` with columns:
#' \describe{
#'   \item{`stat_type`}{Top-level list element name (e.g. `"salary_vol"`).}
#'   \item{`vol_fn`}{Code name of the volatility function (e.g. `"pct_change"`).}
#'   \item{`vol_fn_label`}{Human label (e.g. `"Percent Change"`).}
#'   \item{`group_var`}{Column name(s) used as the grouping variable.}
#'   \item{`group_var_label`}{Dictionary label for `group_var` (NA for composites).}
#'   \item{`group_val`}{Value of the grouping variable (character).}
#'   \item{`ref_date`}{Time period.}
#'   \item{`indicator`}{Aggregated indicator code (e.g. `"gross_salary_lcu_sum"`).}
#'   \item{`indicator_label`}{Dictionary label for the base variable.}
#'   \item{`value`}{Aggregated numeric value.}
#'   \item{`vol_stat`}{Computed volatility statistic.}
#' }
#'
#' @importFrom data.table as.data.table copy rbindlist setcolorder setnames
#' @export
flatten_volatility <- function(vol_list, dict = govhr::dictionary) {

  .fixed_cols  <- c("indicator", "ref_date", "value")
  .vol_fn_cols <- c("pct_change", "sd", "cv",
                    "rolling_sd", "rolling_cv", "rolling_pct_change")

  dict_dt <- data.table::as.data.table(dict)[, .(variable_id, variable_name)]

  ## ------------------------------------------------------------------
  ## Recursive flattener: walks the list, yields a list of data.tables
  ## path[1] = top-level stat_type name (fixed at first level of recursion)
  ## ------------------------------------------------------------------
  .flatten <- function(x, path = character(0)) {
    if (data.table::is.data.table(x)) {

      vfn     <- intersect(names(x), .vol_fn_cols)           # which vol_fn column?
      grp_col <- setdiff(names(x), c(.fixed_cols, vfn))      # group column(s)

      out <- data.table::copy(x)
      
      ## if group columns are specified, lets 
      if (length(grp_col) > 0) {
        out[, group_val := do.call(paste, c(.SD, list(sep = " | "))),
            .SDcols = grp_col]
        out[, group_var := paste(grp_col, collapse = " | ")]
        out[, (grp_col) := NULL]
      } else {
        out[, group_var := NA_character_]
        out[, group_val := NA_character_]
      }

      out[, stat_type := path[[1]]]
      out[, vol_fn    := if (length(vfn) > 0) vfn[[1]] else NA_character_]

      if (length(vfn) > 0) data.table::setnames(out, vfn[[1]], "vol_stat")

      list(out)

    } else if (is.list(x)) {
      nms <- names(x)
      unlist(
        lapply(seq_along(x), \(i) {
          ## stat_type is always the first-level name; deeper levels just navigate
          new_path <- if (length(path) == 0) nms[[i]] else path
          .flatten(x[[i]], path = new_path)
        }),
        recursive = FALSE
      )
    }
  }

  flat_list <- .flatten(vol_list)

  if (length(flat_list) == 0L) {
    return(data.table::data.table(
      stat_type       = character(0),
      vol_fn          = character(0),
      vol_fn_label    = character(0),
      group_var       = character(0),
      group_var_label = character(0),
      group_val       = character(0),
      ref_date        = as.Date(character(0)),
      indicator       = factor(),
      indicator_label = character(0),
      value           = numeric(0),
      vol_stat        = numeric(0)
    ))
  }

  out <- data.table::rbindlist(flat_list, fill = TRUE)

  ## ------------------------------------------------------------------
  ## Join vol_fn labels
  ## ------------------------------------------------------------------
  out <- .vol_fn_labels[out, on = "vol_fn"]

  ## ------------------------------------------------------------------
  ## Derive base variable_id by stripping the trailing agg_fn suffix
  ## e.g. "gross_salary_lcu_sum" -> "gross_salary_lcu"
  ## ------------------------------------------------------------------
  agg_suffixes <- paste0("_(", paste(
    c("sum", "mean", "count_unique", "min", "max", "median", "sd"), collapse = "|"
  ), ")$")

  out[, .ind_base := sub(agg_suffixes, "", as.character(indicator))]

  ## join indicator label
  out <- dict_dt[, .(variable_id, indicator_label = variable_name)][
    out, on = c(variable_id = ".ind_base"), mult = "first"
  ]
  out[, variable_id := NULL]

  ## join group_var label (only meaningful for single-column group_var)
    out[, .grp_base := ifelse(grepl(" | ", group_var, fixed = TRUE), NA_character_, group_var)]
  out <- dict_dt[, .(variable_id, group_var_label = variable_name)][
    out, on = c(variable_id = ".grp_base"), mult = "first"
  ]
  out[, c("variable_id") := NULL]

  ## ------------------------------------------------------------------
  ## Final column order
  ## ------------------------------------------------------------------
  data.table::setcolorder(out, intersect(
    c("stat_type", "vol_fn", "vol_fn_label",
      "group_var", "group_var_label", "group_val",
      "ref_date", "indicator", "indicator_label",
      "value", "vol_stat"),
    names(out)
  ))

  out[]
}
