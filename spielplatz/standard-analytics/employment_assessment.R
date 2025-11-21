# reference:
# https://documents1.worldbank.org/curated/en/324801640074379484/pdf/Public-Sector-Employment-and-Compensation-An-Assessment-Framework.pdf

# set-up ------------------------------------------------------------------
library(here)
library(dplyr)
library(readr)
library(ggplot2)
library(purrr)
library(lubridate)
library(ggthemes)

# set default color palette with scale_color_brewer
theme_set(
  theme_few()
)

devtools::load_all()

# read-in data ------------------------------------------------------------
personnel <- read_rds(
  here("inst", "extdata", "bra_hrmis_personnel.rds")
)

contract <- read_rds(
  here("spielplatz", "bra_hrmis_contract.rds")
)

# process data ------------------------------------------------------------
contract_ppp <- contract |>
  convert_constant_ppp(
    ends_with("lcu"),
    macro_indicators |> mutate(year = as.numeric(year))
  )

contract_summary_ppp <- contract_ppp |>
  compute_grouped_summary(
    group_vars = c(year, paygrade),
    cols = c(base_salary_ppp, allowance_ppp)
  )

contract_annual_growth <- contract_ppp |>
  group_by(country_code, year) |>
  summarise(
    median_wage_ppp = median(gross_salary_ppp, na.rm = TRUE),
    total_headcount = n(),
    .groups = "drop"
  ) |>
  mutate(
    growth_median_wage_ppp = (median_wage_ppp - lag(median_wage_ppp))/lag(median_wage_ppp) * 100
  ) |>
  left_join(
    macro_indicators,
    by = c("country_code", "year")
  )

wage_bill_change <- contract_ppp |>
  filter(
    paygrade %in% seq(1, 4, 1)
  ) |>
  mutate(
    year = as.integer(year)
  ) |>
  group_by(paygrade, year) |>
  summarise(
    median_base_salary_ppp = median(base_salary_ppp, na.rm = TRUE),
    .groups = "drop"
  ) |>
  arrange(paygrade, year) |>
  group_by(paygrade) |>
  mutate(
    pct_change = 100 * (median_base_salary_ppp - lag(median_base_salary_ppp))/ lag(median_base_salary_ppp),
    .groups = "drop"
  )

# analysis ----------------------------------------------------------------
# 3.6. wage incentives ----------------------------------------------------
# 3.6.1. percentage of staff receiving highest performance ratings
# N/A

# 3.6.2. annual, within-grade pay increases
contract_ppp |>
  filter(
    paygrade %in% seq(1, 4, 1)
  ) |>
  mutate(
    year = as.numeric(year)
  ) |>
  group_by(
    paygrade,
    year
  ) |>
  summarise(
    mean_base_salary_ppp = mean(base_salary_ppp),
    median_base_salary_ppp = median(base_salary_ppp)
  ) |>
  ggplot_point_line(
    year,
    median_base_salary_ppp,
    group = paygrade
  ) +
  scale_color_brewer(
    name = "Paygrade",
    palette = "Paired"
  ) +
  theme(
    legend.position = "bottom"
  ) +
  labs(
    x = "Year",
    y = "Median Salary (Constant International Dollars)"
  )

# as growth rates
wage_bill_change |>
  ggplot_point_line(
    year,
    pct_change,
    label = round(pct_change, 1)
  ) +
  geom_hline(
    yintercept = 0,
    linetype = "dashed"
  ) +
  scale_color_brewer(
    name = "Paygrade", palette = "Paired"
  ) +
  scale_x_continuous(
    breaks = scales::pretty_breaks()
  ) +
  theme(
    legend.position = "bottom"
  ) +
  facet_wrap(
    vars(paygrade)
  ) +
  coord_cartesian(
    ylim = c(-10, 40)
  ) +
  labs(
    x = "Year",
    y = "Annual Change (%)",
    title = "Annual Change in Median Salary by Paygrade"
  )

# 3.6.3. percentage of staff receiving a performance bonus
performance_bonus_personnel <- contract |>
  filter(
    !is.na(allowance_lcu)
  ) |>
  group_by(year) |>
  summarise(
    total_performance = n_distinct(personnel_id)
  )

contract |>
  group_by(year) |>
  summarise(
    total = n_distinct(personnel_id)
  ) |>
  left_join(
    performance_bonus_personnel,
    by = "year"
  ) |>
  mutate(
    year = as.numeric(year),
    share_performance = total_performance/total
  ) |>
  ggplot_point_line(
    year,
    share_performance
  ) +
  scale_y_continuous(
    labels = scales::percent_format()
  ) +
  labs(
    x = "Year",
    y = "Share of personnel"
  )

# 3.6.4. performance bonus as a percentage of basic pay
contract_summary_ppp |>
  mutate(
    share_allowance = allowance_ppp_mean/base_salary_ppp_mean
  ) |>
  filter(
    paygrade %in% seq(1, 4, 1)
  ) |>
  ggplot_point_line(
    year,
    share_allowance,
    group = paygrade
  ) +
  facet_wrap(
    vars(paygrade)
  ) +
  scale_color_brewer(
    name = "Paygrade", palette = "Paired"
  ) +
  scale_y_continuous(
    labels = scales::percent_format()
  ) +
  labs(
    x = "Year",
    y = "Share of personnel"
  )

# 3.6.6. hardship allowance and percentage of staff receiving it
# n/a: no data on hardship available

# fiscal sustainability ---------------------------------------------------
# 4.1.1. correlation between wage bill growth and fiscal balances
contract_annual_growth |>
  ggplot() +
  geom_point(
    aes(growth_median_wage_ppp, fiscal_balance)
  )

# 4.1.2.Correlation between wage bill growth and changes in capital and non-wage recurrent expenditures
contract_annual_growth |>
  ggplot(
    aes(
      government_expenditure_gdp,
      growth_median_wage_ppp
    )
  ) +
  geom_point() +
  labs(
    x = "Government Expenditre (Share of GDP)",
    y = "Wage growth"
  )

# 4.1.3. Decomposition of wage growth: employment and wages
contract_annual_growth |>
  filter(year <= 2017) |>
  transmute(
    year,
    `Median Wage (PPP)` = median_wage_ppp/median_wage_ppp[year == min(year)] * 100,
    `Total Headcount` = total_headcount/total_headcount[year == min(year)] * 100
  ) |>
  pivot_longer(
    -c(year),
    names_to = "Indicator"
  ) |>
  ggplot_point_line(
    year,
    value,
    group = Indicator
  )

# 4.2. public sector productivity -----------------------------------------
# 4.2.1. Correlation between wage bill growth and public-sector outputs and outcomes.
# confidence in government
# challenge: confidence in government is measured at the national level and
# generally for only a few years
# not representative at the institutional level
contract_annual_growth |>
  inner_join(
    social_sustainability,
    by = c("country_code", "year")
  )

# 4.3. labor allocation between public and private sectors ----------------
# 4.3.1. public sector wage premium
wwbi |>
  filter(country_code == "BRA") |>
  ggplot_point_line(
    year,
    ps_wage_premium_pooled
  ) +
  labs(
    x = "Year",
    y = "Public Sector Wage Premium"
  )

wwbi |>
  filter(country_code == "BRA") |>
  select(country_code, year, starts_with("ps_wage")) |>
  pivot_longer(
    cols = c(starts_with("ps_wage_")),
    names_prefix = "ps_wage_premium_"
  ) |>
  mutate(
    name = case_when(
      name == "edu_sector" ~ "Education",
      name == "hea_sector" ~ "Health",
      name == "female" ~ "Female personnel",
      name == "male" ~ "Male personnel",
      name == "pooled" ~  "Overall"
    )
  ) |>
  filter(
    between(year, 2002, 2015)
  ) |>
  ggplot_point_line(
    year,
    value,
    group = name
  )

# 4.3.2. Number of applications per position
# N/A

# 4.3.3. Correlation between public sector employment growth or recruitment patterns and
# private-sector employment growth or recruitment patterns (by skill, demographic, occupation,
# and geographical groups)
contract_annual_growth |>
  transmute(
    year,
    `Total Headcount` = total_headcount/total_headcount[year == 2007] * 100,
    `Total labor force` = labor_force_total/labor_force_total[year == 2007] * 100
  ) |>
  pivot_longer(
    -c(year),
    names_to = "Indicator"
  ) |>
  ggplot_point_line(
    year,
    value,
    group = Indicator
  ) +
  labs(
    x = "Year",
    y = "Index (2007 = 100)"
  )

# 4.3.4. Trends in educational profiles of public-sector personnels relative to private-sector personnels (by demographic, occupation, and geographical groups)
personnel |>
  mutate(
    year = year(ref_date)
  ) |>
  group_by(country_code, year) |>
  summarise(
    ps_share_tertiary = mean(educat7 %in% c("Higher than secondary but not university", "University incomplete or complete"), na.rm = TRUE) * 100,
    .groups = "drop"
  ) |>
  left_join(
    macro_indicators,
    by = c("country_code", "year")
  ) |>
  pivot_longer(
    cols = c(ps_share_tertiary, labor_force_advanced_edu)
  ) |>
  ggplot_point_line(
    year,
    value,
    group = name
  )

# 4.3.5. Correlation between public-sector wage premium and relative employment
# growth in the public sector (by skill, demographic, occupation, and geographical groups)
contract_annual_growth |>
  group_by(country_code) |>
  compute_change(
    col = total_headcount,
    year
  ) |>
  ungroup() |>
  left_join(
    wwbi,
    by = c("country_code", "year")
  ) |>
  ggplot(
    aes(ps_wage_premium_pooled, total_headcount_growth)
  ) +
  geom_point() +
  labs(
    x = "Public Sector Wage Premium",
    y = "Growth in headcount"
  )

# 4.3.6. Skills shortages in the private sector (from firm surveys)
enterprise_surveys |>
  filter(country_code == "BRA")
