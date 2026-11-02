# Plot stacked areas over time

Draws `y_col` over time as stacked areas, one per value of `fill_col`,
such as headcount by contract type.

## Usage

``` r
plot_area(
  data,
  x_col = "ref_date",
  y_col,
  fill_col = NULL,
  x_lab = NULL,
  y_lab = NULL
)
```

## Arguments

- data:

  Data frame with the columns named in `x_col`, `y_col` and `fill_col`.

- x_col:

  Character. Date column for the x-axis. Default `"ref_date"`.

- y_col:

  Character. Column to stack.

- fill_col:

  Character. Column whose values each get their own area, or `NULL`
  (default) for a single area.

- x_lab, y_lab:

  Character. Axis labels, or `NULL` (default) for none.

## Value

A ggplot2 object.

## Details

The x-axis is labelled by year, so `x_col` must be a Date.

## Examples

``` r
headcount <- data.frame(
  ref_date = as.Date(rep(c("2020-01-01", "2021-01-01"), each = 2)),
  contract_type = rep(c("permanent", "temporary"), times = 2),
  headcount = c(80, 20, 85, 25)
)
plot_area(headcount, y_col = "headcount", fill_col = "contract_type", y_lab = "Headcount")

```
