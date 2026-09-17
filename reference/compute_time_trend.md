# Compute time trend

Summarizes data over time by grouping variable, producing a tidy data
frame with `ref_date`, optional group column, and `value`.

## Usage

``` r
compute_time_trend(data, group_col, measure_col = NULL, group = NULL)
```

## Arguments

- data:

  A data frame containing at least a `ref_date` column.

- group_col:

  Character string naming the grouping column, or `"ref_date"` for no
  grouping.

- measure_col:

  Character string naming the numeric column to sum, or `NULL` to count
  rows.

- group:

  Deprecated. Use `group_col` instead.

## Value

A summarized data frame with columns `ref_date`, optionally `group`, and
`value`. Value denotes either a sum or headcount (if `measure_col` is
`NULL`).

## Details

When `measure_col` is `NULL`, counts rows per period (headcount). When a
column name is supplied, sums that column per period (wage bill).
