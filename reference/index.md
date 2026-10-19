# Package index

## Harmonization

`R/harmonize.R`: align column names, identifiers and values across
sources.

- [`find_inconsistent_colnames()`](https://wb-pida-data-science-shop.github.io/govhr/reference/find_inconsistent_colnames.md)
  : Identify inconsistent column names across data frames
- [`detect_inconsistent_cols()`](https://wb-pida-data-science-shop.github.io/govhr/reference/detect_inconsistent_cols.md)
  : Detect inconsistent columns in a data frame
- [`harmonize_columns()`](https://wb-pida-data-science-shop.github.io/govhr/reference/harmonize_columns.md)
  : Harmonize column names based on a dictionary
- [`find_duplicate_ids()`](https://wb-pida-data-science-shop.github.io/govhr/reference/find_duplicate_ids.md)
  : Find duplicate identifiers in a data frame
- [`dedup_values()`](https://wb-pida-data-science-shop.github.io/govhr/reference/dedup_values.md)
  : Deduplicate values within grouped data
- [`complete_columns()`](https://wb-pida-data-science-shop.github.io/govhr/reference/complete_columns.md)
  : Complete columns in a dataframe
- [`guess_date_frequency()`](https://wb-pida-data-science-shop.github.io/govhr/reference/guess_date_frequency.md)
  : Guess the reporting frequency of the reference dates
- [`convert_constant_ppp()`](https://wb-pida-data-science-shop.github.io/govhr/reference/convert_constant_ppp.md)
  : Convert nominal wages to real PPP-adjusted wages (2021 base year)
- [`deflate_to_real()`](https://wb-pida-data-science-shop.github.io/govhr/reference/deflate_to_real.md)
  : Deflate a nominal LCU column to real values

## Data treatment

`R/treatment.R`: remove duplicates and fix invalid records.

- [`clean_hr_data()`](https://wb-pida-data-science-shop.github.io/govhr/reference/clean_hr_data.md)
  : Apply Standard HR data cleaning pipeline
- [`remove_duplicate_personnel()`](https://wb-pida-data-science-shop.github.io/govhr/reference/remove_duplicate_personnel.md)
  : Remove duplicate personnel records
- [`remove_duplicate_contracts()`](https://wb-pida-data-science-shop.github.io/govhr/reference/remove_duplicate_contracts.md)
  : Remove duplicate contract records
- [`fix_invalid_dates()`](https://wb-pida-data-science-shop.github.io/govhr/reference/fix_invalid_dates.md)
  : Fix invalid reference dates
- [`fix_invalid_birthdates()`](https://wb-pida-data-science-shop.github.io/govhr/reference/fix_invalid_birthdates.md)
  : Fix invalid birth dates
- [`fix_underage_workers()`](https://wb-pida-data-science-shop.github.io/govhr/reference/fix_underage_workers.md)
  : Flag or remove underage workers
- [`fix_retirement_age()`](https://wb-pida-data-science-shop.github.io/govhr/reference/fix_retirement_age.md)
  : Flag or adjust over-retirement-age workers
- [`fix_working_hours()`](https://wb-pida-data-science-shop.github.io/govhr/reference/fix_working_hours.md)
  : Fix invalid working hours
- [`fix_salary_components()`](https://wb-pida-data-science-shop.github.io/govhr/reference/fix_salary_components.md)
  : Fix salary component inconsistencies
- [`fix_negative_salaries()`](https://wb-pida-data-science-shop.github.io/govhr/reference/fix_negative_salaries.md)
  : Fix negative salary values

## Validation

`R/validation.R`: check data against quality rules.

- [`validate_data()`](https://wb-pida-data-science-shop.github.io/govhr/reference/validate_data.md)
  : Validate Data Quality Using Rule-Based Framework

## Coverage

`R/coverage.R`: how complete each column is.

- [`compute_coverage()`](https://wb-pida-data-science-shop.github.io/govhr/reference/compute_coverage.md)
  : Compute data coverage
- [`compute_global_coverage()`](https://wb-pida-data-science-shop.github.io/govhr/reference/compute_global_coverage.md)
  : Compute global coverage

## Consistency

`R/consistency.R`: how consistent records and values are over time.

- [`compute_record_consistency()`](https://wb-pida-data-science-shop.github.io/govhr/reference/compute_record_consistency.md)
  : Compute record consistency
- [`compute_value_consistency()`](https://wb-pida-data-science-shop.github.io/govhr/reference/compute_value_consistency.md)
  : Compute value consistency
- [`compute_global_consistency()`](https://wb-pida-data-science-shop.github.io/govhr/reference/compute_global_consistency.md)
  : Compute global consistency

## Quality check plots

`R/qcheck_plots.R`: plot coverage and consistency.

- [`plot_coverage_trend()`](https://wb-pida-data-science-shop.github.io/govhr/reference/plot_coverage_trend.md)
  : Plot coverage over time
- [`plot_coverage_bar()`](https://wb-pida-data-science-shop.github.io/govhr/reference/plot_coverage_bar.md)
  : Plot coverage by variable
- [`plot_coverage_heatmap()`](https://wb-pida-data-science-shop.github.io/govhr/reference/plot_coverage_heatmap.md)
  : Plot coverage by variable and group
- [`plot_consistency_trend()`](https://wb-pida-data-science-shop.github.io/govhr/reference/plot_consistency_trend.md)
  : Plot consistency over time
- [`plot_consistency_heatmap()`](https://wb-pida-data-science-shop.github.io/govhr/reference/plot_consistency_heatmap.md)
  : Plot value consistency by variable and group

## Headcount

`R/headcount.R`

- [`compute_headcount()`](https://wb-pida-data-science-shop.github.io/govhr/reference/compute_headcount.md)
  : Compute headcount by group

## Overview

`R/overview.R`: trends, cross-sections and growth by group.

- [`count_entity()`](https://wb-pida-data-science-shop.github.io/govhr/reference/count_entity.md)
  : Count unique entities by group
- [`compute_trend_summary()`](https://wb-pida-data-science-shop.github.io/govhr/reference/compute_trend_summary.md)
  : Compute trend summary
- [`apply_baseline_index()`](https://wb-pida-data-science-shop.github.io/govhr/reference/apply_baseline_index.md)
  : Apply baseline index to a trend summary
- [`compute_cross_section_summary()`](https://wb-pida-data-science-shop.github.io/govhr/reference/compute_cross_section_summary.md)
  : Compute cross-section summary
- [`plot_trend()`](https://wb-pida-data-science-shop.github.io/govhr/reference/plot_trend.md)
  : Plot time trend
- [`plot_bar_total()`](https://wb-pida-data-science-shop.github.io/govhr/reference/plot_bar_total.md)
  : Plot totals by group
- [`plot_bar_growth()`](https://wb-pida-data-science-shop.github.io/govhr/reference/plot_bar_growth.md)
  : Plot growth rates by group

## Movement

`R/movement.R`: hires, separations and retirements, and their cost.

- [`detect_movement()`](https://wb-pida-data-science-shop.github.io/govhr/reference/detect_movement.md)
  : Detect hires and separations
- [`compute_movement()`](https://wb-pida-data-science-shop.github.io/govhr/reference/compute_movement.md)
  : Compute movements as hires and separations
- [`compute_movement_cost()`](https://wb-pida-data-science-shop.github.io/govhr/reference/compute_movement_cost.md)
  : Compute the cost of hires and separations
- [`detect_retirement()`](https://wb-pida-data-science-shop.github.io/govhr/reference/detect_retirement.md)
  : Detect retirements
- [`compute_retirement()`](https://wb-pida-data-science-shop.github.io/govhr/reference/compute_retirement.md)
  : Compute retirements
- [`compute_retirement_cost()`](https://wb-pida-data-science-shop.github.io/govhr/reference/compute_retirement_cost.md)
  : Compute the cost of retirements
- [`detect_personnel_event()`](https://wb-pida-data-science-shop.github.io/govhr/reference/detect_personnel_event.md)
  : Detect Personnel Events
- [`complete_dates()`](https://wb-pida-data-science-shop.github.io/govhr/reference/complete_dates.md)
  : Complete panel data by identifier and reference dates

## Transitions

`R/transition.R`: moves between groups, such as paygrades.

- [`detect_transition()`](https://wb-pida-data-science-shop.github.io/govhr/reference/detect_transition.md)
  : Detect transitions
- [`compute_transition()`](https://wb-pida-data-science-shop.github.io/govhr/reference/compute_transition.md)
  : Compute career transitions
- [`plot_transition_network()`](https://wb-pida-data-science-shop.github.io/govhr/reference/plot_transition_network.md)
  : Plot transition network

## Retirement projections

`R/retirement.R`

- [`project_retirement()`](https://wb-pida-data-science-shop.github.io/govhr/reference/project_retirement.md)
  : Project retirements of the current workforce
- [`add_contract_to_event()`](https://wb-pida-data-science-shop.github.io/govhr/reference/add_contract_to_event.md)
  : Add contract information to event records
- [`compute_pension_ratio()`](https://wb-pida-data-science-shop.github.io/govhr/reference/compute_pension_ratio.md)
  : Compute ratio of last salary to first pension for retired workers

## Demographics

`R/demographics.R`: decrement rates and service tables.

- [`estimate_decrement_rates()`](https://wb-pida-data-science-shop.github.io/govhr/reference/estimate_decrement_rates.md)
  : Estimate empirical decrement rates from a personnel panel
- [`smooth_decrement_rates()`](https://wb-pida-data-science-shop.github.io/govhr/reference/smooth_decrement_rates.md)
  : Graduate (smooth and gap-fill) empirical decrement rates
- [`compute_service_table()`](https://wb-pida-data-science-shop.github.io/govhr/reference/compute_service_table.md)
  : Compute an actuarial service table from a personnel panel

## Workforce analytics

`R/workforce.R`: the standard workforce indicators in one call.

- [`compute_workforce_analytics()`](https://wb-pida-data-science-shop.github.io/govhr/reference/compute_workforce_analytics.md)
  : Compute standard workforce indicators

## Wages

`R/wage.R`

- [`compute_wage()`](https://wb-pida-data-science-shop.github.io/govhr/reference/compute_wage.md)
  : Compute the average wage

## Wage distribution

`R/distribution.R`

- [`compute_percentile()`](https://wb-pida-data-science-shop.github.io/govhr/reference/compute_percentile.md)
  : Compute the percentile of a measure
- [`compute_decile()`](https://wb-pida-data-science-shop.github.io/govhr/reference/compute_decile.md)
  : Compute deciles of a measure

## Wage models

`R/wage_model.R`

- [`model_wage()`](https://wb-pida-data-science-shop.github.io/govhr/reference/model_wage.md)
  : Fit a wage model with fixed effects
- [`plot_model_wage()`](https://wb-pida-data-science-shop.github.io/govhr/reference/plot_model_wage.md)
  : Plot a wage model fit
- [`plot_model_wage_fes()`](https://wb-pida-data-science-shop.github.io/govhr/reference/plot_model_wage_fes.md)
  : Plot fixed effects from a wage model fit

## Wage bill

`R/wagebill_total.R`

- [`compute_wagebill()`](https://wb-pida-data-science-shop.github.io/govhr/reference/compute_wagebill.md)
  : Compute the wagebill

## Wage bill growth

`R/wagebill_growth.R`: decompose wage bill and wage growth.

- [`compute_growth_decomposition()`](https://wb-pida-data-science-shop.github.io/govhr/reference/compute_growth_decomposition.md)
  : Compute growth decomposition of wagebill
- [`compute_wage_decomposition()`](https://wb-pida-data-science-shop.github.io/govhr/reference/compute_wage_decomposition.md)
  : Decompose average-wage growth

## Wage bill analytics

`R/wagebill.R`: the standard wage bill indicators in one call.

- [`compute_wagebill_analytics()`](https://wb-pida-data-science-shop.github.io/govhr/reference/compute_wagebill_analytics.md)
  : Compute standard wagebill indicators

## Reports

`R/report.R`

- [`generate_standard_report()`](https://wb-pida-data-science-shop.github.io/govhr/reference/generate_standard_report.md)
  : Generate the standard HR report

## Summary helpers

`R/summarize.R`: fast grouped summaries and summary statistics.

- [`compute_fastsummary()`](https://wb-pida-data-science-shop.github.io/govhr/reference/compute_fastsummary.md)
  : Compute Fast Summary Statistics by Group
- [`compute_fastshare()`](https://wb-pida-data-science-shop.github.io/govhr/reference/compute_fastshare.md)
  : Compute ratio indicators of summarized variables over macro
  indicators
- [`compute_fastchange()`](https://wb-pida-data-science-shop.github.io/govhr/reference/compute_fastchange.md)
  : Calculate year-over-year growth for a numeric column
- [`fastcount()`](https://wb-pida-data-science-shop.github.io/govhr/reference/fastcount.md)
  : Fast counting via dtplyr
- [`fastprop()`](https://wb-pida-data-science-shop.github.io/govhr/reference/fastprop.md)
  : Compute group-wise proportions from counts
- [`compute_baseline_index()`](https://wb-pida-data-science-shop.github.io/govhr/reference/compute_baseline_index.md)
  : Compute index values relative to base year
- [`compute_quantile()`](https://wb-pida-data-science-shop.github.io/govhr/reference/compute_quantile.md)
  : Function to compute quantiles of a measure column within groups and
  reference dates
- [`compute_growth()`](https://wb-pida-data-science-shop.github.io/govhr/reference/compute_growth.md)
  : Compute growth rate summary table
- [`compute_compression_ratio()`](https://wb-pida-data-science-shop.github.io/govhr/reference/compute_compression_ratio.md)
  : Compute the compression ratio of a measure
- [`define_fns()`](https://wb-pida-data-science-shop.github.io/govhr/reference/define_fns.md)
  : Define default summary functions
- [`cv()`](https://wb-pida-data-science-shop.github.io/govhr/reference/cv.md)
  : Compute the coefficient of variation (CV)
- [`cp_ratio()`](https://wb-pida-data-science-shop.github.io/govhr/reference/cp_ratio.md)
  : Compute a compression ratio between two percentiles
- [`count_unique()`](https://wb-pida-data-science-shop.github.io/govhr/reference/count_unique.md)
  : Count unique non-missing values

## Plot helpers

`R/plots.R`

- [`scale_plot_height()`](https://wb-pida-data-science-shop.github.io/govhr/reference/scale_plot_height.md)
  : Plot Height for a Grouped Bar Chart
- [`ggplot_point_line()`](https://wb-pida-data-science-shop.github.io/govhr/reference/ggplot_point_line.md)
  : Plot grouped line chart with labeled points
- [`ggplot_segment()`](https://wb-pida-data-science-shop.github.io/govhr/reference/ggplot_segment.md)
  : Plot segments overlaid with points, ordered by median
- [`ggplot_coef()`](https://wb-pida-data-science-shop.github.io/govhr/reference/ggplot_coef.md)
  : Plot model coefficients with confidence intervals
- [`plot_segment()`](https://wb-pida-data-science-shop.github.io/govhr/reference/plot_segment.md)
  : Create a segment plot with jittered points
- [`plot_movement()`](https://wb-pida-data-science-shop.github.io/govhr/reference/plot_movement.md)
  : Plot hires or separations over time
- [`plot_movement_cost()`](https://wb-pida-data-science-shop.github.io/govhr/reference/plot_movement_cost.md)
  : Plot movement cost
- [`plot_decile()`](https://wb-pida-data-science-shop.github.io/govhr/reference/plot_decile.md)
  : Plot decile summary
- [`plot_histogram()`](https://wb-pida-data-science-shop.github.io/govhr/reference/plot_histogram.md)
  : Plot density as percentage share
- [`plot_compression_ratio()`](https://wb-pida-data-science-shop.github.io/govhr/reference/plot_compression_ratio.md)
  : Plot compression ratio

## Sampling

`R/sample.R`

- [`sample_group()`](https://wb-pida-data-science-shop.github.io/govhr/reference/sample_group.md)
  : Sample groups and return all rows for those groups

## Data360 API

`R/data360api.R`: download World Bank Data360 datasets.

- [`get_data360_api()`](https://wb-pida-data-science-shop.github.io/govhr/reference/get_data360_api.md)
  : This function retrieves data from the Data360 API.
- [`pivot_data360()`](https://wb-pida-data-science-shop.github.io/govhr/reference/pivot_data360.md)
  : Pivot Data360 dataset to wide format
- [`get_metadata360()`](https://wb-pida-data-science-shop.github.io/govhr/reference/get_metadata360.md)
  : Retrieve dataset metadata from the World Bank Data360 API

## Datasets

`R/data.R`

- [`bra_hrmis`](https://wb-pida-data-science-shop.github.io/govhr/reference/bra_hrmis.md)
  : Brazilian Public Employee Payroll Data
- [`bra_hrmis_personnel`](https://wb-pida-data-science-shop.github.io/govhr/reference/bra_hrmis_personnel.md)
  : HRMIS Personnel Dataset
- [`bra_hrmis_contract`](https://wb-pida-data-science-shop.github.io/govhr/reference/bra_hrmis_contract.md)
  : HRMIS Contract Dataset
- [`bra_hrmis_allowance`](https://wb-pida-data-science-shop.github.io/govhr/reference/bra_hrmis_allowance.md)
  : Brazil HRMIS Allowance Module
- [`bra_hrmis_est`](https://wb-pida-data-science-shop.github.io/govhr/reference/bra_hrmis_est.md)
  : HRMIS Establishment Dataset
- [`dictionary`](https://wb-pida-data-science-shop.github.io/govhr/reference/dictionary.md)
  : Harmonization Dictionary for Payroll and HRMIS Data
- [`contract_rules`](https://wb-pida-data-science-shop.github.io/govhr/reference/contract_rules.md)
  : Contract Validation Rules
- [`personnel_rules`](https://wb-pida-data-science-shop.github.io/govhr/reference/personnel_rules.md)
  : Personnel Validation Rules
- [`cpi`](https://wb-pida-data-science-shop.github.io/govhr/reference/cpi.md)
  : Monthly consumer price index (CPI) by country
- [`countryclass`](https://wb-pida-data-science-shop.github.io/govhr/reference/countryclass.md)
  : World Bank Country and Lending Groups
- [`macro_indicators`](https://wb-pida-data-science-shop.github.io/govhr/reference/macro_indicators.md)
  : Macro-level World Bank WDI indicators
- [`wwbi`](https://wb-pida-data-science-shop.github.io/govhr/reference/wwbi.md)
  : Worldwide Bureaucracy Indicators
- [`enterprise_surveys`](https://wb-pida-data-science-shop.github.io/govhr/reference/enterprise_surveys.md)
  : World Bank Enterprise Surveys
- [`social_sustainability`](https://wb-pida-data-science-shop.github.io/govhr/reference/social_sustainability.md)
  : Social Sustainability Global Database
- [`cofog_taxonomy`](https://wb-pida-data-science-shop.github.io/govhr/reference/cofog_taxonomy.md)
  : COFOG Functional Classification Taxonomy
- [`isco`](https://wb-pida-data-science-shop.github.io/govhr/reference/isco.md)
  : International Standard Classification of Occupations (ISCO-08)
