# Plot changes as bars above or below zero

Draws a proportional change, such as a growth rate, as one bar per value
of `x_col`, blue when it is zero or above and orange when it is below.

## Usage

``` r
plot_change(data, x_col, y_col, group_cols = NULL, x_lab = NULL, y_lab = NULL)
```

## Arguments

- data:

  Data frame with the columns named in `x_col`, `y_col` and
  `group_cols`.

- x_col:

  Character. Column for the x-axis, usually `"ref_date"`.

- y_col:

  Character. Column holding the change as a proportion, so `0.1` means
  10%.

- group_cols:

  Character vector of columns to split the plot into one panel per
  group, or `NULL` (default) for a single panel.

- x_lab, y_lab:

  Character. Axis labels, or `NULL` (default) for none.

## Value

A ggplot2 object.

## Details

Rows with a missing change, such as the first date, which has no earlier
value to change from, are left out. When `x_col` is `"ref_date"`, it
must be a Date, and the axis is labelled by year.

## Examples

``` r
growth <- data.frame(
  ref_date = as.Date(c("2020-01-01", "2021-01-01", "2022-01-01")),
  wage_growth = c(NA, 0.05, -0.02)
)
plot_change(growth, x_col = "ref_date", y_col = "wage_growth", y_lab = "Wage growth")

```
