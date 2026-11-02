# Compute employment tenure from a stacked contract panel

Computes cumulative employment tenure for each personnel member at each
reference date while avoiding double-counting overlapping contracts.
Contracts with type `"inactive"` or `"pensioner"` are excluded.
Open-ended contracts are truncated at the corresponding reference date,
after which overlapping contract periods are merged before calculating
total tenure.

## Usage

``` r
compute_tenure_panel(contracts, ...)

# S3 method for class 'data.frame'
compute_tenure_panel(
  contracts,
  personnel_id_col = "personnel_id",
  ref_date_col = "ref_date",
  contract_id_col = "contract_id",
  start_date_col = "start_date",
  end_date_col = "end_date",
  contract_type_col = "contract_type",
  group_cols = NULL,
  ...
)

# S3 method for class 'tbl_dbi'
compute_tenure_panel(
  contracts,
  personnel_id_col = "personnel_id",
  ref_date_col = "ref_date",
  contract_id_col = "contract_id",
  start_date_col = "start_date",
  end_date_col = "end_date",
  contract_type_col = "contract_type",
  group_cols = NULL,
  ...
)

# Default S3 method
compute_tenure_panel(contracts, ...)
```

## Arguments

- contracts:

  The stacked contract panel, as a data frame or a lazy database table
  (`tbl_dbi`). Must include personnel identifiers, contract start and
  end dates, reference dates, contract types, and any grouping variables
  supplied in `group_cols`.

- ...:

  Not used.

- personnel_id_col:

  Character. Name of the personnel identifier column. Default is
  `"personnel_id"`.

- ref_date_col:

  Character. Name of the reference date column. Default is `"ref_date"`.

- contract_id_col:

  Character. Not used: a contract seen more than once counts once
  without it. Kept so existing calls still work.

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

One row per unique combination of `personnel_id`, optional `group_cols`,
and `ref_date` (a data.table for a data frame, a lazy table for a
`tbl_dbi`), containing:

- tenure_days:

  Total employment tenure in days.

- tenure_years:

  Total employment tenure in years, calculated as tenure days divided by
  365.25.

## Details

Tenure is calculated independently within each combination of
`personnel_id`, optional grouping variables supplied through
`group_cols`, and `ref_date`, from the contracts listed at that
reference date.

As in
[`compute_tenure()`](https://wb-pida-data-science-shop.github.io/govhr/reference/compute_tenure.md),
each snapshot's contracts count only the part not already covered by the
person's earlier-starting ones, a contract listed twice in a snapshot
counts once (to its latest end), and missing contract types count as
active.
