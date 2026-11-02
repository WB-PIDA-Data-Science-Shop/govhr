# Plot a service table

Draws the expected years of service left (`ex`) at each duration, one
line per group. Dots show how many people each duration's stay rate
rests on, so thin durations stand out.

## Usage

``` r
# S3 method for class 'service_table'
plot(x, show_n = TRUE, ...)
```

## Arguments

- x:

  A service table from
  [`compute_service_table()`](https://wb-pida-data-science-shop.github.io/govhr/reference/compute_service_table.md).

- show_n:

  `TRUE` (the default) to draw the dots. They need the `pop` column,
  which `include_all = FALSE` leaves out.

- ...:

  Not used.

## Value

A ggplot. Add to it as usual, e.g.
`+ ggplot2::labs(x = "Years of service")`.

## See also

[`compute_service_table()`](https://wb-pida-data-science-shop.github.io/govhr/reference/compute_service_table.md)
for the table.

## Examples

``` r
st <- compute_service_table(
  bra_hrmis_personnel, "age", group_cols = "gender", smooth = TRUE
)
plot(st)

```
