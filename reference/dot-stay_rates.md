# The stay rate at every duration of a service table

Part of
[`.service_table_from_rates()`](https://wb-pida-data-science-shop.github.io/govhr/reference/dot-service_table_from_rates.md).
Leaves out person-snapshots with no duration, with a warning, and takes
the stay rate `px` (the `"active"` rows) with the people it rests on
(`pop`). The chain needs a stay rate at every duration, so the rates are
smoothed if asked, or if a group is missing a duration (then every
group, so they stay comparable, with a warning).

## Usage

``` r
.stay_rates(rates, duration_col, group_cols, smooth, span)
```

## Arguments

- rates:

  Pooled decrement rates with the columns `.duration`, `.status`,
  `group_cols`, `pop` and `decrement_rate`.

- duration_col:

  The original duration column name, for the warnings.

- group_cols:

  As in
  [`compute_service_table()`](https://wb-pida-data-science-shop.github.io/govhr/reference/compute_service_table.md).

- smooth, span:

  Whether and how much to smooth.

## Value

A data.table with `.duration`, `group_cols`, `pop` (`NA` where smoothing
filled in a duration) and `px`, sorted by group and duration.
