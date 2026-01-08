# Personnel Dataset

This dataset contains demographic and employment information for
personnel, including identifiers, education, tribal/racial
classification, employment status, and geographic context. Each row
represents a unique personnel record.

## Usage

``` r
bra_hrmis_personnel
```

## Format

A data frame with N rows and 9 variables:

- personnel_id:

  Unique identifier for the personnel

- birth_date:

  Personnel’s date of birth

- gender:

  Personnel’s gender

- educat7:

  Education level using 7-category classification

- tribe:

  Tribal affiliation (where applicable)

- race:

  Racial/ethnic classification

- status:

  Current employment status (active/retired)

- country_code:

  Official World Bank ISO-3 country code

- ref_date:

  Timestamp for the personnel record
