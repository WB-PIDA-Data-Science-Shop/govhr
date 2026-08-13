# Estimate Historical Non-Retirement Exit Rates from Panel Data

Uses `govhr::detect_personnel_event(event_type = "fire")` to identify
non-retirement attrition events (voluntary resignation, dismissal,
contract non-renewal) across the full historical panel. Computes
`exit_rate = n_exits / n_active` per group per panel snapshot, then
returns the mean rate per group.

## Usage

``` r
estimate_exit_rates(
  contract_dt,
  personnel_dt,
  group_cols = NULL,
  freq = "year",
  ref_date = NULL,
  personnel_id_col = "personnel_id",
  ref_date_col = "ref_date",
  start_date_col = "start_date",
  contract_type_col = "contract_type",
  end_date_col = "end_date",
  status_col = "employment_status"
)
```

## Arguments

- contract_dt:

  data.table. Full panel of contract data (all `ref_date` snapshots).

- personnel_dt:

  data.table. Full panel of personnel data.

- group_cols:

  Character vector or `NULL`. Columns to group by (e.g. `"est_id"`).
  Pass `NULL` for an overall (ungrouped) rate.

- freq:

  Character. Frequency passed to
  [`govhr::detect_personnel_event()`](https://wb-pida-data-science-shop.github.io/govhr/reference/detect_personnel_event.md).
  Default `"year"`.

- ref_date:

  Date or character. Optional reference date (currently unused; included
  to prevent partial argument matching against `ref_date_col`).

- personnel_id_col:

  Character. Default `"personnel_id"`.

- ref_date_col:

  Character. Default `"ref_date"`.

- start_date_col:

  Character. Default `"start_date"`.

- contract_type_col:

  Character. Default `"contract_type_code"`.

- end_date_col:

  Character. Default `"end_date"`.

- status_col:

  Character. Default `"employment_status"`.

## Value

data.table with `group_cols` (if specified) and `exit_rate` column.
