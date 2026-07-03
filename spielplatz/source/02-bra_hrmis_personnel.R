# set-up ------------------------------------------------------------------
library(dplyr)
library(readxl)
library(purrr)
library(janitor)
library(lubridate)
library(furrr)
library(pointblank)
library(tibble)
library(here)
library(readr)
library(ggplot2)
library(data.table)
library(here)

devtools::load_all()
set.seed(1789)

# read-in data ------------------------------------------------------------
file_path <- "//egvpi/egvpi/data/harmonization/HRM/BRA/data-raw/6. Wage Bill AL/3. Microdados"

plan(multisession, workers = 3)

personnel_active_list <-
  list.files(
    path = file_path,
    pattern = "^Ativos_[0-9]{4}\\.xlsx$",
    full.names = T
  ) |>
  future_map(
    \(file) read_xlsx(
      file, na = c("", "-"), col_types = "text"
    ) |>
      clean_names()
  )

personnel_inactive_list <-
  list.files(
    path = file_path,
    pattern = "^Inativos_[0-9]{4}\\.xlsx$",
    full.names = T
  ) |>
  map(
    \(file) read_xlsx(
      file, na = c("", "-"), col_types = "text"
    ) |>
      clean_names()
  )

future::plan(sequential)

# harmonization -----------------------------------------------------------
# what we want is two things: (1) uniqueness in the cross-section (entities are uniquely identified) and
# (2) consistency (those unique ids refer to the same entities across the panel)

inactive_inconsistent_cols <- personnel_inactive_list |>
  find_inconsistent_colnames() |>
  pull(colnames)

# identify if a dataset contains inconsistent colnames
personnel_inactive_list |>
  keep(
    ~ detect_inconsistent_cols(.x, inactive_inconsistent_cols)
  )

# harmonize column names
dictionary_personnel <- tibble(
  from = c(
    "ano_pagamento", "orgao", "mes_referencia", "matricula", "cpf", "data_nascimento", "genero", "escolaridade"
  ),
  to = c(
    "year", "department", "month", "contract_id", "personnel_id", "birth_date", "gender", "education"
  )
)

personnel_active <- personnel_active_list |>
  map(
    \(data){
      data |>
        harmonize_columns(dictionary_personnel)
    }
  ) |>
  bind_rows() |>
  # extract the month of september
  filter(month == 9) |>
  mutate(
    employment_status = "active"
  )

personnel_inactive <- personnel_inactive_list |>
  map(
    \(data){
      data |>
        harmonize_columns(dictionary_personnel)
    }
  ) |>
  bind_rows() |>
  # extract the month of september
  filter(month == 9) |>
  mutate(
    employment_status = "inactive"
  )

personnel_df <- personnel_active |>
  bind_rows(
    personnel_inactive
  )

# we need to create quality-checks that are specific to each standardized column
# does it match our expectations
personnel_df <- personnel_df |>
  mutate(
    birth_date = as_date(
      as.numeric(birth_date), origin = "1899-12-30"
    ),
    ref_date = ymd(
      paste(year, month, "01", sep = "-")
    ),
    age = interval(
      birth_date, ref_date
    ) |>
      as.numeric("years") |>
      floor(),
    educat7 = case_when(
      education == "ANALFABETO" ~ "No education",
      education %in% c(
        "1 A 4 SERIE DO PRIM. GRAU INCOMPLETO",
        "5 A 8 SERIE DO PRIM. GRAU INCOMPLETO"
      ) ~ "Primary incomplete",
      education %in% c(
        "1 A 4 SERIE DO PRIM. GRAU COMPLETO",
        "5 A 8 SERIE DO PRIM. GRAU COMPLETO"
      ) ~ "Primary complete",
      education == "SEGUNDO GRAU INCOMPLETO" ~ "Secondary incomplete",
      education == "SEGUNDO GRAU COMPLETO" ~ "Secondary complete",
      education %in% c(
        "ESPECIALIZAÇÃO COMPLETO",
        "ESPECIALIZAÇÃO INCOMPLETO",
        "ESPECIALIZA«√O COMPLETO",
        "ESPECIALIZA«√O INCOMPLETO"
      ) ~ "Higher than secondary but not university",
      education %in% c(
        "CURSO SUPERIOR COMPLETO",
        "CURSO SUPERIOR INCOMPLETO",
        "MESTRADO INCOMPLETO"
      ) ~ "University incomplete or complete",
      education == "NA" ~ NA_character_,
      TRUE ~ NA_character_
    )
  )

# check age
personnel_df <- personnel_df |>
  mutate(
    age = if_else(
      age <= 17 & is.na(educat7),
      NA_real_,
      age
    )
  )

# check for uniqueness per year
personnel_quality_check <- create_agent(tbl = personnel_df) |>
  rows_distinct(
    columns = personnel_id,
    segments = vars(year),
    step_id = "check_unique_personnel_id",
    label = "Check for uniqueness of personnel_df ID per year"
  ) |>
  rows_distinct(
    columns = personnel_id,
    preconditions = . %>% distinct(contract_id, personnel_id),
    step_id = "check_unique_personnel_and_personnel_id",
    label = "Check for uniqueness of personnel_df ID and national ID combinations"
  )

personnel_quality_check |>
  interrogate()

# deduplicate -------------------------------------------------------------
# matricula is the contract ID
personnel_id <- personnel_df |>
  distinct(
    contract_id,
    personnel_id
  )

personnel_id_multiple_contracts <- personnel_id |>
  group_by(personnel_id) |>
  summarise(
    n_contract = n_distinct(contract_id),
    .groups = "drop"
  ) |>
  filter(n_contract > 1)

personnel_inconsistency_df <- personnel_df |>
  as.data.table() %>%
  .[
    ,
    lapply(.SD, uniqueN),
    .SDcols = c("birth_date", "educat7"),
    by = c("personnel_id", "ref_date")
  ]

# we identify that there are a few inconsistencies in birth dates
# such as the same personnel having different birth dates
# and the same personnel having two different educational levels
# in the same reference date
personnel_birthdate_inconsistency_df <- personnel_df |>
  as.data.table() %>%
  .[
    ,
    lapply(.SD, uniqueN),
    .SDcols = c("birth_date"),
    by = c("personnel_id")
  ]

### birth_date needs to be one for each person and has to be the same across all
### periods for that person. Lets fix that! 

birth_df <- 
  personnel_df |> 
  dplyr::select(personnel_id, birth_date) |>
  distinct()

birth_df <- 
  birth_df |>
  group_by(personnel_id) |>
  filter(birth_date == max(birth_date)) 

#### lets quickly look at the distribution of ages by the latest reference date within the public sector
birth_df <- 
birth_df |>
  mutate(age = as.numeric(as.Date("2018-09-01") - birth_date) / 365.25) 

### ok we are going to drop reassign birth days to all those who are below 18 and those who are above 100
## starting with all those under 18


# birth_df |>
#   filter(age > 0 & age < 100) |>
#   ggplot(aes(x = age)) + 
#   geom_histogram(binwidth = 1) + 
#   labs(x = "Age", y = "Personnel Count")

set.seed(1234)

ref_date <- min(personnel_df$ref_date, na.rm = TRUE)

birth_df_fixed <-
  birth_df |>
  left_join(
    personnel_df |>
      distinct(personnel_id, employment_status),
    by = "personnel_id"
  ) |>
  mutate(
    age = as.numeric(ref_date - birth_date) / 365.25,
    replacement_age = age
  )

# Under 18, active -> random age 18-65
idx <- birth_df_fixed$age < 18 &
  birth_df_fixed$employment_status == "active"

birth_df_fixed$replacement_age[idx] <-
  sample(18:65, sum(idx), replace = TRUE)

# Under 18, inactive -> random age 65-90
idx <- birth_df_fixed$age < 18 &
  birth_df_fixed$employment_status == "inactive"

birth_df_fixed$replacement_age[idx] <-
  sample(65:90, sum(idx), replace = TRUE)

# Under 18, other status -> random age 18-65
idx <- birth_df_fixed$age < 18 &
  !birth_df_fixed$employment_status %in% c("active", "inactive")

birth_df_fixed$replacement_age[idx] <-
  sample(18:65, sum(idx), replace = TRUE)

# 100+, active -> random age 18-65
idx <- birth_df_fixed$age >= 100 &
  birth_df_fixed$employment_status == "active"

birth_df_fixed$replacement_age[idx] <-
  sample(18:65, sum(idx), replace = TRUE)

# 100+, inactive -> random age 65-90
idx <- birth_df_fixed$age >= 100 &
  birth_df_fixed$employment_status == "inactive"

birth_df_fixed$replacement_age[idx] <-
  sample(65:90, sum(idx), replace = TRUE)

# 100+, other status -> random age 18-65
idx <- birth_df_fixed$age >= 100 &
  !birth_df_fixed$employment_status %in% c("active", "inactive")

birth_df_fixed$replacement_age[idx] <-
  sample(18:65, sum(idx), replace = TRUE)

# Convert replacement ages back to birth dates
birth_df_fixed <-
  birth_df_fixed |>
  mutate(
    # Random day within the assigned age year
    day_offset = sample(0:364, n(), replace = TRUE),

    birth_date = if_else(
      age < 18 | age >= 100,
      ref_date - round(replacement_age * 365.25) - day_offset,
      birth_date
    )
  ) |>
  select(-age, -replacement_age, -day_offset)

birth_df_fixed <- 
  birth_df_fixed |>
  mutate(age = as.numeric(as.Date("2018-09-01") - birth_date) / 365.25)

birth_df_fixed |>
  filter(age > 0 & age < 100) |>
  ggplot(aes(x = age)) + 
  geom_histogram(binwidth = 1) + 
  labs(x = "Age", y = "Personnel Count")


# establish protocol that if there are inconsistencies,
# we use the highest frequency value to override the inconsistencies
# fix birthdate
# personnel_df <- personnel_df |>
#   mutate(
#     birth_date =
#   )

birth_df_fixed <- 
  birth_df_fixed |>
  select(-employment_status, -age) |> 
  distinct() |>
  group_by(personnel_id) |>
  filter(birth_date == min(birth_date))

### ok lets merge this back in
personnel_df <- 
  personnel_df |>
  select(-birth_date, -age) |>
  left_join(birth_df_fixed |> select(personnel_id, birth_date), 
            by = "personnel_id") |>
  mutate(age = difftime(ref_date, birth_date) / 365.25)

### include service type
personnel_df <-
  personnel_df |>
  mutate(
    service_type = case_when(
      department %in% c(
        "CORPO DE BOMBEIROS MILITAR DE ALAGOAS",
        "POLICIA MILITAR DE ALAGOAS",
        "GABINETE MILITAR DO GOVERNO"
      ) ~ "military",

      TRUE ~ "civilian"
    )
  )


personnel_df <-
  personnel_df |>
  arrange(personnel_id, ref_date) |>
  group_by(personnel_id, ref_date) |>
  slice(1) |>
  ungroup() |>
  select(
    personnel_id,
    ref_date,
    birth_date,
    age,
    gender,
    educat7,
    employment_status,
    service_type,
  )

personnel_df$race <- NA
personnel_df$tribe <- NA
# extract personnel_df module ---------------------------------------------------
# personnel_df
#   - Reference date (ref_date)
#   - personnel_df ID (contract_id)
#   - Date of Birth (birth_date)
#   - Gender (gender): standardize to english
#   - Education Attainment (educat7)
#   - Tribe (tribe)
#   - Race (race)
#   - Status (active/retired)

# # create a function that does a conformity assessment
# # and fill out missing columns with NA
# dictionary_personnel_cols <- c(
#   "ref_date", "personnel_id", "birth_date", "gender", "educat7", "tribe", "race", "status"
# )

# personnel_module_clean <- personnel_module |>
#   complete_columns(
#     dictionary_personnel_cols
#   ) |>
#   mutate(
#     country_code = "BRA"
#   )

## the age variable needs to be a numeric and not a difftime object
personnel_df <- personnel_df |> mutate(age = as.numeric(age))

# personnel_module_clean |>
arrow::write_parquet(personnel_df, 
                     "spielplatz/data/personnel_alagoas_tbl.parquet", 
                     compression = "zstd", 
                     compression_level = 22)
