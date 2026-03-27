# Remove Duplicate Personnel Records

Removes duplicate \`personnel_id\` + \`ref_date\` combinations,
addressing violations of the \`personnel_unique_id\` rule.

## Usage

``` r
remove_duplicate_personnel(data, keep = c("first", "last", "none"))
```

## Arguments

- data:

  A data.frame with columns \`personnel_id\` and \`ref_date\`.

- keep:

  Which record to keep per duplicate group: \`"first"\` (default),
  \`"last"\`, or \`"none"\` (drops all records in a duplicate group).

## Value

A data.frame with duplicates removed.

## See also

[`personnel_rules`](https://wb-pida-data-science-shop.github.io/govhr/reference/personnel_rules.md),
[`remove_duplicate_contracts`](https://wb-pida-data-science-shop.github.io/govhr/reference/remove_duplicate_contracts.md)

## Examples

``` r
if (FALSE) { # \dontrun{
remove_duplicate_personnel(personnel_df, keep = "first")
remove_duplicate_personnel(personnel_df, keep = "none")
} # }
```
