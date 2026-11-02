# Split a plot into one panel per group

Adds a
[`ggplot2::facet_wrap()`](https://ggplot2.tidyverse.org/reference/facet_wrap.html)
by `group_cols` to `plot`, after checking that `data` has those columns.
Used by
[`plot_change()`](https://wb-pida-data-science-shop.github.io/govhr/reference/plot_change.md).

## Usage

``` r
facet_by_group(plot, data, group_cols)
```

## Arguments

- plot:

  A ggplot2 object.

- data:

  The data drawn in `plot`, checked for `group_cols`.

- group_cols:

  Character vector of the columns to split by.

## Value

`plot` with the facets added.
