# Compute headcount by group

Counts how many distinct people (`personnel_id`) are in each group
within each reference group, usually a reference date, and what share of
the reference group's total headcount each group represents.

## Usage

``` r
compute_headcount(data, ...)

# S3 method for class 'data.frame'
compute_headcount(
  data,
  group_cols = NULL,
  reference_group_cols = "ref_date",
  ...
)

# S3 method for class 'tbl_dbi'
compute_headcount(
  data,
  group_cols = NULL,
  reference_group_cols = "ref_date",
  ...
)
```

## Arguments

- data:

  Data frame or remote database table (`tbl_dbi`) with one row per
  person-record. Must contain `personnel_id` and the columns named in
  `reference_group_cols`.

- ...:

  Arguments passed to methods.

- group_cols:

  Character vector of columns to group by, or `NULL` to count everyone
  together. Must not overlap with `reference_group_cols`.

- reference_group_cols:

  Character vector of the columns that together define the reference
  groups, such as a date, or a date and a country. Shares are computed
  within each combination of these columns. Default `"ref_date"`.

## Value

A table with the grouping columns, `reference_group_cols`, `headcount`
(number of distinct people) and `share_headcount` (the group's share of
all people in its reference group, between 0 and 1). A data.table for
data frame input; a lazy table for `tbl_dbi` input (use
[`dplyr::collect()`](https://dplyr.tidyverse.org/reference/compute.html)
to bring it into memory).

## Details

Rows with a missing `personnel_id` are not counted. A group whose IDs
are all missing still appears, with a headcount of 0.

## Examples

``` r
hr <- data.frame(
  personnel_id = c(1, 2, 3, 1, 2),
  ref_date = as.Date(c(rep("2020-01-01", 3), rep("2021-01-01", 2))),
  country = c("A", "A", "B", "A", "B"),
  gender = c("F", "M", "F", "F", "M")
)
compute_headcount(hr, group_cols = "gender")
#>    gender   ref_date headcount share_headcount
#>    <char>     <Date>     <int>           <num>
#> 1:      F 2020-01-01         2       0.6666667
#> 2:      M 2020-01-01         1       0.3333333
#> 3:      F 2021-01-01         1       0.5000000
#> 4:      M 2021-01-01         1       0.5000000

# shares within each date and country
compute_headcount(
  hr,
  group_cols = "gender",
  reference_group_cols = c("ref_date", "country")
)
#>    gender   ref_date country headcount share_headcount
#>    <char>     <Date>  <char>     <int>           <num>
#> 1:      F 2020-01-01       A         1             0.5
#> 2:      M 2020-01-01       A         1             0.5
#> 3:      F 2020-01-01       B         1             1.0
#> 4:      F 2021-01-01       A         1             1.0
#> 5:      M 2021-01-01       B         1             1.0
```
