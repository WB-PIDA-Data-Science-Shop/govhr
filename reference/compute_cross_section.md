# Compute cross-section summary table

Filters to the latest reference date within each group, then aggregates
to produce a per-group `value`. Used as the data source for
total-by-group bar charts.

## Usage

``` r
compute_cross_section(data, group_cols, measure_col = NULL, group = NULL)
```

## Arguments

- data:

  A data frame containing a `ref_date` column and the grouping column.

- group_cols:

  Character string naming the grouping column.

- measure_col:

  Character string naming the numeric column to sum, or `NULL` to count
  rows.

- group:

  Deprecated. Use `group_cols` instead.

## Value

A data frame with the grouping column and a `value` column.

## Details

When `measure_col` is `NULL`, counts rows (headcount). When a column
name is supplied, sums that column (wage bill).
