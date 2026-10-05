# Compute career transitions

Tracks how people (or contracts) move between groups, such as paygrades
or departments, over time. Each entity's history is collapsed into
spells: runs of consecutive periods in the same group. Each spell is
then paired with the one that follows it, giving one row per move.

## Usage

``` r
compute_transition(data, ...)

# S3 method for class 'data.frame'
compute_transition(
  data,
  id_col = "contract_id",
  group_cols,
  return_all = FALSE,
  summarize = FALSE,
  ...
)

# S3 method for class 'tbl_dbi'
compute_transition(
  data,
  id_col = "contract_id",
  group_cols,
  return_all = FALSE,
  summarize = FALSE,
  ...
)
```

## Arguments

- data:

  Data frame or remote database table (`tbl_dbi`) with a `ref_date`
  column, the identifier column and the grouping columns.

- ...:

  Arguments passed to methods.

- id_col:

  Character. Column identifying whose career is tracked, such as a
  person or a contract. Default `"contract_id"`.

- group_cols:

  Character vector of columns defining a career position (e.g. paygrade,
  department). Several columns are combined into one label, such as
  `"G1 | Finance"`.

- return_all:

  Logical. Also keep each entity's last spell, which has no next group,
  so its `to` and `ref_date` are `NA`. This includes entities that never
  move. Default `FALSE`.

- summarize:

  Logical. Count moves by origin, destination and date instead of
  returning one row per move. Default `FALSE`.

## Value

With `summarize = FALSE`, one row per move with the identifier, `from`
(the group left), `to` (the group joined), `from_date` (when the spell
in `from` began) and `ref_date` (when the entity was first seen in
`to`).

With `summarize = TRUE`, one row per `from`, `to` and `ref_date`, with
`transitions`, the number of moves.

A data.table for data frame input; a lazy table for `tbl_dbi` input (use
[`dplyr::collect()`](https://dplyr.tidyverse.org/reference/compute.html)
to bring it into memory).

## Details

Each move is dated when it happens: `ref_date` is the first period the
entity is seen in its new group. Dating it by when the previous spell
began would instead push every first move back to the start of the data.

Rows with a missing identifier or group are dropped. Each entity must
have at most one record per `ref_date`, otherwise its position in that
period is unclear. Entities that break this rule are dropped entirely,
with a warning saying how many records were removed.

## See also

[`plot_transition_network()`](https://wb-pida-data-science-shop.github.io/govhr/reference/plot_transition_network.md)
to draw the moves as a network.

## Examples

``` r
careers <- data.frame(
  contract_id = c("a", "a", "a", "b", "b"),
  ref_date = as.Date(c(
    "2020-01-01", "2021-01-01", "2022-01-01", "2020-01-01", "2021-01-01"
  )),
  paygrade = c("G1", "G1", "G2", "G5", "G5")
)
compute_transition(careers, group_cols = "paygrade")
#>    contract_id   from     to  from_date   ref_date
#>         <char> <char> <char>     <Date>     <Date>
#> 1:           a     G1     G2 2020-01-01 2022-01-01
compute_transition(careers, group_cols = "paygrade", summarize = TRUE)
#>      from     to   ref_date transitions
#>    <char> <char>     <Date>       <int>
#> 1:     G1     G2 2022-01-01           1
```
