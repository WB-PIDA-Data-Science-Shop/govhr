# Build a service table from pooled decrement rates

The shared engine of both methods of
[`compute_service_table()`](https://wb-pida-data-science-shop.github.io/govhr/reference/compute_service_table.md),
which only differ in how they get the rates (in memory, or collected
from the database): the stay rate at every duration
([`.stay_rates()`](https://wb-pida-data-science-shop.github.io/govhr/reference/dot-stay_rates.md)),
chained into `lx`, `Lx`, `Tx` and `ex`
([`.chain_service_table()`](https://wb-pida-data-science-shop.github.io/govhr/reference/dot-chain_service_table.md)).

## Usage

``` r
.service_table_from_rates(
  decrement_dt,
  duration_col,
  status_col,
  group_cols,
  include_all,
  settings
)
```

## Arguments

- decrement_dt:

  A data.table from
  [`estimate_decrement_rates()`](https://wb-pida-data-science-shop.github.io/govhr/reference/estimate_decrement_rates.md).
  Its duration and status columns are renamed by reference.

- duration_col, status_col, group_cols, include_all:

  As in
  [`compute_service_table()`](https://wb-pida-data-science-shop.github.io/govhr/reference/compute_service_table.md).

- settings:

  The list from
  [`.service_table_settings()`](https://wb-pida-data-science-shop.github.io/govhr/reference/dot-service_table_settings.md).

## Value

A `service_table` (see
[`compute_service_table()`](https://wb-pida-data-science-shop.github.io/govhr/reference/compute_service_table.md)).
