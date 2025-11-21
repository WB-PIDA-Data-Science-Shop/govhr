library(dplyr)
library(tidyr)
library(readr)
library(stringr)
library(lubridate)

# Set seed for reproducibility
set.seed(123)

# Number of records to generate
n <- 1000

# Generate synthetic HRMIS data
generate_hrmis_data <- function(n) {

  # Define reference dates (5 time periods)
  ref_dates <- as.Date(c("2020-01-01", "2021-01-01", "2022-01-01",
                         "2023-01-01", "2024-01-01"))

  # Countries and admin levels
  countries <- c("Country_A", "Country_B", "Country_C", "Country_D", "Country_E")

  # Occupations
  occupations <- c(
    "Manager", "Analyst", "Specialist", "Officer", "Coordinator",
    "Assistant", "Consultant", "Director", "Technician", "Administrator"
  )

  # Contract types
  contract_types <- c("Regular", "Fixed-term", "Temporary", "Consultant", "Intern")

  # Pay grades
  pay_grades <- paste0("Grade_", 1:10)

  # Seniority levels
  seniority_levels <- c("Junior", "Mid-level", "Senior", "Lead", "Executive")

  # Calculate records per reference date
  records_per_date <- round(n / length(ref_dates))

  # Generate base personnel pool (people who could appear in multiple periods)
  n_personnels <- round(n * 0.6)  # 60% of records are from a stable personnel pool
  personnel_pool <- paste0("W", sprintf("%06d", 1:n_personnels))

  # Initialize empty dataframe
  all_data <- tibble()

  # Generate data for each reference date
  for (i in seq_along(ref_dates)) {
    current_ref_date <- ref_dates[i]
    n_records <- records_per_date

    # Determine personnel composition for this period
    if (i == 1) {
      # First period: all new hires
      personnels <- sample(personnel_pool, n_records, replace = FALSE)
      start_dates <- current_ref_date - days(sample(0:365, n_records, replace = TRUE))
    } else {
      # Subsequent periods: mix of retained, new hires, and churned
      prev_data <- all_data %>%
        filter(ref_date == ref_dates[i-1])

      # Retention rate: 70-80% of previous period personnels are retained
      retention_rate <- runif(1, 0.70, 0.80)
      n_retained <- round(nrow(prev_data) * retention_rate)

      # Get personnels from previous period who are still active
      prev_active_personnels <- prev_data %>%
        filter(is.na(end_date) | end_date >= current_ref_date) %>%
        pull(personnel_id)

      # Retained personnels (from previous active personnels)
      retained_personnels <- sample(prev_active_personnels,
                                 min(n_retained, length(prev_active_personnels)),
                                 replace = FALSE)

      # New hires to fill remaining slots
      n_new_hires <- n_records - length(retained_personnels)
      available_personnels <- setdiff(personnel_pool, retained_personnels)
      new_hire_personnels <- sample(available_personnels, n_new_hires, replace = FALSE)

      personnels <- c(retained_personnels, new_hire_personnels)

      # Start dates: retained personnels keep their original start date, new hires get recent dates
      start_dates <- c(
        # Retained personnels: get their original start date from previous period
        sapply(retained_personnels, function(w) {
          prev_start <- prev_data %>%
            filter(personnel_id == w) %>%
            pull(start_date) %>%
            first()
          if(length(prev_start) == 0 || is.na(prev_start)) {
            current_ref_date - days(sample(365:730, 1))
          } else {
            prev_start
          }
        }),
        # New hires: started within last year
        current_ref_date - days(sample(0:365, n_new_hires, replace = TRUE))
      )
    }

    # Generate data for this period
    period_data <- tibble(
      # IDs
      contract_id = paste0("C", sprintf("%06d", (i-1)*records_per_date + 1:n_records)),
      personnel_id = personnels,
      est_id = paste0("ORG", sprintf("%03d", sample(1:50, n_records, replace = TRUE))),

      # Reference date (same for all records in this period)
      ref_date = current_ref_date,
      start_date = as.Date(start_dates),
      end_date = as.Date(NA)
    ) %>%
      mutate(
        # Determine who gets terminated/leaves before next period
        # 20-30% of personnels will have left by the next period
        churn_rate = if_else(i < length(ref_dates),
                             runif(1, 0.20, 0.30),
                             0.15),  # Lower churn in last period
        churn_this_period = runif(n()) < churn_rate,

        # For churned personnels, set end date between this ref_date and next ref_date
        end_date = if_else(
          churn_this_period & i < length(ref_dates),
          start_date + days(sample(30:365, n(), replace = TRUE)),
          as.Date(NA)
        ),

        # Ensure end date doesn't exceed next ref_date (if there is one)
        end_date = if_else(
          !is.na(end_date) & i < length(ref_dates) & end_date > ref_dates[i+1],
          ref_dates[i+1] - days(sample(1:30, n(), replace = TRUE)),
          end_date
        ),

        # Salary information (base in local currency)
        # Retained personnels might get raises
        base_salary = if_else(
          personnel_id %in% retained_personnels & i > 1,
          round(rnorm(n(), mean = 55000, sd = 22000), 2),  # Slightly higher for retained
          round(rnorm(n(), mean = 50000, sd = 20000), 2)
        ),
        gross_salary = round(base_salary * runif(n(), 1.1, 1.3), 2),
        net_salary = round(gross_salary * runif(n(), 0.7, 0.85), 2),

        # Contract type
        contract_type = sample(contract_types, n(), replace = TRUE,
                               prob = c(0.4, 0.3, 0.15, 0.1, 0.05)),

        # Occupation information
        occupation_title = sample(occupations, n(), replace = TRUE),
        occupation_code = paste0("OCC", sprintf("%03d", sample(1:100, n(), replace = TRUE))),
        occupation_category = sample(c("Professional", "Technical", "Administrative",
                                       "Management", "Support"), n(), replace = TRUE),
        occupation_level = sample(1:5, n(), replace = TRUE),

        # Hours and grade
        whours = sample(c(20, 30, 35, 40), n(), replace = TRUE,
                        prob = c(0.05, 0.1, 0.15, 0.7)),
        paygrade = sample(pay_grades, n(), replace = TRUE),
        seniority = sample(seniority_levels, n(), replace = TRUE,
                           prob = c(0.25, 0.35, 0.25, 0.1, 0.05)),

        # Location information
        country_code = sample(countries, n(), replace = TRUE),
        country_name = paste(country_code, "Full Name"),
        admin1_name = paste0(country_code, "_Region_", sample(1:5, n(), replace = TRUE)),
        admin1_code = paste0("ADM1_", sprintf("%03d", sample(1:50, n(), replace = TRUE)))
      ) %>%
      select(-churn_this_period, -churn_rate) %>%
      # Reorder columns to match the header
      select(
        contract_id, personnel_id, est_id, ref_date,
        base_salary, gross_salary, net_salary,
        contract_type, occupation_title, occupation_code,
        occupation_category, occupation_level,
        start_date, end_date, whours, paygrade, seniority,
        country_code, country_name, admin1_name, admin1_code
      )

    # Append to overall data
    all_data <- bind_rows(all_data, period_data)
  }

  return(all_data)
}

# Generate the data
hrmis_data <- generate_hrmis_data(n)

# ========================================
# INTRODUCE ERRORS AND MISSINGNESS
# ========================================

introduce_errors <- function(df, error_rate = 0.15) {

  n <- nrow(df)

  # 1. MISSINGNESS (5-20% depending on field)
  df <- df %>%
    mutate(
      # Critical fields: low missingness (2-5%)
      personnel_id = if_else(runif(n) < 0.02, NA_character_, personnel_id),
      est_id = if_else(runif(n) < 0.03, NA_character_, est_id),

      # Salary fields: moderate missingness (5-10%)
      base_salary = if_else(runif(n) < 0.08, NA_real_, base_salary),
      gross_salary = if_else(runif(n) < 0.06, NA_real_, gross_salary),
      net_salary = if_else(runif(n) < 0.10, NA_real_, net_salary),

      # Occupation: moderate missingness (3-8%)
      occupation_title = if_else(runif(n) < 0.05, NA_character_, occupation_title),
      occupation_code = if_else(runif(n) < 0.07, NA_character_, occupation_code),

      # Dates: low-moderate missingness (2-8%)
      start_date = if_else(runif(n) < 0.03, as.Date(NA), start_date),
      ref_date = if_else(runif(n) < 0.02, as.Date(NA), ref_date),

      # Administrative: higher missingness (10-15%)
      admin1_name = if_else(runif(n) < 0.12, NA_character_, admin1_name),
      admin1_code = if_else(runif(n) < 0.10, NA_character_, admin1_code),

      # Work details: moderate missingness (5-12%)
      whours = if_else(runif(n) < 0.08, NA_real_, whours),
      paygrade = if_else(runif(n) < 0.06, NA_character_, paygrade),
      seniority = if_else(runif(n) < 0.10, NA_character_, seniority)
    )

  # 2. DATE LOGIC ERRORS (5% of records)
  date_error_idx <- sample(1:n, round(n * 0.05))
  df <- df %>%
    mutate(
      row_num = row_number(),
      end_date = if_else(row_num %in% date_error_idx,
                         start_date - days(sample(1:365, n, replace = TRUE)),
                         end_date)
    ) %>%
    select(-row_num)

  # 3. SALARY LOGIC ERRORS (8% of records)
  salary_error_idx <- sample(1:n, round(n * 0.08))
  salary_error_half <- round(length(salary_error_idx) / 2)

  df <- df %>%
    mutate(
      row_num = row_number(),
      # Net salary > gross salary (first half of error indices)
      net_salary = if_else(row_num %in% salary_error_idx[1:salary_error_half],
                           gross_salary * runif(n, 1.1, 1.5),
                           net_salary),
      # Gross salary < base salary (second half of error indices)
      gross_salary = if_else(row_num %in% salary_error_idx[salary_error_half:length(salary_error_idx)],
                             base_salary * runif(n, 0.5, 0.9),
                             gross_salary)
    ) %>%
    select(-row_num)

  # 4. NEGATIVE VALUES (3% of records)
  negative_idx <- sample(1:n, round(n * 0.03))
  df <- df %>%
    mutate(
      row_num = row_number(),
      base_salary = if_else(row_num %in% negative_idx,
                            -abs(base_salary),
                            base_salary)
    ) %>%
    select(-row_num)

  # 5. OUTLIERS (2% extreme values)
  outlier_idx <- sample(1:n, round(n * 0.02))
  df <- df %>%
    mutate(
      row_num = row_number(),
      gross_salary = if_else(row_num %in% outlier_idx,
                             gross_salary * runif(n, 10, 100),
                             gross_salary)
    ) %>%
    select(-row_num)

  # 6. INVALID WORKING HOURS (4% of records)
  hours_error_idx <- sample(1:n, round(n * 0.04))
  df <- df %>%
    mutate(
      row_num = row_number(),
      whours = if_else(row_num %in% hours_error_idx,
                       sample(c(0, -5, 80, 100, 168), n, replace = TRUE),
                       whours)
    ) %>%
    select(-row_num)

  # 7. DUPLICATE IDs (3% of records)
  dup_idx <- sample(1:n, round(n * 0.03))
  available_ids <- df %>%
    mutate(row_num = row_number()) %>%
    filter(!row_num %in% dup_idx) %>%
    pull(contract_id)
  dup_ids <- sample(available_ids, length(dup_idx), replace = TRUE)

  df <- df %>%
    mutate(
      row_num = row_number(),
      contract_id = if_else(row_num %in% dup_idx,
                            dup_ids[match(row_num, dup_idx)],
                            contract_id)
    ) %>%
    select(-row_num)

  # 8. TYPOS AND FORMATTING ERRORS (5% of text fields)
  typo_idx <- sample(1:n, round(n * 0.05))
  typo_suffixes <- sample(c("  ", " ", "123", "!", "??"), n, replace = TRUE)

  df <- df %>%
    mutate(
      row_num = row_number(),
      occupation_title = if_else(row_num %in% typo_idx,
                                 paste0(occupation_title, typo_suffixes),
                                 occupation_title)
    ) %>%
    select(-row_num)

  # 9. INCONSISTENT COUNTRY CODES (3% of records)
  country_error_idx <- sample(1:n, round(n * 0.03))
  country_suffixes <- sample(c("_OLD", "_2", "X"), n, replace = TRUE)

  df <- df %>%
    mutate(
      row_num = row_number(),
      country_code = if_else(row_num %in% country_error_idx,
                             paste0(country_code, country_suffixes),
                             country_code)
    ) %>%
    select(-row_num)

  # 10. FUTURE START DATES (2% of records)
  future_idx <- sample(1:n, round(n * 0.02))
  future_days <- sample(1:365, n, replace = TRUE)

  df <- df %>%
    mutate(
      row_num = row_number(),
      start_date = if_else(row_num %in% future_idx,
                           Sys.Date() + days(future_days),
                           start_date)
    ) %>%
    select(-row_num)

  # 11. INCONSISTENT SENIORITY vs PAYGRADE (6% of records)
  inconsistent_idx <- sample(1:n, round(n * 0.06))
  df <- df %>%
    mutate(
      row_num = row_number(),
      seniority = if_else(row_num %in% inconsistent_idx, "Executive", seniority),
      paygrade = if_else(row_num %in% inconsistent_idx, "Grade_1", paygrade)
    ) %>%
    select(-row_num)

  # 12. MISSING OCCUPATION CODE BUT HAS TITLE (4% of records)
  missing_code_idx <- sample(1:n, round(n * 0.04))
  df <- df %>%
    mutate(
      row_num = row_number(),
      occupation_code = if_else(row_num %in% missing_code_idx,
                                NA_character_,
                                occupation_code)
    ) %>%
    select(-row_num)

  # 13. WHITESPACE ISSUES (3% of records)
  whitespace_idx <- sample(1:n, round(n * 0.03))
  df <- df %>%
    mutate(
      row_num = row_number(),
      occupation_title = if_else(row_num %in% whitespace_idx,
                                 paste0("  ", occupation_title, "  "),
                                 occupation_title),
      country_name = if_else(row_num %in% whitespace_idx,
                             paste0(country_name, " "),
                             country_name)
    ) %>%
    select(-row_num)

  return(df)
}

# Apply errors
hrmis_data_with_errors <- introduce_errors(hrmis_data, error_rate = 0.15)

# Display first few rows
head(hrmis_data_with_errors, 10)

# ========================================
# ERROR DIAGNOSTICS
# ========================================

diagnose_errors <- function(df) {
  cat("\n=== ERROR DIAGNOSTIC REPORT ===\n\n")

  # Missingness
  cat("1. MISSINGNESS BY VARIABLE:\n")
  missing_summary <- df %>%
    summarise(across(everything(), ~sum(is.na(.)))) %>%
    pivot_longer(everything(), names_to = "variable", values_to = "missing_count") %>%
    mutate(missing_pct = round(missing_count / nrow(df) * 100, 2)) %>%
    filter(missing_count > 0) %>%
    arrange(desc(missing_pct))
  print(missing_summary, n = 20)

  # Date logic errors
  cat("\n2. DATE LOGIC ERRORS:\n")
  date_errors <- sum(df$end_date < df$start_date, na.rm = TRUE)
  cat("  - End date before start date:", date_errors, "records\n")
  future_starts <- sum(df$start_date > Sys.Date(), na.rm = TRUE)
  cat("  - Future start dates:", future_starts, "records\n")

  # Salary logic errors
  cat("\n3. SALARY LOGIC ERRORS:\n")
  net_gt_gross <- sum(df$net_salary > df$gross_salary, na.rm = TRUE)
  cat("  - Net salary > Gross salary:", net_gt_gross, "records\n")
  gross_lt_base <- sum(df$gross_salary < df$base_salary, na.rm = TRUE)
  cat("  - Gross salary < Base salary:", gross_lt_base, "records\n")
  negative_salary <- sum(df$base_salary < 0, na.rm = TRUE)
  cat("  - Negative salaries:", negative_salary, "records\n")

  # Working hours errors
  cat("\n4. WORKING HOURS ERRORS:\n")
  invalid_hours <- sum(df$whours <= 0 | df$whours > 60, na.rm = TRUE)
  cat("  - Invalid hours (<=0 or >60):", invalid_hours, "records\n")

  # Duplicates
  cat("\n5. DUPLICATE IDs:\n")
  dup_contracts <- sum(duplicated(df$contract_id))
  cat("  - Duplicate contract IDs:", dup_contracts, "records\n")

  # Text errors
  cat("\n6. TEXT FORMATTING ISSUES:\n")
  whitespace_issues <- sum(str_detect(df$occupation_title, "^\\s|\\s$"), na.rm = TRUE)
  cat("  - Fields with leading/trailing whitespace:", whitespace_issues, "records\n")
  special_chars <- sum(str_detect(df$occupation_title, "[0-9!?]"), na.rm = TRUE)
  cat("  - Occupation titles with numbers/special chars:", special_chars, "records\n")

  # Inconsistencies
  cat("\n7. LOGICAL INCONSISTENCIES:\n")
  missing_code_has_title <- sum(is.na(df$occupation_code) & !is.na(df$occupation_title))
  cat("  - Missing occupation code but has title:", missing_code_has_title, "records\n")

  cat("\n========================================\n")
}

# Run diagnostics
diagnose_errors(hrmis_data_with_errors)

# Summary statistics
cat("\n=== DATA SUMMARY ===\n")
cat("Total records:", nrow(hrmis_data_with_errors), "\n")
cat("Unique personnels:", n_distinct(hrmis_data_with_errors$personnel_id, na.rm = TRUE), "\n")
cat("Unique establishments:", n_distinct(hrmis_data_with_errors$est_id, na.rm = TRUE), "\n")
cat("Complete cases (no missing values):", sum(complete.cases(hrmis_data_with_errors)), "\n")
cat("Records with at least one error/missing:",
    sum(!complete.cases(hrmis_data_with_errors)), "\n")

cat("\n=== COHORT ANALYSIS BY REF_DATE ===\n")
cohort_summary <- hrmis_data_with_errors %>%
  group_by(ref_date) %>%
  summarise(
    total_personnels = n(),
    unique_personnels = n_distinct(personnel_id, na.rm = TRUE),
    new_hires = sum(start_date >= ref_date - days(365) & start_date <= ref_date, na.rm = TRUE),
    terminated = sum(!is.na(end_date) & end_date >= ref_date - days(365) & end_date <= ref_date, na.rm = TRUE),
    active = sum(is.na(end_date) | end_date > ref_date, na.rm = TRUE),
    avg_salary = round(mean(gross_salary, na.rm = TRUE), 2)
  ) %>%
  arrange(ref_date)

print(cohort_summary)

# Calculate retention rates between periods
cat("\n=== RETENTION RATES ===\n")
ref_dates <- sort(unique(hrmis_data_with_errors$ref_date))
for (i in 2:length(ref_dates)) {
  prev_personnels <- hrmis_data_with_errors %>%
    filter(ref_date == ref_dates[i-1]) %>%
    pull(personnel_id) %>%
    unique()

  current_personnels <- hrmis_data_with_errors %>%
    filter(ref_date == ref_dates[i]) %>%
    pull(personnel_id) %>%
    unique()

  retained <- length(intersect(prev_personnels, current_personnels))
  retention_rate <- round(retained / length(prev_personnels) * 100, 1)

  cat(format(ref_dates[i-1]), "to", format(ref_dates[i]), ": ",
      retention_rate, "% (", retained, "/", length(prev_personnels), ")\n")
}

# Export both clean and dirty data
write_csv(hrmis_data, "synthetic_hrmis_data_CLEAN.csv")
write_csv(hrmis_data_with_errors, "synthetic_hrmis_data_WITH_ERRORS.csv")

cat("\n=== FILES EXPORTED ===\n")
cat("Clean data: synthetic_hrmis_data_CLEAN.csv\n")
cat("Data with errors: synthetic_hrmis_data_WITH_ERRORS.csv\n")

# Optional: View examples of errors
cat("\n=== SAMPLE ERRORS ===\n")
cat("\nRecords with date logic errors:\n")
print(hrmis_data_with_errors %>%
        filter(end_date < start_date) %>%
        select(contract_id, start_date, end_date) %>%
        head(3))

cat("\nRecords with salary logic errors:\n")
print(hrmis_data_with_errors %>%
        filter(net_salary > gross_salary | gross_salary < base_salary | base_salary < 0) %>%
        select(contract_id, base_salary, gross_salary, net_salary) %>%
        head(3))
