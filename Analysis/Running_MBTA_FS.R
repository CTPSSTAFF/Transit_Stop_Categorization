source("../Functions/MBTA_FS_Functions.R")
library(tidyverse)
library(sf)
library(mapview)

### MBTA Service IDs -----------------------------------------------------------

# 20220923,20220928,"Fall 2022, 2022-09-30T22:53:11+00:00, version D"

MBTA_gtfs <- import_gtfs()


trips <- MBTA_gtfs$trips
stop_times <- MBTA_gtfs$stop_times
cal <- MBTA_gtfs$calendar
cal_att <- MBTA_gtfs$calendar_attributes
stop_time_by_trip <- left_join(trips, stop_times, by = "trip_id")

# 
# # TO DO: service_schedule_name
# # not modified 
# 
# special_dates <- MBTA_gtfs$calendar_dates$service_id
# 
# non_special_cal<- MBTA_gtfs$calendar_attributes %>%
#   filter(!(service_id %in% special_dates))

# weekdays <- MBTA_gtfs$calendar %>%
#   filter(thursday == 1) %>%
#   filter(friday == 1)




## All Relevant Service IDs ##
# join dates 
cal_att_dates_fixed <- cal_att %>% 
  full_join(cal, by = "service_id")
# Change date format
cal_att_dates_fixed$start_date <- gsub("-", "", cal_att_dates_fixed$start_date) %>%
  as.double()
cal_att_dates_fixed$end_date <- gsub("-", "", cal_att_dates_fixed$end_date)%>%
  as.double()
# Filter to relevant IDs
cl_att_RTL <- cal_att_dates_fixed %>%
  filter(str_detect(service_id, "RTL") & service_schedule_typicality == 1)

cal_att_filt <- cal_att_dates_fixed %>%
  filter(start_date <= 20221008 & end_date >= 20221008) %>% 
  bind_rows(cl_att_RTL) %>%
  filter(wednesday == 1 | saturday == 1 | sunday == 1) %>%
  distinct()
stop_time_by_trip_filter <- stop_time_by_trip |> filter(service_id %in% cal_att_filt$service_id) 


WD <- cal_att_filt %>%
 filter(wednesday == 1)
MBTA_WD_id <- WD$service_id

# BUS422-hbs42sw1-Wdy-02: mon-fri
# BUS422-hbc42wk1-Wdy-02: mon-thurs
# BUS422-hbc42fr1-Wdy-02: fri


SA <-  cal_att_filt %>%
  filter(saturday == 1)
MBTA_SA_id <- SA$service_id

SU <-  cal_att_filt %>%
  filter(sunday == 1)
MBTA_SU_id <- SU$service_id


### Running Functions ----------------------------------------------------------

## Get Stop Headways ## 
stop_headways <- stop_headways_GTFS(WD_id = MBTA_WD_id,
                                    SA_id = MBTA_SA_id,
                                    SU_id = MBTA_SU_id)


MBTA_detailed_path <- "../Output/frequent_stops_detail_MBTA.csv"
MBTA_summary_path <- "../Output/frequent_stops_summary_MBTA.csv"

## Get detailed information on whether each stop passes for span and/or frequency ##
detailed_output <- freq_service_detailed(stop_headways) %>% left_join(MBTA_gtfs$stops %>% select(stop_id:stop_lon), by = "stop_id")
write_csv(detailed_output,  path = MBTA_detailed_path)

## Summarize the detailed report into a simple report ##
summarized_output <- freq_service_summary(stop_headways) %>% left_join(MBTA_gtfs$stops %>% select(stop_id:stop_lon), by = "stop_id")
write_csv(summarized_output, path = MBTA_summary_path) 



## Mapping the frequent stops##
stops_geo <- summarized_output %>%
  filter(frequent_stop == TRUE) %>%
  #filter(passing_values >=5) %>%
  st_as_sf(coords= c("stop_lon", "stop_lat")) %>% 
  st_set_crs(4326) %>%
  st_transform(26986)

mapview(stops_geo, zcol = 'frequent_stop')

### NOTES ----------------------------------------------------------------------
# Taking out the interpolation 
# 23 warnings about na's- for some trips, there is no max or mean headway, because it is the only stop
# on that trip.  This leads to NaN for avg headway and -Inf for longest headway
# 911 frequent stops in the MBTA
# Using Average Headway, there are 1676 frequent stops
# Using AWT with half the headway threshold, there are 1225 frequent stops
# The previous time this analysis was run, there were 1596 frequent stops