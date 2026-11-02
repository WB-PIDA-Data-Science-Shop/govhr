# Plot transitions as a network

Draws moves between groups as a directed graph: one numbered node per
group and one arrow per origin and destination, as wide as the number of
moves. Nodes are numbered from the group with the most moves in and out,
and the legend matches each number to its group.

## Usage

``` r
plot_transition(data, weight_col = NULL, legend = TRUE, interactive = FALSE)
```

## Arguments

- data:

  Data frame with `from` and `to` columns: one row per move, as returned
  by
  [`detect_transition()`](https://wb-pida-data-science-shop.github.io/govhr/reference/detect_transition.md),
  or one row per origin and destination with a count, as returned by
  [`compute_transition()`](https://wb-pida-data-science-shop.github.io/govhr/reference/compute_transition.md).
  Bring a lazy table (`tbl_dbi`) into memory first with
  [`dplyr::collect()`](https://dplyr.tidyverse.org/reference/compute.html),
  ideally after counting the moves with
  [`compute_transition()`](https://wb-pida-data-science-shop.github.io/govhr/reference/compute_transition.md).

- weight_col:

  Character. Column counting the moves on each row, such as
  `"transitions"` for
  [`compute_transition()`](https://wb-pida-data-science-shop.github.io/govhr/reference/compute_transition.md)
  output, or `NULL` (default) to count each row as one move.

- legend:

  Logical. Show the legend matching node numbers to groups. Default
  `TRUE`.

- interactive:

  Logical. If `TRUE`, return an interactive chart that shows each
  group's name on hover. If `FALSE` (default), return a static ggplot,
  for outputs such as Word that cannot show interactive charts.

## Value

A ggplot object, or a ggiraph girafe object when `interactive = TRUE`.

## Details

A node's area is proportional to the number of moves in and out of its
group, with a minimum size so that the number drawn on it stays legible.

The plot takes its font and colours from the active ggplot2 theme, to
match the figures around it.

## See also

[`plot_transition_flows()`](https://wb-pida-data-science-shop.github.io/govhr/reference/plot_transition_flows.md)
for moves in and out of each group over time.

## Examples

``` r
careers <- data.frame(
  personnel_id = c("a", "a", "b", "b", "c", "c"),
  ref_date = as.Date(rep(c("2020-01-01", "2021-01-01"), times = 3)),
  unit = c("A", "B", "A", "C", "B", "A")
)
transitions <- compute_transition(careers, group_col = "unit")
plot_transition(transitions, weight_col = "transitions")

```
