# Add each contract's country from the establishment module

Matches on `est_id` only, so a gap in the establishment's dates does not
lose its country. Any `country_code` already in `contracts` is replaced.

## Usage

``` r
add_country_code(contracts, establishment)
```

## Arguments

- contracts:

  Data frame or remote database table (`tbl_dbi`) of contracts, with an
  `est_id` column.

- establishment:

  Data frame or remote database table of establishments, with `est_id`
  and `country_code` columns.

## Value

`contracts` with a `country_code` column. An error if an `est_id` has
more than one country; a warning if an `est_id` is missing from
`establishment` (its `country_code` is `NA`).
