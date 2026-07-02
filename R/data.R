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

#' Harmonization Dictionary for Payroll and HRMIS Data
#'
#' A dictionary defining the standardized variables, descriptions, data types,
#' module assignments, and permissible values used in the GovHR harmonization
#' framework.
#'
#' This dictionary serves as the authoritative data standard for harmonizing
#' payroll and Human Resource Management Information System (HRMIS) data from
#' government institutions into a consistent, analysis-ready structure.
#' Each row represents a standardized variable and provides its identifier,
#' definition, expected data type, module assignment, and expected values or
#' coding scheme where applicable.
#'
#' The dictionary is used throughout the harmonization pipeline to map raw
#' source variables from government payroll and HRMIS systems to a common
#' schema, enabling cross-country comparability and reproducible analytics.
#'
#' The dictionary contains the following fields:
#'
#' \itemize{
#'   \item \strong{variable_name} -- Human-readable name of the standardized variable.
#'   \item \strong{variable_id} -- Machine-readable variable identifier used in harmonized datasets.
#'   \item \strong{variable_description} -- Definition and intended use of the variable.
#'   \item \strong{variable_class} -- Expected R data type for the variable.
#'   \item \strong{module} -- Harmonization module to which the variable belongs (e.g., Establishment, Personnel, or Contract).
#'   \item \strong{values} -- Expected values, formats, coding schemes, or controlled vocabularies associated with the variable.
#' }
#'
#' This dictionary is designed to support:
#'
#' \enumerate{
#'   \item Validation of required variables and schema compliance;
#'   \item Standardized renaming of source variables;
#'   \item Data type coercion and consistency checks;
#'   \item Generation of harmonized module-specific outputs;
#'   \item Documentation and governance of the GovHR data standard.
#' }
#'
#' @section Dictionary Version:
#' \strong{Version 1.0.0}
#'
#' This version corresponds to the initial public release of the GovHR
#' harmonization dictionary.
#'
#' @section Version History:
#' \itemize{
#'   \item \strong{Version 1.0.0} (2026-06-25): Initial release.
#' }
#'
#' @format A tibble with 50 rows and 6 variables:
#' \describe{
#'   \item{variable_name}{Character. Human-readable name of the standardized variable.}
#'   \item{variable_id}{Character. Standardized machine-readable variable identifier.}
#'   \item{variable_description}{Character. Definition and intended use of the variable.}
#'   \item{variable_class}{Character. Expected R class for the variable.}
#'   \item{module}{Character. Harmonization module to which the variable belongs.}
#'   \item{values}{Character. Expected values, formats, coding schemes, or controlled vocabularies associated with the variable.}
#' }
#'
#' @usage
#' dictionary
#'
#' @source
#' Created and maintained by the Public Institutions Data and Analytics Unit
#' (EGVPI) of the World Bank as part of the GovHR harmonization framework.
#'
#' @keywords datasets harmonization payroll hrmis governance
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

#' HRMIS Contract Dataset
#'
#' Harmonized contract-level human resource management information system (HRMIS)
#' data for the State of Alagoas, Brazil. Each observation represents a unique
#' contract at a given reference date (`contract_id`, `ref_date`) and contains
#' information on remuneration, contract characteristics, occupation, and
#' employment details.
#'
#' The dataset follows the GovHR contract module data dictionary and is intended
#' for workforce analytics, payroll analysis, and personnel microsimulation.
#'
#' @format A data frame with 16,434 rows and 19 variables:
#' \describe{
#'   \item{contract_id}{Unique identifier assigned to each contract.}
#'   \item{personnel_id}{Unique identifier assigned to each worker.}
#'   \item{est_id}{Unique identifier assigned to each establishment.}
#'   \item{ref_date}{Reference date of the HRMIS record.}
#'   \item{base_salary_lcu}{Basic salary before allowances and deductions (local currency units).}
#'   \item{allowance_lcu}{Total allowances paid in addition to base salary (local currency units).}
#'   \item{gross_salary_lcu}{Total compensation before taxes and deductions (local currency units).}
#'   \item{net_salary_lcu}{Take-home pay after taxes and deductions (local currency units).}
#'   \item{whours}{Contracted working hours.}
#'   \item{start_date}{Employment contract start date.}
#'   \item{end_date}{Employment contract end date, if applicable.}
#'   \item{paygrade}{Pay grade or salary scale classification.}
#'   \item{seniority}{Level or step within the pay grade.}
#'   \item{occupation_native}{Occupation title in the native language.}
#'   \item{occupation_english}{Occupation title translated into English.}
#'   \item{occupation_iscocode}{ISCO-08 occupation code (4-digit level).}
#'   \item{occupation_isconame}{ISCO-08 occupation name corresponding to the occupation code.}
#'   \item{contract_type_native}{Employment contract type in the native language.}
#'   \item{contract_type}{Standardized employment contract type. One of
#'   \code{"permanent"}, \code{"fixed-term"}, \code{"short-term"},
#'   \code{"pensioner"}, or \code{"inactive"}.}
#' }
#'
#' @details
#' This dataset is harmonized according to the GovHR data dictionary. Salary
#' variables are expressed in nominal local currency units (LCU). Occupations
#' are translated into English and mapped to the International Standard
#' Classification of Occupations (ISCO-08). Contract types are standardized
#' across countries to facilitate comparative analysis.
#'
#' @source
#' Government of the State of Alagoas Human Resource Management Information
#' System (HRMIS), harmonized by the GovHR project.
#'
#' @seealso
#' \code{\link{bra_hrmis_personnel}},
#' \code{\link{bra_hrmis_est}}
#'
#' @examples
#' data(bra_hrmis_contract)
#' head(bra_hrmis_contract)
"bra_hrmis_contract"

#' HRMIS Personnel Dataset
#'
#' Harmonized personnel-level human resource management information system
#' (HRMIS) data for the State of Alagoas, Brazil. Each observation represents a
#' unique worker at a given reference date (`personnel_id`, `ref_date`) and
#' contains demographic characteristics, education, employment status, and
#' public service information.
#'
#' The dataset follows the GovHR personnel module data dictionary and is
#' intended for workforce analytics, demographic analysis, and personnel
#' microsimulation.
#'
#' @format A data frame with 15,681 rows and 11 variables:
#' \describe{
#'   \item{personnel_id}{Unique identifier assigned to each worker.}
#'   \item{ref_date}{Reference date of the HRMIS record.}
#'   \item{birth_date}{Worker's date of birth.}
#'   \item{age}{Worker's age in years at the reference date.}
#'   \item{gender}{Worker's gender.}
#'   \item{educat7}{Educational attainment using the World Bank Global Labor Database (GLD) seven-level education classification.}
#'   \item{employment_status}{Standardized employment status. One of
#'   \code{"active"}, \code{"inactive"}, or \code{"pensioner"}.}
#'   \item{service_type}{Type of public service. One of
#'   \code{"civilian"} or \code{"military"}.}
#'   \item{race}{Worker's race or broad ethnic classification, where available.}
#'   \item{tribe}{Worker's ethnic or tribal affiliation, where available.}
#'   \item{first_employment_date}{Date the worker first entered the public service.}
#' }
#'
#' @details
#' This dataset is harmonized according to the GovHR data dictionary. Educational
#' attainment follows the seven-level classification used by the World Bank's
#' Global Labor Database (GLD). Employment status and service type are
#' standardized across countries to facilitate comparative analysis of public
#' sector workforces.
#'
#' @source
#' Government of the State of Alagoas Human Resource Management Information
#' System (HRMIS), harmonized by the GovHR project.
#'
#' @seealso
#' \code{\link{bra_hrmis_contract}},
#' \code{\link{bra_hrmis_est}}
#'
#' @examples
#' data(bra_hrmis_personnel)
"bra_hrmis_personnel"

#' HRMIS Establishment Dataset
#'
#' Harmonized establishment-level human resource management information system
#' (HRMIS) data for the State of Alagoas, Brazil. Each observation represents a
#' unique public sector establishment and contains standardized establishment
#' names, country identifiers, and functional classifications.
#'
#' The dataset follows the GovHR establishment module data dictionary and is
#' intended to support organizational analysis, workforce reporting, and
#' aggregation of personnel and contract records.
#'
#' @format A data frame with 65 rows and 6 variables:
#' \describe{
#'   \item{est_name_native}{Official establishment name in the native language (Portuguese).}
#'   \item{est_id}{Unique identifier assigned to each establishment.}
#'   \item{ref_date}{Reference date of the HRMIS record.}
#'   \item{country_code}{Three-letter ISO 3166-1 alpha-3 country code following the World Bank convention (e.g., \code{"BRA"}).}
#'   \item{country_name}{Official World Bank country name.}
#'   \item{est_name_en}{Official establishment name translated into English.}
#'   \item{sector}{Standardized Classification of the Functions of Government (COFOG) sector assigned to the establishment.}
#' }
#'
#' @details
#' This dataset is harmonized according to the GovHR establishment module data
#' dictionary. Establishment names are translated into English to facilitate
#' international comparative analysis. Each establishment is assigned to one of
#' the ten top-level COFOG functional sectors:
#'
#' \itemize{
#'   \item General Public Services
#'   \item Defence
#'   \item Public Order and Safety
#'   \item Economic Affairs
#'   \item Environmental Protection
#'   \item Housing and Community Amenities
#'   \item Health
#'   \item Recreation, Culture and Religion
#'   \item Education
#'   \item Social Protection
#' }
#'
#' @source
#' Government of the State of Alagoas Human Resource Management Information
#' System (HRMIS), harmonized by the GovHR project.
#'
#' @seealso
#' \code{\link{bra_hrmis_contract}},
#' \code{\link{bra_hrmis_personnel}}
#'
#' @examples
#' data(bra_hrmis_est)
#' head(bra_hrmis_est)
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


#' COFOG Functional Classification Taxonomy
#'
#' A lookup table containing the first-level Classification of the Functions
#' of Government (COFOG) taxonomy used by `govhrcast` to classify government
#' establishments according to their primary functional responsibilities.
#'
#' The dataset includes the ten top-level COFOG classes defined by the
#' International Monetary Fund (IMF) Government Finance Statistics Manual
#' and the United Nations Classification of the Functions of Government,
#' together with descriptive keyword dictionaries that facilitate automated
#' establishment classification during HRMIS harmonization.
#'
#' @format A data frame with 10 rows and 3 variables:
#' \describe{
#'   \item{class_id}{Character. Two-digit COFOG class identifier (e.g.,
#'   `"01"`, `"02"`).}
#'
#'   \item{class_label}{Character. Name of the first-level COFOG function.}
#'
#'   \item{description}{Character. Collection of keywords and descriptive
#'   terms associated with each COFOG function. These are intended to support
#'   rule-based and machine-assisted classification of government
#'   establishments.}
#' }
#'
#' The ten first-level COFOG functions are:
#' \enumerate{
#'   \item General Public Services
#'   \item Defence
#'   \item Public Order and Safety
#'   \item Economic Affairs
#'   \item Environmental Protection
#'   \item Housing and Community Amenities
#'   \item Health
#'   \item Recreation, Culture and Religion
#'   \item Education
#'   \item Social Protection
#' }
#'
#' @details
#' This dataset is intended primarily for internal use by the establishment
#' harmonization workflow, where establishment names are mapped to functional
#' classifications using keyword matching and other natural language
#' processing methods. Users may also employ the taxonomy directly when
#' developing custom classification rules or validating automated
#' classifications in general.
#'
#' @seealso
#' \code{\link{dictionary}},
#'
#' @source
#' United Nations. *Classification of the Functions of Government (COFOG)*;
#' International Monetary Fund. *Government Finance Statistics Manual 2014*.
#'
#' @docType data
#' @keywords datasets
#' @name cofog_taxonomy
#' @usage data(cofog_taxonomy)
NULL

#' Brazil HRMIS Allowance Module
#'
#' A harmonized personnel allowance dataset derived from the Brazil Human
#' Resource Management Information System (HRMIS). Each record represents a
#' single allowance or bonus received by a personnel contract during a
#' reference period.
#'
#' The dataset follows a long format, with one observation per
#' `contract_id`–`ref_date`–`allowance_type` combination. Monetary values are
#' reported in local currency units (LCU).
#'
#' @format A data frame with 60,430 rows and 5 variables:
#' \describe{
#'   \item{contract_id}{Character. Unique identifier for the employment
#'   contract associated with the allowance.}
#'
#'   \item{ref_date}{Date. Reference date for the payroll record.}
#'
#'   \item{allowance_type}{Character. Harmonized allowance or bonus category.}
#'
#'   \item{allowance_lcu}{Numeric. Value of the allowance in local currency
#'   units (LCU).}
#'
#'   \item{personnel_id}{Character. Unique identifier for the individual
#'   receiving the allowance.}
#' }
#'
#' @details
#' The allowance module records non-base salary remuneration components paid
#' to employees, including permanent and temporary allowances, bonuses,
#' commissions, and other supplementary payments. Each observation
#' corresponds to a single allowance category for a specific contract and
#' payroll reference date.
#'
#' Multiple allowance records may exist for the same contract and reference
#' date when an employee receives more than one type of allowance.
#'
#' @source
#' Government of the State of Alagoas Human Resource Management Information
#' System (HRMIS), harmonized by the `govhrcast` package.
#'
#' @docType data
#' @keywords datasets
#' @name bra_hrmis_allowance
#' @usage data(bra_hrmis_allowance)
NULL