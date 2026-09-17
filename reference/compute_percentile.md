# Bin a measure into a share distribution

Bins `measure_col` at a fixed width and reports each bin's share and
cumulative share of observations, filling empty bins with zero so the
distribution is gap-free.

## Usage

``` r
compute_percentile(
  data,
  group_col = NULL,
  measure_col,
  binwidth = 1,
  latest_measure = FALSE
)
```

## Arguments

- data:

  Data frame containing a `ref_date` column and the measure.

- group_col:

  Character. Column to group by, or `NULL` for no grouping.

- measure_col:

  Character. Numeric column to bin.

- binwidth:

  Numeric. Width of each bin. Default `1`.

- latest_measure:

  Logical. Restrict to the latest reference date. Default `FALSE`.

## Value

A data frame with the grouping column, `bin`, `count`, `pct` and
`cum_pct`.
