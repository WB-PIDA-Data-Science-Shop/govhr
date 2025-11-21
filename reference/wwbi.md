# Worldwide Bureaucracy Indicators

The Worldwide Bureaucracy Indicators (WWBI) database is a unique
cross-national dataset on public sector employment and wages that aims
to fill an information gap, thereby helping researchers, development
practitioners, and policymakers gain a better understanding of the
personnel dimensions of state capability, the footprint of the public
sector within the overall labor market, and the fiscal implications of
the public sector wage bill. The dataset is derived from administrative
data and household surveys, thereby complementing existing, expert
perception-based approaches.

## Usage

``` r
wwbi
```

## Format

A data frame with 993 rows and 11 variables:

- `country_code`:

  character World Bank country code.

- `year`:

  double Year.

- `share_no_edu`:

  double Share of public sector personnels with no education.

- `share_primary_edu`:

  double Share of public sector personnels with primary education
  completed.

- `share_secondary_edu`:

  double Share of public sector personnels with secondary education
  completed.

- `share_tertiary_edu`:

  double Share of public sector personnels with tertiary education
  completed.

- `ps_wage_premium_edu_sector`:

  double Public sector wage premium in the education sector, compared to
  formal sector personnels in the private sector.

- `ps_wage_premium_hea_sector`:

  double Public sector wage premium in the health sector, compared to
  formal sector personnels in the private sector.

- `ps_wage_premium_female`:

  double Public sector wage premium for female personnels, compared to
  formal sector personnels in the private sector.

- `ps_wage_premium_male`:

  double Public sector wage premium for male personnels, compared to
  formal sector personnels in the private sector.

- `ps_wage_premium_pooled`:

  double Public sector wage premium for all public sector personnels,
  compared to formal sector personnels in the private sector.

## Source

World Bank <https://data360.worldbank.org/en/int/dataset/WB_WWBI>
