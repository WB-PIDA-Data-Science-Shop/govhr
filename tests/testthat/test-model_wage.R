wage_data <- data.frame(
  gross_salary_lcu = c(
    4687, 5092, 4582, 5798, 5165, 4590, 5244, 5369, 5288, 4847,
    5756, 5195, 4689, 3893, 5562, 4978, 4992, 5472, 5411, 5297,
    5459, 5391, 5037, 4005, 5310, 4972, 4922, 4265, 4761, 5209
  ),
  contract_type = c(
    "permanent", "temporary", "temporary", "temporary", "temporary",
    "temporary", "temporary", "permanent", "temporary", "temporary",
    "temporary", "temporary", "permanent", "permanent", "permanent",
    "temporary", "temporary", "permanent", "permanent", "temporary",
    "temporary", "temporary", "permanent", "permanent", "permanent",
    "temporary", "permanent", "temporary", "permanent", "temporary"
  ),
  occupation_native = c(
    "teacher", "teacher", "nurse", "nurse", "teacher", "teacher",
    "teacher", "nurse", "nurse", "teacher", "nurse", "nurse", "nurse",
    "teacher", "teacher", "teacher", "teacher", "nurse", "teacher",
    "teacher", "teacher", "teacher", "teacher", "nurse", "nurse",
    "nurse", "nurse", "teacher", "nurse", "nurse"
  ),
  educat7 = c(
    2, 7, 7, 4, 3, 5, 2, 2, 1, 3, 3, 2, 7, 2, 5, 2, 5, 4, 7, 7,
    5, 4, 6, 1, 3, 2, 3, 3, 1, 5
  ),
  whours = c(
    33, 25, 39, 28, 24, 33, 36, 22, 22, 26, 33, 22, 38, 31, 36,
    28, 37, 36, 37, 34, 26, 34, 39, 38, 40, 35, 38, 23, 21, 35
  ),
  paygrade = c(
    1, 4, 1, 4, 2, 5, 2, 2, 2, 3, 1, 2, 3, 3, 3, 3, 5, 3, 1, 2,
    4, 2, 2, 4, 5, 1, 5, 5, 5, 4
  ),
  personnel_id = rep(1:10, each = 3),
  est_id = rep(1:5, length.out = 30),
  ref_date = rep(as.Date(c("2020-01-01", "2021-01-01", "2022-01-01")), 10)
)

test_that("model_wage fits with the default variables", {
  fit <- model_wage(wage_data)
  expect_s3_class(fit, "fixest")
})

test_that("model_wage stops when outcome_var is missing from data", {
  d <- wage_data
  d$gross_salary_lcu <- NULL

  expect_error(model_wage(d), "outcome_var")
})

test_that("model_wage stops when any fixed_effects_vars is missing from data", {
  d <- wage_data
  d$est_id <- NULL

  expect_error(model_wage(d), "fixed_effects_vars")
  expect_error(model_wage(d), "est_id")
})

test_that("model_wage drops missing predictor_vars with a warning rather than failing", {
  d <- wage_data
  d$paygrade <- NULL

  expect_warning(
    fit <- model_wage(d),
    "paygrade"
  )
  expect_s3_class(fit, "fixest")
})

test_that("model_wage falls back to an intercept-only formula when no predictor_vars remain", {
  expect_warning(
    fit <- model_wage(wage_data, predictor_vars = c("does_not_exist")),
    "does_not_exist"
  )
  expect_s3_class(fit, "fixest")
})
