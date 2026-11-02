# Pick one contract per person and snapshot

The highest-paid (or lowest-paid) contract, ties going to the lowest
contract id, and a contract with missing pay only if all of them are
missing. One sort and a pass keeping each group's first row, both in C,
which is several times faster than a grouped
[`max()`](https://rdrr.io/r/base/Extremes.html) filter on large panels
(and needs no separate tie-break).

## Usage

``` r
.choose_contract(
  contract_dt,
  person_year,
  salary_col,
  contract_id_col,
  select_contract
)
```

## Arguments

- contract_dt:

  A data.table of contracts. **Sorted by reference.**

- person_year:

  The person and snapshot columns.

- salary_col, contract_id_col:

  The pay and contract id columns.

- select_contract:

  `"highest_paid"` or `"lowest_paid"`.

## Value

The chosen rows of `contract_dt`, one per person and snapshot.
