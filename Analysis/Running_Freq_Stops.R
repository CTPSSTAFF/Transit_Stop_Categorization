source("../Functions/Frequent_Stops_Functions.R")
library(tidyverse)

### BAT  ----------------------------------------------------------

BAT_gtfs_path <- "../GTFS_data/brockton-ma-us.zip"
BAT_detailedpath <- "../Output/frequent_stops_detail_BAT.csv"
BAT_summarypath <- "../Output/frequent_stops_summary_BAT.csv"

# Took these IDs from calendar$service_id, match to calendar$service_name
# used "Year Round Starting 3/1/21 (Sunday only)","Year Round Starting 3/1/21 (Saturday only", and "Year Round Starting 3/1/21 (Weekday)" 
BAT_WD_id <- "c_21163_b_29144_d_31" 
BAT_SA_id <- "c_21163_b_29144_d_32"
BAT_SU_id <- "c_21163_b_29144_d_64"
  
  
### CATA  ----------------------------------------------------------

CATA_gtfs_path <- "../GTFS_data/capeann-ma-us.zip"
CATA_detailedpath <- "../Output/frequent_stops_detail_CATA.csv"
CATA_summarypath <- "../Output/frequent_stops_summary_CATA.csv"

# Year Round starting 2/21/22
CATA_WD_id <- "c_24289_b_33923_d_31" 
CATA_SA_id <- "c_24289_b_33923_d_32" 
# No Sunday CATA_SU_id <- #TO DO
  
  
### GATRA  ----------------------------------------------------------

GATRA_gtfs_path <- "../GTFS_data/gatra-ma-us.zip"
GATRA_detailedpath <- "../Output/frequent_stops_detail_GATRA.csv"
GATRA_summarypath <- "../Output/frequent_stops_summary_GATRA.csv"

# Year round ending in 10/2/2022
# Weekday MWThF and Tuesday Only
GATRA_WD_id <- c( "c_45847_b_55954_d_29", "c_45847_b_55954_d_2")
GATRA_SA_id <- "c_45847_b_55954_d_32"
# No Sunday GATRA_SU_id <- #TO DO

  
### LRTA  ----------------------------------------------------------

LRTA_gtfs_path <- "../GTFS_data/lowell-ma-us.zip"
LRTA_detailedpath <- "../Output/frequent_stops_detail_LRTA.csv"
LRTA_summarypath <- "../Output/frequent_stops_summary_LRTA.csv"

# Year Round starting 8/15/22
LRTA_WD_id <- "c_67333_b_77545_d_31" 
LRTA_SA_id <- "c_67333_b_77545_d_32"
# No SundayLRTA_SU_id <- #TO DO
  

### Merrimack Valley  -----------------------------------------------------

MVRTA_gtfs_path <- "../GTFS_data/merrimackvalley-ma-us.zip"
MVRTA_detailedpath <- "../Output/frequent_stops_detail_MVRTA.csv"
MVRTA_summarypath <- "../Output/frequent_stops_summary_MVRTA.csv"

MVRTA_WD_id <- #TO DO 
MVRTA_SA_id <- #TO DO
MVRTA_SU_id <- #TO DO


### Metrowest  ----------------------------------------------------------
# Downloaded from https://transitfeeds.com/p/massdot/101
# For 6 September 2022

MW_gtfs_path <- "../GTFS_data/metrowest-ma-us.zip"
MW_detailedpath <- "../Output/frequent_stops_detail_MW.csv"
MW_summarypath <- "../Output/frequent_stops_summary_MW.csv"

MW_WD_id <- #TO DO 
MW_SA_id <- #TO DO
MW_SU_id <- #TO DO
  
  
### Running Functions ----------------------------------------------------

# Choose RTA
gtfs_path <- BAT_gtfs_path
detailedpath <- BAT_detailedpath
summarypath <- BAT_summarypath

WD_id <- BAT_WD_id
SA_id <- BAT_SA_id
SU_id <- BAT_SU_id


## Get GTFS Data ##
GTFS_Output <- import_gtfs(gtfs_path)

## Get Stop Headways ## 
stop_headways <- stop_headways_GTFS(path = gtfs_path, 
                                    WD_id = WD_id,
                                    SA_id = SA_id,
                                    SU_id = SU_id)


## Get detailed information on whether each stop passes for span and/or frequency ##
detailed_output <- freq_service_detailed(stop_headways) %>% left_join(GTFS_Output$stops %>% select(stop_id:stop_lon), by = "stop_id")
write_csv(detailed_output,  path = detailedpath)

## Summarize the detailed report into a simple report ##
summarized_output <- freq_service_summary(stop_headways) %>% left_join(GTFS_Output$stops %>% select(stop_id:stop_lon), by = "stop_id")
write_csv(summarized_output, path = paste0summarypath) 

