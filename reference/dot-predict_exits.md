# Predict exits from one exit type's model, with 0 where fixest dropped a level

The prediction shared by both uses of
[`predict.survival_model()`](https://wb-pida-data-science-shop.github.io/govhr/reference/predict.survival_model.md):
the expected exits, [`exp()`](https://rdrr.io/r/base/Log.html) of the
band, year and covariate effects times the `exposure` in `model_data`.
With `exposure = 1` that is the hazard per year.

## Usage

``` r
.predict_exits(model, model_data, cells)
```

## Arguments

- model:

  One `fixest` model from
  [`.survival_models()`](https://wb-pida-data-science-shop.github.io/govhr/reference/dot-survival_models.md).

- model_data:

  A data.table with `.band`, `.year` (if the model has year effects),
  the covariates and `exposure`.

- cells:

  The cells the model was fitted on, for the bands and years seen.

## Value

A numeric vector, one value per row of `model_data`.

## Details

fixest drops a tenure band or year in which no one left, since its
effect is minus infinity: it predicts `NA` there. The model's estimate
is 0 exits, so a band or year seen in the cells but dropped gets 0. One
never seen, a covariate level never seen, or a missing value stays `NA`.
