# Compute a compression ratio between two percentiles

Calculates a wage (or value) compression ratio by dividing one quantile
by another, typically the 90th percentile divided by the 10th
percentile. This provides a measure of wage inequality or spread within
a group.

## Usage

``` r
cp_ratio(x, upper = 0.9, lower = 0.1, na.rm = TRUE)
```

## Arguments

- x:

  A numeric vector of values (e.g., wages or salaries).

- upper:

  Numeric; the upper percentile to compute (default is `0.9` for the
  90th percentile).

- lower:

  Numeric; the lower percentile to compute (default is `0.1` for the
  10th percentile).

- na.rm:

  Logical; if `TRUE`, missing values (`NA`) are removed before
  computation. Defaults to `TRUE`.

## Value

A numeric value representing the ratio of the specified upper to lower
percentile values. Returns `NA_real_` if computation is not possible
(e.g., due to missing data or zero denominator).

## Details

The function computes the specified upper and lower quantiles and
returns their ratio (`upper / lower`). If either quantile is `NA` or the
lower quantile is zero, the function returns `NA_real_`.

## Examples

``` r
wages <- c(1000, 1200, 900, 3000, 5000, NA)
cp_ratio(wages)             # default 90/10 ratio
#>      90% 
#> 4.468085 
cp_ratio(wages, 0.75, 0.25) # 75/25 ratio
#> 75% 
#>   3 
```
