# Establishment Dataset

This dataset contains information about public sector establishments,
including identifiers, names, hierarchical relationships, and geographic
context. Each row represents a unique establishment record.

## Usage

``` r
bra_hrmis_est
```

## Format

A data frame with N rows and 9 variables:

- est_id:

  Unique identifier for the establishment

- est_name_native:

  Official establishment name in local language

- est_name_en:

  Establishment name translated to English

- country_code:

  Official World Bank ISO-3 country code

- country_name:

  Official World Bank country name

- adm1_name:

  First-level administrative division name

- adm1_code:

  First-level administrative division code

- est_parent:

  Identifier for parent establishment in hierarchy

- est_child:

  Identifier for child establishments in hierarchy
