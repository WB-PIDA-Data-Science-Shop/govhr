# Compute growth rate summary table

Filters to the first and last reference date within each group and
computes the percentage change from first `ref_date` to last `ref_date`.

## Usage

``` r
compute_growth(data, group_col, measure_col = NULL, group = NULL)
```

## Arguments

- data:

  A data frame with `ref_date` and the grouping column.

- group_col:

  Character string naming the grouping column.

- measure_col:

  Character string naming the numeric column to sum, or `NULL` to count
  rows.

- group:

  Deprecated. Use `group_col` instead.

## Value

A data frame with the grouping column and a `growth_rate` column
(percentage points, e.g. 12.5 for +12.5%).

## Details

When `measure_col` is `NULL`, counts rows per date-group cell
(headcount). When a column name is supplied, sums that column (wage
bill).
