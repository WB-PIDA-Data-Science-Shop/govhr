# Plot transition network

Draws career transitions as a directed graph, with edge width
proportional to the number of transitions and node size to degree
centrality. Networks of ten or more nodes are labelled by index rather
than by name.

## Usage

``` r
plot_transition_network(data, interactive = TRUE)
```

## Arguments

- data:

  Data frame with one row per move and `from` and `to` columns, as
  returned by
  [`compute_transition()`](https://wb-pida-data-science-shop.github.io/govhr/reference/compute_transition.md)
  with `summarize = FALSE`.

- interactive:

  Logical. If `TRUE` (default), return an interactive chart that shows
  each establishment's name on hover. If `FALSE`, return a static
  ggplot, for outputs such as Word that cannot show interactive charts.

## Value

A ggiraph girafe object, or a ggplot object when `interactive = FALSE`.
