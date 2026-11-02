#' Fit a wage model with fixed effects
#'
#' Fits a linear wage model based on a set of predictors and fixed effects.
#'
#' @param data A data frame containing the outcome, predictor, and fixed
#'   effects columns.
#' @param outcome_var Character. Name of the outcome column.
#'   Default `"gross_salary_lcu"`.
#' @param predictor_vars A character vector. Names of predictor columns.
#'   Default `c("contract_type", "occupation_native", "educat7", "whours", "paygrade")`.
#' @param fixed_effects_vars Character vector, or `NULL` to fit without fixed
#'   effects. Names of fixed effects columns.
#'   Default `c("personnel_id", "est_id", "ref_date")`.
#'
#' @details
#' `outcome_var` and `fixed_effects_vars` are required to be present in
#' `data`. `predictor_vars` are covariates and are dropped with a
#' warning rather than failing the whole call; if none remain, the model is
#' fit with an intercept-only right-hand side (`1`).
#'
#' @returns A `fixest` model object, as returned by `fixest::feols()`.
#'
#' @export
model_wage <- function(
  data,
  outcome_var = "gross_salary_lcu",
  predictor_vars = c(
    "contract_type",
    "occupation_native",
    "educat7",
    "whours",
    "paygrade"
  ),
  fixed_effects_vars = c("personnel_id", "est_id", "ref_date")
) {
  if (!outcome_var %in% names(data)) {
    stop("`outcome_var` not found in `data`: ", outcome_var)
  }

  missing_fixed_effects <- setdiff(fixed_effects_vars, names(data))
  if (length(missing_fixed_effects) > 0) {
    stop(
      "`fixed_effects_vars` not found in `data`: ",
      paste(missing_fixed_effects, collapse = ", ")
    )
  }

  missing_predictors <- setdiff(predictor_vars, names(data))
  if (length(missing_predictors) > 0) {
    warning(
      "dropping `predictor_vars` not found in `data`: ",
      paste(missing_predictors, collapse = ", ")
    )
    predictor_vars <- intersect(predictor_vars, names(data))
  }

  predictor_rhs <- if (length(predictor_vars) > 0) {
    paste(predictor_vars, collapse = " + ")
  } else {
    "1"
  }

  model_formula <- paste(outcome_var, "~", predictor_rhs)

  if (!is.null(fixed_effects_vars) && length(fixed_effects_vars) > 0) {
    model_formula <- paste(
      model_formula,
      "|",
      paste(fixed_effects_vars, collapse = " + ")
    )
  }

  fixest::feols(as.formula(model_formula), data = data)
}
