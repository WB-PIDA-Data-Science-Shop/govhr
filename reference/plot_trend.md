# Plot Time Trend

Produces a ggplot2 line and point chart of \`value\` over \`ref_date\`.
When a grouping variable is present, each group receives its own line
coloured with an orange palette. When \`toggle_growth\` is \`TRUE\`, the
y-axis is formatted for a baseline index (first period = 100) with a
reference line at 100; otherwise raw values are shown with short-scale
labels.

## Usage

``` r
plot_trend(
  data,
  group,
  toggle_growth = FALSE,
  y_col = "value",
  y_label = "Value"
)
```

## Arguments

- data:

  A data frame with columns \`ref_date\` and \`value\`, as returned by
  \[compute_trend_summary()\] and optionally \[apply_baseline_index()\].

- group:

  Character string naming the grouping column, or \`"ref_date"\` for no
  grouping.

- toggle_growth:

  Logical. If \`TRUE\`, format the y-axis as a baseline index and add a
  dashed reference line at 100. Default \`FALSE\`.

- y_col:

  Character string of the column to plot on the y-axis. Default
  \`"value"\`.

- y_label:

  Character string for the y-axis label used when \`toggle_growth\` is
  \`FALSE\`. Default \`"Value"\`.

## Value

A ggplot2 object.
