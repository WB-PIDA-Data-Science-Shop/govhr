# Graduate a single age curve onto a complete age grid

Internal single-curve workhorse called by
[`smooth_decrement_rates()`](https://wb-pida-data-science-shop.github.io/govhr/reference/smooth_decrement_rates.md)
once per `(group_cols, status_col)` combination. Given raw `(age, rate)`
observations for one specific outcome curve (e.g. "male pensioner rate
by age"), returns a smoothed rate for *every* age in `full_ages` –
including ages that had zero raw observations at all.

The method used depends on how much data is actually available, since a
local regression needs enough support to be stable:

- Exactly one distinct age observed: there is no trend to fit from a
  single point, so that one rate is repeated flat across the whole grid.

- Two or three distinct ages: too few for a stable `loess` fit, so falls
  back to [`stats::approx()`](https://rdrr.io/r/stats/approxfun.html)
  (piecewise linear interpolation). Ages in `full_ages` outside the
  observed range get the nearest boundary value (`rule = 2`) rather than
  `NA`.

- Four or more distinct ages: fits
  `stats::loess(rate ~ age, weights = weight, span = span, degree = 2)`
  and predicts it onto `full_ages`. `weight` (exposure) means an age
  with many people at risk pulls the local curve toward its raw rate
  harder than a thin, noisy age.

## Usage

``` r
.smooth_rate_curve(age, rate, weight, full_ages, span)
```

## Arguments

- age:

  Numeric vector. Ages with an observed rate.

- rate:

  Numeric vector. The observed rate at each `age` (same length as
  `age`).

- weight:

  Numeric vector. Exposure weight at each `age` (same length as `age`),
  used as [`loess()`](https://rdrr.io/r/stats/loess.html) weights.

- full_ages:

  Integer vector. The complete, gapless target age grid to return a
  smoothed rate for.

- span:

  Numeric. The [`loess()`](https://rdrr.io/r/stats/loess.html) smoothing
  span (only used when there are at least 4 distinct ages); larger
  values produce a smoother, more global fit, smaller values track local
  features more closely.

## Value

A numeric vector of smoothed rates, one per element of `full_ages`, in
the same order. Not clipped to `[0, 1]` – callers (e.g.
[`smooth_decrement_rates()`](https://wb-pida-data-science-shop.github.io/govhr/reference/smooth_decrement_rates.md))
are responsible for that.

## See also

[`smooth_decrement_rates`](https://wb-pida-data-science-shop.github.io/govhr/reference/smooth_decrement_rates.md)
