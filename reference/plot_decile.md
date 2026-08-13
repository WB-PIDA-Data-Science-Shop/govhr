# Plot Decile Summary

Plot Decile Summary

## Usage

``` r
plot_decile(.data, group_cols)
```

## Arguments

- .data:

  A data frame produced by \`compute_decile()\`, containing columns
  \`decile\`, \`mean_value\`, and optionally a grouping column.

- group_cols:

  A character string indicating the grouping column, or "ref_date" for
  no grouping.

## Value

A ggplot2 object representing the decile summary.

## Examples

``` r
govhr::compute_decile(
  govhr::bra_hrmis_contract,
  measure_col = "gross_salary_lcu",
  group_cols = "paygrade"
) |>
  govhr::plot_decile(group_cols = "paygrade")
```
