# Plot grouped line chart with labeled points

This function creates a line plot with labeled points, showing how a
variable (y) evolves along another variable (x).

## Usage

``` r
ggplot_point_line(.data, x, y, group_col = NULL, label = NULL, ...)
```

## Arguments

- .data:

  A data frame or tibble containing the variables to plot.

- x:

  Column to be mapped to the x-axis.

- y:

  Column to be mapped to the y-axis.

- group_col:

  Column specifying the grouping variable (mapped to color).

- label:

  Column specifying the labels for each point (optional).

- ...:

  Any other arguments passed to `aes()`.

## Value

A `ggplot` object representing the grouped line chart.

## Examples

``` r
if (FALSE) { # \dontrun{
ggplot_point_line(
  data,
  x = year,
  y = median_base_salary_ppp,
  group = paygrade,
  label = year
)
} # }
```
