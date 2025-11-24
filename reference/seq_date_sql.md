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
if (FALSE) { # \dontrun{
con <- DBI::dbConnect(drv = duckdb::duckdb())
seq_date_sql(start_date = "2015-01-01", end_date = "2024-04-20", time_unit = "day", con = con)
} # }
```
