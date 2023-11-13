Annika created this code doc on 10/21/2023. Last compiled on 2023-11-13

- [Description](#description)
- [Setup](#setup)
- [DATA - Open and Clean](#data---open-and-clean)
- [define distance bins](#define-distance-bins)

# Description

This code opens raw datasets from NHTS data in 2017, cleans them,
possibly merges them, gives super basic summary tables of new stats that
are a result of the new vars, and then saves as new datasets. Another
code will then use the cleaned dataset from here to make more fancy
summary stats.

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

# DATA - Open and Clean

These data sets are from the NHST 2017 survey. Define and clean each
dataset. - trippub is person-trip, without geo IDs

## Dataset: trippub

- each row is a person-trip.

- This dataset is a public dataset. It does not have geo IDs.

- The public data dictionary is here:
  <https://nhts.ornl.gov/documentation>
  <https://nhts.ornl.gov/documentation>

``` r
trippub <- read_csv(file=file.path(data_path, 'trippub.csv'))
names(trippub)
```

    ##   [1] "HOUSEID"   "PERSONID"  "TDTRPNUM"  "STRTTIME"  "ENDTIME"   "TRVLCMIN" 
    ##   [7] "TRPMILES"  "TRPTRANS"  "TRPACCMP"  "TRPHHACC"  "VEHID"     "TRWAITTM" 
    ##  [13] "NUMTRANS"  "TRACCTM"   "DROP_PRK"  "TREGRTM"   "WHODROVE"  "WHYFROM"  
    ##  [19] "LOOP_TRIP" "TRPHHVEH"  "HHMEMDRV"  "HH_ONTD"   "NONHHCNT"  "NUMONTRP" 
    ##  [25] "PSGR_FLG"  "PUBTRANS"  "TRIPPURP"  "DWELTIME"  "TDWKND"    "VMT_MILE" 
    ##  [31] "DRVR_FLG"  "WHYTRP1S"  "ONTD_P1"   "ONTD_P2"   "ONTD_P3"   "ONTD_P4"  
    ##  [37] "ONTD_P5"   "ONTD_P6"   "ONTD_P7"   "ONTD_P8"   "ONTD_P9"   "ONTD_P10" 
    ##  [43] "ONTD_P11"  "ONTD_P12"  "ONTD_P13"  "TDCASEID"  "TRACC_WLK" "TRACC_POV"
    ##  [49] "TRACC_BUS" "TRACC_CRL" "TRACC_SUB" "TRACC_OTH" "TREGR_WLK" "TREGR_POV"
    ##  [55] "TREGR_BUS" "TREGR_CRL" "TREGR_SUB" "TREGR_OTH" "WHYTO"     "TRAVDAY"  
    ##  [61] "HOMEOWN"   "HHSIZE"    "HHVEHCNT"  "HHFAMINC"  "DRVRCNT"   "HHSTATE"  
    ##  [67] "HHSTFIPS"  "NUMADLT"   "WRKCOUNT"  "TDAYDATE"  "HHRESP"    "LIF_CYC"  
    ##  [73] "MSACAT"    "MSASIZE"   "RAIL"      "URBAN"     "URBANSIZE" "URBRUR"   
    ##  [79] "GASPRICE"  "CENSUS_D"  "CENSUS_R"  "CDIVMSAR"  "HH_RACE"   "HH_HISP"  
    ##  [85] "HH_CBSA"   "SMPLSRCE"  "R_AGE"     "EDUC"      "R_SEX"     "PRMACT"   
    ##  [91] "PROXY"     "WORKER"    "DRIVER"    "WTTRDFIN"  "WHYTRP90"  "R_AGE_IMP"
    ##  [97] "R_SEX_IMP" "HBHUR"     "HTHTNRNT"  "HTPPOPDN"  "HTRESDN"   "HTEEMPDN" 
    ## [103] "HBHTNRNT"  "HBPPOPDN"  "HBRESDN"

``` r
saveRDS(trippub, "df_trips.rds")
rm(trippub)
```

``` r
df_trips <- readRDS("df_trips.rds")
View(df_trips)
names(df_trips)
```

    ##   [1] "HOUSEID"   "PERSONID"  "TDTRPNUM"  "STRTTIME"  "ENDTIME"   "TRVLCMIN" 
    ##   [7] "TRPMILES"  "TRPTRANS"  "TRPACCMP"  "TRPHHACC"  "VEHID"     "TRWAITTM" 
    ##  [13] "NUMTRANS"  "TRACCTM"   "DROP_PRK"  "TREGRTM"   "WHODROVE"  "WHYFROM"  
    ##  [19] "LOOP_TRIP" "TRPHHVEH"  "HHMEMDRV"  "HH_ONTD"   "NONHHCNT"  "NUMONTRP" 
    ##  [25] "PSGR_FLG"  "PUBTRANS"  "TRIPPURP"  "DWELTIME"  "TDWKND"    "VMT_MILE" 
    ##  [31] "DRVR_FLG"  "WHYTRP1S"  "ONTD_P1"   "ONTD_P2"   "ONTD_P3"   "ONTD_P4"  
    ##  [37] "ONTD_P5"   "ONTD_P6"   "ONTD_P7"   "ONTD_P8"   "ONTD_P9"   "ONTD_P10" 
    ##  [43] "ONTD_P11"  "ONTD_P12"  "ONTD_P13"  "TDCASEID"  "TRACC_WLK" "TRACC_POV"
    ##  [49] "TRACC_BUS" "TRACC_CRL" "TRACC_SUB" "TRACC_OTH" "TREGR_WLK" "TREGR_POV"
    ##  [55] "TREGR_BUS" "TREGR_CRL" "TREGR_SUB" "TREGR_OTH" "WHYTO"     "TRAVDAY"  
    ##  [61] "HOMEOWN"   "HHSIZE"    "HHVEHCNT"  "HHFAMINC"  "DRVRCNT"   "HHSTATE"  
    ##  [67] "HHSTFIPS"  "NUMADLT"   "WRKCOUNT"  "TDAYDATE"  "HHRESP"    "LIF_CYC"  
    ##  [73] "MSACAT"    "MSASIZE"   "RAIL"      "URBAN"     "URBANSIZE" "URBRUR"   
    ##  [79] "GASPRICE"  "CENSUS_D"  "CENSUS_R"  "CDIVMSAR"  "HH_RACE"   "HH_HISP"  
    ##  [85] "HH_CBSA"   "SMPLSRCE"  "R_AGE"     "EDUC"      "R_SEX"     "PRMACT"   
    ##  [91] "PROXY"     "WORKER"    "DRIVER"    "WTTRDFIN"  "WHYTRP90"  "R_AGE_IMP"
    ##  [97] "R_SEX_IMP" "HBHUR"     "HTHTNRNT"  "HTPPOPDN"  "HTRESDN"   "HTEEMPDN" 
    ## [103] "HBHTNRNT"  "HBPPOPDN"  "HBRESDN"

### define modes

Uses TRPTRANS from NHTS

First I’m going to create smaller bins of modes because there are too
many, there are like 17 or more The definitions are here: GEMS master
data dictionary, in the clean_mode_choice_data tab:
<https://docs.google.com/spreadsheets/d/1RVxqALDAE1u4SC569Cq373_fafaE1nZiZBJJMiRTYu8/edit#gid=81250909>

![](pngs/TRPTRANS_dictionary.png)

``` r
df_trips <- df_trips  %>%
  mutate(mode = 
      case_when(TRPTRANS %in% c("01") ~ 'walk',
                TRPTRANS %in% c("02") ~ 'bike',
                TRPTRANS %in% c(10,11,12,13,14) ~ 'bus', 
                TRPTRANS %in% c(15, 16)~ 'rail',
                TRPTRANS %in% c(17) ~ 'taxi',
      # CONTESTING:
                  TRPTRANS %in% c("03","04","05","06",          "09","18") ~ 'hv', 
                # TRPTRANS %in% c("03","04","05","06",     "08") ~ 'personal vehicle', # PROPOSED
                # TRPTRANS %in% c(18) ~ 'rental', # PROPOSED
                  TRPTRANS %in% c(                    "07","08") ~ 'scooter', 
                # 09 is RV (motor home, ATV, snowmobile)
                # 18 is rental car
                # 08 is motorcycle / moped
                # 07 is golf cart / segway
                # TRPTRANS %in% c(19) ~ 'something else', # PROPOSED
                TRUE ~ "other")
      )


summary <- df_trips |>
    group_by(TRPTRANS, mode) |>
  summarise(countN = n() ,
            Nmissing = sum(is.na(mode)),
    .groups = "drop") |> 
  arrange(TRPTRANS)   
summary
```

<div class="kable-table">

| TRPTRANS | mode    | countN | Nmissing |
|:---------|:--------|-------:|---------:|
| -7       | other   |      2 |        0 |
| -8       | other   |     13 |        0 |
| -9       | other   |      1 |        0 |
| 01       | walk    |  81288 |        0 |
| 02       | bike    |   8034 |        0 |
| 03       | hv      | 396931 |        0 |
| 04       | hv      | 229466 |        0 |
| 05       | hv      |  60463 |        0 |
| 06       | hv      | 108303 |        0 |
| 07       | scooter |    826 |        0 |
| 08       | scooter |   2088 |        0 |
| 09       | hv      |    814 |        0 |
| 10       | bus     |  11313 |        0 |
| 11       | bus     |   6616 |        0 |
| 12       | bus     |    624 |        0 |
| 13       | bus     |   1581 |        0 |
| 14       | bus     |    120 |        0 |
| 15       | rail    |   1148 |        0 |
| 16       | rail    |   3326 |        0 |
| 17       | taxi    |   2813 |        0 |
| 18       | hv      |   2006 |        0 |
| 19       | other   |   1823 |        0 |
| 20       | other   |    458 |        0 |
| 97       | other   |   3515 |        0 |

</div>

``` r
summary <- df_trips |>
    group_by(mode) |>
  summarise(countN = n() ,
            Nmissing = sum(is.na(mode)),
    .groups = "drop") |> 
  arrange(-countN)   
summary
```

<div class="kable-table">

| mode    | countN | Nmissing |
|:--------|-------:|---------:|
| hv      | 797983 |        0 |
| walk    |  81288 |        0 |
| bus     |  20254 |        0 |
| bike    |   8034 |        0 |
| other   |   5812 |        0 |
| rail    |   4474 |        0 |
| scooter |   2914 |        0 |
| taxi    |   2813 |        0 |

</div>

### define trip purpose

trip_purpose generated from NHTS field ‘whytrp1s’
![](pngs/WHYTRP1S_dictionary.png)

``` r
df_trips <- df_trips  %>%
  mutate(trip_purpose = 
      case_when(WHYTRP1S %in% c("01") ~ 'home',
                WHYTRP1S %in% c("10") ~ 'work',
                WHYTRP1S %in% c("20") ~ 'school',
                WHYTRP1S %in% c("30") ~ 'medical',
                WHYTRP1S %in% c("40") ~ 'shopping',
                WHYTRP1S %in% c("50") ~ 'social',
                WHYTRP1S %in% c("70") ~ 'transp_someone',
                WHYTRP1S %in% c("80") ~ 'meals',
                TRUE ~ "other")
      )
summary <- df_trips |>
    group_by(WHYTRP1S, trip_purpose) |>
  summarise(countN = n() ,
            Nmissing = sum(is.na(mode)),
    .groups = "drop") |> 
  arrange(WHYTRP1S)   
summary
```

<div class="kable-table">

| WHYTRP1S | trip_purpose   | countN | Nmissing |
|:---------|:---------------|-------:|---------:|
| 01       | home           | 318777 |        0 |
| 10       | work           | 110590 |        0 |
| 20       | school         |  43397 |        0 |
| 30       | medical        |  16784 |        0 |
| 40       | shopping       | 184126 |        0 |
| 50       | social         | 100284 |        0 |
| 70       | transp_someone |  56377 |        0 |
| 80       | meals          |  72327 |        0 |
| 97       | other          |  20910 |        0 |

</div>

### define time bins

trip_purpose generated from NHTS field ‘STRTTIME’
![](pngs/STRTTIME_dictionary.png)

``` r
# convert to numeric
df_trips <- df_trips  %>%
  mutate(STRTTIME_num = as.numeric(STRTTIME))
```

``` r
df_trips <- df_trips  %>%
  mutate(start_time_bin = 
      case_when(STRTTIME_num <=  600 ~ 'morning_rush',
                STRTTIME_num >= 1600 ~ 'evening_rush',
                is.na(STRTTIME_num)  ~ 'missing time',
                TRUE ~ "other_time")
      )
summary <- df_trips |>
    group_by(start_time_bin) |>
  summarise(countN = n() ,
            "Min start time" = min(STRTTIME_num),
            "Max start time" = max(STRTTIME_num),
            Nmissing = sum(is.na(mode)),
    .groups = "drop") |> 
  arrange(start_time_bin)   
summary
```

<div class="kable-table">

| start_time_bin | countN | Min start time | Max start time | Nmissing |
|:---------------|-------:|---------------:|---------------:|---------:|
| evening_rush   | 298139 |           1600 |           2359 |        0 |
| morning_rush   |  20909 |              0 |            600 |        0 |
| other_time     | 604524 |            601 |           1559 |        0 |

</div>

# define distance bins

in the “transition_matrix” tab of the GEMS Master Data dictionary sheet
DistanceBinID “Trip distance bin defined as following: • bin1 - distance
between 0 and 1 mile • bin2 - distance between 1 and 2 miles • bin3 -
distance between 2 and 4 miles • bin4 - distance between 4 and 8 miles •
bin5 - distance between 8 and 15 miles • bin6 - distance between 15 and
20 miles • bin7 - distance between 20 and 35 miles • bin8 - distance
above 35 miles” \### Note is this inclusive? Check at some point

## Dataset: …

## Dataset: …

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

``` r
1 + 1
```

    ## [1] 2

``` r
knitr::knit_exit()
```
