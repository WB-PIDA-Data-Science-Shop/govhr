# Plot Density as Percentage Share

Plot Density as Percentage Share

## Usage

``` r
plot_histogram(.data, plot_type = "histogram", group_col = NULL)
```

## Arguments

- .data:

  A data frame produced by \`compute_histogram()\` or
  \`compute_cumulative()\`, containing columns \`bin\`, \`pct\`, and
  optionally a grouping column.

- plot_type:

  A character string indicating the type of plot: "histogram" or
  "cumulative".

- group_col:

  The column name to group by.

## Value

A ggplot2 object.
