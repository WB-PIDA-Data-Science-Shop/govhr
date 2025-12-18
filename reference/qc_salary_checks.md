# Validate Salary Variables for Logic and Numeric Integrity

This internal function checks selected salary columns for numeric type,
non-negativity, and logical relationships (e.g., base salary ≤ gross
salary).

## Usage

``` r
qc_salary_checks(dt, cols)
```

## Arguments

- dt:

  A data.table containing salary variables.

- cols:

  A character vector of salary-related column names to evaluate.

## Value

A list with:

- `variable_checks`:

  Numeric type and negativity checks for each salary variable.

- `logical_salary_relationships`:

  Counts of violations in salary ordering logic.
