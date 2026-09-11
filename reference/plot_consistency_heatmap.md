# Plot Consistency Heatmap by Group

Plot Consistency Heatmap by Group

## Usage

``` r
plot_consistency_heatmap(data, id_col, group)
```

## Arguments

- data:

  A data frame.

- id_col:

  Character string. The column name of the unique identifier for each
  record.

- group:

  Character string. The column name of the grouping variable (e.g.,
  "ref_date").

## Value

A plotly heatmap object representing consistency values by group and
variable.
