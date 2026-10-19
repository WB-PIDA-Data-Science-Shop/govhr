# Compute career transitions

Counts, for each reference date, how many entities moved from one group
to another since the previous date, and what share of the origin group
they make up.

## Usage

``` r
compute_transition(data, ...)

# S3 method for class 'data.frame'
compute_transition(
  data,
  id_col = "personnel_id",
  group_col,
  drop_duplicates = FALSE,
  across_separations = FALSE,
  ...
)

# S3 method for class 'tbl_dbi'
compute_transition(
  data,
  id_col = "personnel_id",
  group_col,
  drop_duplicates = FALSE,
  across_separations = FALSE,
  ...
)
```

## Arguments

- data:

  Data frame or remote database table (`tbl_dbi`) with a `ref_date`
  column, the identifier column and the grouping column.

- ...:

  Arguments passed to methods.

- id_col:

  Character. Column identifying whose career is tracked, such as a
  person or a contract. Default `"personnel_id"`.

- group_col:

  Character. Column defining a group, such as a paygrade or a
  department. To track a combination of groups, such as paygrade within
  department, combine them into one column beforehand (e.g.,
  `paste(paygrade, department, sep = "|")`).

- drop_duplicates:

  Logical. Drop every entity with more than one record on the same
  `ref_date`, with a warning, so that each entity belongs to a single
  group per period. Default `FALSE`, which keeps entities belonging to
  several groups at once. See Details.

- across_separations:

  Logical. Count moves made across a separation, i.e. between the groups
  an entity held before leaving the public sector and those it holds on
  its return. Default `FALSE`, which treats the return as the start of a
  new career. See Details.

## Value

A table with one row per `from`, `to` and `ref_date`, containing:

- transitions:

  Number of moves from `from` to `to` dated `ref_date`, as detected by
  [`detect_transition()`](https://wb-pida-data-science-shop.github.io/govhr/reference/detect_transition.md).

- transition_rate:

  `transitions` divided by the headcount in `from` on the previous date
  in the data, as in
  [`compute_movement()`](https://wb-pida-data-science-shop.github.io/govhr/reference/compute_movement.md).

A data.table for data frame input; a lazy table for `tbl_dbi` input (use
[`dplyr::collect()`](https://dplyr.tidyverse.org/reference/compute.html)
to bring it into memory).

## Details

Moves are found and dated as in
[`detect_transition()`](https://wb-pida-data-science-shop.github.io/govhr/reference/detect_transition.md),
so an entity holding several groups moves from each group it held to
each group it joins.

The headcount is the number of distinct entities in each group on each
date, from
[`count_entity()`](https://wb-pida-data-science-shop.github.io/govhr/reference/count_entity.md),
so each entity counts once in every group it holds. It is counted on the
same records as the moves: rows with a missing identifier or group, and
with `drop_duplicates = TRUE` the entities dropped as duplicates, are
left out of both.

With `across_separations = TRUE`, a move can span dates on which the
entity is missing, but `transition_rate` still divides by the headcount
on the previous date in the data, which such an entity is not part of.

## See also

[`detect_transition()`](https://wb-pida-data-science-shop.github.io/govhr/reference/detect_transition.md),
which finds each move.
[`compute_movement()`](https://wb-pida-data-science-shop.github.io/govhr/reference/compute_movement.md),
which counts hires and separations.

## Examples

``` r
careers <- data.frame(
  personnel_id = c("a", "a", "a", "b", "b", "b", "b"),
  ref_date = as.Date(c(
    "2020-01-01", "2021-01-01", "2022-01-01",
    "2020-01-01", "2020-01-01", "2021-01-01", "2021-01-01"
  )),
  paygrade = c("G1", "G1", "G2", "A", "B", "A", "C")
)
compute_transition(careers, group_col = "paygrade")
#>      from     to   ref_date transitions transition_rate
#>    <char> <char>     <Date>       <int>           <num>
#> 1:      A      C 2021-01-01           1               1
#> 2:      B      C 2021-01-01           1               1
#> 3:     G1     G2 2022-01-01           1               1
```
