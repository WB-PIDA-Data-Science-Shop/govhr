# set-up ------------------------------------------------------------------
library(readr)
library(dplyr)
library(lubridate)
library(stringr)
library(tidyr)
library(here)

devtools::load_all()

dir.create(
  here("inst", "extdata"),
  recursive = TRUE
)

# read-in data ------------------------------------------------------------
contract_df <- read_rds(
  here("spielplatz", "data", "bra_hrmis_contract.rds")
)

personnel_df <- read_rds(
  here("spielplatz", "data", "bra_hrmis_personnel.rds")
)

# infer movement ----------------------------------------------------------
# the movement table should have:
# 1) contract_id
# 2) ref_date
# 3) event type: hire, dismissal, retirement, reallocation.

# 1. infer hire
# a hire is defined as a new contract when the personnel_df
# was not present in the dataset in the previous period
personnel_hire_df <- personnel_df |>
  detect_personnel_event(
    id_col = "personnel_id",
    event_type = "hire",
    start_date = "2007-09-01",
    end_date = "2018-09-01"
  )

# 2. infer fire
personnel_fire_df <- personnel_df |>
  detect_personnel_event(
    id_col = "personnel_id",
    event_type = "fire",
    start_date = "2007-09-01",
    end_date = "2018-09-01"
  )

# 3. infer retirement
# if the personnel_df appears as retired in the next ref_date, this is a retirement
personnel_retired_df <- personnel_df |>
  detect_retirement()

# 4. infer movement
# rename orgao id
contract_rename_est_df <- contract_df |>
  inner_join(
    personnel_df |> filter(status == "active"),
    by = c("personnel_id", "ref_date"),
    relationship = "many-to-many"
  ) |>
  mutate(
    est_id = str_remove_all(est_id, "\\d+|-")
  )

personnel_reallocation_df <- contract_rename_est_df |>
  detect_reallocation(
    personnel_hire = personnel_hire_df
  )

# join all
personnel_movement_df <- list(
  personnel_hire_df,
  personnel_fire_df,
  personnel_retired_df,
  personnel_reallocation_df
) |>
  reduce(
    bind_rows
  )

# write-out ---------------------------------------------------------------
personnel_movement_df |>
  write_rds(
    here("spielplatz", "data", "personnel_movement.rds")
  )

