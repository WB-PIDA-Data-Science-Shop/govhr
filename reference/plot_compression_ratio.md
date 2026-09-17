# Plot compression ratio

Plot compression ratio

## Usage

``` r
plot_compression_ratio(data, group_cols = NULL)
```

## Arguments

- data:

  A data frame containing the compression ratio data produced by
  [`compute_compression_ratio()`](https://wb-pida-data-science-shop.github.io/govhr/reference/compute_compression_ratio.md).

- group_cols:

  A character vector of columns to group by, or `"ref_date"` for no
  grouping.

## Value

A ggplot2 object representing the compression ratio.
