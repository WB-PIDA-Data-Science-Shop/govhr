#' Fit a wage model with fixed effects
#'
#' Fits a linear wage model based on a set of predictors and fixed effects.
#'
#' @param data A data frame containing the outcome, predictor, and fixed
#'   effects columns.
#' @param outcome_var Character. Name of the outcome column.
#'   Default `"gross_salary_lcu"`.
#' @param predictor_vars Character vector. Names of predictor columns.
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
#' @return A `fixest` model object, as returned by `fixest::feols()`.
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

#' Plot a wage model fit
#'
#' @param model_fit A `fixest` model object, as returned by `model_wage()`.
#' @return A `ggplot` object visualizing the model coefficients.
#' @export
#'
#' @importFrom ggstats ggcoef_model
#' @importFrom ggplot2 label_wrap_gen
plot_model_wage <- function(model_fit) {
  if (!inherits(model_fit, "fixest")) {
    stop("`model_fit` must be a fixest model object")
  }

  model_fit |>
    ggstats::ggcoef_model(
      add_reference_rows = TRUE,
      categorical_terms_pattern = "{level} (ref: {reference_level})",
      facet_labeller = ggplot2::label_wrap_gen(20)
    )
}

#' Plot fixed effects from a wage model fit
#'
#' @param model_fit A `fixest` model object, as returned by `model_wage()`.
#' @param fixed_effects_var Character. Name of the fixed effects variable to plot.
#' @return A `ggplot` object visualizing the fixed effects.
#'
#' @export
#'
#' @importFrom ggplot2 ggplot aes geom_point labs theme element_text
#' @importFrom dplyr arrange desc mutate
#' @importFrom forcats fct_reorder
#' @importFrom tibble tibble
#' @importFrom fixest fixef
plot_model_wage_fes <- function(
  model_fit,
  fixed_effects_var = c("personnel_id", "est_id", "ref_date")
) {
  if (!inherits(model_fit, "fixest")) {
    stop("`model_fit` must be a fixest model object")
  }

  fes <- fixest::fixef(model_fit)

  if (!fixed_effects_var %in% names(fes)) {
    stop(
      "`fixed_effects_var` not found in model fixed effects: ",
      fixed_effects_var
    )
  }

  fixed_effects_var <- match.arg(fixed_effects_var, choices = names(fes))

  fes_df <- tibble::tibble(
    id = names(fes[[fixed_effects_var]]),
    premium = fes[[fixed_effects_var]]
  ) |>
    dplyr::arrange(
      dplyr::desc(.data[["premium"]])
    ) |>
    dplyr::mutate(
      id = forcats::fct_reorder(.data[["id"]], .data[["premium"]])
    )

  average_premium <- mean(fes_df[["premium"]], na.rm = TRUE)

  fes_df |>
    ggplot2::ggplot(ggplot2::aes(x = .data[["id"]], y = .data[["premium"]])) +
    ggplot2::geom_point() +
    ggplot2::labs(
      title = paste("Fixed Effects for", fixed_effects_var),
      x = fixed_effects_var,
      y = "Premium"
    ) +
    ggplot2::geom_hline(yintercept = average_premium, linetype = "dashed") +
    ggplot2::annotate(
      "text",
      x = 1,
      y = average_premium,
      label = paste("Average premium:", round(average_premium, 1)),
      vjust = -1,
      hjust = 0
    ) +
    ggplot2::theme(axis.text.x = ggplot2::element_text(angle = 45, hjust = 1))
}
