# Test validate_data function
test_that("validate_data returns report format by default", {
  result <- validate_data(
    govhr::bra_hrmis_contract,
    govhr::contract_rules
  )
  
  expect_s3_class(result, "data.frame")
  expect_named(result, c("Rule", "Description", "Total Records", "Passes", "Pass Rate", "Fails", "Errors"))
  expect_equal(nrow(result), nrow(govhr::contract_rules))
})

test_that("validate_data returns object format when requested", {
  result <- validate_data(
    govhr::bra_hrmis_contract,
    govhr::contract_rules,
    output_format = "object"
  )
  
  expect_s4_class(result, "validation")
})

# Test validation rules with dummy data
test_that("contract rules detect unique violations", {
  dummy_contract <- data.frame(
    contract_id = c(1, 1, 2),
    personnel_id = c(1, 1, 2),
    ref_date = as.Date(c("2023-01-01", "2023-01-01", "2023-01-01")),
    whours = c(40, 40, 40),
    start_date = as.Date(c("2023-01-01", "2023-01-01", "2023-01-01")),
    gross_salary_lcu = c(1000, 1000, 1000),
    base_salary_lcu = c(800, 800, 800),
    net_salary_lcu = c(900, 900, 900),
    allowance_lcu = c(200, 200, 200)
  )
  
  result <- validate_data(dummy_contract, govhr::contract_rules)
  
  # Should fail unique contract_id + ref_date (rows 1 and 2 are duplicates)
  unique_id_fails <- result$Fails[result$Rule == "Unique contract ID"]
  expect_equal(unique_id_fails, 2)
  
  # Should fail unique contract_id + personnel_id + ref_date  
  unique_personnel_fails <- result$Fails[result$Rule == "Unique assignment"]
  expect_equal(unique_personnel_fails, 2)
})

test_that("contract rules detect salary logic violations", {
  dummy_contract <- data.frame(
    contract_id = 1:3,
    personnel_id = 1:3,
    ref_date = as.Date("2023-01-01"),
    whours = c(40, 40, 40),
    start_date = as.Date("2023-01-01"),
    gross_salary_lcu = c(1000, 1000, 900),
    base_salary_lcu = c(800, 800, 800),
    net_salary_lcu = c(900, 1100, 900),
    allowance_lcu = c(200, 200, 200)
  )
  
  result <- validate_data(dummy_contract, govhr::contract_rules)
  
  # Row 2: net (1100) > gross (1000) should fail
  net_fails <- result$Fails[result$Rule == "Net vs gross"]
  expect_equal(net_fails, 1)
  
  # Row 3: gross (900) < base + allowance (800 + 200) should fail
  composition_fails <- result$Fails[result$Rule == "Gross composition"]
  expect_equal(composition_fails, 1)
})

test_that("personnel rules detect age and date violations", {
  dummy_personnel <- data.frame(
    personnel_id = 1:3,
    ref_date = as.Date(c("2023-01-01", "2030-01-01", "2023-01-01")),
    birth_date = as.Date(c("2000-01-01", "2000-01-01", "2020-01-01")),
    status = c("active", "active", "active")
  )
  
  result <- validate_data(dummy_personnel, govhr::personnel_rules)
  
  # Row 2: ref_date in 2030 (future) should fail
  date_fails <- result$Fails[result$Rule == "Valid date"]
  expect_equal(date_fails, 1)
  
  # Row 3: age ~3 years (< 18) should fail
  age_fails <- result$Fails[result$Rule == "Minimum age"]
  expect_equal(age_fails, 1)
})

test_that("validate_data output_format argument matches correctly", {
  expect_error(
    validate_data(
      govhr::bra_hrmis_contract,
      govhr::contract_rules,
      output_format = "invalid"
    ),
    "'arg' should be one of"
  )
})
