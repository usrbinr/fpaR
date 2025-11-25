# ABC Classification

### Introduction

In business and financial analytics, the **ABC classification** method
is widely used to categorize items, customers, or other groups according
to their relative contribution to a total metric.  
The [`abc()`](https://usrbinr.github.io/fpaR/reference/abc.md) function
provides an easy way to classify a group’s member by their relative
contribution of either their **transaction counts** or the sum of a
**numeric variable** such as sales margin or revenue.

- Allows for **custom break points** (e.g., top 10% = A, next 40% = B,
  etc.)
- Works on both **tibbles** and **database objects**
- Returns a **segment object**, which is processed by
  [`calculate()`](https://usrbinr.github.io/fpaR/reference/calculate.md)
  to produce a table of results

### How It Works

> [`abc()`](https://usrbinr.github.io/fpaR/reference/abc.md) requires a
> grouped tibble or lazy DBI object using
> [`dplyr::group_by()`](https://dplyr.tidyverse.org/reference/group_by.html)
> to specify the group composition that drives the contribution

**Value Capture**

- If `.value` is provided, then that column is aggregate per group
  member; otherwise, it counts rows

**Category Values**

- Provide the break points that are used to set the cumulative
  categories
- Each break point will get a letter category starting with ‘A’
- If you want to see the stores that make up the top 40% of revenue
  follow by top 70% and then 90% you should put in `c(0.4,.7,.9,1)`

| Argument        | Description                                                                                                      |
|-----------------|------------------------------------------------------------------------------------------------------------------|
| .data           | A grouped tibble or DBI object (using dplyr::group_by())                                                         |
| category_values | A numeric vector of breakpoints between 0 and 1, representing cumulative proportions for ABC categories.         |
| .value          | Optional. A column to sum for categorization. If not provided, the function counts the number of rows per group. |

Table 1

``` r
# Example

contoso::sales |> 
   dplyr::group_by(store_key) |> 
   fpaR::abc(
      category_values = c(0.4,.7,.9,1), 
      .value = margin
      )
```

    ── ABC Classification ──────────────────────────────────────────────────────────

    Function: `ABC` was executed

    ── Description: ──

    This calculates a rolling cumulative distribution of variable and segments each
    group member's contribution by the break points provided. Helpful to know which
    group member's proportational contribution to the total.

    ── Category Information ──

    • The data set is grouped by the margin and segments each group member by their first NA entry to define their cohort margin
    • This creates cohort ID that each member is assigned to eg; January 2020, February 2020, etc
    • The distinct count of each margin member in the cohort is then tracked over time

    ── Calendar: ──

    • The calendar aggregated NA to the day time unit
    • A NA calendar is created with 1 groups
    • Calendar ranges from 0 to 0
    • 0 days were missing and replaced with 0
    • New date column NA was created from NA

    ── Actions: ──

    ✔Aggregate

    ✖Shift

    ✖Compare

    ✔Proportion Of Total

    ✖Count Distinct

    ── Next Steps: ──

    • Use `calculate()` to return the results

    ────────────────────────────────────────────────────────────────────────────────

The function returns a **segment object**

- This will summarize the series of actions and meta information about
  your data
- Use
  [`calculate()`](https://usrbinr.github.io/fpaR/reference/calculate.md)
  to generate the ABC classification table
- This will return a duckdb DBI object use
  [`dplyr::collect()`](https://dplyr.tidyverse.org/reference/compute.html)
  to return a tibble

``` r
contoso::sales |> 
   dplyr::group_by(store_key) |> 
   fpaR::abc(
      category_values = c(0.4,.7,.9,1), 
      .value = margin
      ) |> 
   fpaR::calculate()
```

| store_key | abc_margin | cum_sum   | prop_total | cum_prop_total | row_id | max_row_id | cum_unit_prop | category_value | category_name |
|-----------|------------|-----------|------------|----------------|--------|------------|---------------|----------------|---------------|
| 540       | 78124.11   | 78124.11  | 0.04102100 | 0.04102100     | 1      | 57         | 0.01754386    | 0.4            | a             |
| 610       | 74603.84   | 152727.95 | 0.03917259 | 0.08019359     | 2      | 57         | 0.03508772    | 0.4            | a             |
| 510       | 69455.50   | 222183.44 | 0.03646933 | 0.11666292     | 3      | 57         | 0.05263158    | 0.4            | a             |
| 80        | 67880.51   | 290063.96 | 0.03564234 | 0.15230526     | 4      | 57         | 0.07017544    | 0.4            | a             |
| 270       | 56722.52   | 346786.47 | 0.02978356 | 0.18208882     | 5      | 57         | 0.08771930    | 0.4            | a             |
| 440       | 56500.03   | 403286.51 | 0.02966674 | 0.21175556     | 6      | 57         | 0.10526316    | 0.4            | a             |
| 450       | 54941.68   | 458228.19 | 0.02884849 | 0.24060405     | 7      | 57         | 0.12280702    | 0.4            | a             |
| 550       | 53874.43   | 512102.61 | 0.02828810 | 0.26889216     | 8      | 57         | 0.14035088    | 0.4            | a             |
| 490       | 51347.82   | 563450.44 | 0.02696145 | 0.29585360     | 9      | 57         | 0.15789474    | 0.4            | a             |
| 650       | 49467.08   | 612917.52 | 0.02597392 | 0.32182752     | 10     | 57         | 0.17543860    | 0.4            | a             |

Table 2

This table contains grouped data with various metrics, highlighting the
contribution of each group in terms of both value and transaction count.
Below is an explanation of the key columns and how to interpret the
results:

### Understanding the Results

- Store 540 has a margin of \$7,812.11 (“ABC Margin”), which accounts
  for about 4% (“prop_total”) of the total margin across all stores

- The “cum_sum” column tracks the running total of values (e.g., revenue
  or count) for each store, showing the cumulative sum up to that row

- The “cum_prop_total” column shows each store’s contribution as a
  percentage of the total margin as you move down the table

- The store with the highest contribution has a “row_id” of 1 and is
  assigned to the first category segment (‘A’) via the “category_name”
  column

- The “max_row_id” shows that there are 57 additional stores in the same
  category (‘A’)

- The “cum_unit_prop” column tracks the cumulative contribution from a
  transaction count perspective, similar to cum_prop_total but at the
  unit level

- The category_value and category_name columns define the breakpoints
  you provided, assigning stores to categories (e.g., ‘A’, ‘B’, ‘C’)
  based on their cumulative contribution

This is summarized in [Table 3](#tbl-output) below:

| Column_Name    | Description                                                                                                                                       | Example_Values   |
|----------------|---------------------------------------------------------------------------------------------------------------------------------------------------|------------------|
| cum_sum        | The cumulative sum of the specified values (e.g., revenue, count, etc.), aggregated per group. Represents the total value up to that row.         | 1000, 2500, 4000 |
| prop_total     | The proportion of the total for each row's value. Shows the percentage of the total represented by the current row's contribution.                | 0.10, 0.25, 0.40 |
| cum_prop_total | The cumulative proportion of the total, showing the running total percentage of the entire dataset as you move through the rows.                  | 0.10, 0.35, 0.75 |
| row_id         | The unique identifier for the row, often used to track or identify specific rows in the dataset. Typically sequential ID or index.                | 1, 2, 3          |
| max_row_id     | The maximum row ID in the current group (if grouping is applied), representing the total number of rows in the group.                             | 5, 5, 5          |
| cum_unit_prop  | The cumulative proportion of the unit values, similar to cum_prop_total, but typically used when the unit is treated as aggregate.                | 0.10, 0.30, 0.70 |
| category_value | The category value that corresponds to the cumulative proportion break points (e.g., top 10%, top 40%, etc.). Based on the break points provided. | 0.4, 0.7, 0.9    |
| category_name  | The name of the category assigned to each row based on the cumulative contribution. Categories are represented by letters (A, B, C, etc.).        | "A", "B", "C"    |

Table 3
