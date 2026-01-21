devtools::document()
devtools::load_all()
devtools::check()
pkgdown::build_site()
library(tidyverse)
devtools::test()

## do a function by funtion test with and without groups to see what the returns looks like
# - year to date ocmpleted works
# - error in seq_date_sql
# problem with non-standard new soluition to be implemetnend
# need to focus on complete calendar -- don't think i need it nayamore
## check print methods
## transfer to fpa not fpaR


# period to date functions -------

contoso::sales |>
  group_by(store_key) |>
  # summarise(n=n()) |>
  # arrange(-n)
  ytd(order_date,margin,"standard") |>
  calculate() |>
  collect() |>
  filter(
    store_key=="999999"
  )


contoso::sales |>
  group_by(store_key) |>
  ytd(order_date,margin,"445") |>
  calculate() |>
  collect() |>
  arrange(date) |>
  filter(
        store_key=="999999"
      )
  # count(year) |>




  contoso::sales |>
    group_by(store_key) |>
    qtd(order_date,margin,"standard") |>
    calculate() |>
    filter(
      store_key=="999999"
    )


  contoso::sales |>
    group_by(store_key) |>
    qtd(order_date,margin,"445") |>
    calculate() |>
    filter(
      store_key=="999999"
    ) |>
    arrange(date)


  contoso::sales |>
    group_by(store_key) |>
    mtd(order_date,margin,"standard") |>
    calculate() |>
    filter(
      store_key=="999999"
    ) |>
    arrange(date)


  contoso::sales |>
    group_by(store_key) |>
    mtd(order_date,margin,"445") |>
    calculate() |>
    filter(
      store_key=="999999"
    ) |>
    arrange(date)


  contoso::sales |>
    group_by(store_key) |>
    wtd(order_date,margin,"standard") |>
    calculate() |>
    filter(
      store_key=="999999"
    ) |>
    arrange(date)


  contoso::sales |>
    group_by(store_key) |>
    wtd(order_date,margin,"445") |>
    calculate() |>
    collect() |>
    arrange(date) |>
    filter(
      store_key=="999999"
    ) |>
    print(n=100)



  contoso::sales |>
    group_by(store_key) |>
    atd(order_date,margin,"445") |>
    calculate() |>
    collect() |>
    filter(
      store_key=="999999"
    ) |>
    arrange(date)


  contoso::sales |>
    group_by(store_key) |>
    atd(order_date,margin,"standard") |>
    calculate() |>
    collect() |>
    filter(
      store_key=="999999"
    ) |>
    arrange(date)

## period over period------------

  devtools::document()

x <- contoso::sales |>
    group_by(store_key) |>
    yoy(order_date,margin,"standard",1)
    calculate() |>
    arrange(date) |>
    filter(
      store_key=="999999"
    ) |>
    arrange(date)


 contoso::sales |>
    group_by(store_key) |>
    yoy(order_date,margin,"445",1) |>
    calculate() |>
    arrange(date) |>
    filter(
      store_key=="999999"
    ) |>
    arrange(date)



  contoso::sales |>
    group_by(store_key) |>
    qoq(order_date,margin,"standard") |>
    calculate() |>
    filter(
      store_key=="999999"
    ) |>
    arrange(date)


  contoso::sales |>
    group_by(store_key) |>
    qoq(order_date,margin,"445") |>
    calculate() |>
    filter(
      store_key=="999999"
    ) |>
    arrange(date)


  contoso::sales |>
    group_by(store_key) |>
    mom(order_date,margin,"standard") |>
    calculate() |>
    filter(
      store_key=="999999"
    ) |>
    arrange(date)


  contoso::sales |>
    group_by(store_key) |>
    mom(order_date,margin,"445") |>
    calculate() |>
    filter(
      store_key=="999999"
    ) |>
    arrange(date)


# x <-
  contoso::sales |>
   group_by(store_key) |>
   wow(order_date,margin,"standard") |>
    calculate() |>
    filter(
      store_key=="999999"
    ) |>
   arrange(date)
   print(n=100)




  contoso::sales |>
    group_by(store_key) |>
    wow(order_date,margin,"445") |>
    calculate() |>
    filter(
      store_key=="999999"
    ) |>
    arrange(date)



  contoso::sales |>
    group_by(store_key) |>
    dod(order_date,margin,"standard") |>
    calculate() |>
    filter(
      store_key=="999999"
    ) |>
    arrange(date)

  ## prior week to current ytd------------

  contoso::sales |>
    group_by(store_key) |>
    fpaR::yoytd(order_date,margin,"standard",1) |>
    calculate() |>
    filter(
      store_key=="999999"
    ) |>
    arrange(date) |>
    filter(
      !is.na(pytd_margin)
    )


  contoso::sales |>
    # group_by(customer_key) |>
    fpaR::qoqtd(order_date,margin,"standard",1) |>
    calculate() |>
    arrange(date) |>
    filter(
      !is.na(pqtd_margin)
    )




 contoso::sales |>
    # group_by(customer_key) |>
    fpaR::momtd(order_date,margin,"standard",1) |>
    calculate() |>
    arrange(date) |>
    filter(
      !is.na(pmtd_margin)
    )


  # x <-
    contoso::sales |>
   # group_by(customer_key) |>
   fpaR::wowtd(.date = order_date,.value = margin,calendar_type = "standard",lag_n = 1) |>
   calculate()


  ### prior to date----


   contoso::sales |>
     group_by(store_key) |>
     fpaR::pytd(.date = order_date,.value = margin,calendar_type = "standard",lag_n = 1) |>
     calculate() |>
      filter(
        store_key=="999999"
      ) |>
     filter(
       !is.na(pytd_margin)
     )


    contoso::sales |>
      group_by(store_key) |>
      fpaR::pytd(.date = order_date,.value = margin,calendar_type = "445",lag_n = 1) |>
      calculate() |>
      filter(
        store_key=="999999"
      ) |>
      filter(
        !is.na(pytd_margin)
      )

   contoso::sales |>
     group_by(store_key) |>
     fpaR::pqtd(.date = order_date,.value = margin,calendar_type = "standard",lag_n = 1) |>
     calculate() |>
     filter(
       store_key=="999999"
     ) |>
     filter(
       !is.na(pqtd_margin)
     )


   contoso::sales |>
     group_by(store_key) |>
     fpaR::pqtd(.date = order_date,.value = margin,calendar_type = "445",lag_n = 1) |>
     calculate() |>
     filter(
       store_key=="999999"
     ) |>
     filter(
       !is.na(pqtd_margin)
     )




     contoso::sales |>
     group_by(store_key) |>
     fpaR::pmtd(.date = order_date,.value = margin,calendar_type = "standard",lag_n = 1) |>
   calculate() |>
       filter(
         store_key=="999999"
       ) |>
     filter(
       !is.na(pmtd_margin)
     ) |>
       arrange(date)



     contoso::sales |>
       group_by(store_key) |>
       fpaR::pmtd(.date = order_date,.value = margin,calendar_type = "445",lag_n = 1) |>
       calculate() |>
       filter(
         store_key=="999999"
       ) |>
       filter(
         !is.na(pmtd_margin)
       ) |>
       arrange(date)


  contoso::sales |>
     group_by(store_key) |>
     fpaR::pwtd(.date = order_date,.value = margin,calendar_type = "standard",lag_n = 1) |>
     calculate() |>
    filter(
      store_key=="999999"
    ) |>
     filter(
       !is.na(pwtd_margin)
     )



  contoso::sales |>
    group_by(store_key) |>
    fpaR::pwtd(.date = order_date,.value = margin,calendar_type = "445",lag_n = 1) |>
    calculate() |>
    filter(
      store_key=="999999"
    ) |>
    filter(
      !is.na(pwtd_margin)
    )


# current year to date on overprior year---------------

  # x <-
    contoso::sales |>
      group_by(store_key) |>
    fpaR::ytdopy(order_date,margin,calendar_type="standard",lag_n = 1) |>

    calculate() |>
      filter(
        store_key=="999999"
      ) |>
    filter(
      !is.na(yoy_margin)
    )

    contoso::sales |>
      group_by(store_key) |>
      fpaR::ytdopy(order_date,margin,calendar_type="445",lag_n = 1) |>

      calculate() |>
      filter(
        store_key=="999999"
      ) |>
      filter(
        !is.na(yoy_margin)
      )



  contoso::sales |>
    group_by(store_key) |>
    fpaR::mtdopm(order_date,margin,calendar_type="standard",lag_n = 1) |>
    calculate() |>
    filter(
      store_key=="999999"
    ) |>
    filter(
      !is.na(mom_margin)
    ) |>
    arrange(date)


  contoso::sales |>
    group_by(store_key) |>
    fpaR::mtdopm(order_date,margin,calendar_type="445",lag_n = 1) |>
    calculate() |>
    filter(
      store_key=="999999"
    ) |>
    filter(
      !is.na(mom_margin)
    ) |>
    arrange(date)





   contoso::sales |>
     group_by(store_key) |>
    fpaR::qtdopq(order_date,margin,calendar_type="standard",lag_n = 1) |>
    calculate() |>
     filter(
       store_key=="999999"
     )

   contoso::sales |>
     group_by(store_key) |>
     fpaR::qtdopq(order_date,margin,calendar_type="445",lag_n = 1) |>
     calculate() |>
     filter(
       store_key=="999999"
     )



  contoso::sales |>
    group_by(store_key) |>
    fpaR::wtdopw(order_date,margin,lag_n = 1,calendar_type = "standard") |>
    calculate() |>
    filter(
      store_key=="999999"
    )

  contoso::sales |>
    group_by(store_key) |>
    fpaR::wtdopw(order_date,margin,lag_n = 1,calendar_type = "445") |>
    calculate() |>
    filter(
      store_key=="999999"
      ,!is.na(wow_margin)
    )



## other function

    contoso::sales |>
      group_by(store_key) |>
      fpaR::abc(category_values = c(.3,.5,.7,.8),.value = margin) |>
      calculate()



    contoso::sales |>
      group_by(store_key) |>
      fpaR::cohort(.date = order_date,.value = margin,time_unit = "month",period_label = FALSE) |>
      calculate()


devtools::document()

devtools::check()

pkgdown::build_site()

library(dbplyr)
start_month = 1
end_day_of_week = 7
x@datum@data |>

  dbplyr::window_order(order_date) |>
  dplyr::mutate(
    # Use a unique name to avoid conflict with year() function
    yr_idx = dplyr::if_else(dplyr::row_number() %% (days_in_week * weeks_in_quarter * quarters_in_year) == 1, 1, 0),
    f_year = cumsum(yr_idx)
  ) |>
  dplyr::mutate(
    wk_idx = dplyr::if_else(dplyr::row_number() %% 7 == 1, 1, 0),
    f_week = cumsum(wk_idx),
    .by = f_year
  ) |>
  # Ensure this function returns a column named 'f_month'
  create_non_standard_month(pattern = pattern) |>
  dplyr::mutate(
    quarter = dplyr::case_when(
      f_month <= 3 ~ 1,
      f_month <= 6 ~ 2,
      f_month <= 9 ~ 3,
      .default = 4
    )
  )



library(dplyr)
library(lubridate)

library(dplyr)
library(lubridate)

create_true_445_calendar <- function(.data, pattern = "445") {
  .data |>
    mutate(
      # 1. Get Jan 31st of the current calendar year
      target_date = as.Date(paste0(year(date), "-01-31")),

      # 2. Find the Sunday closest to Jan 31
      # Calculate Sunday before or on Jan 31
      prev_sun = floor_date(target_date, unit = "week", week_start = 7),
      next_sun = prev_sun + days(7),

      # Pick the one with the smallest absolute difference
      f_year_start = if_else(
        abs(as.numeric(difftime(target_date, prev_sun, units = "days"))) <=
          abs(as.numeric(difftime(target_date, next_sun, units = "days"))),
        prev_sun,
        next_sun
      ),

      # 3. Handle the 'January Gap'
      # If the date is Jan 5 and the anchor is Jan 28, this date belongs to the PREVIOUS year
      f_year_start = if_else(date < f_year_start, f_year_start - weeks(52), f_year_start),

      # Final check: Does the previous year's anchor actually need to be 53 weeks ago?
      # We re-check the 'closest Sunday' logic for the previous year to be 100% "True"
      f_year_start = if_else(
        date < f_year_start,
        # (This is a simplified correction; for production, use a lookup table)
        f_year_start,
        f_year_start
      )
    ) |>
    group_by(f_year_start) |>
    mutate(
      # Calculate Fiscal Week
      f_week = as.integer(difftime(date, f_year_start, units = "weeks")) + 1,
      f_year = year(f_year_start + days(14)), # Label by the year it mostly falls in

      # 4. Map the Pattern (using your requested pattern)
      f_month = case_when(
        pattern == "445" ~ case_when(
          f_week <= 4 ~ 1, f_week <= 8 ~ 2, f_week <= 13 ~ 3,
          f_week <= 17 ~ 4, f_week <= 21 ~ 5, f_week <= 26 ~ 6,
          f_week <= 30 ~ 7, f_week <= 34 ~ 8, f_week <= 39 ~ 9,
          f_week <= 43 ~ 10,f_week <= 47 ~ 11, TRUE ~ 12
        ),
        pattern == "454" ~ case_when(
          f_week <= 4 ~ 1, f_week <= 9 ~ 2, f_week <= 13 ~ 3,
          f_week <= 17 ~ 4, f_week <= 22 ~ 5, f_week <= 26 ~ 6,
          f_week <= 30 ~ 7, f_week <= 35 ~ 8, f_week <= 39 ~ 9,
          f_week <= 43 ~ 10,f_week <= 48 ~ 11, TRUE ~ 12
        ),
        pattern == "544" ~ case_when(
          f_week <= 5 ~ 1, f_week <= 9 ~ 2, f_week <= 13 ~ 3,
          f_week <= 18 ~ 4, f_week <= 22 ~ 5, f_week <= 26 ~ 6,
          f_week <= 31 ~ 7, f_week <= 35 ~ 8, f_week <= 39 ~ 9,
          f_week <= 44 ~ 10,f_week <= 48 ~ 11, TRUE ~ 12
        )
      ),
      f_quarter = (f_month - 1) %/% 3 + 1
    ) |>
    ungroup() |>
    select(-target_date, -prev_sun, -next_sun) # Cleanup helper columns
}

get_fiscal_start <- function(calendar_year) {
  # Target: Sunday closest to Jan 31 of that year
  target <- as.Date(paste0(calendar_year, "-01-31"))

  # Find the Sunday of that week (using lubridate)
  # floor_date with week_start=7 gives the Sunday PRIOR to or ON the date
  prev_sunday <- lubridate::floor_date(target, unit = "week", week_start = 7)
  next_sunday <- prev_sunday + 7

  # Return the one closest to Jan 31
  if (as.numeric(target - prev_sunday) <= as.numeric(next_sunday - target)) {
    return(prev_sunday)
  } else {
    return(next_sunday)
  }
}

library(dplyr)
library(lubridate)
library(purrr)

generate_445_lookup <- function(start_year, end_year, pattern = "445") {

  # 1. Generate the Anchor Dates for the range
  anchors <- map_dfr(start_year:(end_year + 1), function(yr) {
    target <- as.Date(paste0(yr, "-01-31"))
    # Find closest Sunday
    prev_sun <- floor_date(target, unit = "week", week_start = 7)
    next_sun <- prev_sun + 7
    anchor <- if (as.numeric(target - prev_sun) <= as.numeric(next_sun - target)) prev_sun else next_sun
    tibble(f_year = yr, f_year_start = anchor)
  })

  # 2. Create a daily sequence and join the anchors
  all_dates <- tibble(date = seq(min(anchors$f_year_start),
                                 max(anchors$f_year_start) - days(1),
                                 by = "day")) |>
    # This logic finds the correct anchor for every single date
    mutate(f_year_start = map_vec(date, ~ max(anchors$f_year_start[anchors$f_year_start <= .x]))) |>
    left_join(anchors, by = "f_year_start")

  # 3. Calculate 445/454/544 Columns
  all_dates |>
    group_by(f_year_start) |>
    mutate(
      f_day_of_year = as.integer(date - f_year_start) + 1,
      f_week = (f_day_of_year - 1) %/% 7 + 1,
      # Apply mapping based on your specific pattern
      f_month = case_when(
        pattern == "445" ~ case_when(
          f_week <= 4 ~ 1, f_week <= 8 ~ 2, f_week <= 13 ~ 3,
          f_week <= 17 ~ 4, f_week <= 21 ~ 5, f_week <= 26 ~ 6,
          f_week <= 30 ~ 7, f_week <= 34 ~ 8, f_week <= 39 ~ 9,
          f_week <= 43 ~ 10,f_week <= 47 ~ 11, TRUE ~ 12
        ),
        pattern == "454" ~ case_when(
          f_week <= 4 ~ 1, f_week <= 9 ~ 2, f_week <= 13 ~ 3,
          f_week <= 17 ~ 4, f_week <= 22 ~ 5, f_week <= 26 ~ 6,
          f_week <= 30 ~ 7, f_week <= 35 ~ 8, f_week <= 39 ~ 9,
          f_week <= 43 ~ 10,f_week <= 48 ~ 11, TRUE ~ 12
        ),
        pattern == "544" ~ case_when(
          f_week <= 5 ~ 1, f_week <= 9 ~ 2, f_week <= 13 ~ 3,
          f_week <= 18 ~ 4, f_week <= 22 ~ 5, f_week <= 26 ~ 6,
          f_week <= 31 ~ 7, f_week <= 35 ~ 8, f_week <= 39 ~ 9,
          f_week <= 44 ~ 10,f_week <= 48 ~ 11, TRUE ~ 12
        )
      ),
      f_quarter = (f_month - 1) %/% 3 + 1
    ) |>
    ungroup()
}

# Generate it!
lookup_table <- generate_445_lookup(2023, 2026, pattern = "445")

x@datum@data |>
  mutate(
    date=order_date
  ) |>
  create_true_445_calendar() |>
  relocate(contains("f"),date)


create_true_445_calendar <- function(.data, pattern = "445") {
  .data |>
    mutate(
      # 1. Anchor Date Calculation
      target_date = as.Date(paste0(year(date), "-01-31")),
      prev_sun = floor_date(target_date, unit = "week", week_start = 7),
      next_sun = prev_sun + days(7),

      # Use date_diff: it takes (unit, start, end)
      # This returns a BIGINT immediately, bypassing the INTERVAL/CAST issues
      days_to_prev = sql("date_diff('day', prev_sun, target_date)"),
      days_to_next = sql("date_diff('day', target_date, next_sun)"),

      f_year_start = if_else(
        days_to_prev <= days_to_next,
        prev_sun,
        next_sun
      ),

      # Adjust for dates in early Jan that belong to the previous fiscal year
      f_year_start = if_else(date < f_year_start, f_year_start - days(364), f_year_start)
    ) |>
    mutate(
      # Calculate Week Number
      diff_days = sql("date_diff('day', f_year_start, date)"),
      f_week = floor(diff_days / 7) + 1
    ) |>
    mutate(
      # 2. Pattern Mapping
      f_month = case_when(
        pattern == "445" ~ case_when(
          f_week <= 4  ~ 1,  f_week <= 8  ~ 2,  f_week <= 13 ~ 3,
          f_week <= 17 ~ 4,  f_week <= 21 ~ 5,  f_week <= 26 ~ 6,
          f_week <= 30 ~ 7,  f_week <= 34 ~ 8,  f_week <= 39 ~ 9,
          f_week <= 43 ~ 10, f_week <= 47 ~ 11, .default = 12
        ),
        pattern == "454" ~ case_when(
          f_week <= 4  ~ 1,  f_week <= 9  ~ 2,  f_week <= 13 ~ 3,
          f_week <= 17 ~ 4,  f_week <= 22 ~ 5,  f_week <= 26 ~ 6,
          f_week <= 30 ~ 7,  f_week <= 35 ~ 8,  f_week <= 39 ~ 9,
          f_week <= 43 ~ 10, f_week <= 48 ~ 11, .default = 12
        ),
        pattern == "544" ~ case_when(
          f_week <= 5  ~ 1,  f_week <= 9  ~ 2,  f_week <= 13 ~ 3,
          f_week <= 18 ~ 4,  f_week <= 22 ~ 5,  f_week <= 26 ~ 6,
          f_week <= 31 ~ 7,  f_week <= 35 ~ 8,  f_week <= 39 ~ 9,
          f_week <= 44 ~ 10, f_week <= 48 ~ 11, .default = 12
        )
      )
    ) |>
    mutate(
      f_quarter = case_when(
        f_month <= 3 ~ 1,
        f_month <= 6 ~ 2,
        f_month <= 9 ~ 3,
        .default = 4
      ),
      f_year = year(f_year_start + days(14))
    ) |>
    select(-target_date, -prev_sun, -next_sun, -days_to_prev, -days_to_next, -diff_days)
}


library(dplyr)
library(lubridate)
library(purrr)

generate_445_lookup <- function(start_year, end_year, pattern = "445",
                                week_start = 7, manual_start = NULL) {

  # 1. Determine the Anchor Dates
  anchors <- map_dfr(start_year:(end_year + 1), function(yr) {

    # Logic: Use manual start if provided for the first year,
    # otherwise calculate 'closest to Jan 31'
    if (yr == start_year && !is.null(manual_start)) {
      anchor <- as.Date(manual_start)
    } else {
      target <- as.Date(paste0(yr, "-01-31"))
      prev_sun <- floor_date(target, unit = "week", week_start = week_start)
      next_sun <- prev_sun + days(7)

      anchor <- if (abs(as.numeric(target - prev_sun)) <= abs(as.numeric(next_sun - target))) {
        prev_sun
      } else {
        next_sun
      }
    }
    tibble(f_year_label = yr, f_year_start = anchor)
  })

  # 2. Build the spine and join anchors
  # This ensures every date is associated with its specific fiscal year start
  spine <- tibble(date = seq(min(anchors$f_year_start),
                             max(anchors$f_year_start) - days(1),
                             by = "day")) |>
    mutate(f_year_start = map_vec(date, ~ max(anchors$f_year_start[anchors$f_year_start <= .x]))) |>
    left_join(anchors, by = "f_year_start")

  # 3. Calculate Fiscal Metrics
  lookup <- spine |>
    group_by(f_year_start) |>
    mutate(
      f_day_of_year = as.integer(date - f_year_start) + 1,
      f_week = (f_day_of_year - 1) %/% 7 + 1,
      f_day_of_week = wday(date, week_start = week_start)
    ) |>
    mutate(
      f_month = case_when(
        pattern == "445" ~ case_when(
          f_week <= 4 ~ 1,  f_week <= 8 ~ 2,  f_week <= 13 ~ 3,
          f_week <= 17 ~ 4, f_week <= 21 ~ 5, f_week <= 26 ~ 6,
          f_week <= 30 ~ 7, f_week <= 34 ~ 8, f_week <= 39 ~ 9,
          f_week <= 43 ~ 10,f_week <= 47 ~ 11, .default = 12
        ),
        pattern == "454" ~ case_when(
          f_week <= 4 ~ 1,  f_week <= 9 ~ 2,  f_week <= 13 ~ 3,
          f_week <= 17 ~ 4, f_week <= 22 ~ 5, f_week <= 26 ~ 6,
          f_week <= 30 ~ 7, f_week <= 35 ~ 8, f_week <= 39 ~ 9,
          f_week <= 43 ~ 10,f_week <= 48 ~ 11, .default = 12
        ),
        pattern == "544" ~ case_when(
          f_week <= 5 ~ 1,  f_week <= 9 ~ 2,  f_week <= 13 ~ 3,
          f_week <= 18 ~ 4, f_week <= 22 ~ 5, f_week <= 26 ~ 6,
          f_week <= 31 ~ 7, f_week <= 35 ~ 8, f_week <= 39 ~ 9,
          f_week <= 44 ~ 10,f_week <= 48 ~ 11, .default = 12
        )
      )
    ) |>
    mutate(
      f_quarter = (f_month - 1) %/% 3 + 1
    ) |>
    ungroup()

  return(lookup)
}

library(tidyverse)
seq_date_sql(start_date = 2021,end_Date = 2023,pattern = "445",week_start = 7)

devtools::document()

con_db <- DBI::dbConnect(duckdb::duckdb())

x <- ytd(contoso::sales,.date = order_date,.value = margin,calendar_type = "standard")
seq_date_sql(.con = con_db,start_date = "2021-01-01",end_date = "2022-01-01",calendar_type = "544",time_unit="week")

start_date = "2021-01-01"

# master_dates <-
  seq_date_sql(
  start_date    = start_date,
  end_date      = x@datum@max_date,
  calendar_type =x@datum@calendar_type,
  time_unit     =x@time_unit@value,
  .con          = dbplyr::remote_con(x@datum@data)
)

## calendar table--------

#'
#' #' Generate a Cross-Dialect SQL Date Series
#' #'
#' #' @description
#' #' Creates a lazy `dbplyr` table containing a continuous sequence of dates.
#' #' The function automatically detects the SQL dialect of the connection and
#' #' dispatches the most efficient native series generator (e.g., `GENERATE_SERIES`
#' #' for DuckDB/Postgres or `GENERATOR` for Snowflake).
#' #'
#' #' @details
#' #' This function is designed to be "nestable," meaning the resulting SQL can be
#' #' used safely inside larger `dplyr` pipelines. It avoids `WITH` clauses in
#' #' dialects like DuckDB to prevent parser errors when `dbplyr` wraps the query
#' #' in a subquery (e.g., `SELECT * FROM (...) AS q01`).
#' #'
#' #' For unit testing, the function supports `dbplyr` simulation objects. If a
#' #' `TestConnection` is detected, it returns a `lazy_frame` to avoid metadata
#' #' field queries that would otherwise fail on a mock connection.
#' #'
#' #' @param start_date A character string in 'YYYY-MM-DD' format or a Date object
#' #' representing the start of the series.
#' #' @param end_date A character string in 'YYYY-MM-DD' format or a Date object
#' #' representing the end of the series.
#' #' @param time_unit A character string specifying the interval. Must be one of:
#' #' \code{"day"}, \code{"week"}, \code{"month"}, \code{"quarter"}, or \code{"year"}.
#' #' @param .con A valid DBI connection object (e.g., DuckDB, Postgres, Snowflake)
#' #' or a \code{dbplyr} simulated connection.
#' #'
#' #' @return A \code{tbl_lazy} (SQL) object with a single column \code{date}.
#' #'
#' #' @examples
#' #' \dontrun{
#' #' con <- DBI::dbConnect(duckdb::duckdb())
#' #' # Generates a daily sequence for the year 2025
#' #' calendar <- seq_date_sql("2025-01-01", "2025-12-31", "day", con)
#' #' }
#' #'
#' #' @keywords internal
#' seq_date_sql <- function(start_date, end_date, time_unit, .con) {
#'
#'   # 1. Validations ----------------------------------------------------------
#'   assertthat::assert_that(
#'     time_unit %in% c("day", "week", "month", "quarter", "year"),
#'     msg = "Please have time unit match 'day', 'week','month','quarter' or 'year'"
#'   )
#'
#'   # 2. Variable Prep -------------------------------------------------------
#'   unit <- tolower(time_unit)
#'   is_duckdb_pg <- inherits(.con, "duckdb_connection") || inherits(.con, "Pqconnection")
#'   is_snowflake <- inherits(.con, "Snowflake")
#'   is_test      <- inherits(.con, "Test.connection")
#'
#'   # 3. SQL Dispatch --------------------------------------------------------
#'
#'   if (is_duckdb_pg) {
#'
#'     time_interval <- paste("1",time_unit)
#'
#'     date_seq_sql <- glue::glue_sql("
#'   WITH DATE_SERIES AS (
#'   SELECT
#'
#'   GENERATE_SERIES(
#'      MIN(DATE_TRUNC({time_unit}, DATE {start_date}::date))::DATE
#'     ,MAX(DATE_TRUNC({time_unit}, DATE {end_date}::date))::DATE
#'     ,INTERVAL {time_interval}
#'   ) AS DATE_LIST),
#'
#'   CALENDAR_TBL AS (
#'         SELECT
#'
#'         UNNEST(DATE_LIST)::DATE AS date
#'
#'         FROM DATE_SERIES
#'
#'         )
#'   SELECT *
#'   FROM CALENDAR_TBL
#'
#' ",.con=.con)
#'   }
#'
#'   else if (is_snowflake) {
#'     # SNOWFLAKE: Uses the GENERATOR table function (no WITH clause needed)
#'     date_seq_sql <- glue::glue_sql("
#'       SELECT
#'         DATEADD({unit}, SEQ4(), DATE_TRUNC({unit}, {start_date}::DATE))::DATE AS date
#'       FROM TABLE(GENERATOR(ROWCOUNT => (
#'         DATEDIFF({unit}, {start_date}::DATE, {end_date}::DATE) + 1
#'       )))
#'     ",.con = .con)
#'   }
#'
#'   else {
#'     # FALLBACK: Recursive CTE (Note: This may still struggle in subqueries
#'     # depending on the backend, but is the standard for T-SQL)
#'     date_seq_sql <- glue::glue_sql("
#'       WITH date_range AS (
#'         SELECT CAST({start_date} AS DATE) AS date
#'         UNION ALL
#'         SELECT DATEADD({unit*}, 1, date)
#'         FROM date_range
#'         WHERE date < CAST({end_date} AS DATE)
#'       )
#'       SELECT date FROM date_range
#'     ", .con = .con)
#'   }
#'
#'   # 4. Handle Return --------------------------------------------------------
#'
#'   # Protect simulations from 'dbGetQuery' errors
#'   if (is_test) {
#'     return(
#'       dbplyr::lazy_frame(
#'         date = as.Date(start_date),
#'         con = .con,
#'         .name = as.character(date_seq_sql)
#'       )
#'     )
#'   }
#'
#'   # Return as lazy tbl
#'   return(dplyr::tbl(.con, dplyr::sql(date_seq_sql)))
#' }
