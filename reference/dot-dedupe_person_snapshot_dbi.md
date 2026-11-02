# Keep one row per person and snapshot of a lazy personnel table

The database counterpart of the de-duplication in the data.frame methods
of
[`estimate_decrement_rates()`](https://wb-pida-data-science-shop.github.io/govhr/reference/estimate_decrement_rates.md)
and
[`build_survival_panel()`](https://wb-pida-data-science-shop.github.io/govhr/reference/build_survival_panel.md):
if any person has several rows at one snapshot, warns with their number
and keeps the first by status, then by `tiebreak_col` if given, missing
values last. The missing-last order is spelled out, because databases
differ in where they sort NULLs.

## Usage

``` r
.dedupe_person_snapshot_dbi(
  panel,
  personnel_id_col,
  ref_date_col,
  tiebreak_col = NULL
)
```

## Arguments

- panel:

  A lazy table (`tbl_dbi`) with the columns `.pid`, `.ref` and
  `.status`.

- personnel_id_col, ref_date_col:

  Character. The original person and snapshot date column names, for the
  warning.

- tiebreak_col:

  Character or `NULL`. A column of `panel` that orders rows with the
  same status (e.g. tenure, lowest first), so the row kept does not
  depend on the database.

## Value

`panel`, lazily filtered to one row per `.pid` and `.ref`, or unchanged
if there were no duplicates. Counting them runs one query.
