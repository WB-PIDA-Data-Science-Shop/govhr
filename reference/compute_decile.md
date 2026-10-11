# Compute deciles of a measure

Splits the records of each group and reference date into ten equally
sized deciles of `measure_col`, and reports the median and mean of the
measure in each decile.

## Usage

``` r
compute_decile(data, ...)

# S3 method for class 'data.frame'
compute_decile(
  data,
  measure_col,
  group_cols = NULL,
  latest_measure = FALSE,
  ...
)

# S3 method for class 'tbl_dbi'
compute_decile(
  data,
  measure_col,
  group_cols = NULL,
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

  Character. Numeric column to rank into deciles.

- group_cols:

  Character vector of columns to group by, or `NULL` (default) for no
  grouping. Must not include `ref_date`.

- latest_measure:

  Logical. Restrict to the latest reference date and drop `ref_date`
  from the grouping. Default `FALSE`.

## Value

A table with one row per group, reference date and decile, containing
the grouping columns, `ref_date` (unless `latest_measure` is `TRUE`),
`decile` (1 to 10), `median_value` and `mean_value`. A data.table for
data frame input; a lazy table for `tbl_dbi` input (use
[`dplyr::collect()`](https://dplyr.tidyverse.org/reference/compute.html)
to bring it into memory).

## Details

Records with a missing `measure_col` are left out before ranking. Decile
sizes differ by at most one record, with the larger deciles first, so a
group with fewer than ten records fills only the first deciles. Records
with the same value may fall on either side of a decile boundary, which
leaves the medians and means unchanged.

With `latest_measure = TRUE`, the latest date is the latest across all
of `data`, not within each group. Missing groups are kept as their own
group.

## See also

[`compute_percentile()`](https://wb-pida-data-science-shop.github.io/govhr/reference/compute_percentile.md),
which bins the measure at a fixed width instead.
[`plot_decile()`](https://wb-pida-data-science-shop.github.io/govhr/reference/plot_decile.md),
which draws the result.

## Examples

``` r
hr <- data.frame(
  ref_date = as.Date("2020-01-01"),
  wage = 1:20
)
compute_decile(hr, measure_col = "wage")
#>       ref_date decile median_value mean_value
#>         <Date>  <int>        <num>      <num>
#>  1: 2020-01-01      1          1.5        1.5
#>  2: 2020-01-01      2          3.5        3.5
#>  3: 2020-01-01      3          5.5        5.5
#>  4: 2020-01-01      4          7.5        7.5
#>  5: 2020-01-01      5          9.5        9.5
#>  6: 2020-01-01      6         11.5       11.5
#>  7: 2020-01-01      7         13.5       13.5
#>  8: 2020-01-01      8         15.5       15.5
#>  9: 2020-01-01      9         17.5       17.5
#> 10: 2020-01-01     10         19.5       19.5
```
