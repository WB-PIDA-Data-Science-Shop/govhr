# Plot Consistency Over Time

Plot Consistency Over Time

## Usage

``` r
plot_consistency_trend(
  data,
  id_col,
  group,
  value_col,
  type_plot,
  toggle_growth = FALSE
)
```

## Arguments

- data:

  A data frame.

- id_col:

  Character string. The column name of the unique identifier for each
  record.

- group:

  Character string. The column name of the grouping variable (e.g.,
  "ref_date").

- value_col:

  Character string. The column name of the value to be checked for
  consistency.

- type_plot:

  Character string. The type of consistency plot ("record" or "value").

- toggle_growth:

  Logical. When \`TRUE\` the y-axis switches to a baseline-index view
  (first period = 100). Defaults to \`FALSE\`.

## Value

A ggplot2 object.
