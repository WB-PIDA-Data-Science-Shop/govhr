# Compute a service table: expected years of service left

For each value of a duration, such as age or years of service, estimates
how many more years an employee in service at that duration stays, on
average (`ex`).

It works like a life table. From
[`estimate_decrement_rates()`](https://wb-pida-data-science-shop.github.io/govhr/reference/estimate_decrement_rates.md)
it takes the share of employees still in service a year later (`px`). It
then follows an imaginary group of employees from the lowest duration to
the highest, keeping a share `px` of them each year, and adds up the
years they serve.

## Usage

``` r
compute_service_table(personnel, ...)

# S3 method for class 'data.frame'
compute_service_table(
  personnel,
  duration_col,
  status_col = "employment_status",
  personnel_id_col = "personnel_id",
  ref_date_col = "ref_date",
  group_cols = NULL,
  include_all = TRUE,
  ...
)

# S3 method for class 'tbl_dbi'
compute_service_table(
  personnel,
  duration_col,
  status_col = "employment_status",
  personnel_id_col = "personnel_id",
  ref_date_col = "ref_date",
  group_cols = NULL,
  include_all = TRUE,
  ...
)

# Default S3 method
compute_service_table(personnel, ...)
```

## Arguments

- personnel:

  A data frame, or a database table (`tbl_dbi`), with one row per person
  and snapshot.

- ...:

  Rarely needed settings:

  - `smooth`: `TRUE` to smooth the stay rates across durations first,
    which evens out durations with few people. Default `FALSE`.

  - `span`: how much to smooth; larger is smoother. Default `0.75`.

  - `radix`: the size of the imaginary group. Default `100000`. It only
    scales `lx`, `Lx` and `Tx`.

- duration_col:

  The column of `personnel` to build the table on, in years: e.g.
  `"age"`, or years of service from
  [`compute_tenure_panel()`](https://wb-pida-data-science-shop.github.io/govhr/reference/compute_tenure_panel.md).
  Cut to whole years (2.9 counts as 2).

- status_col:

  The employment status column. `"active"` means in service; any other
  value is a way of leaving.

- personnel_id_col, ref_date_col:

  The person and snapshot date columns.

- group_cols:

  Columns to build a separate table for, e.g. `"gender"`, or `NULL` (the
  default) for one table.

- include_all:

  `TRUE` (the default) for every column; `FALSE` for only the duration,
  the groups, `px` and `ex`.

## Value

A `service_table`: a data.table with one row per group and duration,
from the lowest to the highest seen.
[plot()](https://wb-pida-data-science-shop.github.io/govhr/reference/plot.service_table.md)
draws it.

- pop:

  People in service at that duration, whom `px` is measured on. `NA`
  where smoothing filled in a missing duration.

- px:

  The share of them still in service a year later.

- lx, lx_next:

  How many of the imaginary group are in service at that duration, and a
  year later.

- Lx:

  Years they serve in that year (someone who leaves counts half).

- Tx:

  Years they serve from that duration to the end of the table.

- ex:

  Expected years of service left: `Tx / lx`.

## Details

**Not a forecast.** The table assumes someone meets, at every later
duration, the stay rates seen at that duration in your data. To project
your own workforce, apply
[`estimate_decrement_rates()`](https://wb-pida-data-science-shop.github.io/govhr/reference/estimate_decrement_rates.md)
to it year by year.

**One snapshot a year.** `px` is read as the chance of staying a year,
so with monthly data, keep one month a year first.

**Missing durations.** People with no `duration_col` are left out, with
a warning. If a whole duration is missing in a group (no one in service
at it), every group's rates are smoothed to fill the gap, with a
warning.

**Where it ends.** The table stops at the highest duration seen, so `ex`
counts no service after it. If everyone at some duration left, no one is
left after it: `ex` is `NA` from there, with a warning.

## See also

[`estimate_decrement_rates()`](https://wb-pida-data-science-shop.github.io/govhr/reference/estimate_decrement_rates.md)
for the rates of each way of leaving.

## Examples

``` r
st <- compute_service_table(bra_hrmis_personnel, "age", smooth = TRUE)
subset(st, age %in% c(25, 40, 55), select = c(age, px, ex))
#>      age        px        ex
#>    <int>     <num>     <num>
#> 1:    25 0.9052762 15.471887
#> 2:    40 0.9687776 15.068774
#> 3:    55 0.9152548  7.734391
plot(st)

```
