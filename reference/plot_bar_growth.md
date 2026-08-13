# Plot Horizontal Bar Chart of Growth Rates by Group

Produces a ggplot2 horizontal bar chart with groups ordered by
\`growth_rate\`. A dashed vertical line is drawn at zero to distinguish
positive from negative growth. The x-axis uses short-scale number
formatting and the y-axis uses \`guide_axis(n.dodge = 2)\`.

## Usage

``` r
plot_bar_growth(data, group)
```

## Arguments

- data:

  A data frame with the grouping column and a \`growth_rate\` column, as
  returned by \[compute_growth_summary()\].

- group:

  Character string naming the grouping column.

## Value

A ggplot2 object.
