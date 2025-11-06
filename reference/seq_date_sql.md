# Create a calendar table in sql

Create a calendar table in sql

## Usage

``` r
seq_date_sql(start_date, end_date, time_unit, con)
```

## Arguments

- start_date:

  calendar start date in YYYY-MM-DD format

- end_date:

  calendar end date in YYYY-MM-DD format

- time_unit:

  calendar table unit in 'day', 'week', 'month', 'quarter' or 'year'

- con:

  database connection

## Value

DBI object

## Examples

``` r
con <- DBI::dbConnect(drv = duckdb::duckdb())
seq_date_sql(start_date = "2015-01-01", end_date = "2024-04-20", time_unit = "day", con = con)
#> # Source:   SQL [?? x 1]
#> # Database: DuckDB 1.4.1 [unknown@Linux 6.11.0-1018-azure:R 4.5.2/:memory:]
#>    date      
#>    <date>    
#>  1 2015-01-01
#>  2 2015-01-02
#>  3 2015-01-03
#>  4 2015-01-04
#>  5 2015-01-05
#>  6 2015-01-06
#>  7 2015-01-07
#>  8 2015-01-08
#>  9 2015-01-09
#> 10 2015-01-10
#> # ℹ more rows
```
