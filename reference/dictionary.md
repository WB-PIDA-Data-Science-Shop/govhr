# Harmonization Dictionary for Payroll Data

A dictionary defining the standardized variable names, descriptions,
classes, and module assignments used during the payroll data
harmonization process.

## Usage

``` r
dictionary
```

## Format

A tibble with 45 rows and 5 variables:

- variable_name:

  Character. Human-readable variable name.

- variable_id:

  Character. Standardized snake_case variable identifier.

- variable_description:

  Character. Definition of the variable.

- variable_class:

  Character. Target R class for the variable.

- module:

  Character. Harmonization module using this variable.

## Source

Created by the Institutional Capacity and EFfectiveness team as part of
the payroll harmonization ETL framework.

## Details

This dictionary is used by the harmonization pipeline to map raw
payroll, contract, personnel, and establishment variables from
government HRMIS / payroll systems to a consistent, analysis-ready
schema. Each row represents one standardized variable name and
specifies:

\* \*\*variable_name\*\* — The human-readable name of the variable as it
appears in the final harmonized dataset. \* \*\*variable_id\*\* — The
machine-readable variable name (snake_case) used in the harmonized
output. \* \*\*variable_description\*\* — A concise definition of the
variable’s meaning and intended use. \* \*\*variable_class\*\* — The R
class the variable should be cast to (e.g., character, Date, numeric,
integer). \* \*\*module\*\* — The module where the variable belongs
(e.g., \*Establishment\*, \*Personnel\*, \*Contract\*).

This dictionary is designed so that automated harmonization scripts
can: 1. Validate presence and structure of required variables; 2. Rename
raw variables to standardized IDs; 3. Coerce variables to the correct
data type; 4. Split harmonized outputs into module-specific files.
