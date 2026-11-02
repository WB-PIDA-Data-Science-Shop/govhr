# Plot hires and separations over time

Draws hires, separations, both, or the net movement between them for
each reference date, as counts or rates, from the output of
[`compute_movement()`](https://wb-pida-data-science-shop.github.io/govhr/reference/compute_movement.md).

## Usage

``` r
plot_movement(
  data,
  movement_type = c("hire", "separation", "joint", "net"),
  measurement_type = c("count", "rate"),
  group_col = NULL,
  group_cols = lifecycle::deprecated()
)
```

## Arguments

- data:

  Output of
  [`compute_movement()`](https://wb-pida-data-science-shop.github.io/govhr/reference/compute_movement.md).
  A lazy table (`tbl_dbi`) is brought into memory first.

- movement_type:

  Character. What to draw:

  - `"hire"` (default): hires, as a line.

  - `"separation"`: separations, as a line.

  - `"joint"`: hires and separations, as two lines.

  - `"net"`: hires minus separations, as bars above or below zero.

- measurement_type:

  Character. `"count"` (default) or `"rate"`.

- group_col:

  Character. A column to split the plot by group, such as `"gender"`. It
  should be one of the `group_cols` used in
  [`compute_movement()`](https://wb-pida-data-science-shop.github.io/govhr/reference/compute_movement.md).
  `NULL` (default) or `"ref_date"` draws the whole workforce.

- group_cols:

  **\[deprecated\]** Use `group_col` instead.

## Value

A ggplot2 object.

## Details

Hires are drawn in blue and separations in orange, so the colours keep
their meaning across movement types: in `"net"`, a blue bar means more
hires than separations and an orange bar the reverse.

With one movement (`"hire"` or `"separation"`), each group gets its own
coloured line. With two (`"joint"` and `"net"`), each group gets its own
panel instead.

The net rate is the hire rate minus the separation rate, which is the
net change in headcount divided by the previous headcount, as both rates
share that denominator.

Dates with no hires or separations to compare with (`NA` in `data`),
such as the first date, are left out of the plot.

## Examples

``` r
hr <- data.frame(
  personnel_id = c(1, 2, 1, 3, 4, 1, 3),
  ref_date = as.Date(c(
    "2020-01-01", "2020-01-01",
    "2021-01-01", "2021-01-01", "2021-01-01",
    "2022-01-01", "2022-01-01"
  )),
  employment_status = "active"
)
movement <- compute_movement(hr)
plot_movement(movement, movement_type = "separation", measurement_type = "rate")

plot_movement(movement, movement_type = "joint")

plot_movement(movement, movement_type = "net")

```
