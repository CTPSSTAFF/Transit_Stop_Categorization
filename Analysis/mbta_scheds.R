library(tidyverse)

trips <- read_csv("./GTFS_Data/mbta/trips.txt")
stop_times <- read_csv("./GTFS_Data/mbta/stop_times.txt")
cal <- read_csv("./GTFS_Data/mbta/calendar.txt")
cal_att <- read_csv("./GTFS_Data/mbta/calendar_attributes.txt") 

stop_time_by_trip <- left_join(trips, stop_times, by = "trip_id")

cal_att_filt <- cal_att |> 
  full_join(cal, by = "service_id") |> 
  filter(start_date <= 20220928 & end_date >= 20220928) |>
  filter(wednesday == 1 | saturday == 1 | sunday == 1) 

stop_time_by_trip_filter <- stop_time_by_trip |> filter(service_id %in% cal_att_filt$service_id)

stop_time_by_trip_filter |> 
  filter(route_id == 8, stop_id == 111) |> 
  arrange(arrival_time) |> 
  View()

stop_time_by_trip |> 
  filter(route_id == 8, stop_id == 111) |> 
  arrange(arrival_time) |> 
  View()

