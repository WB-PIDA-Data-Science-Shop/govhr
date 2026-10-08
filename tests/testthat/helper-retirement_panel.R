# shared by the compute_retirement(), detect_movement() and detect_retirement()
# tests
#
# p1 retires in 2021, pensioner in 2022
# p2 leaves in 2020 without a pension
# p3 stays throughout, with two contracts in 2020
# p4 draws a pension alongside an active contract, so never leaves
# p5 retires in 2020, pensioner in 2021
# p6 retires in 2020, but the pension is only registered in 2022
# p7 leaves in 2020 and returns in 2022 before any pension, so only the 2022
#   exit is a retirement
retirement_panel <- utils::read.csv(
  text = "
personnel_id,ref_date,employment_status,unit
p1,2020-01-01,active,A
p2,2020-01-01,active,A
p3,2020-01-01,active,B
p3,2020-01-01,active,B
p4,2020-01-01,active,B
p5,2020-01-01,active,B
p6,2020-01-01,active,A
p7,2020-01-01,active,A
p1,2021-01-01,active,A
p3,2021-01-01,active,B
p4,2021-01-01,active,B
p4,2021-01-01,pensioner,B
p5,2021-01-01,pensioner,B
p1,2022-01-01,pensioner,A
p3,2022-01-01,active,B
p4,2022-01-01,active,B
p6,2022-01-01,pensioner,A
p7,2022-01-01,active,A
p3,2023-01-01,active,B
p4,2023-01-01,active,B
p7,2023-01-01,pensioner,A
",
  colClasses = c(ref_date = "Date")
)
