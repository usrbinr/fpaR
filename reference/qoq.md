# Current full period quarter over previous full period quarter

A short description...

## Usage

``` r
qoq(.data, .date, .value, calendar_type, lag_n = 1)
```

## Arguments

- .data:

  tibble or dbi object (either grouped or ungrouped)

- .date:

  the date column to group by

- .value:

  the value column to summarize

- calendar_type:

  select either 'standard' or '5-5-4' calendar, see 'Details' for
  additional information

- lag_n:

  the number of periods to lag

## Value

ti object

## See also

Other time_intelligence:
[`atd()`](https://usrbinr.github.io/fpaR/reference/atd.md),
[`dod()`](https://usrbinr.github.io/fpaR/reference/dod.md),
[`mom()`](https://usrbinr.github.io/fpaR/reference/mom.md),
[`momtd()`](https://usrbinr.github.io/fpaR/reference/momtd.md),
[`mtd()`](https://usrbinr.github.io/fpaR/reference/mtd.md),
[`mtdopm()`](https://usrbinr.github.io/fpaR/reference/mtdopm.md),
[`pmtd()`](https://usrbinr.github.io/fpaR/reference/pmtd.md),
[`pqtd()`](https://usrbinr.github.io/fpaR/reference/pqtd.md),
[`pwtd()`](https://usrbinr.github.io/fpaR/reference/pwtd.md),
[`pytd()`](https://usrbinr.github.io/fpaR/reference/pytd.md),
[`qoqtd()`](https://usrbinr.github.io/fpaR/reference/qoqtd.md),
[`qtd()`](https://usrbinr.github.io/fpaR/reference/qtd.md),
[`qtdopq()`](https://usrbinr.github.io/fpaR/reference/qtdopq.md),
[`wow()`](https://usrbinr.github.io/fpaR/reference/wow.md),
[`wowtd()`](https://usrbinr.github.io/fpaR/reference/wowtd.md),
[`wtd()`](https://usrbinr.github.io/fpaR/reference/wtd.md),
[`wtdopw()`](https://usrbinr.github.io/fpaR/reference/wtdopw.md),
[`yoy()`](https://usrbinr.github.io/fpaR/reference/yoy.md),
[`yoytd()`](https://usrbinr.github.io/fpaR/reference/yoytd.md),
[`ytd()`](https://usrbinr.github.io/fpaR/reference/ytd.md),
[`ytdopy()`](https://usrbinr.github.io/fpaR/reference/ytdopy.md)

## Examples

``` r
qoq(sales,.date=order_date,.value=quantity,calendar_type='standard',lag_n=1)
#> 
#> ── Quarter over quarter ────────────────────────────────────────────────────────
#> Function: `qoq` was executed
#> 
#> ── Description: ──
#> 
#> This creates a full quarter `sum()` of the previous quarter quantity and
#> compares it with the full quarter `sum()` current quarter quantity from the
#> start of the standard calendar quarter to the end of the quarter
#> 
#> ── Calendar: ──
#> 
#> • The calendar aggregated order_date to the quarter time unit
#> • A standard calendar is created with 0 groups
#> • Calendar ranges from 2021-05-18 to 2024-04-20
#> • 222 days were missing and replaced with 0
#> • New date column date, year and quarter was created from order_date
#> 
#> ── Actions: ──
#> 
#> Error in str_detect(x@action@value[[1]], "32m"): could not find function "str_detect"
```
