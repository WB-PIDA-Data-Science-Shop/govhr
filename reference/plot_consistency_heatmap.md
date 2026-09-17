# Plot consistency heatmap by group

Plot consistency heatmap by group

## Usage

``` r
plot_consistency_heatmap(data, id_col, group_cols, group = NULL)
```

## Arguments

- data:

  A data frame.

- id_col:

  A string. The column name of the unique identifier for each record.

- group_cols:

  A string. The column name of the grouping variable (e.g., "ref_date").

- group:

  Deprecated. Use `group_cols` instead.

## Value

A plotly heatmap object representing consistency values by group and
variable.
