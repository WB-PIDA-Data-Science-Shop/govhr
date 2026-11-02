# Plot transition heatmap

Draws transitions between groups as a heatmap, origin groups on the
y-axis and destination groups on the x-axis, from red for no moves
through yellow for a typical number of moves to green for the most.

## Usage

``` r
plot_transition_heatmap(data)
```

## Arguments

- data:

  Data frame with `from`, `to` and `transitions` columns, such as the
  output of
  [`compute_transition()`](https://wb-pida-data-science-shop.github.io/govhr/reference/compute_transition.md).
  Moves are added up over all reference dates.

## Value

A plotly object.
