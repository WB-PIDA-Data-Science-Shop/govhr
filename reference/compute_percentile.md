# Compute the percentile of a measure

Bins `measure_col` at a fixed width and reports each bin's share and
cumulative share of observations within each group, filling empty bins
with zero so the distribution is gap-free.

## Usage

``` r
compute_percentile(data, ...)

# S3 method for class 'data.frame'
compute_percentile(
  data,
  measure_col,
  group_cols = NULL,
  binwidth = NULL,
  latest_measure = FALSE,
  ...
)

# S3 method for class 'tbl_dbi'
compute_percentile(
  data,
  measure_col,
  group_cols = NULL,
  binwidth = NULL,
  latest_measure = FALSE,
  ...
)
```

## Arguments

- data:

  Data frame or remote table (`tbl_dbi`) containing the measure, the
  grouping columns and, if `latest_measure = TRUE`, a `ref_date` column.

- ...:

  Arguments passed to methods.

- measure_col:

  Character. Numeric column to bin.

- group_cols:

  Character vector of columns to group by, or `NULL` for no grouping.

- binwidth:

  Positive whole number. Width of each bin. Default `NULL` picks a width
  from the data; see Details.

- latest_measure:

  Logical. Restrict to the latest reference date. Default `FALSE`.

## Value

A data.table (a lazy table for `tbl_dbi` input) with the grouping
columns, `bin` (the lower edge of each bin), `count`, `pct` and
`cum_pct`. Bins span the range of `measure_col` across all groups.

## Details

Rows with a missing `measure_col` are dropped. Missing values in
`group_cols` are kept as their own group.

`binwidth` must be a whole number because bins are assigned with
`floor(measure_col / binwidth)`, and fractional widths are not exact in
floating point: `0.3 / 0.1` is `2.9999...`, which would put 0.3 in the
0.2 bin.

When `binwidth` is `NULL`, it is chosen with the Freedman-Diaconis rule,
which is based on the spread of the middle half of the values, so a few
extreme values do not throw it off. The width is then adjusted so that
the bulk of the values (1st to 99th percentile) spans 20 to 60 bins, and
rounded up to 1, 2 or 5 times a power of ten. With
`latest_measure = TRUE`, it is based on the latest reference date only.
