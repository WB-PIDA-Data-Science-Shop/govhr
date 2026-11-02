# Fit the Poisson survival model on summed cells

The fit shared by both methods of
[`fit_survival_model()`](https://wb-pida-data-science-shop.github.io/govhr/reference/fit_survival_model.md).
Fits one model per exit type, with `log(exposure)` as an offset and
fixed effects for tenure band (and calendar year if `period_effects`).
An exit type no one had cannot be fitted, so it is left out with a
warning.

## Usage

``` r
.fit_survival_cells(
  cells,
  panel,
  covariate_cols,
  exit_types,
  band_width,
  period_effects,
  make_tidy_output,
  ...
)
```

## Arguments

- cells:

  A data.table of cells with exit counts (`exit_retired`, `exit_other`),
  years at risk (`exposure`), tenure band (`.band`), snapshot (`.ref`)
  and `covariate_cols`. **Modified by reference**: sorted, and a `.year`
  column is added.

- panel:

  The `survival_panel` the cells were summed from, for the column names
  it remembers.

- covariate_cols:

  Character vector. The covariates to model, or empty for tenure (and
  year) effects only.

- exit_types:

  Character vector. Any of `"retired"` and `"other"`.

- band_width:

  Number. The width of the tenure bands, in years.

- period_effects:

  Logical. Whether to add calendar year fixed effects.

- make_tidy_output:

  Logical. Whether to return the table of hazard ratios from
  [`tidy.survival_model()`](https://wb-pida-data-science-shop.github.io/govhr/reference/tidy.survival_model.md)
  instead of the model.

- ...:

  Further arguments passed to
  [`fixest::fepois()`](https://lrberge.github.io/fixest/reference/feglm.html),
  already checked by
  [`.check_survival_model_args()`](https://wb-pida-data-science-shop.github.io/govhr/reference/dot-check_survival_model_args.md).

## Value

A `survival_model`: the output of
[`fixest::fepois()`](https://lrberge.github.io/fixest/reference/feglm.html)
(a `fixest_multi` with one model per exit type, or a `fixest` if only
one is fitted) with class `survival_model` prepended, and two attributes
for
[`predict.survival_model()`](https://wb-pida-data-science-shop.github.io/govhr/reference/predict.survival_model.md):
`cells` (the cells it was fitted on) and `survival_settings` (the
panel's columns, `band_width`, `period_effects`, the exit types asked
for and those no one had). Or, if `make_tidy_output`, its table of
hazard ratios. Stops with an error if no exit type has any exits.
