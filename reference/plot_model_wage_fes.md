# Plot fixed effects from a wage model fit

Plot fixed effects from a wage model fit

## Usage

``` r
plot_model_wage_fes(
  model_fit,
  fixed_effects_var = c("personnel_id", "est_id", "ref_date")
)
```

## Arguments

- model_fit:

  A `fixest` model object, as returned by
  [`model_wage()`](https://wb-pida-data-science-shop.github.io/govhr/reference/model_wage.md).

- fixed_effects_var:

  Character. Name of the fixed effects variable to plot.

## Value

A `ggplot` object visualizing the fixed effects.
