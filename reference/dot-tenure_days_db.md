# Tenure as the union of contract intervals, in a database

The database version of
[`.tenure_days()`](https://wb-pida-data-science-shop.github.io/govhr/reference/dot-tenure_days.md),
as dplyr verbs that dbplyr turns into SQL. The latest end among the
key's earlier contracts is a window function,
`MAX(end) OVER (PARTITION BY keys ORDER BY start ROWS BETWEEN UNBOUNDED PRECEDING AND 1 PRECEDING)`,
and days are differences of dates (`DATE - DATE`, a number of days in
DuckDB and PostgreSQL). Contracts with the same start add up to their
latest end whatever order the window puts them in, so the result matches
[`.tenure_days()`](https://wb-pida-data-science-shop.github.io/govhr/reference/dot-tenure_days.md).

## Usage

``` r
.tenure_days_db(
  contracts,
  keys,
  ref,
  start_date_col,
  end_date_col,
  contract_type_col
)
```

## Arguments

- contracts:

  A lazy table of contracts.

- keys:

  Character vector. The columns to compute tenure by.

- ref:

  The reference date, as an expression for
  [`mutate()`](https://dplyr.tidyverse.org/reference/mutate.html): a
  column symbol (a panel's snapshot date) or a SQL date literal.

- start_date_col, end_date_col, contract_type_col:

  Character. The contract start date, end date and type columns.

## Value

A lazy table with `keys`, `tenure_days` and `tenure_years`.
