# Plot Coverage Over Time

Computes coverage using
[`compute_coverage()`](https://wb-pida-data-science-shop.github.io/govhr/reference/compute_coverage.md)
(with `ref_date` always included, aggregated across variables) and
renders a trend line via
[`plot_trend()`](https://wb-pida-data-science-shop.github.io/govhr/reference/plot_trend.md).

## Usage

``` r
plot_coverage_trend(data, group_col, toggle_growth = FALSE, group = NULL)
```

## Arguments

- data:

  A data frame. Typically the contract, personnel, or establishment
  dataset for the active module.

- group_col:

  A string. Grouping variable inherited from the `coverage_group` UI
  input (e.g. `"ref_date"`, `"grade_id"`).

- toggle_growth:

  Logical. When `TRUE` the y-axis switches to a baseline-index view
  (first period = 100). Defaults to `FALSE`.

- group:

  Deprecated. Use `group_col` instead.

## Value

A ggplot2 object.
