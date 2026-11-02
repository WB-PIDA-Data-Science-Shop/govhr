# Plot compression ratio

Plot compression ratio

## Usage

``` r
plot_compression_ratio(
  data,
  group_col = NULL,
  group_cols = lifecycle::deprecated()
)
```

## Arguments

- data:

  A data frame containing the compression ratio data produced by
  [`compute_compression_ratio()`](https://wb-pida-data-science-shop.github.io/govhr/reference/compute_compression_ratio.md).

- group_col:

  Character. A column to draw one range per group, or `NULL` (default)
  or `"ref_date"` for one range per reference date.

- group_cols:

  **\[deprecated\]** Use `group_col` instead.

## Value

A ggplot2 object representing the compression ratio.
