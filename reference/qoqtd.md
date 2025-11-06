# Current period quarter-to-date compared to previous period quarter-to-date

- This calculates the annual cumulative sum of targeted value using a
  standard or 5-5-4 calendar respecting any groups that are passed
  through with
  [`dplyr::group_by()`](https://dplyr.tidyverse.org/reference/group_by.html)

- Use [calculate](https://usrbinr.github.io/fpaR/reference/calculate.md)
  to return the results

## Usage

``` r
qoqtd(.data, .date, .value, calendar_type, lag_n)
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

## Details

- This function creates a complete calendar object that fills in any
  missing days, weeks, months, quarters, or years

- If you provide a grouped object with
  [`dplyr::group_by()`](https://dplyr.tidyverse.org/reference/group_by.html),
  it will generate a complete calendar for each group

- The function creates a `ti` object, which pre-processes the data and
  arguments for further downstream functions

**standard calendar**

- The standard calendar splits the year into 12 months (with 28–31 days
  each) and uses a 7-day week

- It automatically accounts for leap years every four years to match the
  Gregorian calendar

**5-5-4 calendar**

- The 5-5-4 calendar divides the fiscal year into 52 weeks (occasionally
  53), organizing each quarter into two 5-week periods and one 4-week
  period.

- This system is commonly used in retail and financial reporting

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
[`qoq()`](https://usrbinr.github.io/fpaR/reference/qoq.md),
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
qoqtd(sales,.date=order_date,.value=quantity,calendar_type="standard",lag_n=1)
#> 
#> ── Current period quarter-to-date compared to previous period quarter-to-date ──
#> Function: `qoqtd` was executed
#> 
#> ── Description: ──
#> 
#> This creates a daily `cumsum()` of the previous quarter quantity and compares
#> it with the daily `cumsum()` current quarter quantity from the start of the
#> standard calendar quarter to the end of the quarter
#> 
#> ── Calendar: ──
#> 
#> • The calendar aggregated order_date to the day time unit
#> • A standard calendar is created with 0 groups
#> • Calendar ranges from 2021-05-18 to 2024-04-20
#> • 222 days were missing and replaced with 0
#> • New date column date, year and quarter was created from order_date
#> 
#> ── Actions: ──
#> 
#> Error in str_detect(x@action@value[[1]], "32m"): could not find function "str_detect"
```
