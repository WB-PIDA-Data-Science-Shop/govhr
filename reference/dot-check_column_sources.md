# Check that each column comes from exactly one of personnel and contracts

Used for the survival panel's covariates (see
[`.check_survival_args()`](https://wb-pida-data-science-shop.github.io/govhr/reference/dot-check_survival_args.md)).
Stops with an error if a column is in both tables (ambiguous) or in
neither.

## Usage

``` r
.check_column_sources(cols, personnel, contracts, noun)
```

## Arguments

- cols:

  Character vector of column names, or `NULL`.

- personnel, contracts:

  The two tables.

- noun:

  What the columns are called in the error, e.g. `"group column"`.

## Value

`NULL`, invisibly.
