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

  double Share of public sector personnel with no education.

- `share_primary_edu`:

  double Share of public sector personnel with primary education
  completed.

- `share_secondary_edu`:

  double Share of public sector personnel with secondary education
  completed.

- `share_tertiary_edu`:

  double Share of public sector personnel with tertiary education
  completed.

- `ps_wage_premium_edu_sector`:

  double Public sector wage premium in the education sector, compared to
  formal wage employees in the private sector.

- `ps_wage_premium_hea_sector`:

  double Public sector wage premium in the health sector, compared to
  formal wage employees in the private sector.

- `ps_wage_premium_female`:

  double Public sector wage premium for female personnel, compared to
  formal wage employees in the private sector.

- `ps_wage_premium_male`:

  double Public sector wage premium for male personnel, compared to
  formal wage employees in the private sector.

- `ps_wage_premium_pooled`:

  double Public sector wage premium for all public sector personnel,
  compared to formal wage employees in the private sector.

- `ps_share_total_emp`:

  double Public sector employment, as a share of total employment

- `ps_share_paid_emp`:

  double Public sector employment, as a share of paid employment

- `ps_share_formal_emp`:

  double Public sector employment, as a share of formal employment

- `ps_wage_premium_isced_n`:

  double Public sector wage premium for personnel with no education,
  compared to formal wage employees in the private sector.

- `ps_wage_premium_isced_1`:

  double Public sector wage premium for personnel with primary education
  completed, compared to formal wage employees in the private sector.

- `ps_wage_premium_isced_2_3`:

  double Public sector wage premium for personnel with secondary
  education completed, compared to formal wage employees in the private
  sector.

- `ps_wage_premium_isced_5t8`:

  double Public sector wage premium for personnel with tertiary
  education completed, compared to formal wage employees in the private
  sector.

- `ps_wage_premium_clerk`:

  double Public sector wage premium for personnel in clerical support
  occupations, compared to formal wage employees in the private sector.

- `ps_wage_premium_elementary`:

  double Public sector wage premium for personnel in elementary
  occupations, compared to formal wage employees in the private sector.

- `ps_wage_premium_professional`:

  double Public sector wage premium for personnel in professional
  occupations, compared to formal wage employees in the private sector.

- `ps_wage_premium_manager`:

  double Public sector wage premium for personnel in managerial
  occupations, compared to formal wage employees in the private sector.

- `ps_wage_premium_technical`:

  double Public sector wage premium for personnel in technical and
  associate professional occupations, compared to formal wage employees
  in the private sector.

## Source

World Bank <https://data360.worldbank.org/en/int/dataset/WB_WWBI>
