
library(gtfsr)
library(tidyverse)
library(lubridate)

# Convert GTFS times into minutes after midnight.
to_minutesaftermidnight <- function(timecolumn) {
  min_aft_mid <- coalesce(
    (hour(hms(timecolumn)) * 60 + minute(hms(timecolumn)) * 1 + second(hms(timecolumn)) / 60),
    (hour(hm(timecolumn)) * 60 + minute(hm(timecolumn)) * 1 + second(hm(timecolumn)) / 60),
    (hour(ymd_hms(timecolumn)) * 60 + minute(ymd_hms(timecolumn)) * 1 + second(ymd_hms(timecolumn)) / 60)
  )
  min_aft_mid <- as.double(min_aft_mid)
  
  min_aft_mid <- ifelse(min_aft_mid < 180, 1440 + min_aft_mid, min_aft_mid)
  
  return(min_aft_mid)
}

# Quietly load the GTFS file from a local path.
import_gtfs_ql <- function(path) {
  
  returnedGTFS <- tidytransit::read_gtfs(path = path)
  
  # returnedGTFS <- gtfsr::import_gtfs(paths = path,
  #                                    local = TRUE,
  #                                    quiet = TRUE)
  return(returnedGTFS)
}

# Calculate the stop headways.
stop_headways_GTFS <- function(path, WD_id, SA_id, SU_id) {

  returnedGTFS <- import_gtfs_ql(path)

  returnedGTFS$tripsinschedule <- returnedGTFS$trips %>% filter(service_id %in% c(WD_id, SA_id, SU_id))
  
  returnedGTFS$tripsinschedule <- returnedGTFS$tripsinschedule %>% 
    mutate(DOW = case_when(service_id %in% WD_id ~ "WD",
                           service_id %in% SA_id ~ "SA",
                           service_id %in% SU_id ~ "SU",
                           TRUE ~ "Err")) %>% 
    mutate(direction_id = NA)
    

  returnedGTFS$stop_times <- returnedGTFS$stop_times %>%
    mutate(
      arrival_time_mam = to_minutesaftermidnight(arrival_time) #convert arrival time to minutes after midnight
    )
  
  returnedGTFS$stop_times <- returnedGTFS$stop_times %>% 
    group_by(trip_id) %>% 
    # Fix missing stop times.
    mutate(
           distancetp = if_else(is.na(arrival_time_mam), NA_real_ , as.double(shape_dist_traveled)),
      
           last_tp = zoo::na.locf(arrival_time_mam),
           next_tp = zoo::na.locf(arrival_time_mam, fromLast = TRUE),
           last_dis = zoo::na.locf(distancetp),
           next_dis = zoo::na.locf(distancetp, fromLast = TRUE),
           # This assigns times to every stop arrival based on the distance traveled between timepoints. If every stop has an arrival time,
           # it shouldn't do anything. 
           arrival_time_mam_inter = (next_tp - last_tp) * ((as.double(shape_dist_traveled)- last_dis)/(next_dis - last_dis)) + last_tp,
           arrival_time_mam = if_else(is.nan(arrival_time_mam_inter), arrival_time_mam, arrival_time_mam_inter))  %>% 
    select(-distancetp, -last_tp, -next_tp, -last_dis, -next_dis, -arrival_time_mam_inter)
             
  
  returnedGTFS$stop_times_inSch <- returnedGTFS$stop_times %>% 
    inner_join(returnedGTFS$tripsinschedule %>% select(trip_id, service_id, DOW, route_id, direction_id), by = "trip_id") 
  
  stop_headways <- returnedGTFS$stop_times_inSch %>%
    group_by(DOW, stop_id, direction_id) %>% 
    arrange(stop_id, DOW, arrival_time_mam) %>% 
    filter(pickup_type == 0) %>% #select regularly scheduled pickups
    mutate(
      preceding_arrival = lag(arrival_time_mam),
      preceding_headway = arrival_time_mam - preceding_arrival) %>% 
    summarize(minimumArrival_mam = min(arrival_time_mam),
              maximumArrival_mam = max(arrival_time_mam),
              trips = n(),
              averageHeadway = mean(preceding_headway, na.rm = TRUE),
              longestHeadway = max(preceding_headway, na.rm = TRUE),
              Percentile90_hw = quantile(preceding_headway, probs = 0.90, na.rm = TRUE)) %>% 
    ungroup()
  
  return(stop_headways)
}

# Get detailed information on whether each stop passes for span and/or frequency
freq_service_detailed <- function(df) {
  out <- df %>%
    mutate(
      span_min = if_else(DOW %in% c("WD"), 7 * 60, 8 * 60),
      span_max = if_else(DOW %in% c("WD"), 19 * 60, 18.5 * 60),
      
      freq_min = if_else(DOW %in% c("WD"), 15, 20),
      
      span_pass = minimumArrival_mam <= span_min &
        maximumArrival_mam >= span_max,
      freq_pass = averageHeadway <= freq_min
    )
  return(out)
}

# Summarize the detailed report into a simple report.
freq_service_summary <- function(df) {
  out <- freq_service_detailed(df) %>%
    group_by(stop_id) %>%
    summarize(passing_values = sum(span_pass, na.rm = TRUE) + sum(freq_pass, na.rm = TRUE)) %>%
    mutate(frequent_stop = passing_values == 4)
  
  return(out)
}

# Get a list of the trips for by service ID. 
read_GTFS_cal <- function(path, WD_id, SA_id, SU_id) {
  
  returnedGTFS <- gtfsr::import_gtfs(paths = path,
                                     local = TRUE,
                                     quiet = TRUE)
  
  trips_per_id <- returnedGTFS$trips_df %>% group_by(service_id) %>% summarize(n_trips = n())
  
  cal <- returnedGTFS$calendar_df %>% left_join(trips_per_id, by = "service_id")
  
  return(cal)

}
