# International Standard Classification of Occupations (ISCO-08)

A dataset containing the structure of the International Standard
Classification of Occupations (ISCO-08), as published by the
International Labour Establishment (ILO).

## Usage

``` r
isco
```

## Format

A data frame with 436 rows and 9 variables:

- isco_version:

  Character. Version of the ISCO classification (e.g., \`"ISCO-08"\`).

- major:

  Character. One-digit major group code.

- major_label:

  Character. Title of the major group (e.g., \`"Managers"\`).

- sub_major:

  Character. Two-digit sub-major group code.

- sub_major_label:

  Character. Title of the sub-major group (e.g., \`"Chief Executives,
  Senior Officials and Legislators"\`).

- minor:

  Character. Three-digit minor group code.

- minor_label:

  Character. Title of the minor group (e.g., \`"Legislators and Senior
  Officials"\`).

- unit:

  Character. Four-digit unit group code.

- description:

  Character. Definition or title of the occupation at the unit group
  level (e.g., \`"Legislators"\`, \`"Senior Government Officials"\`).

## Source

International Labour Establishment (ILO),
<https://www.ilo.org/public/english/bureau/stat/isco/>

## Details

The ISCO provides a system for classifying and aggregating occupational
information to facilitate international comparisons and harmonization of
occupational statistics. It is widely used in labor statistics, survey
design, and policy analysis.

ISCO-08 is structured hierarchically: - **Major groups** (1 digit) –
broad occupational categories - **Sub-major groups** (2 digits) –
subdivisions of major groups - **Minor groups** (3 digits) –
subdivisions of sub-major groups - **Unit groups** (4 digits) – most
detailed level, individual occupations

Each unit group includes a description outlining the scope of the
occupation according to ILO’s ISCO-08 documentation.

## Examples

``` r
data(isco)
head(isco)
#> # A tibble: 6 × 9
#>   isco_version major major_label sub_major sub_major_label     minor minor_label
#>   <chr>        <chr> <chr>       <chr>     <chr>               <chr> <chr>      
#> 1 ISCO-08      1     Managers    11        Chief Executives, … 111   Legislator…
#> 2 ISCO-08      1     Managers    11        Chief Executives, … 111   Legislator…
#> 3 ISCO-08      1     Managers    11        Chief Executives, … 111   Legislator…
#> 4 ISCO-08      1     Managers    11        Chief Executives, … 111   Legislator…
#> 5 ISCO-08      1     Managers    11        Chief Executives, … 112   Managing D…
#> 6 ISCO-08      1     Managers    12        Administrative and… 121   Business S…
#> # ℹ 2 more variables: unit <chr>, description <chr>
```
