# Plot Horizontal Bar Chart of Totals by Group

Produces a ggplot2 horizontal bar chart with groups ordered by
\`value\`. Missing values in either \`value\` or the group column are
dropped. The x-axis uses short-scale number formatting (e.g. 1K, 1M) and
the y-axis uses \`guide_axis(n.dodge = 2)\` to prevent overlapping
labels.

## Usage

``` r
plot_bar_total(data, group, x_col = "value", x_label = "Value")
```

## Arguments

- data:

  A data frame with the grouping column and a \`value\` column, as
  returned by \[compute_cross_section_summary()\].

- group:

  Character string naming the grouping column.

- x_col:

  Character string of the column to plot on the x-axis. Default
  \`"value"\`.

- x_label:

  Character string for the x-axis label. Default \`"Value"\`.

## Value

A ggplot2 object.
