
# ---- detect_career_transition ------------------------------------------------
# Backs both the transition panel and the pre-computed analytics cache.

careers <- data.frame(
  contract_id = c("a", "a", "a", "a", "b", "b"),
  ref_date = as.Date(c(
    "2020-01-01", "2021-01-01", "2022-01-01", "2023-01-01",
    "2020-01-01", "2021-01-01"
  )),
  paygrade = c("G1", "G1", "G2", "G3", "G5", "G5"),
  unit = c("U1", "U1", "U1", "U1", "U2", "U2"),
  stringsAsFactors = FALSE
)

test_that("detect_career_transition collapses consecutive periods into spells", {
  result <- detect_career_transition(
    careers,
    id_col = "contract_id",
    group_cols = "paygrade"
  )

  # a: G1 (2020-2021) -> G2 (2022) -> G3 (2023) is two transitions, not three
  expect_equal(nrow(result), 2L)
  expect_equal(result$from, c("G1", "G2"))
  expect_equal(result$to, c("G2", "G3"))
})

test_that("detect_career_transition dates each row to the move itself", {
  result <- detect_career_transition(
    careers,
    id_col = "contract_id",
    group_cols = "paygrade"
  )

  # the move out of G1 lands in 2022, when G2 is first observed, not in 2020
  # when G1 began; `from_date` keeps the origin spell's start
  expect_equal(result$ref_date, as.Date(c("2022-01-01", "2023-01-01")))
  expect_equal(result$from_date, as.Date(c("2020-01-01", "2022-01-01")))
})

test_that("detect_career_transition does not pile moves onto the panel start", {
  # every entity begins its first spell at the earliest date in the panel, so
  # dating by the origin spell backdated all first moves onto that one period
  starts_together <- data.frame(
    contract_id = rep(c("a", "b", "c"), each = 3),
    ref_date = rep(
      as.Date(c("2020-01-01", "2021-01-01", "2022-01-01")),
      times = 3
    ),
    paygrade = c(
      "G1", "G1", "G2",  # a moves in 2022
      "G1", "G1", "G2",  # b moves in 2022
      "G1", "G2", "G2"   # c moves in 2021
    ),
    stringsAsFactors = FALSE
  )

  counts <- detect_career_transition(
    starts_together,
    id_col = "contract_id",
    group_cols = "paygrade"
  ) |>
    (\(x) table(x$ref_date))()

  expect_false("2020-01-01" %in% names(counts))
  expect_equal(as.integer(counts[["2021-01-01"]]), 1L)
  expect_equal(as.integer(counts[["2022-01-01"]]), 2L)
})

test_that("detect_career_transition leaves terminal spells undated", {
  everyone <- detect_career_transition(
    careers,
    id_col = "contract_id",
    group_cols = "paygrade",
    return_all = TRUE
  )

  terminal <- everyone[is.na(everyone$to), ]

  expect_true(all(is.na(terminal$ref_date)))
  expect_true(all(!is.na(terminal$from_date)))
})

test_that("detect_career_transition keeps non-movers only when return_all is TRUE", {
  movers_only <- detect_career_transition(
    careers,
    id_col = "contract_id",
    group_cols = "paygrade"
  )
  everyone <- detect_career_transition(
    careers,
    id_col = "contract_id",
    group_cols = "paygrade",
    return_all = TRUE
  )

  # b never leaves G5
  expect_false("b" %in% movers_only$contract_id)
  expect_true("b" %in% everyone$contract_id)
  expect_true(is.na(everyone$to[everyone$contract_id == "b"]))
})

test_that("detect_career_transition drops entities with duplicate periods", {
  # `a` holds two paygrades in 2021, so its position that period is undefined
  doubled <- data.frame(
    contract_id = c("a", "a", "a", "b", "b"),
    ref_date = as.Date(c(
      "2020-01-01", "2021-01-01", "2021-01-01",
      "2020-01-01", "2021-01-01"
    )),
    paygrade = c("G1", "G2", "G3", "G1", "G2"),
    stringsAsFactors = FALSE
  )

  expect_warning(
    result <- detect_career_transition(
      doubled,
      id_col = "contract_id",
      group_cols = "paygrade"
    ),
    "not uniquely identified"
  )

  # the whole of `a` goes, not just its surplus record; `b` is untouched
  expect_false("a" %in% result$contract_id)
  expect_equal(result$contract_id, "b")
  expect_equal(result$from, "G1")
  expect_equal(result$to, "G2")
})

test_that("detect_career_transition reports how much it drops", {
  doubled <- data.frame(
    contract_id = c("a", "a", "a", "b", "b"),
    ref_date = as.Date(c(
      "2020-01-01", "2021-01-01", "2021-01-01",
      "2020-01-01", "2021-01-01"
    )),
    paygrade = c("G1", "G2", "G3", "G1", "G2"),
    stringsAsFactors = FALSE
  )

  # one surplus record, three dropped in total, one offending id
  expect_warning(
    detect_career_transition(doubled, id_col = "contract_id", group_cols = "paygrade"),
    "1 record\\(s\\) are not uniquely identified.*3 record\\(s\\).*1 affected"
  )
})

test_that("detect_career_transition stays quiet when records are unique", {
  expect_no_warning(
    detect_career_transition(
      careers,
      id_col = "contract_id",
      group_cols = "paygrade"
    )
  )
})

test_that("detect_career_transition combines multiple grouping columns", {
  result <- detect_career_transition(
    careers,
    id_col = "contract_id",
    group_cols = c("paygrade", "unit")
  )

  expect_equal(result$from, c("G1 | U1", "G2 | U1"))
  expect_equal(result$to, c("G2 | U1", "G3 | U1"))
})
