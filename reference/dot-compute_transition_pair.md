# Compute Transition Counts for a Single Consecutive Snapshot Pair

Internal workhorse called by
[`roll_snapshot_pairs()`](https://wb-pida-data-science-shop.github.io/govhr/reference/roll_snapshot_pairs.md)
inside
[`estimate_movement_rates()`](https://wb-pida-data-science-shop.github.io/govhr/reference/estimate_movement_rates.md).
Given two consecutive panel snapshots (`snap_t0` at T0 and `snap_t1` at
T1), this function:

1.  Filters each snapshot to *active* contracts, defined as records
    where `start_date_col <= ref_date`, `end_date_col` \>= `ref_date`
    (or `end_date` is `NA`), and `contract_type_col != "inactive"`.

2.  Constructs a state label per person at T0 (`from_group`) and T1
    (`to_group`) by concatenating `group_cols` values with `"||"` as
    separator. When `salary_col` is supplied, salary is first summed
    within each person-group combination via
    [`compute_fastsummary()`](https://wb-pida-data-science-shop.github.io/govhr/reference/compute_fastsummary.md)
    to handle multi-contract persons before state labels are formed.

3.  Joins T0 and T1 states on person ID (inner join), so persons who
    exit between T0 and T1 are excluded from transition counts.

4.  Counts transitions per `(from_group, to_group)` pair and divides by
    the T0 population in `from_group` to obtain a period-specific
    transition probability. Groups with zero movers are retained with
    `n_moves = 0L`.

5.  When `salary_col` is supplied, computes salary summary statistics
    *over movers only* (persons who appear in both snapshots), not over
    the full T0 population.

## Usage

``` r
.compute_transition_pair(
  snap_t0,
  snap_t1,
  ref_date_col,
  group_cols,
  personnel_id_col,
  start_date_col,
  end_date_col,
  contract_type_col,
  salary_col = NULL
)
```

## Arguments

- snap_t0:

  data.table. Subset of the full panel at snapshot T0, already filtered
  to a single reference date. Must contain `ref_date_col`,
  `personnel_id_col`, `group_cols`, `start_date_col`, `end_date_col`,
  and `contract_type_col`.

- snap_t1:

  data.table. Subset of the full panel at snapshot T1 (the period
  immediately following T0). Same column requirements as `snap_t0`.

- ref_date_col:

  Character. Name of the reference date column used to extract T0 and T1
  dates from the snapshots.

- group_cols:

  Character vector. Columns whose concatenated values define the
  movement state for each person. Rows with `NA` in any of these columns
  are dropped via [`na.omit()`](https://rdrr.io/r/stats/na.fail.html)
  before state labels are formed.

- personnel_id_col:

  Character. Name of the personnel identifier column. Internally renamed
  to `".pid"` during processing.

- start_date_col:

  Character. Name of the contract start date column, used in the
  active-contract filter.

- end_date_col:

  Character. Name of the contract end date column, used in the
  active-contract filter. `NA` values are treated as open-ended
  contracts (i.e., still active at the snapshot date).

- contract_type_col:

  Character. Name of the contract type column. Records with value
  `"inactive"` are excluded from both snapshots.

- salary_col:

  Character or `NULL`. Name of a compensation column. When provided,
  salary is summed per person-group via
  `compute_fastsummary(fns = "sum")` before state construction, and
  salary summary columns are appended to the output. Default: `NULL`.

## Value

A `data.table` with one row per `(from_group, to_group)` pair observed
in this period, or `NULL` if either snapshot contains no active
contracts after filtering. Columns:

- from_group:

  Character. Concatenated `group_cols` state at T0.

- to_group:

  Character. Concatenated `group_cols` state at T1. `NA` for T0 groups
  where no movers were observed (these rows carry `n_moves = 0L` and are
  filtered downstream).

- n_moves:

  Integer. Number of persons who moved from `from_group` to `to_group`
  between T0 and T1. Set to `0L` for T0 groups with no observed movers.

- n_pop:

  Integer. Number of active persons in `from_group` at T0 (the
  denominator for `period_prob`).

- period_prob:

  Numeric. Transition probability for this pair in this period:
  \\n\\moves / n\\pop\\.

- t0_date:

  Date. Reference date of the T0 snapshot.

- t1_date:

  Date. Reference date of the T1 snapshot.

When `salary_col` is not `NULL`, the following columns are prepended
(computed over movers only, i.e., persons present in both snapshots):

- mean_salary_t0:

  Numeric. Mean of per-person salary sums in `from_group` at T0.

- mean_salary_t1:

  Numeric. Mean of per-person salary sums in `to_group` at T1.

- mean_salary_change:

  Numeric. Mean absolute salary change (T1 sum minus T0 sum) across
  movers.

- median_salary_change:

  Numeric. Median absolute salary change across movers.

- mean_salary_pct_change:

  Numeric. Mean percentage salary change (\\(salary\_{T1} -
  salary\_{T0}) / salary\_{T0}\\) across movers.

## See also

[`estimate_movement_rates`](https://wb-pida-data-science-shop.github.io/govhr/reference/estimate_movement_rates.md),
[`roll_snapshot_pairs`](https://wb-pida-data-science-shop.github.io/govhr/reference/roll_snapshot_pairs.md)
