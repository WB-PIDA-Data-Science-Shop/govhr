# Compute the cost of hires and separations

Adds up, for each reference date, the pay of the people who were hired
or separated since the previous date.

## Usage

``` r
compute_movement_cost(data, ...)

# S3 method for class 'data.frame'
compute_movement_cost(
  data,
  event_type = c("hire", "separation"),
  measure_col,
  group_cols = NULL,
  status_col = "employment_status",
  ...
)

# S3 method for class 'tbl_dbi'
compute_movement_cost(
  data,
  event_type = c("hire", "separation"),
  measure_col,
  group_cols = NULL,
  status_col = "employment_status",
  ...
)
```

## Arguments

- data:

  Data frame or remote database table (`tbl_dbi`) with one row per
  person-record. Must contain `personnel_id`, `ref_date` and the columns
  named in `measure_col` and `status_col`.

- ...:

  Arguments passed to methods.

- event_type:

  Character vector of the movements to cost: `"hire"`, `"separation"` or
  both. Default both.

- measure_col:

  Character. Name of the pay column to add up.

- group_cols:

  Character vector of columns to group by, such as `"est_id"`, or `NULL`
  (default) for the whole workforce. Must not include `ref_date`.

- status_col:

  Character. Column holding employment status. Only rows equal to
  `"active"` are considered. Default `"employment_status"`.

## Value

A table with one row per `ref_date`, group and movement type, containing
`movement_type` (one of `event_type`) and `movement_cost`, the movers'
pay. `movement_cost` is 0 when nobody moved, and `NA` on the first date,
which has nothing to compare with, and for the separations of a group
with nobody active on the previous date. A data.table for data frame
input; a lazy table for `tbl_dbi` input (use
[`dplyr::collect()`](https://dplyr.tidyverse.org/reference/compute.html)
to bring it into memory).

## Details

As in
[`compute_movement()`](https://wb-pida-data-science-shop.github.io/govhr/reference/compute_movement.md),
hires are counted on the date they are hired, and separations on the
first date the person is absent. Hires are costed at their pay on the
date they are hired, and separations at their pay on their last active
date. The pay on all of a mover's active records that date is added up,
so people with several contracts are costed in full; pay recorded
alongside, such as a pension, is not. Missing pay counts as 0.

With `group_cols`, each mover's pay is counted in the group of the
record it comes from. Every group with active personnel on a date
appears for that date, and a group that everyone left still appears on
the next date.

## See also

[`detect_movement()`](https://wb-pida-data-science-shop.github.io/govhr/reference/detect_movement.md),
which flags the movers.
[`compute_movement()`](https://wb-pida-data-science-shop.github.io/govhr/reference/compute_movement.md),
which counts them.
[`compute_retirement_cost()`](https://wb-pida-data-science-shop.github.io/govhr/reference/compute_retirement_cost.md),
which costs the retirements.

## Examples

``` r
hr <- data.frame(
  personnel_id = c(1, 1, 1, 2, 2),
  ref_date = as.Date(c(
    "2019-01-01", "2020-01-01", "2021-01-01", "2020-01-01", "2021-01-01"
  )),
  employment_status = "active",
  wage = c(100, 100, 100, 250, 250)
)
compute_movement_cost(hr, event_type = "hire", measure_col = "wage")
#>      ref_date movement_type movement_cost
#>        <Date>        <char>         <num>
#> 1: 2019-01-01          hire            NA
#> 2: 2020-01-01          hire           250
#> 3: 2021-01-01          hire             0
```
