# Apply baseline index to a trend summary

Rescales `value` so the earliest observation equals 100. When a grouping
column is supplied the rescaling is applied independently within each
group.

## Usage

``` r
apply_baseline_index(data, group_col)
```

## Arguments

- data:

  Data frame with `ref_date` and `value`, as returned by
  [`compute_trend_summary()`](https://wb-pida-data-science-shop.github.io/govhr/reference/compute_trend_summary.md).

- group_col:

  Character. Column to group by, or `"ref_date"` for no grouping.

## Value

The input data frame with `value` rescaled to a baseline index.
