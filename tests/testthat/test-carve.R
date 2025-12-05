test_that("sample_group samples the requested number of unique groups", {
  df <- tibble::tibble(id = 1:8, grp = rep(letters[1:4], each = 2))
  set.seed(101)
  res <- sample_group(df, grp, 2)
  expect_equal(length(unique(res$grp)), 2L)
  expect_true(all(unique(res$grp) %in% df$grp))
})

test_that("sample_group returns all rows when n > number of unique groups", {
  df <- tibble::tibble(id = 1:8, grp = rep(letters[1:4], each = 2))
  res <- sample_group(df, grp, 10)
  expect_equal(sort(unique(res$grp)), sort(unique(df$grp)))
  expect_equal(nrow(res), nrow(df))
})

test_that("sample_group returns zero rows when n <= 0", {
  df <- tibble::tibble(id = 1:8, grp = rep(letters[1:4], each = 2))
  res0 <- sample_group(df, grp, 0)
  expect_equal(nrow(res0), 0L)
  res_neg <- sample_group(df, grp, -1)
  expect_equal(nrow(res_neg), 0L)
})