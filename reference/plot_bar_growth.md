# Plot Growth Rates by Group

Draws a horizontal bar chart with groups ordered by \`growth_rate\`,
with a dashed reference line at zero separating growth from decline.

## Usage

``` r
plot_bar_growth(.data, group_col)
```

## Arguments

- .data:

  Data frame with the grouping column and a \`growth_rate\` column, as
  returned by \[compute_growth_summary()\].

- group_col:

  Character. Column to group by.

## Value

A ggplot2 object.
