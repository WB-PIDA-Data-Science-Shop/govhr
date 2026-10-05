# Compute the wagebill

Computes the wagebill (total pay) for each group within each reference
group, usually a reference date. It also reports each group's share of
its reference group's total wagebill, and how much the wagebill grew
since the previous reference group.

## Usage

``` r
compute_wagebill(data, ...)

# S3 method for class 'data.frame'
compute_wagebill(
  data,
  measure_col = "gross_salary_lcu",
  group_cols = NULL,
  reference_group_col = "ref_date",
  ...
)

# S3 method for class 'tbl_dbi'
compute_wagebill(
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

  Character. Name of the pay column to add up. Default
  `"gross_salary_lcu"`.

- group_cols:

  Character vector of columns to group by, or `NULL` to add up everyone
  together. Must not include `reference_group_col`.

- reference_group_col:

  Character. Name of the column that defines the reference groups,
  usually a date. Shares are computed within each reference group, and
  growth compares each reference group with the one before it in sorted
  order. Default `"ref_date"`.

## Value

A table with the grouping columns, `reference_group_col`, `wagebill`,
`share_wagebill` (the group's share of its reference group's total,
between 0 and 1; only when `group_cols` is given) and `wagebill_growth`
(the change from the previous reference group as a proportion, so `0.1`
means 10% growth). A data.table for data frame input; a lazy table for
`tbl_dbi` input (use
[`dplyr::collect()`](https://dplyr.tidyverse.org/reference/compute.html)
to bring it into memory).

## Details

Missing wage values are skipped when adding up. If every wage value for
a group in a reference group is missing, its wagebill is `NA` rather
than 0, so missing data is not mistaken for zero pay.

When `group_cols` is given, every group appears in every reference group
in `data`. A group with no records in a reference group gets
`wagebill = NA`, so gaps stay visible instead of disappearing. Rows with
a missing group value are kept as their own group.

`wagebill_growth` is `NA` in the first reference group, and whenever the
current or previous wagebill is `NA`.

## See also

[`compute_growth_decomposition()`](https://wb-pida-data-science-shop.github.io/govhr/reference/compute_growth_decomposition.md)
to split wagebill changes into the part due to headcount and the part
due to average pay.

## Examples

``` r
compute_wagebill(
  bra_hrmis_contract,
  group_cols = "contract_type",
  reference_group_col = "ref_date"
)
#>     contract_type   ref_date   wagebill share_wagebill wagebill_growth
#>            <char>     <Date>      <num>          <num>           <num>
#>  1:          <NA> 2007-09-01  294787.56     0.14836231              NA
#>  2:          <NA> 2008-09-01  367352.40     0.15850296    2.461598e-01
#>  3:          <NA> 2009-09-01  454056.09     0.17934348    2.360232e-01
#>  4:          <NA> 2010-09-01  527131.16     0.19702671    1.609384e-01
#>  5:          <NA> 2011-09-01  653584.82     0.21937972    2.398903e-01
#>  6:          <NA> 2012-09-01  798941.51     0.24567373    2.223991e-01
#>  7:          <NA> 2013-09-01  939372.35     0.25993423    1.757711e-01
#>  8:          <NA> 2014-09-01 1118965.92     0.26468309    1.911846e-01
#>  9:          <NA> 2015-09-01 1301424.39     0.26841665    1.630599e-01
#> 10:          <NA> 2016-09-01 2573385.98     0.41291493    9.773611e-01
#> 11:          <NA> 2017-09-01 2705349.39     0.42240617    5.128007e-02
#> 12:    fixed-term 2007-09-01   72833.17     0.03665588              NA
#> 13:    fixed-term 2008-09-01   81333.69     0.03509336    1.167122e-01
#> 14:    fixed-term 2009-09-01  102220.40     0.04037510    2.568027e-01
#> 15:    fixed-term 2010-09-01   87750.53     0.03279866   -1.415556e-01
#> 16:    fixed-term 2011-09-01  105443.45     0.03539273    2.016275e-01
#> 17:    fixed-term 2012-09-01  101042.43     0.03107045   -4.173820e-02
#> 18:    fixed-term 2013-09-01  111571.64     0.03087305    1.042058e-01
#> 19:    fixed-term 2014-09-01  125473.14     0.02967974    1.245971e-01
#> 20:    fixed-term 2015-09-01  108581.17     0.02239469   -1.346262e-01
#> 21:    fixed-term 2016-09-01  133968.80     0.02149608    2.338125e-01
#> 22:    fixed-term 2017-09-01  157587.56     0.02460531    1.763005e-01
#> 23:     permanent 2007-09-01 1520880.13     0.76543694              NA
#> 24:     permanent 2008-09-01 1777054.08     0.76675241    1.684380e-01
#> 25:     permanent 2009-09-01 1871313.80     0.73913318    5.304269e-02
#> 26:     permanent 2010-09-01 1976985.17     0.73894111    5.646908e-02
#> 27:     permanent 2011-09-01 2124012.65     0.71293775    7.436954e-02
#> 28:     permanent 2012-09-01 2246368.80     0.69075621    5.760613e-02
#> 29:     permanent 2013-09-01 2440696.32     0.67536639    8.650740e-02
#> 30:     permanent 2014-09-01 2852021.79     0.67462461    1.685279e-01
#> 31:     permanent 2015-09-01 3229721.14     0.66612469    1.324321e-01
#> 32:     permanent 2016-09-01 3349699.62     0.53747903    3.714825e-02
#> 33:     permanent 2017-09-01 3349791.75     0.52302771    2.750396e-05
#> 34:    short-term 2007-09-01   98442.88     0.04954488              NA
#> 35:    short-term 2008-09-01   91897.25     0.03965126   -6.649165e-02
#> 36:    short-term 2009-09-01  104177.81     0.04114824    1.336336e-01
#> 37:    short-term 2010-09-01   83563.08     0.03123351   -1.978802e-01
#> 38:    short-term 2011-09-01   96199.05     0.03228980    1.512147e-01
#> 39:    short-term 2012-09-01  105690.11     0.03249961    9.866064e-02
#> 40:    short-term 2013-09-01  122244.45     0.03382633    1.566309e-01
#> 41:    short-term 2014-09-01  131107.70     0.03101255    7.250431e-02
#> 42:    short-term 2015-09-01  208796.69     0.04306397    5.925586e-01
#> 43:    short-term 2016-09-01  175188.09     0.02810996   -1.609633e-01
#> 44:    short-term 2017-09-01  191887.45     0.02996080    9.532246e-02
#>     contract_type   ref_date   wagebill share_wagebill wagebill_growth
#>            <char>     <Date>      <num>          <num>           <num>
```
