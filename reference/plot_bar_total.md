# Plot Totals by Group

Draws a horizontal bar chart with groups ordered by the plotted value.
Rows missing either the value or the group label are dropped.

## Usage

``` r
plot_bar_total(.data, group_col, x_col = "value", x_label = "Value")
```

## Arguments

- .data:

  Data frame with the grouping column and the x-axis column, as returned
  by \[compute_cross_section_summary()\].

- group_col:

  Character. Column to group by.

- x_col:

  Character. Column to plot on the x-axis. Default \`"value"\`.

- x_label:

  Character. x-axis label. Default \`"Value"\`.

## Value

A ggplot2 object.
