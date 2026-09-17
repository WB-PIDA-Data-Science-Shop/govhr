# Compute Decrement Outcome Counts for a Single Consecutive Snapshot Pair

Internal workhorse intended to be called by
[`roll_snapshot_pairs()`](https://wb-pida-data-science-shop.github.io/govhr/reference/roll_snapshot_pairs.md)
inside a future
[`estimate_decrement_rates()`](https://wb-pida-data-science-shop.github.io/govhr/reference/estimate_decrement_rates.md),
mirroring the role
[`.compute_transition_pair()`](https://wb-pida-data-science-shop.github.io/govhr/reference/dot-compute_transition_pair.md)
plays for movement rates. Given two consecutive panel snapshots
(`snap_t0` at T0 and `snap_t1` at T1), this function:

1.  Defines the exposure cohort as every person with
    `status_col == "active"` at T0, and tabulates exposure by
    `age_col`/`group_cols` using each person's T0 age and group – ages
    are never shifted, since individuals are tracked by identity rather
    than aggregated independently per snapshot.

2.  Looks up each cohort member's `status_col` value at T1 via a native
    data.table join (`x[i, on =]`) on `personnel_id_col`. Anyone absent
    from `snap_t1` altogether (i.e. dropped out of the panel) is
    assigned the synthetic outcome `"non-retirement-exit"`.

3.  Builds the outcome vocabulary from whatever `status_col` values
    actually appear in `snap_t1` (e.g. `"active"`, `"pensioner"`,
    `"deceased"`, ...), unioned with `"non-retirement-exit"`, which is
    always included since it is synthesized rather than drawn from the
    data. No status values are hardcoded.

4.  Counts, per `age_col`/`group_cols`/`status_col` combination, how
    many cohort members ended up with each outcome at T1 – including
    `"active"` (i.e. stayed), so the resulting rates for a given
    age/group sum to 1 across all outcome types.

5.  Expands the result to a complete grid of every exposure age/group
    crossed with every outcome type, filling `exits = 0` where a
    combination had no occurrences, so no age/group ever collapses into
    an ambiguous `NA`-status row.

## Usage

``` r
.compute_decrement_pair(
  snap_t0,
  snap_t1,
  age_col,
  status_col,
  personnel_id_col,
  ref_date_col,
  group_cols
)
```

## Arguments

- snap_t0:

  Data.table. Subset of the full personnel panel at snapshot T0, already
  filtered to a single reference date. Must contain `age_col`,
  `status_col`, `personnel_id_col`, `ref_date_col`, and `group_cols`.

- snap_t1:

  Data.table. Subset of the full personnel panel at snapshot T1 (the
  period immediately following T0). Same column requirements as
  `snap_t0`.

- age_col:

  Character. Name of the (integer or coercible-to-integer) age column.
  Exposure and outcome counts are keyed by each person's T0 age.

- status_col:

  Character. Name of the employment status column (e.g.
  `"employment_status"`). The literal value `"active"` defines the T0
  exposure cohort; every other value observed at T1, plus the
  synthesized `"non-retirement-exit"`, forms the outcome vocabulary.

- personnel_id_col:

  Character. Name of the personnel identifier column, used to join each
  cohort member's T0 record to their T1 status.

- ref_date_col:

  Character. Name of the reference date column used to extract the T0
  and T1 dates attached to the output.

- group_cols:

  A character vector. Additional columns (e.g. gender, service type) to
  stratify exposure and outcome counts by, alongside `age_col`.

## Value

A `data.table` with one row per `(age_col, group_cols, status_col)`
combination observed in the T0 exposure cohort. Columns:

- age_col:

  Integer. T0 age (column name taken from `age_col`).

- group_cols:

  The stratifying columns, taken directly from T0.

- status_col:

  Character. The T1 outcome type (column name taken from `status_col`),
  e.g. `"active"`, `"pensioner"`, `"non-retirement-exit"`.

- pop:

  Integer. Number of active persons at T0 in this age/group (the
  exposure, and the denominator for `decrement_rate`).

- exits:

  Integer. Number of cohort members in this age/group who had this
  outcome at T1. `0L` where the combination had no occurrences.

- decrement_rate:

  Numeric. \\exits / pop\\ for this age/group/outcome combination.

- t0_date:

  Date. Reference date of the T0 snapshot.

- t1_date:

  Date. Reference date of the T1 snapshot.

## See also

[`.compute_transition_pair`](https://wb-pida-data-science-shop.github.io/govhr/reference/dot-compute_transition_pair.md),
[`roll_snapshot_pairs`](https://wb-pida-data-science-shop.github.io/govhr/reference/roll_snapshot_pairs.md)
