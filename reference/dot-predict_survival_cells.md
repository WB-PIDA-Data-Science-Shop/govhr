# Expected exits in each cell a survival model was fitted on

[`predict.survival_model()`](https://wb-pida-data-science-shop.github.io/govhr/reference/predict.survival_model.md)
without `newdata`: the cells, with the expected exits of each exit type
next to the exits seen. The cells' own exposure is in the offset, so the
prediction is on the scale of the outcome.

## Usage

``` r
.predict_survival_cells(object)
```

## Arguments

- object:

  A `survival_model`.

## Value

A data.table: the snapshot date (named as in the panel), `tenure_band`,
the covariates, `exposure`, and `exit_<type>` and `pred_<type>` for each
exit type modelled.
