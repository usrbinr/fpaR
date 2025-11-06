# Previous month-to-date execution function

`pmtd_fn()` is the function that is called by
[`pmtd()`](https://usrbinr.github.io/fpaR/reference/pmtd.md) when passed
through to
[calculate](https://usrbinr.github.io/fpaR/reference/calculate.md)

## Usage

``` r
pmtd_fn(x)
```

## Arguments

- x:

  ti object

## Value

dbi object

## Details

This is internal non exported function that is nested in ti class and is
called upon when the underlying function is called by
[calculate](https://usrbinr.github.io/fpaR/reference/calculate.md) This
will return a dbi object that can converted to a tibble object with
[`dplyr::collect()`](https://dplyr.tidyverse.org/reference/compute.html)

## See also

[`pmtd()`](https://usrbinr.github.io/fpaR/reference/pmtd.md) for the
function's intent
