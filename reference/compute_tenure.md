# Compute employment tenure from contract history

Computes cumulative employment tenure for each personnel member as of a
specified reference date while avoiding double-counting overlapping
contracts. Contracts with type `"inactive"` or `"pensioner"` are
excluded. Open-ended contracts are truncated at the reference date
before overlapping contract periods are merged to calculate total
tenure.

## Usage

``` r
compute_tenure(
  contract_dt,
  ref_date,
  personnel_id_col = "personnel_id",
  contract_id_col = "contract_id",
  start_date_col = "start_date",
  end_date_col = "end_date",
  contract_type_col = "contract_type",
  group_cols = NULL
)
```

## Arguments

- contract_dt:

  data.table containing the contract history. Must include personnel
  identifiers, contract identifiers, contract start and end dates,
  contract types, and any grouping variables supplied in `group_cols`.

- ref_date:

  Date. Reference date at which tenure is calculated.

- personnel_id_col:

  Character. Name of the personnel identifier column. Default is
  `"personnel_id"`.

- contract_id_col:

  Character. Name of the contract identifier column. Default is
  `"contract_id"`.

- start_date_col:

  Character. Name of the contract start date column. Default is
  `"start_date"`.

- end_date_col:

  Character. Name of the contract end date column. Default is
  `"end_date"`.

- contract_type_col:

  Character. Name of the contract type column. Default is
  `"contract_type"`.

- group_cols:

  Optional character vector of additional variables over which tenure
  should be calculated independently (for example, establishment,
  occupation, or organization). Default is `NULL`.

## Value

A data.table with one row per unique combination of `personnel_id` and
optional `group_cols`, containing:

- tenure_days:

  Total employment tenure in days.

- tenure_years:

  Total employment tenure in years, calculated as tenure days divided by
  365.25.

## Details

Tenure is calculated independently for each personnel member and,
optionally, within additional grouping variables supplied through
`group_cols`. Gaps between contracts are excluded from the total tenure.

The implementation uses an interval-union algorithm based on
[`cummax()`](https://rdrr.io/r/base/cumsum.html) to efficiently merge
overlapping contract periods, resulting in an \\O(n \log n)\\ algorithm
dominated by the initial sorting step.

## Examples

``` r
if (FALSE) { # \dontrun{
tenure_dt <- compute_tenure(
  contract_dt = contract_data,
  ref_date = as.Date("2025-01-01")
)
} # }
```
