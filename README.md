# README


# fpaR: A Business Intelligence Toolkit for Financial Planning & Analysis (FP&A)

## Introduction

`fpaR` is a collection of business intelligence tools designed to
simplify common **financial planning and analysis (FP&A)** tasks such as
time intelligence calculations, customer, vendor or product
segmentation, and factor/variance analysis.

The package is inspired by best practices from a collection of blogs,
books, industry research, and hands-on work experience, consolidating
frequently performed business analyses into a fast, efficient, and
reusable framework.

In particular, the time intelligence functions are heavily inspired by
[PowerBI DAX](https://www.sqlbi.com/) functions.

Under the hood, these functions are built upon the great foundations of:

- [dbplyr](https://dbplyr.tidyverse.org/)  
- [duckdb](https://github.com/duckdb/duckdb-r)
- [lubridate](https://lubridate.tidyverse.org/)

`fpaR` is designed to seamlessly work with either tibbles or modern
databases (DuckDB, Snowflake, SQLite, etc) with a unified syntax.

Even if you are working with tibbles, most functions are optimized to
leverage [DuckDB](https://github.com/duckdb/duckdb-r) for superior speed
and performance.[^1]

By default most `fpaR` function returns a lazy DBI object which you can
return as a tibble with `dplyr::collect()`

## Key features & benefits

- **Unified syntax** regardless if your data is in a tibble or a
  database
- **Scale** your data with [duckdb](https://github.com/duckdb/duckdb-r)
  to optimize your calculations
- **Instant clarity** as every function summarizes its transformation
  actions so that you can understand and validate the results

## Installation

Install the development version of `fpaR` from GitHub:

``` r
# Install using pak or install.package()

pak::pak("alejandrohagan/fpaR")
```

## What is in fpaR?

There are 3 main categories of functions:

- Time intelligence (Ready for testing and feedback)
- Segmentation strategies (work in progress)
- Factor Analysis (work in progress)

### Time intelligence

`fpaR` provides readily available functions for most time intelligence
analysis such as **Year-over-Year (YoY)**, **Month-to-Date (MTD)**, and
**Current Year-to-Date over Previous Year-to-Date (YoYTD)** analysis.

These functions are designed to quickly answer most common time
intelligence related analysis in a consistent, fast and transparent way.

**Key benefits:**

- **Auto-fill missing dates**: Ensures no missing periods in your
  datasets so that right period comparisons are performed

- **Flexible calendar options**: Handle comparisons based on a
  **standard** or **5-5-4** fiscal calendar to accommodate different
  reporting frameworks

- **Period imbalance indicator**: When comparing periods with dates
  imbalance, the time intelligence functions will alert you to the type
  and number of period imbalances to ensure you are aware of misleading
  likewise comparisons

Below is the full list of time intelligence functions:

| short_name | description | shift | aggregate | compare |
|----|----|----|----|----|
| YoY | Full Year over Year |  |  | X |
| YTD | Year-to-Date |  | X |  |
| PYTD | Prior Year-to-Date amount | X | X |  |
| YoYTD | Current Year-to-Date over Prior Year-to-Date | X | X | X |
| YTDOPY | Year-to-Date over Full Previous Year | X | X | X |
| QoQ | Full Quarter over Quarter |  |  | X |
| QTD | Quarter-to-Date |  | X |  |
| PQTD | Prior Quarter-to-Date | X | X |  |
| QOQTD | Quarter-over-Quarter-to-Date | X | X | X |
| QTDOPQ | Quarter-to-Date over Full Previous Quarter | X | X | X |
| MTD | Month-to-Date |  | X |  |
| MoM | Full Month over Full Month |  |  | X |
| MoMTD | Current Month-to-Date over Prior Month-to-Date | X | X | X |
| PMTD | Prior Month’s MTD amount | X | X |  |
| MTDOPM | Month-to-Date over Full Previous Month | X | X | X |
| WTD | Week-to-Date |  | X |  |
| WoW | Full Week over Full Week |  |  | X |
| WoWTD | Current Week-to-Date over Prior Week-to-Date | X | X | X |
| PWTD | Prior Week-to-Date | X | X |  |
| ATD | cumlaitve total from inception to date |  | x |  |
| DoD | Full Day over Full Day |  |  | X |

## How to use fpaR?

### Time Intelligence

When you execute a time intelligence function, it will return a `ti`
class object with a custom print method that explains what the function
is doing and a summary of transformation steps and the calendar
attributes.

``` r
sales |> 
   mtd(.date=order_date,.value = margin,calendar_type = "standard") 
```

    <fpaR::ti>
     @ data     : <fpaR::data>
     .. @ data           :List of 2
     .. .. $ src       :List of 2
     .. ..  ..$ con  :Formal class 'duckdb_connection' [package "duckdb"] with 8 slots
     .. ..  .. .. ..@ conn_ref      :<externalptr> 
     .. ..  .. .. .. ..- attr(*, "_registered_df_x")='data.frame':  7794 obs. of  17 variables:
     .. ..  .. .. .. .. ..$ order_key    : num [1:7794] 233000 233100 233100 233100 233200 ...
     .. ..  .. .. .. .. ..$ line_number  : num [1:7794] 0 0 1 2 0 1 2 3 0 1 ...
     .. ..  .. .. .. .. ..$ order_date   : Date[1:7794], format: "2021-05-18" ...
     .. ..  .. .. .. .. ..$ delivery_date: Date[1:7794], format: "2021-05-18" ...
     .. ..  .. .. .. .. ..$ customer_key : num [1:7794] 1855811 1345436 1345436 1345436 926315 ...
     .. ..  .. .. .. .. ..$ store_key    : num [1:7794] 585 550 550 550 370 370 370 370 60 60 ...
     .. ..  .. .. .. .. ..$ product_key  : num [1:7794] 1483 499 1512 1490 2512 ...
     .. ..  .. .. .. .. ..$ quantity     : num [1:7794] 2 1 3 3 3 2 3 2 3 5 ...
     .. ..  .. .. .. .. ..$ unit_price   : num [1:7794] 377 148 335 181 182 ...
     .. ..  .. .. .. .. ..$ net_price    : num [1:7794] 377 131 288 177 173 ...
     .. ..  .. .. .. .. ..$ unit_cost    : num [1:7794] 173.2 75.7 153.9 92.1 60.3 ...
     .. ..  .. .. .. .. ..$ currency_code: chr [1:7794] "USD" "USD" "USD" "USD" ...
     .. ..  .. .. .. .. ..$ exchange_rate: num [1:7794] 1 1 1 1 0.708 ...
     .. ..  .. .. .. .. ..$ gross_revenue: num [1:7794] 753 148 1004 542 546 ...
     .. ..  .. .. .. .. ..$ net_revenue  : num [1:7794] 753 131 863 531 519 ...
     .. ..  .. .. .. .. ..$ cogs         : num [1:7794] 346.4 75.7 461.6 276.2 180.9 ...
     .. ..  .. .. .. .. ..$ margin       : num [1:7794] 407 55 402 255 338 ...
     .. ..  .. .. ..@ driver        :Formal class 'duckdb_driver' [package "duckdb"] with 6 slots
     .. ..  .. .. .. .. ..@ database_ref:<externalptr> 
     .. ..  .. .. .. .. ..@ config      :List of 2
     .. ..  .. .. .. .. .. ..$ extension_directory: chr "/home/hagan/.local/share/R/duckdb/extensions"
     .. ..  .. .. .. .. .. ..$ secret_directory   : chr "/home/hagan/.local/share/R/duckdb/stored_secrets"
     .. ..  .. .. .. .. ..@ dbdir       : chr "/tmp/RtmpBs78jg/file31ffc564e9f89"
     .. ..  .. .. .. .. ..@ read_only   : logi FALSE
     .. ..  .. .. .. .. ..@ convert_opts:List of 7
     .. ..  .. .. .. .. .. ..$ timezone_out     : chr "UTC"
     .. ..  .. .. .. .. .. ..$ tz_out_convert   : chr "with"
     .. ..  .. .. .. .. .. ..$ bigint           : chr "numeric"
     .. ..  .. .. .. .. .. ..$ array            : chr "none"
     .. ..  .. .. .. .. .. ..$ arrow            : logi FALSE
     .. ..  .. .. .. .. .. ..$ experimental     : logi FALSE
     .. ..  .. .. .. .. .. ..$ strict_relational: logi TRUE
     .. ..  .. .. .. .. ..@ bigint      : chr "numeric"
     .. ..  .. .. ..@ debug         : logi FALSE
     .. ..  .. .. ..@ convert_opts  :List of 7
     .. ..  .. .. .. ..$ timezone_out     : chr "UTC"
     .. ..  .. .. .. ..$ tz_out_convert   : chr "with"
     .. ..  .. .. .. ..$ bigint           : chr "numeric"
     .. ..  .. .. .. ..$ array            : chr "none"
     .. ..  .. .. .. ..$ arrow            : logi FALSE
     .. ..  .. .. .. ..$ experimental     : logi FALSE
     .. ..  .. .. .. ..$ strict_relational: logi TRUE
     .. ..  .. .. ..@ reserved_words: chr [1:489] "abort" "absolute" "access" "action" ...
     .. ..  .. .. ..@ timezone_out  : chr "UTC"
     .. ..  .. .. ..@ tz_out_convert: chr "with"
     .. ..  .. .. ..@ bigint        : chr "numeric"
     .. ..  ..$ disco: NULL
     .. ..  ..- attr(*, "class")= chr [1:4] "src_duckdb_connection" "src_dbi" "src_sql" "src"
     .. .. $ lazy_query:List of 5
     .. ..  ..$ x         : 'dbplyr_table_path' chr "x"
     .. ..  ..$ vars      : chr [1:17] "order_key" "line_number" "order_date" "delivery_date" ...
     .. ..  ..$ group_vars: chr(0) 
     .. ..  ..$ order_vars: NULL
     .. ..  ..$ frame     : NULL
     .. ..  ..- attr(*, "class")= chr [1:3] "lazy_base_remote_query" "lazy_base_query" "lazy_query"
     .. .. - attr(*, "class")= chr [1:5] "tbl_duckdb_connection" "tbl_dbi" "tbl_sql" "tbl_lazy" ...
     .. @ class_name     : chr "dbi"
     .. @ calendar_type  : chr "standard"
     .. @ date_vec       : chr "order_date"
     .. @ date_quo       : symbol order_date
     .. @ min_date       : Date[1:1], format: "2021-05-18"
     .. @ max_date       : Date[1:1], format: "2024-04-20"
     .. @ date_range     : num 1068
     .. @ date_count     : int 846
     .. @ date_missing   : num 222
     .. @ group_indicator: logi FALSE
     .. @ group_quo      : list()
     .. @ group_vec      : chr(0) 
     .. @ group_count    : num 0
     @ time_unit: <fpaR::time_unit>
     .. @ value: chr "day"
     @ value    : <fpaR::value>
     .. @ value_vec          : chr "margin"
     .. @ value_quo          : symbol margin
     .. @ new_column_name_vec: chr "mtd_margin"
     .. @ new_column_name_quo: symbol mtd_margin
     @ fn       : <fpaR::fn>
     .. @ fn_exec             : function (x)  
     .. @ fn_name             : chr "mtd"
     .. @ fn_long_name        : chr "Month-to-date"
     .. @ shift               : chr NA
     .. @ compare             : chr NA
     .. @ label               : logi FALSE
     .. @ new_date_column_name: chr [1:3] "date" "year" "month"
     .. @ lag_n               : int NA
     @ action   : <fpaR::action>
     .. @ value :List of 5
     .. .. $ : chr [1:2] "✔" "Aggregate"
     .. .. $ : chr [1:2] "✖" "Shift"
     .. .. $ : chr [1:2] "✖" "Compare"
     .. .. $ : chr [1:2] "✖" "Proportion Of Total"
     .. .. $ : chr [1:2] "✖" "Count Distinct"
     .. @ method: chr "This creates a daily {.code cumsum()} of the {cli::col_cyan('current month')}\n                             {.f"| __truncated__

This prints a summary of the function’s actions,details the calendar’s
attributes, summarizes the main transformation steps and lists out
possible next actions.

To return a tibble of results, pass the ti object through to
`calculate()`.

``` r
sales |>                                                                
   mtd(.date=order_date,.value = margin,calendar_type = "standard") |>  
   calculate()                                                          
```

    # Source:     SQL [?? x 7]
    # Database:   DuckDB 1.4.2-dev189 [hagan@Linux 6.16.3-76061603-generic:R 4.5.1//tmp/RtmpBs78jg/file31ffc35b0b5ef]
    # Ordered by: date
        year month date       margin missing_date_indicator mtd_margin
       <dbl> <dbl> <date>      <dbl>                  <dbl>      <dbl>
     1  2021    11 2021-11-01   310.                      0       310.
     2  2021    11 2021-11-02   605.                      0       916.
     3  2021    11 2021-11-03 15938.                      0     16854.
     4  2021    11 2021-11-04  1987.                      0     18840.
     5  2021    11 2021-11-05  1763.                      0     20603.
     6  2021    11 2021-11-06  7703.                      0     28306.
     7  2021    11 2021-11-07     0                       1     28306.
     8  2021    11 2021-11-08   325.                      0     28631.
     9  2021    11 2021-11-09  2309.                      0     30940.
    10  2021    11 2021-11-10  3476.                      0     34416.
    # ℹ more rows
    # ℹ 1 more variable: days_in_current_period <dbl>

If you using a tibble, under the hood, `fpaR` is converting your data to
a [duckdb](https://github.com/duckdb/duckdb-r) database.

If your data is in a database, the package will leverage
[dbplyr](https://dbplyr.tidyverse.org/) to execute all the calculations.

Either case use `dplyr::collect()` to return your results to a local
tibble.

``` r
sales |>                                                                
   mtd(.date=order_date,.value = margin,calendar_type = "standard") |>  
   calculate() |>                                                       
   dplyr::collect() |>                                               
   head(10)
```

    # A tibble: 10 × 7
        year month date       margin missing_date_indicator mtd_margin
       <dbl> <dbl> <date>      <dbl>                  <dbl>      <dbl>
     1  2022     4 2022-04-01      0                      1          0
     2  2022     4 2022-04-02      0                      1          0
     3  2022     4 2022-04-03      0                      1          0
     4  2022     4 2022-04-04      0                      1          0
     5  2022     4 2022-04-05      0                      1          0
     6  2022     4 2022-04-06      0                      1          0
     7  2022     4 2022-04-07      0                      1          0
     8  2022     4 2022-04-08      0                      1          0
     9  2022     4 2022-04-09      0                      1          0
    10  2022     4 2022-04-10      0                      1          0
    # ℹ 1 more variable: days_in_current_period <dbl>

### What if you need the analysis at the group level?

Simply pass through the groups that you want with `dplyr::group_by()`
and time intelligence function will create a custom calendar for each
group level.

This will calculate a complete calendar ensuring each group has a
complete calendar with no missing dates.

``` r
sales |>   
   dplyr::group_by(customer_key,store_key) |>  
   yoy(.date=order_date,.value = margin,calendar_type = "standard") 
```

    <fpaR::ti>
     @ data     : <fpaR::data>
     .. @ data           :List of 2
     .. .. $ src       :List of 2
     .. ..  ..$ con  :Formal class 'duckdb_connection' [package "duckdb"] with 8 slots
     .. ..  .. .. ..@ conn_ref      :<externalptr> 
     .. ..  .. .. .. ..- attr(*, "_registered_df_x")='data.frame':  7794 obs. of  17 variables:
     .. ..  .. .. .. .. ..$ order_key    : num [1:7794] 233000 233100 233100 233100 233200 ...
     .. ..  .. .. .. .. ..$ line_number  : num [1:7794] 0 0 1 2 0 1 2 3 0 1 ...
     .. ..  .. .. .. .. ..$ order_date   : Date[1:7794], format: "2021-05-18" ...
     .. ..  .. .. .. .. ..$ delivery_date: Date[1:7794], format: "2021-05-18" ...
     .. ..  .. .. .. .. ..$ customer_key : num [1:7794] 1855811 1345436 1345436 1345436 926315 ...
     .. ..  .. .. .. .. ..$ store_key    : num [1:7794] 585 550 550 550 370 370 370 370 60 60 ...
     .. ..  .. .. .. .. ..$ product_key  : num [1:7794] 1483 499 1512 1490 2512 ...
     .. ..  .. .. .. .. ..$ quantity     : num [1:7794] 2 1 3 3 3 2 3 2 3 5 ...
     .. ..  .. .. .. .. ..$ unit_price   : num [1:7794] 377 148 335 181 182 ...
     .. ..  .. .. .. .. ..$ net_price    : num [1:7794] 377 131 288 177 173 ...
     .. ..  .. .. .. .. ..$ unit_cost    : num [1:7794] 173.2 75.7 153.9 92.1 60.3 ...
     .. ..  .. .. .. .. ..$ currency_code: chr [1:7794] "USD" "USD" "USD" "USD" ...
     .. ..  .. .. .. .. ..$ exchange_rate: num [1:7794] 1 1 1 1 0.708 ...
     .. ..  .. .. .. .. ..$ gross_revenue: num [1:7794] 753 148 1004 542 546 ...
     .. ..  .. .. .. .. ..$ net_revenue  : num [1:7794] 753 131 863 531 519 ...
     .. ..  .. .. .. .. ..$ cogs         : num [1:7794] 346.4 75.7 461.6 276.2 180.9 ...
     .. ..  .. .. .. .. ..$ margin       : num [1:7794] 407 55 402 255 338 ...
     .. ..  .. .. ..@ driver        :Formal class 'duckdb_driver' [package "duckdb"] with 6 slots
     .. ..  .. .. .. .. ..@ database_ref:<externalptr> 
     .. ..  .. .. .. .. ..@ config      :List of 2
     .. ..  .. .. .. .. .. ..$ extension_directory: chr "/home/hagan/.local/share/R/duckdb/extensions"
     .. ..  .. .. .. .. .. ..$ secret_directory   : chr "/home/hagan/.local/share/R/duckdb/stored_secrets"
     .. ..  .. .. .. .. ..@ dbdir       : chr "/tmp/RtmpBs78jg/file31ffc15c77e80"
     .. ..  .. .. .. .. ..@ read_only   : logi FALSE
     .. ..  .. .. .. .. ..@ convert_opts:List of 7
     .. ..  .. .. .. .. .. ..$ timezone_out     : chr "UTC"
     .. ..  .. .. .. .. .. ..$ tz_out_convert   : chr "with"
     .. ..  .. .. .. .. .. ..$ bigint           : chr "numeric"
     .. ..  .. .. .. .. .. ..$ array            : chr "none"
     .. ..  .. .. .. .. .. ..$ arrow            : logi FALSE
     .. ..  .. .. .. .. .. ..$ experimental     : logi FALSE
     .. ..  .. .. .. .. .. ..$ strict_relational: logi TRUE
     .. ..  .. .. .. .. ..@ bigint      : chr "numeric"
     .. ..  .. .. ..@ debug         : logi FALSE
     .. ..  .. .. ..@ convert_opts  :List of 7
     .. ..  .. .. .. ..$ timezone_out     : chr "UTC"
     .. ..  .. .. .. ..$ tz_out_convert   : chr "with"
     .. ..  .. .. .. ..$ bigint           : chr "numeric"
     .. ..  .. .. .. ..$ array            : chr "none"
     .. ..  .. .. .. ..$ arrow            : logi FALSE
     .. ..  .. .. .. ..$ experimental     : logi FALSE
     .. ..  .. .. .. ..$ strict_relational: logi TRUE
     .. ..  .. .. ..@ reserved_words: chr [1:489] "abort" "absolute" "access" "action" ...
     .. ..  .. .. ..@ timezone_out  : chr "UTC"
     .. ..  .. .. ..@ tz_out_convert: chr "with"
     .. ..  .. .. ..@ bigint        : chr "numeric"
     .. ..  ..$ disco: NULL
     .. ..  ..- attr(*, "class")= chr [1:4] "src_duckdb_connection" "src_dbi" "src_sql" "src"
     .. .. $ lazy_query:List of 5
     .. ..  ..$ x         : 'dbplyr_table_path' chr "x"
     .. ..  ..$ vars      : chr [1:17] "order_key" "line_number" "order_date" "delivery_date" ...
     .. ..  ..$ group_vars: chr [1:2] "customer_key" "store_key"
     .. ..  ..$ order_vars: NULL
     .. ..  ..$ frame     : NULL
     .. ..  ..- attr(*, "class")= chr [1:3] "lazy_base_remote_query" "lazy_base_query" "lazy_query"
     .. .. - attr(*, "class")= chr [1:5] "tbl_duckdb_connection" "tbl_dbi" "tbl_sql" "tbl_lazy" ...
     .. @ class_name     : chr "dbi"
     .. @ calendar_type  : chr "standard"
     .. @ date_vec       : chr "order_date"
     .. @ date_quo       : symbol order_date
     .. @ min_date       : Date[1:1], format: "2021-05-18"
     .. @ max_date       : Date[1:1], format: "2024-04-20"
     .. @ date_range     : num 1068
     .. @ date_count     : int 846
     .. @ date_missing   : num 222
     .. @ group_indicator: logi TRUE
     .. @ group_quo      :List of 2
     .. .. $ : symbol customer_key
     .. .. $ : symbol store_key
     .. @ group_vec      : chr [1:2] "customer_key" "store_key"
     .. @ group_count    : int 2
     @ time_unit: <fpaR::time_unit>
     .. @ value: chr "year"
     @ value    : <fpaR::value>
     .. @ value_vec          : chr "margin"
     .. @ value_quo          : symbol margin
     .. @ new_column_name_vec: chr "yoy_margin"
     .. @ new_column_name_quo: symbol yoy_margin
     @ fn       : <fpaR::fn>
     .. @ fn_exec             : function (x)  
     .. @ fn_name             : chr "yoy"
     .. @ fn_long_name        : chr "Year over year"
     .. @ shift               : chr "year"
     .. @ compare             : chr "previous year"
     .. @ label               : logi FALSE
     .. @ new_date_column_name: chr [1:2] "date" "year"
     .. @ lag_n               : num 1
     @ action   : <fpaR::action>
     .. @ value :List of 5
     .. .. $ : chr [1:2] "✔" "Aggregate"
     .. .. $ : chr [1:2] "✔" "Shift"
     .. .. $ : chr [1:2] "✔" "Compare"
     .. .. $ : chr [1:2] "✖" "Proportion Of Total"
     .. .. $ : chr [1:2] "✖" "Count Distinct"
     .. @ method: chr "This creates a full year {.code sum()} of the {cli::col_br_cyan('previous year')}\n                            "| __truncated__

The functions will work with your database even if you don’t have write
permission by creatively leveraging CTEs to create interim tables.

## Why do we need this package when we have lubridate?

[Lubridate](https://lubridate.tidyverse.org/) is an excellent package
and is heavily used by the package. The issue isn’t lubridate but rather
issues you may not be aware of in your package.

Time-based comparisons, such as Year-over-Year (YoY),
Quarter-over-Quarter (QoQ), and Month-to-Date (MTD), are common for
tracking business performance. However, they come with challenges:

- Many datasets **do not have continuous dates**, especially if data is
  recorded only on business days or for active transactions

- Period imbalances between periods (Eg. the different number of days
  between February vs. January) can create misleading analysis or trends

- Your analysis may need to reference a non-standard calendar such as a
  5-5-4, 4-4-5, or 13 month calendar

- Your data may be in excel sheets, csv or databases and you need to
  inter-operable framework to switch between all your data types

### Issue 1: Continuous Dates

Referencing the table below, if we use `dplyr::lag()` to compare
**Day-over-Day (DoD)** revenue, we would be missing `2024-01-02`,
`2024-01-04`, and `2024-01-05` which will lead to incorrect answers or
trends.

| order_date | margin |
|------------|--------|
| 2024-01-01 | 1200   |
| 2024-01-03 | 1100   |
| 2024-01-06 | 1300   |
| 2024-01-07 | 900    |
| 2024-01-08 | 1200   |
| 2024-01-09 | 850    |
| 2024-01-11 | 1450   |

To correct this, `fpaR` will automatically complete your calendar for
each group for the missing periods to ensure there are no missing
periods when calculating trends.

## Issue 2

- TBD

## Issue 3

- TBD

## Datasets

- This package leverages the
  [Contoso](https://usrbinr.github.io/contoso/) package for its
  analysis. The contoso datasets are fictional business transaction of
  Contoso toy company which are helpful for business intelligence
  related analysis

This is an **active work-in-progress**, and feedback, testing, and
contributions are welcome!

## Future capabilities

### **Segmentation Strategies**

Provides functions to segment and categorize your data into meaningful
business categories.

#### **Example Segmentation Methods:**

- **ABC Classification** – Categorizing products/customers based on
  revenue contribution
- **Cohort Analysis** - Categorize your data by a shared time based
  attribute to track over time
- **New vs. Returning** – Distinguishing first-time buyers from repeat
  customers
- **K-means Clustering** – Grouping data points based on patterns
- **UMAP (Uniform Manifold Approximation and Projection)** –
  Dimensionaltiy reduction for clustering

------------------------------------------------------------------------

### **Factor / Variation Analysis**

Breaks down revenue or cost changes into **price, volume, and mix
effects**.

#### **Use Cases:**

- Analyzing revenue growth **due to price increases vs. increased sales
  volume**
- Measuring the impact of **product mix changes on profitability**.

------------------------------------------------------------------------

## Additional references and inspirations

- [PeerChristensen’s Cohort
  Package](https://github.com/PeerChristensen/cohorts)

[^1]: I plan use [duckplyr](https://duckplyr.tidyverse.org/index.html)
    once it expands support for lubricate functions
