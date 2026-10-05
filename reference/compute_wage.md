# Compute the average wage

Computes the average wage for each group within each reference group,
usually a reference date, and how much it grew since the previous
reference group.

## Usage

``` r
compute_wage(data, ...)

# S3 method for class 'data.frame'
compute_wage(
  data,
  measure_col = "gross_salary_lcu",
  group_cols = NULL,
  reference_group_col = "ref_date",
  ...
)

# S3 method for class 'tbl_dbi'
compute_wage(
  data,
  measure_col = "gross_salary_lcu",
  group_cols = NULL,
  reference_group_col = "ref_date",
  ...
)
```

## Arguments

- data:

  Data frame or remote database table (`tbl_dbi`) with the column named
  in `reference_group_col` and the pay column named in `measure_col`.

- ...:

  Arguments passed to methods.

- measure_col:

  Character. Name of the pay column to average. Default
  `"gross_salary_lcu"`.

- group_cols:

  Character vector of columns to group by, or `NULL` to average over
  everyone. Must not include `reference_group_col`.

- reference_group_col:

  Character. Name of the column that defines the reference groups,
  usually a date. Growth compares each reference group with the one
  before it in sorted order. Default `"ref_date"`.

## Value

A table with the grouping columns, `reference_group_col`, `wage` (the
average of `measure_col`) and `wage_growth` (the change from the
previous reference group as a proportion, so `0.1` means 10% growth). A
data.table for data frame input; a lazy table for `tbl_dbi` input (use
[`dplyr::collect()`](https://dplyr.tidyverse.org/reference/compute.html)
to bring it into memory).

## Details

The average is taken over rows, so with contract data it is the average
pay per contract. Missing wage values are skipped. If every wage value
for a group in a reference group is missing, its wage is `NA`.

As in
[`compute_wagebill()`](https://wb-pida-data-science-shop.github.io/govhr/reference/compute_wagebill.md),
every group appears in every reference group in `data`. A group with no
records in a reference group gets `wage = NA`, so gaps stay visible and
growth is never measured across a gap.

`wage_growth` is `NA` in the first reference group, and whenever the
current or previous wage is `NA`.

## Examples

``` r
compute_wage(
  bra_hrmis_contract,
  group_cols = "contract_type"
)
#>     contract_type   ref_date     wage  wage_growth
#>            <char>     <Date>    <num>        <num>
#>  1:          <NA> 2007-09-01 1901.855           NA
#>  2:          <NA> 2008-09-01 2123.424  0.116501534
#>  3:          <NA> 2009-09-01 2270.280  0.069160070
#>  4:          <NA> 2010-09-01 2406.992  0.060217736
#>  5:          <NA> 2011-09-01 2494.599  0.036396866
#>  6:          <NA> 2012-09-01 2690.039  0.078345353
#>  7:          <NA> 2013-09-01 2926.394  0.087862994
#>  8:          <NA> 2014-09-01 3116.897  0.065098249
#>  9:          <NA> 2015-09-01 3526.895  0.131540661
#> 10:          <NA> 2016-09-01 3977.413  0.127737636
#> 11:          <NA> 2017-09-01 4155.683  0.044820591
#> 12:    fixed-term 2007-09-01 1820.829           NA
#> 13:    fixed-term 2008-09-01 1694.452 -0.069406494
#> 14:    fixed-term 2009-09-01 1675.744 -0.011040510
#> 15:    fixed-term 2010-09-01 1687.510  0.007021316
#> 16:    fixed-term 2011-09-01 1989.499  0.178955283
#> 17:    fixed-term 2012-09-01 1772.674 -0.108984644
#> 18:    fixed-term 2013-09-01 1957.397  0.104205827
#> 19:    fixed-term 2014-09-01 2240.592  0.144679166
#> 20:    fixed-term 2015-09-01 2714.529  0.211523343
#> 21:    fixed-term 2016-09-01 2527.713 -0.068820788
#> 22:    fixed-term 2017-09-01 2865.228  0.133525890
#> 23:     permanent 2007-09-01 1537.796           NA
#> 24:     permanent 2008-09-01 1839.600  0.196257914
#> 25:     permanent 2009-09-01 2014.331  0.094983029
#> 26:     permanent 2010-09-01 2107.660  0.046332384
#> 27:     permanent 2011-09-01 2336.648  0.108645357
#> 28:     permanent 2012-09-01 2570.216  0.099958779
#> 29:     permanent 2013-09-01 2888.398  0.123795818
#> 30:     permanent 2014-09-01 3293.328  0.140191791
#> 31:     permanent 2015-09-01 3777.452  0.147001443
#> 32:     permanent 2016-09-01 3987.738  0.055668752
#> 33:     permanent 2017-09-01 4130.446  0.035786811
#> 34:    short-term 2007-09-01 1823.016           NA
#> 35:    short-term 2008-09-01 1875.454  0.028764299
#> 36:    short-term 2009-09-01 2216.549  0.181873324
#> 37:    short-term 2010-09-01 2142.643 -0.033342853
#> 38:    short-term 2011-09-01 2290.454  0.068985122
#> 39:    short-term 2012-09-01 2577.808  0.125457243
#> 40:    short-term 2013-09-01 2546.759 -0.012044416
#> 41:    short-term 2014-09-01 2675.667  0.050616471
#> 42:    short-term 2015-09-01 1593.868 -0.404310157
#> 43:    short-term 2016-09-01 1564.179 -0.018626693
#> 44:    short-term 2017-09-01 1683.223  0.076106278
#>     contract_type   ref_date     wage  wage_growth
#>            <char>     <Date>    <num>        <num>
```
