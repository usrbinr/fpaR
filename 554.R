library(tidyverse)
library(contoso)
devtools::document()

devtools::load_all()



## create 5-5-4 calendar

x <-  contoso::sales |> fpaR::mtd(order_date,revenue,calendar_type = "standard")


con <- dbplyr::remote_con(x@datum@data)

# complete calendar with all attributes

new_cal <- fpaR:::seq_date_sql(start_date = "2025-01-01",end_date = "2025-12-31",time_unit = "day",con =con ) |>
  augment_calendar(.date = date)


## next step add in new year indicator
new_cal |>
  dplyr::mutate(
    new_year_date_indicator=if_else(month_of_year==2&day_of_year==4,1,0)
    ,.before=1
  )

## next step add in new year indicator



## add in period indicator for that
