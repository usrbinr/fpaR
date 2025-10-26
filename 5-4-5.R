

# Load necessary libraries
library(tidyverse)

# Set start date and year
start_date <- as.Date("2025-01-01")

# Generate a sequence of dates for the whole year
pacman::p_load(tidyverse,contoso,fpaR,rlang,devtools,usethis)


sales_dbi <- fpaR::make_db_tbl(sales)

con <- dbplyr::remote_con(sales_dbi)
## need a start date
## need day of week

wkday_start=7
start_date <- "2021-01-02"

fpaR::seq_date_sql(start_date = start_date,end_date = "2024-01-01",time_unit = "day",con = con) |>
  mutate(
    year = lubridate::year(date)
    ,month = lubridate::month(date)
    ,wkday=wday(date)
    ,start_week_indicator=if_else(wkday==wkday_start,1,0)
  ) |>
  mutate(
    week_count=cumsum(start_week_indicator)
    ,month_non_standard=case_when(
      week_count %in% 1:4 ~1
      ,week_count %in% 5:9~2
      ,week_count %in% 10:13~3
      ,week_count %in% 14:18~4
      ,week_count %in% 19:24~5
      ,week_count %in% 25:29~6
      ,week_count %in% 30:34~7
      ,.default=NA
    )
    ,quarter_non_standar=case_when(
      month_non_standard %in% 1:3 ~1
      ,month_non_standard %in% 4:6 ~2
      ,month_non_standard %in% 7:9 ~3
      ,month_non_standard %in% 10:12 ~4
      ,.default=NA
    )
    ,.by=c(year)
  ) |>
  arrange(date)


"hello"







dates <- seq.Date(start_date, by = "day", length.out = 365)

# Create a dataframe with year, month, and week number
calendar_df <- tibble(
  date = dates,
  year = lubridate::year(dates),
  month = lubridate::month(dates),
  week = lubridate::week(dates)
)

# Add quarter and week in quarter info
# calendar_df <-
  calendar_df %>%
  mutate(
    quarter = case_when(
      month %in% 1:3 ~ 1,
      month %in% 4:6 ~ 2,
      month %in% 7:9 ~ 3,
      month %in% 10:12 ~ 4
    ),
    week_in_quarter = case_when(
      month %in% 1:3 ~ week %% 5,
      month %in% 4:6 ~ ifelse(week <= 13, 1, ifelse(week <= 18, 2, 3)),
      month %in% 7:9 ~ ifelse(week <= 26, 1, 2),
      month %in% 10:12 ~ ifelse(week <= 33, 1, ifelse(week <= 38, 2, 3))
    )
  )

# Preview the calendar data
calendar_df %>%
  filter(year == 2025) %>%
  head(20)  # Show first 20 rows for checking

