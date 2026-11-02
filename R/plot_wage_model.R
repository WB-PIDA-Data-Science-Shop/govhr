#' Plot a wage model fit
#'
#' @param model_fit A `fixest` model object, as returned by `model_wage()`.
#' @returns A `ggplot` object visualizing the model coefficients.
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
#' @returns A `ggplot` object visualizing the fixed effects.
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
