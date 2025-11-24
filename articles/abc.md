# ABC Segmentation

### Introduction

In business and financial analytics, the **ABC classification** method
is widely used to categorize items, customers, or other groups according
to their contribution to a total metric.

The [`abc()`](https://usrbinr.github.io/fpaR/reference/abc.md) function
provides a flexible and robust way to perform ABC segmentation, either
based on **transaction counts** or the sum of a **numeric variable**
such as sales margin or revenue.

### Function Purpose

[`abc()`](https://usrbinr.github.io/fpaR/reference/abc.md):

- Segments a dataset into categories (A, B, C, etc.) based on cumulative
  contribution.
- Allows for **custom break points** (e.g., top 10% = A, next 40% = B,
  etc.).
- Works on both **grouped tibbles** and **database-backed objects**.
- Returns a **segment object**, which is processed by
  [`calculate()`](https://usrbinr.github.io/fpaR/reference/calculate.md)
  to produce a table of results.

### How It Works

> [`fpaR::abc()`](https://usrbinr.github.io/fpaR/reference/abc.md)
> requires a grouped tibble or lazy DBI object using
> [`dplyr::group_by()`](https://dplyr.tidyverse.org/reference/group_by.html)
> to specific the groups that drive the contribution

**Value Capture**

- If `.value` is provided, the function sums it per group; otherwise, it
  counts rows.

**Segment Object Creation**

- The function creates a `segment` object which stores all the necessary
  metadata for later computation. **Category Values**

- [Table 1](#tbl-abc-args) explains the break points should be
  cumulative so if you want to see the stores that make up the top 40%
  of revenue follow by top 70% and then 90% you should put in
  `c(0.4,.7,.9,1)`

| Argument        | Description                                                                                                      |
|-----------------|------------------------------------------------------------------------------------------------------------------|
| .data           | A grouped tibble or DBI object (using dplyr::group_by())                                                         |
| category_values | A numeric vector of breakpoints between 0 and 1, representing cumulative proportions for ABC categories.         |
| .value          | Optional. A column to sum for categorization. If not provided, the function counts the number of rows per group. |

Table 1

### Output

The function returns a **segment object**. Use
[`calculate()`](https://usrbinr.github.io/fpaR/reference/calculate.md)
to generate the ABC classification table:

If we wanted to

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

To return the results, use
[`fpaR::calculate()`](https://usrbinr.github.io/fpaR/reference/calculate.md)

``` r
contoso::sales |> 
   dplyr::group_by(store_key) |> 
   fpaR::abc(
      category_values = c(0.4,.7,.9,1), 
      .value = margin
      ) |> 
   fpaR::calculate()
```

| store_key | abc_margin | cum_sum | prop_total  | cum_prop_total | row_id | max_row_id | cum_unit_prop | category_value | category_name |
|-----------|------------|---------|-------------|----------------|--------|------------|---------------|----------------|---------------|
| 510       | 69455.50   | 2415418 | 0.016949770 | 0.5894534      | 4      | 58         | 0.06896552    | 0.4            | a             |
| 400       | 46370.18   | 3045628 | 0.011316078 | 0.7432485      | 16     | 58         | 0.27586207    | 0.4            | a             |
| 660       | 42338.14   | 3131933 | 0.010332108 | 0.7643101      | 18     | 58         | 0.31034483    | 0.4            | a             |
| 440       | 56500.03   | 2596521 | 0.013788146 | 0.6336494      | 7      | 58         | 0.12068966    | 0.4            | a             |
| 540       | 78124.11   | 2271359 | 0.019065238 | 0.5542974      | 2      | 58         | 0.03448276    | 0.4            | a             |
| 80        | 67880.51   | 2483298 | 0.016565414 | 0.6060188      | 5      | 58         | 0.08620690    | 0.4            | a             |
| 550       | 53874.43   | 2705337 | 0.013147399 | 0.6602046      | 9      | 58         | 0.15517241    | 0.4            | a             |
| 470       | 39874.75   | 3295960 | 0.009730947 | 0.8043389      | 22     | 58         | 0.37931034    | 0.4            | a             |
| 450       | 54941.68   | 2651463 | 0.013407849 | 0.6470572      | 8      | 58         | 0.13793103    | 0.4            | a             |
| 560       | 43966.48   | 3089595 | 0.010729485 | 0.7539780      | 17     | 58         | 0.29310345    | 0.4            | a             |

Table 2
