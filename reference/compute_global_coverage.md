# Compute global coverage

Computes the share of non-missing values across every cell of a table,
as a percentage.

## Usage

``` r
compute_global_coverage(data, digits = 2)
```

## Arguments

- data:

  Data frame or remote database table (`tbl_dbi`).

- digits:

  Whole number. Decimal places to round to. Default `2`.

## Value

A number from 0 to 100.

## Details

Every column has the same number of records, so the share across all
cells is the average of each column's coverage from
[`compute_coverage()`](https://wb-pida-data-science-shop.github.io/govhr/reference/compute_coverage.md),
which is computed in the database for `tbl_dbi` input.

## See also

[`compute_coverage()`](https://wb-pida-data-science-shop.github.io/govhr/reference/compute_coverage.md),
which gives the coverage of each column.

## Examples

``` r
hr <- data.frame(gender = c("F", NA, "M"), grade = c(NA, NA, "G1"))
compute_global_coverage(hr)
#> [1] 50
```
