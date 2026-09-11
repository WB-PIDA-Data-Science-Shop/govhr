# Plot Coverage Over Time

Computes coverage using \[compute_coverage()\] (with \`ref_date\` always
included, aggregated across variables) and renders a trend line via
\[plot_trend()\].

## Usage

``` r
plot_coverage_trend(data, group, toggle_growth = FALSE)
```

## Arguments

- data:

  A data frame. Typically the contract, personnel, or establishment
  dataset for the active module.

- group:

  Character string. Grouping variable inherited from the
  \`coverage_group\` UI input (e.g. \`"ref_date"\`, \`"grade_id"\`).

- toggle_growth:

  Logical. When \`TRUE\` the y-axis switches to a baseline-index view
  (first period = 100). Defaults to \`FALSE\`.

## Value

A ggplot2 object.
