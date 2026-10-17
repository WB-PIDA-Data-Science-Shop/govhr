# ---------------------------------------------------------------------------
# fixtures
#
# a hand-worked panel of four people over three annual snapshots, one
# contract each per year:
#
#   person  2020                 2021                  2022
#   P1      active, t0, pay 100  active, t1, pay 110   active, t2, pay 121
#   P2      active, t0, pay 200  (gone)
#   P3      active, t1, pay 100  pensioner, t2
#   P4                           active, t0, pay 100   active, t1, pay 90
#
# pooled over 2020->2021 and 2021->2022, by tenure at the start of the year:
#
#   tenure 0: exposed P1/2020, P2/2020, P4/2021 (pop 3); stayed P1, P4
#             (px 2/3); pay ratios 1.1 and 0.9, so pay_growth is their
#             geometric mean sqrt(0.99) - 1, the median ratio gives 0, and
#             half took a pay cut; mean pay of the exposed (100+200+100)/3
#   tenure 1: exposed P3/2020, P1/2021 (pop 2; P4/2022 is in the last
#             snapshot, so it has no next year); stayed P1 (px 1/2); pay
#             ratio 1.1; mean pay (100+110)/2
# ---------------------------------------------------------------------------
career_personnel <- function() {
  data.table::data.table(
    personnel_id = c("P1", "P2", "P3", "P1", "P3", "P4", "P1", "P4"),
    ref_date = as.Date(c(
      "2020-01-01", "2020-01-01", "2020-01-01",
      "2021-01-01", "2021-01-01", "2021-01-01",
      "2022-01-01", "2022-01-01"
    )),
    employment_status = c(
      "active", "active", "active",
      "active", "pensioner", "active",
      "active", "active"
    ),
    tenure = c(0, 0, 1, 1, 2, 0, 2, 1)
  )
}

career_contracts <- function() {
  data.table::data.table(
    contract_id = c("C1", "C2", "C3", "C4", "C5", "C6", "C7"),
    personnel_id = c("P1", "P2", "P3", "P1", "P4", "P1", "P4"),
    ref_date = as.Date(c(
      "2020-01-01", "2020-01-01", "2020-01-01",
      "2021-01-01", "2021-01-01",
      "2022-01-01", "2022-01-01"
    )),
    pay = c(100, 200, 100, 110, 100, 121, 90)
  )
}

# ---------------------------------------------------------------------------
# estimate_progression_rates()
# ---------------------------------------------------------------------------
test_that("pooled stay rates and pay growth by tenure match hand-worked values", {
  out <- estimate_progression_rates(
    career_personnel(), career_contracts(),
    tenure_col = "tenure", salary_col = "pay"
  )

  expect_equal(out$tenure, c(0L, 1L))
  expect_equal(out$pop, c(3L, 2L))
  expect_equal(out$stayers, c(2L, 1L))
  expect_equal(out$px, c(2 / 3, 1 / 2))
  expect_equal(out$n_pay, c(2L, 1L))
  expect_equal(out$pay_growth, c(sqrt(0.99) - 1, 0.1))
  expect_equal(out$median_pay_growth, c(0, 0.1))
  expect_equal(out$share_pay_cut, c(0.5, 0))
  expect_equal(out$mean_pay, c(400 / 3, 105))
  expect_equal(out$n_periods, c(2L, 2L))
})

test_that("a personnel-level group gets its own rates, and a cell nobody stayed in has n_pay 0", {
  # P1 and P2 are F, P3 and P4 are M:
  #   F tenure 0: P1/2020, P2/2020 exposed, P1 stays (ratio 1.1)
  #   F tenure 1: P1/2021 exposed and stays (ratio 1.1)
  #   M tenure 0: P4/2021 exposed and stays (ratio 0.9)
  #   M tenure 1: P3/2020 exposed and retires, so no stayers and no growth
  personnel <- career_personnel()
  personnel[, gender := ifelse(personnel_id %in% c("P1", "P2"), "F", "M")]

  out <- estimate_progression_rates(
    personnel, career_contracts(),
    tenure_col = "tenure", salary_col = "pay", group_cols = "gender"
  )

  expect_equal(out$gender, c("F", "F", "M", "M"))
  expect_equal(out$tenure, c(0L, 1L, 0L, 1L))
  expect_equal(out$pop, c(2L, 1L, 1L, 1L))
  expect_equal(out$px, c(0.5, 1, 1, 0))
  expect_equal(out$n_pay, c(1L, 1L, 1L, 0L))
  expect_equal(out$pay_growth, c(0.1, 0.1, -0.1, NA))
  expect_equal(out$share_pay_cut, c(0, 0, 1, NA))
})

# the same panel with an occupation on each contract, and two people holding
# two contracts in 2020:
#   P1/2020: clerk 60 + nurse 40 (total 100)
#   P3/2020: driver 50 + clerk 50, a tie in pay (listed driver first)
occupation_contracts <- function() {
  data.table::data.table(
    contract_id = c("C1", "C8", "C2", "C9", "C3", "C4", "C5", "C6", "C7"),
    personnel_id = c("P1", "P1", "P2", "P3", "P3", "P1", "P4", "P1", "P4"),
    ref_date = as.Date(c(
      "2020-01-01", "2020-01-01", "2020-01-01", "2020-01-01", "2020-01-01",
      "2021-01-01", "2021-01-01",
      "2022-01-01", "2022-01-01"
    )),
    pay = c(60, 40, 200, 50, 50, 110, 100, 121, 90),
    occupation = c(
      "clerk", "nurse", "nurse", "driver", "clerk",
      "clerk", "clerk", "clerk", "clerk"
    )
  )
}

test_that("a contract-level group comes from the highest-paid contract, with pay summed across contracts", {
  # P1/2020 is a clerk (60 > 40) on total pay 100, so grows 100 -> 110;
  # P3/2020 is a clerk: the 50/50 tie goes to the lower contract_id, C3
  #   clerk tenure 0: P1/2020 (1.1), P4/2021 (0.9) both stay
  #   clerk tenure 1: P3/2020 retires, P1/2021 stays (1.1)
  #   nurse tenure 0: P2/2020 leaves
  out <- estimate_progression_rates(
    career_personnel(), occupation_contracts(),
    tenure_col = "tenure", salary_col = "pay", group_cols = "occupation"
  )

  expect_equal(out$occupation, c("clerk", "clerk", "nurse"))
  expect_equal(out$tenure, c(0L, 1L, 0L))
  expect_equal(out$pop, c(2L, 2L, 1L))
  expect_equal(out$px, c(1, 0.5, 0))
  expect_equal(out$pay_growth, c(sqrt(0.99) - 1, 0.1, NA))
})

test_that("select_contract = \"lowest_paid\" takes the group from the lowest-paid contract", {
  # P1/2020 is now a nurse (40 < 60), still on total pay 100;
  # P3/2020's tie still goes to C3, a clerk
  #   clerk tenure 0: P4/2021 stays (0.9)
  #   clerk tenure 1: P3/2020 retires, P1/2021 stays (1.1)
  #   nurse tenure 0: P1/2020 stays (1.1), P2/2020 leaves
  out <- estimate_progression_rates(
    career_personnel(), occupation_contracts(),
    tenure_col = "tenure", salary_col = "pay", group_cols = "occupation",
    select_contract = "lowest_paid"
  )

  expect_equal(out$occupation, c("clerk", "clerk", "nurse"))
  expect_equal(out$pop, c(1L, 2L, 2L))
  expect_equal(out$px, c(1, 0.5, 0.5))
  expect_equal(out$pay_growth, c(-0.1, 0.1, 0.1))
})

test_that("a missing tenure column errors and says how to build one", {
  expect_error(
    estimate_progression_rates(
      career_personnel(), career_contracts(),
      tenure_col = "years_of_service", salary_col = "pay"
    ),
    "years_of_service.*compute_tenure_panel[(][)].*first_employment_date"
  )
})

test_that("a missing pay column errors naming it", {
  expect_error(
    estimate_progression_rates(
      career_personnel(), career_contracts(),
      tenure_col = "tenure", salary_col = "gross_salary_real"
    ),
    "`contracts` is missing required columns: gross_salary_real"
  )
})

test_that("a group column found in both tables errors, since it is ambiguous", {
  personnel <- career_personnel()
  personnel[, occupation := "clerk"]

  expect_error(
    estimate_progression_rates(
      personnel, occupation_contracts(),
      tenure_col = "tenure", salary_col = "pay", group_cols = "occupation"
    ),
    "`occupation` is in both `personnel` and `contracts`"
  )
})

test_that("a group column found in neither table errors naming it", {
  expect_error(
    estimate_progression_rates(
      career_personnel(), career_contracts(),
      tenure_col = "tenure", salary_col = "pay", group_cols = "region"
    ),
    "`region` is in neither `personnel` nor `contracts`"
  )
})

test_that("missing or zero pay drops a person from pay growth but not from exposure", {
  # P1/2021 has pay 0, P2/2020 has NA pay, and P3/2020 has a second
  # contract with NA pay (ignored in the sum, so P3/2020 is still on 100):
  #   tenure 0: P1/2020, P2/2020, P4/2021 exposed, P1 and P4 stay (px 2/3);
  #             only P4 has pay in both years (0.9); mean pay of P1/2020
  #             and P4/2021 is 100 (P2's NA is left out)
  #   tenure 1: P3/2020, P1/2021 exposed, P1 stays (px 1/2); P1 has pay 0
  #             in 2021, so no growth; mean pay is P3's 100 (P1's 0 is
  #             left out)
  contracts <- career_contracts()
  contracts[personnel_id == "P1" & ref_date == as.Date("2021-01-01"), pay := 0]
  contracts[personnel_id == "P2", pay := NA]
  contracts <- rbind(contracts, data.table::data.table(
    contract_id = "C10", personnel_id = "P3",
    ref_date = as.Date("2020-01-01"), pay = NA_real_
  ))

  out <- estimate_progression_rates(
    career_personnel(), contracts, tenure_col = "tenure", salary_col = "pay"
  )

  expect_equal(out$pop, c(3L, 2L))
  expect_equal(out$px, c(2 / 3, 1 / 2))
  expect_equal(out$n_pay, c(1L, 0L))
  expect_equal(out$pay_growth, c(-0.1, NA))
  expect_equal(out$mean_pay, c(100, 100))
})

test_that("pay growth is pooled over all stayers, not averaged across years", {
  # tenure 0: one stayer in 2020->2021 with ratio 1.2, three stayers in
  # 2021->2022 with ratio 1.0. pooled: 1.2^(1/4) - 1; a mean of the two
  # years' growth would give 1.2^(1/2) - 1 instead
  personnel <- data.table::data.table(
    personnel_id = c("A", "A", "B", "C", "D", "B", "C", "D"),
    ref_date = as.Date(c(
      "2020-01-01", "2021-01-01",
      "2021-01-01", "2021-01-01", "2021-01-01",
      "2022-01-01", "2022-01-01", "2022-01-01"
    )),
    employment_status = "active",
    tenure = c(0, 1, 0, 0, 0, 1, 1, 1)
  )
  contracts <- data.table::data.table(
    contract_id = paste0("C", 1:8),
    personnel_id = personnel$personnel_id,
    ref_date = personnel$ref_date,
    pay = c(100, 120, 100, 100, 100, 100, 100, 100)
  )

  out <- estimate_progression_rates(
    personnel, contracts, tenure_col = "tenure", salary_col = "pay"
  )

  expect_equal(out$pay_growth[out$tenure == 0], 1.2^(1 / 4) - 1)
})

test_that("fractional tenure is counted in whole years served", {
  # adding 0.6 to every tenure leaves each person in the same whole year
  personnel <- career_personnel()
  personnel[, tenure := tenure + 0.6]

  out <- estimate_progression_rates(
    personnel, career_contracts(), tenure_col = "tenure", salary_col = "pay"
  )

  expect_equal(out$tenure, c(0L, 1L))
  expect_equal(out$pop, c(3L, 2L))
  expect_equal(out$pay_growth, c(sqrt(0.99) - 1, 0.1))
})

test_that("fewer than 2 snapshots errors", {
  personnel <- career_personnel()[ref_date == as.Date("2020-01-01")]

  expect_error(
    estimate_progression_rates(
      personnel, career_contracts(), tenure_col = "tenure", salary_col = "pay"
    ),
    "`personnel` must contain at least 2 snapshots"
  )
})

test_that("a duplicated personnel row warns and is counted once everywhere", {
  # P2/2020 twice: without de-duplication its pay of 200 would enter the
  # tenure 0 mean pay twice, giving 150 instead of 400 / 3
  personnel <- career_personnel()
  personnel <- rbind(personnel, personnel[personnel_id == "P2"])

  expect_warning(
    out <- estimate_progression_rates(
      personnel, career_contracts(), tenure_col = "tenure", salary_col = "pay"
    ),
    "duplicate"
  )
  expect_equal(out$pop, c(3L, 2L))
  expect_equal(out$n_pay, c(2L, 1L))
  expect_equal(out$mean_pay, c(400 / 3, 105))
})

# ---------------------------------------------------------------------------
# compute_career_table()
# ---------------------------------------------------------------------------
test_that("the service chain matches compute_service_table() with tenure as the age", {
  personnel <- career_personnel()
  personnel[, gender := ifelse(personnel_id %in% c("P1", "P2"), "F", "M")]

  career <- compute_career_table(
    personnel, career_contracts(),
    tenure_col = "tenure", salary_col = "pay", group_cols = "gender",
    radix = 100
  )
  service <- compute_service_table(
    personnel, duration_col = "tenure", status_col = "employment_status",
    personnel_id_col = "personnel_id", ref_date_col = "ref_date",
    group_cols = "gender", radix = 100
  )

  chain_cols <- c("gender", "tenure", "px", "lx", "lx_next", "Lx", "Tx", "ex")
  expect_equal(
    as.data.frame(career)[chain_cols],
    as.data.frame(service)[chain_cols],
    ignore_attr = TRUE
  )
})

# two people hired together in 2020 and followed to 2023, both staying, each
# getting a 10% real raise every year. The 2023 snapshot is the last, so the
# table covers tenures 0, 1 and 2
steady_growth_panel <- function() {
  ids <- rep(c("A", "B"), times = 4)
  dates <- as.Date(rep(c("2020-01-01", "2021-01-01", "2022-01-01", "2023-01-01"), each = 2))
  tenure <- rep(0:3, each = 2)
  list(
    personnel = data.table::data.table(
      personnel_id = ids, ref_date = dates,
      employment_status = "active", tenure = tenure
    ),
    contracts = data.table::data.table(
      contract_id = paste0("C", seq_along(ids)), personnel_id = ids,
      ref_date = dates, pay = 100 * 1.1^tenure
    )
  )
}

test_that("pay is projected by compounding each year's growth from entry_pay", {
  panel <- steady_growth_panel()

  career <- compute_career_table(
    panel$personnel, panel$contracts,
    tenure_col = "tenure", salary_col = "pay", entry_pay = 50
  )

  expect_equal(career$tenure, 0:2)
  expect_equal(career$projected_pay, c(50, 55, 60.5))
  expect_equal(career$pay_index, c(100, 110, 121))
})

test_that("by default each group's pay path starts at the median pay of its new hires", {
  # F new hires: P1/2020 on 100, P2/2020 on 200, so the median is 150, then
  # +10% (P1). M new hires: P4/2021 on 100, then -10%
  personnel <- career_personnel()
  personnel[, gender := ifelse(personnel_id %in% c("P1", "P2"), "F", "M")]

  career <- compute_career_table(
    personnel, career_contracts(),
    tenure_col = "tenure", salary_col = "pay", group_cols = "gender"
  )

  expect_equal(career$projected_pay, c(150, 165, 100, 90))
})

test_that("expected earnings add up years served times projected pay over the rest of the career", {
  # radix 100; px is 2/3 then 1/2, so lx is 100 and 200/3, Lx is 250/3 and
  # 50; starting pay is the new hires' median, 100, then grows by
  # sqrt(0.99). From tenure t, earnings are sum(Lx * pay) from t on / lx(t)
  career <- compute_career_table(
    career_personnel(), career_contracts(),
    tenure_col = "tenure", salary_col = "pay", radix = 100
  )

  pay_1 <- 100 * sqrt(0.99)
  expect_equal(
    career$expected_earnings,
    c((250 / 3 * 100 + 50 * pay_1) / 100, 50 * pay_1 / (200 / 3))
  )
})

test_that("include_all = FALSE keeps only the essential columns", {
  personnel <- career_personnel()
  personnel[, gender := ifelse(personnel_id %in% c("P1", "P2"), "F", "M")]
  args <- list(
    personnel, career_contracts(),
    tenure_col = "tenure", salary_col = "pay", group_cols = "gender"
  )

  full <- do.call(compute_career_table, args)
  short <- do.call(compute_career_table, c(args, include_all = FALSE))

  expect_named(short, c("gender", "tenure", "px", "ex", "pay_growth", "projected_pay"))
  expect_equal(as.data.frame(short), as.data.frame(full)[names(short)], ignore_attr = TRUE)
  expect_true(all(c("pop", "lx", "Tx", "pay_index", "expected_earnings", "mean_pay") %in% names(full)))
})

# two snapshots, 2020 and 2021. A is a new hire (tenure 0) and B is at tenure
# 2; both stay with a 10% raise. Nobody is at tenure 1, a gap in the table
gapped_career_panel <- function() {
  list(
    personnel = data.table::data.table(
      personnel_id = c("A", "B", "A", "B"),
      ref_date = as.Date(c("2020-01-01", "2020-01-01", "2021-01-01", "2021-01-01")),
      employment_status = "active",
      tenure = c(0, 2, 1, 3)
    ),
    contracts = data.table::data.table(
      contract_id = c("C1", "C2", "C3", "C4"),
      personnel_id = c("A", "B", "A", "B"),
      ref_date = as.Date(c("2020-01-01", "2020-01-01", "2021-01-01", "2021-01-01")),
      pay = c(100, 200, 110, 220)
    )
  )
}

test_that("a tenure gap warns and is filled by smoothing, so the pay path is unbroken", {
  panel <- gapped_career_panel()

  expect_warning(
    career <- compute_career_table(
      panel$personnel, panel$contracts, tenure_col = "tenure", salary_col = "pay"
    ),
    "gap"
  )
  # growth of 10% at tenures 0 and 2 is interpolated to 10% at tenure 1;
  # pay starts at the tenure 0 median, 100
  expect_equal(career$tenure, 0:2)
  expect_equal(career$px, c(1, 1, 1))
  expect_equal(career$projected_pay, c(100, 110, 121))
})

test_that("smooth = TRUE fills the gap up front, without a warning", {
  panel <- gapped_career_panel()

  expect_no_warning(
    career <- compute_career_table(
      panel$personnel, panel$contracts, tenure_col = "tenure", salary_col = "pay",
      smooth = TRUE
    )
  )
  expect_equal(career$projected_pay, c(100, 110, 121))
})

test_that("a tenure with people but no measurable pay growth also warns and is filled", {
  # tenure 1 has C, who leaves, so it has a px but no pay growth
  panel <- gapped_career_panel()
  panel$personnel <- rbind(panel$personnel, data.table::data.table(
    personnel_id = "C", ref_date = as.Date("2020-01-01"),
    employment_status = "active", tenure = 1
  ))
  panel$contracts <- rbind(panel$contracts, data.table::data.table(
    contract_id = "C5", personnel_id = "C",
    ref_date = as.Date("2020-01-01"), pay = 150
  ))

  expect_warning(
    career <- compute_career_table(
      panel$personnel, panel$contracts, tenure_col = "tenure", salary_col = "pay"
    ),
    "gap"
  )
  expect_equal(career$px, c(1, 0, 1))
  expect_equal(career$projected_pay, c(100, 110, 121))
})

test_that("a group with no new hires starts at its first tenure, with a warning naming it", {
  # M is only P3, first seen at tenure 1 on pay 100, so M's path starts at
  # tenure 1 on 100. F (P1, P2, P4) has new hires and starts at tenure 0
  personnel <- career_personnel()
  personnel[, gender := ifelse(personnel_id == "P3", "M", "F")]

  expect_warning(
    career <- compute_career_table(
      personnel, career_contracts(),
      tenure_col = "tenure", salary_col = "pay", group_cols = "gender"
    ),
    "gender = M.*tenure 1"
  )
  expect_equal(career$gender, c("F", "F", "M"))
  expect_equal(career$start_tenure, c(0L, 0L, 1L))
  expect_equal(career$projected_pay[career$gender == "M"], 100)
})

test_that("a person-year with no tenure is left out of exposure, with a warning, but still counts as staying", {
  # P1/2021 has no tenure: it drops out of tenure 1, but P1/2020 still
  # stayed (P1 is active in 2021) and grew 100 -> 110
  #   tenure 0: P1/2020, P2/2020, P4/2021 exposed, P1 and P4 stay
  #   tenure 1: only P3/2020, who retires
  personnel <- career_personnel()
  personnel[personnel_id == "P1" & ref_date == as.Date("2021-01-01"), tenure := NA]

  expect_warning(
    out <- estimate_progression_rates(
      personnel, career_contracts(), tenure_col = "tenure", salary_col = "pay"
    ),
    "1 active person-year.*no `tenure`"
  )
  expect_equal(out$tenure, c(0L, 1L))
  expect_equal(out$pop, c(3L, 1L))
  expect_equal(out$px, c(2 / 3, 0))
  expect_equal(out$pay_growth, c(sqrt(0.99) - 1, NA))
})

test_that("someone missing for a year adds no pay growth across the gap", {
  # A is away in 2021 and back in 2022 on 150: that is a leave and a
  # return, not a raise. B stays 100 -> 110
  personnel <- data.table::data.table(
    personnel_id = c("A", "B", "B", "A", "B"),
    ref_date = as.Date(c("2020-01-01", "2020-01-01", "2021-01-01", "2022-01-01", "2022-01-01")),
    employment_status = "active",
    tenure = c(0, 0, 1, 2, 2)
  )
  contracts <- data.table::data.table(
    contract_id = paste0("C", 1:5),
    personnel_id = personnel$personnel_id,
    ref_date = personnel$ref_date,
    pay = c(100, 100, 110, 150, 121)
  )

  out <- estimate_progression_rates(
    personnel, contracts, tenure_col = "tenure", salary_col = "pay"
  )

  expect_equal(out$n_pay[out$tenure == 0], 1L)
  expect_equal(out$pay_growth[out$tenure == 0], 0.1)
})

test_that("someone who retires adds no pay growth, even if paid in retirement", {
  # P3 retires in 2021 on a pension contract of 80; only P1 grows at tenure 1
  contracts <- rbind(career_contracts(), data.table::data.table(
    contract_id = "C11", personnel_id = "P3",
    ref_date = as.Date("2021-01-01"), pay = 80
  ))

  out <- estimate_progression_rates(
    career_personnel(), contracts, tenure_col = "tenure", salary_col = "pay"
  )

  expect_equal(out$n_pay[out$tenure == 1], 1L)
  expect_equal(out$pay_growth[out$tenure == 1], 0.1)
})

test_that("no warning when every group has new hires and only its last year lacks growth", {
  # M (P3, P4) has a new hire, P4, and its last tenure (P3, who retires)
  # has no growth -- which is never used, so it is not a gap
  personnel <- career_personnel()
  personnel[, gender := ifelse(personnel_id %in% c("P1", "P2"), "F", "M")]

  expect_no_warning(
    compute_career_table(
      personnel, career_contracts(),
      tenure_col = "tenure", salary_col = "pay", group_cols = "gender"
    )
  )
})

test_that("the caller's tables are not changed", {
  personnel <- career_personnel()
  contracts <- occupation_contracts()
  personnel_before <- data.table::copy(personnel)
  contracts_before <- data.table::copy(contracts)

  compute_career_table(
    personnel, contracts,
    tenure_col = "tenure", salary_col = "pay", group_cols = "occupation"
  )

  expect_identical(personnel, personnel_before)
  expect_identical(contracts, contracts_before)
})

test_that("without groups, a panel with no new hires warns that the whole table starts later", {
  personnel <- career_personnel()[tenure > 0]
  contracts <- career_contracts()

  expect_warning(
    career <- compute_career_table(
      personnel, contracts, tenure_col = "tenure", salary_col = "pay"
    ),
    "the table [(]from tenure 1[)]"
  )
  expect_equal(career$start_tenure[1], 1L)
})
