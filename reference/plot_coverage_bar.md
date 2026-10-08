# Plot coverage by variable

Plots one bar per variable with its coverage, coloured by coverage tier,
from coverage already computed.

## Usage

``` r
plot_coverage_bar(data)
```

## Arguments

- data:

  Data frame with `variable` and `coverage`, such as the output of
  [`compute_coverage()`](https://wb-pida-data-science-shop.github.io/govhr/reference/compute_coverage.md)
  without grouping.

## Value

A ggplot2 object.

## Details

Coverage below 50% is low, from 50% to 79% medium, and from 80% high.

## See also

[`compute_coverage()`](https://wb-pida-data-science-shop.github.io/govhr/reference/compute_coverage.md),
which computes the coverage.

## Examples

``` r
hr <- data.frame(gender = c("F", NA, "M"), grade = c(NA, NA, "G1"))
plot_coverage_bar(compute_coverage(hr))

```
