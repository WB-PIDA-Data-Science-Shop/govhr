# Keep the contracts of active personnel

Matches each contract to the personnel module by `personnel_id` and
`ref_date`, and keeps only the contracts of people whose
`employment_status` is `"active"` on that date. Contracts with no
matching personnel record are dropped.

## Usage

``` r
keep_active_contracts(contracts, personnel)
```

## Arguments

- contracts:

  A data frame or lazy database table with `personnel_id` and
  `ref_date`.

- personnel:

  A data frame or lazy database table with `personnel_id`, `ref_date`
  and `employment_status`. For lazy tables, it must live in the same
  database as `contracts`.

## Value

`contracts`, filtered to active personnel, with an `employment_status`
column taken from `personnel` (always `"active"`).
