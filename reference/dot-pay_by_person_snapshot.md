# Total pay per person and snapshot, with contract columns from one contract

Used by
[`build_survival_panel()`](https://wb-pida-data-science-shop.github.io/govhr/reference/build_survival_panel.md)
to turn contracts into one row per person and snapshot:

- `.pay` is the total across the person's contracts, leaving out a
  contract with missing pay (`NA` only if all of them are missing);

- `contract_cols` (e.g. occupation) come from the one contract that
  [`.choose_contract()`](https://wb-pida-data-science-shop.github.io/govhr/reference/dot-choose_contract.md)
  picks.

## Usage

``` r
.pay_by_person_snapshot(
  contracts,
  person_year,
  contract_id_col,
  salary_col,
  contract_cols,
  select_contract
)
```

## Arguments

- contracts:

  The contract table (any data frame).

- person_year:

  The person and snapshot columns.

- contract_id_col, salary_col:

  The contract id and pay columns.

- contract_cols:

  Columns to take from the chosen contract, or empty.

- select_contract:

  `"highest_paid"` or `"lowest_paid"`.

## Value

A data.table with one row per person and snapshot: `person_year`,
`contract_cols` and `.pay`.
