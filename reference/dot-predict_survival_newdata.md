# Hazards and exit probabilities for new data from a survival model

[`predict.survival_model()`](https://wb-pida-data-science-shop.github.io/govhr/reference/predict.survival_model.md)
with `newdata`: one row per row of `newdata` (e.g. one per person), with
the hazard of each exit type and, if every exit type is covered, the
chance of each exit and of staying within `horizon` years.

## Usage

``` r
.predict_survival_newdata(object, newdata, horizon)
```

## Arguments

- object:

  A `survival_model`.

- newdata:

  A data frame with the panel's tenure column, its covariates and (if
  the model has year effects) its snapshot date column, or a lazy
  database table with them (collected).

- horizon:

  Number. The years ahead the exit chances are for.

## Value

`newdata` as a data.table with `hazard_<type>` for each exit type
modelled (per year), and `prob_retired`, `prob_other` and `prob_stay` if
both exit types were modelled or had no exits.

## Details

The hazard is constant within a tenure band, so the chance of leaving
within `horizon` is `1 - exp(-total hazard * horizon)`, split between
the exit types in proportion to their hazards. This holds for any
horizon (a month, a year, several), and the three chances always add up
to 1.
