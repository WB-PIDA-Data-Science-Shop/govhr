# Detect transitions

Tracks how entities move between groups, such as paygrades or
departments, over time. A move happens when an entity joins a group it
did not hold in its previous period, and pairs each group it held then
with each group it joins, returning one record per transition

## Usage

``` r
detect_transition(data, ...)

# S3 method for class 'data.frame'
detect_transition(
  data,
  id_col = "personnel_id",
  group_col,
  drop_duplicates = FALSE,
  across_separations = FALSE,
  ...
)

# S3 method for class 'tbl_dbi'
detect_transition(
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

One row per move with the identifier, `from` (a group held in the period
before the move), `to` (a group joined), `from_date` (when the entity
began holding `from` without a break) and `ref_date` (when the entity
was first seen in `to`). A data.table for data frame input; a lazy table
for `tbl_dbi` input (use
[`dplyr::collect()`](https://dplyr.tidyverse.org/reference/compute.html)
to bring it into memory).

## Details

Each move is dated when it happens: `ref_date` is the first period the
entity is seen in its new group. Dating it by when the entity entered
its previous group would instead push every first move back to the start
of the data.

An entity may belong to several groups on the same date, such as two
occupations. Each group it held in its previous period is paired with
each group it joins, so holding `A` and `B` and then `A` and `C` gives
two moves, `A -> C` and `B -> C`. Leaving a group without joining
another, such as holding `A` and `B` and then only `A`, is not a move.
Several records in the same group, such as two contracts in the same
paygrade, hold it once.

With `drop_duplicates = TRUE`, an entity with more than one record on a
date, even in the same group, is dropped entirely, with a warning saying
how many records were removed.

An entity may separate itself from the public sector and return later in
time. By default its return starts a new career: the groups it held
before leaving are the last of the old career, and the groups it returns
to are not moves. Pass only the records in which entities are active,
such as active contracts, so that inactive periods count as separations.
With `across_separations = TRUE`, separations are ignored, so a move can
span dates on which the entity is missing.

Rows with a missing identifier or group are silently dropped.

## See also

[`compute_transition()`](https://wb-pida-data-science-shop.github.io/govhr/reference/compute_transition.md),
which counts these moves.
[`plot_transition_network()`](https://wb-pida-data-science-shop.github.io/govhr/reference/plot_transition_network.md)
to draw them as a network.

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
detect_transition(careers, group_col = "paygrade")
#>    personnel_id   from     to  from_date   ref_date
#>          <char> <char> <char>     <Date>     <Date>
#> 1:            a     G1     G2 2020-01-01 2022-01-01
#> 2:            b      A      C 2020-01-01 2021-01-01
#> 3:            b      B      C 2020-01-01 2021-01-01

# b holds two paygrades at once, so is dropped
detect_transition(careers, group_col = "paygrade", drop_duplicates = TRUE)
#> Warning: 2 record(s) are not uniquely identified by `personnel_id` and `ref_date`; dropping all 4 record(s) for the 1 affected `personnel_id` value(s).
#>    personnel_id   from     to  from_date   ref_date
#>          <char> <char> <char>     <Date>     <Date>
#> 1:            a     G1     G2 2020-01-01 2022-01-01

# c leaves after 2020 and returns to a different paygrade in 2022
returns <- data.frame(
  personnel_id = "c",
  ref_date = as.Date(c("2020-01-01", "2022-01-01")),
  paygrade = c("G1", "G2")
)
detect_transition(rbind(careers, returns), group_col = "paygrade")
#>    personnel_id   from     to  from_date   ref_date
#>          <char> <char> <char>     <Date>     <Date>
#> 1:            a     G1     G2 2020-01-01 2022-01-01
#> 2:            b      A      C 2020-01-01 2021-01-01
#> 3:            b      B      C 2020-01-01 2021-01-01
detect_transition(
  rbind(careers, returns),
  group_col = "paygrade",
  across_separations = TRUE
)
#>    personnel_id   from     to  from_date   ref_date
#>          <char> <char> <char>     <Date>     <Date>
#> 1:            a     G1     G2 2020-01-01 2022-01-01
#> 2:            b      A      C 2020-01-01 2021-01-01
#> 3:            b      B      C 2020-01-01 2021-01-01
#> 4:            c     G1     G2 2020-01-01 2022-01-01
```
