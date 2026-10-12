################################################################
#### CHECK OUT HOW THESE CAREER PROGRESSION FUNCTIONS WORK #####
################################################################
library(ggplot2)
library(patchwork)
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


### house style: theme_bw with a black frame and long outward ticks
pretty_plot <- function(lp = "top") {
  theme_bw() +
    theme(
      panel.border = element_rect(colour = "black", linewidth = 0.5, fill = NA),
      axis.ticks = element_line(colour = "black", linewidth = 0.25),
      axis.ticks.length = unit(0.4, "lines"),
      panel.grid.major = element_line(linewidth = 0.25),
      legend.position = lp,
      legend.margin = margin(t = 0, b = 2, unit = "pt")
    )
}

### one row per gender and year of service, with readable labels
plot_dt <- career_dt[, .(
  gender = fifelse(gender == "FEMININO", "Women", "Men"),
  personnel_tenure,
  pay_growth,
  projected_pay
)]
gender_colours <- c(Women = "orange", Men = "dodgerblue4")

### left: real pay growth from each year of service to the next
p_growth <- ggplot(plot_dt, aes(x = personnel_tenure, y = pay_growth, colour = gender)) +
  geom_hline(yintercept = 0, linewidth = 0.25, linetype = "dashed") +
  geom_line(linewidth = 0.8) +
  scale_x_continuous(n.breaks = 7, expand = c(0.02, 0)) +
  scale_y_continuous(n.breaks = 7, labels = scales::label_percent(accuracy = 0.1)) +
  scale_colour_manual(values = gender_colours) +
  labs(x = "Years of service", y = "Real pay growth per year", colour = NULL) +
  pretty_plot()

### right: pay path for a typical new hire who stays, compounding that growth
p_pay <- ggplot(plot_dt, aes(x = personnel_tenure, y = projected_pay, colour = gender)) +
  geom_line(linewidth = 0.8) +
  scale_x_continuous(n.breaks = 7, expand = c(0.02, 0)) +
  scale_y_continuous(n.breaks = 7, labels = scales::label_comma()) +
  scale_colour_manual(values = gender_colours) +
  labs(
    x = "Years of service",
    y = "Projected monthly pay\n(BRL, Dec 2021 prices)",
    colour = NULL
  ) +
  pretty_plot()

### side by side, one shared legend on top
p_career <- p_growth + p_pay +
  plot_layout(guides = "collect") &
  theme(legend.position = "top")

print(p_career)

### save as a vector pdf
pdf("data-raw/bench/career_progression_gender.pdf", width = 10, height = 4)
print(p_career)
dev.off()