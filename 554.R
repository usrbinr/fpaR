library(tidyverse)
library(contoso)
devtools::load_all()

## create 5-5-4 calendar

x <-  contoso::sales |> fpaR::mtd(order_date,revenue,calendar_type = "standard")


con <- dbplyr::remote_con(x@datum@data)


## find beginng date indicator

min_year <- year(x@datum@min_date)

start_year <- closest_sunday_feb1(min_year)


new_cal <- fpaR:::seq_date_sql(start_date = start_year,end_date=x@datum@max_date,time_unit = "day",con =con ) |>
  augment_calendar(.date = date)



## next step add in new year indicator
new_cal |>
  dplyr::mutate(
    new_week_indicator=if_else(day_of_week==1,1,0)
    ,cumulative_week_count=cumsum(new_week_indicator)
    ,quarter_554=case_when(
      cumulative_week_count<=14~1
      ,cumulative_week_count<=28~2
      ,cumulative_week_count<=42~3
      ,.default=4
    )
    ,month_554=case_when(
      cumulative_week_count<=5~1
      ,cumulative_week_count<=10~2
      ,cumulative_week_count<=14~3
      ,.default=0
    )
    ,.before=1
  )




# Example usage:
map(2021:2024,\(x) closest_sunday_feb1(x))


generate_5_5_4_daily <- function(start_date, num_years = 1) {
  start_date <- as.Date(start_date)

  # 5-5-4 pattern: weeks per month
  weeks_per_quarter <- c(5, 5, 4)
  weeks_per_year <- rep(weeks_per_quarter, 4)  # 12 months

  # Total weeks to generate
  total_weeks <- length(weeks_per_year) * num_years

  # Generate week numbers
  week_number <- 1:total_weeks

  # Generate fiscal years
  fiscal_year <- rep(1:num_years, each = length(weeks_per_year))

  # Generate month assignment
  month_pattern <- 1:12
  month <- rep(month_pattern, times = weeks_per_year)  # expand by weeks per month
  month <- rep(month, times = num_years)              # expand for multiple years
  month <- month[1:total_weeks]                        # truncate if needed

  # Generate start dates for each week
  week_starts <- start_date + 7 * (week_number - 1)

  # Generate daily dates
  daily_dates <- unlist(lapply(week_starts, function(d) d + 0:6))

  # Repeat week, month, fiscal year info for each day
  week_number_daily <- rep(week_number, each = 7)
  month_daily <- rep(month, each = 7)
  fiscal_year_daily <- rep(fiscal_year, each = 7)

  # Return daily calendar
  data.frame(
    date = daily_dates,
    fiscal_year = fiscal_year_daily,
    month = month_daily,
    week_number = week_number_daily
  ) |>
    mutate(
      date=as.Date(date)
    )
}

# Example usage: daily calendar starting Feb 2, 2020, for 1 year
generate_5_5_4_daily("2020-02-02", num_years = 1)


## next step add in new year indicator



## add in period indicator for that
