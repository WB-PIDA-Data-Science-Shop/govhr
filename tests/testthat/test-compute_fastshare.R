library(testthat)
library(data.table)

# Sample microdata
dt <- data.table(
  group = c("A", "A", "B", "B"),
  x = c(10, 20, 30, 40),
  y = c(1, 1, 2, 2)
)

# Sample macro data
macro_dt <- data.table(
  group = c("A", "B"),
  pop = c(100, 200),
  gdp = c(1000, 2000)
)


test_that("compute_fastshare computes correct long output", {

  res <- compute_fastshare(
    data = dt,
    macro_data = macro_dt,
    macro_cols = c("pop", "gdp"),
    cols = c("x"),
    groups = "group",
    fns = c("sum"),
    output = "long"
  )

  expect_s3_class(res, "data.table")

  # expected indicators
  expect_true("x_sum_per_pop" %in% res$indicator)
  expect_true("x_sum_per_gdp" %in% res$indicator)

  # expected number of rows: groups × macro_vars × summary_vars
  expect_equal(
    nrow(res),
    length(unique(dt$group)) * 2 * 1   # 2 macro vars × 1 summary var
  )

  # check a specific value
  # For group A: sum(x) = 30 → 30/100 = 0.3, 30/1000 = 0.03
  expect_equal(
    res[group == "A" & indicator == "x_sum_per_pop", value],
    30/100
  )
  expect_equal(
    res[group == "A" & indicator == "x_sum_per_gdp", value],
    30/1000
  )
})


test_that("compute_fastshare computes correct wide output", {

  res <- compute_fastshare(
    data = dt,
    macro_data = macro_dt,
    macro_cols = c("pop", "gdp"),
    cols = c("x"),
    groups = "group",
    fns = c("sum"),
    output = "wide"
  )

  # wide format should have these columns
  expect_true(all(c("pop", "gdp", "x_sum", "x_sum_per_pop", "x_sum_per_gdp") %in% names(res)))

  # check a value
  expect_equal(res[group == "B", x_sum_per_pop], 70/200)
  expect_equal(res[group == "B", x_sum_per_gdp], 70/2000)
})

test_that("compute_fastshare works with user-defined functions", {

  res <- compute_fastshare(
    data = dt,
    macro_data = macro_dt,
    macro_cols = c("pop"),
    cols = "x",
    groups = "group",
    fns = list("mean", rng = ~ max(.x) - min(.x)),
    output = "long"
  )

  expect_true("x_rng_per_pop" %in% res$indicator)

  # group A: max(x)-min(x) = 20-10 = 10 → 10/100 = 0.1
  expect_equal(res[group == "A" & indicator == "x_rng_per_pop", value], 10/100)
})


test_that("compute_fastshare automatically detects join keys", {

  res <- compute_fastshare(
    data = dt,
    macro_data = macro_dt,
    macro_cols = "pop",
    cols = "x",
    groups = "group",
    fns = "sum"
  )

  # the join key should be "group"
  expect_true("group" %in% names(res))
})



test_that("compute_fastshare errors when there are no join keys", {

  macro2 <- data.table(region = c("A","B"), pop = c(100,200))

  expect_error(
    compute_fastshare(
      data = dt,
      macro_data = macro2,
      macro_cols = "pop",
      cols = "x",
      groups = "group",
      fns = "sum"
    ),
    "No common grouping variables"
  )
})


test_that("compute_fastshare works with multiple summary columns", {

  res <- compute_fastshare(
    data = dt,
    macro_data = macro_dt,
    macro_cols = c("pop"),
    cols = c("x","y"),
    groups = "group",
    fns = c("sum")
  )

  expect_true("x_sum_per_pop" %in% res$indicator)
  expect_true("y_sum_per_pop" %in% res$indicator)

  # check a value
  expect_equal(
    res[group=="A" & indicator=="y_sum_per_pop", value],
    (1+1)/100
  )
})
