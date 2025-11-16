# Current period year-to-date compared to full previous period

- This calculates the full year value compared to the previous year
  value using a standard or 5-5-4 calendar respecting any groups that
  are passed through with
  [`dplyr::group_by()`](https://dplyr.tidyverse.org/reference/group_by.html)

- Use [calculate](https://usrbinr.github.io/fpaR/reference/calculate.md)
  to return the results

## Usage

``` r
ytdopy(.data, .date, .value, calendar_type, lag_n = 1)
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
[`qoqtd()`](https://usrbinr.github.io/fpaR/reference/qoqtd.md),
[`qtd()`](https://usrbinr.github.io/fpaR/reference/qtd.md),
[`qtdopq()`](https://usrbinr.github.io/fpaR/reference/qtdopq.md),
[`wow()`](https://usrbinr.github.io/fpaR/reference/wow.md),
[`wowtd()`](https://usrbinr.github.io/fpaR/reference/wowtd.md),
[`wtd()`](https://usrbinr.github.io/fpaR/reference/wtd.md),
[`wtdopw()`](https://usrbinr.github.io/fpaR/reference/wtdopw.md),
[`yoy()`](https://usrbinr.github.io/fpaR/reference/yoy.md),
[`yoytd()`](https://usrbinr.github.io/fpaR/reference/yoytd.md),
[`ytd()`](https://usrbinr.github.io/fpaR/reference/ytd.md)

## Examples

``` r
ytdopy(sales,.date=order_date,.value=quantity,calendar_type='standard',lag_n=1)
#> <fpaR::ti>
#>  @ data     : <fpaR::data>
#>  .. @ data           :List of 2
#>  .. .. $ src       :List of 2
#>  .. ..  ..$ con  :Formal class 'duckdb_connection' [package "duckdb"] with 8 slots
#>  .. ..  .. .. ..@ conn_ref      :<externalptr> 
#>  .. ..  .. .. .. ..- attr(*, "_registered_df_x")='data.frame':   7794 obs. of  17 variables:
#>  .. ..  .. .. .. .. ..$ order_key    : num [1:7794] 233000 233100 233100 233100 233200 ...
#>  .. ..  .. .. .. .. ..$ line_number  : num [1:7794] 0 0 1 2 0 1 2 3 0 1 ...
#>  .. ..  .. .. .. .. ..$ order_date   : Date[1:7794], format: "2021-05-18" ...
#>  .. ..  .. .. .. .. ..$ delivery_date: Date[1:7794], format: "2021-05-18" ...
#>  .. ..  .. .. .. .. ..$ customer_key : num [1:7794] 1855811 1345436 1345436 1345436 926315 ...
#>  .. ..  .. .. .. .. ..$ store_key    : num [1:7794] 585 550 550 550 370 370 370 370 60 60 ...
#>  .. ..  .. .. .. .. ..$ product_key  : num [1:7794] 1483 499 1512 1490 2512 ...
#>  .. ..  .. .. .. .. ..$ quantity     : num [1:7794] 2 1 3 3 3 2 3 2 3 5 ...
#>  .. ..  .. .. .. .. ..$ unit_price   : num [1:7794] 377 148 335 181 182 ...
#>  .. ..  .. .. .. .. ..$ net_price    : num [1:7794] 377 131 288 177 173 ...
#>  .. ..  .. .. .. .. ..$ unit_cost    : num [1:7794] 173.2 75.7 153.9 92.1 60.3 ...
#>  .. ..  .. .. .. .. ..$ currency_code: chr [1:7794] "USD" "USD" "USD" "USD" ...
#>  .. ..  .. .. .. .. ..$ exchange_rate: num [1:7794] 1 1 1 1 0.708 ...
#>  .. ..  .. .. .. .. ..$ gross_revenue: num [1:7794] 753 148 1004 542 546 ...
#>  .. ..  .. .. .. .. ..$ net_revenue  : num [1:7794] 753 131 863 531 519 ...
#>  .. ..  .. .. .. .. ..$ cogs         : num [1:7794] 346.4 75.7 461.6 276.2 180.9 ...
#>  .. ..  .. .. .. .. ..$ margin       : num [1:7794] 407 55 402 255 338 ...
#>  .. ..  .. .. ..@ driver        :Formal class 'duckdb_driver' [package "duckdb"] with 6 slots
#>  .. ..  .. .. .. .. ..@ database_ref:<externalptr> 
#>  .. ..  .. .. .. .. ..@ config      :List of 2
#>  .. ..  .. .. .. .. .. ..$ extension_directory: chr "/home/runner/.local/share/R/duckdb/extensions"
#>  .. ..  .. .. .. .. .. ..$ secret_directory   : chr "/home/runner/.local/share/R/duckdb/stored_secrets"
#>  .. ..  .. .. .. .. ..@ dbdir       : chr "/tmp/RtmpKEPn4a/file5c0632166a5d"
#>  .. ..  .. .. .. .. ..@ read_only   : logi FALSE
#>  .. ..  .. .. .. .. ..@ convert_opts:List of 7
#>  .. ..  .. .. .. .. .. ..$ timezone_out     : chr "UTC"
#>  .. ..  .. .. .. .. .. ..$ tz_out_convert   : chr "with"
#>  .. ..  .. .. .. .. .. ..$ bigint           : chr "numeric"
#>  .. ..  .. .. .. .. .. ..$ array            : chr "none"
#>  .. ..  .. .. .. .. .. ..$ arrow            : logi FALSE
#>  .. ..  .. .. .. .. .. ..$ experimental     : logi FALSE
#>  .. ..  .. .. .. .. .. ..$ strict_relational: logi TRUE
#>  .. ..  .. .. .. .. ..@ bigint      : chr "numeric"
#>  .. ..  .. .. ..@ debug         : logi FALSE
#>  .. ..  .. .. ..@ convert_opts  :List of 7
#>  .. ..  .. .. .. ..$ timezone_out     : chr "UTC"
#>  .. ..  .. .. .. ..$ tz_out_convert   : chr "with"
#>  .. ..  .. .. .. ..$ bigint           : chr "numeric"
#>  .. ..  .. .. .. ..$ array            : chr "none"
#>  .. ..  .. .. .. ..$ arrow            : logi FALSE
#>  .. ..  .. .. .. ..$ experimental     : logi FALSE
#>  .. ..  .. .. .. ..$ strict_relational: logi TRUE
#>  .. ..  .. .. ..@ reserved_words: chr [1:489] "abort" "absolute" "access" "action" ...
#>  .. ..  .. .. ..@ timezone_out  : chr "UTC"
#>  .. ..  .. .. ..@ tz_out_convert: chr "with"
#>  .. ..  .. .. ..@ bigint        : chr "numeric"
#>  .. ..  ..$ disco: NULL
#>  .. ..  ..- attr(*, "class")= chr [1:4] "src_duckdb_connection" "src_dbi" "src_sql" "src"
#>  .. .. $ lazy_query:List of 5
#>  .. ..  ..$ x         : 'dbplyr_table_path' chr "x"
#>  .. ..  ..$ vars      : chr [1:17] "order_key" "line_number" "order_date" "delivery_date" ...
#>  .. ..  ..$ group_vars: chr(0) 
#>  .. ..  ..$ order_vars: NULL
#>  .. ..  ..$ frame     : NULL
#>  .. ..  ..- attr(*, "class")= chr [1:3] "lazy_base_remote_query" "lazy_base_query" "lazy_query"
#>  .. .. - attr(*, "class")= chr [1:5] "tbl_duckdb_connection" "tbl_dbi" "tbl_sql" "tbl_lazy" ...
#>  .. @ class_name     : chr "dbi"
#>  .. @ calendar_type  : chr "standard"
#>  .. @ date_vec       : chr "order_date"
#>  .. @ date_quo       : symbol order_date
#>  .. @ min_date       : Date[1:1], format: "2021-05-18"
#>  .. @ max_date       : Date[1:1], format: "2024-04-20"
#>  .. @ date_range     : num 1068
#>  .. @ date_count     : int 846
#>  .. @ date_missing   : num 222
#>  .. @ group_indicator: logi FALSE
#>  .. @ group_quo      : list()
#>  .. @ group_vec      : chr(0) 
#>  .. @ group_count    : num 0
#>  @ time_unit: <fpaR::time_unit>
#>  .. @ value: chr "day"
#>  @ value    : <fpaR::value>
#>  .. @ value_vec          : chr "quantity"
#>  .. @ value_quo          : symbol quantity
#>  .. @ new_column_name_vec: chr "ytd_quantity"
#>  .. @ new_column_name_quo: symbol ytd_quantity
#>  @ fn       : <fpaR::fn>
#>  .. @ fn_exec             : function (x)  
#>  .. @ fn_name             : chr "ytdopy"
#>  .. @ fn_long_name        : chr "Year-to-date over full previous year"
#>  .. @ shift               : chr "year"
#>  .. @ compare             : chr "previous year"
#>  .. @ label               : logi FALSE
#>  .. @ new_date_column_name: chr [1:2] "date" "year"
#>  .. @ lag_n               : num 1
#>  @ action   : <fpaR::action>
#>  .. @ value :List of 5
#>  .. .. $ : chr [1:2] "\033[32m✔\033[39m" "Aggregate"
#>  .. .. $ : chr [1:2] "\033[32m✔\033[39m" "Shift"
#>  .. .. $ : chr [1:2] "\033[32m✔\033[39m" "Compare"
#>  .. .. $ : chr [1:2] "\033[31m✖\033[39m" "Proportion Of Total"
#>  .. .. $ : chr [1:2] "\033[31m✖\033[39m" "Count Distinct"
#>  .. @ method: chr "This creates a daily {.code cumsum()} of the {cli::col_cyan('current year')}\n                             {.fi"| __truncated__
```
