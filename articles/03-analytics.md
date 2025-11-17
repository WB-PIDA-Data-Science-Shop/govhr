# HR Analytics

## Overview

This article shows examples for how to analyze harmonized human resource
management information system (HRMIS) data, organized into three main
modules: Organization, Worker, and Contract. The contents of each module
are described in `vignette("standard_dictionary")`

## Building analytics on harmonized data

Because we have already cleaned and harmonized the HRMIS data shared by
the Government of Brazil, we can use standard functions to produce
analytical outputs. This is fast and reliable because the function knows
what to data formats to expect and produces summary statistics in a
consistent way.

``` r
library(govhr)
```

Let’s start with the contract module. Suppose we are interested in
computing the overall wage bill and its evolution over time. We can do
it quickly with this convenient function:

``` r
wagebill_annual <-
  bra_hrmis_contract |> 
    compute_fastsummary(
      cols = c("net_salary_ppp"), 
      fns = c("sum"), 
      groups = c("year"), 
      output = "long"
    )

reactable(
  wagebill_annual
)
```

There is no salary data for the year of 2018, therefore we can’t compute
the wage bill for that year.

We can quickly visualize the annual wage bill.

``` r
wagebill_annual |> 
  filter(
    year != 2018
  ) |> 
  ggplot_point_line(
    year,
    value
  ) +
  scale_y_continuous(
    labels = scales::label_number()
  ) +
  labs(
    x = "Year",
    y = "Wage Bill \n(Constant International Dollars)",
    title = "Wage Bill: Annual"
  )
```

![Plot of wage bill at the annual
level.](03-analytics_files/figure-html/unnamed-chunk-3-1.png)

Now imagine you want to unpack the wage bill. Suppose you are interested
in a decomposition by establishment. You can quickly do that with our
function, like this:

``` r
wagebill_annual_org <-
  bra_hrmis_contract |> 
    compute_fastsummary(
      cols = c("net_salary_ppp"), 
      fns = c("sum"), 
      groups = c("org_id", "year"), 
      output = "long"
    )

reactable(
  wagebill_annual_org
)
```

We just have to add `"org_id"` to the groups argument. We can quickly
plot this new object:

``` r
wagebill_annual_org |> 
  filter(
    year != 2018 &
      org_id %in% (unique(wagebill_annual_org$org_id) |> sample(4))
  ) |>
  ggplot_point_line(
    year,
    value,
    group = org_id
  ) +
  scale_y_continuous(
    labels = scales::label_number()
  ) +
  facet_wrap(
    vars(org_id)
  ) +
  labs(
    x = "Year",
    y = "Wage Bill \n(Constant International Dollars)",
    title = "Wage Bill: Annual, by Organization"
  )
```

![Plot of wage bill at the annual level and organizational
level.](03-analytics_files/figure-html/unnamed-chunk-5-1.png)
