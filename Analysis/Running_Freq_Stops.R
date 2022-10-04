source("../Functions/Frequent_Stops_Functions.R")
library(tidyverse)

### BAT  ----------------------------------------------------------

BAT_gtfs_path <- "../GTFS_data/brockton-ma-us.zip"
BAT_detailedpath <- "../Output/frequent_stops_detail_BAT.csv"
BAT_summarypath <- "../Output/frequent_stops_summary_BAT.csv"


# used "Year Round Starting 3/1/21" for weekday, saturday, sunday
BAT_WD_id <- "c_21163_b_29144_d_31" 
BAT_SA_id <- "c_21163_b_29144_d_32"
BAT_SU_id <- "c_21163_b_29144_d_64"
  
  
### CATA  ----------------------------------------------------------

CATA_gtfs_path <- "../GTFS_data/capeann-ma-us.zip"
CATA_detailedpath <- "../Output/frequent_stops_detail_CATA.csv"
CATA_summarypath <- "../Output/frequent_stops_summary_CATA.csv"

# Year Round starting 2/21/22 weekday and saturday
CATA_WD_id <- "c_24289_b_33923_d_31" 
CATA_SA_id <- "c_24289_b_33923_d_32" 
CATA_SU_id <- ""
# No Sunday 
  
  
### GATRA  ----------------------------------------------------------

GATRA_gtfs_path <- "../GTFS_data/gatra-ma-us.zip"
GATRA_detailedpath <- "../Output/frequent_stops_detail_GATRA.csv"
GATRA_summarypath <- "../Output/frequent_stops_summary_GATRA.csv"

# Year Round starting 10/3/22
# Weekday MWThF and Tuesday 
GATRA_WD_id <- c( "c_67596_b_78143_d_29", "c_67596_b_78143_d_2")
# only "weekend", not divided as saturday and sunday
GATRA_SA_id <- "c_67596_b_78143_d_96"
GATRA_SU_id <- ""


  
### LRTA  ----------------------------------------------------------

LRTA_gtfs_path <- "../GTFS_data/lowell-ma-us.zip"
LRTA_detailedpath <- "../Output/frequent_stops_detail_LRTA.csv"
LRTA_summarypath <- "../Output/frequent_stops_summary_LRTA.csv"

# Year Round starting 8/15/22
LRTA_WD_id <- "c_67333_b_77545_d_31" 
LRTA_SA_id <- "c_67333_b_77545_d_32"
LATRA_SU_id <- ""
# No Sunday
  

### Merrimack Valley  -----------------------------------------------------

MVRTA_gtfs_path <- "../GTFS_data/merrimackvalley-ma-us.zip"
MVRTA_detailedpath <- "../Output/frequent_stops_detail_MVRTA.csv"
MVRTA_summarypath <- "../Output/frequent_stops_summary_MVRTA.csv"

# Using Year Round starting 9/6/22 
MVRTA_WD_id <- "c_67487_b_77930_d_31" 
MVRTA_SA_id <- "c_67487_b_77930_d_32"
MVRTA_SU_id <- ""
# No Sunday


### Metrowest  ----------------------------------------------------------
# Downloaded from https://transitfeeds.com/p/massdot/101
# For 6 September 2022

MW_gtfs_path <- "../GTFS_data/metrowest-ma-us.zip"
MW_detailedpath <- "../Output/frequent_stops_detail_MW.csv"
MW_summarypath <- "../Output/frequent_stops_summary_MW.csv"

# Chosen by using 9/30/22-10/01/22-10/02/22
MW_WD_id <- "2576ab55-fdab-479b-a7e0-61e3113a76aa" 
MW_SA_id <- "b7dde38d-7326-48f1-80f1-539156430383"
MW_SU_id <- "c42e7fe8-7703-4ecd-abf6-7ffedef656ee"
  
  
### Running Functions ----------------------------------------------------

## Get GTFS Data ##
GTFS_Output <- import_gtfs(MW_gtfs_path)

## Get Stop Headways ## 
stop_headways <- stop_headways_GTFS(path = MW_gtfs_path, 
                                    WD_id = MW_WD_id,
                                    SA_id = MW_SA_id,
                                    SU_id = MW_SU_id)


## Get detailed information on whether each stop passes for span and/or frequency ##
detailed_output <- freq_service_detailed(stop_headways) %>% left_join(GTFS_Output$stops %>% select(stop_id:stop_lon), by = "stop_id")
write_csv(detailed_output,  path = MW_detailedpath)

## Summarize the detailed report into a simple report ##
summarized_output <- freq_service_summary(stop_headways) %>% left_join(GTFS_Output$stops %>% select(stop_id:stop_lon), by = "stop_id")
write_csv(summarized_output, path = MW_summarypath) 




### Notes -------------------------------------------------------------------
# Took the service IDs from calendar_attributes of each RTA
# should I include school service and special holiday service?
# Chose the most recent years for the RTAs that had multiple options