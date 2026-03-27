# Validate Data Quality Using Rule-Based Framework

Validates data against a set of predefined rules. Returns either a
summary report or the full validation object.

## Usage

``` r
validate_data(data, input_rules, output_format = c("report", "object"))
```

## Arguments

- data:

  A data.frame or data.table.

- input_rules:

  A set of rules, defined in a dataframe.

- output_format:

  A string specifying the output format: "report" for a summary report
  or "object" for the raw validation results.

## Value

A data.frame containing the audit report with columns:

- Rule:

  Short label for the rule (from input_rules\$label)

- Description:

  Detailed explanation of what the rule checks

- Total Records:

  Number of records evaluated

- Passes:

  Number of records that passed the rule

- Pass Rate:

  Percentage of records passing (0-100)

- Fails:

  Number of records that failed the rule

- Errors:

  Logical indicating whether the rule threw an error

## Details

Validate Data Against Quality Rules

The function validates data against user-defined rules using the
validate package.

## See also

[`personnel_rules`](https://wb-pida-data-science-shop.github.io/govhr/reference/personnel_rules.md)
for personnel validation rules
[`contract_rules`](https://wb-pida-data-science-shop.github.io/govhr/reference/contract_rules.md)
for contract validation rules

## Examples

``` r
# Validate contract data
audit_report <- validate_data(
  data = govhr::bra_hrmis_contract,
  input_rules = govhr::contract_rules
)

# View the audit report
print(audit_report)
#>                  Rule
#> 1  Unique contract ID
#> 2   Unique assignment
#> 3          Valid date
#> 4    Reasonable hours
#> 5        Valid status
#> 6   Gross composition
#> 7        Net vs gross
#> 8      Positive gross
#> 9       Positive base
#> 10       Positive net
#> 11      Base vs gross
#> 12    Valid allowance
#> 13      Gross outlier
#> 14        Net outlier
#> 15       Base outlier
#> 16  Allowance outlier
#>                                                                                    Description
#> 1            combination of contract_id and ref_date is unique (no duplicate contract records)
#> 2  combination of contract_id, personnel_id, and ref_date is unique (no duplicate assignments)
#> 3             ref_date is a valid date (not in future, not before reasonable historical bound)
#> 4                                                    working hours are positive and reasonable
#> 5                    employment status is valid (active contracts have start_date <= ref_date)
#> 6                                      gross salary is consistent with base salary + allowance
#> 7                                             net salary is less than or equal to gross salary
#> 8                                                                     gross salary is positive
#> 9                                                                      base salary is positive
#> 10                                                                      net salary is positive
#> 11                                                    base salary does not exceed gross salary
#> 12                                                       allowance is non-negative if provided
#> 13                     gross salary is not a statistical outlier (within IQR-based thresholds)
#> 14                       net salary is not a statistical outlier (within IQR-based thresholds)
#> 15                      base salary is not a statistical outlier (within IQR-based thresholds)
#> 16                        allowance is not a statistical outlier (within IQR-based thresholds)
#>    Total Records Passes Pass Rate Fails Errors
#> 1           8885   8885    100.00     0  FALSE
#> 2           8885   8885    100.00     0  FALSE
#> 3           8885   8885    100.00     0  FALSE
#> 4           8885   8885    100.00     0  FALSE
#> 5           8885   8868     99.81    17  FALSE
#> 6           8885   5872     66.09     1  FALSE
#> 7           8885   7955     89.53     0  FALSE
#> 8           8885   7955     89.53     0  FALSE
#> 9           8885   5873     66.10     0  FALSE
#> 10          8885   7955     89.53     0  FALSE
#> 11          8885   5872     66.09     1  FALSE
#> 12          8885   3107     34.97  5778  FALSE
#> 13          8885   7530     84.75   425  FALSE
#> 14          8885   7599     85.53   356  FALSE
#> 15          8885   5653     63.62   220  FALSE
#> 16          8885   8790     98.93    95  FALSE

# Check rules with failures
audit_report[audit_report$Fails > 0, ]
#>                 Rule
#> 5       Valid status
#> 6  Gross composition
#> 11     Base vs gross
#> 12   Valid allowance
#> 13     Gross outlier
#> 14       Net outlier
#> 15      Base outlier
#> 16 Allowance outlier
#>                                                                  Description
#> 5  employment status is valid (active contracts have start_date <= ref_date)
#> 6                    gross salary is consistent with base salary + allowance
#> 11                                  base salary does not exceed gross salary
#> 12                                     allowance is non-negative if provided
#> 13   gross salary is not a statistical outlier (within IQR-based thresholds)
#> 14     net salary is not a statistical outlier (within IQR-based thresholds)
#> 15    base salary is not a statistical outlier (within IQR-based thresholds)
#> 16      allowance is not a statistical outlier (within IQR-based thresholds)
#>    Total Records Passes Pass Rate Fails Errors
#> 5           8885   8868     99.81    17  FALSE
#> 6           8885   5872     66.09     1  FALSE
#> 11          8885   5872     66.09     1  FALSE
#> 12          8885   3107     34.97  5778  FALSE
#> 13          8885   7530     84.75   425  FALSE
#> 14          8885   7599     85.53   356  FALSE
#> 15          8885   5653     63.62   220  FALSE
#> 16          8885   8790     98.93    95  FALSE
```
