library(testthat)
library(data.table)

# Sample data
dt <- data.table(
  x = 1:6,
  y = c(2, 4, 6, 8, 10, 12),
  group = c("A", "A", "A", "B", "B", "B")
)

# Define a simple custom function
cv_fun <- function(x) sd(x) / mean(x)

test_that("compute_fastsummary returns correct structure", {
  res <- compute_fastsummary(dt, cols = c("x", "y"), groups = "group", fns = c("mean", "sd"))
  expect_s3_class(res, "data.table")
  expect_true(all(c("group", "indicator", "value") %in% names(res)))
})

test_that("compute_fastsummary handles long and wide outputs as expected", {
  def_fns <- c("mean", "sd")

  long_res <- compute_fastsummary(dt, 
                                  cols = c("x", "y"), 
                                  groups = "group", 
                                  output = "long", 
                                  fns = def_fns)
  wide_res <- compute_fastsummary(dt, 
                                  cols = c("x", "y"), 
                                  groups = "group", 
                                  output = "wide",
                                  fns = def_fns)
  
  x <- sum(unique(long_res$indicator) |> as.character() %in% colnames(wide_res))
  
  expect_equal(x, length(unique(long_res$indicator)))  
  
})

test_that("compute_fastsummary returns tibble if tbl = TRUE", {
  res_tbl <- compute_fastsummary(dt, cols = "x", groups = "group", tbl = TRUE, fns = c("sd", "mean"))
  expect_s3_class(res_tbl, "tbl_df")
})

test_that("compute_fastsummary works with both default and user-defined functions", {

  # user-defined indicator
  newind <- function(x) sd(x) * 10 / mean(x)

  res <- compute_fastsummary(
    dt,
    cols = c("x", "y"),
    fns = list("mean", newind = ~ sd(.x) * 10 / mean(.x)),
    groups = "group",
    output = "long"
  )

  # 1. Output should be a data.table (default)
  expect_s3_class(res, "data.table")

  # 2. Check expected indicator names
  expected_inds <- c("x_mean", "y_mean", "x_newind", "y_newind")
  expect_true(all(expected_inds %in% res$indicator))

  # 3. Row count should be: (# groups) * (# cols) * (# functions)
  expect_equal(
    nrow(res),
    length(unique(dt$group)) * length(c("x", "y")) * 2  # mean + newind
  )

  # 4. Values should be numeric for these indicators
  expect_type(res$value, "double")

  # 5. Ensure the custom function actually computes different values than mean
  expect_true(any(res[indicator == "x_newind", value] != res[indicator == "x_mean", value]))
})

test_that("compute_fastsummary errors on unknown function names", {
  expect_error(
    compute_fastsummary(dt, cols = "x", fns = c("not_a_fn"), groups = "group"),
    "Unknown function name"
  )
})

test_that("compute_fastsummary errors if data is not a data.table", {
  df <- data.frame(x = 1:3, y = 3:1, group = c("A", "B", "C"))
  expect_error(
    compute_fastsummary(df, cols = "x", groups = "group"),
    "data.table"
  )
})
