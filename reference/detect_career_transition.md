# Detect career transitions

Collapses each entity's history into spells of consecutive periods in
the same group, then pairs each spell with the one that follows it. A
row is dated by `ref_date`, the period in which the entity is first
observed in the destination group, so a transition is counted when it
happens. `from_date` records when the origin spell began.

## Usage

``` r
detect_career_transition(
  data,
  id_col = "contract_id",
  group_cols,
  return_all = FALSE
)
```

## Arguments

- data:

  Data frame containing a `ref_date` column, the identifier and the
  grouping columns.

- id_col:

  Character. Column identifying the entity whose career is tracked.
  Default `"contract_id"`.

- group_cols:

  Character vector of columns defining the career position (e.g.
  paygrade, department). Multiple columns are pasted into one label.

- return_all:

  Logical. Keep terminal spells, which have no destination and so carry
  `NA` in both `to` and `ref_date`. Default `FALSE`.

## Value

A data table with the identifier, `from`, `to`, `from_date` and
`ref_date`.

## Details

Records must be uniquely identified by `id_col` and `ref_date`. An
entity holding more than one record in the same period has no
well-defined position, so every record for that entity is dropped with a
warning reporting how many.
