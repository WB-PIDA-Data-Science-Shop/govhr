# Rescale to baseline index

Rescales the `value` column so that the first observation equals 100,
producing a baseline index. When a grouping variable is present, the
rescaling is applied within each group.

## Usage

``` r
rescale_baseline(data, group_col, group = NULL)
```

## Arguments

- data:

  A data frame with columns `ref_date` and `value`, as returned by
  [`compute_time_trend()`](https://wb-pida-data-science-shop.github.io/govhr/reference/compute_time_trend.md).

- group_col:

  Character string naming the grouping column, or `"ref_date"` for no
  grouping.

- group:

  Deprecated. Use `group_col` instead.

## Value

The input data frame with `value` rescaled to a baseline index.
