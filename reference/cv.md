# Compute the coefficient of variation (CV)

Calculates the coefficient of variation for a numeric vector, defined as
the ratio of the standard deviation to the mean. This provides a
unitless measure of relative dispersion, allowing comparison of
variability across variables or groups with different scales.

## Usage

``` r
cv(x, na.rm = TRUE)
```

## Arguments

- x:

  A numeric vector of values.

- na.rm:

  Logical; if `TRUE`, missing values (`NA`) are removed before
  computation. Defaults to `TRUE`.

## Value

A numeric value representing the coefficient of variation (CV). Returns
`NA_real_` if the computation is not possible (e.g., all values are
missing or the mean is zero).

## Details

The function safely handles missing values and cases where the mean is
zero (to avoid division by zero). If the input vector is empty or the
mean equals zero, the function returns `NA_real_`.

## Examples

``` r
x <- c(10, 12, 8, 15, NA)
cv(x)
#> [1] 0.2654292
```
