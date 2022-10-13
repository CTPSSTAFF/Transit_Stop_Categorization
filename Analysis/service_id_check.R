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

cal_att_filt <- cal_att %>% 
  full_join(cal, by = "service_id")
cal_att_filt$start_date <- gsub("-", "", cal_att_filt$start_date) %>%
  as.double()
cal_att_filt$end_date <- gsub("-", "", cal_att_filt$end_date)%>%
  as.double()
cal_att_filt <- cal_att_filt%>%
  filter(start_date <= 20220928 & end_date >= 20220928) %>%
  filter(wednesday == 1 | saturday == 1 | sunday == 1) 

stop_time_by_trip_filter <- stop_time_by_trip |> filter(service_id %in% cal_att_filt$service_id)
