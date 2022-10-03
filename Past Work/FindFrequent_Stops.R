source("./Functions/read_GTFS_files.R")
library(tidyverse)

## BAT ----------------------------------------------------------------
# # 
gtfs_path <- "./GTFS_Files/brockton-ma-us.zip"
detailedpath <- "frequent_stops_detail_BAT.csv"
summarypath <- "frequent_stops_summary_BAT.csv"

## BAT
WD_id <- c("c_1589_b_973_d_31", "c_1703_b_4246_d_31")
SA_id <- "c_1589_b_973_d_32"
SU_id <- "c_1589_b_973_d_64"

## CATA ----------------------------------------------------------------
# 
gtfs_path <- "./GTFS_Files/capeann-ma-us.zip"
detailedpath <- "frequent_stops_detail_CATA.csv"
summarypath <- "frequent_stops_summary_CATA.csv"
# analysis_date <- 20171115

WD_id <- c("c_1538_b_2883_d_31", "c_1535_b_970_d_31")
SA_id <- c("c_1535_b_970_d_32", "c_1625_b_4216_d_96")
SU_id <- "c_1625_b_4216_d_96"

## GATRA ----------------------------------------------------------------
# 
gtfs_path <- "./GTFS_Files/gatra-ma-us.zip"
detailedpath <- "frequent_stops_detail_GATRA.csv"
summarypath <- "frequent_stops_summary_GATRA.csv"
# analysis_date <- 20171115

WD_id <- c("c_1908_b_437_d_31", "c_1908_b_437_d_21")
SA_id <- c("c_1908_b_437_d_32", "c_1908_b_437_d_96")
SU_id <- "c_1908_b_437_d_96"

## Merrimack Valley ----------------------------------------------------------------
# 
gtfs_path <- "./GTFS_Files/merrimackvalley-ma-us.zip"
detailedpath <- "frequent_stops_detail_MVRTA.csv"
summarypath <- "frequent_stops_summary_MVRTA.csv"
# analysis_date <- 20171115

WD_id <- c("c_1540_b_1476_d_31", "c_1541_b_1393_d_31", "c_6297_b_6813_d_31")
SA_id <- c("c_1908_b_437_d_32", "c_1540_b_1476_d_32", "c_6297_b_6813_d_32")
SU_id <- "c_1540_b_1476_d_96"


## Metrowest RTA ----------------------------------------------------------------
# 
gtfs_path <- "./GTFS_Files/MWRTA_GTFS.zip"
detailedpath <- "frequent_stops_detail_MWRTA.csv"
summarypath <- "frequent_stops_summary_MWRTA.csv"
# analysis_date <- 20171115

WD_id <- "a30e69df-df05-4500-a33d-ffc30ceb4580"
SA_id <- "5503e246-a616-41b0-9d74-feda63a8ce91"
SU_id <- "14662073-a2fa-480a-a398-e26846386260"

# Igonore sundays. 
SU_id <- "Not Used"

#YYYYMMDD
# read_GTFS_cal(path = gtfs_path) %>% filter(end_date >= analysis_date, start_date <= analysis_date) %>% View()

GTFS_Output <- tidytransit::read_gtfs(path = path)
#GTFS_Output <- import_gtfs_ql(path = gtfs_path)

# left_join(GTFS_Output$trips_df, GTFS_Output$stop_times_df, by = "trip_id") %>%
#   left_join(GTFS_Output$routes_df %>% select(route_id, route_long_name, route_desc), by = "route_id") %>% 
#   group_by(trip_id) %>% 
#   filter(service_id %in% c(WD_id, SA_id, SU_id)) %>%
#   filter(arrival_time == min(arrival_time)) %>%
#   arrange(route_id, arrival_time) %>% 
#   select(-contains(".x"), -contains(".y")) %>% 
#   View()

stop_headways <- stop_headways_GTFS(path = gtfs_path, 
                                WD_id = WD_id,
                                SA_id = SA_id,
                                SU_id = SU_id)

detailed_output <- freq_service_detailed(stop_headways) %>% left_join(GTFS_Output$stops %>% select(stop_id:stop_lon), by = "stop_id")
write_csv(detailed_output,  path = paste0("./Output/", detailedpath))

summarized_output <- freq_service_summary(stop_headways) %>% left_join(GTFS_Output$stops_df %>% select(stop_id:stop_lon), by = "stop_id")
write_csv(summarized_output, path = paste0("./Output/", summarypath)) 
