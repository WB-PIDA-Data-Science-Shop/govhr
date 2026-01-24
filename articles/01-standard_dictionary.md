# HR Standard Data Dictionary

## Overview

This article describes a standard dictionary for human resource
management information system (HRMIS) data, organized into three main
modules: Establishment, Personnel, and Contract. These modules are
designed to organize and standardize information about public sector
personnel across different countries and administrative levels.

## Module 1: Establishment

The Establishment module captures information about public sector
institutions, including ministries, departments, and agencies.

### Fields

| Field Name                   | Variable Name     | Description                                        |
|------------------------------|-------------------|----------------------------------------------------|
| Establishment ID             | `est_id`          | Unique identifier for the establishment            |
| Establishment Name (Native)  | `est_name_native` | Official establishment name in local language      |
| Establishment Name (English) | `est_name_en`     | Establishment name translated to English           |
| Reference Date               | `ref_date`        | Latest date when the establishment had that name   |
| Establishment Type           | `est_type`        | Type of establishment (Ministry/Department/Agency) |
| Parent Establishment         | `est_parent`      | Identifier for parent establishment in hierarchy   |
| Child Establishment          | `est_child`       | Identifier for child establishments in hierarchy   |
| Country Code                 | `country_code`    | Official World Bank ISO-3 country code             |
| Country Name                 | `country_name`    | Official World Bank country name                   |
| Administration 1 Name        | `adm1_name`       | First-level administrative division name           |
| Administration 1 Code        | `adm1_code`       | First-level administrative division code           |

### Notes

- **Establishment Type**: Indicates the hierarchical level of the
  institution within the government structure. Ideally, this would
  support parent-child relationships, though such data may be rare in
  practice.
- **Administration Level**: Refers to the geographic/administrative
  level of government (e.g., national, state/provincial, local).
- **Reference Date**: Critical for tracking establishmental changes,
  mergers, or renaming over time.

## Module 2: Personnel

The Personnel module contains demographic and employment information
about individual public sector employees.

### Fields

| Field Name                          | Variable Name     | Description                                      |
|-------------------------------------|-------------------|--------------------------------------------------|
| Personnel ID                        | `personnel_id`    | Unique identifier for the personnel              |
| Establishment ID                    | `est_id`          | Foreign key linking to Establishment module      |
| Establishment Name                  | `est_name_native` | Foreign key linking to the Establishment module  |
| Reference Date                      | `ref_date`        | Timestamp for the personnel record               |
| Date of Birth                       | `birth_date`      | Personnel’s date of birth                        |
| Gender                              | `gender`          | Personnel’s gender                               |
| Education Attainment (7 categories) | `educat7`         | Education level using 10-category classification |
| Tribe                               | `tribe`           | Tribal affiliation                               |
| Race                                | `race`            | Racial/ethnic classification                     |
| Country Code                        | `country_code`    | Official World Bank ISO-3 country code           |
| Country Name                        | `country_name`    | Official World Bank country name                 |
| Administration 1 Name               | `adm1_name`       | First-level administrative division name         |
| Administration 1 Code               | `adm1_code`       | First-level administrative division code         |

### Notes

- **Education Categories**: Multiple classification systems are provided
  to allow for cross-country comparisons and mapping to international
  standards.
- **Geographic Information**: While personnels are linked to
  establishments, separate geographic fields allow for tracking mobility
  and remote work arrangements.
- **Privacy Considerations**: This module contains sensitive personal
  information and should be handled according to applicable data
  protection regulations.

## Module 3: Contract

The Contract module captures details about employment contracts,
compensation, and job characteristics.

### Fields

| Field Name             | Variable Name                                                     | Description                                                                 |
|------------------------|-------------------------------------------------------------------|-----------------------------------------------------------------------------|
| Contract ID            | `contract_id`                                                     | Unique identifier for the contract                                          |
| Personnel ID           | `personnel_id`                                                    | Foreign key linking to Personnel module                                     |
| Establishment ID       | `est_id`                                                          | Foreign key linking to Establishment module                                 |
| Establishment Name     | `est_name_native`                                                 | Foreign key linking to Establishment module                                 |
| Reference Date         | `ref_date`                                                        | Timestamp for the contract record                                           |
| Base Salary (LCU)      | `base_salary_lcu`                                                 | Base compensation in local currency units                                   |
| Base Salary (PPP)      | `base_salary_ppp`                                                 | Base compensation in constant 2021 international dollars                    |
| Gross Salary (LCU)     | `gross_salary_lcu`                                                | Total compensation before deductions in local currency units                |
| Gross Salary (PPP)     | `gross_salary_ppp`                                                | Total compensation before deductions in constant 2021 international dollars |
| Net Salary (LCU)       | `net_salary_lcu`                                                  | Compensation after deductions in local currency units                       |
| Net Salary (PPP)       | `net_salary_ppp`                                                  | Compensation after deductions in constant 2021 international dollars        |
| Allowances (LCU)       | `allowance_lcu`                                                   | Allowances in local currency units                                          |
| Allowances (PPP)       | `allowance_ppp` Allowances in constant 2021 international dollars |                                                                             |
| Contract Type          | `contract_type`                                                   | Contract modality (short-term/open-term/permanent/inactive/retired)         |
| Occupation (Native)    | `occupation_native`                                               | Job title in local language                                                 |
| Occupation (English)   | `occupation_english`                                              | Job title translated to English                                             |
| Occupation (ISCO Name) | `occupation_isconame`                                             | ISCO standard occupation name                                               |
| Occupation (ISCO Code) | `occupation_iscocode`                                             | ISCO standard occupation code                                               |
| Start Date             | `start_date`                                                      | Contract start date                                                         |
| End Date               | `end_date`                                                        | Contract end date (if applicable)                                           |
| Country Code           | `country_code`                                                    | Official World Bank ISO-3 country code                                      |
| Country Name           | `country_name`                                                    | Official World Bank country name                                            |
| Administration 1 Name  | `adm1_name`                                                       | First-level administrative division name                                    |
| Administration 1 Code  | `adm1_code`                                                       | First-level administrative division code                                    |
| Hours Worked           | `whours`                                                          | Standard or actual hours worked                                             |
| Pay Grade              | `paygrade`                                                        | Salary scale or grade level                                                 |
| Seniority              | `seniority`                                                       | Years of service or seniority level                                         |

### Notes

- **Compensation Fields**: Multiple salary measures allow for analysis
  of gross-to-net ratios, taxation effects, and allowances.
- **Occupation Coding**: Both native and standardized (ISCO)
  classifications enable within-country detail and cross-country
  comparability.
- **Contract Duration**: The combination of `contract_type`,
  `start_date`, and `end_date` provides comprehensive information about
  employment stability and temporary arrangements.

## Relationship between modules

The three modules are related as follows:

    Establishment (1) ←→ (N) Personnel
    Establishment (1) ←→ (N) Contract
    Personnel (1) ←→ (N) Contract

- One establishment can have many workers
- One establishment can have many contracts
- One worker can have multiple contracts (over time or concurrent)
- One worker can have multiple establishments

## Data Quality Considerations

1.  **Temporal Consistency**: Ensure `ref_date` fields are properly
    maintained across all modules
2.  **Geographic Consistency**: Country and administration codes should
    be consistent across all modules
3.  **Unique Identifiers**: All ID fields should be globally unique and
    persistent
4.  **Missing Data**: Document conventions for handling missing or
    unavailable data
5.  **Historical Records**: Consider versioning strategy for tracking
    changes over time
