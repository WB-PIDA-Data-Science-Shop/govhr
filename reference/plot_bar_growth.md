# Plot growth rates by group

Draws a horizontal bar chart with groups ordered by `growth_rate`, with
a dashed reference line at zero separating growth from decline.

## Usage

``` r
plot_bar_growth(data, group_col)
```

## Arguments

- data:

  Data frame with the grouping column and a `growth_rate` column, as
  returned by
  [`compute_growth_summary()`](https://wb-pida-data-science-shop.github.io/govhr/reference/compute_growth_summary.md).

- group_col:

  Character. Column to group by.

## Value

A ggplot2 object.
