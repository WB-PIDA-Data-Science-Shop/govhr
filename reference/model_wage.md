# Fit a wage model with fixed effects

Fits a linear wage model based on a set of predictors and fixed effects.

## Usage

``` r
model_wage(
  data,
  outcome_var = "gross_salary_lcu",
  predictor_vars = c("contract_type", "occupation_native", "educat7", "whours",
    "paygrade"),
  fixed_effects_vars = c("personnel_id", "est_id", "ref_date")
)
```

## Arguments

- data:

  A data frame containing the outcome, predictor, and fixed effects
  columns.

- outcome_var:

  Character. Name of the outcome column. Default `"gross_salary_lcu"`.

- predictor_vars:

  A character vector. Names of predictor columns. Default
  `c("contract_type", "occupation_native", "educat7", "whours", "paygrade")`.

- fixed_effects_vars:

  Character vector, or `NULL` to fit without fixed effects. Names of
  fixed effects columns. Default
  `c("personnel_id", "est_id", "ref_date")`.

## Value

A `fixest` model object, as returned by
[`fixest::feols()`](https://lrberge.github.io/fixest/reference/feols.html).

## Details

`outcome_var` and `fixed_effects_vars` are required to be present in
`data`. `predictor_vars` are covariates and are dropped with a warning
rather than failing the whole call; if none remain, the model is fit
with an intercept-only right-hand side (`1`).
