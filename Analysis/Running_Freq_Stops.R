source("Functions/Frequent_Stops_Functions.R")
library(tidyverse)
#install.packages("gtfstools")

# TO DO: Might want to include more service IDs
# trips <- GTFS_Output$trips
# stop_times <- GTFS_Output$stop_times
# cal <- GTFS_Output$calendar
# cal_att <- GTFS_Output$calendar_attributes
# 
# stop_time_by_trip <- left_join(trips, stop_times, by = "trip_id")
# 
# cal_att_dates_fixed <- cal_att %>% 
#   full_join(cal, by = "service_id")
# cal_att_dates_fixed$start_date <- gsub("-", "", cal_att_dates_fixed$start_date) %>%
#   as.double()
# cal_att_dates_fixed$end_date <- gsub("-", "", cal_att_dates_fixed$end_date)%>%
#   as.double()
# 
# 
# cal_att_filt <- cal_att_dates_fixed %>%
#   filter(start_date <= 20221008 & end_date >= 20221008) %>% 
#   filter(wednesday == 1 | saturday == 1 | sunday == 1) %>%
#   distinct()
# 
# stop_time_by_trip_filter <- stop_time_by_trip |> filter(service_id %in% CATA_WD_id) 

### BAT  ----------------------------------------------------------

BAT_gtfs_path <- "GTFS_data/brockton-ma-us.zip"
BAT_detailedpath <- "Output/frequent_stops_detail_BAT.csv"
BAT_summarypath <- "Output/frequent_stops_summary_BAT.csv"
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

BAT_WD_id <- c("c_21163_b_29144_d_31", "c_1747_b_78103_d_31") # no duplicates, service ids are for different routes
BAT_SA_id <- "c_21163_b_29144_d_32"
BAT_SU_id <- "c_21163_b_29144_d_64"
  
  
### CATA  ----------------------------------------------------------

CATA_gtfs_path <- "GTFS_data/capeann-ma-us.zip"
CATA_detailedpath <- "Output/frequent_stops_detail_CATA.csv"
CATA_summarypath <- "Output/frequent_stops_summary_CATA.csv"
#GTFS_Output <- import_gtfs(CATA_gtfs_path)

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



CATA_WD_id <- c("c_24289_b_33923_d_31" , "c_21058_b_28942_d_31", "c_21045_b_78058_d_31")
#  The WD service ids are all for different routes
CATA_SA_id <- "c_24289_b_33923_d_32" 
CATA_SU_id <- ""
# No Sunday 
  
  
### GATRA  ----------------------------------------------------------

GATRA_gtfs_path <- "GTFS_data/gatra-ma-us.zip"
GATRA_detailedpath <- "Output/frequent_stops_detail_GATRA.csv"
GATRA_summarypath <- "Output/frequent_stops_summary_GATRA.csv"
#GTFS_Output <- import_gtfs(GATRA_gtfs_path)

# Year Round starting 10/3/22
# Weekday MWThF and Tuesday 
GATRA_WD_id <- c( "c_67596_b_78143_d_29", "c_67596_b_78143_d_2")
# only "weekend", not divided as saturday and sunday
GATRA_SA_id <- "c_67596_b_78143_d_96"
GATRA_SU_id <- ""


  
### LRTA  ----------------------------------------------------------

LRTA_gtfs_path <- "GTFS_data/lowell-ma-us.zip"
LRTA_detailedpath <- "Output/frequent_stops_detail_LRTA.csv"
LRTA_summarypath <- "Output/frequent_stops_summary_LRTA.csv"
#GTFS_Output <- import_gtfs(LRTA_gtfs_path)

# Year Round starting 8/15/22
LRTA_WD_id <- "c_67333_b_77545_d_31" 
LRTA_SA_id <- "c_67333_b_77545_d_32"
LRTA_SU_id <- ""
# No Sunday
  

### Merrimack Valley  -----------------------------------------------------

MVRTA_gtfs_path <- "GTFS_data/merrimackvalley-ma-us.zip"
MVRTA_detailedpath <- "Output/frequent_stops_detail_MVRTA.csv"
MVRTA_summarypath <- "Output/frequent_stops_summary_MVRTA.csv"
#GTFS_Output <- import_gtfs(MVRTA_gtfs_path)

# Using Year Round starting 9/6/22 
MVRTA_WD_id <- "c_67487_b_77930_d_31" 
MVRTA_SA_id <- "c_67487_b_77930_d_32"
MVRTA_SU_id <- ""
# No Sunday


### Metrowest  ----------------------------------------------------------
# Downloaded from https://transitfeeds.com/p/massdot/101
# For 6 September 2022

MW_gtfs_path <- "GTFS_data/metrowest-ma-us.zip"
MW_detailedpath <- "Output/frequent_stops_detail_MW.csv"
MW_summarypath <- "Output/frequent_stops_summary_MW.csv"
#GTFS_Output <- import_gtfs(MW_gtfs_path)

# Chosen by using 9/30/22-10/01/22-10/02/22
MW_WD_id <- "2576ab55-fdab-479b-a7e0-61e3113a76aa" 
MW_SA_id <- "b7dde38d-7326-48f1-80f1-539156430383"
MW_SU_id <- "c42e7fe8-7703-4ecd-abf6-7ffedef656ee"
  
  
### Running Functions ----------------------------------------------------

path <- BAT_gtfs_path
WD <- BAT_WD_id
SA <- BAT_SA_id
SU <- BAT_SU_id


## Get GTFS Data ##
GTFS_Output <- import_gtfs(path)

## Get Stop Headways ## 
stop_headways <- stop_headways_GTFS(path = path, 
                                    WD_id = WD,
                                    SA_id = SA,
                                    SU_id = SU)
det <- BAT_detailedpath
summ <- BAT_summarypath

## Get detailed information on whether each stop passes for span and/or frequency ##
detailed_output <- freq_service_detailed(stop_headways) %>% left_join(GTFS_Output$stops %>% select(stop_id:stop_lon), by = "stop_id")
write_csv(detailed_output,  path = det)

## Summarize the detailed report into a simple report ##
summarized_output <- freq_service_summary(stop_headways) %>% left_join(GTFS_Output$stops %>% select(stop_id:stop_lon), by = "stop_id")
write_csv(summarized_output, path = summ) 


## Mapping the frequent stops##
stops_geo <- summarized_output %>%
  filter(frequent_stop == TRUE) %>%
  #filter(passing_values >=5) %>%
  st_as_sf(coords= c("stop_lon", "stop_lat")) %>% 
  st_set_crs(4326) %>%
  st_transform(26986)

mapview(stops_geo, zcol = 'frequent_stop')

### Notes -------------------------------------------------------------------
# Took the service IDs from calendar_attributes of each RTA
# should I include school service and special holiday service?
# Chose the most recent years for the RTAs that had multiple options
# In some of the gtfs files there seem to be routes that aren't in the online schedule or vice versa
# WARNING: for some trips in CATA and MW there is no max or mean headway, because it is the only stop
# on that trip.  This leads to NaN for avg headway and -Inf for longest headway
# Only a handful of frequent stops in each RTA, if any