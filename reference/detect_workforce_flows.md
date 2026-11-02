# Flag the flows of each active person and date

Flags, for each active person and reference date, whether they were
hired since the previous date, and whether they leave active status by
the next date into a pension (a retirement) or exiting the public sector
(a separation).

## Usage

``` r
detect_workforce_flows(data, ...)

# S3 method for class 'data.frame'
detect_workforce_flows(data, status_col = "employment_status", ...)

# S3 method for class 'tbl_dbi'
detect_workforce_flows(data, status_col = "employment_status", ...)
```

## Arguments

- data:

  Data frame or remote database table (`tbl_dbi`) with one row per
  person-record. Must contain `personnel_id`, `ref_date` and the column
  named in `status_col`.

- ...:

  Arguments passed to methods.

- status_col:

  Character. Column holding employment status. Rows equal to `"active"`
  are the active workforce, and rows equal to `"pensioner"` mark exits
  as retirements. Default `"employment_status"`.

## Value

A table with one row per active person and `ref_date`, containing
`personnel_id`, `ref_date`, `prev_date`, `next_date`, `hire`,
`separation` and `retirement`. `hire` is `NA` on the first date, and
`separation` and `retirement` on the last, which have nothing to compare
with. A data.table for data frame input; a lazy table for `tbl_dbi`
input.

## Details

See
[`detect_movement()`](https://wb-pida-data-science-shop.github.io/govhr/reference/detect_movement.md)
and
[`detect_retirement()`](https://wb-pida-data-science-shop.github.io/govhr/reference/detect_retirement.md)
for how hires, separations and retirements are defined.
