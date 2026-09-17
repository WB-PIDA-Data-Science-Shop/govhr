# Compute trend summary

Aggregates data over time into a tidy frame of `ref_date`, the optional
grouping column, and `value`. Counts rows when `measure_col` is `NULL`
(headcount) and sums the column otherwise (wage bill).

## Usage

``` r
compute_trend_summary(data, group_col, measure_col = NULL)
```

## Arguments

- data:

  Data frame containing at least a `ref_date` column.

- group_col:

  Character. Column to group by, or `"ref_date"` for no grouping.

- measure_col:

  Character. Numeric column to sum, or `NULL` to count rows.

## Value

A data frame with `ref_date`, optionally `group_col`, and `value`.
