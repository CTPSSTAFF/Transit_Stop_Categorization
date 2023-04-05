library(gtfsr)
library(tidyverse)
library(lubridate)
library(gtfstools)


# Load in OPMI data: 

freq_WD <- read_csv("GTFS_Data/MBTA/freqstops_fa22_wkdy15.csv") %>% 
  mutate(frequent_stop = TRUE)
freq_SA <- read_csv("GTFS_Data/MBTA/freqstops_fa22_sat20.csv")  %>% 
  mutate(frequent_stop = TRUE)

allStops_WD <- read_csv("GTFS_Data/MBTA/allstops_fa22_wkdy.csv")
allStops_SA <- read_csv("GTFS_Data/MBTA/allstops_fa22_sat.csv")



WD_freq_summ <- full_join(allStops_WD, freq_WD) %>% 
  mutate(frequent_stop = if_else(is.na(frequent_stop), FALSE, TRUE))
