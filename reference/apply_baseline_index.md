# Apply Baseline Index to a Trend Summary

Rescales \`value\` so the earliest observation equals 100. When a
grouping column is supplied the rescaling is applied independently
within each group.

## Usage

``` r
apply_baseline_index(.data, group_col)
```

## Arguments

- .data:

  Data frame with \`ref_date\` and \`value\`, as returned by
  \[compute_trend_summary()\].

- group_col:

  Character. Column to group by, or \`"ref_date"\` for no grouping.

## Value

The input data frame with \`value\` rescaled to a baseline index.
