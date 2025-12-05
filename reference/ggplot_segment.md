# Plot segments overlaid with points, ordered by median

Compute per-group min/max/median for a numeric column and plot one
horizontal segment per group with individual points overlaid. Groups are
ordered from highest median to lowest.

## Usage

``` r
ggplot_segment(.data, col, group)
```

## Arguments

- .data:

  A data.frame or tibble.

- col:

  Unquoted numeric column (values).

- group:

  Unquoted grouping column.

## Value

A ggplot object.

## Examples

``` r
if (FALSE) { # \dontrun{
   ggplot_segment(df, salary, occupation)
} # }
```
