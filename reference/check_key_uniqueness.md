# Check Primary Key Uniqueness in a Dataset

This internal function tests whether a combination of variables uniquely
identifies rows in a dataset. It reports the number of duplicate keys
and returns the duplicate rows if any are found.

## Usage

``` r
check_key_uniqueness(dt, keys)
```

## Arguments

- dt:

  A data.table containing the module to check.

- keys:

  A character vector specifying the primary key columns.

## Value

A list with:

- `n_duplicates`:

  Number of duplicated key combinations.

- `duplicate_rows`:

  A data.table of problematic records (if any).
