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

pak::pak("usrbinr/fpaR")
```

## What is in fpaR?

There are 3 main categories of functions:

- Time intelligence (Ready for testing and feedback)
- Segmentation strategies (work in progress)
- Factor Analysis (work in progress)

### Time intelligence

`fpaR` provides readily available functions for most time intelligence
analysis such as **Year-over-Year**(`yoy()`),
**Month-to-Date**(`mtd()`), and **Current Year-to-Date over Previous
Year-to-Date** (`ytdopy()`) analysis.

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

## Datasets

- This package leverages the
  [Contoso](https://usrbinr.github.io/contoso/) package for its
  analysis. The contoso datasets are fictional business transaction of
  Contoso toy company which are helpful for business intelligence
  related analysis

This is an **active work-in-progress**, and feedback, testing, and
contributions are welcome!

## Future capabilities

Is there a future capability that you want to see here? please open up a
[discussion](https://github.com/usrbinr/fpaR/discussions) on our github
site

### **Segmentation Strategies**

Provides functions to segment and categorize your data into meaningful
business categories.

#### **Example Segmentation Methods:**

- **New vs. Returning** Distinguishing first-time buyers from repeat
  customers
- **K-means Clustering** Grouping data points based on patterns
- **UMAP (Uniform Manifold Approximation and Projection)**
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
