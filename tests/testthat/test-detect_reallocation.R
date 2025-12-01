# library(testthat)
# library(dplyr)
# library(tidyr)
# library(purrr)
# library(lubridate)

# set.seed(123)

# # Example dataset
# dt <- tibble(
#   personnel_id = rep(1:3, each = 4),
#   ref_date = rep(ymd(c("2020-01-01","2021-01-01","2022-01-01","2023-01-01")), 3),
#   est_id = c(101,101,102,102, 201,202,202,203, 301,301,301,301)
# )

# # Example hires
# personnel_hire <- tibble(
#   personnel_id = c(1,2,3),
#   ref_date = ymd(c("2020-01-01","2020-01-01","2020-01-01"))
# )

# test_that("detect_reallocation identifies reallocations correctly", {
#   res <- detect_reallocation(dt, personnel_hire)

#   # Output columns
#   expect_true(all(c("personnel_id", "ref_date", "type_event") %in% names(res)))

#   # Personnel 1: 101 -> 102 at 2022
#   expect_true(any(res$personnel_id == 1 & res$ref_date == ymd("2022-01-01") & res$type_event == "reallocation"))

#   # Personnel 3: no change (all 301), so no events
#   expect_false(any(res$personnel_id == 3))
# })

