10_mode-choices_summary-statistics
================
Annika
created this code doc on 10/21/2023. Last compiled on 2023-11-08

# Description

This code opens raw datasets from NHTS data in 2017, cleans them, saves
as new datasets. The second half of this code provides very basic
summary stats. Another code will then use the cleaned dataset from here
to make more fancy summary stats.

# Setup

## libraries

``` r
rm(list=ls()) # Clear RStudio environment
cat("\014") # Clear console
```



``` r
library(tidyverse)
library(readxl)
library(rstudioapi)
library(scales)
library(writexl)
#install.packages("rmarkdown")
```

## file path directories

``` r
# get current root directory of the user's Github repo
root <- getwd() # Saves current WD 
while ((basename(root) != "GEMS-data")) {
  root <- dirname(root)
} # Sets root equal to the location of the Github repo
source(file.path(root, "paths.R")) # Runs paths.R file found in users Github repo
```

``` r
data_path <- 'C:/FHWA/For FHWA folks/Mode_choice_estimation/Data'
```

# Open Data sets and Clean

These data sets are from the NHST 2017 (verify it’s 2017?) survey

## trippub dataset

- each row is a person-trip.

- This dataset is a public dataset. It does not have geo IDs.

- The public data dictionary is here:
  <https://nhts.ornl.gov/documentation>
  <https://nhts.ornl.gov/documentation>

``` r
trippub <- read_csv(file=file.path(data_path, 'trippub.csv'))
#View(trippub)
```

### 

``` r
summary <- trippub |>
    group_by(TRPTRANS) |>
  summarise(countN = n() ,
            Nmissing = sum(is.na(TRPTRANS)),
    .groups = "drop") |> 
  arrange(TRPTRANS)   
summary
```

<div class="kable-table">

| TRPTRANS | countN | Nmissing |
|:---------|-------:|---------:|
| -7       |      2 |        0 |
| -8       |     13 |        0 |
| -9       |      1 |        0 |
| 01       |  81288 |        0 |
| 02       |   8034 |        0 |
| 03       | 396931 |        0 |
| 04       | 229466 |        0 |
| 05       |  60463 |        0 |
| 06       | 108303 |        0 |
| 07       |    826 |        0 |
| 08       |   2088 |        0 |
| 09       |    814 |        0 |
| 10       |  11313 |        0 |
| 11       |   6616 |        0 |
| 12       |    624 |        0 |
| 13       |   1581 |        0 |
| 14       |    120 |        0 |
| 15       |   1148 |        0 |
| 16       |   3326 |        0 |
| 17       |   2813 |        0 |
| 18       |   2006 |        0 |
| 19       |   1823 |        0 |
| 20       |    458 |        0 |
| 97       |   3515 |        0 |

</div>

### define modes

First I’m going to create smaller bins of modes because there are too
many, there are like 17 or more The definitions are here: GEMS master
data dictionary, in the clean_mode_choice_data tab:
<https://docs.google.com/spreadsheets/d/1RVxqALDAE1u4SC569Cq373_fafaE1nZiZBJJMiRTYu8/edit#gid=81250909>

“Mode_chosen Generated from NHTS field ‘trptrans’. trptrans
=3,4,5,6,18,9 ~ ‘hv’, \# human driving vehicle trptrans =2 ~ ‘bike’,
trptrans =7,8 ~ ‘scooter’, trptrans =1 ~ ‘walk’, trptrans = 10-14 ~
‘bus’, \# now we only have 11 in the data trptrans =15, 16~ ‘rail’,
trptrans =17 ~ ‘taxi’, Rest ~ ‘other’”

## define trip purpose

“trip purpose generated from NHTS field ‘whytrp1s’. whytrp1s =50~
‘social’, whytrp1s =1 ~ ‘home’, whytrp1s =10~ ‘work’, whytrp1s =40 ~
‘shopping’, whytrp1s =70 ~ ‘transp_someone’, whytrp1s 30 ~ ‘medical’,
whytrp1s =80~ ‘meals’, whytrp1s =20~ ‘school’, Rest ~ ‘other’”

## define time bins

“travel time bins generated from NHTS field ‘strttime’. morning rush
hour \[6am, 9am), evening rush hour \[4pm, 7pm\], and other hours. 600
\>= strttime \<900 ~ ‘morning_rush’, 1600 \>= strttime \<=1900 ~
‘evening_rush’, rest ~ ‘other_time’”

## define distance bins

in the “transition_matrix” tab of the GEMS Master Data dictionary sheet
DistanceBinID “Trip distance bin defined as following: • bin1 - distance
between 0 and 1 mile • bin2 - distance between 1 and 2 miles • bin3 -
distance between 2 and 4 miles • bin4 - distance between 4 and 8 miles •
bin5 - distance between 8 and 15 miles • bin6 - distance between 15 and
20 miles • bin7 - distance between 20 and 35 miles • bin8 - distance
above 35 miles” \### Note is this inclusive? Check at some point

``` r
# Houshold GEOIDs?


#df <- read.csv(file = file.path(datadir, "hhct.csv" ))  # household, trip ct.csv -- resticted 

#

#df <- read.csv(trippub.csv)

# SURVEY DATA, this is cleaned of location
#trippub.csv # has all of the trip information for every trip a household took in the survey, each row is a trip
```

``` r
#hhpub -- # this has the household information , demographics, location of household, info from survey
  
  
# PRIVATE data, maps household to trips
#location <- read.csv(file = file.path(datadir, "hhct.csv" ))  # household, trip ct.csv -- resticted data -- only has household location -- links

#df <- tripct.csv # raw trip with od  -- only has tract
# trip path with distance
```

## Read in tripsct because it has the county fips codes and census tract to crosswalk to

# Next Steps

## Overview & background

Are there enough counties where there are enough trips within them
broken down into heterogeneity that we want to estimate the coefs

enough counties with enough trips for each mode –\> that’s what we need

then want to divide by heterogeneous groups.

Next to get heads around: Do we need number of or proportion for each
section for each to do the proportional mnl thing Also do we need to
weight it?

Goal: how should we collapse the data

## clean data enough that we can get a lots of different histograms

## Histogram of trip counts by county. Each county will have a number of trips that’s within the county

------------------------------------------------------------------------

------------------------------------------------------------------------

- 

## Histogram of trip counts by mode by county

## Also pull in the micro geotype indicators

i’ll need to ask Xiaodan where the cross walk is between census-tract
and microgeotypes

## TEMPO – look at how they did it

Use nhts does county level does fractional split logit? they have bins
of income levels how did they decide to use their bins? Were they
defining the bins <https://www.nrel.gov/transportation/tempo-model.html>

Note: keep all new vars etc, new definitions, at the beginning or in a
separate code

## Future next step

### doing a mnl fractional, even if not totally decided on how to make one unit of obs

filter raw trip in the NHTS by origin county tripct is census tract –
last 4 didgets or something is county number of trips by county by mode

- After that then \*

*User Classes* another need to have definitions of user classes income,
age, vehicle ownership – do we want to keep that definition? Use this to
look at definitions – but don’t merge with it bc maybe it excluded some
trips: nhts_user_classes_inc_veh_sr.csv 264234 C:FHWA folksXiaodan

*Time Classes* there’s a definition somewhere

*Distance Class* Can use this to see what the different classes are –
but these merge with geo types not with census TransitionMatrix-100m.csv
31919 C:FHWA folksXiaodan

``` r
#df <- load("C:/FHWA_R2/This is from before/Mode_choice_estimation/Data/ModeChoice_Tour_A.Rdata")
```

# train distance data merged to trip locations.

load(file=
file.path(datadir,‘NHTS_tract_origin_train_dist_transgeo.RData’))

# NOTE: “ct” is restricted, only data for us, like hhct

# “pub” public data

# “perwgt” is also public

# Step 1. Tripspub, maybe merge to ct. Need to merge to county. Take the

# raw trips, have the county / fips codes, then look at how many trips by county

# do we have per trips

# tract IDs, then the microgeotypes – crosswalk of tract to geotype

This is from before I talked to Anna and Xiaodan: \#— \# END \# \# END
\# \*\*\* Notes \*\*\*

``` r
1 + 1
```

    ## [1] 2

``` r
knitr::knit_exit()
```
