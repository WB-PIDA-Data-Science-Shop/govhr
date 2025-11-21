test_that("deduplication works", {
  df <- tibble(
    personnel_id = c(1, 1, 1, 2, 2, 2, 2),
    gender    = c(NA, "M", "F", "F", NA, "M", "F"),
    ref_date  = as.Date(
      c(
        "2023-01-01",
        "2023-01-02",
        "2023-01-02",
        "2023-01-01",
        "2023-01-02",
        "2023-01-03",
        "2023-01-03"
      )
    )
  )

  df_expected <- tibble(
    personnel_id = c(1, 1, 2, 2, 2),
    ref_date = as.Date(
      c("2023-01-01", "2023-01-02", "2023-01-01", "2023-01-02", "2023-01-03")
    ),
    gender = c(NA, "F", "F", NA, "F")
  )

  expect_equal(
    df |> dedup_value_panel(gender, personnel_id, ref_date),
    df_expected
    )
})
