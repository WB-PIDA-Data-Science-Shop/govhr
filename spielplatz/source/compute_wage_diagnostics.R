################################################################################
################### QUICKLY COMPUTE WAGE BILL DIAGNOSTICS ######################
################################################################################
library(dplyr)
library(ggplot2)

### first let us read in the harmonized data
contract_df <- readRDS("spielplatz/bra_hrmis_contract.rds")
personnel_df <- readRDS("spielplatz/bra_hrmis_personnel.rds")
est_df <- readRDS("spielplatz/bra_hrmis_establishment.rds")

### wage bill planning

#3.1.1  wage bill as a share of GDP, expenditures and revenues

## preparing the required data

totwage_df <-
  contract_df |>
  group_by(year) |>
  summarise(base_salary_lcu = sum(base_salary_lcu, na.rm = T),
            gross_salary_lcu = sum(gross_salary_lcu, na.rm = T),
            net_salary_lcu = sum(net_salary_lcu, na.rm = T)) |>
  mutate(year = as.integer(year))

econwide_df <-
  macro_indicators |>
  filter(country_code == "BRA" &
           year >= min(totwage_df[["year"]]) &
                 year <= max(totwage_df[["year"]]))


### let compute all at once
wage_vars <- c("base_salary_lcu", "gross_salary_lcu", "net_salary_lcu")
econ_vars <- c("gdp_lcu", "pexpenditure_lcu", "taxrevenue_lcu", "prevenue_lcu")

### lets create a tbl recipe of sorts using expand.grid
map_tbl <-
  expand.grid(wage_vars, econ_vars, stringsAsFactors = FALSE) |>
  setNames(c("wage_vars", "econ_vars")) |>
  mutate(
    wage_vars = as.character(wage_vars),
    econ_vars = as.character(econ_vars),
    new_var   = paste0(wage_vars, "_per_", econ_vars)
  )

wagebillstats_df <-
totwage_df |>
  merge(
    econwide_df |> dplyr::select(-country_code),
    by = "year",
    all = TRUE
  ) |>
  as_tibble() |>
  (\(.df)
   bind_cols(
     .df,
     pmap_dfc(map_tbl, function(wage_vars, econ_vars, new_var) {
       tibble(!!new_var := .df[[wage_vars]] / .df[[econ_vars]])
     })
   )
  )() |>
  dplyr::select(year, all_of(map_tbl[["new_var"]]))

# lets pivot long
longwagebillstats_df <-
  wagebillstats_df |>
  pivot_longer(
    cols = -year,
    names_to = c("wage_type", "denominator"),
    names_pattern = "(.*)_per_(.*)",
    values_to = "rate"
  ) |>
  mutate(denominator = case_when(
    denominator == "gdp_lcu" ~ "GDP",
    denominator == "pexpenditure_lcu" ~ "Government Expenditure",
    denominator == "taxrevenue_lcu" ~ "Government Tax Revenue",
    denominator == "prevenue_lcu" ~ "Total Government Revenue",
    TRUE ~ denominator
  ),
  wage_type = case_when(
    wage_type == "base_salary_lcu" ~ "Base Salary",
    wage_type == "gross_salary_lcu" ~ "Gross Salary",
    wage_type == "net_salary_lcu" ~ "Net Salary",
    TRUE ~ wage_type
  ))

# Plot

longwagebillstats_df |>
  filter(year != 2018) |>
  mutate(year = as.integer(year)) |>   # <- convert to integer
  ggplot(aes(x = year, y = rate, color = wage_type)) +
  geom_line(size = 1.2) +
  geom_point(size = 2) +
  facet_wrap(~denominator, scales = "free_y") +
  scale_x_continuous(breaks = unique(longwagebillstats_df$year)) +
  scale_y_continuous(labels = scales::percent_format(accuracy = 0.01)) +
  labs(
    title = "Brazil Wage Bill Rates over Time",
    subtitle = "Base, Gross, and Net Salaries relative to GDP, Expenditure, and Revenue",
    x = "Year",
    y = "Ratio",
    color = "Wage Type"
  ) +
  theme_minimal(base_size = 14) +
  theme(
    legend.position = "bottom",
    strip.text = element_text(face = "bold"),
    axis.text.x = element_text(angle = 45, hjust = 1)
  )





