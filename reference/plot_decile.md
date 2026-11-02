# Plot decile summary

Plot decile summary

## Usage

``` r
plot_decile(data, group_col, group_cols = lifecycle::deprecated())
```

## Arguments

- data:

  A data frame produced by
  [`compute_decile()`](https://wb-pida-data-science-shop.github.io/govhr/reference/compute_decile.md),
  containing columns `decile`, `mean_value`, and optionally a grouping
  column.

- group_col:

  Character. A column to draw one panel per group, or `"ref_date"` for
  no grouping.

- group_cols:

  **\[deprecated\]** Use `group_col` instead.

## Value

A ggplot2 object representing the decile summary.

## Examples

``` r
govhr::compute_decile(
  govhr::bra_hrmis_contract,
  measure_col = "gross_salary_lcu",
  group_cols = "paygrade"
) |>
  govhr::plot_decile(group_col = "paygrade")
```
