# Chain stay rates into expected years of service

Part of
[`.service_table_from_rates()`](https://wb-pida-data-science-shop.github.io/govhr/reference/dot-service_table_from_rates.md).
Follows `radix` people from each group's lowest duration: `lx` are those
still in service, `Lx` the years they serve in the year (someone who
leaves counts half), `Tx` the years from there to the end of the table,
and `ex = Tx / lx`. After a duration everyone left (`px = 0`) no one is
left, so `ex` is `NA` there, with a warning.

## Usage

``` r
.chain_service_table(stay_dt, duration_col, group_cols, radix, smooth)
```

## Arguments

- stay_dt:

  The output of
  [`.stay_rates()`](https://wb-pida-data-science-shop.github.io/govhr/reference/dot-stay_rates.md),
  sorted by group and duration.

- duration_col:

  The original duration column name, for the warning.

- group_cols:

  As in
  [`compute_service_table()`](https://wb-pida-data-science-shop.github.io/govhr/reference/compute_service_table.md).

- radix:

  The size of the imaginary group.

- smooth:

  Whether the rates were smoothed (the warning only suggests smoothing
  if not).

## Value

`stay_dt` with `lx`, `lx_next`, `Lx`, `Tx` and `ex` added.
