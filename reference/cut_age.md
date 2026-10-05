# Group ages into age bands

Converts a numeric age into a factor of age bands. Each band includes
its lower bound and excludes its upper bound, so an age of 30 falls in
`"30-39"`, not `"20-29"`.

## Usage

``` r
cut_age(
  age,
  breaks = c(-Inf, 20, 30, 40, 50, 60, Inf),
  labels = c("<20", "20-29", "30-39", "40-49", "50-59", "60+")
)
```

## Arguments

- age:

  A numeric vector of ages.

- breaks:

  A numeric vector of band boundaries, passed to
  [`base::cut()`](https://rdrr.io/r/base/cut.html).

- labels:

  A character vector of band labels, one fewer than `breaks`.

## Value

A factor the same length as `age`, with levels given by `labels`.
