# Tests for Data Quality Treatment Functions
# Covers: duplicates, dates, ages, hours, salaries, master function, integration

library(testthat)
library(dplyr)

# ==============================================================================
# 1. DUPLICATES
# ==============================================================================

test_that("remove_duplicate_personnel handles all keep strategies", {
  data <- data.frame(
    personnel_id = c("P001", "P001", "P002", "P003", "P003", "P003"),
    ref_date = as.Date(rep("2023-01-01", 6)),
    value = 1:6
  )
  
  # Keep first
  result <- remove_duplicate_personnel(data, keep = "first")
  expect_equal(nrow(result), 3)
  expect_equal(result$value, c(1, 3, 4))
  
  # Keep last
  result <- remove_duplicate_personnel(data, keep = "last")
  expect_equal(result$value, c(2, 3, 6))
  
  # Keep none
  result <- remove_duplicate_personnel(data, keep = "none")
  expect_equal(nrow(result), 1)
  expect_equal(result$personnel_id, "P002")
  
  # Edge case: empty data
  empty <- data.frame(personnel_id = character(), ref_date = as.Date(character()))
  expect_equal(nrow(remove_duplicate_personnel(empty)), 0)
})

test_that("remove_duplicate_contracts handles both levels", {
  data <- data.frame(
    contract_id = c("C001", "C001", "C002", "C002"),
    personnel_id = c("P001", "P002", "P001", "P001"),
    ref_date = as.Date(rep("2023-01-01", 4))
  )
  
  # Contract level
  result <- remove_duplicate_contracts(data, level = "contract", keep = "first")
  expect_equal(nrow(result), 2)
  
  # Assignment level
  result <- remove_duplicate_contracts(data, level = "assignment", keep = "first")
  expect_equal(nrow(result), 3)
})

# ==============================================================================
# 2. DATES
# ==============================================================================

test_that("fix_invalid_dates handles all treatments", {
  data <- data.frame(
    ref_date = as.Date(c("1800-01-01", "2000-01-01", "2100-01-01", NA))
  )
  min_d <- as.Date("1900-01-01")
  max_d <- as.Date("2025-01-01")
  
  # NA treatment
  result <- fix_invalid_dates(data, min_date = min_d, max_date = max_d, treatment = "na")
  expect_true(is.na(result$ref_date[1]))
  expect_false(is.na(result$ref_date[2]))
  expect_true(is.na(result$ref_date[3]))
  
  # Clamp treatment
  result <- fix_invalid_dates(data, min_date = min_d, max_date = max_d, treatment = "clamp")
  expect_equal(result$ref_date[1], min_d)
  expect_equal(result$ref_date[3], max_d)
  
  # Filter treatment
  result <- fix_invalid_dates(data, min_date = min_d, max_date = max_d, treatment = "filter")
  expect_equal(nrow(result), 1)
  
  # Boundaries
  boundary <- data.frame(ref_date = c(min_d, max_d, min_d - 1, max_d + 1))
  result <- fix_invalid_dates(boundary, min_date = min_d, max_date = max_d, treatment = "na")
  expect_false(is.na(result$ref_date[1]))  # At min is valid
  expect_false(is.na(result$ref_date[2]))  # At max is valid
  expect_true(is.na(result$ref_date[3]))   # Before min is invalid
  expect_true(is.na(result$ref_date[4]))   # After max is invalid
})

test_that("fix_invalid_birthdates works", {
  data <- data.frame(
    birth_date = as.Date(c("1900-01-01", "2000-01-01", "2100-01-01"))
  )
  
  result <- fix_invalid_birthdates(data, treatment = "na")
  expect_true(is.na(result$birth_date[1]))
  expect_false(is.na(result$birth_date[2]))
  
  result <- fix_invalid_birthdates(data, treatment = "filter")
  expect_equal(nrow(result), 1)
})

# ==============================================================================
# 3. AGES
# ==============================================================================

test_that("fix_underage_workers handles all cases", {
  data <- data.frame(
    personnel_id = c("P001", "P002", "P003"),
    birth_date = as.Date(c("2010-01-01", "2000-01-01", "2004-12-31")),
    ref_date = as.Date(rep("2023-06-01", 3)),
    status = rep("active", 3)
  )
  
  # Flag treatment
  result <- fix_underage_workers(data, min_age = 18, treatment = "flag")
  expect_true(result$underage_flag[1])   # 13 years old
  expect_false(result$underage_flag[2])  # 23 years old
  expect_false(result$underage_flag[3])  # Over 18
  
  # Filter treatment
  result <- fix_underage_workers(data, min_age = 18, treatment = "filter")
  expect_equal(nrow(result), 2)
  
  # NA handling
  na_data <- data.frame(
    birth_date = as.Date(NA),
    ref_date = as.Date("2023-01-01"),
    employment_status = "active"
  )
  result <- fix_underage_workers(na_data, treatment = "flag")
  expect_false(result$underage_flag[1])
})

test_that("fix_retirement_age works", {
  data <- data.frame(
    birth_date = as.Date(c("1950-01-01", "1960-01-01", "1970-01-01")),
    ref_date = as.Date(rep("2023-01-01", 3)),
    employment_status = c("active", "active", "retired")
  )
  
  # Flag treatment
  result <- fix_retirement_age(data, max_age = 65, treatment = "flag")
  expect_true(result$over_retirement_flag[1])   # 73, active
  expect_false(result$over_retirement_flag[2])  # 63, active
  expect_false(result$over_retirement_flag[3])  # 53, retired (not flagged)
  
  # Adjust status treatment
  result <- fix_retirement_age(data, max_age = 65, treatment = "adjust_status")
  expect_equal(result$status[1], "retired")
  expect_equal(result$status[2], "active")
})

# ==============================================================================
# 4. HOURS
# ==============================================================================

test_that("fix_working_hours handles all treatments", {
  data <- data.frame(whours = c(-10, 40, 200, NA))
  
  # NA treatment
  result <- fix_working_hours(data, treatment = "na")
  expect_true(is.na(result$whours[1]))
  expect_equal(result$whours[2], 40)
  expect_true(is.na(result$whours[3]))
  
  # Clamp treatment
  result <- fix_working_hours(data, treatment = "clamp")
  expect_equal(result$whours[1], 0)
  expect_equal(result$whours[3], 40)
  
  # Flag treatment
  result <- fix_working_hours(data, treatment = "flag")
  expect_true(result$invalid_hours_flag[1])
  expect_false(result$invalid_hours_flag[2])
  expect_true(result$invalid_hours_flag[4])  # NA is flagged
  
  # Boundaries
  boundary <- data.frame(whours = c(0, 40, -0.1, 40.1))
  result <- fix_working_hours(boundary, treatment = "flag")
  expect_false(result$invalid_hours_flag[1])  # 0 is valid
  expect_false(result$invalid_hours_flag[2])  # 40 is valid
  expect_true(result$invalid_hours_flag[3])   # < 0 is invalid
  expect_true(result$invalid_hours_flag[4])   # > 40 is invalid
})

# ==============================================================================
# 5. SALARIES
# ==============================================================================

test_that("fix_salary_components handles all strategies", {
  # Recalculate gross
  data <- data.frame(
    gross_salary_lcu = c(1000, 2000),
    base_salary_lcu = c(800, 1500),
    allowance_lcu = c(100, NA),
    net_salary_lcu = c(900, 1800)
  )
  result <- fix_salary_components(data, strategy = "recalculate_gross")
  expect_equal(result$gross_salary_lcu[1], 900)
  expect_equal(result$gross_salary_lcu[2], 1500)
  
  # Cap strategies
  data <- data.frame(
    gross_salary_lcu = c(1000, 1000),
    base_salary_lcu = c(1200, 800),
    net_salary_lcu = c(900, 1100),
    allowance_lcu = c(0, 0)
  )
  expect_equal(fix_salary_components(data, strategy = "cap_base")$base_salary_lcu[1], 1000)
  expect_equal(fix_salary_components(data, strategy = "cap_net")$net_salary_lcu[2], 1000)
  
  # Flag strategy
  data <- data.frame(
    gross_salary_lcu = c(1000, 1000, 1000),
    base_salary_lcu = c(600, 1200, 800),
    net_salary_lcu = c(900, 900, 1100),
    allowance_lcu = c(500, 0, 0)
  )
  result <- fix_salary_components(data, strategy = "flag")
  expect_true(result$gross_composition_flag[1])   # 1000 < 1100
  expect_true(result$base_exceeds_gross_flag[2])  # 1200 > 1000
  expect_true(result$net_exceeds_gross_flag[3])   # 1100 > 1000
})

test_that("fix_negative_salaries works", {
  data <- data.frame(
    gross_salary_lcu = c(-1000, 1000, 0),
    base_salary_lcu = c(500, -500, 0),
    net_salary_lcu = c(900, 900, 0)
  )
  
  # NA treatment
  result <- fix_negative_salaries(data, treatment = "na")
  expect_true(is.na(result$gross_salary_lcu[1]))
  expect_true(is.na(result$base_salary_lcu[2]))
  
  # Abs treatment
  result <- fix_negative_salaries(data, treatment = "abs")
  expect_equal(result$gross_salary_lcu[1], 1000)
  expect_equal(result$base_salary_lcu[2], 500)
  
  # Zero treatment
  result <- fix_negative_salaries(data, treatment = "zero")
  expect_equal(result$gross_salary_lcu[1], 0)
  expect_equal(result$base_salary_lcu[2], 0)
  
  # Column-specific
  result <- fix_negative_salaries(data, columns = "gross_salary_lcu", treatment = "abs")
  expect_equal(result$gross_salary_lcu[1], 1000)
  expect_equal(result$base_salary_lcu[2], -500)  # Unchanged
})

# ==============================================================================
# 6. MASTER FUNCTION
# ==============================================================================

test_that("clean_hr_data works for personnel", {
  data <- data.frame(
    personnel_id = c("P001", "P001", "P002"),
    ref_date = as.Date(c("2023-01-01", "2023-01-01", "2100-01-01")),
    birth_date = as.Date(c("2010-01-01", "2010-01-01", "1990-01-01")),
    employment_status = rep("active", 3)
  )
  
  result <- clean_hr_data(data, data_type = "personnel")
  expect_equal(nrow(result), 2)  # Duplicate removed
  expect_true(is.na(result$ref_date[result$personnel_id == "P002"]))
  expect_true("underage_flag" %in% names(result))
})

test_that("clean_hr_data works for contracts", {
  data <- data.frame(
    contract_id = c("C001", "C001", "C002"),
    personnel_id = c("P001", "P001", "P002"),
    ref_date = as.Date(rep("2023-01-01", 3)),
    whours = c(-10, 40, 200),
    gross_salary_lcu = c(1000, 1000, 1000),
    base_salary_lcu = c(-800, 800, 800),
    net_salary_lcu = c(900, 900, 900),
    allowance_lcu = c(100, 100, 100)
  )
  
  result <- clean_hr_data(data, data_type = "contract")
  expect_equal(nrow(result), 2)
  expect_true(all(result$base_salary_lcu >= 0))
  expect_true(all(result$whours >= 0 & result$whours <= 168))
})

test_that("clean_hr_data respects flags", {
  data <- data.frame(
    personnel_id = c("P001", "P001"),
    ref_date = as.Date(c("2023-01-01", "2023-01-01")),
    birth_date = as.Date(c("1990-01-01", "1990-01-01")),
    status = c("active", "active")
  )
  
  result <- clean_hr_data(data, data_type = "personnel", 
                         remove_duplicates = FALSE, fix_dates = FALSE, fix_ages = FALSE)
  expect_equal(nrow(result), nrow(data))
})

# ==============================================================================
# 7. INTEGRATION
# ==============================================================================

test_that("functions work in pipeline", {
  data <- data.frame(
    contract_id = c("C001", "C001", "C002"),
    personnel_id = c("P001", "P001", "P002"),
    ref_date = as.Date(c("2023-01-01", "2023-01-01", "2100-01-01")),
    whours = c(40, 40, -10),
    gross_salary_lcu = c(1000, 1000, 1000),
    base_salary_lcu = c(800, 800, -800),
    net_salary_lcu = c(900, 900, 900),
    allowance_lcu = c(100, 100, 100)
  )
  
  result <- data |>
    remove_duplicate_contracts(level = "contract", keep = "first") |>
    fix_invalid_dates(treatment = "na") |>
    fix_working_hours(treatment = "clamp") |>
    fix_negative_salaries(treatment = "abs")
  
  expect_equal(nrow(result), 2)
  expect_true(all(result$whours >= 0 & result$whours <= 168))
  expect_true(all(result$base_salary_lcu >= 0))
})

test_that("filter treatment removes records", {
  data <- data.frame(
    contract_id = c("C001", "C002", "C003"),
    ref_date = as.Date(c("1800-01-01", "2023-01-01", "2100-01-01"))
  )
  
  result <- fix_invalid_dates(data, treatment = "filter")
  expect_equal(nrow(result), 1)
  expect_equal(result$contract_id, "C002")
})

test_that("functions preserve column order", {
  data <- data.frame(
    col_a = 1:3,
    personnel_id = c("P001", "P002", "P003"),
    col_b = letters[1:3],
    ref_date = as.Date(rep("2023-01-01", 3)),
    employment_status = c("active", "active", "retired")
  )
  result <- remove_duplicate_personnel(data)
  expect_equal(names(result), names(data))
})