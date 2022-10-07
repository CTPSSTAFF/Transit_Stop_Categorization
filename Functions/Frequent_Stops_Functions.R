library(gtfsr)
library(tidyverse)
library(lubridate)
library(gtfstools)

# Convert GTFS times into minutes after midnight.
to_minutesaftermidnight <- function(GTFS, file, timecolumn) {
  # Convert from time format to number of minutes after midnight
  sec_stop_time <- convert_time_to_seconds(GTFS, file = file) 
  min_aft_mid <- sec_stop_time$stop_time$arrival_time_secs / 60
  as.double()
  
  # If the stop is before 3 AM, add 24 hrs, since it is still part of the previous 
  # day's service
  min_aft_mid <- ifelse(min_aft_mid < 180, 1440 + min_aft_mid, min_aft_mid)
  
  print(sum(is.na(min_aft_mid)))
  
  return(min_aft_mid)
}


# Loading the GTFS file from the local path
import_gtfs <- function(path) {
  
  returnedGTFS <- gtfstools::read_gtfs(path = path)
  
  return(returnedGTFS)
}

# Calculate the stop headway
stop_headways_GTFS <- function(path, WD_id, SA_id, SU_id) {
  
  # load the gtfs data from the local path
  returnedGTFS <- import_gtfs(path)
  
  # Create new table that finds trips in the service schedule that have the 
  # correct service ID (weekday, Saturday, Sunday)
  returnedGTFS$tripsinschedule <- returnedGTFS$trips %>% filter(service_id %in% c(WD_id, SA_id, SU_id))
  
  # categorizing as weekday, Saturday, and Sunday
  returnedGTFS$tripsinschedule <- returnedGTFS$tripsinschedule %>% 
    mutate(DOW = case_when(service_id %in% WD_id ~ "WD",
                           service_id %in% SA_id ~ "SA",
                           service_id %in% SU_id ~ "SU",
                           TRUE ~ "Err")) %>% 
    mutate(direction_id = NA) #TO DO: Might take this out, not used again
  
  ## Finding Arrival Times at Each Stop ##
  returnedGTFS$stop_times <- returnedGTFS$stop_times %>%
    # creating a column that computes the minutes after midnight of arrival to each stop
    mutate(
      arrival_time_mam = to_minutesaftermidnight(returnedGTFS, 'stop_times', arrival_time) # HELP: Giving warnings, not sure why
    )  %>% 
    group_by(trip_id) %>% 
    # Fix missing stop times.
    # TO DO: Find a new way to calculate time when in between main stops
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
  
  # Finding stop times that are in the service schedule, joining by trip_id
  returnedGTFS$stop_times_inSch <- returnedGTFS$stop_times %>% 
    inner_join(returnedGTFS$tripsinschedule %>% select(trip_id, service_id, DOW, 
                                                       route_id, direction_id), by = "trip_id") 
  
  # finding the stop headways
  stop_headways <- returnedGTFS$stop_times_inSch %>%
    group_by(DOW, stop_id, direction_id) %>% 
    arrange(stop_id, DOW, arrival_time_mam) %>% 
    filter(pickup_type == 0) %>% #select regularly scheduled pickups
    # Summarizing to use in determining a frequent stop
    # TO DO: Change this so that it uses the correct equations
    mutate(
      preceding_arrival = lag(arrival_time_mam),
      preceding_headway = arrival_time_mam - preceding_arrival) %>% 
      summarize(firstArrival_mam = min(arrival_time_mam),
                lastArrival_mam = max(arrival_time_mam),
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
      # span of the service for weekday vs weekend
      span_min = if_else(DOW %in% c("WD"), 7 * 60, 8 * 60),
      span_max = if_else(DOW %in% c("WD"), 19 * 60, 18.5 * 60),
      
      # set minimum frequency for day of week
      # TO DO: Check out if the frequency requirements have changed
      freq_min = if_else(DOW %in% c("WD"), 15, 20),
      
      # passes if in the correct span
      span_pass = firstArrival_mam <= span_min &
        lastArrival_mam >= span_max,
      # passes if less than minimum frequency 
      freq_pass = averageHeadway <= freq_min
    )
  return(out)
}

# Summarize the detailed report into a simple report.
freq_service_summary <- function(df) {
  # get detailed information
  out <- freq_service_detailed(df) %>%
    group_by(stop_id) %>%
    # Adding up the number of times a stop 'passes', for span/frequency, on weekday/weekend
    summarize(passing_values = sum(span_pass, na.rm = TRUE) + sum(freq_pass, na.rm = TRUE)) %>%
    mutate(frequent_stop = passing_values == 4)
  
  return(out)
}


