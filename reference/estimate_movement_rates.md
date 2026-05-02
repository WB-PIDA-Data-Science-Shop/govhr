# Estimate Movement Baseline from Panel Data

Analyzes longitudinal panel data to compute empirical transition
probabilities for promotions and transfers. Compares consecutive
snapshots (T0-\>T1, T1-\>T2, etc.) and returns one row per
`(from_group, to_group, from_period, to_period)` pair. Only actual
transitions (`from_group != to_group`) are returned; stay rows and rows
with NA in any group_col are dropped.

To obtain a single averaged rate across all periods, aggregate the
result:
`result[, .(movement_rate = mean(movement_rate)), by = .(from_group, to_group)]`

## Usage

``` r
estimate_movement_rates(
  contract_dt,
  group_cols,
  personnel_id_col = "personnel_id",
  ref_date_col = "ref_date",
  start_date_col = "start_date",
  end_date_col = "end_date",
  contract_type_col = "contract_type_code"
)
```

## Arguments

- contract_dt:

  data.table. Contract data in long (panel) format. Must contain
  ref_date_col for panel identification.

- group_cols:

  Character vector. Columns defining movement states (e.g., c("est_id",
  "paygrade") or c("paygrade"))

- personnel_id_col:

  Character. Personnel ID column (default: "personnel_id")

- ref_date_col:

  Character. Reference date column (default: "ref_date")

- start_date_col:

  Character. Contract start date column (default: "start_date")

- end_date_col:

  Character. Contract end date column (default: "end_date")

- contract_type_col:

  Character. Contract type column (default: "contract_type_code")

## Value

data.table with columns:

- from_group:

  Character. State at period start (concatenated group_cols)

- to_group:

  Character. State at period end (concatenated group_cols)

- movement_rate:

  Numeric. Transition probability for this specific period pair

- from_period:

  Date. Start snapshot date (T0)

- to_period:

  Date. End snapshot date (T1)

- n_pop:

  Integer. Number of persons in from_group at T0

- n_moves:

  Integer. Number of persons who moved from from_group to to_group
