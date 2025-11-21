# HRMIS Harmonization Data Dictionary

A structured metadata dictionary describing variables harmonized across
the Human Resource Management Information System (HRMIS) modules:
Establishment, Personnel, and Contract. The dictionary follows
SDMX-style documentation standards and specifies variable names,
identifiers, data types (in R), relationships, and other metadata fields
used in HRMIS data harmonization.

## Usage

``` r
harmonization_dict
```

## Format

A tibble with 48 rows and 9 variables:

- Concept Name:

  Variable or concept name as used in the HRMIS module.

- Concept ID:

  Short machine-readable variable name used in datasets.

- Description:

  Detailed explanation of the variable or concept.

- Data Type:

  R data type assigned to the variable (e.g., `character`, `numeric`,
  `Date`).

- Representation (Code list / Format):

  Expected format, code list, or data representation.

- Primary Key:

  Indicates whether the variable uniquely identifies a record (`"Yes"`
  or `"No"`).

- Relationship:

  Describes any relational links to other modules or variables.

- Module:

  The HRMIS module the variable belongs to: `"Establishment"`,
  `"Personnel"`, or `"Contract"`.

- Example Value:

  Illustrative example value for the variable.

## Details

The dictionary integrates all HRMIS modules into a single metadata
table. It was designed for use in R-based harmonization workflows and
conforms to SDMX Content-Oriented Guidelines (COG) for defining
concepts, code lists, and roles.

## References

SDMX Technical Standards v3.0 — Data Structure Definition (DSD):
<https://sdmx.org/?page_id=5008>

SDMX Content-Oriented Guidelines (COG): <https://sdmx.org/?page_id=4345>

Eurostat SDMX Metadata Reference Manual:
<https://ec.europa.eu/eurostat/web/metadata/reference-metadata-reporting-standards>

## Examples

``` r
library(dplyr)
data(harmonization_dict)

# View structure
glimpse(harmonization_dict)
#> Rows: 48
#> Columns: 9
#> $ `Concept Name`                        <chr> "Organization ID", "Organization…
#> $ `Concept ID`                          <chr> "org_id", "org_name_native", "or…
#> $ Description                           <chr> "Unique identifier assigned to e…
#> $ `Data Type`                           <chr> "character", "character", "chara…
#> $ `Representation (Code list / Format)` <chr> "Alphanumeric (e.g., 'MOF001')",…
#> $ `Primary Key`                         <chr> "Yes", "No", "No", "No", "No", "…
#> $ Relationship                          <chr> "Referenced in Worker, Contract"…
#> $ Module                                <chr> "Organization", "Organization", …
#> $ `Example Value`                       <chr> "MOF001", "Ministère des Finance…

# Filter dictionary by module
harmonization_dict |>
filter(Module == "Personnel")
#> # A tibble: 0 × 9
#> # ℹ 9 variables: Concept Name <chr>, Concept ID <chr>, Description <chr>,
#> #   Data Type <chr>, Representation (Code list / Format) <chr>,
#> #   Primary Key <chr>, Relationship <chr>, Module <chr>, Example Value <chr>
```
