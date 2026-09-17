# Compute growth rate summary

Keeps each group's first and last reference date and computes the
percentage change between them. Counts rows when `measure_col` is `NULL`
(headcount) and sums the column otherwise (wage bill).

## Usage

``` r
compute_growth_summary(data, group_col, measure_col = NULL)
```

## Arguments

- data:

  Data frame containing `ref_date` and the grouping column.

- group_col:

  Character. Column to group by.

- measure_col:

  Character. Numeric column to sum, or `NULL` to count rows.

## Value

A data frame with the grouping column and a `growth_rate` column, in
percentage points (e.g. `12.5` for +12.5%).
