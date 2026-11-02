# Split a survival model into one fixest model per exit type

Shared by
[`tidy.survival_model()`](https://wb-pida-data-science-shop.github.io/govhr/reference/tidy.survival_model.md)
and
[`predict.survival_model()`](https://wb-pida-data-science-shop.github.io/govhr/reference/predict.survival_model.md).
Drops the `survival_model` class first, so the methods they call on each
model
([`broom::tidy()`](https://generics.r-lib.org/reference/tidy.html),
[`predict()`](https://rdrr.io/r/stats/predict.html)) reach fixest's own
instead of ours.

## Usage

``` r
.survival_models(x)
```

## Arguments

- x:

  A `survival_model` from
  [`fit_survival_model()`](https://wb-pida-data-science-shop.github.io/govhr/reference/fit_survival_model.md).

## Value

A list of `fixest` models, named by the exit type each one's outcome
counts (`exit_other` is `"other"`).
