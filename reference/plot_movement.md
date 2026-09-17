# Plot personnel movement over time

Plot personnel movement over time

## Usage

``` r
plot_movement(data, movement_type, measurement_type, group_cols)
```

## Arguments

- data:

  A data frame containing the movement data with columns `ref_date`,
  `indicator`, and optionally a grouping column.

- movement_type:

  A string indicating the type of movement: "hire", "fire", or
  "turnover".

- measurement_type:

  A string indicating the measurement type: "count" or "rate".

- group_cols:

  A character vector of columns to group by, or `"ref_date"` for no
  grouping.

## Value

A ggplot2 object representing the personnel movement over time.
