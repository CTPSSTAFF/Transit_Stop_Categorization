# Transit_Stop_Categorization
LRTP NA Transit Stop Categorization


RTA Data Files: https://www.mass.gov/lists/mbta-and-transit-data-for-developers
MetroWest RTA Data: https://transitfeeds.com/p/massdot/101 for September 6.

MBTA Data Files: all and frequent MBTA stops come from OPMI.

The purpose of this project was to categorize transit stops in the MPO as frequent or not.  Stops in each of the RTAs in the MPO were studied (Brockton, Cape Ann, Greater Attleboro Taunton RTA, Lowell, Merrimack Valley, and MetroWest), as well as the rapid transit, commuter rail, bus, and boat stops in the MBTA. To determine if a stop was frequent, it was judged based on two criteria: whether it ran for at least the minimum span required by the MBTA, and whether the effective stop headway was less than or equal to a given threshold.  

Effective headway = sum (headway ^ 2) / sum(headway)


The minimum span and headway thresholds are dependent on the day of the week of service.  For weekdays, the minimum span is from 7am to 7pm.  For weekends, the minimum span is from 8am to 6:30pm.  

For the MBTA stops, a stop is frequent if it passes both span thresholds and if the effective headway was less than 15 minutes on weekdays AND 20 minutes on Saturdays.  For the RTA stops, a stop is frequent if it passes both span thresholds and if the effective headway was less than 20 minutes on weekdays AND Saturdays.  Since many of the RTAs don't provide Sunday transit service, we only looked at weekdays and Saturdays for all analyses.  RTAs tend to have less frequent service in general than the MBTA, so the frequency threshold is 20 minutes regardless of the day of the week.  A stop needs to pass all four thesholds (2 span and 2 frequency) for it to be designated as a frequent stop.  


The functions that were created to categorize the RTA stops are found in this script: Functions/Frequent_Stops_Functions.R

The script used to run these functions and create summarized and detailed outputs for the RTA stops is found here: Analysis/Running_Freq_Stops.R

The script used to combine the results from OPMI into a summarzed table of MBTA frequent stops is found here: Analysis/OPMI_MBTA.R

The output folder contains the shapefiles for the MBTA and RTA frequent stop summaries, as well as additional folders containing the detailed and summarized csvs for each individual RTA.
