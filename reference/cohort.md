# Cohort Analysis

A database is remake of 'https://github.com/PeerChristensen/cohorts'
excellent cohort package combining chort_table_month, cohort_table_year,
cohort_table_day into a single package. Re-written to be database
friendly tested against snowflake and duckdb databases

## Usage

``` r
cohort(
  .data,
  .date,
  .value,
  calendar_type,
  time_unit = "month",
  period_label = FALSE
)
```

## Arguments

- .data:

  tibble or dbi object

- .date:

  date column

- .value:

  id column

- calendar_type:

  clarify the calendar type; 'standard' or '554'

- time_unit:

  do you want summarize the date column to 'day',
  'week','month','quarter' or 'year'

- period_label:

  do you want period labels or the dates c(TRUE,FALSE)

## Value

segment object

## Details

- This will group your `.value` column by shared time attributes from
  the `.date` column

- It will assign to each member a time base cohort based on the member's
  first entry in the `.date` column

- The cohort will be generalized by the time_unit argument you selected

- Then the distinct count of each cohort member over time is calculated
