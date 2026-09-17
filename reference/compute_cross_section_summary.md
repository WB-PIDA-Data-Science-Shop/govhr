# Compute cross-section summary

Keeps each group's latest reference date and aggregates it into a single
`value` per group. Counts rows when `measure_col` is `NULL` (headcount)
and sums the column otherwise (wage bill).

## Usage

``` r
compute_cross_section_summary(data, group_col, measure_col = NULL)
```

## Arguments

- data:

  Data frame containing `ref_date` and the grouping column.

- group_col:

  Character. Column to group by.

- measure_col:

  Character. Numeric column to sum, or `NULL` to count rows.

## Value

A data frame with the grouping column and a `value` column.
