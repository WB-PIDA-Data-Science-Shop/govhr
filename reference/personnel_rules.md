# Personnel Validation Rules

A dataset containing validation rules for personnel data quality checks.
These rules are designed to be used with the `validate` package to
assess the quality and consistency of personnel records in HRMIS data.

## Usage

``` r
personnel_rules
```

## Format

A tibble with 9 rows and 5 variables:

- rule:

  Character. The validation rule expression as a string that can be
  parsed by
  [`validate::validator()`](https://rdrr.io/pkg/validate/man/validator.html).

- name:

  Character. Unique identifier for the rule (e.g.,
  "personnel_ref_date_valid").

- description:

  Character. Detailed explanation of what the rule checks. This
  description appears in validation summaries.

- label:

  Character. Short 2-3 word label for the rule, useful for plotting and
  quick reference.

- required_vars:

  Character. Comma-separated list of minimum required variables for the
  rule to be evaluated. At minimum: personnel_id and birth_date.

## Source

Created for the govhr package data quality framework

## Details

The personnel validation rules check:

- Column existence (personnel_id, ref_date, birth_date, status)

- ID uniqueness (personnel_id + ref_date combination is unique)

- Reference date validity (within reasonable historical bounds)

- Age range (18-70 years calculated from birth_date and ref_date)

- Birth date reasonableness

- Employment status validity (active, inactive, retired, terminated)

These rules can be programmatically converted to
[`validate::validator()`](https://rdrr.io/pkg/validate/man/validator.html)
objects for use in data quality pipelines.

## See also

[`contract_rules`](https://wb-pida-data-science-shop.github.io/govhr/reference/contract_rules.md),
[`validate_data`](https://wb-pida-data-science-shop.github.io/govhr/reference/validate_data.md)

## Examples

``` r
# View all personnel validation rules
personnel_rules
#> # A tibble: 5 × 4
#>   rule                                                   name  description label
#>   <chr>                                                  <chr> <chr>       <chr>
#> 1 is_unique(personnel_id, ref_date)                      pers… combinatio… Uniq…
#> 2 ref_date >= as.Date('1900-01-01') & ref_date <= Sys.D… pers… ref_date i… Vali…
#> 3 as.numeric(difftime(ref_date, birth_date, units = 'da… pers… age calcul… Reas…
#> 4 birth_date >= as.Date('1920-01-01') & birth_date <= S… pers… birth_date… Vali…
#> 5 status %in% c('active', 'inactive', 'retired', 'termi… pers… employment… Vali…

# Filter to specific rule
personnel_rules[personnel_rules$name == "personnel_age_range", ]
#> # A tibble: 1 × 4
#>   rule                                                   name  description label
#>   <chr>                                                  <chr> <chr>       <chr>
#> 1 as.numeric(difftime(ref_date, birth_date, units = 'da… pers… age calcul… Reas…
```
