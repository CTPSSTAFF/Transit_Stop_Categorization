library(tidyverse)

import_gtfs <- function() {
  
  returnedGTFS <- gtfstools::read_gtfs("https://cdn.mbtace.com/archive/20220923.zip")
  
  return(returnedGTFS)
}

MBTA_gtfs <- import_gtfs()


trips <- MBTA_gtfs$trips
stop_times <- MBTA_gtfs$stop_times
cal <- MBTA_gtfs$calendar
cal_att <- MBTA_gtfs$calendar_attributes

stop_time_by_trip <- left_join(trips, stop_times, by = "trip_id")

cal_att_dates_fixed <- cal_att %>% 
  full_join(cal, by = "service_id")
cal_att_dates_fixed$start_date <- gsub("-", "", cal_att_dates_fixed$start_date) %>%
  as.double()
cal_att_dates_fixed$end_date <- gsub("-", "", cal_att_dates_fixed$end_date)%>%
  as.double()

cl_att_RTL <- cal_att_dates_fixed %>%
  filter(str_detect(service_id, "RTL") & service_schedule_typicality == 1)

cal_att_filt <- cal_att_dates_fixed %>%
  filter(start_date <= 20221008 & end_date >= 20221008) %>% 
  bind_rows(cl_att_RTL) %>%
  filter(wednesday == 1 | saturday == 1 | sunday == 1) %>%
  distinct()

stop_time_by_trip_filter <- stop_time_by_trip |> filter(service_id %in% cal_att_filt$service_id) 
