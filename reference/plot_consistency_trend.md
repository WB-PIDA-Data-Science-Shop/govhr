# Plot consistency over time

Plot consistency over time

## Usage

``` r
plot_consistency_trend(
  data,
  id_col,
  group_col,
  value_col,
  type_plot,
  toggle_growth = FALSE,
  group = NULL
)
```

## Arguments

- data:

  A data frame.

- id_col:

  A string. The column name of the unique identifier for each record.

- group_col:

  A string. The column name of the grouping variable (e.g., "ref_date").

- value_col:

  A string. The column name of the value to be checked for consistency.

- type_plot:

  A string. The type of consistency plot ("record" or "value").

- toggle_growth:

  Logical. When `TRUE` the y-axis switches to a baseline-index view
  (first period = 100). Defaults to `FALSE`.

- group:

  Deprecated. Use `group_col` instead.

## Value

A ggplot2 object.
