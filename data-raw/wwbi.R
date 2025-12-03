## code to prepare `wwbi` dataset goes here
library(dplyr)
library(readxl)
library(janitor)
library(tidyr)
library(stringr)

devtools::load_all()

# accessed 2025.12.03
wwbi_indicators <- c(
  "WB_WWBI_BI_WAG_PREM_PE",
  "WB_WWBI_BI_WAG_PREM_FW",
  "WB_WWBI_BI_PWK_PUBS_ED",
  "WB_WWBI_BI_EMP_TOTL_PB",
  "WB_WWBI_BI_EMP_PWRK_PB",
  "WB_WWBI_BI_EMP_FRML_PB"
)

wwbi_raw <- get_data360_api(
  "WB_WWBI",
  wwbi_indicators,
  pivot = FALSE
)

wwbi_educational_attainment <- wwbi_raw |>
  filter(
    INDICATOR == "WB_WWBI_BI_PWK_PUBS_ED" &
      str_detect(COMP_BREAKDOWN_1, "^ISCED")
  ) |>
  pivot_wider(
    id_cols = c(REF_AREA, TIME_PERIOD),
    values_from = OBS_VALUE,
    names_from = c(INDICATOR, COMP_BREAKDOWN_1),
    names_sep = "_"
  ) |>
  rename(
    country_code = REF_AREA,
    year = TIME_PERIOD,
    share_no_edu = WB_WWBI_BI_PWK_PUBS_ED_ISCED11_N,
    share_primary_edu = WB_WWBI_BI_PWK_PUBS_ED_ISCED11_1,
    share_secondary_edu = WB_WWBI_BI_PWK_PUBS_ED_ISCED11_2_3,
    share_tertiary_edu = WB_WWBI_BI_PWK_PUBS_ED_ISCED11_5T8
  )

wwbi_wage_premium <- wwbi_raw |>
  filter(
    INDICATOR == "WB_WWBI_BI_WAG_PREM_PE"|
      INDICATOR == "WB_WWBI_BI_WAG_PREM_FW"
  ) |>
  pivot_wider(
    id_cols = c(REF_AREA, TIME_PERIOD),
    values_from = OBS_VALUE,
    names_from = c(INDICATOR, COMP_BREAKDOWN_1, SEX),
    names_sep = "_"
  ) |>
  rename(
    country_code = REF_AREA,
    year = TIME_PERIOD,
    ps_wage_premium_pooled = WB_WWBI_BI_WAG_PREM_PE__Z__T,
    ps_wage_premium_female = WB_WWBI_BI_WAG_PREM_PE__Z_F,
    ps_wage_premium_male = WB_WWBI_BI_WAG_PREM_PE__Z_M,
    ps_wage_premium_edu_sector = WB_WWBI_BI_WAG_PREM_PE_WB_WWBI_INED__T,
    ps_wage_premium_hea_sector = WB_WWBI_BI_WAG_PREM_PE_WB_WWBI_INHE__T,
    ps_wage_premium_isced_n = WB_WWBI_BI_WAG_PREM_FW_ISCED11_N__T,
    ps_wage_premium_isced_1 = WB_WWBI_BI_WAG_PREM_FW_ISCED11_1__T,
    ps_wage_premium_isced_2_3 = WB_WWBI_BI_WAG_PREM_FW_ISCED11_2_3__T,
    ps_wage_premium_isced_5t8 = WB_WWBI_BI_WAG_PREM_FW_ISCED11_5T8__T
  )

wwbi_employment <- wwbi_raw |> 
  filter(
    INDICATOR %in% c(
      "WB_WWBI_BI_EMP_TOTL_PB",
      "WB_WWBI_BI_EMP_PWRK_PB",
      "WB_WWBI_BI_EMP_FRML_PB"
    ) &
      # _Z denotes pooled
      COMP_BREAKDOWN_1 == "_Z" &
      # _T denotes total 
      SEX == "_T" & AGE == "_T" & URBANISATION == "_T"
  ) |> 
    pivot_data360() |> 
  rename(
    ps_share_total_emp = wb_wwbi_bi_emp_totl_pb,
    ps_share_paid_emp = wb_wwbi_bi_emp_pwrk_pb,
    ps_share_formal_emp = wb_wwbi_bi_emp_frml_pb
  )

wwbi <- wwbi_educational_attainment |>
  full_join(
    wwbi_wage_premium,
    by = c("country_code", "year")
  ) |>
  full_join(
    wwbi_employment,
    by = c("country_code", "year")
  ) |> 
  mutate(
    across(
      -c(country_code),
      as.numeric
    )
  )

usethis::use_data(wwbi, overwrite = TRUE)
