# Compute employment tenure from a stacked contract panel

Computes cumulative employment tenure for each personnel member at each
reference date while avoiding double-counting overlapping contracts.
Contracts with type `"inactive"` or `"pensioner"` are excluded.
Open-ended contracts are truncated at the corresponding reference date,
after which overlapping contract periods are merged before calculating
total tenure.

## Usage

``` r
compute_tenure_panel(
  contract_dt,
  personnel_id_col = "personnel_id",
  ref_date_col = "ref_date",
  contract_id_col = "contract_id",
  start_date_col = "start_date",
  end_date_col = "end_date",
  contract_type_col = "contract_type",
  group_cols = NULL
)
```

## Arguments

- contract_dt:

  data.table containing the stacked contract panel. Must include
  personnel identifiers, contract identifiers, contract start and end
  dates, reference dates, contract types, and any grouping variables
  supplied in `group_cols`.

- personnel_id_col:

  Character. Name of the personnel identifier column. Default is
  `"personnel_id"`.

- ref_date_col:

  Character. Name of the reference date column. Default is `"ref_date"`.

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

A data.table with one row per unique combination of `personnel_id`,
optional `group_cols`, and `ref_date`, containing:

- tenure_days:

  Total employment tenure in days.

- tenure_years:

  Total employment tenure in years, calculated as tenure days divided by
  365.25.

## Details

Tenure is calculated independently within each combination of
`personnel_id`, optional grouping variables supplied through
`group_cols`, and `ref_date`.
