# Estimate movement baseline from panel data

Analyzes longitudinal panel data to compute empirical transition
probabilities for promotions and transfers. Compares every pair of
consecutive snapshots (T0 -\> T1, T1 -\> T2, etc.) and returns one row
per `(from_group, to_group, from_period, to_period)` pair.

Only actual transitions (`from_group != to_group`) are returned; stay
rows and rows where any `group_cols` value is `NA` (or the string
`"NA"`) are dropped.

To obtain a single averaged rate across all periods, aggregate the
result:


    result[, .(movement_rate = mean(movement_rate)), by = .(from_group, to_group)]

## Usage

``` r
estimate_movement_rates(contracts, ...)

# S3 method for class 'data.frame'
estimate_movement_rates(
  contracts,
  group_cols,
  personnel_id_col = "personnel_id",
  ref_date_col = "ref_date",
  start_date_col = "start_date",
  end_date_col = "end_date",
  contract_type_col = "contract_type",
  salary_col = NULL,
  ...
)

# S3 method for class 'tbl_dbi'
estimate_movement_rates(
  contracts,
  group_cols,
  personnel_id_col = "personnel_id",
  ref_date_col = "ref_date",
  start_date_col = "start_date",
  end_date_col = "end_date",
  contract_type_col = "contract_type",
  salary_col = NULL,
  ...
)

# Default S3 method
estimate_movement_rates(contracts, ...)
```

## Arguments

- contracts:

  A data frame (data.table, data.frame or tibble) or a remote database
  table (`tbl_dbi`, e.g. DuckDB) of contract data in long (panel)
  format. Must contain `ref_date_col` for panel snapshot identification.

- ...:

  Arguments passed to methods.

- group_cols:

  A character vector. One or more columns defining the movement states
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

  Character or `NULL`. Name of a compensation column in `contracts`.
  When provided, salary summary columns are appended to the output (see
  Value). Default: `NULL`.

## Value

A table with one row per
`(from_group, to_group, from_period, to_period)` transition pair – a
`data.table` keyed on those four columns for data frame input, or a lazy
table sorted by them for `tbl_dbi` input (use
[`dplyr::collect()`](https://dplyr.tidyverse.org/reference/compute.html)
to bring it into memory). Has no rows if no valid transitions are found.
Columns:

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

## Details

**How it works.** A contract counts on a snapshot date if it has
started, has not ended (or has no end date) and its type is not
`"inactive"`. Each person's position on a snapshot is their `group_cols`
value(s) on such a contract. Snapshots are numbered, and every person's
positions at snapshot k are joined to their positions at k + 1 in a
single pass over the panel, rather than one join per snapshot pair.

**Several contracts at once.** A person holding positions in several
groups on the same snapshot counts in each: they are at risk in every
`from_group` they hold, and every pairing of a T0 position with a T1
position is a transition. Someone in G1 and G2 at T0 and only G2 at T1
moves G1 -\> G2 (and stays in G2).

**Entries, exits and gaps.** Only people present (on an active contract)
at both T0 and T1 can move. Leavers still count in `n_pop`; entrants do
not. A person missing from a snapshot and back later is a leaver and
then an entrant, never a move across the gap.

**Salaries.** With `salary_col`, a person's salaries within one position
are summed (missing values ignored), and the statistics are taken over
the transitions in each `(from_group, to_group)` pair. A percentage
change from a T0 salary of 0 is `Inf`, or undefined (and left out of the
mean) if the T1 salary is also 0.

For a `tbl_dbi`, the same steps run inside the database as SQL, and the
result is returned lazily. Two small queries run straight away: the
snapshot dates, and the distinct `group_cols` values (to build the group
labels, which SQL cannot paste).
