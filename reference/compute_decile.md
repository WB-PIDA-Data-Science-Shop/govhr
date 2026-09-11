# Compute Deciles of a Measure

Assigns rows to deciles of \`measure_col\` within each group and
reference date, then reports the median and mean of the measure in each
decile.

## Usage

``` r
compute_decile(.data, group_cols = NULL, measure_col, latest_measure = FALSE)
```

## Arguments

- .data:

  Data frame containing a \`ref_date\` column and the measure.

- group_cols:

  Character vector of columns to group by, or \`NULL\` for no grouping.

- measure_col:

  Character. Numeric column to rank into deciles.

- latest_measure:

  Logical. Restrict to the latest reference date and drop \`ref_date\`
  from the grouping. Default \`FALSE\`.

## Value

A data frame with the grouping columns, \`decile\`, \`median_value\` and
\`mean_value\`.
