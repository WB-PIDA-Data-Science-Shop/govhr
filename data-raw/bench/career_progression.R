################################################################
#### CHECK OUT HOW THESE CAREER PROGRESSION FUNCTIONS WORK #####
################################################################
library(ggplot2)
library(dplyr)
### lets do this

contract_dt <- copy(as.data.table(bra_hrmis_contract))
personnel_dt <- copy(as.data.table(bra_hrmis_personnel))

### real pay (December 2021 prices), so pay growth is not just inflation
contract_dt[, gross_salary_real := deflate_to_real(gross_salary_lcu, ref_date, "BRA")]

### compute tenure
tenure_dt <-
compute_tenure_panel(contracts = contract_dt,
                      group_cols = "personnel_id") |>
  (\(dt) dt[, !duplicated(names(dt)), with = FALSE])() |>
  dplyr::select(personnel_id, ref_date, tenure_years) |>
  setnames(old = "tenure_years", new = "personnel_tenure")

personnel_dt <- tenure_dt[personnel_dt, on = c("personnel_id", "ref_date")]

### ok lets compute career trajectories and progression
career_dt <- compute_career_table(personnel = personnel_dt, 
                                  contracts = contract_dt,
                                  tenure_col = "personnel_tenure",
                                  salary_col = "gross_salary_real",
                                  group_cols = c("gender"),
                                  smooth = TRUE)

################################################################
#### PLOT: PAY GROWTH AND PROJECTED PAY, WOMEN VS MEN      #####
################################################################

### plot() draws a career_table: pay growth and projected pay by default,
### dots sized by the people behind each year's estimate. it returns a
### ggplot, so the colours, labels and pay units are added on top
gender_colours <- c(FEMININO = "orange", MASCULINO = "dodgerblue4")

p_career <- plot(career_dt) +
  scale_colour_manual(
    values = gender_colours,
    labels = c(FEMININO = "Women", MASCULINO = "Men")
  ) +
  labs(caption = "Pay is monthly, in BRL at December 2021 prices.")

print(p_career)

### the same, with expected years of service left
print(plot(career_dt, which = c("pay_growth", "projected_pay", "ex")))

### save as a vector pdf
pdf("data-raw/bench/career_progression_gender.pdf", width = 10, height = 4.5)
print(p_career)
dev.off()
