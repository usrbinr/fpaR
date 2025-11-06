# Print ti objects

Print ti objects

Print segment objects

## Arguments

- x:

  segment object

- ...:

## Value

ti object

segment object

## Examples

``` r
x <- ytd(sales,.date=order_date,.value=quantity,calendar_type="standard")
x
#> 
#> ── Year-to-date ────────────────────────────────────────────────────────────────
#> Function: `ytd` was executed
#> 
#> ── Description: ──
#> 
#> This creates a daily `cumsum()` of the current year quantity from the start of
#> the standard calendar year to the end of the year
#> 
#> ── Calendar: ──
#> 
#> • The calendar aggregated order_date to the day time unit
#> • A standard calendar is created with 0 groups
#> • Calendar ranges from 2021-05-18 to 2024-04-20
#> • 222 days were missing and replaced with 0
#> • New date column date and year was created from order_date
#> 
#> ── Actions: ──
#> 
#> Error in str_detect(x@action@value[[1]], "32m"): could not find function "str_detect"
```
