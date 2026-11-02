# Compute transitions in and out of each group

Adds up, for each group and reference date, the moves into the group and
the moves out of it.

## Usage

``` r
compute_transition_flows(data, ...)

# S3 method for class 'data.frame'
compute_transition_flows(data, ...)

# S3 method for class 'tbl_dbi'
compute_transition_flows(data, ...)
```

## Arguments

- data:

  Output of
  [`compute_transition()`](https://wb-pida-data-science-shop.github.io/govhr/reference/compute_transition.md),
  with `from`, `to`, `ref_date` and `transitions` columns.

- ...:

  Arguments passed to methods.

## Value

A table with one row per group and `ref_date`, containing `group`,
`ref_date`, `transitions_inflow` (moves into the group) and
`transitions_outflow` (moves out of it). A data.table for data frame
input; a lazy table for `tbl_dbi` input (use
[`dplyr::collect()`](https://dplyr.tidyverse.org/reference/compute.html)
to bring it into memory).

## Details

A group that only received or only sent people on a date has 0 moves the
other way, rather than being left out.

## See also

[`plot_transition_flows()`](https://wb-pida-data-science-shop.github.io/govhr/reference/plot_transition_flows.md)
to draw these flows.

## Examples

``` r
careers <- data.frame(
  personnel_id = c("a", "a", "b", "b", "c", "c"),
  ref_date = as.Date(rep(c("2020-01-01", "2021-01-01"), times = 3)),
  unit = c("A", "B", "A", "C", "B", "A")
)
compute_transition(careers, group_col = "unit") |>
  compute_transition_flows()
#>     group   ref_date transitions_inflow transitions_outflow
#>    <char>     <Date>              <int>               <int>
#> 1:      A 2021-01-01                  1                   2
#> 2:      B 2021-01-01                  1                   1
#> 3:      C 2021-01-01                  1                   0
```
