# Compute the compression ratio of a measure

Computes, for each group and reference date, an upper, middle and lower
percentile of `measure_col`, by default the 90th, 50th and 10th. The
spread between the upper and lower percentiles shows how compressed pay
is.

## Usage

``` r
compute_compression_ratio(data, ...)

# S3 method for class 'data.frame'
compute_compression_ratio(
  data,
  measure_col,
  group_cols = NULL,
  percentiles = c(0.9, 0.5, 0.1),
  latest_measure = FALSE,
  ...
)

# S3 method for class 'tbl_dbi'
compute_compression_ratio(
  data,
  measure_col,
  group_cols = NULL,
  percentiles = c(0.9, 0.5, 0.1),
  latest_measure = FALSE,
  ...
)
```

## Arguments

- data:

  Data frame or remote database table (`tbl_dbi`) containing `ref_date`
  and the columns named in `measure_col` and `group_cols`.

- ...:

  Arguments passed to methods.

- measure_col:

  Character. Numeric column to compute the percentiles of.

- group_cols:

  Character vector of columns to group by, or `NULL` (default) for no
  grouping. Must not include `ref_date`.

- percentiles:

  Numeric vector of length 3 with the upper, middle and lower
  percentiles, as proportions. Default `c(0.9, 0.5, 0.1)`.

- latest_measure:

  Logical. Restrict to the latest reference date. Default `FALSE`.

## Value

A table with one row per group and reference date, containing the
grouping columns, `ref_date`, `percentile_upper`, `percentile_50` (the
middle percentile, whichever `percentiles[2]` is) and
`percentile_lower`. A data.table for data frame input; a lazy table for
`tbl_dbi` input (use
[`dplyr::collect()`](https://dplyr.tidyverse.org/reference/compute.html)
to bring it into memory).

## Details

Percentiles are interpolated between neighbouring values, as in
`stats::quantile(type = 7)`. Records with a missing `measure_col` are
left out. Missing groups are kept as their own group.

With `latest_measure = TRUE`, the latest date is the latest with a
non-missing `measure_col` across all of `data`, not within each group.

## See also

[`compute_decile()`](https://wb-pida-data-science-shop.github.io/govhr/reference/compute_decile.md),
which summarises the whole distribution by decile.
[`plot_compression_ratio()`](https://wb-pida-data-science-shop.github.io/govhr/reference/plot_compression_ratio.md),
which draws the result.

## Examples

``` r
hr <- data.frame(
  ref_date = as.Date("2020-01-01"),
  wage = 1:11
)
compute_compression_ratio(hr, measure_col = "wage")
#>      ref_date percentile_upper percentile_50 percentile_lower
#>        <Date>            <num>         <num>            <num>
#> 1: 2020-01-01               10             6                2
```
