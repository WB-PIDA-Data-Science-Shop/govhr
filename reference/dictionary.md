# Harmonization Dictionary for Payroll and HRMIS Data

A dictionary defining the standardized variables, descriptions, data
types, module assignments, and permissible values used in the GovHR
harmonization framework.

## Usage

``` r
dictionary
```

## Format

A tibble with 50 rows and 6 variables:

- variable_name:

  Character. Human-readable name of the standardized variable.

- variable_id:

  Character. Standardized machine-readable variable identifier.

- variable_description:

  Character. Definition and intended use of the variable.

- variable_class:

  Character. Expected R class for the variable.

- module:

  Character. Harmonization module to which the variable belongs.

- values:

  Character. Expected values, formats, coding schemes, or controlled
  vocabularies associated with the variable.

## Source

Created and maintained by the Public Institutions Data and Analytics
Unit (EGVPI) of the World Bank as part of the GovHR harmonization
framework.

## Details

This dictionary serves as the authoritative data standard for
harmonizing payroll and Human Resource Management Information System
(HRMIS) data from government institutions into a consistent,
analysis-ready structure. Each row represents a standardized variable
and provides its identifier, definition, expected data type, module
assignment, and expected values or coding scheme where applicable.

The dictionary is used throughout the harmonization pipeline to map raw
source variables from government payroll and HRMIS systems to a common
schema, enabling cross-country comparability and reproducible analytics.

The dictionary contains the following fields:

- **variable_name** – Human-readable name of the standardized variable.

- **variable_id** – Machine-readable variable identifier used in
  harmonized datasets.

- **variable_description** – Definition and intended use of the
  variable.

- **variable_class** – Expected R data type for the variable.

- **module** – Harmonization module to which the variable belongs (e.g.,
  Establishment, Personnel, or Contract).

- **values** – Expected values, formats, coding schemes, or controlled
  vocabularies associated with the variable.

This dictionary is designed to support:

1.  Validation of required variables and schema compliance;

2.  Standardized renaming of source variables;

3.  Data type coercion and consistency checks;

4.  Generation of harmonized module-specific outputs;

5.  Documentation and governance of the GovHR data standard.

## Dictionary Version

**Version 1.0.0**

This version corresponds to the initial public release of the GovHR
harmonization dictionary.

## Version History

- **Version 1.0.0** (2026-06-25): Initial release.
