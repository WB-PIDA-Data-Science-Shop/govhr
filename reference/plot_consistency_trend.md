# Plot consistency over time

Plots record or value consistency for each reference date, one line per
group, from consistency already computed.

## Usage

``` r
plot_consistency_trend(
  data,
  group_col = "ref_date",
  type_plot = c("record", "value"),
  toggle_growth = FALSE
)
```

## Arguments

- data:

  Data frame or lazy table (`tbl_dbi`) with `ref_date`, the column named
  in `group_col` and `record_consistency` or `value_consistency`, such
  as the output of
  [`compute_record_consistency()`](https://wb-pida-data-science-shop.github.io/govhr/reference/compute_record_consistency.md)
  or
  [`compute_value_consistency()`](https://wb-pida-data-science-shop.github.io/govhr/reference/compute_value_consistency.md)
  grouped by `group_col` and `ref_date`. A lazy table is brought into
  memory first.

- group_col:

  Character. Column to draw one line per group, or `"ref_date"`
  (default) for a single line.

- type_plot:

  Character. `"record"` (default) or `"value"`, the kind of consistency
  in `data`.

- toggle_growth:

  Logical. Show consistency as a baseline index, with each group's first
  date at 100. Default `FALSE`.

## Value

A ggplot2 object.

## See also

[`compute_record_consistency()`](https://wb-pida-data-science-shop.github.io/govhr/reference/compute_record_consistency.md)
and
[`compute_value_consistency()`](https://wb-pida-data-science-shop.github.io/govhr/reference/compute_value_consistency.md),
which compute the consistency.

## Examples

``` r
hr <- data.frame(
  personnel_id = c("a", "a", "b", "a"),
  ref_date = as.Date(c(rep("2020-01-01", 3), "2021-01-01"))
)
hr |>
  compute_record_consistency("personnel_id", group_cols = "ref_date") |>
  plot_consistency_trend()

```
