# Plot transitions in and out of each group

Draws, for each group and reference date, the moves into the group as
blue bars above zero and the moves out of it as orange bars below zero,
with one panel per group.

## Usage

``` r
plot_transition_flows(data)
```

## Arguments

- data:

  Data frame output of
  [`compute_transition_flows()`](https://wb-pida-data-science-shop.github.io/govhr/reference/compute_transition_flows.md).
  Bring a lazy table (`tbl_dbi`) into memory first with
  [`dplyr::collect()`](https://dplyr.tidyverse.org/reference/compute.html).

## Value

A ggplot2 object.

## See also

[`plot_transition()`](https://wb-pida-data-science-shop.github.io/govhr/reference/plot_transition.md)
for the moves between groups as a network.

## Examples

``` r
careers <- data.frame(
  personnel_id = c("a", "a", "b", "b", "c", "c"),
  ref_date = as.Date(rep(c("2020-01-01", "2021-01-01"), times = 3)),
  unit = c("A", "B", "A", "C", "B", "A")
)
compute_transition(careers, group_col = "unit") |>
  compute_transition_flows() |>
  plot_transition_flows()

```
