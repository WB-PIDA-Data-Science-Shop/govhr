# Contract Validation Rules

A dataset containing validation rules for contract and wage bill data
quality checks. These rules are designed to be used with the `validate`
package to assess the quality and consistency of contract records in
HRMIS data.

## Usage

``` r
contract_rules
```

## Format

A tibble with 17 rows and 5 variables:

- rule:

  Character. The validation rule expression as a string that can be
  parsed by
  [`validate::validator()`](https://rdrr.io/pkg/validate/man/validator.html).

- name:

  Character. Unique identifier for the rule (e.g.,
  "contract_ref_date_valid").

- description:

  Character. Detailed explanation of what the rule checks. This
  description appears in validation summaries.

- label:

  Character. Short 2-3 word label for the rule, useful for plotting and
  quick reference.

- required_vars:

  Character. Comma-separated list of minimum required variables for the
  rule to be evaluated. At minimum: contract_id, personnel_id,
  gross_salary_lcu, base_salary_lcu, and allowance_lcu.

## Source

Created for the govhr package data quality framework

## Details

The contract validation rules check:

- Column existence (contract_id, ref_date, gross_salary_lcu,
  base_salary_lcu, allowance_lcu)

- Contract ID uniqueness (contract_id + ref_date combination is unique)

- Personnel assignment uniqueness (contract_id + personnel_id + ref_date
  combination is unique)

- Reference date validity

- Working hours reasonableness (1-168 hours per week)

- Contract status consistency (start_date \<= ref_date)

- Wage bill composition (gross = base + allowance)

- Wage bill hierarchy (net \<= gross, base \<= gross)

- Positive salary values (gross, base, net \>= 1)

- Allowance validity (non-negative or missing)

These rules can be programmatically converted to
[`validate::validator()`](https://rdrr.io/pkg/validate/man/validator.html)
objects for use in data quality pipelines.

## See also

[`personnel_rules`](https://wb-pida-data-science-shop.github.io/govhr/reference/personnel_rules.md),
[`validate_data`](https://wb-pida-data-science-shop.github.io/govhr/reference/validate_data.md)

## Examples

``` r
# View all contract validation rules
contract_rules
#> # A tibble: 16 × 4
#>    rule                                                  name  description label
#>    <chr>                                                 <chr> <chr>       <chr>
#>  1 is_unique(contract_id, ref_date)                      cont… combinatio… Uniq…
#>  2 is_unique(contract_id, personnel_id, ref_date)        cont… combinatio… Uniq…
#>  3 ref_date >= as.Date('1900-01-01') & ref_date <= Sys.… cont… ref_date i… Vali…
#>  4 whours >= 1 & whours <= 168                           cont… working ho… Reas…
#>  5 start_date <= ref_date                                cont… employment… Vali…
#>  6 gross_salary_lcu >= base_salary_lcu + allowance_lcu   wage… gross sala… Gros…
#>  7 net_salary_lcu <= gross_salary_lcu                    wage… net salary… Net …
#>  8 gross_salary_lcu >= 1                                 wage… gross sala… Posi…
#>  9 base_salary_lcu >= 1                                  wage… base salar… Posi…
#> 10 net_salary_lcu >= 1                                   wage… net salary… Posi…
#> 11 base_salary_lcu <= gross_salary_lcu                   wage… base salar… Base…
#> 12 allowance_lcu >= 1 | is.na(allowance_lcu)             wage… allowance … Vali…
#> 13 in_range(gross_salary_lcu, min = quantile(gross_sala… wage… gross sala… Gros…
#> 14 in_range(net_salary_lcu, min = quantile(net_salary_l… wage… net salary… Net …
#> 15 in_range(base_salary_lcu, min = quantile(base_salary… wage… base salar… Base…
#> 16 in_range(allowance_lcu, min = quantile(allowance_lcu… wage… allowance … Allo…

# Filter to wage bill rules
contract_rules[grepl("wagebill", contract_rules$name), ]
#> # A tibble: 11 × 4
#>    rule                                                  name  description label
#>    <chr>                                                 <chr> <chr>       <chr>
#>  1 gross_salary_lcu >= base_salary_lcu + allowance_lcu   wage… gross sala… Gros…
#>  2 net_salary_lcu <= gross_salary_lcu                    wage… net salary… Net …
#>  3 gross_salary_lcu >= 1                                 wage… gross sala… Posi…
#>  4 base_salary_lcu >= 1                                  wage… base salar… Posi…
#>  5 net_salary_lcu >= 1                                   wage… net salary… Posi…
#>  6 base_salary_lcu <= gross_salary_lcu                   wage… base salar… Base…
#>  7 allowance_lcu >= 1 | is.na(allowance_lcu)             wage… allowance … Vali…
#>  8 in_range(gross_salary_lcu, min = quantile(gross_sala… wage… gross sala… Gros…
#>  9 in_range(net_salary_lcu, min = quantile(net_salary_l… wage… net salary… Net …
#> 10 in_range(base_salary_lcu, min = quantile(base_salary… wage… base salar… Base…
#> 11 in_range(allowance_lcu, min = quantile(allowance_lcu… wage… allowance … Allo…
```
