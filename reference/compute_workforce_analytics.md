# Compute standard workforce indicators

Produces a standard set of workforce indicators in one call: how many
people work in government, where they work, how many join and leave, and
how many move between establishments. Each indicator comes from an
existing govhr function, so the results match what those functions
return on their own.

## Usage

``` r
compute_workforce_analytics(contracts, personnel)
```

## Arguments

- contracts:

  Data frame or remote database table (`tbl_dbi`) with the contract
  data, one row per contract and reference date. Must contain
  `personnel_id`, `ref_date` and `est_id`.

- personnel:

  Data frame or remote database table (`tbl_dbi`) with the personnel
  data. Must contain `personnel_id`, `ref_date` and `employment_status`
  (with `"active"` marking people currently employed). For database
  input, it must live in the same database as `contracts`.

## Value

A named list of tables:

- headcount:

  Headcount for each `ref_date`, from
  [`compute_headcount()`](https://wb-pida-data-science-shop.github.io/govhr/reference/compute_headcount.md).

- headcount_by_est:

  Headcount and share of the total for each establishment and
  `ref_date`, from
  [`compute_headcount()`](https://wb-pida-data-science-shop.github.io/govhr/reference/compute_headcount.md).

- movement:

  Headcount, hires, separations and their rates for each `ref_date`,
  from
  [`compute_movement()`](https://wb-pida-data-science-shop.github.io/govhr/reference/compute_movement.md).
  Hires are `NA` on the first date and separations on the last, since
  there is nothing to compare with.

- transitions:

  One row per move between establishments, with `personnel_id`, origin
  (`from`), destination (`to`), when the person joined the origin
  (`from_date`) and when they arrived at the destination (`ref_date`),
  from
  [`compute_transition()`](https://wb-pida-data-science-shop.github.io/govhr/reference/compute_transition.md).

Each table has the class its function returns for `contracts`:
data.tables for data frame input, lazy tables for `tbl_dbi` input (use
[`dplyr::collect()`](https://dplyr.tidyverse.org/reference/compute.html)
to bring them into memory).

## Details

Only active personnel are counted: each contract is matched to
`personnel` by `personnel_id` and `ref_date`, and kept only if
`employment_status` is `"active"` on that date. Contracts with no
matching personnel record are left out. Each indicator function then
picks the method for the class of the data, so a database table is
processed in the database.

Hires and separations are counted per person, so someone holding several
contracts on the same date is counted once.

A person recorded in more than one establishment on the same date has no
single position that period, so
[`compute_transition()`](https://wb-pida-data-science-shop.github.io/govhr/reference/compute_transition.md)
leaves them out of `transitions` and warns about it.

## Examples

``` r
contracts <- data.frame(
  personnel_id = rep(1:3, each = 3),
  ref_date = rep(as.Date(c("2020-01-01", "2021-01-01", "2022-01-01")), times = 3),
  est_id = c("A", "A", "A", "B", "B", "A", "A", "A", "B")
)
personnel <- data.frame(
  personnel_id = rep(1:3, each = 3),
  ref_date = rep(as.Date(c("2020-01-01", "2021-01-01", "2022-01-01")), times = 3),
  employment_status = c(
    "active", "active", "active",
    "inactive", "active", "active",
    "active", "active", "inactive"
  )
)
compute_workforce_analytics(contracts, personnel)
#> $headcount
#>      ref_date headcount share_headcount
#>        <Date>     <int>           <num>
#> 1: 2020-01-01         2               1
#> 2: 2021-01-01         3               1
#> 3: 2022-01-01         2               1
#> 
#> $headcount_by_est
#>    est_id   ref_date headcount share_headcount
#>    <char>     <Date>     <int>           <num>
#> 1:      A 2020-01-01         2       1.0000000
#> 2:      A 2021-01-01         2       0.6666667
#> 3:      A 2022-01-01         2       1.0000000
#> 4:      B 2021-01-01         1       0.3333333
#> 
#> $movement
#>      ref_date headcount hires separations hire_rate separation_rate
#>        <Date>     <int> <int>       <int>     <num>           <num>
#> 1: 2020-01-01         2    NA           0        NA       0.0000000
#> 2: 2021-01-01         3     1           1 0.3333333       0.3333333
#> 3: 2022-01-01         2     0          NA 0.0000000              NA
#>    replacement_rate
#>               <num>
#> 1:               NA
#> 2:                1
#> 3:               NA
#> 
#> $transitions
#>    personnel_id   from     to  from_date   ref_date
#>           <int> <char> <char>     <Date>     <Date>
#> 1:            2      B      A 2021-01-01 2022-01-01
#> 
```
