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
    status = "active"
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
    status = "inactive"
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
    ),
    educat7 = factor(
      educat7,
      levels = c(
        "No education", "Primary incomplete", "Primary complete",
        "Secondary incomplete", "Secondary complete",
        "Higher than secondary but not university",
        "University incomplete or complete"
      ),
      ordered = TRUE
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

# establish protocol that if there are inconsistencies,
# we use the highest frequency value to override the inconsistencies
# fix birthdate
# personnel_df <- personnel_df |>
#   mutate(
#     birth_date =
#   )

# only one personnel per reference date per status
personnel_module <- personnel_df |>
  distinct(
    personnel_id,
    ref_date,
    status,
    gender,
    educat7
  )

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

# create a function that does a conformity assessment
# and fill out missing columns with NA
dictionary_personnel_cols <- c(
  "ref_date", "personnel_id", "birth_date", "gender", "educat7", "tribe", "race", "status"
)

personnel_module_clean <- personnel_module |>
  complete_columns(
    dictionary_personnel_cols
  ) |>
  mutate(
    country_code = "BRA"
  )

# personnel_module_clean |>
#   write_rds(
#     here("spielplatz", "data", "bra_hrmis_personnel.rds"),
#     compress = "gz"
#   )

# personnel_module_clean |>
#   qs::qsave("spielplatz/data/personnel_alagoas_tbl.qs", preset = "high")

arrow::write_parquet(personnel_module_clean, 
                     "spielplatz/data/personnel_alagoas_tbl.parquet", 
                     compression = "zstd", 
                     compression_level = 22)
