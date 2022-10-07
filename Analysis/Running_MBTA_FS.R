source("../Functions/MBTA_FS_Functions.R")
library(tidyverse)

### MBTA -----------------------------------------------------------------------

# 20220923,20220928,"Fall 2022, 2022-09-30T22:53:11+00:00, version D"

MBTA_gtfs <- import_gtfs()


MBTA_detailed_path <- "../Output/frequent_stops_detail_MBTA.csv"
MBTA_summary_path <- "../Output/frequent_stops_summary_MBTA.csv"

WD <- MBTA_gtfs$calendar_attributes %>%
  filter(service_schedule_type == 'Weekday')
MBTA_WD_id <- WD$service_id

SA <- MBTA_gtfs$calendar_attributes %>%
  filter(service_schedule_type == 'Saturday')
MBTA_SA_id <- SA$service_id

SU <- MBTA_gtfs$calendar_attributes %>%
  filter(service_schedule_type == 'Sunday')
MBTA_SU_id <- SU$service_id


### Running Functions ----------------------------------------------------------

## Get Stop Headways ## 
stop_headways <- stop_headways_GTFS(WD_id = MBTA_WD_id,
                                    SA_id = MBTA_SA_id,
                                    SU_id = MBTA_SU_id)



## Get detailed information on whether each stop passes for span and/or frequency ##
detailed_output <- freq_service_detailed(stop_headways) %>% left_join(MBTA_gtfs$stops %>% select(stop_id:stop_lon), by = "stop_id")
write_csv(detailed_output,  path = MBTA_detailed_path)

## Summarize the detailed report into a simple report ##
summarized_output <- freq_service_summary(stop_headways) %>% left_join(MBTA_gtfs$stops %>% select(stop_id:stop_lon), by = "stop_id")
write_csv(summarized_output, path = MBTA_summary_path) 


### NOTES ----------------------------------------------------------------------
# Taking out the interpolation 23 warnings about na's 