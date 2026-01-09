# Harmonization Dictionary for Payroll Data

A dictionary defining the standardized variable names, descriptions,
classes, and module assignments used during the payroll data
harmonization process.

## Usage

``` r
harmonization_dict
```

## Format

A tibble with 45 rows and 5 variables:

- VariableName:

  Character. Human-readable variable name.

- VariableID:

  Character. Standardized snake_case variable identifier.

- Description:

  Character. Definition of the variable.

- VariableClass:

  Character. Target R class for the variable.

- Module:

  Character. Harmonization module using this variable.

## Source

Created by the Public Institutions Data & Analytics Team as part of the
payroll harmonization ETL framework.

## Details

This dictionary is used by the harmonization pipeline to map raw
payroll, contract, personnel, and establishment variables from
government HRMIS / payroll systems to a consistent, analysis-ready
schema. Each row represents one standardized variable name and
specifies:

\* \*\*VariableName\*\* — The human-readable name of the variable as it
appears in the final harmonized dataset. \* \*\*VariableID\*\* — The
machine-readable variable name (snake_case) used in the harmonized
output. \* \*\*Description\*\* — A concise definition of the variable’s
meaning and intended use. \* \*\*VariableClass\*\* — The R class the
variable should be cast to (e.g., character, Date, numeric, integer). \*
\*\*Module\*\* — The module where the variable belongs (e.g.,
\*Establishment\*, \*Personnel\*, \*Contract\*).

This dictionary is designed so that automated harmonization scripts
can: 1. Validate presence and structure of required variables; 2. Rename
raw variables to standardized IDs; 3. Coerce variables to the correct
data type; 4. Split harmonized outputs into module-specific files.
