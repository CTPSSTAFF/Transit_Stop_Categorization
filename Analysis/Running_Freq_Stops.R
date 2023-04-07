source("Functions/Frequent_Stops_Functions.R")
library(tidyverse)
#install.packages("gtfstools")

# TO DO: Might want to include more service IDs
# trips <- GTFS_Output$trips
# 
# stop_times <- GTFS_Output$stop_times
# cal <- GTFS_Output$calendar
# cal_att <- GTFS_Output$calendar_attributes
# #
# stop_time_by_trip <- left_join(trips, stop_times, by = "trip_id")
# #
# cal_att_dates_fixed <- cal_att %>%
#   full_join(cal, by = "service_id")
# 
# cal_att_dates_fixed$start_date <- gsub("-", "", cal_att_dates_fixed$start_date) %>%
#   as.double()
# 
# cal_att_dates_fixed$end_date <- gsub("-", "", cal_att_dates_fixed$end_date)%>%
#   as.double()
# #
# #
# cal_att_filt <- cal_att_dates_fixed %>%
#   filter(start_date <= 20221008 & end_date >= 20221008) %>%
#   filter(wednesday == 1 | saturday == 1 | sunday == 1) %>%
#   distinct()
# #
# stop_time_by_trip_filter <- stop_time_by_trip |> filter(service_id %in% CATA_WD_id) 

### BAT  ----------------------------------------------------------

BAT_gtfs_path <- "GTFS_data/brockton-ma-us.zip"
BAT_detailedpath <- "Output/Detailed_RTA/frequent_stops_detail_BAT.csv"
BAT_summarypath <- "Output/Summary_RTA/frequent_stops_summary_BAT.csv"
#GTFS_Output <- import_gtfs(BAT_gtfs_path)


# used "Year Round Starting 3/1/21" for weekday, saturday, sunday
# WD <- cal_att_filt %>%
#   filter(wednesday == 1)
# BAT_WD_id <- WD$service_id
# 
# SA <- cal_att_filt %>%
#   filter(saturday == 1)
# BAT_SA_id <- SA$service_id
# 
# SU <- cal_att_filt %>%
#   filter(sunday == 1)
# BAT_SU_id <- SU$service_id
# Because the only ID with Sunday is every day, it is classified as WD

BAT_WD_id <- c("c_21163_b_29144_d_31", "c_1747_b_78103_d_31") # no duplicates, service ids are for different routes, year-round weekday fall and BSU
BAT_SA_id <- "c_21163_b_29144_d_32"
#BAT_SU_id <- "c_21163_b_29144_d_64"
  
  
### CATA  ----------------------------------------------------------

CATA_gtfs_path <- "GTFS_data/capeann-ma-us.zip"
CATA_detailedpath <- "Output/Detailed_RTA/frequent_stops_detail_CATA.csv"
CATA_summarypath <- "Output/Summary_RTA/frequent_stops_summary_CATA.csv"
GTFS_Output <- import_gtfs(CATA_gtfs_path)

# Year Round starting 2/21/22 weekday and saturday
# WD <- cal_att_filt %>%
#   filter(wednesday == 1)
# CATA_WD_id <- WD$service_id
# 
# SA <- cal_att_filt %>%
#   filter(saturday == 1)
# CATA_SA_id <- SA$service_id
# 
# SU <- cal_att_filt %>%
#   filter(sunday == 1)
# CATA_SU_id <- SU$service_id



CATA_WD_id <- c("c_24289_b_33923_d_31" , "c_21058_b_28942_d_31", "c_21045_b_78058_d_31") # year round weekday, Beverly Commuter Pilot, school service (fall 2022)
#  The WD service ids are all for different routes
CATA_SA_id <- "c_24289_b_33923_d_32" 
CATA_SU_id <- ""
# No Sunday 
  
  
### GATRA  ----------------------------------------------------------

GATRA_gtfs_path <- "GTFS_data/gatra-ma-us.zip"
GATRA_detailedpath <- "Output/Detailed_RTA/frequent_stops_detail_GATRA.csv"
GATRA_summarypath <- "Output/Summary_RTA/frequent_stops_summary_GATRA.csv"
GTFS_Output <- import_gtfs(GATRA_gtfs_path)

# Year Round starting 10/3/22
# Weekday MWThF and Tuesday 
GATRA_WD_id <- c( "c_67596_b_78143_d_31") # year-round 
# only "weekend", not divided as saturday and sunday
GATRA_SA_id <- "c_67596_b_78143_d_96"
GATRA_SU_id <- ""


### LRTA  ----------------------------------------------------------

LRTA_gtfs_path <- "GTFS_data/lowell-ma-us.zip"
LRTA_detailedpath <- "Output/Detailed_RTA/frequent_stops_detail_LRTA.csv"
LRTA_summarypath <- "Output/Summary_RTA/frequent_stops_summary_LRTA.csv"
GTFS_Output <- import_gtfs(LRTA_gtfs_path)

# Year Round starting 8/15/22
LRTA_WD_id <- "c_67333_b_77545_d_31" 
LRTA_SA_id <- "c_67333_b_77545_d_32"
LRTA_SU_id <- ""
# No Sunday
  

### Merrimack Valley  -----------------------------------------------------

MVRTA_gtfs_path <- "GTFS_data/merrimackvalley-ma-us.zip"
MVRTA_detailedpath <- "Output/Detailed_RTA/frequent_stops_detail_MVRTA.csv"
MVRTA_summarypath <- "Output/Summary_RTA/frequent_stops_summary_MVRTA.csv"
GTFS_Output <- import_gtfs(MVRTA_gtfs_path)

# Using Year Round starting 9/6/22 
MVRTA_WD_id <- "c_67487_b_77930_d_31" 
MVRTA_SA_id <- "c_67487_b_77930_d_32"
MVRTA_SU_id <- ""
# No Sunday


### Metrowest  ----------------------------------------------------------
# Downloaded from https://transitfeeds.com/p/massdot/101
# For 6 September 2022

MW_gtfs_path <- "GTFS_data/metrowest-ma-us.zip"
MW_detailedpath <- "Output/Detailed_RTA/frequent_stops_detail_MW.csv"
MW_summarypath <- "Output/Summary_RTA/frequent_stops_summary_MW.csv"
GTFS_Output <- import_gtfs(MW_gtfs_path)

# Chosen by using 9/30/22-10/01/22-10/02/22
MW_WD_id <- "2576ab55-fdab-479b-a7e0-61e3113a76aa" 
MW_SA_id <- "b7dde38d-7326-48f1-80f1-539156430383"
MW_SU_id <- "c42e7fe8-7703-4ecd-abf6-7ffedef656ee"
  
  
### Running Functions ----------------------------------------------------

# path <- BAT_gtfs_path
# WD <- BAT_WD_id
# SA <- BAT_SA_id
#SU <- BAT_SU_id


## Get GTFS Data ##
BAT_GTFS_Output <- import_gtfs(BAT_gtfs_path)
CATA_GTFS_Output <- import_gtfs(CATA_gtfs_path)
GATRA_GTFS_Output <- import_gtfs(GATRA_gtfs_path)
LRTA_GTFS_Output <- import_gtfs(LRTA_gtfs_path)
MVRTA_GTFS_Output <- import_gtfs(MVRTA_gtfs_path)
MW_GTFS_Output <- import_gtfs(MW_gtfs_path)



## Get Stop Headways ## 
BAT_stop_headways <- stop_headways_GTFS(path = BAT_gtfs_path, WD_id = BAT_WD_id, SA_id = BAT_SA_id)
CATA_stop_headways <- stop_headways_GTFS(path = CATA_gtfs_path, WD_id = CATA_WD_id, SA_id = CATA_SA_id)
GATRA_stop_headways <- stop_headways_GTFS(path = GATRA_gtfs_path, WD_id = GATRA_WD_id, SA_id = GATRA_SA_id)
LRTA_stop_headways <- stop_headways_GTFS(path = LRTA_gtfs_path, WD_id = LRTA_WD_id, SA_id = LRTA_SA_id)
MVRTA_stop_headways <- stop_headways_GTFS(path = MVRTA_gtfs_path, WD_id = MVRTA_WD_id, SA_id = MVRTA_SA_id)
MW_stop_headways <- stop_headways_GTFS(path = MW_gtfs_path, WD_id = MW_WD_id, SA_id = MW_SA_id)


## Get detailed information on whether each stop passes for span and/or frequency ##
BAT_detailed_output <- freq_service_detailed(BAT_stop_headways) %>% left_join(BAT_GTFS_Output$stops %>% select(stop_id:stop_lon), by = "stop_id") %>% 
  st_as_sf(coords= c("stop_lon", "stop_lat")) %>% st_set_crs(4326) %>% st_transform(26986)
write.csv(BAT_detailed_output, BAT_detailedpath)

CATA_detailed_output <- freq_service_detailed(CATA_stop_headways) %>% left_join(CATA_GTFS_Output$stops %>% select(stop_id:stop_lon), by = "stop_id") %>% 
  st_as_sf(coords= c("stop_lon", "stop_lat")) %>% st_set_crs(4326) %>% st_transform(26986)
write.csv(CATA_detailed_output, CATA_detailedpath)

GATRA_detailed_output <- freq_service_detailed(GATRA_stop_headways) %>% left_join(GATRA_GTFS_Output$stops %>% select(stop_id:stop_lon), by = "stop_id") %>% 
  st_as_sf(coords= c("stop_lon", "stop_lat")) %>% st_set_crs(4326) %>% st_transform(26986)
write.csv(GATRA_detailed_output, GATRA_detailedpath)

LRTA_detailed_output <- freq_service_detailed(LRTA_stop_headways) %>% left_join(LRTA_GTFS_Output$stops %>% select(stop_id:stop_lon), by = "stop_id") %>% 
  st_as_sf(coords= c("stop_lon", "stop_lat")) %>% st_set_crs(4326) %>% st_transform(26986)
write.csv(LRTA_detailed_output, LRTA_detailedpath)

MVRTA_detailed_output <- freq_service_detailed(MVRTA_stop_headways) %>% left_join(MVRTA_GTFS_Output$stops %>% select(stop_id:stop_lon), by = "stop_id") %>% 
  st_as_sf(coords= c("stop_lon", "stop_lat")) %>% st_set_crs(4326) %>% st_transform(26986)
write.csv(MVRTA_detailed_output, MVRTA_detailedpath)

MW_detailed_output <- freq_service_detailed(MW_stop_headways) %>% left_join(MW_GTFS_Output$stops %>% select(stop_id:stop_lon), by = "stop_id") %>% 
  st_as_sf(coords= c("stop_lon", "stop_lat")) %>% st_set_crs(4326) %>% st_transform(26986)
write.csv(MW_detailed_output, MW_detailedpath)



## Summarize the detailed report into a simple report ##
BAT_summarized_output <- freq_service_summary(BAT_stop_headways) %>% left_join(BAT_GTFS_Output$stops %>% select(stop_id:stop_lon), by = "stop_id") %>% 
  st_as_sf(coords= c("stop_lon", "stop_lat")) %>% st_set_crs(4326) %>% st_transform(26986) %>% 
  mutate(RTA = "BAT") %>% select(stop_id, passing_values, frequent_stop, stop_name, geometry, RTA)
write.csv(BAT_summarized_output, BAT_summarypath)

CATA_summarized_output <- freq_service_summary(CATA_stop_headways) %>% left_join(CATA_GTFS_Output$stops %>% select(stop_id:stop_lon), by = "stop_id") %>% 
  st_as_sf(coords= c("stop_lon", "stop_lat")) %>% st_set_crs(4326) %>% st_transform(26986) %>% 
  mutate(RTA = "CATA") %>% select(stop_id, passing_values, frequent_stop, stop_name, geometry, RTA)
write.csv(CATA_summarized_output, CATA_summarypath)

GATRA_summarized_output <- freq_service_summary(GATRA_stop_headways) %>% left_join(GATRA_GTFS_Output$stops %>% select(stop_id:stop_lon), by = "stop_id") %>% 
  st_as_sf(coords= c("stop_lon", "stop_lat")) %>% st_set_crs(4326) %>% st_transform(26986) %>% 
  mutate(RTA = "GATRA") %>% select(stop_id, passing_values, frequent_stop, stop_name, geometry, RTA)
write.csv(GATRA_summarized_output, GATRA_summarypath)

LRTA_summarized_output <- freq_service_summary(LRTA_stop_headways) %>% left_join(LRTA_GTFS_Output$stops %>% select(stop_id:stop_lon), by = "stop_id") %>% 
  st_as_sf(coords= c("stop_lon", "stop_lat")) %>% st_set_crs(4326) %>% st_transform(26986) %>% 
  mutate(RTA = "LRTA") %>% select(stop_id, passing_values, frequent_stop, stop_name, geometry, RTA)
write.csv(LRTA_summarized_output, LRTA_summarypath)

MVRTA_summarized_output <- freq_service_summary(MVRTA_stop_headways) %>% left_join(MVRTA_GTFS_Output$stops %>% select(stop_id:stop_lon), by = "stop_id") %>% 
  st_as_sf(coords= c("stop_lon", "stop_lat")) %>% st_set_crs(4326) %>% st_transform(26986) %>% 
  mutate(RTA = "MVRTA") %>% select(stop_id, passing_values, frequent_stop, stop_name, geometry, RTA)
write.csv(MVRTA_summarized_output, MVRTA_summarypath)

MW_summarized_output <- freq_service_summary(MW_stop_headways) %>% left_join(MW_GTFS_Output$stops %>% select(stop_id:stop_lon), by = "stop_id") %>% 
  st_as_sf(coords= c("stop_lon", "stop_lat")) %>% st_set_crs(4326) %>% st_transform(26986) %>% 
  mutate(RTA = "MW") %>% select(stop_id, passing_values, frequent_stop, stop_name, geometry, RTA)
write.csv(MW_summarized_output, MW_summarypath)

RTA_frequent_summary <- rbind(BAT_summarized_output, CATA_summarized_output, GATRA_summarized_output, LRTA_summarized_output, MVRTA_summarized_output, MW_summarized_output)

mapview::mapview(RTA_frequent_summary, zcol = "RTA")

st_write(RTA_frequent_summary, "Output/RTA_frequent_summary.shp")

#write_csv(summarized_output, path = summ) 


### Notes -------------------------------------------------------------------
# Took the service IDs from calendar_attributes of each RTA
# should I include school service and special holiday service?
# Chose the most recent years for the RTAs that had multiple options
# In some of the gtfs files there seem to be routes that aren't in the online schedule or vice versa
# WARNING: for some trips in CATA and MW there is no max or mean headway, because it is the only stop
# on that trip.  This leads to NaN for avg headway and -Inf for longest headway
# Only a handful of frequent stops in each RTA, if any