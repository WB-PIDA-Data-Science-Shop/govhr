# Orange gradient colour scale for grouped series

Builds the package's standard sequential orange scale, sized to the
number of distinct groups present in the data.

## Usage

``` r
group_color_scale(values)
```

## Arguments

- values:

  Vector of group values. Distinct non-missing values determine the
  number of colours.

## Value

A ggplot2 manual colour scale.
