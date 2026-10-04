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

# a person can hold contracts in several establishments at once, so combine
# them into one label per person and date (e.g. "AL + SEDUC"). a reallocation
# is then any change in that set of establishments
personnel_est_df <- contract_rename_est_df |>
  distinct(personnel_id, ref_date, est_id) |>
  summarise(
    est_set = paste(sort(est_id), collapse = " + "),
    .by = c(personnel_id, ref_date)
  )

# compute_transition() dates each move to the first period in the new set of
# establishments, so a person's first observation is never a reallocation.
# moves on a hire date are re-entries after a gap, already counted as hires
personnel_reallocation_df <- personnel_est_df |>
  compute_transition(
    id_col = "personnel_id",
    group_cols = "est_set"
  ) |>
  anti_join(
    personnel_hire_df |> distinct(personnel_id, ref_date),
    by = c("personnel_id", "ref_date")
  ) |>
  mutate(
    type_event = "reallocation"
  ) |>
  select(
    personnel_id, ref_date, type_event
  )

# join all
personnel_movement_df <- bind_rows(
  personnel_hire_df,
  personnel_fire_df,
  personnel_retired_df,
  personnel_reallocation_df
)

# write-out ---------------------------------------------------------------
personnel_movement_df |>
  write_rds(
    here("spielplatz", "data", "personnel_movement.rds")
  )

