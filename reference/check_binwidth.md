# Check that a bin width is a positive whole number

Fractional widths are not exact in floating point (see
[`compute_percentile()`](https://wb-pida-data-science-shop.github.io/govhr/reference/compute_percentile.md)),
so only positive whole numbers are accepted.

## Usage

``` r
check_binwidth(binwidth)
```

## Arguments

- binwidth:

  The bin width to check.

## Value

`NULL`, invisibly, if `binwidth` is valid. Otherwise an error.
