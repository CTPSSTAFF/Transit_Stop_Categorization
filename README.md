# Transit_Stop_Categorization
LRTP NA Transit Stop Categorization


RTA Data Files: https://www.mass.gov/lists/mbta-and-transit-data-for-developers
MetroWest RTA Data: https://transitfeeds.com/p/massdot/101 for September 6.

MBTA Data File: 20220923,20220928,"Fall 2022, 2022-09-30T22:53:11+00:00, version D" from https://cdn.mbta.com/archive/archived_feeds.txt

The purpose of this project was to categorize transit stops in the MPO as frequent or not.  Stops in each of the RTAs in the MPO were studied (Brockton, Cape Ann, Greater Attleboro Taunton RTA, Lowell, Merrimack Valley, and MetroWest), as well as the rapid transit, commuter rail, bus, and boat stops in the MBTA. To determine if a stop was frequent, it was judged based on two criteria: whether it ran for at least the minimum span required by the MBTA, and whether the mean stop headway was less than or equal to a given threshold.  The minimum span and headway threshold are dependent on the day of the week of service.  If the stop met that criteria at least 4 out of 6 times (two criteria x three day of week options = 6), the stop is classified as frequent.  
