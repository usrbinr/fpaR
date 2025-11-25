# cohort

## Introduction

Cohort analysis is a common method for tracking groups of users,
customers, or entities over time to understand retention, behavior, or
trends.

The [`cohort()`](https://usrbinr.github.io/fpaR/reference/cohort.md)
function in **fpaR** provides a **database-friendly implementation** of
cohort analysis that is compatible with `duckdb` and `snowflake`
backends. It combines the functionality of multiple traditional cohort
tables into a single streamlined workflow.

## Function Purpose

[`cohort()`](https://usrbinr.github.io/fpaR/reference/cohort.md):

- Assigns each member in your dataset to a **time-based cohort** based
  on the first occurrence in the `.date` column.
- Aggregates distinct counts of cohort members over time.
- Supports multiple calendar types (`"standard"` or `"554"`).
- Can summarize cohorts by various `time_unit`s (`day`, `week`, `month`,
  `quarter`, `year`).
- Returns a **segment object**, which can be processed using
  [`calculate()`](https://usrbinr.github.io/fpaR/reference/calculate.md)
  to generate the cohort table.

## Arguments

| Argument        | Description                                                                                                   |
|-----------------|---------------------------------------------------------------------------------------------------------------|
| `.data`         | A `tibble` or DBI object containing your dataset.                                                             |
| `.date`         | The date column to base the cohort assignment on.                                                             |
| `.value`        | The column representing members to track (e.g., customer ID).                                                 |
| `calendar_type` | Type of calendar to use for aggregation: `"standard"` or `"554"`.                                             |
| `time_unit`     | Time unit to summarize the cohort table by (`day`, `week`, `month`, `quarter`, `year`). Default is `"month"`. |
| `period_label`  | Whether to use numeric period labels (`TRUE`) or actual dates (`FALSE`). Default is `FALSE`.                  |

## How It Works

1.  **Assign Cohorts**  
    Each member in `.value` is assigned to a **cohort date**, which is
    the first date they appear in `.date`.

2.  **Aggregate Over Time**  
    The function counts distinct members per cohort across time periods
    defined by `time_unit`.

3.  **Database Efficiency**  
    The function is optimized for DBI objects, generating SQL-compatible
    operations using `dbplyr`.

4.  **Internal Execution**  
    The internal function
    [`cohort_fn()`](https://usrbinr.github.io/fpaR/reference/cohort_fn.md):

    - Floors dates to the chosen `time_unit`.
    - Groups members by cohort and date.
    - Computes distinct counts and period IDs.
    - Reshapes the table into a **wide format** for analysis.

## Output

The function returns a **segment object**. Use
[`calculate()`](https://usrbinr.github.io/fpaR/reference/calculate.md)
to retrieve the cohort table:

``` r
#|eval: false
library(dplyr)
```

    Attaching package: 'dplyr'

    The following objects are masked from 'package:stats':

        filter, lag

    The following objects are masked from 'package:base':

        intersect, setdiff, setequal, union

``` r
# Example cohort analysis
fpaR::cohort(.data = contoso::sales,
                  .date = order_date,
                  .value = customer_key,
                  calendar_type = "standard",
                  time_unit = "month",
                  period_label = FALSE
             )
```

    ── Time Based Cohort ───────────────────────────────────────────────────────────

    Function: `cohort` was executed

    ── Description: ──

    This segments groups based on a shared time related dimension so you can track
    a cohort's trend over time

    ── Category Information ──

    • The data set is grouped by the customer_key and segments each group member by their first order_date entry to define their cohort customer_key
    • This creates cohort ID that each member is assigned to eg; January 2020, February 2020, etc
    • The distinct count of each customer_key member in the cohort is then tracked over time

    ── Calendar: ──

    • The calendar aggregated order_date to the month time unit
    • A standard calendar is created with 0 groups
    • Calendar ranges from 2021-05-18 to 2024-04-20
    • 222 days were missing and replaced with 0
    • New date column cohort_date was created from order_date

    ── Actions: ──

    ✖Aggregate

    ✖Shift

    ✖Compare

    ✖Proportion Of Total

    ✔Count Distinct

    ── Next Steps: ──

    • Use `calculate()` to return the results

    ────────────────────────────────────────────────────────────────────────────────
