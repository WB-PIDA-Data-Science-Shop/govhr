#' World Bank Country and Lending Groups
#'
#' This dataset is produced by the World Bank Group to classify countries as to their income levels and other groups.
#'
#' @format ## `countryclass`
#' A data frame with 267 rows and 4 columns:
#' \describe{
#'   \item{country_code}{World Bank country code}
#'   \item{economy}{Country name}
#'   \item{region}{World Bank region}
#'   \item{income_group}{World Bank income classification}
#'   ...
#' }
#' @source <https://ddh-openapi.worldbank.org/resources/DR0095333/download/>
"countryclass"


#' Macro-level World Bank WDI indicators
#'
#' This dataset contains a selection of macroeconomic and labor market indicators
#' for multiple countries and years. The data are primarily sourced from the World
#' Bank World Development Indicators (WDI) via the Data360 API. The variables have
#' been renamed for convenience, but the original WDI variable codes are provided
#' for reference.
#'
#' @format A tibble with 11652 rows and 14 variables:
#' \describe{
#'   \item{country_code}{ISO3 country code (originally from Data360 API).}
#'   \item{year}{Year of observation (character, originally from Data360 API).}
#'   \item{gdp_lcu}{Gross Domestic Product (local currency units). Original WDI code: WB_WDI_NY_GDP_MKTP_CN.}
#'   \item{pexpenditure_lcu}{Total government expenditure (local currency units). Original WDI code: WB_WDI_GC_XPN_TOTL_CN.}
#'   \item{prevenue_lcu}{Total government revenue (local currency units). Original WDI code: WB_WDI_GC_REV_XGRT_CN.}
#'   \item{taxrevenue_lcu}{Total government tax revenue (local currency units). Original WDI code: WB_WDI_GC_TAX_TOTL_CN.}
#'   \item{emp_pop_rate}{Employment-to-population ratio (in percent). Original WDI code: WB_WDI_SL_EMP_TOTL_SP_NE_ZS.}
#'   \item{labor_force_total}{Labor force, total. Original WDI code: WB_WDI_SL_TLF_TOTL_IN.}
#'   \item{labor_force_advanced_edu}{Labor force with advanced education (percentage of total working-age population with advanced education). Original WDI code: WB_WDI_SL_TLF_ADVN_ZS.}
#'   \item{labor_force_women}{Labor force, women (percentage of total labor force). Original WDI code: WB_WDI_SL_TLF_TOTL_FE_ZS.}
#'   \item{tot_pop}{Total population. Original WDI code: WB_WDI_SP_POP_TOTL.}
#'   \item{government_expenditure_gdp}{General government final consumption expenditure (percentage of GDP). Original WDI code: WB_WDI_NE_CON_GOVT_ZS.}
#'   \item{salaried_rate}{Share of employed people who are salaried (in percent). Original WDI code: WB_WDI_SL_EMP_WORK_ZS.}
#'   \item{cpi}{Consumer Price Index, total. Original WDI code: WB_WDI_FP_CPI_TOTL.}
#'   \item{ppp}{Purchasing Power Parity (local currency units per international USD). Original WDI code: WB_WDI_PA_NUS_PRVT_PP.}
#'   \item{fiscal_balance}{Overall Fiscal Balance, USD, percentage of GDP.}
#'   \item{emp_pop}{The population of employed i.e. `emp_pop_rate` * `tot_pop`.}
#'   \item{salaried_pop}{The population of salaried personnel i.e. `salaried_rate` * `emp_pop`.}
#' }
#'
#' @details
#' This dataset was prepared to support wage bill diagnostics and other fiscal
#' and labor market analysis. All numeric variables have been coerced to numeric
#' type. Missing values may exist for certain countries and years.
#'
#' @source Data360 API, World Bank World Development Indicators (WDI)
#' \url{https://data.worldbank.org/indicator}
#'
"macro_indicators"


#' International Standard Classification of Occupations (ISCO-08)
#'
#' A dataset containing the structure of the International
#' Standard Classification of Occupations (ISCO-08), as published by the
#' International Labour Establishment (ILO).
#'
#' The ISCO provides a system for classifying and aggregating occupational
#' information to facilitate international comparisons and harmonization of
#' occupational statistics. It is widely used in labor statistics, survey design,
#' and policy analysis.
#'
#' @format A data frame with 436 rows and 9 variables:
#' \describe{
#'   \item{isco_version}{Character. Version of the ISCO classification (e.g., `"ISCO-08"`).}
#'   \item{major}{Character. One-digit major group code.}
#'   \item{major_label}{Character. Title of the major group (e.g., `"Managers"`).}
#'   \item{sub_major}{Character. Two-digit sub-major group code.}
#'   \item{sub_major_label}{Character. Title of the sub-major group (e.g.,
#'   `"Chief Executives, Senior Officials and Legislators"`).}
#'   \item{minor}{Character. Three-digit minor group code.}
#'   \item{minor_label}{Character. Title of the minor group (e.g.,
#'   `"Legislators and Senior Officials"`).}
#'   \item{unit}{Character. Four-digit unit group code.}
#'   \item{description}{Character. Definition or title of the occupation
#'   at the unit group level (e.g., `"Legislators"`, `"Senior Government Officials"`).}
#' }
#'
#' @details
#' ISCO-08 is structured hierarchically:
#' - \strong{Major groups} (1 digit) – broad occupational categories
#' - \strong{Sub-major groups} (2 digits) – subdivisions of major groups
#' - \strong{Minor groups} (3 digits) – subdivisions of sub-major groups
#' - \strong{Unit groups} (4 digits) – most detailed level, individual occupations
#'
#' Each unit group includes a description outlining the scope of the occupation
#' according to ILO’s ISCO-08 documentation.
#'
#' @source International Labour Establishment (ILO),
#' \url{https://www.ilo.org/public/english/bureau/stat/isco/}
#'
#' @examples
#' data(isco)
#' head(isco)
"isco"

#' @title Social Sustainability Global Database
#' @description The Social Sustainability global database and its visualization dashboard <https://public.tableau.com/app/profile/social.sustainability.and.inclusion.world.bank/viz/SocialSustainabilityGlobalDashboard2_0/Historia1?publish=yes/> are global public goods produced by the Social Development Global Practice of The World Bank Group. They feature leading indicators of inclusion, resilience, social cohesion, and process legitimacy, for 222 countries, disaggregated by population group and analyzed spatially and over time. In addition, the dashboard allows the user to overlay the indicators in the geospatial platform of the World Bank Group.
#' @format A data frame with 195 rows and 3 variables:
#' \describe{
#'   \item{\code{country_code}}{character World Bank country code.}
#'   \item{\code{year}}{numeric Year.}
#'   \item{\code{confidence_in_gov}}{numeric Percentage of population with confidence in government.}
#'}
#' @source World Bank
#' \url{https://datacatalog.worldbank.org/int/search/dataset/0061880/Social-Sustainability-Global-Database-}
"social_sustainability"

#' @title Worldwide Bureaucracy Indicators
#' @description The Worldwide Bureaucracy Indicators (WWBI) database is a unique cross-national dataset on public sector employment and wages that aims to fill an information gap, thereby helping researchers, development practitioners, and policymakers gain a better understanding of the personnel dimensions of state capability, the footprint of the public sector within the overall labor market, and the fiscal implications of the public sector wage bill. The dataset is derived from administrative data and household surveys, thereby complementing existing, expert perception-based approaches.
#' @format A data frame with 993 rows and 11 variables:
#' \describe{
#'   \item{\code{country_code}}{character World Bank country code.}
#'   \item{\code{year}}{double Year.}
#'   \item{\code{share_no_edu}}{double Share of public sector personnel with no education.}
#'   \item{\code{share_primary_edu}}{double Share of public sector personnel with primary education completed.}
#'   \item{\code{share_secondary_edu}}{double Share of public sector personnel with secondary education completed.}
#'   \item{\code{share_tertiary_edu}}{double Share of public sector personnel with tertiary education completed.}
#'   \item{\code{ps_wage_premium_edu_sector}}{double Public sector wage premium in the education sector, compared to formal wage employees in the private sector.}
#'   \item{\code{ps_wage_premium_hea_sector}}{double Public sector wage premium in the health sector, compared to formal wage employees in the private sector.}
#'   \item{\code{ps_wage_premium_female}}{double Public sector wage premium for female personnel, compared to formal wage employees in the private sector.}
#'   \item{\code{ps_wage_premium_male}}{double Public sector wage premium for male personnel, compared to formal wage employees in the private sector.}
#'   \item{\code{ps_wage_premium_pooled}}{double Public sector wage premium for all public sector personnel, compared to formal wage employees in the private sector.}
#'   \item{\code{ps_share_total_emp}}{double Public sector employment, as a share of total employment}
#'   \item{\code{ps_share_paid_emp}}{double Public sector employment, as a share of paid employment}
#'   \item{\code{ps_share_formal_emp}}{double Public sector employment, as a share of formal employment}
#'   \item{\code{ps_wage_premium_isced_n}}{double Public sector wage premium for personnel with no education, compared to formal wage employees in the private sector.}
#'   \item{\code{ps_wage_premium_isced_1}}{double Public sector wage premium for personnel with primary education completed, compared to formal wage employees in the private sector.}
#'   \item{\code{ps_wage_premium_isced_2_3}}{double Public sector wage premium for personnel with secondary education completed, compared to formal wage employees in the private sector.}
#'   \item{\code{ps_wage_premium_isced_5t8}}{double Public sector wage premium for personnel with tertiary education completed, compared to formal wage employees in the private sector.}
#'   \item{\code{ps_wage_premium_clerk}}{double Public sector wage premium for personnel in clerical support occupations, compared to formal wage employees in the private sector.}
#'   \item{\code{ps_wage_premium_elementary}}{double Public sector wage premium for personnel in elementary occupations, compared to formal wage employees in the private sector.}
#'   \item{\code{ps_wage_premium_professional}}{double Public sector wage premium for personnel in professional occupations, compared to formal wage employees in the private sector.}
#'   \item{\code{ps_wage_premium_manager}}{double Public sector wage premium for personnel in managerial occupations, compared to formal wage employees in the private sector.}
#'   \item{\code{ps_wage_premium_technical}}{double Public sector wage premium for personnel in technical and associate professional occupations, compared to formal wage employees in the private sector.}
#'}
#' @source World Bank
#' \url{https://data360.worldbank.org/en/int/dataset/WB_WWBI}
"wwbi"

#' @title World Bank Enterprise Surveys
#' @description The Formal Sector World Bank Enterprise Surveys, generally known by the shortened term, World Bank Enterprise Surveys (WBES), are the main product of the Enterprise Surveys team. They are nationally representative firm-level surveys with top managers and owners of businesses in over 160 economies, reaching 180 in upcoming years, that provide insight into many business environment topics such as access to finance, corruption, infrastructure, and performance, among others. The comprehensive data and analytical reports enable easy comparisons across economies and time. The information collected through these surveys is publicly available at the economy and firm level. Explore the indicators by economy or topic, browse the surveys, or access the granular data on the WBES data portal.
#' @format A data frame with 413 rows and 3 variables:
#' \describe{
#'   \item{\code{country_code}}{character World Bank country code.}
#'   \item{\code{year}}{character Year.}
#'   \item{\code{workforce_constraint}}{character Proportion of establishments identifying an inadequately educated workforce as a major or severe constraint to the current operations of the establishment.}
#'}
#'
#' @source World Bank
#' \url{https://data360.worldbank.org/en/int/indicator/WB_ES_T_WK10}
"enterprise_surveys"

#' Harmonization Dictionary for Payroll Data
#'
#' A dictionary defining the standardized variable names, descriptions,
#' classes, and module assignments used during the payroll data harmonization
#' process.  
#'
#' This dictionary is used by the harmonization pipeline to map raw payroll,
#' contract, personnel, and establishment variables from government HRMIS /
#' payroll systems to a consistent, analysis-ready schema. Each row represents
#' one standardized variable name and specifies:
#' 
#' * **variable_name** — The human-readable name of the variable as it appears in the
#'   final harmonized dataset.  
#' * **variable_id** — The machine-readable variable name (snake_case) used in the
#'   harmonized output.  
#' * **variable_description** — A concise definition of the variable’s meaning and intended use.  
#' * **variable_class** — The R class the variable should be cast to (e.g., character,
#'   Date, numeric, integer).  
#' * **module** — The module where the variable belongs (e.g., *Establishment*,
#'   *Personnel*, *Contract*).
#'
#' This dictionary is designed so that automated harmonization scripts can:
#' 1. Validate presence and structure of required variables;  
#' 2. Rename raw variables to standardized IDs;  
#' 3. Coerce variables to the correct data type;  
#' 4. Split harmonized outputs into module-specific files.
#'
#' @format A tibble with 45 rows and 5 variables:
#' \describe{
#'   \item{variable_name}{Character. Human-readable variable name.}
#'   \item{variable_id}{Character. Standardized snake_case variable identifier.}
#'   \item{variable_description}{Character. Definition of the variable.}
#'   \item{variable_class}{Character. Target R class for the variable.}
#'   \item{module}{Character. Harmonization module using this variable.}
#' }
#'
#' @usage
#' dictionary
#'
#' @source Created by the Institutional Capacity and EFfectiveness team as part of
#' the payroll harmonization ETL framework.
#'
#' @keywords datasets harmonization payroll
"dictionary"

#' Brazilian Public Employee Payroll Data
#'
#' A dataset containing payroll information for Brazilian public sector employees,
#' including salary components, personal information, and employment details.
#'
#' @format A data frame with 34 variables:
#' \describe{
#'   \item{ANO_PAGAMENTO}{Payment year (numeric)}
#'   \item{MES_REFERENCIA}{Reference month (numeric)}
#'   \item{MATRICULA}{Employee registration/enrollment number (character)}
#'   \item{CPF}{Brazilian tax identification number - Cadastro de Pessoas Físicas (character)}
#'   \item{DATA_NASCIMENTO}{Date of birth (Date)}
#'   \item{GENERO}{Gender (character)}
#'   \item{ESCOLARIDADE}{Educational level/degree (character)}
#'   \item{DATA_ADMISSAO}{Admission/hiring date (Date)}
#'   \item{ADMINISTRACAO}{Administration type (character)}
#'   \item{TIPO_CONTRATO}{Contract type (character)}
#'   \item{GRUPO}{Employee group classification (character)}
#'   \item{COD_ORGAO}{Agency/department code (character)}
#'   \item{ORGAO}{Agency/department name (character)}
#'   \item{CARREIRA}{Career path/track (character)}
#'   \item{CARGO}{Position/job title (character)}
#'   \item{JORNADA}{Work schedule/hours (character)}
#'   \item{CLASSE}{Position class (character)}
#'   \item{NIVEL}{Position level (character)}
#'   \item{DATA_ULT_PROGRESSAO}{Date of last career progression (Date)}
#'   \item{SALARIO_BASE}{Base salary (numeric)}
#'   \item{CONTRIBUICAO_PREVIDENCIA}{Social security contribution (numeric)}
#'   \item{ADICIONAL_TEMPO_SERVICO}{Time of service bonus (numeric)}
#'   \item{COMISSAO}{Commission payment (numeric)}
#'   \item{ABONO_PERMANENCIA}{Permanence allowance (numeric)}
#'   \item{DECISAO_JUDICIAL}{Judicial decision payments (numeric)}
#'   \item{DEMAIS_GRATIFICACOES_TRANSITORIAS}{Other temporary bonuses (numeric)}
#'   \item{DEMAIS_GRATIFICACOES_CARREIRA}{Other career-related bonuses (numeric)}
#'   \item{SALARIO_BRUTO}{Gross salary (numeric)}
#'   \item{SALARIO_LIQUIDO}{Net salary (numeric)}
#'   \item{DATA_APOSENTADORIA}{Retirement date (Date)}
#'   \item{VALOR_BRUTO}{Gross amount (numeric)}
#'   \item{VALOR_LIQUIDO}{Net amount (numeric)}
#'   \item{TIPO}{Type/category (character)}
#'   \item{TEMPO DE CONTRIBUIÇÃO}{Contribution time period (character)}
#' }
#'
#' @source Brazilian public sector payroll records
#'
#' @examples
#' \dontrun{
#' # Summary of base salaries
#' summary(payroll_data$SALARIO_BASE)
#'
#' # Count by agency
#' table(payroll_data$ORGAO)
#' }
"bra_hrmis"

#' Contract Dataset
#'
#' This dataset contains detailed information about contracts, including salaries,
#' allowances, occupation, work hours, and establishmental context. Each row represents
#' a unique contract record.
#'
#' @format A data frame with N rows and 24 variables:
#' \describe{
#'   \item{contract_id}{Unique identifier for the contract}
#'   \item{personnel_id}{Foreign key linking to Personnel module}
#'   \item{est_id}{Foreign key linking to Establishment module}
#'   \item{ref_date}{Timestamp for the contract record}
#'   \item{contract_type_code}{Type of contract code}
#'   \item{contract_type_native}{Type of contract in local language}
#'   \item{base_salary_lcu}{Base compensation in local currency units (LCU)}
#'   \item{gross_salary_lcu}{Total compensation before deductions in local currency units}
#'   \item{net_salary_lcu}{Compensation after deductions in local currency units}
#'   \item{allowance_lcu}{Allowances in local currency units}
#'   \item{occupation_native}{Job title in the local language}
#'   \item{occupation_english}{Job title translated to English}
#'   \item{occupation_isconame}{ISCO standard occupation name}
#'   \item{occupation_iscocode}{ISCO standard occupation code}
#'   \item{start_date}{Contract start date}
#'   \item{end_date}{Contract end date, if applicable}
#'   \item{country_code}{Official World Bank ISO-3 country code}
#'   \item{country_name}{Official World Bank country name}
#'   \item{adm1_name}{First-level administrative division name}
#'   \item{adm1_code}{First-level administrative division code}
#'   \item{whours}{Standard or actual hours worked}
#'   \item{paygrade}{Salary scale or grade level}
#'   \item{seniority}{Years of service or seniority level}
#' }
#'
"bra_hrmis_contract"

#' Personnel Dataset
#'
#' This dataset contains demographic and employment information for personnel,
#' including identifiers, education, tribal/racial classification, employment status,
#' and geographic context. Each row represents a unique personnel record.
#'
#' @format A data frame with N rows and 9 variables:
#' \describe{
#'   \item{personnel_id}{Unique identifier for the personnel}
#'   \item{birth_date}{Personnel’s date of birth}
#'   \item{gender}{Personnel’s gender}
#'   \item{educat7}{Education level using 7-category classification}
#'   \item{tribe}{Tribal affiliation (where applicable)}
#'   \item{race}{Racial/ethnic classification}
#'   \item{status}{Current employment status (active/retired)}
#'   \item{country_code}{Official World Bank ISO-3 country code}
#'   \item{ref_date}{Timestamp for the personnel record}
#' }
#'
"bra_hrmis_personnel"

#' Establishment Dataset
#'
#' This dataset contains information about public sector establishments, including
#' identifiers, names, hierarchical relationships, and geographic context.
#' Each row represents a unique establishment record.
#'
#' @format A data frame with N rows and 9 variables:
#' \describe{
#'   \item{est_id}{Unique identifier for the establishment}
#'   \item{est_name_native}{Official establishment name in local language}
#'   \item{est_name_en}{Establishment name translated to English}
#'   \item{country_code}{Official World Bank ISO-3 country code}
#'   \item{country_name}{Official World Bank country name}
#'   \item{adm1_name}{First-level administrative division name}
#'   \item{adm1_code}{First-level administrative division code}
#'   \item{est_parent}{Identifier for parent establishment in hierarchy}
#'   \item{est_child}{Identifier for child establishments in hierarchy}
#' }
#'
"bra_hrmis_est"

#' Personnel Validation Rules
#'
#' A dataset containing validation rules for personnel data quality checks.
#' These rules are designed to be used with the \code{validate} package to
#' assess the quality and consistency of personnel records in HRMIS data.
#'
#' @format A tibble with 9 rows and 5 variables:
#' \describe{
#'   \item{rule}{Character. The validation rule expression as a string that can be parsed by \code{validate::validator()}.}
#'   \item{name}{Character. Unique identifier for the rule (e.g., "personnel_ref_date_valid").}
#'   \item{description}{Character. Detailed explanation of what the rule checks. This description appears in validation summaries.}
#'   \item{label}{Character. Short 2-3 word label for the rule, useful for plotting and quick reference.}
#'   \item{required_vars}{Character. Comma-separated list of minimum required variables for the rule to be evaluated. At minimum: personnel_id and birth_date.}
#' }
#'
#' @details
#' The personnel validation rules check:
#' \itemize{
#'   \item Column existence (personnel_id, ref_date, birth_date, status)
#'   \item ID uniqueness (personnel_id + ref_date combination is unique)
#'   \item Reference date validity (within reasonable historical bounds)
#'   \item Age range (18-70 years calculated from birth_date and ref_date)
#'   \item Birth date reasonableness
#'   \item Employment status validity (active, inactive, retired, terminated)
#' }
#'
#' These rules can be programmatically converted to \code{validate::validator()} objects
#' for use in data quality pipelines.
#'
#' @seealso \code{\link{contract_rules}}, \code{\link{validate_data}}
#'
#' @examples
#' # View all personnel validation rules
#' personnel_rules
#'
#' # Filter to specific rule
#' personnel_rules[personnel_rules$name == "personnel_age_range", ]
#'
#' @source Created for the govhr package data quality framework
"personnel_rules"

#' Contract Validation Rules
#'
#' A dataset containing validation rules for contract and wage bill data quality checks.
#' These rules are designed to be used with the \code{validate} package to
#' assess the quality and consistency of contract records in HRMIS data.
#'
#' @format A tibble with 17 rows and 5 variables:
#' \describe{
#'   \item{rule}{Character. The validation rule expression as a string that can be parsed by \code{validate::validator()}.}
#'   \item{name}{Character. Unique identifier for the rule (e.g., "contract_ref_date_valid").}
#'   \item{description}{Character. Detailed explanation of what the rule checks. This description appears in validation summaries.}
#'   \item{label}{Character. Short 2-3 word label for the rule, useful for plotting and quick reference.}
#'   \item{required_vars}{Character. Comma-separated list of minimum required variables for the rule to be evaluated. At minimum: contract_id, personnel_id, gross_salary_lcu, base_salary_lcu, and allowance_lcu.}
#' }
#'
#' @details
#' The contract validation rules check:
#' \itemize{
#'   \item Column existence (contract_id, ref_date, gross_salary_lcu, base_salary_lcu, allowance_lcu)
#'   \item Contract ID uniqueness (contract_id + ref_date combination is unique)
#'   \item Personnel assignment uniqueness (contract_id + personnel_id + ref_date combination is unique)
#'   \item Reference date validity
#'   \item Working hours reasonableness (1-168 hours per week)
#'   \item Contract status consistency (start_date <= ref_date)
#'   \item Wage bill composition (gross = base + allowance)
#'   \item Wage bill hierarchy (net <= gross, base <= gross)
#'   \item Positive salary values (gross, base, net >= 1)
#'   \item Allowance validity (non-negative or missing)
#' }
#'
#' These rules can be programmatically converted to \code{validate::validator()} objects
#' for use in data quality pipelines.
#'
#' @seealso \code{\link{personnel_rules}}, \code{\link{validate_data}}
#'
#' @examples
#' # View all contract validation rules
#' contract_rules
#'
#' # Filter to wage bill rules
#' contract_rules[grepl("wagebill", contract_rules$name), ]
#'
#' @source Created for the govhr package data quality framework
"contract_rules"

