## code to prepare `economy_wide` variables for wage diagnostics
# last updated: 6/11/2026
library(purrr)
library(dplyr)

idvar_list <- list(
  "gdp_lcu" = "WB_WDI_NY_GDP_MKTP_CN",
  "pexpenditure_lcu" = "WB_WDI_GC_XPN_TOTL_CN",
  "prevenue_lcu" = "WB_WDI_GC_REV_XGRT_CN",
  "taxrevenue_lcu" = "WB_WDI_GC_TAX_TOTL_CN",
  "emp_pop_rate" = "WB_WDI_SL_EMP_TOTL_SP_NE_ZS",
  "labor_force_total" = "WB_WDI_SL_TLF_TOTL_IN",
  "labor_force_women" = "WB_WDI_SL_TLF_TOTL_FE_ZS",
  "labor_force_advanced_edu" = "WB_WDI_SL_TLF_ADVN_ZS",
  "tot_pop" = "WB_WDI_SP_POP_TOTL",
  "salaried_rate" = "WB_WDI_SL_EMP_WORK_ZS",
  "government_expenditure_gdp" = "WB_WDI_NE_CON_GOVT_ZS",
  "cpi" = "WB_WDI_FP_CPI_TOTL",
  "ppp" = "WB_WDI_PA_NUS_PRVT_PP"
)

macro_indicators <- lapply(X = idvar_list,
             FUN = get_data360_api,
             dataset_id = "WB_WDI") |>
      Reduce(f = "merge_wrapper") |>
      as_tibble() |>
      setNames(c("country_code", "year", names(idvar_list)))

fiscal_balance <- readr::read_csv(
  "https://data360files.worldbank.org/data360-data/data/WB_MPO/GGBALOVRL_WIDEF.csv"
) |>
  filter(
    VINTAGE == "V_SM2026" & # spring meetings 2026
    UNIT_MEASURE == "PT_GDP" & # percentage of GDP
    OBS_STATUS == "A"
  ) |>
  tidyr::pivot_longer(
    cols = c(`1980`:`2028`),
    names_to = "TIME_PERIOD",
    values_to = "fiscal_balance"
  ) |>
  select(
    country_code = REF_AREA,
    year = TIME_PERIOD,
    fiscal_balance
  )

macro_indicators <-
  macro_indicators |>
  left_join(
    fiscal_balance,
    by = c("country_code", "year")
  ) |>
  mutate(
    across(-c(country_code), as.numeric)
  )

macro_indicators <-
  macro_indicators |>
  mutate(emp_pop = 0.01 * emp_pop_rate * tot_pop)

macro_indicators <-
  macro_indicators |>
  mutate(salaried_pop = salaried_rate * emp_pop)

usethis::use_data(macro_indicators, overwrite = TRUE)
