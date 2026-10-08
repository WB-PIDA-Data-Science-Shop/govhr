# Plot coverage over time

Plots coverage for each reference date, one line per group, from
coverage already computed.

## Usage

``` r
plot_coverage_trend(data, group_col = "ref_date", toggle_growth = FALSE)
```

## Arguments

- data:

  Data frame with `ref_date`, `coverage` and the column named in
  `group_col`, such as the output of
  `compute_coverage(include_ref_date = TRUE, aggregate = TRUE)`.

- group_col:

  Character. Column to draw one line per group, or `"ref_date"`
  (default) for a single line.

- toggle_growth:

  Logical. Show coverage as a baseline index, with each group's first
  date at 100. Default `FALSE`.

## Value

A ggplot2 object.

## See also

[`compute_coverage()`](https://wb-pida-data-science-shop.github.io/govhr/reference/compute_coverage.md),
which computes the coverage.

## Examples

``` r
hr <- data.frame(
  ref_date = as.Date(c("2020-01-01", "2020-01-01", "2021-01-01")),
  gender = c("F", NA, "M")
)
hr |>
  compute_coverage(include_ref_date = TRUE, aggregate = TRUE) |>
  plot_coverage_trend()

```
