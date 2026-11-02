# Compute employment tenure from contract history

Computes cumulative employment tenure for each personnel member as of a
specified reference date while avoiding double-counting overlapping
contracts. Contracts with type `"inactive"` or `"pensioner"` are
excluded. Open-ended contracts are truncated at the reference date
before overlapping contract periods are merged to calculate total
tenure.

## Usage

``` r
compute_tenure(contracts, ...)

# S3 method for class 'data.frame'
compute_tenure(
  contracts,
  ref_date,
  personnel_id_col = "personnel_id",
  contract_id_col = "contract_id",
  start_date_col = "start_date",
  end_date_col = "end_date",
  contract_type_col = "contract_type",
  group_cols = NULL,
  ...
)

# S3 method for class 'tbl_dbi'
compute_tenure(
  contracts,
  ref_date,
  personnel_id_col = "personnel_id",
  contract_id_col = "contract_id",
  start_date_col = "start_date",
  end_date_col = "end_date",
  contract_type_col = "contract_type",
  group_cols = NULL,
  ...
)

# Default S3 method
compute_tenure(contracts, ...)
```

## Arguments

- contracts:

  The contract history, as a data frame or a lazy database table
  (`tbl_dbi`). Must include personnel identifiers, contract start and
  end dates, contract types, and any grouping variables supplied in
  `group_cols`.

- ...:

  Not used.

- ref_date:

  Date. Reference date at which tenure is calculated.

- personnel_id_col:

  Character. Name of the personnel identifier column. Default is
  `"personnel_id"`.

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

One row per unique combination of `personnel_id` and optional
`group_cols` (a data.table for a data frame, a lazy table for a
`tbl_dbi`), containing:

- tenure_days:

  Total employment tenure in days.

- tenure_years:

  Total employment tenure in years, calculated as tenure days divided by
  365.25.

## Details

Tenure is calculated independently for each personnel member and,
optionally, within additional grouping variables supplied through
`group_cols`. Gaps between contracts are excluded from the total tenure.

**Overlaps.** Contracts are sorted by start date, and each counts only
the part not already covered by the person's earlier ones (the union of
the intervals). This is \\O(n \log n)\\, dominated by the sort; the
running maximum of earlier end dates is one vectorised pass for data
frames and a window function in the database.

**A contract seen more than once** (e.g. at several snapshots of a
panel) counts once, from its start to its latest recorded end. With
`group_cols`, a contract seen in several groups (e.g. paygrades) counts
in each.

**Missing contract types** count as active.

## Examples

``` r
if (FALSE) { # \dontrun{
tenure_dt <- compute_tenure(
  contracts = contract_data,
  ref_date = as.Date("2025-01-01")
)
} # }
```
