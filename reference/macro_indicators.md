# Macro-level World Bank WDI indicators

This dataset contains a selection of macroeconomic and labor market
indicators for multiple countries and years. The data are primarily
sourced from the World Bank World Development Indicators (WDI) via the
Data360 API. The variables have been renamed for convenience, but the
original WDI variable codes are provided for reference.

## Usage

``` r
macro_indicators
```

## Format

A tibble with 11652 rows and 14 variables:

- country_code:

  ISO3 country code (originally from Data360 API).

- year:

  Year of observation (character, originally from Data360 API).

- gdp_lcu:

  Gross Domestic Product (local currency units). Original WDI code:
  WB_WDI_NY_GDP_MKTP_CN.

- pexpenditure_lcu:

  Total government expenditure (local currency units). Original WDI
  code: WB_WDI_GC_XPN_TOTL_CN.

- prevenue_lcu:

  Total government revenue (local currency units). Original WDI code:
  WB_WDI_GC_REV_XGRT_CN.

- taxrevenue_lcu:

  Total government tax revenue (local currency units). Original WDI
  code: WB_WDI_GC_TAX_TOTL_CN.

- emp_pop_rate:

  Employment-to-population ratio (in percent). Original WDI code:
  WB_WDI_SL_EMP_TOTL_SP_NE_ZS.

- labor_force_total:

  Labor force, total. Original WDI code: WB_WDI_SL_TLF_TOTL_IN.

- labor_force_advanced_edu:

  Labor force with advanced education (percentage of total working-age
  population with advanced education). Original WDI code:
  WB_WDI_SL_TLF_ADVN_ZS.

- labor_force_women:

  Labor force, women (percentage of total labor force). Original WDI
  code: WB_WDI_SL_TLF_TOTL_FE_ZS.

- tot_pop:

  Total population. Original WDI code: WB_WDI_SP_POP_TOTL.

- government_expenditure_gdp:

  General government final consumption expenditure (percentage of GDP).
  Original WDI code: WB_WDI_NE_CON_GOVT_ZS.

- salaried_rate:

  Share of employed people who are salaried (in percent). Original WDI
  code: WB_WDI_SL_EMP_WORK_ZS.

- cpi:

  Consumer Price Index, total. Original WDI code: WB_WDI_FP_CPI_TOTL.

- ppp:

  Purchasing Power Parity (local currency units per international USD).
  Original WDI code: WB_WDI_PA_NUS_PRVT_PP.

- fiscal_balance:

  Overall Fiscal Balance, USD, percentage of GDP.

- emp_pop:

  The population of employed i.e. \`emp_pop_rate\` \* \`tot_pop\`.

- salaried_pop:

  The population of salaried personnel i.e. \`salaried_rate\` \*
  \`emp_pop\`.

## Source

Data360 API, World Bank World Development Indicators (WDI)
<https://data.worldbank.org/indicator>

## Details

This dataset was prepared to support wage bill diagnostics and other
fiscal and labor market analysis. All numeric variables have been
coerced to numeric type. Missing values may exist for certain countries
and years.
