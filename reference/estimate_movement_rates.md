# Estimate Movement Baseline from Panel Data

Analyzes longitudinal panel data to compute empirical transition
probabilities for promotions and transfers. Compares consecutive
snapshots (T0 -\> T1, T1 -\> T2, etc.) using
[`roll_snapshot_pairs()`](https://wb-pida-data-science-shop.github.io/govhr/reference/roll_snapshot_pairs.md)
and
[`.compute_transition_pair()`](https://wb-pida-data-science-shop.github.io/govhr/reference/dot-compute_transition_pair.md),
and returns one row per `(from_group, to_group, from_period, to_period)`
pair.

Only actual transitions (`from_group != to_group`) are returned; stay
rows and rows where any `group_cols` value is `NA` (or the string
`"NA"`) are dropped.

To obtain a single averaged rate across all periods, aggregate the
result:


    result[, .(movement_rate = mean(movement_rate)), by = .(from_group, to_group)]

## Usage

``` r
estimate_movement_rates(
  contract_dt,
  group_cols,
  personnel_id_col = "personnel_id",
  ref_date_col = "ref_date",
  start_date_col = "start_date",
  end_date_col = "end_date",
  contract_type_col = "contract_type",
  salary_col = NULL
)
```

## Arguments

- contract_dt:

  data.table. Contract data in long (panel) format. Must contain
  `ref_date_col` for panel snapshot identification.

- group_cols:

  Character vector. One or more columns defining the movement states
  between which transitions are measured (e.g.,
  `c("est_id", "paygrade")` or `c("paygrade")`). Values are concatenated
  into a single state label when multiple columns are provided.

- personnel_id_col:

  Character. Name of the personnel identifier column. Default:
  `"personnel_id"`.

- ref_date_col:

  Character. Name of the reference (snapshot) date column used to
  identify panel periods. Default: `"ref_date"`.

- start_date_col:

  Character. Name of the contract start date column. Default:
  `"start_date"`.

- end_date_col:

  Character. Name of the contract end date column. Default:
  `"end_date"`.

- contract_type_col:

  Character. Name of the contract type column. Default:
  `"contract_type"`.

- salary_col:

  Character or `NULL`. Name of a compensation column in `contract_dt`.
  When provided, salary summary columns are appended to the output (see
  Value). Default: `NULL`.

## Value

A `data.table` with one row per
`(from_group, to_group, from_period, to_period)` transition pair, keyed
on those four columns. Returns an empty `data.table` with the same
schema if no valid transitions are found. Columns:

- from_group:

  Character. Concatenated `group_cols` state at the start of the period
  (T0).

- to_group:

  Character. Concatenated `group_cols` state at the end of the period
  (T1).

- movement_rate:

  Numeric. Empirical transition probability for this specific period
  pair: \\n\\moves / n\\pop\\.

- from_period:

  Date. Snapshot date at the start of the period (T0).

- to_period:

  Date. Snapshot date at the end of the period (T1).

- n_pop:

  Integer. Number of persons in `from_group` at T0.

- n_moves:

  Integer. Number of persons who moved from `from_group` to `to_group`
  between T0 and T1.

When `salary_col` is not `NULL`, five additional columns are appended:

- mean_salary_t0:

  Numeric. Mean salary in `from_group` at T0.

- mean_salary_t1:

  Numeric. Mean salary in `to_group` at T1.

- mean_salary_change:

  Numeric. Absolute change in mean salary (T1 minus T0).

- median_salary_change:

  Numeric. Median absolute salary change across movers.

- mean_salary_pct_change:

  Numeric. Mean percentage salary change across movers.
