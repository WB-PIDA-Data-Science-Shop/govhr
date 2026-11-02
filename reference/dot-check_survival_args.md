# Check the inputs of build_survival_panel()

Shared by the data.frame and tbl_dbi methods, so the checks cannot drift
apart. Stops with an error if only one of `contracts` and `salary_col`
is given, if a required column is missing from `personnel` or
`contracts`, or if a covariate is in both tables (ambiguous) or in
neither.

## Usage

``` r
.check_survival_args(
  personnel,
  contracts,
  tenure_col,
  salary_col,
  status_col,
  covariate_cols,
  personnel_id_col,
  ref_date_col,
  contract_id_col
)
```

## Arguments

- personnel, contracts:

  The personnel and contract tables, as data frames or lazy database
  tables. `contracts` may be `NULL`.

- tenure_col, salary_col, status_col:

  Character. The tenure (in `personnel`), pay (in `contracts`, or
  `NULL`) and employment status (in `personnel`, or `NULL`) columns.

- covariate_cols:

  Character vector or `NULL`. Covariates, each from exactly one of the
  two tables.

- personnel_id_col, ref_date_col, contract_id_col:

  Character. The person, snapshot date and contract id columns.

## Value

`NULL`, invisibly.
