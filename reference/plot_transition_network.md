# Plot transition network

**\[deprecated\]**

This function is deprecated. Use
[`plot_transition()`](https://wb-pida-data-science-shop.github.io/govhr/reference/plot_transition.md)
instead, which also takes the counts returned by
[`compute_transition()`](https://wb-pida-data-science-shop.github.io/govhr/reference/compute_transition.md)
through `weight_col`.

## Usage

``` r
plot_transition_network(data, interactive = TRUE)
```

## Arguments

- data:

  Data frame with one row per move and `from` and `to` columns, as
  returned by
  [`detect_transition()`](https://wb-pida-data-science-shop.github.io/govhr/reference/detect_transition.md).

- interactive:

  Logical. If `TRUE` (default), return an interactive chart that shows
  each group's name on hover. If `FALSE`, return a static ggplot.

## Value

A ggiraph girafe object, or a ggplot object when `interactive = FALSE`.
