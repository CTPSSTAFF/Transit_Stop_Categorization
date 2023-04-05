library(gtfsr)
library(tidyverse)
library(lubridate)
library(gtfstools)


# Load in OPMI data: 

freq_WD <- read_csv("GTFS_Data/MBTA/freqstops_fa22_wkdy15.csv") %>% 
  mutate(WD_frequent_stop = TRUE)
freq_SA <- read_csv("GTFS_Data/MBTA/freqstops_fa22_sat20.csv")  %>% 
  mutate(SA_frequent_stop = TRUE)

allStops_WD <- read_csv("GTFS_Data/MBTA/allstops_fa22_wkdy.csv")
allStops_SA <- read_csv("GTFS_Data/MBTA/allstops_fa22_sat.csv")



WD_freq_summ <- full_join(allStops_WD, freq_WD) %>% 
  mutate(WD_frequent_stop = if_else(is.na(WD_frequent_stop), FALSE, TRUE))

SA_freq_summ <- full_join(allStops_SA, freq_SA) %>% 
  mutate(SA_frequent_stop = if_else(is.na(SA_frequent_stop), FALSE, TRUE))

# needs to be frequent on both the weekday and saturday to be considered frequent
MBTA_freq_summary <- full_join(WD_freq_summ,SA_freq_summ ) %>% 
  mutate(MBTA_frequent_stop = case_when(WD_frequent_stop == TRUE & SA_frequent_stop == TRUE ~ TRUE, .default = FALSE) ) %>% 
  st_as_sf(coords= c("stop_lon", "stop_lat")) %>% st_set_crs(4326) %>% st_transform(26986)
  


         