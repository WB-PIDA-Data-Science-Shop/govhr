# Plot hires or separations over time

Draws hires or separations for each reference date, as counts or rates,
from the output of
[`compute_movement()`](https://wb-pida-data-science-shop.github.io/govhr/reference/compute_movement.md).

## Usage

``` r
plot_movement(
  data,
  movement_type = c("hire", "separation"),
  measurement_type = c("count", "rate"),
  group_cols = NULL
)
```

## Arguments

- data:

  Output of
  [`compute_movement()`](https://wb-pida-data-science-shop.github.io/govhr/reference/compute_movement.md).
  A lazy table (`tbl_dbi`) is brought into memory first.

- movement_type:

  Character. `"hire"` (default) or `"separation"`.

- measurement_type:

  Character. `"count"` (default) or `"rate"`.

- group_cols:

  Character. A column to draw one line per group, such as `"gender"`. It
  should be one of the `group_cols` used in
  [`compute_movement()`](https://wb-pida-data-science-shop.github.io/govhr/reference/compute_movement.md).
  `NULL` (default) or `"ref_date"` draws a single line.

## Value

A ggplot2 object.

## Details

Dates with no hires or separations to compare with (`NA` in `data`),
such as the first date for hires, are left out of the plot.

## Examples

``` r
hr <- data.frame(
  personnel_id = c(1, 2, 1, 3, 1, 3),
  ref_date = as.Date(rep(c("2020-01-01", "2021-01-01", "2022-01-01"), each = 2)),
  employment_status = "active"
)
movement <- compute_movement(hr)
plot_movement(movement, movement_type = "separation", measurement_type = "rate")

```
