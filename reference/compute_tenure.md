# Calculate Tenure from Contract History

Computes total years of service for each personnel as of a reference
date using a vectorised interval-union algorithm based on
[`cummax()`](https://rdrr.io/r/base/cumsum.html). Overlapping and nested
contracts are correctly de-duplicated; gaps between contracts are
excluded from the total.

The algorithm sorts each person's contracts by start date, then
propagates the "furthest right endpoint seen so far" with
[`cummax()`](https://rdrr.io/r/base/cumsum.html). Three cases cover all
interval relationships:

- **Case 1** (new span): start \> lag_cummax → contributes `end - start`

- **Case 2** (extension): end \> lag_cummax ≥ start → contributes
  `end - lag_cummax`

- **Case 3** (nested): end ≤ lag_cummax → contributes 0

## Usage

``` r
compute_tenure(
  contract_dt,
  ref_date,
  personnel_id_col = "personnel_id",
  contract_id_col = "contract_id",
  start_date_col = "start_date",
  end_date_col = "end_date",
  contract_type_col = "contract_type_code"
)
```

## Arguments

- contract_dt:

  data.table. Contract data (may contain panel observations)

- ref_date:

  Date. Reference date for tenure calculation

- personnel_id_col:

  Character. Name of personnel ID column (default: "personnel_id")

- contract_id_col:

  Character. Name of contract ID column (default: "contract_id")

- start_date_col:

  Character. Name of start date column (default: "start_date")

- end_date_col:

  Character. Name of end date column (default: "end_date")

- contract_type_col:

  Character. Name of contract type column (default:
  "contract_type_code")

## Value

data.table with personnel_id, tenure_days, and tenure_years columns

## Examples

``` r
if (FALSE) { # \dontrun{
tenure_dt <- compute_tenure(
  contract_dt = contract_data,
  ref_date = as.Date("2025-01-01")
)
} # }
```
