# Remove Duplicate Contract Records

Removes duplicate contract records, addressing violations of
\`contract_unique_id\` (contract-level) and
\`contract_unique_personnel\` (assignment-level) rules.

## Usage

``` r
remove_duplicate_contracts(
  data,
  level = c("contract", "assignment"),
  keep = c("first", "last", "none")
)
```

## Arguments

- data:

  A data.frame with columns \`contract_id\`, \`personnel_id\`, and
  \`ref_date\`.

- level:

  Deduplication scope:

  - \`"contract"\`: Deduplicate on \`contract_id\` + \`ref_date\`

  - \`"assignment"\`: Deduplicate on \`contract_id\` +
    \`personnel_id\` + \`ref_date\`

- keep:

  Which record to keep: \`"first"\`, \`"last"\`, or \`"none"\`. See
  [`remove_duplicate_personnel`](https://wb-pida-data-science-shop.github.io/govhr/reference/remove_duplicate_personnel.md).

## Value

A data.frame with duplicates removed.

## See also

[`contract_rules`](https://wb-pida-data-science-shop.github.io/govhr/reference/contract_rules.md),
[`remove_duplicate_personnel`](https://wb-pida-data-science-shop.github.io/govhr/reference/remove_duplicate_personnel.md)

## Examples

``` r
if (FALSE) { # \dontrun{
remove_duplicate_contracts(contract_df, level = "contract", keep = "first")
remove_duplicate_contracts(contract_df, level = "assignment", keep = "last")
} # }
```
