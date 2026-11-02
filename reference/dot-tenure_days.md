# Tenure as the union of contract intervals, for a data frame

The calculation behind the data frame methods of
[`compute_tenure()`](https://wb-pida-data-science-shop.github.io/govhr/reference/compute_tenure.md)
and
[`compute_tenure_panel()`](https://wb-pida-data-science-shop.github.io/govhr/reference/compute_tenure_panel.md):
per key (person, groups and, for a panel, the snapshot), the days
covered by at least one active contract up to the reference date.

## Usage

``` r
.tenure_days(
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

  A data frame of contracts.

- keys:

  Character vector. The columns to compute tenure by.

- ref:

  A `Date`: one for every row, or one per row (a panel's snapshot
  dates).

- start_date_col, end_date_col, contract_type_col:

  Character. The contract start date, end date and type columns.

## Value

A data.table with `keys`, `tenure_days` and `tenure_years`, sorted by
`keys`.

## Details

Each contract counts only the part not already covered by the key's
earlier-starting contracts:
`max(0, end - max(start, latest earlier end))`. The latest earlier end
is a running maximum within each key. Rather than a grouped
[`cummax()`](https://rdrr.io/r/base/cumsum.html) (one R call per key,
slow with millions of keys), it is one vectorised pass: after sorting,
each key's end dates are lifted by `key number * step`, with `step`
wider than the span of all dates, so the running maximum can never carry
over from the key before.

Only the needed columns of the kept rows are copied, so `contracts`
stays untouched.
