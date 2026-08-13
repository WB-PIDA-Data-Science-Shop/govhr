
# govhr <a href="https://wb-pida-data-science-shop.github.io/govhr/"><img src="man/figures/logo.png" align="right" height="120" alt="govhr website" /></a>

<!-- README.md is generated from README.Rmd. Please edit that file -->

<!-- badges: start -->

[![R-CMD-check](https://github.com/WB-PIDA-Data-Science-Shop/govhr/actions/workflows/R-CMD-check.yaml/badge.svg)](https://github.com/WB-PIDA-Data-Science-Shop/govhr/actions/workflows/R-CMD-check.yaml)
[![Codecov test
coverage](https://codecov.io/gh/WB-PIDA-Data-Science-Shop/govhr/graph/badge.svg)](https://app.codecov.io/gh/WB-PIDA-Data-Science-Shop/govhr)
<!-- badges: end -->

Governments generate large amounts of data on their public sector workforce and payroll. However, leveraging those data to generate actionable analytics is challenging. `govhr` is here to help.

The goals of `govhr` is to provide a set of open-source tools that:

1.  Provide a standard approach to harmonizing human resources data.
2.  Produce workforce and wagebill analytics in a standard, but customizable, format.

`govhr` is based on the [Public Sector Employment and Compensation
Assessment
Framework](https://documents1.worldbank.org/curated/en/324801640074379484/pdf/Public-Sector-Employment-and-Compensation-An-Assessment-Framework.pdf#page=37.23)
developed by the World Bank.

## :hammer: Installation

You can install the development version of `govhr` from
[GitHub](https://github.com/WB-PIDA-Data-Science-Shop/govhr) with:

``` r
# install.packages("pak")
pak::pak("WB-PIDA-Data-Science-Shop/govhr")
# or
# install.packages("remotes")
remotes::install_github("WB-PIDA-Data-Science-Shop/govhr")
```
## :link: Get started:
1. [Standard dictionary for human resources (HR) data.](https://wb-pida-data-science-shop.github.io/govhr/articles/01-standard_dictionary.html)
2. [How to harmonize your HR data.](https://wb-pida-data-science-shop.github.io/govhr/articles/02-harmonization.html)
3. [How to generate analytics.](https://wb-pida-data-science-shop.github.io/govhr/articles/03-analytics.html)

## License

`govhr` is licensed under the MIT License. However, it comes with no guarantees and the package developers cannot be held responsible for any issues arising from its use.