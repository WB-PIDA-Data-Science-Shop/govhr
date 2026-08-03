# Rescale to Baseline Index

Rescales the \`value\` column so that the first observation equals 100,
producing a baseline index. When a grouping variable is present, the
rescaling is applied within each group.

## Usage

``` r
rescale_baseline(data, group)
```

## Arguments

- data:

  A data frame with columns \`ref_date\` and \`value\`, as returned by
  \[compute_time_trend()\].

- group:

  Character string naming the grouping column, or \`"ref_date"\` for no
  grouping.

## Value

The input data frame with \`value\` rescaled to a baseline index.
