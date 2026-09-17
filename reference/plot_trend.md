# Plot time trend

Draws a line-and-point chart of the measure over `ref_date`, one
coloured series per group. When `toggle_growth` is `TRUE` the y-axis is
formatted as a baseline index with a dashed reference line at 100.

## Usage

``` r
plot_trend(
  data,
  group_col,
  toggle_growth = FALSE,
  y_col = "value",
  y_label = "Value"
)
```

## Arguments

- data:

  Data frame with `ref_date` and the y-axis column, as returned by
  [`compute_trend_summary()`](https://wb-pida-data-science-shop.github.io/govhr/reference/compute_trend_summary.md)
  and optionally
  [`apply_baseline_index()`](https://wb-pida-data-science-shop.github.io/govhr/reference/apply_baseline_index.md).

- group_col:

  Character. Column to group by, or `"ref_date"` for no grouping.

- toggle_growth:

  Logical. Format the y-axis as a baseline index. Default `FALSE`.

- y_col:

  Character. Column to plot on the y-axis. Default `"value"`.

- y_label:

  Character. y-axis label, used when `toggle_growth` is `FALSE`. Default
  `"Value"`.

## Value

A ggplot2 object.
