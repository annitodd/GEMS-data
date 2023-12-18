# Summary Stats
Invalid Date

- [Description and Overview](#description-and-overview)
  - [Latest Updates](#latest-updates)
- [Setup](#setup)
  - [libraries](#libraries)
  - [file path directories](#file-path-directories)
- [Data: Open, summarize](#data-open-summarize)
  - [Full dataset](#full-dataset)
- [Smaller dataset](#smaller-dataset)
  - [REMOVE variables](#remove-variables)
  - [save with fewer variables AND only
    trips](#save-with-fewer-variables-and-only-trips)
  - [Summarise and Examine:](#summarise-and-examine)
- [Data:](#data)
- [Data: make analysis dataset
  (wider)](#data-make-analysis-dataset-wider)
  - [make county level dataset](#make-county-level-dataset)
  - [make microXgeotype level
    dataset](#make-microxgeotype-level-dataset)
- [START HERE DEC 14!!](#start-here-dec-14)
- [This is where put the modes
  wider](#this-is-where-put-the-modes-wider)
  - [Collapse by type unit etc](#collapse-by-type-unit-etc)
  - [Then widen](#then-widen)
  - [save widened](#save-widened)
- [histograms](#histograms)
  - [END 12/15](#end-1215)
  - [Wide microgeo by mode to get fractions (first get the
    sum)](#wide-microgeo-by-mode-to-get-fractions-first-get-the-sum)
  - [new dataset](#new-dataset)
- [Summary stats by coumty](#summary-stats-by-coumty)
  - [basic](#basic)
  - [by county](#by-county)
  - [by mode type by](#by-mode-type-by)
  - [by purpose](#by-purpose)
- [Make new proportional dataset](#make-new-proportional-dataset)
  - [by microXgeotype](#by-microxgeotype)
- [fractional split logit](#fractional-split-logit)
  - [methodology](#methodology)

html: code-fold: true df-print: paged

## Description and Overview

This code summarizes the dataset that is a result of this script:
10_mode-choice-cleaning

GitHub: This .Rmd code (possibly qmd if I have to change it with the new
update to R Studio) is synced to Github, and when this code is knit,
it’s also synced to GitHub, as a .md file, which makes the knitted code
easy to read (kind of like python code.) Currently in a FORK:
<https://github.com/annitodd/GEMS-data/blob/main/gems-mode-choice>

### Latest Updates

\####DEC 6: the next step is to go back to the 10\_ code, and add income

#### Dec 14: next step

Is to create the dataset that replicates the one i’ve been talking to
anna about in that excel sheet But FIRST make a mandatory vs
non-mandatory

another to-do is ALSO use the raw raw data in the folder that I found

## Setup

### libraries

``` r
library(arrow)
library(tidyverse)
library(readxl)
library(rstudioapi)
library(scales)
library(writexl)
library(sjmisc)
library(fmlogit)
library(tidyverse) # use this last
```

### file path directories

``` r
# get current root directory of the user's Github repo
root <- getwd() # Saves current WD 
#while ((basename(root) != "GEMS-data")) {
#  root <- dirname(root)
#} # Sets root equal to the location of the Github repo
#source(file.path(root, "paths.R")) # Runs paths.R file found in users Github repo
```

``` r
data_path <- 'C:/FHWA/For FHWA folks/Mode_choice_estimation/Data'
data_results <- 'C:/FHWA_R2/mode_choice_estimation/data'
```

## Data: Open, summarize

### Full dataset

full merged dataset

``` r
df_temp_full <- read_parquet(file.path(data_results, "10-mode-choice-cleaning_output-full-merged.parquet"))
names(df_temp_full)
```

      [1] "rawdatafrom_trippub_ATB"      "mode_ATB"                    
      [3] "trip_purpose_ATB"             "trip_purpose_small_ATB"      
      [5] "start_time_bin_ATB"           "orig_fips11_ATB"             
      [7] "dest_fips11_ATB"              "rawdatafrom_tripct_ATB"      
      [9] "hh_fips11_ATB"                "rawdatafrom_hhct_ATB"        
     [11] "origin_microtypeXgeotype_ATB" "origin_geotype_ATB"          
     [13] "origin_microXgeo2types_ATB"   "origin_microtype_ATB"        
     [15] "origin_geoXmicrotype_ATB"     "origin_geo2types_ATB"        
     [17] "dest_microtypeXgeotype_ATB"   "dest_geotype_ATB"            
     [19] "dest_microXgeo2types_ATB"     "dest_microtype_ATB"          
     [21] "dest_geoXmicrotype_ATB"       "dest_geo2types_ATB"          
     [23] "hh_microtypeXgeotype_ATB"     "hh_geotype_ATB"              
     [25] "hh_microXgeo2types_ATB"       "hh_microtype_ATB"            
     [27] "hh_geoXmicrotype_ATB"         "hh_geo2types_ATB"            
     [29] "vehicleYN_ATB"                "isSenior_ATB"                
     [31] "incHiLo_ATB"                  "user_class_ATB"              
     [33] "distance_bin_class_ATB"       "HOUSEID"                     
     [35] "PERSONID"                     "TDTRPNUM"                    
     [37] "STRTTIME"                     "ENDTIME"                     
     [39] "TRVLCMIN"                     "TRPMILES"                    
     [41] "TRPTRANS"                     "TRPACCMP"                    
     [43] "TRPHHACC"                     "VEHID"                       
     [45] "TRWAITTM"                     "NUMTRANS"                    
     [47] "TRACCTM"                      "DROP_PRK"                    
     [49] "TREGRTM"                      "WHODROVE"                    
     [51] "WHYFROM"                      "LOOP_TRIP"                   
     [53] "TRPHHVEH"                     "HHMEMDRV"                    
     [55] "HH_ONTD"                      "NONHHCNT"                    
     [57] "NUMONTRP"                     "PSGR_FLG"                    
     [59] "PUBTRANS"                     "TRIPPURP"                    
     [61] "DWELTIME"                     "TDWKND"                      
     [63] "VMT_MILE"                     "DRVR_FLG"                    
     [65] "WHYTRP1S"                     "ONTD_P1"                     
     [67] "ONTD_P2"                      "ONTD_P3"                     
     [69] "ONTD_P4"                      "ONTD_P5"                     
     [71] "ONTD_P6"                      "ONTD_P7"                     
     [73] "ONTD_P8"                      "ONTD_P9"                     
     [75] "ONTD_P10"                     "ONTD_P11"                    
     [77] "ONTD_P12"                     "ONTD_P13"                    
     [79] "TDCASEID"                     "TRACC_WLK"                   
     [81] "TRACC_POV"                    "TRACC_BUS"                   
     [83] "TRACC_CRL"                    "TRACC_SUB"                   
     [85] "TRACC_OTH"                    "TREGR_WLK"                   
     [87] "TREGR_POV"                    "TREGR_BUS"                   
     [89] "TREGR_CRL"                    "TREGR_SUB"                   
     [91] "TREGR_OTH"                    "WHYTO"                       
     [93] "TRAVDAY"                      "HOMEOWN"                     
     [95] "HHSIZE"                       "HHVEHCNT"                    
     [97] "HHFAMINC"                     "DRVRCNT"                     
     [99] "HHSTATE"                      "HHSTFIPS.x"                  
    [101] "NUMADLT"                      "WRKCOUNT"                    
    [103] "TDAYDATE"                     "HHRESP"                      
    [105] "LIF_CYC"                      "MSACAT"                      
    [107] "MSASIZE"                      "RAIL"                        
    [109] "URBAN"                        "URBANSIZE"                   
    [111] "URBRUR"                       "GASPRICE"                    
    [113] "CENSUS_D"                     "CENSUS_R"                    
    [115] "CDIVMSAR"                     "HH_RACE"                     
    [117] "HH_HISP"                      "HH_CBSA"                     
    [119] "SMPLSRCE"                     "R_AGE"                       
    [121] "EDUC"                         "R_SEX"                       
    [123] "PRMACT"                       "PROXY"                       
    [125] "WORKER"                       "DRIVER"                      
    [127] "WTTRDFIN"                     "WHYTRP90"                    
    [129] "R_AGE_IMP"                    "R_SEX_IMP"                   
    [131] "HBHUR"                        "HTHTNRNT"                    
    [133] "HTPPOPDN"                     "HTRESDN"                     
    [135] "HTEEMPDN"                     "HBHTNRNT"                    
    [137] "HBPPOPDN"                     "HBRESDN"                     
    [139] "STRTTIME_num"                 "ORIG_COUNTRY"                
    [141] "ORIG_ST"                      "ORIG_CNTY"                   
    [143] "ORIG_CT"                      "DEST_COUNTRY"                
    [145] "DEST_ST"                      "DEST_CNTY"                   
    [147] "DEST_CT"                      "HHSTFIPS.y"                  
    [149] "HHCNTYFP"                     "HHCT"                        

#### Summarize

Recall that the trips dataset and the households dataset, they don’t
equally merge, as we saw before (hhct has more households on file). Anna
notes that this is likely because lots of households took the survey but
only some of them filled out the trips diary part.

``` r
df_temp_full |>
  count(rawdatafrom_trippub_ATB,rawdatafrom_tripct_ATB,rawdatafrom_hhct_ATB)
```

    # A tibble: 2 × 4
      rawdatafrom_trippub_ATB rawdatafrom_tripct_ATB rawdatafrom_hhct_ATB      n
                        <dbl>                  <dbl>                <dbl>  <int>
    1                       1                      1                    1 923572
    2                      NA                     NA                    1  12474

``` r
df_temp_full <- ungroup(df_temp_full)
```

The number of **observations** in the dataset (these should give the
same answer):

``` r
df_temp_full |> summarise(n())
```

    # A tibble: 1 × 1
       `n()`
       <int>
    1 936046

``` r
df_temp_full |> summarise(n_distinct(HOUSEID,PERSONID,TDTRPNUM))
```

    # A tibble: 1 × 1
      `n_distinct(HOUSEID, PERSONID, TDTRPNUM)`
                                          <int>
    1                                    936046

number of **people** in the dataset:

``` r
df_temp_full |> summarise(n_distinct(HOUSEID,PERSONID))
```

    # A tibble: 1 × 1
      `n_distinct(HOUSEID, PERSONID)`
                                <int>
    1                          231668

number of **people** in the dataset **with trips** (there are FEWER
people with trips than there are total people:

``` r
df_temp_full |> 
  filter(rawdatafrom_trippub_ATB==1,rawdatafrom_tripct_ATB==1,rawdatafrom_hhct_ATB==1) |> summarise(n_distinct(HOUSEID,PERSONID))
```

    # A tibble: 1 × 1
      `n_distinct(HOUSEID, PERSONID)`
                                <int>
    1                          219194

The number of **households** in the dataset:

``` r
df_temp_full |> summarise(n_distinct(HOUSEID))
```

    # A tibble: 1 × 1
      `n_distinct(HOUSEID)`
                      <int>
    1                129696

The number of **households** in the dataset **with trips**:

``` r
df_temp_full |> 
  filter(rawdatafrom_trippub_ATB==1,rawdatafrom_tripct_ATB==1,rawdatafrom_hhct_ATB==1) |> summarise(n_distinct(HOUSEID))
```

    # A tibble: 1 × 1
      `n_distinct(HOUSEID)`
                      <int>
    1                117222

#### Missing observations

``` r
summary <- df_temp_full |>
    group_by(mode_ATB) |>
  summarise(countN = n() ,
            Nmissing = sum(is.na(mode_ATB)),
    .groups = "drop") |> 
  arrange(-countN)   
summary
```

    # A tibble: 8 × 3
      mode_ATB countN Nmissing
      <chr>     <int>    <int>
    1 hv       800071        0
    2 walk      81288        0
    3 bus       20254        0
    4 <NA>      12474    12474
    5 bike       8034        0
    6 other      6638        0
    7 rail       4474        0
    8 taxi       2813        0

For the **bin class** It looks like the missing values are from the
non-trip survey part, but ALSO, many distance bins that are missing (656
of them)

``` r
df_temp_full |> 
  count(distance_bin_class_ATB,rawdatafrom_tripct_ATB,rawdatafrom_hhct_ATB)
```

    # A tibble: 10 × 4
       distance_bin_class_ATB rawdatafrom_tripct_ATB rawdatafrom_hhct_ATB      n
       <fct>                                   <dbl>                <dbl>  <int>
     1 bin1                                        1                    1 176959
     2 bin2                                        1                    1 140845
     3 bin3                                        1                    1 183539
     4 bin4                                        1                    1 171526
     5 bin5                                        1                    1 120310
     6 bin6                                        1                    1  40437
     7 bin7                                        1                    1  48542
     8 bin8                                        1                    1  40758
     9 <NA>                                        1                    1    656
    10 <NA>                                       NA                    1  12474

Now **missings for all of the important vars** , the important ones end
with \_ATB

``` r
summary_table <- df_temp_full |> 
  select(contains("_ATB")) |> 
  summarise(
          countN = n(),
          across(.cols=everything(), ~sum(is.na(.x)),.names = "{.col}_Missing"),
            across(where(is.factor ),~n_distinct(.x),.names = "{.col}_Ndis"),
            , .groups = "drop") |> 
  arrange(countN) 
summary_table %>% sjmisc::rotate_df(rn="N distinct")
```

                                 N distinct     V1
    1                                countN 936046
    2       rawdatafrom_trippub_ATB_Missing  12474
    3                      mode_ATB_Missing  12474
    4              trip_purpose_ATB_Missing  12474
    5        trip_purpose_small_ATB_Missing  12474
    6            start_time_bin_ATB_Missing  12474
    7               orig_fips11_ATB_Missing  12474
    8               dest_fips11_ATB_Missing  12474
    9        rawdatafrom_tripct_ATB_Missing  12474
    10                hh_fips11_ATB_Missing      0
    11         rawdatafrom_hhct_ATB_Missing      0
    12 origin_microtypeXgeotype_ATB_Missing  12717
    13           origin_geotype_ATB_Missing  12717
    14   origin_microXgeo2types_ATB_Missing  12717
    15         origin_microtype_ATB_Missing  12717
    16     origin_geoXmicrotype_ATB_Missing  12717
    17         origin_geo2types_ATB_Missing  12717
    18   dest_microtypeXgeotype_ATB_Missing  12701
    19             dest_geotype_ATB_Missing  12701
    20     dest_microXgeo2types_ATB_Missing  12701
    21           dest_microtype_ATB_Missing  12701
    22       dest_geoXmicrotype_ATB_Missing  12701
    23           dest_geo2types_ATB_Missing  12701
    24     hh_microtypeXgeotype_ATB_Missing     47
    25               hh_geotype_ATB_Missing     47
    26       hh_microXgeo2types_ATB_Missing     47
    27             hh_microtype_ATB_Missing     47
    28         hh_geoXmicrotype_ATB_Missing     47
    29             hh_geo2types_ATB_Missing     47
    30                vehicleYN_ATB_Missing  12474
    31                 isSenior_ATB_Missing  12474
    32                  incHiLo_ATB_Missing  12474
    33               user_class_ATB_Missing      0
    34       distance_bin_class_ATB_Missing  13130
    35                       countN_Missing      0
    36          distance_bin_class_ATB_Ndis      9

another way to look at some missings:

``` r
df_temp_full |> 
  count(user_class_ATB,rawdatafrom_tripct_ATB,rawdatafrom_hhct_ATB)
```

    # A tibble: 13 × 4
       user_class_ATB     rawdatafrom_tripct_ATB rawdatafrom_hhct_ATB      n
       <chr>                               <dbl>                <dbl>  <int>
     1 HiInc_NVeh_NSenior                      1                    1   3352
     2 HiInc_NVeh_YSenior                      1                    1    634
     3 HiInc_YVeh_NSenior                      1                    1 471444
     4 HiInc_YVeh_YSenior                      1                    1 132075
     5 LoInc_NVeh_NSenior                      1                    1  13480
     6 LoInc_NVeh_YSenior                      1                    1   5008
     7 LoInc_YVeh_NSenior                      1                    1 176506
     8 LoInc_YVeh_YSenior                      1                    1  96733
     9 NAInc_NVeh_NSenior                      1                    1    330
    10 NAInc_NVeh_YSenior                      1                    1    376
    11 NAInc_YVeh_NSenior                      1                    1  12041
    12 NAInc_YVeh_YSenior                      1                    1  11593
    13 Other                                  NA                    1  12474

What if we look only at the ones that are from the trip data:

``` r
summary_table <- df_temp_full |> 
  select(contains("_ATB")) |> 
  group_by(rawdatafrom_trippub_ATB,rawdatafrom_tripct_ATB,rawdatafrom_hhct_ATB) |> 
  summarise(
          countN = n(),
          across(.cols=everything(), ~sum(is.na(.x)),.names = "{.col}_Missing"),
            across(where(is.factor ),~n_distinct(.x),.names = "{.col}_Ndis"),
            , .groups = "drop") |> 
  arrange(countN) 
summary_table
```

    # A tibble: 2 × 36
      rawdatafrom_trippub_ATB rawdatafrom_tripct_ATB rawdatafrom_hhct_ATB countN
                        <dbl>                  <dbl>                <dbl>  <int>
    1                      NA                     NA                    1  12474
    2                       1                      1                    1 923572
    # ℹ 32 more variables: mode_ATB_Missing <int>, trip_purpose_ATB_Missing <int>,
    #   trip_purpose_small_ATB_Missing <int>, start_time_bin_ATB_Missing <int>,
    #   orig_fips11_ATB_Missing <int>, dest_fips11_ATB_Missing <int>,
    #   hh_fips11_ATB_Missing <int>, origin_microtypeXgeotype_ATB_Missing <int>,
    #   origin_geotype_ATB_Missing <int>, origin_microXgeo2types_ATB_Missing <int>,
    #   origin_microtype_ATB_Missing <int>, origin_geoXmicrotype_ATB_Missing <int>,
    #   origin_geo2types_ATB_Missing <int>, …

``` r
summary_table %>% sjmisc::rotate_df(rn="V2 is obs with trips")
```

                       V2 is obs with trips    V1     V2
    1               rawdatafrom_trippub_ATB    NA      1
    2                rawdatafrom_tripct_ATB    NA      1
    3                  rawdatafrom_hhct_ATB     1      1
    4                                countN 12474 923572
    5                      mode_ATB_Missing 12474      0
    6              trip_purpose_ATB_Missing 12474      0
    7        trip_purpose_small_ATB_Missing 12474      0
    8            start_time_bin_ATB_Missing 12474      0
    9               orig_fips11_ATB_Missing 12474      0
    10              dest_fips11_ATB_Missing 12474      0
    11                hh_fips11_ATB_Missing     0      0
    12 origin_microtypeXgeotype_ATB_Missing 12474    243
    13           origin_geotype_ATB_Missing 12474    243
    14   origin_microXgeo2types_ATB_Missing 12474    243
    15         origin_microtype_ATB_Missing 12474    243
    16     origin_geoXmicrotype_ATB_Missing 12474    243
    17         origin_geo2types_ATB_Missing 12474    243
    18   dest_microtypeXgeotype_ATB_Missing 12474    227
    19             dest_geotype_ATB_Missing 12474    227
    20     dest_microXgeo2types_ATB_Missing 12474    227
    21           dest_microtype_ATB_Missing 12474    227
    22       dest_geoXmicrotype_ATB_Missing 12474    227
    23           dest_geo2types_ATB_Missing 12474    227
    24     hh_microtypeXgeotype_ATB_Missing     1     46
    25               hh_geotype_ATB_Missing     1     46
    26       hh_microXgeo2types_ATB_Missing     1     46
    27             hh_microtype_ATB_Missing     1     46
    28         hh_geoXmicrotype_ATB_Missing     1     46
    29             hh_geo2types_ATB_Missing     1     46
    30                vehicleYN_ATB_Missing 12474      0
    31                 isSenior_ATB_Missing 12474      0
    32                  incHiLo_ATB_Missing 12474      0
    33               user_class_ATB_Missing     0      0
    34       distance_bin_class_ATB_Missing 12474    656
    35                       countN_Missing     0      0
    36          distance_bin_class_ATB_Ndis     1      9

``` r
df_trips_only <- df_temp_full |> 
  filter(rawdatafrom_trippub_ATB==1,rawdatafrom_tripct_ATB==1,rawdatafrom_hhct_ATB==1)

df_trips_only |> 
  count(rawdatafrom_trippub_ATB,rawdatafrom_tripct_ATB,rawdatafrom_hhct_ATB)
```

    # A tibble: 1 × 4
      rawdatafrom_trippub_ATB rawdatafrom_tripct_ATB rawdatafrom_hhct_ATB      n
                        <dbl>                  <dbl>                <dbl>  <int>
    1                       1                      1                    1 923572

``` r
df_trips_only <- ungroup(df_trips_only)
```

#### List of variables and descriptions

``` r
names(df_trips_only)
```

      [1] "rawdatafrom_trippub_ATB"      "mode_ATB"                    
      [3] "trip_purpose_ATB"             "trip_purpose_small_ATB"      
      [5] "start_time_bin_ATB"           "orig_fips11_ATB"             
      [7] "dest_fips11_ATB"              "rawdatafrom_tripct_ATB"      
      [9] "hh_fips11_ATB"                "rawdatafrom_hhct_ATB"        
     [11] "origin_microtypeXgeotype_ATB" "origin_geotype_ATB"          
     [13] "origin_microXgeo2types_ATB"   "origin_microtype_ATB"        
     [15] "origin_geoXmicrotype_ATB"     "origin_geo2types_ATB"        
     [17] "dest_microtypeXgeotype_ATB"   "dest_geotype_ATB"            
     [19] "dest_microXgeo2types_ATB"     "dest_microtype_ATB"          
     [21] "dest_geoXmicrotype_ATB"       "dest_geo2types_ATB"          
     [23] "hh_microtypeXgeotype_ATB"     "hh_geotype_ATB"              
     [25] "hh_microXgeo2types_ATB"       "hh_microtype_ATB"            
     [27] "hh_geoXmicrotype_ATB"         "hh_geo2types_ATB"            
     [29] "vehicleYN_ATB"                "isSenior_ATB"                
     [31] "incHiLo_ATB"                  "user_class_ATB"              
     [33] "distance_bin_class_ATB"       "HOUSEID"                     
     [35] "PERSONID"                     "TDTRPNUM"                    
     [37] "STRTTIME"                     "ENDTIME"                     
     [39] "TRVLCMIN"                     "TRPMILES"                    
     [41] "TRPTRANS"                     "TRPACCMP"                    
     [43] "TRPHHACC"                     "VEHID"                       
     [45] "TRWAITTM"                     "NUMTRANS"                    
     [47] "TRACCTM"                      "DROP_PRK"                    
     [49] "TREGRTM"                      "WHODROVE"                    
     [51] "WHYFROM"                      "LOOP_TRIP"                   
     [53] "TRPHHVEH"                     "HHMEMDRV"                    
     [55] "HH_ONTD"                      "NONHHCNT"                    
     [57] "NUMONTRP"                     "PSGR_FLG"                    
     [59] "PUBTRANS"                     "TRIPPURP"                    
     [61] "DWELTIME"                     "TDWKND"                      
     [63] "VMT_MILE"                     "DRVR_FLG"                    
     [65] "WHYTRP1S"                     "ONTD_P1"                     
     [67] "ONTD_P2"                      "ONTD_P3"                     
     [69] "ONTD_P4"                      "ONTD_P5"                     
     [71] "ONTD_P6"                      "ONTD_P7"                     
     [73] "ONTD_P8"                      "ONTD_P9"                     
     [75] "ONTD_P10"                     "ONTD_P11"                    
     [77] "ONTD_P12"                     "ONTD_P13"                    
     [79] "TDCASEID"                     "TRACC_WLK"                   
     [81] "TRACC_POV"                    "TRACC_BUS"                   
     [83] "TRACC_CRL"                    "TRACC_SUB"                   
     [85] "TRACC_OTH"                    "TREGR_WLK"                   
     [87] "TREGR_POV"                    "TREGR_BUS"                   
     [89] "TREGR_CRL"                    "TREGR_SUB"                   
     [91] "TREGR_OTH"                    "WHYTO"                       
     [93] "TRAVDAY"                      "HOMEOWN"                     
     [95] "HHSIZE"                       "HHVEHCNT"                    
     [97] "HHFAMINC"                     "DRVRCNT"                     
     [99] "HHSTATE"                      "HHSTFIPS.x"                  
    [101] "NUMADLT"                      "WRKCOUNT"                    
    [103] "TDAYDATE"                     "HHRESP"                      
    [105] "LIF_CYC"                      "MSACAT"                      
    [107] "MSASIZE"                      "RAIL"                        
    [109] "URBAN"                        "URBANSIZE"                   
    [111] "URBRUR"                       "GASPRICE"                    
    [113] "CENSUS_D"                     "CENSUS_R"                    
    [115] "CDIVMSAR"                     "HH_RACE"                     
    [117] "HH_HISP"                      "HH_CBSA"                     
    [119] "SMPLSRCE"                     "R_AGE"                       
    [121] "EDUC"                         "R_SEX"                       
    [123] "PRMACT"                       "PROXY"                       
    [125] "WORKER"                       "DRIVER"                      
    [127] "WTTRDFIN"                     "WHYTRP90"                    
    [129] "R_AGE_IMP"                    "R_SEX_IMP"                   
    [131] "HBHUR"                        "HTHTNRNT"                    
    [133] "HTPPOPDN"                     "HTRESDN"                     
    [135] "HTEEMPDN"                     "HBHTNRNT"                    
    [137] "HBPPOPDN"                     "HBRESDN"                     
    [139] "STRTTIME_num"                 "ORIG_COUNTRY"                
    [141] "ORIG_ST"                      "ORIG_CNTY"                   
    [143] "ORIG_CT"                      "DEST_COUNTRY"                
    [145] "DEST_ST"                      "DEST_CNTY"                   
    [147] "DEST_CT"                      "HHSTFIPS.y"                  
    [149] "HHCNTYFP"                     "HHCT"                        

This is the data dictionary from NHTS:

``` r
dictionary_v1_2 <- read_csv("dictionary_v1_2.csv") %>% 
  relocate ("Label","Name")
dictionary_v1_2 
```

    # A tibble: 244 × 8
       Label                              Name  Type  Length HH    PER   VEH   TRIP 
       <chr>                              <chr> <chr>  <dbl> <chr> <chr> <chr> <lgl>
     1 Alternative Mode of Transportatio… ALT_… C          2 <NA>  P     <NA>  NA   
     2 Alternative Mode of Transportatio… ALT_… C          2 <NA>  P     <NA>  NA   
     3 Alternative Mode of Transportatio… ALT_… C          2 <NA>  P     <NA>  NA   
     4 Self-reported annualized mile est… ANNM… N          6 <NA>  <NA>  V     NA   
     5 Best estimate of annual miles      BEST… N          8 <NA>  <NA>  V     NA   
     6 Flag any edits/adjustments to BES… BEST… C          2 <NA>  <NA>  V     NA   
     7 How BESTMILE was computed          BEST… C          2 <NA>  <NA>  V     NA   
     8 Flag identifying BESTMILE outlier… BEST… C          2 <NA>  <NA>  V     NA   
     9 Frequency of Bicycle Use for Trav… BIKE  C          2 H     <NA>  <NA>  NA   
    10 Bicycle to Reduce Financial Burde… BIKE… C          2 H     <NA>  <NA>  NA   
    # ℹ 234 more rows

## Smaller dataset

### REMOVE variables

choose only some vars: keep all of the ones that we made. These all end
in “\_ATB”

``` r
names(df_trips_only)
```

      [1] "rawdatafrom_trippub_ATB"      "mode_ATB"                    
      [3] "trip_purpose_ATB"             "trip_purpose_small_ATB"      
      [5] "start_time_bin_ATB"           "orig_fips11_ATB"             
      [7] "dest_fips11_ATB"              "rawdatafrom_tripct_ATB"      
      [9] "hh_fips11_ATB"                "rawdatafrom_hhct_ATB"        
     [11] "origin_microtypeXgeotype_ATB" "origin_geotype_ATB"          
     [13] "origin_microXgeo2types_ATB"   "origin_microtype_ATB"        
     [15] "origin_geoXmicrotype_ATB"     "origin_geo2types_ATB"        
     [17] "dest_microtypeXgeotype_ATB"   "dest_geotype_ATB"            
     [19] "dest_microXgeo2types_ATB"     "dest_microtype_ATB"          
     [21] "dest_geoXmicrotype_ATB"       "dest_geo2types_ATB"          
     [23] "hh_microtypeXgeotype_ATB"     "hh_geotype_ATB"              
     [25] "hh_microXgeo2types_ATB"       "hh_microtype_ATB"            
     [27] "hh_geoXmicrotype_ATB"         "hh_geo2types_ATB"            
     [29] "vehicleYN_ATB"                "isSenior_ATB"                
     [31] "incHiLo_ATB"                  "user_class_ATB"              
     [33] "distance_bin_class_ATB"       "HOUSEID"                     
     [35] "PERSONID"                     "TDTRPNUM"                    
     [37] "STRTTIME"                     "ENDTIME"                     
     [39] "TRVLCMIN"                     "TRPMILES"                    
     [41] "TRPTRANS"                     "TRPACCMP"                    
     [43] "TRPHHACC"                     "VEHID"                       
     [45] "TRWAITTM"                     "NUMTRANS"                    
     [47] "TRACCTM"                      "DROP_PRK"                    
     [49] "TREGRTM"                      "WHODROVE"                    
     [51] "WHYFROM"                      "LOOP_TRIP"                   
     [53] "TRPHHVEH"                     "HHMEMDRV"                    
     [55] "HH_ONTD"                      "NONHHCNT"                    
     [57] "NUMONTRP"                     "PSGR_FLG"                    
     [59] "PUBTRANS"                     "TRIPPURP"                    
     [61] "DWELTIME"                     "TDWKND"                      
     [63] "VMT_MILE"                     "DRVR_FLG"                    
     [65] "WHYTRP1S"                     "ONTD_P1"                     
     [67] "ONTD_P2"                      "ONTD_P3"                     
     [69] "ONTD_P4"                      "ONTD_P5"                     
     [71] "ONTD_P6"                      "ONTD_P7"                     
     [73] "ONTD_P8"                      "ONTD_P9"                     
     [75] "ONTD_P10"                     "ONTD_P11"                    
     [77] "ONTD_P12"                     "ONTD_P13"                    
     [79] "TDCASEID"                     "TRACC_WLK"                   
     [81] "TRACC_POV"                    "TRACC_BUS"                   
     [83] "TRACC_CRL"                    "TRACC_SUB"                   
     [85] "TRACC_OTH"                    "TREGR_WLK"                   
     [87] "TREGR_POV"                    "TREGR_BUS"                   
     [89] "TREGR_CRL"                    "TREGR_SUB"                   
     [91] "TREGR_OTH"                    "WHYTO"                       
     [93] "TRAVDAY"                      "HOMEOWN"                     
     [95] "HHSIZE"                       "HHVEHCNT"                    
     [97] "HHFAMINC"                     "DRVRCNT"                     
     [99] "HHSTATE"                      "HHSTFIPS.x"                  
    [101] "NUMADLT"                      "WRKCOUNT"                    
    [103] "TDAYDATE"                     "HHRESP"                      
    [105] "LIF_CYC"                      "MSACAT"                      
    [107] "MSASIZE"                      "RAIL"                        
    [109] "URBAN"                        "URBANSIZE"                   
    [111] "URBRUR"                       "GASPRICE"                    
    [113] "CENSUS_D"                     "CENSUS_R"                    
    [115] "CDIVMSAR"                     "HH_RACE"                     
    [117] "HH_HISP"                      "HH_CBSA"                     
    [119] "SMPLSRCE"                     "R_AGE"                       
    [121] "EDUC"                         "R_SEX"                       
    [123] "PRMACT"                       "PROXY"                       
    [125] "WORKER"                       "DRIVER"                      
    [127] "WTTRDFIN"                     "WHYTRP90"                    
    [129] "R_AGE_IMP"                    "R_SEX_IMP"                   
    [131] "HBHUR"                        "HTHTNRNT"                    
    [133] "HTPPOPDN"                     "HTRESDN"                     
    [135] "HTEEMPDN"                     "HBHTNRNT"                    
    [137] "HBPPOPDN"                     "HBRESDN"                     
    [139] "STRTTIME_num"                 "ORIG_COUNTRY"                
    [141] "ORIG_ST"                      "ORIG_CNTY"                   
    [143] "ORIG_CT"                      "DEST_COUNTRY"                
    [145] "DEST_ST"                      "DEST_CNTY"                   
    [147] "DEST_CT"                      "HHSTFIPS.y"                  
    [149] "HHCNTYFP"                     "HHCT"                        

``` r
df_trips_only_small <- df_trips_only |> 
  select(contains("_ATB")) %>% 
  select(-contains("rawdatafrom"))
df_trips_only_small
```

    # A tibble: 923,572 × 30
       mode_ATB trip_purpose_ATB trip_purpose_small_ATB start_time_bin_ATB
       <chr>    <chr>            <chr>                  <chr>             
     1 hv       school           work_school            other_time        
     2 hv       home             home                   other_time        
     3 hv       home             home                   other_time        
     4 hv       work             work_school            evening_rush      
     5 hv       school           work_school            other_time        
     6 hv       home             home                   other_time        
     7 hv       work             work_school            other_time        
     8 hv       home             home                   evening_rush      
     9 hv       social           other                  morning_rush      
    10 hv       home             home                   other_time        
    # ℹ 923,562 more rows
    # ℹ 26 more variables: orig_fips11_ATB <chr>, dest_fips11_ATB <chr>,
    #   hh_fips11_ATB <chr>, origin_microtypeXgeotype_ATB <chr>,
    #   origin_geotype_ATB <chr>, origin_microXgeo2types_ATB <chr>,
    #   origin_microtype_ATB <dbl>, origin_geoXmicrotype_ATB <chr>,
    #   origin_geo2types_ATB <chr>, dest_microtypeXgeotype_ATB <chr>,
    #   dest_geotype_ATB <chr>, dest_microXgeo2types_ATB <chr>, …

### save with fewer variables AND only trips

This keeps only some variables

``` r
df_trips_only_small <- df_trips_only |> 
  select(contains("_ATB")) %>% 
  select(-contains("rawdatafrom"))

write_parquet(df_trips_only_small,  file.path(data_results, "10-mode-choice-cleaning_output-merged-onlytrips-fewvars.parquet"))
write_rds(df_trips_only_small,  file.path(data_results, "10-mode-choice-cleaning_output-merged-onlytrips-fewvars.rds"))
write_csv(df_trips_only_small,  file.path(data_results, "10-mode-choice-cleaning_output-merged-onlytrips-fewvars.csv"))
```

#### Number of distinct groups in each variable

``` r
summary <- df_trips_only_small |>
  summarise("Number Obs" = n(),
            across(contains("_ATB"),~n_distinct(.x),.names = "{.col} distinct"),
    .groups = "drop")
summary
```

    # A tibble: 1 × 31
      `Number Obs` `mode_ATB distinct` trip_purpose_ATB dis…¹ trip_purpose_small_A…²
             <int>               <int>                  <int>                  <int>
    1       923572                   7                      9                      3
    # ℹ abbreviated names: ¹​`trip_purpose_ATB distinct`,
    #   ²​`trip_purpose_small_ATB distinct`
    # ℹ 27 more variables: `start_time_bin_ATB distinct` <int>,
    #   `orig_fips11_ATB distinct` <int>, `dest_fips11_ATB distinct` <int>,
    #   `hh_fips11_ATB distinct` <int>,
    #   `origin_microtypeXgeotype_ATB distinct` <int>,
    #   `origin_geotype_ATB distinct` <int>, …

``` r
summary %>% sjmisc::rotate_df(rn="N distinct")
```

                                  N distinct     V1
    1                             Number Obs 923572
    2                      mode_ATB distinct      7
    3              trip_purpose_ATB distinct      9
    4        trip_purpose_small_ATB distinct      3
    5            start_time_bin_ATB distinct      3
    6               orig_fips11_ATB distinct  52765
    7               dest_fips11_ATB distinct  52783
    8                 hh_fips11_ATB distinct  33586
    9  origin_microtypeXgeotype_ATB distinct     37
    10           origin_geotype_ATB distinct      7
    11   origin_microXgeo2types_ATB distinct     13
    12         origin_microtype_ATB distinct      7
    13     origin_geoXmicrotype_ATB distinct     37
    14         origin_geo2types_ATB distinct      3
    15   dest_microtypeXgeotype_ATB distinct     37
    16             dest_geotype_ATB distinct      7
    17     dest_microXgeo2types_ATB distinct     13
    18           dest_microtype_ATB distinct      7
    19       dest_geoXmicrotype_ATB distinct     37
    20           dest_geo2types_ATB distinct      3
    21     hh_microtypeXgeotype_ATB distinct     37
    22               hh_geotype_ATB distinct      7
    23       hh_microXgeo2types_ATB distinct     13
    24             hh_microtype_ATB distinct      7
    25         hh_geoXmicrotype_ATB distinct     37
    26             hh_geo2types_ATB distinct      3
    27                vehicleYN_ATB distinct      2
    28                 isSenior_ATB distinct      2
    29                  incHiLo_ATB distinct      3
    30               user_class_ATB distinct     12
    31       distance_bin_class_ATB distinct      9

``` r
names(df_trips_only_small)
```

     [1] "mode_ATB"                     "trip_purpose_ATB"            
     [3] "trip_purpose_small_ATB"       "start_time_bin_ATB"          
     [5] "orig_fips11_ATB"              "dest_fips11_ATB"             
     [7] "hh_fips11_ATB"                "origin_microtypeXgeotype_ATB"
     [9] "origin_geotype_ATB"           "origin_microXgeo2types_ATB"  
    [11] "origin_microtype_ATB"         "origin_geoXmicrotype_ATB"    
    [13] "origin_geo2types_ATB"         "dest_microtypeXgeotype_ATB"  
    [15] "dest_geotype_ATB"             "dest_microXgeo2types_ATB"    
    [17] "dest_microtype_ATB"           "dest_geoXmicrotype_ATB"      
    [19] "dest_geo2types_ATB"           "hh_microtypeXgeotype_ATB"    
    [21] "hh_geotype_ATB"               "hh_microXgeo2types_ATB"      
    [23] "hh_microtype_ATB"             "hh_geoXmicrotype_ATB"        
    [25] "hh_geo2types_ATB"             "vehicleYN_ATB"               
    [27] "isSenior_ATB"                 "incHiLo_ATB"                 
    [29] "user_class_ATB"               "distance_bin_class_ATB"      

### Summarise and Examine:

#### the key vars

``` r
names(df_trips_only_small)
```

     [1] "mode_ATB"                     "trip_purpose_ATB"            
     [3] "trip_purpose_small_ATB"       "start_time_bin_ATB"          
     [5] "orig_fips11_ATB"              "dest_fips11_ATB"             
     [7] "hh_fips11_ATB"                "origin_microtypeXgeotype_ATB"
     [9] "origin_geotype_ATB"           "origin_microXgeo2types_ATB"  
    [11] "origin_microtype_ATB"         "origin_geoXmicrotype_ATB"    
    [13] "origin_geo2types_ATB"         "dest_microtypeXgeotype_ATB"  
    [15] "dest_geotype_ATB"             "dest_microXgeo2types_ATB"    
    [17] "dest_microtype_ATB"           "dest_geoXmicrotype_ATB"      
    [19] "dest_geo2types_ATB"           "hh_microtypeXgeotype_ATB"    
    [21] "hh_geotype_ATB"               "hh_microXgeo2types_ATB"      
    [23] "hh_microtype_ATB"             "hh_geoXmicrotype_ATB"        
    [25] "hh_geo2types_ATB"             "vehicleYN_ATB"               
    [27] "isSenior_ATB"                 "incHiLo_ATB"                 
    [29] "user_class_ATB"               "distance_bin_class_ATB"      

##### the distinct values

``` r
df_trips_only_small %>% 
  distinct(origin_geoXmicrotype_ATB) 
```

    # A tibble: 37 × 1
       origin_geoXmicrotype_ATB
       <chr>                   
     1 E_4                     
     2 C_3                     
     3 E_5                     
     4 A_5                     
     5 A_4                     
     6 B_1                     
     7 B_4                     
     8 B_5                     
     9 B_2                     
    10 F_5                     
    # ℹ 27 more rows

``` r
df_trips_only_small %>% 
  distinct(dest_geoXmicrotype_ATB) 
```

    # A tibble: 37 × 1
       dest_geoXmicrotype_ATB
       <chr>                 
     1 E_4                   
     2 C_3                   
     3 E_5                   
     4 A_4                   
     5 A_5                   
     6 B_4                   
     7 B_1                   
     8 B_2                   
     9 B_5                   
    10 F_5                   
    # ℹ 27 more rows

``` r
df_trips_only_small %>% 
  distinct(hh_geoXmicrotype_ATB) 
```

    # A tibble: 37 × 1
       hh_geoXmicrotype_ATB
       <chr>               
     1 E_4                 
     2 A_5                 
     3 B_1                 
     4 B_5                 
     5 F_5                 
     6 B_2                 
     7 C_6                 
     8 B_4                 
     9 A_1                 
    10 C_5                 
    # ℹ 27 more rows

``` r
df_trips_only_small %>% 
  distinct(start_time_bin_ATB) 
```

    # A tibble: 3 × 1
      start_time_bin_ATB
      <chr>             
    1 other_time        
    2 evening_rush      
    3 morning_rush      

``` r
df_trips_only_small %>% 
  distinct(trip_purpose_ATB) 
```

    # A tibble: 9 × 1
      trip_purpose_ATB
      <chr>           
    1 school          
    2 home            
    3 work            
    4 social          
    5 medical         
    6 other           
    7 shopping        
    8 meals           
    9 transp_someone  

#### how many combinatorials

distinct mode X trip purpose

``` r
summary <- df_trips_only_small |>
  group_by(mode_ATB,trip_purpose_ATB) %>% 
  summarise("Number Obs" = n(),
            across(contains("_ATB"),~n_distinct(.x),.names = "{.col} distinct"),
    .groups = "drop")
summary
```

    # A tibble: 63 × 31
       mode_ATB trip_purpose_ATB `Number Obs` `trip_purpose_small_ATB distinct`
       <chr>    <chr>                   <int>                             <int>
     1 bike     home                     3420                                 1
     2 bike     meals                     349                                 1
     3 bike     medical                    39                                 1
     4 bike     other                     199                                 1
     5 bike     school                    395                                 1
     6 bike     shopping                  851                                 1
     7 bike     social                   1754                                 1
     8 bike     transp_someone            122                                 1
     9 bike     work                      905                                 1
    10 bus      home                     7493                                 1
    # ℹ 53 more rows
    # ℹ 27 more variables: `start_time_bin_ATB distinct` <int>,
    #   `orig_fips11_ATB distinct` <int>, `dest_fips11_ATB distinct` <int>,
    #   `hh_fips11_ATB distinct` <int>,
    #   `origin_microtypeXgeotype_ATB distinct` <int>,
    #   `origin_geotype_ATB distinct` <int>,
    #   `origin_microXgeo2types_ATB distinct` <int>, …

``` r
summary %>% sjmisc::rotate_df(rn="N distinct")
```

                                  N distinct     V1     V2      V3     V4     V5
    1                               mode_ATB   bike   bike    bike   bike   bike
    2                       trip_purpose_ATB   home  meals medical  other school
    3                             Number Obs   3420    349      39    199    395
    4        trip_purpose_small_ATB distinct      1      1       1      1      1
    5            start_time_bin_ATB distinct      3      3       2      3      3
    6               orig_fips11_ATB distinct   2307    268      38    177    306
    7               dest_fips11_ATB distinct   2222    264      38    174    292
    8                 hh_fips11_ATB distinct   2199    257      38    159    297
    9  origin_microtypeXgeotype_ATB distinct     34     26      16     28     27
    10           origin_geotype_ATB distinct      6      6       5      6      6
    11   origin_microXgeo2types_ATB distinct     12     12      10     12     12
    12         origin_microtype_ATB distinct      6      6       6      6      6
    13     origin_geoXmicrotype_ATB distinct     34     26      16     28     27
    14         origin_geo2types_ATB distinct      2      2       2      2      2
    15   dest_microtypeXgeotype_ATB distinct     35     23      18     29     27
    16             dest_geotype_ATB distinct      7      6       5      6      6
    17     dest_microXgeo2types_ATB distinct     13     12      10     12     12
    18           dest_microtype_ATB distinct      7      6       6      6      6
    19       dest_geoXmicrotype_ATB distinct     35     23      18     29     27
    20           dest_geo2types_ATB distinct      3      2       2      2      2
    21     hh_microtypeXgeotype_ATB distinct     35     25      16     28     26
    22               hh_geotype_ATB distinct      7      6       5      6      6
    23       hh_microXgeo2types_ATB distinct     13     12      11     12     12
    24             hh_microtype_ATB distinct      7      6       6      6      6
    25         hh_geoXmicrotype_ATB distinct     35     25      16     28     26
    26             hh_geo2types_ATB distinct      3      2       2      2      2
    27                vehicleYN_ATB distinct      2      2       2      2      2
    28                 isSenior_ATB distinct      2      2       2      2      2
    29                  incHiLo_ATB distinct      3      3       2      3      3
    30               user_class_ATB distinct     11      9       7      8      8
    31       distance_bin_class_ATB distinct      9      8       4      8      6
             V6     V7             V8     V9    V10    V11     V12    V13    V14
    1      bike   bike           bike   bike    bus    bus     bus    bus    bus
    2  shopping social transp_someone   work   home  meals medical  other school
    3       851   1754            122    905   7493    375     515   1107   5942
    4         1      1              1      1      1      1       1      1      1
    5         3      3              3      3      3      3       3      3      3
    6       638   1281             79    717   4592    306     467    871   3579
    7       640   1271             78    602   4606    298     437    818   3589
    8       549   1176             76    647   4550    295     440    816   3392
    9        33     34             17     30     35     28      28     35     36
    10        7      6              5      6      6      6       6      7      7
    11       13     12             11     12     12     12      12     13     13
    12        7      6              6      6      6      6       6      7      7
    13       33     34             17     30     35     28      28     35     36
    14        3      2              2      2      2      2       2      3      3
    15       31     34             18     32     36     25      27     32     35
    16        6      6              5      6      6      6       6      6      7
    17       12     12             12     12     12     12      12     12     13
    18        6      6              6      6      6      6       6      6      7
    19       31     34             18     32     36     25      27     32     35
    20        2      2              2      2      2      2       2      2      3
    21       32     33             17     30     36     24      28     31     36
    22        7      6              5      6      6      5       6      6      7
    23       13     12             11     12     12     12      12     12     13
    24        7      6              6      6      6      6       6      6      7
    25       32     33             17     30     36     24      28     31     36
    26        3      2              2      2      2      2       2      2      3
    27        2      2              2      2      2      2       2      2      2
    28        2      2              2      2      2      2       2      2      2
    29        3      3              3      3      3      3       3      3      3
    30       11     11              6     11     12     12      12     11     12
    31        7      8              4      8      9      9       8      9      9
            V15    V16            V17    V18    V19    V20     V21    V22    V23
    1       bus    bus            bus    bus     hv     hv      hv     hv     hv
    2  shopping social transp_someone   work   home  meals medical  other school
    3      1356   1236            524   1706 269360  64586   15628  14926  33661
    4         1      1              1      1      1      1       1      1      1
    5         3      3              3      3      3      3       3      3      3
    6      1102    946            378   1407  38311  20547    8717   8826  13731
    7      1061    922            348   1118  33119  17112    6311   8015  12981
    8       947    875            295   1304  31666  18149    8102   7503  12500
    9        29     34             32     34     37     37      36     37     37
    10        6      6              7      6      7      7       7      7      7
    11       12     12             13     12     13     13      13     13     13
    12        6      6              7      6      7      7       7      7      7
    13       29     34             32     34     37     37      36     37     37
    14        2      2              3      2      3      3       3      3      3
    15       30     35             31     31     37     37      37     37     37
    16        6      7              7      7      7      7       7      7      7
    17       12     13             13     13     13     13      13     13     13
    18        6      7              7      7      7      7       7      7      7
    19       30     35             31     31     37     37      37     37     37
    20        2      3              3      3      3      3       3      3      3
    21       30     29             28     32     37     37      36     37     36
    22        6      6              6      6      7      7       7      7      7
    23       12     12             12     12     13     13      13     13     13
    24        6      6              6      6      7      7       7      7      7
    25       30     29             28     32     37     37      36     37     36
    26        2      2              2      2      3      3       3      3      3
    27        2      2              2      2      2      2       2      2      2
    28        2      2              2      2      2      2       2      2      2
    29        3      3              3      3      3      3       3      3      3
    30       12     12             11     11     12     12      12     12     12
    31        9      9              9      9      9      9       8      8      9
            V24    V25            V26    V27    V28    V29     V30    V31    V32
    1        hv     hv             hv     hv  other  other   other  other  other
    2  shopping social transp_someone   work   home  meals medical  other school
    3    171701  78462          53961  97786   1313    230      85   1605    130
    4         1      1              1      1      1      1       1      1      1
    5         3      3              3      3      3      3       3      3      3
    6     32236  23443          18215  26825    974    191      82    403    108
    7     27855  22980          16136  24427    932    194      76    377    109
    8     25575  19732          13815  22037    922    189      78    968    107
    9        37     37             37     37     35     27      23     32     24
    10        7      7              7      7      7      6       6      7      6
    11       13     13             13     13     13     12      11     13     12
    12        7      7              7      7      7      6       6      7      6
    13       37     37             37     37     35     27      23     32     24
    14        3      3              3      3      3      2       2      3      2
    15       37     37             37     37     34     32      22     32     25
    16        7      7              7      7      7      6       6      7      7
    17       13     13             13     13     13     12      11     13     13
    18        7      7              7      7      7      6       6      7      7
    19       37     37             37     37     34     32      22     32     25
    20        3      3              3      3      3      2       2      3      3
    21       37     37             36     37     33     28      23     32     20
    22        7      7              7      7      6      6       6      6      6
    23       13     13             13     13     12     12      11     12     10
    24        7      7              7      7      6      6       6      6      6
    25       37     37             36     37     33     28      23     32     20
    26        3      3              3      3      2      2       2      2      2
    27        2      2              2      2      2      2       2      2      2
    28        2      2              2      2      2      2       2      2      2
    29        3      3              3      3      3      3       3      3      3
    30       12     12             12     11     12     11       8     11      7
    31        9      9              9      9      9      9       8      9      9
            V33    V34            V35    V36    V37    V38     V39    V40    V41
    1     other  other          other  other   rail   rail    rail   rail   rail
    2  shopping social transp_someone   work   home  meals medical  other school
    3       448    875            125   1827   1563    233      54    189    164
    4         1      1              1      1      1      1       1      1      1
    5         3      3              3      3      3      3       2      3      3
    6       384    548            103   1178    681    176      52    146    141
    7       384    555            103   1149   1156    173      49    140    130
    8       322    553             92    750   1154    189      53    153    134
    9        32     33             27     34     23     13       7     16     14
    10        6      7              7      7      5      4       3      5      4
    11       12     13             13     13     12      9       7     11     10
    12        6      7              7      7      6      6       5      6      6
    13       32     33             27     34     23     13       7     16     14
    14        2      3              3      3      2      2       2      2      2
    15       31     34             27     33     21     16       9     15     13
    16        6      7              6      7      5      4       4      5      4
    17       12     13             12     13     11     10       7      9      9
    18        6      7              6      7      6      5       5      6      5
    19       31     34             27     33     21     16       9     15     13
    20        2      3              2      3      2      2       2      2      2
    21       28     30             24     32     24     19      10     18     15
    22        6      6              6      6      5      5       4      4      4
    23       12     12             12     12     12     10       8      9      9
    24        6      6              6      6      6      6       5      5      5
    25       28     30             24     32     24     19      10     18     15
    26        2      2              2      2      2      2       2      2      2
    27        2      2              2      2      2      2       2      2      2
    28        2      2              2      2      2      2       2      2      2
    29        3      3              3      3      3      3       3      3      3
    30       12     10              8      9     12      9       9     11      9
    31        9      9              9      9      9      8       7      8      8
            V42    V43            V44    V45    V46    V47     V48    V49    V50
    1      rail   rail           rail   rail   taxi   taxi    taxi   taxi   taxi
    2  shopping social transp_someone   work   home  meals medical  other school
    3       315    479             93   1384   1033    228     122    275     75
    4         1      1              1      1      1      1       1      1      1
    5         2      3              3      3      3      3       3      3      3
    6       249    341             70   1089    701    168     100    190     56
    7       245    311             81    540    749    159      97    102     57
    8       266    343             79   1072    761    165      96    196     53
    9        15     19             11     22     29     23      21     21     17
    10        5      5              4      4      6      5       5      5      5
    11       11     10              9     12     12     11      11     11      9
    12        6      6              7      6      6      6       6      6      5
    13       15     19             11     22     29     23      21     21     17
    14        2      2              3      2      2      2       2      2      2
    15       19     20             11     19     28     20      22     21     17
    16        5      5              4      4      6      5       5      6      5
    17       12      9              7     11     12     11      12     12     10
    18        6      6              5      6      6      6       6      7      5
    19       19     20             11     19     28     20      22     21     17
    20        2      2              2      2      2      2       2      3      2
    21       19     25             11     22     29     24      21     22     17
    22        4      6              4      5      6      6       5      5      5
    23       10     12              7     12     12     12      11     12     11
    24        6      6              5      6      6      6       6      6      6
    25       19     25             11     22     29     24      21     22     17
    26        2      2              2      2      2      2       2      2      2
    27        2      2              2      2      2      2       2      2      2
    28        2      2              2      2      2      2       2      2      2
    29        3      3              3      3      3      3       3      3      3
    30       12     10              8     12     11      9       9      8      9
    31        9      9              9      9      8      8       9      8      9
            V51    V52            V53    V54    V55    V56     V57    V58    V59
    1      taxi   taxi           taxi   taxi   walk   walk    walk   walk   walk
    2  shopping social transp_someone   work   home  meals medical  other school
    3       200    453             42    385  34595   6326     341   2609   3030
    4         1      1              1      1      1      1       1      1      1
    5         3      3              2      3      3      3       3      3      3
    6       163    320             36    314  13656   3119     285   1720   1864
    7       162    314             34    297  13146   3022     281   1730   1831
    8       143    300             25    297  12907   3757     292   1828   1856
    9        21     28             14     24     37     36      27     35     34
    10        5      7              5      6      7      6       6      6      6
    11       12     13              9     11     13     12      12     12     12
    12        6      7              6      6      7      6       6      6      6
    13       21     28             14     24     37     36      27     35     34
    14        2      3              2      2      3      2       2      2      2
    15       20     24             15     26     37     36      27     35     33
    16        5      6              5      6      7      6       6      7      6
    17       12     11             10     12     13     12      12     13     12
    18        6      6              6      6      7      6       6      7      6
    19       20     24             15     26     37     36      27     35     33
    20        2      2              2      2      3      2       2      3      2
    21       20     25             11     23     37     35      27     34     33
    22        5      6              4      6      7      6       6      6      6
    23       11     12              7     11     13     12      12     12     12
    24        6      6              5      6      7      6       6      6      6
    25       20     25             11     23     37     35      27     34     33
    26        2      2              2      2      3      2       2      2      2
    27        2      2              2      2      2      2       2      2      2
    28        2      2              2      2      2      2       2      2      2
    29        3      3              3      3      3      3       3      3      3
    30       11     10              6     10     12     12      11     11     11
    31        7      9              6      8      9      9       4      8      8
            V60    V61            V62    V63
    1      walk   walk           walk   walk
    2  shopping social transp_someone   work
    3      9255  17025           1510   6597
    4         1      1              1      1
    5         3      3              3      3
    6      4979   8071            989   3112
    7      4833   8047            973   2970
    8      4937   7810            960   3851
    9        35     37             29     35
    10        6      7              6      6
    11       12     13             12     12
    12        6      7              6      6
    13       35     37             29     35
    14        2      3              2      2
    15       36     37             28     36
    16        6      7              6      6
    17       12     13             12     12
    18        6      7              6      6
    19       36     37             28     36
    20        2      3              2      2
    21       36     36             28     33
    22        7      6              6      6
    23       13     12             12     12
    24        7      6              6      6
    25       36     36             28     33
    26        3      2              2      2
    27        2      2              2      2
    28        2      2              2      2
    29        3      3              3      3
    30       12     12             11     11
    31        8      9              6      8

##### distinct origin destination

``` r
df_trips_only_small %>% 
  count(origin_geoXmicrotype_ATB,dest_geoXmicrotype_ATB) %>% 
  pivot_wider(names_from = dest_geoXmicrotype_ATB,values_from = n)
```

    # A tibble: 37 × 38
       origin_geoXmicrotype_…¹   A_1   A_2   A_3   A_4   A_5   A_6   B_1   B_2   B_3
       <chr>                   <int> <int> <int> <int> <int> <int> <int> <int> <int>
     1 A_1                     23776  6717  5960   827  1367   147    33    89    80
     2 A_2                      6786 43551 16508  3862  9385   237    51   138   155
     3 A_3                      5854 16606 26128  3125  7765   202    46   159   244
     4 A_4                       842  3853  3154  7346  3177    91    15    25    96
     5 A_5                      1415  9397  7695  3202 21109   361    40   122   117
     6 A_6                       152   221   184    91   371   645     5    18    28
     7 B_1                        36    61    38    15    24     5 11327  7891  4330
     8 B_2                        81   125   185    30   130    14  7841 48307 14409
     9 B_3                        97   121   249    95   151    25  4301 14517 23096
    10 B_4                        36    79   135   117    63     9  1038  3817  3351
    # ℹ 27 more rows
    # ℹ abbreviated name: ¹​origin_geoXmicrotype_ATB
    # ℹ 28 more variables: B_4 <int>, B_5 <int>, B_6 <int>, C_1 <int>, C_2 <int>,
    #   C_3 <int>, C_4 <int>, C_5 <int>, C_6 <int>, D_5 <int>, D_6 <int>,
    #   E_2 <int>, E_6 <int>, F_1 <int>, F_2 <int>, F_3 <int>, F_4 <int>,
    #   F_5 <int>, F_6 <int>, `NA` <int>, D_2 <int>, D_3 <int>, D_4 <int>,
    #   E_4 <int>, E_5 <int>, D_1 <int>, E_3 <int>, E_1 <int>

###### 12/7 do only micro types not geo types

``` r
ggplot() +
  geom_count(data=df_trips_only_small,
             mapping=aes(x = origin_microtypeXgeotype_ATB, y = dest_microtypeXgeotype_ATB)) +
  scale_size_area(max_size = 10)
```

![](20_mode-choice-cleaned-stats_files/figure-commonmark/unnamed-chunk-32-1.png)

``` r
ggplot() +
  geom_count(data=df_trips_only_small,
             mapping=aes(x = origin_geoXmicrotype_ATB, y = dest_geoXmicrotype_ATB)) +
  scale_size_area(max_size = 10)
```

![](20_mode-choice-cleaned-stats_files/figure-commonmark/unnamed-chunk-33-1.png)

``` r
df_trips_only_small %>% 
  count(origin_microtypeXgeotype_ATB,dest_microtypeXgeotype_ATB) 
```

    # A tibble: 1,094 × 3
       origin_microtypeXgeotype_ATB dest_microtypeXgeotype_ATB     n
       <chr>                        <chr>                      <int>
     1 1_A                          1_A                        23776
     2 1_A                          1_B                           33
     3 1_A                          1_C                            1
     4 1_A                          1_F                            5
     5 1_A                          2_A                         6717
     6 1_A                          2_B                           89
     7 1_A                          2_C                           30
     8 1_A                          2_E                            7
     9 1_A                          2_F                           34
    10 1_A                          3_A                         5960
    # ℹ 1,084 more rows

``` r
df_trips_only_small %>% 
  count(origin_geoXmicrotype_ATB,dest_geoXmicrotype_ATB) %>% 
  filter(n<100) %>% 
  ggplot( aes(x = n)) +
  geom_histogram(binwidth = 5)
```

![](20_mode-choice-cleaned-stats_files/figure-commonmark/unnamed-chunk-34-1.png)

``` r
temp_count <- df_trips_only_small %>% 
  count(origin_geoXmicrotype_ATB,dest_geoXmicrotype_ATB)

ggplot() +
  geom_tile(data=temp_count,
            mapping=aes(x = origin_geoXmicrotype_ATB, 
                        y = dest_geoXmicrotype_ATB,
                        fill = log(n)))
```

![](20_mode-choice-cleaned-stats_files/figure-commonmark/unnamed-chunk-35-1.png)

``` r
ggplot() +
  geom_tile(data=temp_count,
            mapping=aes(x = origin_geoXmicrotype_ATB, 
                        y = dest_geoXmicrotype_ATB,
                        fill = log(n))) +
  geom_point(data=temp_count %>% filter(n<8),
            mapping=aes(x = origin_geoXmicrotype_ATB, 
                        y = dest_geoXmicrotype_ATB,
                        size = -n),
            color = "red",
            alpha = .5) 
```

![](20_mode-choice-cleaned-stats_files/figure-commonmark/unnamed-chunk-36-1.png)

``` r
ggplot(df_trips_only_small, 
       aes(x = origin_geoXmicrotype_ATB, 
           y = dest_geoXmicrotype_ATB,
           color = start_time_bin_ATB,
           shape = trip_purpose_ATB)) +
  geom_count()
```

![](20_mode-choice-cleaned-stats_files/figure-commonmark/unnamed-chunk-37-1.png)

``` r
summary <- df_trips_only_small |>
  group_by(origin_geoXmicrotype_ATB) %>% 
  summarise("Number Obs" = n(),
            across(contains("_ATB"),~n_distinct(.x),.names = "{.col} distinct"),
    .groups = "drop")
36*36
```

    [1] 1296

``` r
summary
```

    # A tibble: 37 × 31
       origin_geoXmicrotype_ATB `Number Obs` `mode_ATB distinct`
       <chr>                           <int>               <int>
     1 A_1                             39466                   7
     2 A_2                             81593                   7
     3 A_3                             61463                   7
     4 A_4                             19131                   7
     5 A_5                             44675                   7
     6 A_6                              1961                   7
     7 B_1                             28130                   7
     8 B_2                             89951                   7
     9 B_3                             56005                   7
    10 B_4                             25133                   7
    # ℹ 27 more rows
    # ℹ 28 more variables: `trip_purpose_ATB distinct` <int>,
    #   `trip_purpose_small_ATB distinct` <int>,
    #   `start_time_bin_ATB distinct` <int>, `orig_fips11_ATB distinct` <int>,
    #   `dest_fips11_ATB distinct` <int>, `hh_fips11_ATB distinct` <int>,
    #   `origin_microtypeXgeotype_ATB distinct` <int>,
    #   `origin_geotype_ATB distinct` <int>, …

``` r
summary %>% sjmisc::rotate_df(rn="N distinct")
```

                                  N distinct     V1     V2     V3     V4     V5
    1               origin_geoXmicrotype_ATB    A_1    A_2    A_3    A_4    A_5
    2                             Number Obs  39466  81593  61463  19131  44675
    3                      mode_ATB distinct      7      7      7      7      7
    4              trip_purpose_ATB distinct      9      9      9      9      9
    5        trip_purpose_small_ATB distinct      3      3      3      3      3
    6            start_time_bin_ATB distinct      3      3      3      3      3
    7               orig_fips11_ATB distinct   4297   5353   3467   1508   2338
    8               dest_fips11_ATB distinct   8937  11652  10989   5284   7537
    9                 hh_fips11_ATB distinct   6755   8567   8689   3518   5308
    10 origin_microtypeXgeotype_ATB distinct      1      1      1      1      1
    11           origin_geotype_ATB distinct      1      1      1      1      1
    12   origin_microXgeo2types_ATB distinct      1      1      1      1      1
    13         origin_microtype_ATB distinct      1      1      1      1      1
    14         origin_geo2types_ATB distinct      1      1      1      1      1
    15   dest_microtypeXgeotype_ATB distinct     29     33     32     25     32
    16             dest_geotype_ATB distinct      7      7      7      6      7
    17     dest_microXgeo2types_ATB distinct     13     13     13     12     13
    18           dest_microtype_ATB distinct      7      7      7      7      7
    19       dest_geoXmicrotype_ATB distinct     29     33     32     25     32
    20           dest_geo2types_ATB distinct      3      3      3      3      3
    21     hh_microtypeXgeotype_ATB distinct     34     35     34     29     32
    22               hh_geotype_ATB distinct      7      7      6      6      6
    23       hh_microXgeo2types_ATB distinct     13     13     12     12     12
    24             hh_microtype_ATB distinct      7      7      6      6      6
    25         hh_geoXmicrotype_ATB distinct     34     35     34     29     32
    26             hh_geo2types_ATB distinct      3      3      2      2      2
    27                vehicleYN_ATB distinct      2      2      2      2      2
    28                 isSenior_ATB distinct      2      2      2      2      2
    29                  incHiLo_ATB distinct      3      3      3      3      3
    30               user_class_ATB distinct     12     12     12     12     12
    31       distance_bin_class_ATB distinct      9      9      9      9      9
           V6     V7     V8     V9    V10    V11    V12    V13    V14    V15    V16
    1     A_6    B_1    B_2    B_3    B_4    B_5    B_6    C_1    C_2    C_3    C_4
    2    1961  28130  89951  56005  25133  53836  17087   5311  72027  52328  20920
    3       7      7      7      7      7      7      7      7      7      7      7
    4       9      9      9      9      9      9      9      9      9      9      9
    5       3      3      3      3      3      3      3      3      3      3      3
    6       3      3      3      3      3      3      3      3      3      3      3
    7     149   1793   5243   3454   1321   3048   1258    120   2607   2118   1029
    8     808   6326  12083  10906   4780   9097   4341   1565   7797   7721   4314
    9     604   5208   8876   8386   3523   6343   2938   1497   6352   5989   3241
    10      1      1      1      1      1      1      1      1      1      1      1
    11      1      1      1      1      1      1      1      1      1      1      1
    12      1      1      1      1      1      1      1      1      1      1      1
    13      1      1      1      1      1      1      1      1      1      1      1
    14      1      1      1      1      1      1      1      1      1      1      1
    15     27     34     35     34     33     35     32     25     35     35     36
    16      7      7      7      7      7      7      7      6      7      7      7
    17     13     13     13     13     13     13     13     12     13     13     13
    18      7      7      7      7      7      7      7      6      7      7      7
    19     27     34     35     34     33     35     32     25     35     35     36
    20      3      3      3      3      3      3      3      2      3      3      3
    21     26     34     35     35     31     34     33     28     34     34     34
    22      6      7      7      7      7      7      7      6      6      6      6
    23     12     13     13     13     13     13     13     12     12     12     12
    24      6      7      7      7      7      7      7      6      6      6      6
    25     26     34     35     35     31     34     33     28     34     34     34
    26      2      3      3      3      3      3      3      2      2      2      2
    27      2      2      2      2      2      2      2      2      2      2      2
    28      2      2      2      2      2      2      2      2      2      2      2
    29      3      3      3      3      3      3      3      3      3      3      3
    30      9     12     12     12     12     12     11     10     12     12     11
    31      9      9      9      9      9      9      9      8      9      9      9
          V17    V18    V19    V20    V21    V22    V23    V24    V25    V26    V27
    1     C_5    C_6    D_1    D_2    D_3    D_4    D_5    D_6    E_1    E_2    E_3
    2  132725  33068     98   2880   1689   1411  11809   5514    122   2544   2012
    3       7      7      4      6      6      7      7      5      3      7      7
    4       9      9      9      9      9      9      9      9      8      9      9
    5       3      3      3      3      3      3      3      3      3      3      3
    6       3      3      3      3      3      3      3      3      3      3      3
    7    5453   2293     16    353    220    155    778    571     18    206    142
    8   12619   6501     56    731    587    427   1887   1375     57    472    487
    9    9305   4416     44    512    439    311   1318   1016     41    356    348
    10      1      1      1      1      1      1      1      1      1      1      1
    11      1      1      1      1      1      1      1      1      1      1      1
    12      1      1      1      1      1      1      1      1      1      1      1
    13      1      1      1      1      1      1      1      1      1      1      1
    14      1      1      1      1      1      1      1      1      1      1      1
    15     36     37     10     33     30     27     35     31      9     26     24
    16      7      7      3      7      6      6      6      6      3      6      6
    17     13     13      9     13     12     12     12     12      7     12     12
    18      7      7      6      7      6      6      6      6      6      6      6
    19     36     37     10     33     30     27     35     31      9     26     24
    20      3      3      2      3      2      2      2      2      2      2      2
    21     35     33      9     32     26     28     32     30     12     26     26
    22      6      6      4      6      6      6      6      6      4      6      6
    23     12     12      7     12     12     12     12     12      8     12     12
    24      6      6      5      6      6      6      6      6      6      6      6
    25     35     33      9     32     26     28     32     30     12     26     26
    26      2      2      2      2      2      2      2      2      2      2      2
    27      2      2      2      2      2      2      2      2      2      2      2
    28      2      2      2      2      2      2      2      2      2      2      2
    29      3      3      2      3      3      3      3      3      2      3      3
    30     12     12      5      9      8      8      9     10      5     11      9
    31      9      9      8      9      8      9      8      9      8      9      9
          V28    V29    V30    V31    V32    V33    V34    V35    V36    V37
    1     E_4    E_5    E_6    F_1    F_2    F_3    F_4    F_5    F_6   <NA>
    2     905   5660   2001   1915  11479  11639   4753  20263   1825    243
    3       6      7      6      7      7      7      7      7      6      7
    4       9      9      9      9      9      9      9      9      9      9
    5       3      3      3      3      3      3      3      3      3      3
    6       3      3      3      3      3      3      3      3      3      3
    7      81    275    178     47    702    530    242   1240    155      7
    8     245    756    501    358   1947   2245   1108   2863    481    115
    9     216    508    338    337   1540   1889    922   2264    345    128
    10      1      1      1      1      1      1      1      1      1      1
    11      1      1      1      1      1      1      1      1      1      1
    12      1      1      1      1      1      1      1      1      1      1
    13      1      1      1      1      1      1      1      1      1      1
    14      1      1      1      1      1      1      1      1      1      1
    15     23     31     32     26     29     34     29     32     29     19
    16      6      6      6      6      6      7      7      6      6      6
    17     11     12     12     12     12     13     13     12     11     12
    18      6      6      6      6      6      7      7      6      6      7
    19     23     31     32     26     29     34     29     32     29     19
    20      2      2      2      2      2      3      3      2      2      3
    21     23     30     28     24     30     30     28     32     28     23
    22      6      6      6      6      6      6      6      6      6      7
    23     10     12     11     11     12     12     11     12     12     12
    24      5      6      6      6      6      6      6      6      6      7
    25     23     30     28     24     30     30     28     32     28     23
    26      2      2      2      2      2      2      2      2      2      3
    27      2      2      2      2      2      2      2      2      1      1
    28      2      2      2      2      2      2      2      2      2      2
    29      3      3      3      3      3      3      3      3      3      3
    30      9     10      8     12     12     11     12     12      6      5
    31      9      9      9      9      9      9      9      9      9      8

``` r
summary <- df_trips_only_small |>
  group_by(origin_geoXmicrotype_ATB,dest_geoXmicrotype_ATB) %>% 
  summarise("Number Obs" = n(),
            across(contains("_ATB"),~n_distinct(.x),.names = "{.col} distinct"),
    .groups = "drop")
36*36
```

    [1] 1296

``` r
summary
```

    # A tibble: 1,094 × 31
       origin_geoXmicrotype_ATB dest_geoXmicrotype_ATB `Number Obs`
       <chr>                    <chr>                         <int>
     1 A_1                      A_1                           23776
     2 A_1                      A_2                            6717
     3 A_1                      A_3                            5960
     4 A_1                      A_4                             827
     5 A_1                      A_5                            1367
     6 A_1                      A_6                             147
     7 A_1                      B_1                              33
     8 A_1                      B_2                              89
     9 A_1                      B_3                              80
    10 A_1                      B_4                              38
    # ℹ 1,084 more rows
    # ℹ 28 more variables: `mode_ATB distinct` <int>,
    #   `trip_purpose_ATB distinct` <int>, `trip_purpose_small_ATB distinct` <int>,
    #   `start_time_bin_ATB distinct` <int>, `orig_fips11_ATB distinct` <int>,
    #   `dest_fips11_ATB distinct` <int>, `hh_fips11_ATB distinct` <int>,
    #   `origin_microtypeXgeotype_ATB distinct` <int>,
    #   `origin_geotype_ATB distinct` <int>, …

``` r
summary %>% sjmisc::rotate_df(rn="N distinct")
```

                                  N distinct    V1    V2    V3    V4    V5    V6
    1               origin_geoXmicrotype_ATB   A_1   A_1   A_1   A_1   A_1   A_1
    2                 dest_geoXmicrotype_ATB   A_1   A_2   A_3   A_4   A_5   A_6
    3                             Number Obs 23776  6717  5960   827  1367   147
    4                      mode_ATB distinct     7     7     7     7     7     6
    5              trip_purpose_ATB distinct     9     9     9     9     9     9
    6        trip_purpose_small_ATB distinct     3     3     3     3     3     3
    7            start_time_bin_ATB distinct     3     3     3     3     3     3
    8               orig_fips11_ATB distinct  3636  1854  1929   434   557    80
    9               dest_fips11_ATB distinct  3632  2234  1647   357   616    18
    10                hh_fips11_ATB distinct  3756  3055  2853   514   848   104
    11 origin_microtypeXgeotype_ATB distinct     1     1     1     1     1     1
    12           origin_geotype_ATB distinct     1     1     1     1     1     1
    13   origin_microXgeo2types_ATB distinct     1     1     1     1     1     1
    14         origin_microtype_ATB distinct     1     1     1     1     1     1
    15         origin_geo2types_ATB distinct     1     1     1     1     1     1
    16   dest_microtypeXgeotype_ATB distinct     1     1     1     1     1     1
    17             dest_geotype_ATB distinct     1     1     1     1     1     1
    18     dest_microXgeo2types_ATB distinct     1     1     1     1     1     1
    19           dest_microtype_ATB distinct     1     1     1     1     1     1
    20           dest_geo2types_ATB distinct     1     1     1     1     1     1
    21     hh_microtypeXgeotype_ATB distinct    30    27    30    19    19    18
    22               hh_geotype_ATB distinct     6     7     6     5     5     4
    23       hh_microXgeo2types_ATB distinct    12    12    12    11    11    10
    24             hh_microtype_ATB distinct     6     7     6     6     6     6
    25         hh_geoXmicrotype_ATB distinct    30    27    30    19    19    18
    26             hh_geo2types_ATB distinct     2     3     2     2     2     2
    27                vehicleYN_ATB distinct     2     2     2     2     2     2
    28                 isSenior_ATB distinct     2     2     2     2     2     2
    29                  incHiLo_ATB distinct     3     3     3     3     3     3
    30               user_class_ATB distinct    12    12    12    10    11     8
    31       distance_bin_class_ATB distinct     9     8     8     8     8     8
          V7    V8    V9   V10   V11   V12   V13   V14   V15   V16   V17   V18
    1    A_1   A_1   A_1   A_1   A_1   A_1   A_1   A_1   A_1   A_1   A_1   A_1
    2    B_1   B_2   B_3   B_4   B_5   B_6   C_1   C_2   C_3   C_4   C_5   C_6
    3     33    89    80    38    93    23     1    30    26    11    79    10
    4      4     5     4     4     5     2     1     3     4     2     4     4
    5      8     9     8     7     7     5     1     6     5     5     8     3
    6      3     3     3     3     3     2     1     3     3     2     3     3
    7      3     3     3     3     3     2     1     2     2     1     3     3
    8     25    60    53    30    60    14     1    18    21     9    54    10
    9     23    60    52    30    56    13     1    19    18     8    56    10
    10    26    64    61    30    58    14     1    19    19     9    57    10
    11     1     1     1     1     1     1     1     1     1     1     1     1
    12     1     1     1     1     1     1     1     1     1     1     1     1
    13     1     1     1     1     1     1     1     1     1     1     1     1
    14     1     1     1     1     1     1     1     1     1     1     1     1
    15     1     1     1     1     1     1     1     1     1     1     1     1
    16     1     1     1     1     1     1     1     1     1     1     1     1
    17     1     1     1     1     1     1     1     1     1     1     1     1
    18     1     1     1     1     1     1     1     1     1     1     1     1
    19     1     1     1     1     1     1     1     1     1     1     1     1
    20     1     1     1     1     1     1     1     1     1     1     1     1
    21     8     9    12     9    10     6     1     5     9     5    12     4
    22     3     2     5     3     3     3     1     3     3     2     5     3
    23     6     5     9     7     8     5     1     5     7     5     9     4
    24     6     5     6     5     6     5     1     4     6     4     6     3
    25     8     9    12     9    10     6     1     5     9     5    12     4
    26     2     1     2     2     2     2     1     2     2     2     2     2
    27     1     2     2     1     2     1     1     1     2     1     1     1
    28     2     2     2     2     2     2     1     2     2     2     2     2
    29     2     3     3     2     3     2     1     2     2     2     3     2
    30     4     6     8     4     7     4     1     3     4     2     5     2
    31     4     6     4     5     4     2     1     2     3     3     5     3
         V19   V20   V21   V22   V23   V24   V25   V26   V27   V28   V29   V30
    1    A_1   A_1   A_1   A_1   A_1   A_1   A_1   A_1   A_1   A_1   A_1   A_2
    2    D_5   D_6   E_2   E_6   F_1   F_2   F_3   F_4   F_5   F_6  <NA>   A_1
    3      4     2     7     1     5    34    39     4    40     6    17  6786
    4      1     1     1     1     3     3     2     1     2     1     2     7
    5      3     2     4     1     4     5     8     1     6     1     4     9
    6      2     2     1     1     2     3     3     1     3     1     2     3
    7      1     1     1     1     2     3     3     1     2     1     2     3
    8      3     2     2     1     5    28    24     1    26     1     7  2256
    9      3     2     3     1     4    26    21     1    23     1     2  1828
    10     3     2     3     1     4    29    27     1    25     1     6  3032
    11     1     1     1     1     1     1     1     1     1     1     1     1
    12     1     1     1     1     1     1     1     1     1     1     1     1
    13     1     1     1     1     1     1     1     1     1     1     1     1
    14     1     1     1     1     1     1     1     1     1     1     1     1
    15     1     1     1     1     1     1     1     1     1     1     1     1
    16     1     1     1     1     1     1     1     1     1     1     1     1
    17     1     1     1     1     1     1     1     1     1     1     1     1
    18     1     1     1     1     1     1     1     1     1     1     1     1
    19     1     1     1     1     1     1     1     1     1     1     1     1
    20     1     1     1     1     1     1     1     1     1     1     1     1
    21     2     2     3     1     4     9    12     1     9     1     3    28
    22     1     1     2     1     3     5     4     1     4     1     2     7
    23     2     2     3     1     4     7     8     1     7     1     3    12
    24     2     2     3     1     3     5     5     1     4     1     3     7
    25     2     2     3     1     4     9    12     1     9     1     3    28
    26     1     1     2     1     2     2     2     1     2     1     2     3
    27     2     1     1     1     1     1     2     1     1     1     1     2
    28     1     2     1     1     2     2     2     1     2     1     2     2
    29     2     1     2     1     2     2     3     1     3     1     2     3
    30     2     2     2     1     3     4     7     1     5     1     4    12
    31     1     1     1     1     2     5     2     1     3     1     5     8
         V31   V32   V33   V34   V35   V36   V37   V38   V39   V40   V41   V42
    1    A_2   A_2   A_2   A_2   A_2   A_2   A_2   A_2   A_2   A_2   A_2   A_2
    2    A_2   A_3   A_4   A_5   A_6   B_1   B_2   B_3   B_4   B_5   B_6   C_1
    3  43551 16508  3862  9385   237    51   138   155    73   162    49     7
    4      7     7     7     7     5     3     5     4     2     2     4     1
    5      9     9     9     9     8     8     9     8     9     9     6     5
    6      3     3     3     3     3     3     3     3     3     3     3     2
    7      3     3     3     3     3     3     3     3     3     3     3     2
    8   4352  3267  1475  2201   145    33    87    97    46   106    34     5
    9   4371  2326   850  1471    57    32    82    89    41    81    29     5
    10  4957  4695  1587  2778   146    35    88   110    48    92    34     5
    11     1     1     1     1     1     1     1     1     1     1     1     1
    12     1     1     1     1     1     1     1     1     1     1     1     1
    13     1     1     1     1     1     1     1     1     1     1     1     1
    14     1     1     1     1     1     1     1     1     1     1     1     1
    15     1     1     1     1     1     1     1     1     1     1     1     1
    16     1     1     1     1     1     1     1     1     1     1     1     1
    17     1     1     1     1     1     1     1     1     1     1     1     1
    18     1     1     1     1     1     1     1     1     1     1     1     1
    19     1     1     1     1     1     1     1     1     1     1     1     1
    20     1     1     1     1     1     1     1     1     1     1     1     1
    21    31    32    27    26    14     9    12    13    10    11    11     3
    22     7     6     6     6     4     4     3     4     4     5     3     2
    23    13    12    12    11    10     7    10     7     7     8     9     3
    24     7     6     6     6     6     5     6     5     5     6     6     2
    25    31    32    27    26    14     9    12    13    10    11    11     3
    26     3     2     2     2     2     2     2     2     2     2     2     2
    27     2     2     2     2     2     2     2     1     2     1     1     1
    28     2     2     2     2     2     2     2     2     2     2     2     1
    29     3     3     3     3     3     2     3     3     3     2     2     1
    30    12    12    11    12     7     5     7     6     6     4     4     1
    31     9     8     8     8     8     6     7     5     6     5     2     2
         V43   V44   V45   V46   V47   V48   V49   V50   V51   V52   V53   V54
    1    A_2   A_2   A_2   A_2   A_2   A_2   A_2   A_2   A_2   A_2   A_2   A_2
    2    C_2   C_3   C_4   C_5   C_6   D_2   D_3   D_4   D_5   D_6   E_4   E_5
    3     46    54    31   158    80     2    11     5     9    22     1     1
    4      2     2     4     4     2     1     3     2     2     3     1     1
    5      6     7     7     8     8     1     4     2     5     6     1     1
    6      3     3     3     3     3     1     2     2     3     3     1     1
    7      3     3     3     3     3     1     2     2     2     2     1     1
    8     38    39    23    99    54     1     7     4     8    12     1     1
    9     35    36    23    95    51     1     4     4     8    12     1     1
    10    37    37    23   109    53     1     7     4     8    12     1     1
    11     1     1     1     1     1     1     1     1     1     1     1     1
    12     1     1     1     1     1     1     1     1     1     1     1     1
    13     1     1     1     1     1     1     1     1     1     1     1     1
    14     1     1     1     1     1     1     1     1     1     1     1     1
    15     1     1     1     1     1     1     1     1     1     1     1     1
    16     1     1     1     1     1     1     1     1     1     1     1     1
    17     1     1     1     1     1     1     1     1     1     1     1     1
    18     1     1     1     1     1     1     1     1     1     1     1     1
    19     1     1     1     1     1     1     1     1     1     1     1     1
    20     1     1     1     1     1     1     1     1     1     1     1     1
    21     5    12     7    12    10     1     4     4     5     6     1     1
    22     3     4     3     3     3     1     3     3     2     4     1     1
    23     4     8     6    10     7     1     4     4     5     5     1     1
    24     3     6     5     6     6     1     2     3     4     4     1     1
    25     5    12     7    12    10     1     4     4     5     6     1     1
    26     2     2     2     2     2     1     2     2     2     2     1     1
    27     1     2     1     2     1     1     1     1     1     1     1     1
    28     2     2     2     2     2     1     2     1     2     2     1     1
    29     3     2     3     3     2     1     2     2     2     3     1     1
    30     5     5     5     7     4     1     2     2     4     5     1     1
    31     4     5     3     7     2     1     1     1     1     1     1     1
         V55   V56   V57   V58   V59   V60   V61   V62   V63   V64   V65   V66
    1    A_2   A_2   A_2   A_2   A_2   A_2   A_2   A_2   A_3   A_3   A_3   A_3
    2    E_6   F_1   F_2   F_3   F_4   F_5   F_6  <NA>   A_1   A_2   A_3   A_4
    3      2     4    61    78     4    49     5     6  5854 16606 26128  3125
    4      1     1     2     3     1     1     1     2     7     7     7     7
    5      1     3     6     8     2     6     3     3     9     9     9     9
    6      1     2     3     3     2     3     2     2     3     3     3     3
    7      1     2     3     3     1     3     2     3     3     3     3     3
    8      2     4    36    50     3    31     3     4  1622  2309  2647  1051
    9      2     4    38    41     3    25     3     3  1934  3244  2635   789
    10     2     4    39    53     3    29     3     4  2785  4678  4235  1321
    11     1     1     1     1     1     1     1     1     1     1     1     1
    12     1     1     1     1     1     1     1     1     1     1     1     1
    13     1     1     1     1     1     1     1     1     1     1     1     1
    14     1     1     1     1     1     1     1     1     1     1     1     1
    15     1     1     1     1     1     1     1     1     1     1     1     1
    16     1     1     1     1     1     1     1     1     1     1     1     1
    17     1     1     1     1     1     1     1     1     1     1     1     1
    18     1     1     1     1     1     1     1     1     1     1     1     1
    19     1     1     1     1     1     1     1     1     1     1     1     1
    20     1     1     1     1     1     1     1     1     1     1     1     1
    21     2     4     7    13     2     6     2     1    31    32    31    26
    22     2     3     3     5     2     3     2     1     6     6     6     6
    23     1     4     6     8     2     5     2     1    12    12    12    12
    24     1     4     4     5     2     4     2     1     6     6     6     6
    25     2     4     7    13     2     6     2     1    31    32    31    26
    26     1     2     2     2     2     2     2     1     2     2     2     2
    27     1     1     1     1     1     1     1     1     2     2     2     2
    28     2     2     2     2     2     2     2     2     2     2     2     2
    29     1     2     2     3     2     2     2     2     3     3     3     3
    30     2     3     4     5     3     4     3     3    12    12    12    11
    31     2     2     6     5     2     5     1     4     8     8     9     8
         V67   V68   V69   V70   V71   V72   V73   V74   V75   V76   V77   V78
    1    A_3   A_3   A_3   A_3   A_3   A_3   A_3   A_3   A_3   A_3   A_3   A_3
    2    A_5   A_6   B_1   B_2   B_3   B_4   B_5   B_6   C_1   C_2   C_3   C_4
    3   7765   202    46   159   244   127   217    43    10    55   161    46
    4      7     7     4     5     4     3     5     2     1     3     4     3
    5      9     8     8     8     8     9     9     7     6     8     8     7
    6      3     3     3     3     3     3     3     3     2     3     3     3
    7      3     3     3     3     3     3     3     3     2     2     3     3
    8   1435   124    33    98   116    72   112    33     7    38    72    31
    9   1363    51    30   106   125    67   110    32     5    40    64    27
    10  2316   136    32   119   168    78   130    36     7    43    86    33
    11     1     1     1     1     1     1     1     1     1     1     1     1
    12     1     1     1     1     1     1     1     1     1     1     1     1
    13     1     1     1     1     1     1     1     1     1     1     1     1
    14     1     1     1     1     1     1     1     1     1     1     1     1
    15     1     1     1     1     1     1     1     1     1     1     1     1
    16     1     1     1     1     1     1     1     1     1     1     1     1
    17     1     1     1     1     1     1     1     1     1     1     1     1
    18     1     1     1     1     1     1     1     1     1     1     1     1
    19     1     1     1     1     1     1     1     1     1     1     1     1
    20     1     1     1     1     1     1     1     1     1     1     1     1
    21    24    14    11    17    23    13    19    12     4    11    12    13
    22     6     4     3     5     5     4     6     3     1     3     3     6
    23    12     9     8    10    11     9    11     9     4     9     9     7
    24     6     5     6     6     6     6     6     6     4     5     6     4
    25    24    14    11    17    23    13    19    12     4    11    12    13
    26     2     2     2     2     2     2     2     2     1     2     2     2
    27     2     2     1     2     2     2     2     2     1     1     2     1
    28     2     2     2     2     2     2     2     2     1     2     2     2
    29     3     3     2     3     3     3     2     3     1     2     3     3
    30     9     8     3     8     8     6     5     7     1     4     8     5
    31     8     8     3     6     6     6     7     3     2     5     6     6
         V79   V80   V81   V82   V83   V84   V85   V86   V87   V88   V89   V90
    1    A_3   A_3   A_3   A_3   A_3   A_3   A_3   A_3   A_3   A_3   A_3   A_3
    2    C_5   C_6   D_1   D_3   D_4   D_5   D_6   E_5   E_6   F_1   F_2   F_3
    3    233    78     1     8     4    11    12     4     3     1   107    80
    4      4     2     1     2     2     2     2     3     1     1     4     3
    5      8     7     1     4     2     4     5     3     2     1     7     7
    6      3     3     1     3     2     2     3     2     2     1     3     3
    7      3     2     1     2     2     2     3     2     1     1     3     3
    8    120    57     1     6     2     9    10     4     2     1    66    53
    9    126    53     1     4     2     9     9     4     2     1    58    37
    10   146    55     1     7     3     9    10     4     2     1    72    58
    11     1     1     1     1     1     1     1     1     1     1     1     1
    12     1     1     1     1     1     1     1     1     1     1     1     1
    13     1     1     1     1     1     1     1     1     1     1     1     1
    14     1     1     1     1     1     1     1     1     1     1     1     1
    15     1     1     1     1     1     1     1     1     1     1     1     1
    16     1     1     1     1     1     1     1     1     1     1     1     1
    17     1     1     1     1     1     1     1     1     1     1     1     1
    18     1     1     1     1     1     1     1     1     1     1     1     1
    19     1     1     1     1     1     1     1     1     1     1     1     1
    20     1     1     1     1     1     1     1     1     1     1     1     1
    21    14    12     1     5     3     6     5     4     2     1    11    14
    22     5     4     1     3     3     3     3     3     1     1     4     4
    23     9     8     1     4     3     4     4     4     2     1     8     9
    24     6     6     1     3     3     3     4     3     2     1     5     5
    25    14    12     1     5     3     6     5     4     2     1    11    14
    26     2     2     1     2     2     2     2     2     1     1     2     2
    27     2     1     1     1     1     1     1     1     1     1     1     2
    28     2     2     1     2     2     2     2     2     1     1     2     2
    29     3     3     1     2     1     1     2     3     1     1     3     3
    30     7     5     1     3     2     2     3     3     1     1     5     6
    31     6     6     1     1     1     1     1     1     1     1     6     6
         V91   V92   V93   V94   V95   V96   V97   V98   V99  V100  V101  V102
    1    A_3   A_3   A_3   A_3   A_4   A_4   A_4   A_4   A_4   A_4   A_4   A_4
    2    F_4   F_5   F_6  <NA>   A_1   A_2   A_3   A_4   A_5   A_6   B_1   B_2
    3      4    82     8    39   842  3853  3154  7346  3177    91    15    25
    4      2     4     2     2     7     7     7     7     6     6     2     1
    5      4     8     3     6     9     9     9     9     9     8     4     6
    6      3     3     2     2     3     3     3     3     3     3     3     3
    7      2     3     2     2     3     3     3     3     3     2     2     2
    8      4    52     5    16   365   839   791  1017   675    49    12    17
    9      4    49     4     4   432  1473  1069  1033   865    41    12    17
    10     4    57     5    30   519  1605  1310  1172  1070    52    12    17
    11     1     1     1     1     1     1     1     1     1     1     1     1
    12     1     1     1     1     1     1     1     1     1     1     1     1
    13     1     1     1     1     1     1     1     1     1     1     1     1
    14     1     1     1     1     1     1     1     1     1     1     1     1
    15     1     1     1     1     1     1     1     1     1     1     1     1
    16     1     1     1     1     1     1     1     1     1     1     1     1
    17     1     1     1     1     1     1     1     1     1     1     1     1
    18     1     1     1     1     1     1     1     1     1     1     1     1
    19     1     1     1     1     1     1     1     1     1     1     1     1
    20     1     1     1     1     1     1     1     1     1     1     1     1
    21     3    12     5    11    16    25    26    25    20     7     5     4
    22     2     5     4     4     4     6     6     6     5     3     2     2
    23     3     8     5     8    10    12    12    12    11     6     5     4
    24     3     5     4     5     6     6     6     6     6     5     5     4
    25     3    12     5    11    16    25    26    25    20     7     5     4
    26     2     2     2     2     2     2     2     2     2     2     1     1
    27     1     1     1     1     2     2     2     2     2     1     1     1
    28     2     2     2     2     2     2     2     2     2     2     2     2
    29     2     3     2     2     3     3     3     3     3     3     2     2
    30     3     5     3     3    10    11    11    11     8     5     3     4
    31     3     5     1     3     8     8     8     9     8     8     3     3
        V103  V104  V105  V106  V107  V108  V109  V110  V111  V112  V113  V114
    1    A_4   A_4   A_4   A_4   A_4   A_4   A_4   A_4   A_4   A_4   A_4   A_4
    2    B_3   B_4   B_5   B_6   C_2   C_3   C_4   C_5   C_6   D_2   D_4   D_5
    3     96   117    67    15    24    53    27   160    28     3     7     6
    4      2     2     2     2     2     3     2     2     2     1     1     1
    5      9     9     8     6     7     8     7     7     2     2     3     3
    6      3     3     3     2     3     3     3     3     2     2     3     2
    7      3     3     3     2     3     3     2     3     3     2     3     2
    8     62    65    42     8    14    27    17    69    18     2     5     4
    9     59    61    41     8    15    26    12    68    20     2     6     4
    10    64    68    42     8    16    30    22    84    19     2     6     4
    11     1     1     1     1     1     1     1     1     1     1     1     1
    12     1     1     1     1     1     1     1     1     1     1     1     1
    13     1     1     1     1     1     1     1     1     1     1     1     1
    14     1     1     1     1     1     1     1     1     1     1     1     1
    15     1     1     1     1     1     1     1     1     1     1     1     1
    16     1     1     1     1     1     1     1     1     1     1     1     1
    17     1     1     1     1     1     1     1     1     1     1     1     1
    18     1     1     1     1     1     1     1     1     1     1     1     1
    19     1     1     1     1     1     1     1     1     1     1     1     1
    20     1     1     1     1     1     1     1     1     1     1     1     1
    21     9     9    10     4     6     7     7     7     5     2     3     3
    22     2     2     3     2     3     2     3     3     3     1     2     2
    23     5     5     7     4     5     7     7     5     5     2     3     3
    24     5     5     5     4     4     4     4     4     4     2     2     3
    25     9     9    10     4     6     7     7     7     5     2     3     3
    26     1     1     2     1     2     2     2     2     2     1     2     2
    27     1     1     2     1     1     1     1     2     2     1     1     1
    28     2     2     2     2     2     2     2     2     2     2     2     2
    29     3     3     3     2     2     2     3     3     2     2     2     1
    30     6     5     7     4     4     4     5     7     5     3     3     2
    31     7     7     6     3     3     5     5     6     4     1     3     1
        V115  V116  V117  V118  V119  V120  V121  V122  V123  V124  V125  V126
    1    A_4   A_4   A_4   A_4   A_4   A_5   A_5   A_5   A_5   A_5   A_5   A_5
    2    D_6   F_2   F_3   F_5  <NA>   A_1   A_2   A_3   A_4   A_5   A_6   B_1
    3      6     5     7     4     3  1415  9397  7695  3202 21109   361    40
    4      2     1     2     1     1     7     7     7     7     7     5     3
    5      5     4     4     3     2     9     9     9     9     9     9     8
    6      2     2     3     2     1     3     3     3     3     3     3     3
    7      3     1     2     2     2     3     3     3     3     3     3     3
    8      5     3     6     4     2   652  1456  1335   878  1808   165    30
    9      5     4     6     4     1   584  2181  1392   687  1795    84    30
    10     6     4     6     4     2   877  2785  2282  1089  2375   159    32
    11     1     1     1     1     1     1     1     1     1     1     1     1
    12     1     1     1     1     1     1     1     1     1     1     1     1
    13     1     1     1     1     1     1     1     1     1     1     1     1
    14     1     1     1     1     1     1     1     1     1     1     1     1
    15     1     1     1     1     1     1     1     1     1     1     1     1
    16     1     1     1     1     1     1     1     1     1     1     1     1
    17     1     1     1     1     1     1     1     1     1     1     1     1
    18     1     1     1     1     1     1     1     1     1     1     1     1
    19     1     1     1     1     1     1     1     1     1     1     1     1
    20     1     1     1     1     1     1     1     1     1     1     1     1
    21     4     3     5     3     2    21    27    23    20    29    12     9
    22     2     2     2     2     1     5     6     6     5     6     4     3
    23     4     3     5     3     2    11    11    12    11    12     7     6
    24     4     3     4     3     2     6     6     6     6     6     5     6
    25     4     3     5     3     2    21    27    23    20    29    12     9
    26     2     2     2     2     1     2     2     2     2     2     2     2
    27     1     1     2     1     1     2     2     2     2     2     1     1
    28     2     2     2     2     1     2     2     2     2     2     2     2
    29     2     2     2     3     1     3     3     3     3     3     3     3
    30     3     3     3     4     1    11    12    10     9    12     6     5
    31     1     2     3     1     1     8     8     8     8     9     8     4
        V127  V128  V129  V130  V131  V132  V133  V134  V135  V136  V137  V138
    1    A_5   A_5   A_5   A_5   A_5   A_5   A_5   A_5   A_5   A_5   A_5   A_5
    2    B_2   B_3   B_4   B_5   B_6   C_1   C_2   C_3   C_4   C_5   C_6   D_2
    3    122   117    74   157    64     8    66   114    51   356   139     5
    4      4     3     2     4     2     2     3     2     2     6     3     2
    5      9     9     8     8     8     5     8     9     7     9     7     2
    6      3     3     3     3     3     3     3     3     3     3     3     1
    7      3     3     3     3     3     3     3     3     3     3     3     2
    8     69    82    43    85    37     7    31    62    33   159    77     4
    9     82    88    43    99    35     6    36    52    25   146    66     3
    10    88    94    49   108    42     7    41    68    34   191    76     3
    11     1     1     1     1     1     1     1     1     1     1     1     1
    12     1     1     1     1     1     1     1     1     1     1     1     1
    13     1     1     1     1     1     1     1     1     1     1     1     1
    14     1     1     1     1     1     1     1     1     1     1     1     1
    15     1     1     1     1     1     1     1     1     1     1     1     1
    16     1     1     1     1     1     1     1     1     1     1     1     1
    17     1     1     1     1     1     1     1     1     1     1     1     1
    18     1     1     1     1     1     1     1     1     1     1     1     1
    19     1     1     1     1     1     1     1     1     1     1     1     1
    20     1     1     1     1     1     1     1     1     1     1     1     1
    21    10    13     8    12     8     3     9    11     8    17     8     1
    22     3     3     3     4     3     2     5     3     4     4     3     1
    23     6     8     6     8     6     3     6     9     6    11     7     1
    24     5     6     5     5     5     3     4     5     5     6     5     1
    25    10    13     8    12     8     3     9    11     8    17     8     1
    26     2     2     2     2     2     1     2     2     2     2     2     1
    27     1     1     2     1     1     2     2     2     1     1     1     1
    28     2     2     2     2     2     1     2     2     2     2     2     2
    29     3     3     3     3     2     2     2     3     3     3     3     2
    30     5     6     7     5     4     3     5     7     5     6     6     2
    31     7     6     6     7     5     2     7     6     5     8     7     2
        V139  V140  V141  V142  V143  V144  V145  V146  V147  V148  V149  V150
    1    A_5   A_5   A_5   A_5   A_5   A_5   A_5   A_5   A_5   A_5   A_5   A_5
    2    D_3   D_4   D_5   D_6   E_2   E_3   E_5   E_6   F_2   F_3   F_5   F_6
    3     11     5    30    20     1     1     1    11    25    31    38     4
    4      2     1     1     2     1     1     1     1     1     2     2     1
    5      2     2     6     5     1     1     1     3     6     8     6     2
    6      1     2     3     3     1     1     1     2     3     3     3     1
    7      2     2     3     3     1     1     1     2     2     2     2     3
    8      7     2    16    16     1     1     1     5    13    19    23     3
    9      3     2    15    14     1     1     1     3    14    18    27     3
    10     7     2    18    16     1     1     1     4    14    21    24     3
    11     1     1     1     1     1     1     1     1     1     1     1     1
    12     1     1     1     1     1     1     1     1     1     1     1     1
    13     1     1     1     1     1     1     1     1     1     1     1     1
    14     1     1     1     1     1     1     1     1     1     1     1     1
    15     1     1     1     1     1     1     1     1     1     1     1     1
    16     1     1     1     1     1     1     1     1     1     1     1     1
    17     1     1     1     1     1     1     1     1     1     1     1     1
    18     1     1     1     1     1     1     1     1     1     1     1     1
    19     1     1     1     1     1     1     1     1     1     1     1     1
    20     1     1     1     1     1     1     1     1     1     1     1     1
    21     2     2     3     6     1     1     1     4     4    10     6     3
    22     1     2     2     4     1     1     1     3     2     5     3     3
    23     2     2     3     5     1     1     1     3     4     7     5     2
    24     2     2     2     4     1     1     1     2     3     4     3     1
    25     2     2     3     6     1     1     1     4     4    10     6     3
    26     1     2     2     2     1     1     1     2     2     2     2     2
    27     1     1     1     1     1     1     1     1     1     2     1     1
    28     2     2     2     2     1     1     1     2     2     2     2     2
    29     2     2     2     3     1     1     1     2     2     2     2     2
    30     3     3     4     4     1     1     1     3     3     5     3     2
    31     1     2     3     2     1     1     1     3     4     4     5     2
        V151  V152  V153  V154  V155  V156  V157  V158  V159  V160  V161  V162
    1    A_5   A_6   A_6   A_6   A_6   A_6   A_6   A_6   A_6   A_6   A_6   A_6
    2   <NA>   A_1   A_2   A_3   A_4   A_5   A_6   B_1   B_2   B_3   B_4   B_5
    3      5   152   221   184    91   371   645     5    18    28    15    18
    4      2     7     7     7     7     5     7     1     1     2     3     3
    5      4     9     9     9     9     9     9     4     5     4     8     6
    6      2     3     3     3     3     3     3     2     3     3     3     3
    7      2     3     3     3     3     3     3     2     2     3     2     2
    8      3    19    61    46    38    91    79     2     7    11     6    11
    9      1    88   143   114    48   178    80     4     9    18    10    15
    10     4   112   141   114    48   165   107     4    11    18    10    15
    11     1     1     1     1     1     1     1     1     1     1     1     1
    12     1     1     1     1     1     1     1     1     1     1     1     1
    13     1     1     1     1     1     1     1     1     1     1     1     1
    14     1     1     1     1     1     1     1     1     1     1     1     1
    15     1     1     1     1     1     1     1     1     1     1     1     1
    16     1     1     1     1     1     1     1     1     1     1     1     1
    17     1     1     1     1     1     1     1     1     1     1     1     1
    18     1     1     1     1     1     1     1     1     1     1     1     1
    19     1     1     1     1     1     1     1     1     1     1     1     1
    20     1     1     1     1     1     1     1     1     1     1     1     1
    21     3    19    13    11     7    11    16     2     5    11     6     6
    22     1     4     5     3     3     5     6     1     3     3     2     2
    23     3    10     8    10     6     8     9     2     4     8     6     6
    24     3     6     6     6     5     6     6     2     3     6     6     6
    25     3    19    13    11     7    11    16     2     5    11     6     6
    26     1     2     2     2     2     2     2     1     2     2     1     1
    27     1     2     2     2     2     1     2     1     1     1     1     1
    28     2     2     2     2     2     2     2     2     2     2     2     2
    29     2     3     3     3     3     3     3     2     2     2     2     3
    30     3     8     7     8     6     6     7     3     4     3     3     4
    31     1     8     8     8     7     8     9     3     4     2     5     5
        V163  V164  V165  V166  V167  V168  V169  V170  V171  V172  V173  V174
    1    A_6   A_6   A_6   A_6   A_6   A_6   A_6   A_6   A_6   A_6   A_6   A_6
    2    B_6   C_1   C_2   C_3   C_4   C_5   C_6   D_2   D_4   D_5   D_6   E_6
    3     11     1     7    21     4    86    43     5     3     2    11     5
    4      3     1     2     2     1     4     2     1     1     1     2     1
    5      4     1     6     6     2     9     7     1     2     2     4     3
    6      2     1     3     3     2     3     3     1     1     2     3     3
    7      2     1     2     2     1     3     3     1     1     1     2     2
    8      9     1     5    10     2    25    21     1     1     2     4     2
    9      8     1     5    10     2    35    25     1     1     1     4     3
    10     8     1     5    13     2    39    27     1     1     2     5     2
    11     1     1     1     1     1     1     1     1     1     1     1     1
    12     1     1     1     1     1     1     1     1     1     1     1     1
    13     1     1     1     1     1     1     1     1     1     1     1     1
    14     1     1     1     1     1     1     1     1     1     1     1     1
    15     1     1     1     1     1     1     1     1     1     1     1     1
    16     1     1     1     1     1     1     1     1     1     1     1     1
    17     1     1     1     1     1     1     1     1     1     1     1     1
    18     1     1     1     1     1     1     1     1     1     1     1     1
    19     1     1     1     1     1     1     1     1     1     1     1     1
    20     1     1     1     1     1     1     1     1     1     1     1     1
    21     3     1     5     8     2     9     7     1     1     2     2     2
    22     2     1     2     3     2     3     4     1     1     1     2     2
    23     2     1     5     7     2     8     6     1     1     2     2     2
    24     2     1     4     5     2     5     4     1     1     2     1     1
    25     3     1     5     8     2     9     7     1     1     2     2     2
    26     1     1     2     2     2     2     2     1     1     1     2     2
    27     1     1     1     1     1     2     1     1     1     1     1     1
    28     2     1     2     2     2     2     2     1     1     2     1     2
    29     3     1     2     2     1     3     3     1     1     2     2     2
    30     5     1     3     4     2     6     5     1     1     2     2     4
    31     4     1     1     4     1     8     6     1     1     2     4     2
        V175  V176  V177  V178  V179  V180  V181  V182  V183  V184  V185  V186
    1    A_6   A_6   A_6   A_6   B_1   B_1   B_1   B_1   B_1   B_1   B_1   B_1
    2    F_2   F_3   F_6  <NA>   A_1   A_2   A_3   A_4   A_5   A_6   B_1   B_2
    3      1     8     3     2    36    61    38    15    24     5 11327  7891
    4      1     1     2     1     3     3     3     2     1     1     7     7
    5      1     2     2     2     7     9     7     8     6     3     9     9
    6      1     2     2     2     3     3     3     3     3     3     3     3
    7      1     2     1     1     2     3     3     3     3     2     3     3
    8      1     2     2     1    22    39    27    11    20     4  1331  1285
    9      1     1     2     1    23    42    28    13    19     2  1326  2013
    10     1     6     2     2    25    45    30    13    23     4  2143  2882
    11     1     1     1     1     1     1     1     1     1     1     1     1
    12     1     1     1     1     1     1     1     1     1     1     1     1
    13     1     1     1     1     1     1     1     1     1     1     1     1
    14     1     1     1     1     1     1     1     1     1     1     1     1
    15     1     1     1     1     1     1     1     1     1     1     1     1
    16     1     1     1     1     1     1     1     1     1     1     1     1
    17     1     1     1     1     1     1     1     1     1     1     1     1
    18     1     1     1     1     1     1     1     1     1     1     1     1
    19     1     1     1     1     1     1     1     1     1     1     1     1
    20     1     1     1     1     1     1     1     1     1     1     1     1
    21     1     5     2     2     8    10     8     4     7     2    28    27
    22     1     2     2     2     3     4     3     3     2     1     6     7
    23     1     4     2     2     7     7     6     4     5     2    12    13
    24     1     4     2     2     6     5     5     3     5     2     6     7
    25     1     5     2     2     8    10     8     4     7     2    28    27
    26     1     1     1     2     2     2     2     2     1     1     2     3
    27     1     1     1     1     1     2     2     1     1     1     2     2
    28     1     2     2     1     2     2     2     2     2     2     2     2
    29     1     1     1     2     2     2     2     3     3     2     3     3
    30     1     2     2     2     4     6     6     4     5     3    12    12
    31     1     1     1     1     3     6     3     4     5     2     9     8
        V187  V188  V189  V190  V191  V192  V193  V194  V195  V196  V197  V198
    1    B_1   B_1   B_1   B_1   B_1   B_1   B_1   B_1   B_1   B_1   B_1   B_1
    2    B_3   B_4   B_5   B_6   C_1   C_2   C_3   C_4   C_5   C_6   D_1   D_2
    3   4330  1053  2083   723     1    75    48    20   145    96     2     4
    4      7     6     7     6     1     3     2     1     4     3     2     1
    5      9     9     9     9     1     7     7     5     9     8     2     2
    6      3     3     3     3     1     3     3     3     3     3     1     2
    7      3     3     3     3     1     3     3     2     3     3     1     2
    8   1037   360   568   296     1    42    33    14   100    57     1     1
    9   1177   347   704   299     1    42    27    15    98    59     2     1
    10  2022   542   982   402     1    48    37    15   110    63     2     2
    11     1     1     1     1     1     1     1     1     1     1     1     1
    12     1     1     1     1     1     1     1     1     1     1     1     1
    13     1     1     1     1     1     1     1     1     1     1     1     1
    14     1     1     1     1     1     1     1     1     1     1     1     1
    15     1     1     1     1     1     1     1     1     1     1     1     1
    16     1     1     1     1     1     1     1     1     1     1     1     1
    17     1     1     1     1     1     1     1     1     1     1     1     1
    18     1     1     1     1     1     1     1     1     1     1     1     1
    19     1     1     1     1     1     1     1     1     1     1     1     1
    20     1     1     1     1     1     1     1     1     1     1     1     1
    21    27    15    22    19     1    12    10     6    17    10     2     2
    22     6     5     5     6     1     4     3     4     5     4     1     2
    23    12    11    11    10     1     9     8     5    10     8     2     1
    24     6     6     6     6     1     6     5     4     6     5     2     1
    25    27    15    22    19     1    12    10     6    17    10     2     2
    26     2     2     2     2     1     2     2     2     2     2     1     1
    27     2     2     2     2     1     2     2     1     2     2     1     1
    28     2     2     2     2     1     2     2     2     2     2     1     2
    29     3     3     3     3     1     2     2     2     3     3     2     1
    30    12    10    11     9     1     5     5     3     7     6     2     2
    31     8     8     8     8     1     8     6     2     7     5     2     1
        V199  V200  V201  V202  V203  V204  V205  V206  V207  V208  V209  V210
    1    B_1   B_1   B_1   B_1   B_1   B_1   B_1   B_1   B_1   B_1   B_1   B_1
    2    D_3   D_4   D_5   D_6   E_2   E_3   E_5   E_6   F_1   F_2   F_4   F_5
    3      2     8    33    23     4    15     7    10     1     6     4    12
    4      1     3     1     2     1     2     1     1     1     1     1     1
    5      1     4     6     6     1     5     2     3     1     4     1     5
    6      1     3     3     3     1     2     2     3     1     3     1     3
    7      1     2     2     3     2     2     2     2     1     3     1     1
    8      1     5    21    17     2    10     3     7     1     4     1     7
    9      1     5    24    15     2     8     4     7     1     4     1     7
    10     1     6    22    16     2     8     4     7     1     4     1     7
    11     1     1     1     1     1     1     1     1     1     1     1     1
    12     1     1     1     1     1     1     1     1     1     1     1     1
    13     1     1     1     1     1     1     1     1     1     1     1     1
    14     1     1     1     1     1     1     1     1     1     1     1     1
    15     1     1     1     1     1     1     1     1     1     1     1     1
    16     1     1     1     1     1     1     1     1     1     1     1     1
    17     1     1     1     1     1     1     1     1     1     1     1     1
    18     1     1     1     1     1     1     1     1     1     1     1     1
    19     1     1     1     1     1     1     1     1     1     1     1     1
    20     1     1     1     1     1     1     1     1     1     1     1     1
    21     1     4     6     6     1     4     2     4     1     3     1     4
    22     1     2     3     3     1     2     2     2     1     2     1     3
    23     1     4     6     5     1     4     2     4     1     3     1     4
    24     1     3     5     4     1     4     2     3     1     2     1     3
    25     1     4     6     6     1     4     2     4     1     3     1     4
    26     1     2     2     2     1     2     2     2     1     2     1     2
    27     1     1     1     1     1     1     1     1     1     1     1     1
    28     1     2     2     2     1     1     1     2     1     1     1     2
    29     1     2     2     2     1     2     2     3     1     2     1     2
    30     1     3     4     4     1     2     2     5     1     2     1     3
    31     1     4     4     4     1     5     1     2     1     1     1     2
        V211  V212  V213  V214  V215  V216  V217  V218  V219  V220  V221  V222
    1    B_1   B_1   B_2   B_2   B_2   B_2   B_2   B_2   B_2   B_2   B_2   B_2
    2    F_6  <NA>   A_1   A_2   A_3   A_4   A_5   A_6   B_1   B_2   B_3   B_4
    3     16    12    81   125   185    30   130    14  7841 48307 14409  3879
    4      2     2     4     5     4     2     4     1     7     7     7     6
    5      5     4     9     9     9     5     9     2     9     9     9     9
    6      3     2     3     3     3     3     3     2     3     3     3     3
    7      2     2     3     3     3     2     3     3     3     3     3     3
    8      8     7    61    84   111    19    91     7  1988  4293  3073  1067
    9      8     1    55    85   103    19    83     6  1291  4252  2237   715
    10     8     7    63    90   125    19    98     7  2806  5309  4407  1453
    11     1     1     1     1     1     1     1     1     1     1     1     1
    12     1     1     1     1     1     1     1     1     1     1     1     1
    13     1     1     1     1     1     1     1     1     1     1     1     1
    14     1     1     1     1     1     1     1     1     1     1     1     1
    15     1     1     1     1     1     1     1     1     1     1     1     1
    16     1     1     1     1     1     1     1     1     1     1     1     1
    17     1     1     1     1     1     1     1     1     1     1     1     1
    18     1     1     1     1     1     1     1     1     1     1     1     1
    19     1     1     1     1     1     1     1     1     1     1     1     1
    20     1     1     1     1     1     1     1     1     1     1     1     1
    21     5     4     7    12    17     5    13     3    28    33    32    23
    22     3     3     3     4     5     3     3     3     7     7     7     6
    23     4     4     6     8    11     4     9     3    13    13    13    12
    24     4     4     5     5     6     3     6     2     7     7     7     6
    25     5     4     7    12    17     5    13     3    28    33    32    23
    26     2     2     2     2     2     2     2     2     3     3     3     2
    27     1     1     2     2     2     1     1     1     2     2     2     2
    28     1     1     2     2     2     2     2     2     2     2     2     2
    29     2     1     3     3     3     2     3     2     3     3     3     3
    30     2     1     6     9     8     3     6     4    12    12    12     9
    31     1     4     4     8     6     4     6     3     8     9     8     8
        V223  V224  V225  V226  V227  V228  V229  V230  V231  V232  V233  V234
    1    B_2   B_2   B_2   B_2   B_2   B_2   B_2   B_2   B_2   B_2   B_2   B_2
    2    B_5   B_6   C_1   C_2   C_3   C_4   C_5   C_6   D_2   D_3   D_4   D_5
    3  10373  2826    11   254   210    75   511   290    19     5    10    87
    4      6     7     1     3     4     1     5     4     2     1     1     2
    5      9     9     4     9     9     9     9     8     8     5     3     9
    6      3     3     3     3     3     3     3     3     3     3     3     3
    7      3     3     3     3     3     3     3     3     2     2     3     3
    8   2209   929    10   129   116    43   283   163    15     4     8    59
    9   1707   627     7   121    90    40   252   171    12     4     7    50
    10  3061  1068    10   158   120    49   317   194    15     4     8    55
    11     1     1     1     1     1     1     1     1     1     1     1     1
    12     1     1     1     1     1     1     1     1     1     1     1     1
    13     1     1     1     1     1     1     1     1     1     1     1     1
    14     1     1     1     1     1     1     1     1     1     1     1     1
    15     1     1     1     1     1     1     1     1     1     1     1     1
    16     1     1     1     1     1     1     1     1     1     1     1     1
    17     1     1     1     1     1     1     1     1     1     1     1     1
    18     1     1     1     1     1     1     1     1     1     1     1     1
    19     1     1     1     1     1     1     1     1     1     1     1     1
    20     1     1     1     1     1     1     1     1     1     1     1     1
    21    32    21     4    13    14    13    19    14     7     2     2     8
    22     7     6     2     4     4     5     6     5     5     2     2     3
    23    13    11     4    11     9    10    11    11     5     2     2     7
    24     7     6     3     6     5     6     6     6     3     2     2     5
    25    32    21     4    13    14    13    19    14     7     2     2     8
    26     3     2     2     2     2     2     2     2     2     2     2     2
    27     2     2     1     1     2     2     2     2     1     1     1     1
    28     2     2     1     2     2     2     2     2     2     2     2     2
    29     3     3     2     3     3     3     3     3     3     2     2     3
    30    12     9     2     6     8     7     7     7     5     3     4     6
    31     8     8     2     8     7     7     7     6     3     3     2     4
        V235  V236  V237  V238  V239  V240  V241  V242  V243  V244  V245  V246
    1    B_2   B_2   B_2   B_2   B_2   B_2   B_2   B_2   B_2   B_2   B_2   B_2
    2    D_6   E_2   E_3   E_4   E_5   E_6   F_1   F_2   F_3   F_4   F_5   F_6
    3     65     9    15     1    34    19     4    20    28     5    47    10
    4      3     3     2     1     1     1     1     1     2     1     2     1
    5      6     4     5     1     7     4     3     8     8     1     8     5
    6      3     3     2     1     3     2     2     3     3     1     3     3
    7      3     2     2     1     2     3     2     3     3     1     3     3
    8     48     6     8     1    22    14     3    17    24     1    35     8
    9     40     4     7     1    16    11     3    15    14     1    26     8
    10    50     6     8     1    19    12     3    17    23     1    33     9
    11     1     1     1     1     1     1     1     1     1     1     1     1
    12     1     1     1     1     1     1     1     1     1     1     1     1
    13     1     1     1     1     1     1     1     1     1     1     1     1
    14     1     1     1     1     1     1     1     1     1     1     1     1
    15     1     1     1     1     1     1     1     1     1     1     1     1
    16     1     1     1     1     1     1     1     1     1     1     1     1
    17     1     1     1     1     1     1     1     1     1     1     1     1
    18     1     1     1     1     1     1     1     1     1     1     1     1
    19     1     1     1     1     1     1     1     1     1     1     1     1
    20     1     1     1     1     1     1     1     1     1     1     1     1
    21    12     4     4     1     3     4     3     4     8     1     8     3
    22     5     3     3     1     3     2     2     2     4     1     3     3
    23     9     3     4     1     3     4     3     4     7     1     7     2
    24     5     2     3     1     2     3     3     3     4     1     5     2
    25    12     4     4     1     3     4     3     4     8     1     8     3
    26     2     2     2     1     2     2     2     2     2     1     2     2
    27     1     1     1     1     1     1     1     1     1     1     1     1
    28     2     2     2     1     2     2     1     2     2     1     2     2
    29     3     2     3     1     2     3     2     2     2     1     3     2
    30     5     3     5     1     4     5     2     4     4     1     5     3
    31     4     2     3     1     2     2     1     2     4     1     4     1
        V247  V248  V249  V250  V251  V252  V253  V254  V255  V256  V257  V258
    1    B_2   B_3   B_3   B_3   B_3   B_3   B_3   B_3   B_3   B_3   B_3   B_3
    2   <NA>   A_1   A_2   A_3   A_4   A_5   A_6   B_1   B_2   B_3   B_4   B_5
    3     22    97   121   249    95   151    25  4301 14517 23096  3195  6732
    4      1     4     5     4     2     2     3     7     7     7     7     7
    5      7     8     9     9     8     8     7     9     9     9     9     9
    6      3     3     3     3     3     3     3     3     3     3     3     3
    7      3     3     3     3     3     3     3     3     3     3     3     3
    8     14    63    80   107    53    93    17  1169  2234  2638   884  1468
    9      3    61    82   114    59    92    11  1043  3117  2634   755  1512
    10    14    70    86   171    62   105    19  1983  4436  4091  1292  2373
    11     1     1     1     1     1     1     1     1     1     1     1     1
    12     1     1     1     1     1     1     1     1     1     1     1     1
    13     1     1     1     1     1     1     1     1     1     1     1     1
    14     1     1     1     1     1     1     1     1     1     1     1     1
    15     1     1     1     1     1     1     1     1     1     1     1     1
    16     1     1     1     1     1     1     1     1     1     1     1     1
    17     1     1     1     1     1     1     1     1     1     1     1     1
    18     1     1     1     1     1     1     1     1     1     1     1     1
    19     1     1     1     1     1     1     1     1     1     1     1     1
    20     1     1     1     1     1     1     1     1     1     1     1     1
    21     5    13    14    22     9    13    10    27    32    33    24    26
    22     2     4     4     6     3     3     4     6     6     7     7     6
    23     5     9     9    11     6     8     7    12    12    13    12    12
    24     4     6     6     6     6     6     5     6     6     7     7     6
    25     5    13    14    22     9    13    10    27    32    33    24    26
    26     2     2     2     2     2     2     2     2     2     3     3     2
    27     1     2     1     2     1     1     2     2     2     2     2     2
    28     2     2     2     2     2     2     2     2     2     2     2     2
    29     2     3     3     3     3     3     3     3     3     3     3     3
    30     4     8     6     6     6     6     6    12    12    12    11    11
    31     6     3     5     6     7     6     3     8     8     9     8     8
        V259  V260  V261  V262  V263  V264  V265  V266  V267  V268  V269  V270
    1    B_3   B_3   B_3   B_3   B_3   B_3   B_3   B_3   B_3   B_3   B_3   B_3
    2    B_6   C_1   C_2   C_3   C_4   C_5   C_6   D_2   D_3   D_4   D_5   D_6
    3   1683     9   171   286    63   540   295     9    23     7    65    37
    4      6     2     4     4     3     4     3     1     2     2     2     1
    5      9     6     9     9     8     9     9     3     7     3     7     6
    6      3     3     3     3     3     3     3     2     3     3     3     3
    7      3     3     3     3     2     3     3     2     3     2     3     3
    8    572     8   105   150    41   260   157     5    17     6    47    28
    9    491     6   111   128    37   292   156     4    16     6    44    27
    10   740     8   124   169    44   343   179     4    17     6    46    28
    11     1     1     1     1     1     1     1     1     1     1     1     1
    12     1     1     1     1     1     1     1     1     1     1     1     1
    13     1     1     1     1     1     1     1     1     1     1     1     1
    14     1     1     1     1     1     1     1     1     1     1     1     1
    15     1     1     1     1     1     1     1     1     1     1     1     1
    16     1     1     1     1     1     1     1     1     1     1     1     1
    17     1     1     1     1     1     1     1     1     1     1     1     1
    18     1     1     1     1     1     1     1     1     1     1     1     1
    19     1     1     1     1     1     1     1     1     1     1     1     1
    20     1     1     1     1     1     1     1     1     1     1     1     1
    21    23     7    13    21    10    19    18     3    12     4    10     8
    22     6     4     4     6     3     5     6     3     4     4     3     4
    23    11     6    11    11     9    11    11     3     9     4     9     7
    24     6     4     6     6     5     6     6     2     6     4     5     5
    25    23     7    13    21    10    19    18     3    12     4    10     8
    26     2     2     2     2     2     2     2     2     2     2     2     2
    27     2     1     1     2     1     2     1     1     1     1     1     1
    28     2     2     2     2     2     2     2     2     2     2     2     2
    29     3     2     3     3     3     3     3     1     2     2     3     2
    30     9     3     5     8     5     7     6     2     4     3     6     4
    31     8     1     5     7     6     6     6     1     5     3     4     3
        V271  V272  V273  V274  V275  V276  V277  V278  V279  V280  V281  V282
    1    B_3   B_3   B_3   B_3   B_3   B_3   B_3   B_3   B_3   B_3   B_3   B_4
    2    E_2   E_3   E_5   E_6   F_1   F_2   F_3   F_4   F_5   F_6  <NA>   A_1
    3     12    34    43     7     2    24    51     4    28     9    24    36
    4      1     2     2     2     1     2     2     2     2     2     2     3
    5      5     8     9     3     2     8     7     2     8     3     6     8
    6      3     3     3     3     2     3     3     2     3     2     3     3
    7      2     2     2     2     2     3     3     1     3     2     3     3
    8      9    15    21     4     2    17    29     3    22     8    16    27
    9      7    12    18     4     2    16    16     3    21     7     2    26
    10     8    19    23     4     2    18    41     3    23     8    14    27
    11     1     1     1     1     1     1     1     1     1     1     1     1
    12     1     1     1     1     1     1     1     1     1     1     1     1
    13     1     1     1     1     1     1     1     1     1     1     1     1
    14     1     1     1     1     1     1     1     1     1     1     1     1
    15     1     1     1     1     1     1     1     1     1     1     1     1
    16     1     1     1     1     1     1     1     1     1     1     1     1
    17     1     1     1     1     1     1     1     1     1     1     1     1
    18     1     1     1     1     1     1     1     1     1     1     1     1
    19     1     1     1     1     1     1     1     1     1     1     1     1
    20     1     1     1     1     1     1     1     1     1     1     1     1
    21     4     9     8     3     2     7    15     2     6     3     8     8
    22     2     3     4     3     2     3     5     1     3     2     3     3
    23     4     7     6     3     2     7    10     2     5     3     8     6
    24     3     4     5     2     2     5     6     2     3     3     7     5
    25     4     9     8     3     2     7    15     2     6     3     8     8
    26     2     2     2     2     1     2     2     1     2     2     3     2
    27     1     1     1     1     1     2     2     1     1     1     1     1
    28     2     2     2     2     1     2     2     2     2     2     2     2
    29     2     2     2     1     1     2     2     2     3     2     2     3
    30     4     4     4     2     1     5     5     3     5     3     4     4
    31     4     5     5     1     1     2     4     1     4     2     5     6
        V283  V284  V285  V286  V287  V288  V289  V290  V291  V292  V293  V294
    1    B_4   B_4   B_4   B_4   B_4   B_4   B_4   B_4   B_4   B_4   B_4   B_4
    2    A_2   A_3   A_4   A_5   A_6   B_1   B_2   B_3   B_4   B_5   B_6   C_2
    3     79   135   117    63     9  1038  3817  3351 11532  3412   700    94
    4      2     4     2     1     3     6     7     6     6     7     5     2
    5      7     9     9     7     5     9     9     9     9     9     9     9
    6      3     3     3     3     3     3     3     3     3     3     3     3
    7      3     3     3     3     2     3     3     3     3     3     3     3
    8     45    77    60    37     7   326   700   768   955   614   188    46
    9     49    79    62    36     6   333  1055   920   949   689   182    47
    10    48    88    72    42     7   507  1397  1358  1371  1003   277    60
    11     1     1     1     1     1     1     1     1     1     1     1     1
    12     1     1     1     1     1     1     1     1     1     1     1     1
    13     1     1     1     1     1     1     1     1     1     1     1     1
    14     1     1     1     1     1     1     1     1     1     1     1     1
    15     1     1     1     1     1     1     1     1     1     1     1     1
    16     1     1     1     1     1     1     1     1     1     1     1     1
    17     1     1     1     1     1     1     1     1     1     1     1     1
    18     1     1     1     1     1     1     1     1     1     1     1     1
    19     1     1     1     1     1     1     1     1     1     1     1     1
    20     1     1     1     1     1     1     1     1     1     1     1     1
    21     8    14    10     6     4    13    24    23    25    25    14    11
    22     2     4     3     2     2     4     6     6     6     6     4     4
    23     5     9     6     3     3    10    12    11    11    11    10     9
    24     5     6     6     3     3     6     6     6     6     6     6     5
    25     8    14    10     6     4    13    24    23    25    25    14    11
    26     1     2     2     1     1     2     2     2     2     2     2     2
    27     1     2     2     1     2     2     2     2     2     2     2     2
    28     2     2     2     2     2     2     2     2     2     2     2     2
    29     3     3     3     3     1     3     3     3     3     3     3     3
    30     5     6     6     6     3    10    11     9    12     9     8     6
    31     6     6     8     6     4     8     8     8     9     8     8     6
        V295  V296  V297  V298  V299  V300  V301  V302  V303  V304  V305  V306
    1    B_4   B_4   B_4   B_4   B_4   B_4   B_4   B_4   B_4   B_4   B_4   B_4
    2    C_3   C_4   C_5   C_6   D_1   D_2   D_3   D_4   D_5   D_6   E_3   E_4
    3    100   113   289   154     1     1     2    12    12    12    16     1
    4      3     2     3     1     1     1     2     1     2     1     2     1
    5      8     7     9     8     1     1     2     3     5     4     6     1
    6      3     3     3     3     1     1     1     3     2     3     3     1
    7      2     3     3     3     1     1     2     3     2     2     2     1
    8     51    43   139    69     1     1     2     8     9     9     4     1
    9     42    36   138    75     1     1     2     8     8     7     4     1
    10    63    52   169    85     1     1     2     8     9     8     5     1
    11     1     1     1     1     1     1     1     1     1     1     1     1
    12     1     1     1     1     1     1     1     1     1     1     1     1
    13     1     1     1     1     1     1     1     1     1     1     1     1
    14     1     1     1     1     1     1     1     1     1     1     1     1
    15     1     1     1     1     1     1     1     1     1     1     1     1
    16     1     1     1     1     1     1     1     1     1     1     1     1
    17     1     1     1     1     1     1     1     1     1     1     1     1
    18     1     1     1     1     1     1     1     1     1     1     1     1
    19     1     1     1     1     1     1     1     1     1     1     1     1
    20     1     1     1     1     1     1     1     1     1     1     1     1
    21    12    10    13    12     1     1     2     3     6     5     3     1
    22     3     3     4     4     1     1     1     2     3     4     2     1
    23    11     9    10    10     1     1     2     3     6     4     3     1
    24     6     6     6     6     1     1     2     2     5     3     3     1
    25    12    10    13    12     1     1     2     3     6     5     3     1
    26     2     2     2     2     1     1     1     2     2     2     2     1
    27     1     2     2     1     1     1     1     1     1     1     1     1
    28     2     2     2     2     1     1     1     2     2     2     2     1
    29     3     3     3     3     1     1     2     2     2     2     1     1
    30     6     7     8     6     1     1     2     3     3     4     2     1
    31     8     6     7     7     1     1     1     3     2     3     6     1
        V307  V308  V309  V310  V311  V312  V313  V314  V315  V316  V317  V318
    1    B_4   B_4   B_4   B_4   B_4   B_4   B_4   B_4   B_5   B_5   B_5   B_5
    2    E_5   E_6   F_1   F_2   F_3   F_5   F_6  <NA>   A_1   A_2   A_3   A_4
    3      2     1     6     6     4    10     2     6    91   162   213    71
    4      1     1     2     1     1     1     1     3     4     3     4     4
    5      2     1     3     4     3     5     1     4     7     9     9     7
    6      1     1     2     2     3     3     1     3     3     3     3     3
    7      1     1     2     2     2     2     1     3     3     3     3     3
    8      2     1     5     4     4     7     1     5    59    87    98    48
    9      2     1     4     4     4     6     1     2    61   103   105    46
    10     2     1     5     4     4     7     1     3    62    96   112    48
    11     1     1     1     1     1     1     1     1     1     1     1     1
    12     1     1     1     1     1     1     1     1     1     1     1     1
    13     1     1     1     1     1     1     1     1     1     1     1     1
    14     1     1     1     1     1     1     1     1     1     1     1     1
    15     1     1     1     1     1     1     1     1     1     1     1     1
    16     1     1     1     1     1     1     1     1     1     1     1     1
    17     1     1     1     1     1     1     1     1     1     1     1     1
    18     1     1     1     1     1     1     1     1     1     1     1     1
    19     1     1     1     1     1     1     1     1     1     1     1     1
    20     1     1     1     1     1     1     1     1     1     1     1     1
    21     1     1     2     3     3     3     1     3     9    15    17    10
    22     1     1     1     2     2     1     1     2     2     5     6     3
    23     1     1     2     3     3     3     1     3     5     9    11     6
    24     1     1     2     2     3     3     1     3     5     6     6     5
    25     1     1     2     3     3     3     1     3     9    15    17    10
    26     1     1     1     2     2     1     1     2     1     2     2     2
    27     1     1     1     1     1     1     1     1     1     2     2     2
    28     1     1     2     2     2     2     1     1     2     2     2     2
    29     1     1     2     1     1     2     1     1     3     3     3     3
    30     1     1     3     2     2     3     1     1     6     7     7     7
    31     2     1     2     1     1     3     1     3     4     5     8     6
        V319  V320  V321  V322  V323  V324  V325  V326  V327  V328  V329  V330
    1    B_5   B_5   B_5   B_5   B_5   B_5   B_5   B_5   B_5   B_5   B_5   B_5
    2    A_5   A_6   B_1   B_2   B_3   B_4   B_5   B_6   C_1   C_2   C_3   C_4
    3    160    16  2089 10237  6710  3481 25789  2646     8   182   204    78
    4      4     3     7     7     7     6     7     6     1     4     3     2
    5      9     6     9     9     9     9     9     9     4     9     9     9
    6      3     3     3     3     3     3     3     3     3     3     3     3
    7      3     3     3     3     3     3     3     3     2     3     3     3
    8     96    14   724  1701  1514   703  2273   733     6   109   115    51
    9     93    11   580  2188  1476   618  2259   606     6   102    88    41
    10   106    13   995  3011  2370  1018  3023   969     6   115   120    50
    11     1     1     1     1     1     1     1     1     1     1     1     1
    12     1     1     1     1     1     1     1     1     1     1     1     1
    13     1     1     1     1     1     1     1     1     1     1     1     1
    14     1     1     1     1     1     1     1     1     1     1     1     1
    15     1     1     1     1     1     1     1     1     1     1     1     1
    16     1     1     1     1     1     1     1     1     1     1     1     1
    17     1     1     1     1     1     1     1     1     1     1     1     1
    18     1     1     1     1     1     1     1     1     1     1     1     1
    19     1     1     1     1     1     1     1     1     1     1     1     1
    20     1     1     1     1     1     1     1     1     1     1     1     1
    21    12     5    21    31    27    21    31    23     3    13    12     8
    22     4     2     6     7     6     6     6     6     2     5     5     3
    23     8     5    11    13    12    11    12    11     3    10     9     7
    24     6     5     6     7     6     6     6     6     3     6     6     5
    25    12     5    21    31    27    21    31    23     3    13    12     8
    26     2     1     2     3     2     2     2     2     2     2     2     2
    27     2     1     2     2     2     2     2     2     1     1     2     1
    28     2     2     2     2     2     2     2     2     2     2     2     2
    29     3     3     3     3     3     3     3     3     2     3     3     3
    30     6     4    10    12    11     9    12     9     3     6     7     5
    31     7     5     8     8     8     8     9     8     3     7     6     6
        V331  V332  V333  V334  V335  V336  V337  V338  V339  V340  V341  V342
    1    B_5   B_5   B_5   B_5   B_5   B_5   B_5   B_5   B_5   B_5   B_5   B_5
    2    C_5   C_6   D_2   D_3   D_4   D_5   D_6   E_2   E_3   E_4   E_5   E_6
    3    737   504    10     9     9    59    89    14    19     2    87    28
    4      5     5     1     1     1     3     2     1     2     1     3     2
    5      9     9     2     5     4     9     7     6     6     1     6     6
    6      3     3     2     3     2     3     3     3     3     1     3     3
    7      3     3     2     3     2     3     3     2     3     1     2     3
    8    310   225     7     6     3    33    58     9    11     1    22    13
    9    319   196     4     7     3    34    46     4     7     1    16    11
    10   398   246     5     7     4    37    59     9    12     1    20    13
    11     1     1     1     1     1     1     1     1     1     1     1     1
    12     1     1     1     1     1     1     1     1     1     1     1     1
    13     1     1     1     1     1     1     1     1     1     1     1     1
    14     1     1     1     1     1     1     1     1     1     1     1     1
    15     1     1     1     1     1     1     1     1     1     1     1     1
    16     1     1     1     1     1     1     1     1     1     1     1     1
    17     1     1     1     1     1     1     1     1     1     1     1     1
    18     1     1     1     1     1     1     1     1     1     1     1     1
    19     1     1     1     1     1     1     1     1     1     1     1     1
    20     1     1     1     1     1     1     1     1     1     1     1     1
    21    21    15     3     5     3    10    10     5     4     1     3     6
    22     6     4     2     3     2     4     4     3     3     1     2     3
    23    11    10     3     5     3     7     8     4     3     1     3     6
    24     6     6     3     5     2     4     5     3     2     1     2     4
    25    21    15     3     5     3    10    10     5     4     1     3     6
    26     2     2     1     2     2     2     2     2     2     1     2     2
    27     2     2     1     1     1     1     1     1     1     1     1     1
    28     2     2     2     2     2     2     2     2     2     1     2     2
    29     3     3     2     2     3     3     3     2     2     1     2     2
    30     8     7     3     3     4     5     5     4     4     1     4     4
    31     8     8     2     3     3     5     6     2     4     1     5     6
        V343  V344  V345  V346  V347  V348  V349  V350  V351  V352  V353  V354
    1    B_5   B_5   B_5   B_5   B_5   B_5   B_5   B_6   B_6   B_6   B_6   B_6
    2    F_1   F_2   F_3   F_4   F_5   F_6  <NA>   A_1   A_2   A_3   A_4   A_5
    3      5     7    31     3    52    18    16    11    49    53    16    29
    4      1     2     3     1     2     1     3     2     2     3     1     2
    5      3     5     7     2     7     6     4     6     9     8     4     7
    6      2     3     3     2     3     3     3     3     3     3     2     3
    7      1     2     3     1     3     2     2     2     3     3     3     3
    8      4     6    23     2    30    10    10     7    22    33     8    18
    9      3     6    16     2    27     9     3     7    27    36     8    22
    10     4     6    24     2    33    11     9     7    28    38     8    23
    11     1     1     1     1     1     1     1     1     1     1     1     1
    12     1     1     1     1     1     1     1     1     1     1     1     1
    13     1     1     1     1     1     1     1     1     1     1     1     1
    14     1     1     1     1     1     1     1     1     1     1     1     1
    15     1     1     1     1     1     1     1     1     1     1     1     1
    16     1     1     1     1     1     1     1     1     1     1     1     1
    17     1     1     1     1     1     1     1     1     1     1     1     1
    18     1     1     1     1     1     1     1     1     1     1     1     1
    19     1     1     1     1     1     1     1     1     1     1     1     1
    20     1     1     1     1     1     1     1     1     1     1     1     1
    21     3     4     9     2     7     6     5     5    10    11     3     6
    22     3     4     4     2     4     4     3     3     3     3     2     2
    23     3     4     7     2     5     6     5     5     7     7     3     6
    24     2     2     5     2     4     4     3     5     6     5     3     6
    25     3     4     9     2     7     6     5     5    10    11     3     6
    26     2     2     2     2     2     2     3     2     2     2     1     1
    27     1     1     1     1     2     1     1     1     2     1     1     1
    28     1     1     2     1     2     2     2     2     2     2     2     2
    29     1     2     3     1     3     2     3     2     2     3     2     2
    30     1     2     4     1     6     4     4     3     5     5     3     4
    31     1     1     4     1     6     5     6     2     1     3     3     4
        V355  V356  V357  V358  V359  V360  V361  V362  V363  V364  V365  V366
    1    B_6   B_6   B_6   B_6   B_6   B_6   B_6   B_6   B_6   B_6   B_6   B_6
    2    A_6   B_1   B_2   B_3   B_4   B_5   B_6   C_1   C_2   C_3   C_4   C_5
    3     14   801  2820  1652   728  2645  6996     5   138   112    22   379
    4      1     7     6     6     5     6     6     1     3     4     2     4
    5      6     9     9     9     9     9     9     4     9     9     6     9
    6      3     3     3     3     3     3     3     2     3     3     3     3
    7      2     3     3     3     3     3     3     2     3     3     3     3
    8      9   323   614   486   194   616   814     3    72    58    14   153
    9      9   310   942   575   200   742   806     3    76    57    13   173
    10     9   421  1078   740   288   966   972     3    82    67    16   186
    11     1     1     1     1     1     1     1     1     1     1     1     1
    12     1     1     1     1     1     1     1     1     1     1     1     1
    13     1     1     1     1     1     1     1     1     1     1     1     1
    14     1     1     1     1     1     1     1     1     1     1     1     1
    15     1     1     1     1     1     1     1     1     1     1     1     1
    16     1     1     1     1     1     1     1     1     1     1     1     1
    17     1     1     1     1     1     1     1     1     1     1     1     1
    18     1     1     1     1     1     1     1     1     1     1     1     1
    19     1     1     1     1     1     1     1     1     1     1     1     1
    20     1     1     1     1     1     1     1     1     1     1     1     1
    21     5    18    19    25    13    19    22     2    11    13     5    16
    22     2     5     6     6     3     5     6     2     3     3     3     5
    23     3    10    10    10     9    11    11     2     9    11     4    11
    24     3     6     6     6     6     6     6     2     5     6     4     6
    25     5    18    19    25    13    19    22     2    11    13     5    16
    26     1     2     2     2     2     2     2     2     2     2     2     2
    27     1     2     2     2     2     2     2     1     2     2     2     2
    28     2     2     2     2     2     2     2     1     2     2     2     2
    29     3     3     3     3     3     3     3     1     3     3     2     3
    30     5     9    10     9     7     9    11     1     6     7     5     8
    31     5     8     8     8     8     8     9     2     6     5     7     8
        V367  V368  V369  V370  V371  V372  V373  V374  V375  V376  V377  V378
    1    B_6   B_6   B_6   B_6   B_6   B_6   B_6   B_6   B_6   B_6   B_6   B_6
    2    C_6   D_2   D_3   D_4   D_5   D_6   E_2   E_4   E_5   E_6   F_2   F_3
    3    349     8     6     7    59    89     2     1     8    13     9    10
    4      5     1     1     1     3     4     1     1     2     1     1     2
    5      9     3     4     3     9     8     2     1     4     5     3     3
    6      3     2     1     1     3     3     2     1     3     3     2     2
    7      3     2     3     2     2     3     1     1     2     3     2     2
    8    162     6     4     4    33    45     2     1     7     8     5     6
    9    183     6     4     4    32    50     2     1     6     8     5     5
    10   195     5     4     4    37    51     2     1     7     9     5     7
    11     1     1     1     1     1     1     1     1     1     1     1     1
    12     1     1     1     1     1     1     1     1     1     1     1     1
    13     1     1     1     1     1     1     1     1     1     1     1     1
    14     1     1     1     1     1     1     1     1     1     1     1     1
    15     1     1     1     1     1     1     1     1     1     1     1     1
    16     1     1     1     1     1     1     1     1     1     1     1     1
    17     1     1     1     1     1     1     1     1     1     1     1     1
    18     1     1     1     1     1     1     1     1     1     1     1     1
    19     1     1     1     1     1     1     1     1     1     1     1     1
    20     1     1     1     1     1     1     1     1     1     1     1     1
    21    14     3     2     2     8    10     2     1     3     3     4     7
    22     5     2     2     2     4     5     1     1     2     3     4     3
    23    10     3     2     2     6     9     2     1     3     2     4     5
    24     5     3     2     1     4     5     2     1     3     1     3     3
    25    14     3     2     2     8    10     2     1     3     3     4     7
    26     2     2     1     2     2     2     1     1     2     2     2     2
    27     2     1     1     1     1     1     1     1     1     1     1     1
    28     2     2     2     2     2     2     2     1     1     2     2     2
    29     3     3     1     2     3     3     1     1     2     2     1     2
    30     8     3     2     3     5     5     2     1     2     3     2     3
    31     8     1     2     4     7     6     1     1     2     4     1     2
        V379  V380  V381  V382  V383  V384  V385  V386  V387  V388  V389  V390
    1    B_6   B_6   B_6   C_1   C_1   C_1   C_1   C_1   C_1   C_1   C_1   C_1
    2    F_5   F_6  <NA>   A_1   A_2   A_3   A_4   A_5   A_6   B_1   B_2   B_3
    3     31    16     9     3     2     7     6     4     1     4     8     7
    4      3     1     3     1     1     1     1     2     1     1     1     2
    5      5     6     4     3     2     3     3     4     1     3     1     5
    6      3     3     2     3     1     2     1     2     1     2     1     3
    7      3     2     2     1     2     2     1     3     1     2     2     2
    8     22     9     6     2     2     3     3     4     1     3     5     7
    9     19     8     2     3     2     5     3     4     1     3     7     7
    10    23     9     6     3     2     5     3     4     1     3     7     7
    11     1     1     1     1     1     1     1     1     1     1     1     1
    12     1     1     1     1     1     1     1     1     1     1     1     1
    13     1     1     1     1     1     1     1     1     1     1     1     1
    14     1     1     1     1     1     1     1     1     1     1     1     1
    15     1     1     1     1     1     1     1     1     1     1     1     1
    16     1     1     1     1     1     1     1     1     1     1     1     1
    17     1     1     1     1     1     1     1     1     1     1     1     1
    18     1     1     1     1     1     1     1     1     1     1     1     1
    19     1     1     1     1     1     1     1     1     1     1     1     1
    20     1     1     1     1     1     1     1     1     1     1     1     1
    21     8     6     5     3     2     2     3     2     1     2     1     6
    22     4     4     3     3     2     1     3     1     1     2     1     3
    23     6     4     4     3     2     2     2     2     1     2     1     5
    24     5     3     4     2     1     2     2     2     1     2     1     4
    25     8     6     5     3     2     2     3     2     1     2     1     6
    26     2     2     2     2     2     1     2     1     1     2     1     2
    27     2     1     1     2     1     1     1     1     1     1     1     1
    28     2     2     1     2     1     1     1     1     1     1     1     2
    29     2     2     2     2     1     1     2     1     1     1     1     3
    30     5     4     2     3     1     1     2     1     1     1     1     4
    31     6     5     3     2     1     2     2     3     1     1     2     2
        V391  V392  V393  V394  V395  V396  V397  V398  V399  V400  V401  V402
    1    C_1   C_1   C_1   C_1   C_1   C_1   C_1   C_1   C_1   C_1   C_1   C_1
    2    B_4   B_5   B_6   C_1   C_2   C_3   C_4   C_5   C_6   D_5   D_6   E_6
    3      1    12     3  1299  1870   789   218   897   156     3     5     2
    4      1     1     1     6     7     7     4     7     3     1     1     1
    5      1     5     2     9     9     9     9     9     8     3     2     1
    6      1     3     1     3     3     3     3     3     3     3     2     1
    7      1     2     2     3     3     3     3     3     3     2     2     2
    8      1     8     2    76    84    76    39    80    35     3     3     1
    9      1     8     2    75   522   294   101   429    79     3     3     2
    10     1     8     2   404   754   441   136   521    97     3     3     2
    11     1     1     1     1     1     1     1     1     1     1     1     1
    12     1     1     1     1     1     1     1     1     1     1     1     1
    13     1     1     1     1     1     1     1     1     1     1     1     1
    14     1     1     1     1     1     1     1     1     1     1     1     1
    15     1     1     1     1     1     1     1     1     1     1     1     1
    16     1     1     1     1     1     1     1     1     1     1     1     1
    17     1     1     1     1     1     1     1     1     1     1     1     1
    18     1     1     1     1     1     1     1     1     1     1     1     1
    19     1     1     1     1     1     1     1     1     1     1     1     1
    20     1     1     1     1     1     1     1     1     1     1     1     1
    21     1     5     2    19    21    13    10    19     8     3     2     1
    22     1     3     2     6     6     4     3     6     3     2     2     1
    23     1     5     2    11    12    10     7    12     7     3     2     1
    24     1     4     2     6     6     6     6     6     6     3     2     1
    25     1     5     2    19    21    13    10    19     8     3     2     1
    26     1     2     1     2     2     2     2     2     2     1     1     1
    27     1     1     1     2     2     2     2     2     2     1     1     1
    28     1     2     1     2     2     2     2     2     2     1     1     2
    29     1     2     1     3     3     3     3     3     3     2     2     1
    30     1     3     1    10    10     8     8    10     7     2     2     2
    31     1     3     2     8     8     8     8     8     7     1     1     2
        V403  V404  V405  V406  V407  V408  V409  V410  V411  V412  V413  V414
    1    C_1   C_1   C_1   C_1   C_2   C_2   C_2   C_2   C_2   C_2   C_2   C_2
    2    F_2   F_3   F_4   F_5   A_1   A_2   A_3   A_4   A_5   A_6   B_1   B_2
    3      3     5     1     5    25    43    47    16    82     6    77   235
    4      1     1     1     1     3     3     4     1     3     2     3     3
    5      3     2     1     3     6     7     8     7     8     4     9     9
    6      3     2     1     2     3     3     3     3     3     3     3     3
    7      3     1     1     2     3     3     3     2     3     3     3     3
    8      2     2     1     3    19    34    29    13    39     5    47   115
    9      3     2     1     5    21    35    29    13    36     5    43   120
    10     3     3     1     5    20    34    29    13    47     5    50   148
    11     1     1     1     1     1     1     1     1     1     1     1     1
    12     1     1     1     1     1     1     1     1     1     1     1     1
    13     1     1     1     1     1     1     1     1     1     1     1     1
    14     1     1     1     1     1     1     1     1     1     1     1     1
    15     1     1     1     1     1     1     1     1     1     1     1     1
    16     1     1     1     1     1     1     1     1     1     1     1     1
    17     1     1     1     1     1     1     1     1     1     1     1     1
    18     1     1     1     1     1     1     1     1     1     1     1     1
    19     1     1     1     1     1     1     1     1     1     1     1     1
    20     1     1     1     1     1     1     1     1     1     1     1     1
    21     2     3     1     3     6     8     8     4    11     4    10    15
    22     1     2     1     2     3     3     3     2     4     3     4     4
    23     2     2     1     2     6     7     7     4     9     4     8    11
    24     2     2     1     2     4     4     5     3     6     4     5     6
    25     2     3     1     3     6     8     8     4    11     4    10    15
    26     1     1     1     1     2     2     2     2     2     2     2     2
    27     1     1     1     1     1     2     1     1     2     1     2     2
    28     1     2     1     2     2     2     2     2     2     1     2     2
    29     1     2     1     3     2     3     3     2     3     1     2     3
    30     1     3     1     4     4     6     4     4     7     1     5     7
    31     3     2     1     3     3     3     5     3     7     1     7     8
        V415  V416  V417  V418  V419  V420  V421  V422  V423  V424  V425  V426
    1    C_2   C_2   C_2   C_2   C_2   C_2   C_2   C_2   C_2   C_2   C_2   C_2
    2    B_3   B_4   B_5   B_6   C_1   C_2   C_3   C_4   C_5   C_6   D_2   D_3
    3    180   100   170   155  1821 37160  9310  3338 15486  3198    19    24
    4      4     3     3     3     7     7     6     6     6     6     1     1
    5      9     8     8     9     9     9     9     9     9     9     5     5
    6      3     3     3     3     3     3     3     3     3     3     3     3
    7      3     3     3     3     3     3     3     3     3     3     2     2
    8    112    49    99    76   517  2131  1409   808  1722   737    12    15
    9    102    42    97    68    86  2123  1145   486  2351   684    11    12
    10   132    64   116    88   723  3547  2480  1167  3587  1096    15    15
    11     1     1     1     1     1     1     1     1     1     1     1     1
    12     1     1     1     1     1     1     1     1     1     1     1     1
    13     1     1     1     1     1     1     1     1     1     1     1     1
    14     1     1     1     1     1     1     1     1     1     1     1     1
    15     1     1     1     1     1     1     1     1     1     1     1     1
    16     1     1     1     1     1     1     1     1     1     1     1     1
    17     1     1     1     1     1     1     1     1     1     1     1     1
    18     1     1     1     1     1     1     1     1     1     1     1     1
    19     1     1     1     1     1     1     1     1     1     1     1     1
    20     1     1     1     1     1     1     1     1     1     1     1     1
    21    13     9    14    13    22    31    26    26    31    23     6     8
    22     5     2     5     4     6     6     6     6     6     6     3     5
    23    10     9    10    10    12    12    12    12    12    12     5     7
    24     5     5     6     6     6     6     6     6     6     6     3     4
    25    13     9    14    13    22    31    26    26    31    23     6     8
    26     2     2     2     2     2     2     2     2     2     2     2     2
    27     1     2     1     2     2     2     2     2     2     2     1     1
    28     2     2     2     2     2     2     2     2     2     2     2     2
    29     3     3     3     3     3     3     3     3     3     3     2     3
    30     6     6     6     7    10    12    12     9    12     9     4     6
    31     6     6     7     6     8     9     8     8     8     8     4     4
        V427  V428  V429  V430  V431  V432  V433  V434  V435  V436  V437  V438
    1    C_2   C_2   C_2   C_2   C_2   C_2   C_2   C_2   C_2   C_2   C_2   C_2
    2    D_4   D_5   D_6   E_2   E_3   E_4   E_5   E_6   F_1   F_2   F_3   F_4
    3      7    64    92    12    12     7    46    33     5    32    69    14
    4      2     3     1     1     2     1     1     1     2     2     3     1
    5      2     9     8     6     5     3     6     5     2     9     7     6
    6      2     3     3     3     2     3     3     3     2     3     3     3
    7      2     3     3     2     2     2     3     3     3     3     3     2
    8      3    46    65     8     9     5    19    23     3    18    41    11
    9      3    45    54     8     8     5    23    19     3    20    29     7
    10     3    48    63     8    10     5    24    20     3    19    37    10
    11     1     1     1     1     1     1     1     1     1     1     1     1
    12     1     1     1     1     1     1     1     1     1     1     1     1
    13     1     1     1     1     1     1     1     1     1     1     1     1
    14     1     1     1     1     1     1     1     1     1     1     1     1
    15     1     1     1     1     1     1     1     1     1     1     1     1
    16     1     1     1     1     1     1     1     1     1     1     1     1
    17     1     1     1     1     1     1     1     1     1     1     1     1
    18     1     1     1     1     1     1     1     1     1     1     1     1
    19     1     1     1     1     1     1     1     1     1     1     1     1
    20     1     1     1     1     1     1     1     1     1     1     1     1
    21     3     6     9     4     6     3     6     4     1     5    11     4
    22     3     4     4     2     3     2     3     2     1     3     4     2
    23     2     5     8     2     5     3     4     3     1     4     8     3
    24     1     5     5     2     4     3     4     3     1     4     5     3
    25     3     6     9     4     6     3     6     4     1     5    11     4
    26     2     2     2     1     2     1     1     1     1     2     2     1
    27     1     1     2     1     2     1     1     1     1     2     1     1
    28     1     2     2     2     2     2     2     2     1     2     2     2
    29     1     2     3     2     2     2     3     2     2     2     2     3
    30     1     4     6     3     4     3     6     4     2     5     4     5
    31     2     4     4     2     2     1     5     4     2     5     6     3
        V439  V440  V441  V442  V443  V444  V445  V446  V447  V448  V449  V450
    1    C_2   C_2   C_2   C_3   C_3   C_3   C_3   C_3   C_3   C_3   C_3   C_3
    2    F_5   F_6  <NA>   A_1   A_2   A_3   A_4   A_5   A_6   B_1   B_2   B_3
    3    121    12     9    34    61   128    44    96    21    65   215   249
    4      1     1     2     4     3     3     3     2     2     3     4     3
    5      8     4     6     8     9     9     7     9     5     9     9     9
    6      3     3     3     3     3     3     3     3     3     3     3     3
    7      3     3     2     3     3     3     3     3     2     3     3     3
    8     60    12     3    18    43    51    23    42    11    35    94   117
    9     53    10     1    20    48    60    27    55    11    38   116   138
    10    64    11     4    18    45    73    29    52    12    40   126   154
    11     1     1     1     1     1     1     1     1     1     1     1     1
    12     1     1     1     1     1     1     1     1     1     1     1     1
    13     1     1     1     1     1     1     1     1     1     1     1     1
    14     1     1     1     1     1     1     1     1     1     1     1     1
    15     1     1     1     1     1     1     1     1     1     1     1     1
    16     1     1     1     1     1     1     1     1     1     1     1     1
    17     1     1     1     1     1     1     1     1     1     1     1     1
    18     1     1     1     1     1     1     1     1     1     1     1     1
    19     1     1     1     1     1     1     1     1     1     1     1     1
    20     1     1     1     1     1     1     1     1     1     1     1     1
    21    10     5     3     9    14    14     6     8     7     8    14    14
    22     3     2     2     4     5     4     2     3     3     4     3     3
    23     9     3     3     8    10    11     6     7     6     7    10    11
    24     6     3     3     5     6     6     3     4     4     5     6     6
    25    10     5     3     9    14    14     6     8     7     8    14    14
    26     2     1     2     2     2     2     2     2     2     2     2     2
    27     1     1     1     2     1     2     1     2     1     1     2     2
    28     2     2     2     2     2     2     2     2     2     2     2     2
    29     3     2     1     3     3     3     2     3     2     2     3     3
    30     6     3     2     6     5     6     4     6     4     4     7     7
    31     7     4     3     3     5     6     5     6     4     6     7     6
        V451  V452  V453  V454  V455  V456  V457  V458  V459  V460  V461  V462
    1    C_3   C_3   C_3   C_3   C_3   C_3   C_3   C_3   C_3   C_3   C_3   C_3
    2    B_4   B_5   B_6   C_1   C_2   C_3   C_4   C_5   C_6   D_2   D_3   D_4
    3     85   198   113   795  9236 23555  2430 12380  2090     8    34    11
    4      2     3     3     7     7     6     7     7     6     1     2     1
    5      9     9     8     9     9     9     9     9     9     5     6     3
    6      3     3     3     3     3     3     3     3     3     3     3     2
    7      3     3     3     3     3     3     3     3     3     2     3     2
    8     40    90    56   306  1132  1713   626  1443   554     5    20     5
    9     50   118    70    74  1418  1697   449  2374   641     5    19     5
    10    56   116    72   425  2449  3144   911  3217   854     5    22     5
    11     1     1     1     1     1     1     1     1     1     1     1     1
    12     1     1     1     1     1     1     1     1     1     1     1     1
    13     1     1     1     1     1     1     1     1     1     1     1     1
    14     1     1     1     1     1     1     1     1     1     1     1     1
    15     1     1     1     1     1     1     1     1     1     1     1     1
    16     1     1     1     1     1     1     1     1     1     1     1     1
    17     1     1     1     1     1     1     1     1     1     1     1     1
    18     1     1     1     1     1     1     1     1     1     1     1     1
    19     1     1     1     1     1     1     1     1     1     1     1     1
    20     1     1     1     1     1     1     1     1     1     1     1     1
    21    11    12    11    17    25    31    26    28    25     4    13     4
    22     4     4     4     5     6     6     6     6     6     3     5     3
    23    10     9    10    11    12    12    12    12    12     4     8     4
    24     6     5     6     6     6     6     6     6     6     3     5     4
    25    11    12    11    17    25    31    26    28    25     4    13     4
    26     2     2     2     2     2     2     2     2     2     2     2     2
    27     2     1     2     2     2     2     2     2     2     1     1     1
    28     2     2     2     2     2     2     2     2     2     2     2     2
    29     3     3     3     3     3     3     3     3     3     2     3     2
    30     7     5     7     8    12    12    11    12    10     3     5     3
    31     8     7     7     8     8     9     8     8     8     2     6     2
        V463  V464  V465  V466  V467  V468  V469  V470  V471  V472  V473  V474
    1    C_3   C_3   C_3   C_3   C_3   C_3   C_3   C_3   C_3   C_3   C_3   C_3
    2    D_5   D_6   E_2   E_3   E_4   E_5   E_6   F_1   F_2   F_3   F_4   F_5
    3     80    89    13    17     4    38    18     3    20    53    16   105
    4      2     2     1     1     1     1     1     1     2     3     2     2
    5      9     7     6     7     2     6     4     2     5     8     6     8
    6      3     3     3     3     2     3     3     2     3     3     3     3
    7      3     2     3     2     2     3     3     3     3     3     3     3
    8     49    55     8    14     3    24    10     3    11    33    13    36
    9     45    54    10    11     2    22    11     2    15    33    13    55
    10    55    61     9    14     3    21    12     3    15    39    12    57
    11     1     1     1     1     1     1     1     1     1     1     1     1
    12     1     1     1     1     1     1     1     1     1     1     1     1
    13     1     1     1     1     1     1     1     1     1     1     1     1
    14     1     1     1     1     1     1     1     1     1     1     1     1
    15     1     1     1     1     1     1     1     1     1     1     1     1
    16     1     1     1     1     1     1     1     1     1     1     1     1
    17     1     1     1     1     1     1     1     1     1     1     1     1
    18     1     1     1     1     1     1     1     1     1     1     1     1
    19     1     1     1     1     1     1     1     1     1     1     1     1
    20     1     1     1     1     1     1     1     1     1     1     1     1
    21    11    10     4     8     3     7     2     2     6    11     4    12
    22     6     4     3     4     2     5     2     1     2     5     2     4
    23     7     8     3     6     3     4     2     2     4     7     3     8
    24     5     6     3     6     3     4     2     2     4     5     3     5
    25    11    10     4     8     3     7     2     2     6    11     4    12
    26     2     2     1     2     1     2     1     1     1     2     1     2
    27     1     1     1     1     1     1     1     1     1     1     2     2
    28     2     2     2     2     1     2     2     1     2     2     2     2
    29     3     2     2     3     2     2     2     2     2     3     3     3
    30     5     4     3     5     2     4     3     2     3     5     6     8
    31     6     5     2     2     2     4     4     1     2     6     4     6
        V475  V476  V477  V478  V479  V480  V481  V482  V483  V484  V485  V486
    1    C_3   C_3   C_4   C_4   C_4   C_4   C_4   C_4   C_4   C_4   C_4   C_4
    2    F_6  <NA>   A_1   A_2   A_3   A_4   A_5   A_6   B_1   B_2   B_3   B_4
    3     16     8     9    19    46    51    49     5    25    60    65    98
    4      2     3     3     3     3     2     1     2     2     1     4     2
    5      5     4     5     6     9     7     7     3     6     8     8     7
    6      3     2     3     3     3     3     3     2     3     3     3     3
    7      3     1     3     2     3     3     2     2     3     3     3     3
    8     14     2     7    12    23    25    22     3    18    29    33    32
    9     14     1     6    14    26    34    32     3    16    30    36    44
    10    15     5     7    14    31    37    30     3    18    37    40    50
    11     1     1     1     1     1     1     1     1     1     1     1     1
    12     1     1     1     1     1     1     1     1     1     1     1     1
    13     1     1     1     1     1     1     1     1     1     1     1     1
    14     1     1     1     1     1     1     1     1     1     1     1     1
    15     1     1     1     1     1     1     1     1     1     1     1     1
    16     1     1     1     1     1     1     1     1     1     1     1     1
    17     1     1     1     1     1     1     1     1     1     1     1     1
    18     1     1     1     1     1     1     1     1     1     1     1     1
    19     1     1     1     1     1     1     1     1     1     1     1     1
    20     1     1     1     1     1     1     1     1     1     1     1     1
    21     7     3     4     4    11    10     7     3     6     9    13    11
    22     4     2     3     4     4     4     2     2     3     3     5     3
    23     5     3     4     3     8     8     7     3     6     8     9    11
    24     4     3     3     3     5     4     5     3     4     5     5     6
    25     7     3     4     4    11    10     7     3     6     9    13    11
    26     2     2     2     2     2     2     2     2     2     2     2     2
    27     1     1     1     1     2     1     1     1     2     1     1     2
    28     2     2     2     2     2     2     2     2     2     2     2     2
    29     2     2     2     3     3     3     2     1     2     3     2     3
    30     4     3     4     4     6     5     4     2     5     5     4     6
    31     5     2     2     2     5     5     5     3     2     6     6     6
        V487  V488  V489  V490  V491  V492  V493  V494  V495  V496  V497  V498
    1    C_4   C_4   C_4   C_4   C_4   C_4   C_4   C_4   C_4   C_4   C_4   C_4
    2    B_5   B_6   C_1   C_2   C_3   C_4   C_5   C_6   D_1   D_2   D_3   D_4
    3     75    21   233  3224  2430  8068  5573   546     1     7    12     4
    4      2     2     5     6     7     6     6     6     1     1     1     1
    5      9     6     9     9     9     9     9     9     1     3     5     4
    6      3     3     3     3     3     3     3     3     1     2     2     3
    7      3     3     3     3     3     3     3     3     1     2     1     2
    8     42    10   100   491   450   755   654   197     1     3     7     4
    9     45    13    40   789   631   759  1372   237     1     3     7     4
    10    49    15   133  1130   940  1249  1646   280     1     3     7     4
    11     1     1     1     1     1     1     1     1     1     1     1     1
    12     1     1     1     1     1     1     1     1     1     1     1     1
    13     1     1     1     1     1     1     1     1     1     1     1     1
    14     1     1     1     1     1     1     1     1     1     1     1     1
    15     1     1     1     1     1     1     1     1     1     1     1     1
    16     1     1     1     1     1     1     1     1     1     1     1     1
    17     1     1     1     1     1     1     1     1     1     1     1     1
    18     1     1     1     1     1     1     1     1     1     1     1     1
    19     1     1     1     1     1     1     1     1     1     1     1     1
    20     1     1     1     1     1     1     1     1     1     1     1     1
    21    10     4    10    27    25    27    29    13     1     3     6     3
    22     4     2     3     6     6     6     6     5     1     2     4     3
    23     8     4     7    12    11    12    12     9     1     3     4     2
    24     6     4     6     6     6     6     6     6     1     3     4     2
    25    10     4    10    27    25    27    29    13     1     3     6     3
    26     2     2     2     2     2     2     2     2     1     1     2     2
    27     1     1     2     2     2     2     2     2     1     1     1     1
    28     2     2     2     2     2     2     2     2     1     2     2     2
    29     3     2     3     3     3     3     3     3     1     2     1     2
    30     6     4     6     9    11    11    10     9     1     3     2     3
    31     6     7     8     8     8     9     8     8     1     3     2     3
        V499  V500  V501  V502  V503  V504  V505  V506  V507  V508  V509  V510
    1    C_4   C_4   C_4   C_4   C_4   C_4   C_4   C_4   C_4   C_4   C_4   C_4
    2    D_5   D_6   E_2   E_3   E_4   E_5   E_6   F_1   F_2   F_3   F_4   F_5
    3     59    29     4     6     8    10     2     4    20    37    43    67
    4      1     1     1     1     2     1     1     1     1     2     1     2
    5      9     5     3     3     2     2     1     2     7     7     6     9
    6      3     3     2     1     2     2     1     2     2     3     3     3
    7      2     3     2     3     2     2     2     2     3     3     3     3
    8     28    15     3     4     4     5     2     2    10    23    24    31
    9     32    14     3     4     3     6     2     3    12    21    22    46
    10    38    14     3     4     3     6     2     2    13    25    28    41
    11     1     1     1     1     1     1     1     1     1     1     1     1
    12     1     1     1     1     1     1     1     1     1     1     1     1
    13     1     1     1     1     1     1     1     1     1     1     1     1
    14     1     1     1     1     1     1     1     1     1     1     1     1
    15     1     1     1     1     1     1     1     1     1     1     1     1
    16     1     1     1     1     1     1     1     1     1     1     1     1
    17     1     1     1     1     1     1     1     1     1     1     1     1
    18     1     1     1     1     1     1     1     1     1     1     1     1
    19     1     1     1     1     1     1     1     1     1     1     1     1
    20     1     1     1     1     1     1     1     1     1     1     1     1
    21    11     7     2     4     2     3     1     1     6     5    10     8
    22     5     4     2     2     2     3     1     1     4     3     6     4
    23     8     6     2     4     1     2     1     1     4     3     6     7
    24     5     4     2     4     1     2     1     1     3     3     5     5
    25    11     7     2     4     2     3     1     1     6     5    10     8
    26     2     2     1     1     1     1     1     1     2     1     2     2
    27     1     1     1     1     1     1     1     1     1     2     2     1
    28     2     2     1     2     2     2     1     2     2     2     2     2
    29     3     2     2     2     2     2     1     1     2     2     3     3
    30     6     4     2     3     3     3     1     2     4     5     6     5
    31     7     5     2     2     3     3     2     2     4     5     8     6
        V511  V512  V513  V514  V515  V516  V517  V518  V519  V520  V521  V522
    1    C_4   C_4   C_5   C_5   C_5   C_5   C_5   C_5   C_5   C_5   C_5   C_5
    2    F_6  <NA>   A_1   A_2   A_3   A_4   A_5   A_6   B_1   B_2   B_3   B_4
    3      6     4    72   163   236   165   340    84   152   540   495   293
    4      1     2     4     5     3     4     4     5     4     5     4     3
    5      1     1     9     9     9     9     9     8     9     9     9     9
    6      1     1     3     3     3     3     3     3     3     3     3     3
    7      1     2     3     3     3     3     3     3     3     3     3     3
    8      2     3    51    97   120    63   140    39   102   273   290   142
    9      2     2    51   102   117    62   158    28    96   283   269   130
    10     2     3    56   107   135    81   186    42   113   323   322   173
    11     1     1     1     1     1     1     1     1     1     1     1     1
    12     1     1     1     1     1     1     1     1     1     1     1     1
    13     1     1     1     1     1     1     1     1     1     1     1     1
    14     1     1     1     1     1     1     1     1     1     1     1     1
    15     1     1     1     1     1     1     1     1     1     1     1     1
    16     1     1     1     1     1     1     1     1     1     1     1     1
    17     1     1     1     1     1     1     1     1     1     1     1     1
    18     1     1     1     1     1     1     1     1     1     1     1     1
    19     1     1     1     1     1     1     1     1     1     1     1     1
    20     1     1     1     1     1     1     1     1     1     1     1     1
    21     2     2     9    13    15    12    15     9    15    20    21    17
    22     2     1     3     3     5     3     3     4     5     6     6     5
    23     2     2     8    10    11    10    10     7    11    10    11    11
    24     2     2     6     6     6     6     6     5     6     6     6     6
    25     2     2     9    13    15    12    15     9    15    20    21    17
    26     2     1     2     2     2     2     2     2     2     2     2     2
    27     1     1     1     2     1     2     2     2     2     2     2     2
    28     1     2     2     2     2     2     2     2     2     2     2     2
    29     2     1     2     3     3     3     3     3     3     3     3     3
    30     2     2     4     7     5     7     7     7     7     7     7     9
    31     2     1     4     7     6     5     8     8     5     7     6     6
        V523  V524  V525  V526  V527  V528  V529  V530  V531  V532  V533  V534
    1    C_5   C_5   C_5   C_5   C_5   C_5   C_5   C_5   C_5   C_5   C_5   C_5
    2    B_5   B_6   C_1   C_2   C_3   C_4   C_5   C_6   D_2   D_3   D_4   D_5
    3    784   376   921 15526 12314  5496 84728  8073    17    37    20   412
    4      5     4     7     6     6     6     6     6     1     2     2     4
    5      9     9     9     9     9     9     9     9     6     9     8     9
    6      3     3     3     3     3     3     3     3     3     3     3     3
    7      3     3     3     3     3     3     3     3     2     3     3     3
    8    321   175   443  2388  2382  1386  4679  1799    14    24    13   206
    9    330   158    75  1739  1449   651  4694  1395    10    22    12   143
    10   410   195   507  3597  3240  1636  6037  2332    15    26    17   216
    11     1     1     1     1     1     1     1     1     1     1     1     1
    12     1     1     1     1     1     1     1     1     1     1     1     1
    13     1     1     1     1     1     1     1     1     1     1     1     1
    14     1     1     1     1     1     1     1     1     1     1     1     1
    15     1     1     1     1     1     1     1     1     1     1     1     1
    16     1     1     1     1     1     1     1     1     1     1     1     1
    17     1     1     1     1     1     1     1     1     1     1     1     1
    18     1     1     1     1     1     1     1     1     1     1     1     1
    19     1     1     1     1     1     1     1     1     1     1     1     1
    20     1     1     1     1     1     1     1     1     1     1     1     1
    21    20    16    13    33    28    30    35    28     7    10     5    22
    22     6     5     4     6     6     6     6     6     3     5     3     6
    23    11    11    11    12    12    12    12    12     6     7     5    10
    24     6     6     6     6     6     6     6     6     5     6     4     6
    25    20    16    13    33    28    30    35    28     7    10     5    22
    26     2     2     2     2     2     2     2     2     2     2     2     2
    27     2     2     2     2     2     2     2     2     1     1     1     2
    28     2     2     2     2     2     2     2     2     2     2     2     2
    29     3     3     3     3     3     3     3     3     3     2     2     3
    30     8     7    10    12    12    10    12    10     5     4     4     8
    31     8     8     8     8     8     8     9     8     3     4     6     8
        V535  V536  V537  V538  V539  V540  V541  V542  V543  V544  V545  V546
    1    C_5   C_5   C_5   C_5   C_5   C_5   C_5   C_5   C_5   C_5   C_5   C_5
    2    D_6   E_1   E_2   E_3   E_4   E_5   E_6   F_1   F_2   F_3   F_4   F_5
    3    249     2    28    32    22   136   115    12   117   241    77   390
    4      3     1     1     2     1     2     4     2     2     4     1     2
    5      9     1     7     6     5     8     7     6     9     9     9     9
    6      3     1     3     3     3     3     3     2     3     3     3     3
    7      3     1     3     3     2     3     3     3     3     3     3     3
    8    148     1    20    26    18    73    60    11    70   112    47   171
    9    113     1    16    19    11    59    42     9    65    85    34   168
    10   149     1    20    23    17    79    61    11    88   123    51   211
    11     1     1     1     1     1     1     1     1     1     1     1     1
    12     1     1     1     1     1     1     1     1     1     1     1     1
    13     1     1     1     1     1     1     1     1     1     1     1     1
    14     1     1     1     1     1     1     1     1     1     1     1     1
    15     1     1     1     1     1     1     1     1     1     1     1     1
    16     1     1     1     1     1     1     1     1     1     1     1     1
    17     1     1     1     1     1     1     1     1     1     1     1     1
    18     1     1     1     1     1     1     1     1     1     1     1     1
    19     1     1     1     1     1     1     1     1     1     1     1     1
    20     1     1     1     1     1     1     1     1     1     1     1     1
    21    20     1     4     6     7    11     6     5    10    14     6    15
    22     6     1     2     3     3     5     2     3     3     4     2     5
    23     9     1     3     4     5     8     4     5     6     9     4     7
    24     5     1     3     3     4     6     4     3     5     5     4     6
    25    20     1     4     6     7    11     6     5    10    14     6    15
    26     2     1     1     2     2     2     1     2     2     2     1     2
    27     2     1     1     1     1     1     1     1     1     1     1     2
    28     2     2     2     2     2     2     2     2     2     2     2     2
    29     3     1     3     2     3     3     3     1     3     3     3     3
    30     8     2     5     4     5     6     5     2     5     6     5     6
    31     7     1     4     5     5     6     7     4     8     7     7     6
        V547  V548  V549  V550  V551  V552  V553  V554  V555  V556  V557  V558
    1    C_5   C_5   C_6   C_6   C_6   C_6   C_6   C_6   C_6   C_6   C_6   C_6
    2    F_6  <NA>   A_1   A_2   A_3   A_4   A_5   A_6   B_1   B_2   B_3   B_4
    3     42    18    24    76    79    17   135    39    97   322   299   147
    4      2     2     3     2     2     2     1     2     3     4     3     2
    5      7     4     7     9     9     5     9     8     9     9     9     9
    6      3     2     3     3     3     3     3     3     3     3     3     3
    7      3     2     3     3     3     3     3     3     3     3     3     3
    8     27    12    17    48    54    13    59    21    61   177   165    71
    9     22     1    16    53    56    10    80    18    63   192   161    73
    10    29    10    17    53    55    12    78    22    68   210   187    86
    11     1     1     1     1     1     1     1     1     1     1     1     1
    12     1     1     1     1     1     1     1     1     1     1     1     1
    13     1     1     1     1     1     1     1     1     1     1     1     1
    14     1     1     1     1     1     1     1     1     1     1     1     1
    15     1     1     1     1     1     1     1     1     1     1     1     1
    16     1     1     1     1     1     1     1     1     1     1     1     1
    17     1     1     1     1     1     1     1     1     1     1     1     1
    18     1     1     1     1     1     1     1     1     1     1     1     1
    19     1     1     1     1     1     1     1     1     1     1     1     1
    20     1     1     1     1     1     1     1     1     1     1     1     1
    21    10     4     6     7    11     6     9     4    10    20    16     9
    22     4     2     3     4     5     3     4     2     3     6     5     2
    23     7     4     5     5     9     6     8     4    10    12    11     9
    24     4     3     4     4     6     4     5     3     6     6     6     6
    25    10     4     6     7    11     6     9     4    10    20    16     9
    26     2     2     2     2     2     2     2     2     2     2     2     2
    27     1     1     1     1     1     2     1     1     2     2     1     1
    28     2     2     2     2     2     2     2     2     2     2     2     2
    29     3     2     2     3     3     2     3     2     3     3     3     3
    30     5     4     4     5     6     5     6     4     6     8     6     6
    31     6     3     3     2     5     3     7     6     5     8     6     7
        V559  V560  V561  V562  V563  V564  V565  V566  V567  V568  V569  V570
    1    C_6   C_6   C_6   C_6   C_6   C_6   C_6   C_6   C_6   C_6   C_6   C_6
    2    B_5   B_6   C_1   C_2   C_3   C_4   C_5   C_6   D_1   D_2   D_3   D_4
    3    457   335   162  3306  2029   523  7991 16096     1    17     9    28
    4      5     5     3     6     7     5     6     6     1     1     2     1
    5      9     9     9     9     9     9     9     9     1     6     5     5
    6      3     3     3     3     3     3     3     3     1     3     3     3
    7      3     3     3     3     3     3     3     3     1     2     2     2
    8    182   172    84   676   627   231  1385  1621     1    12     7    14
    9    204   151    30   737   531   197  1836  1626     1    10     7    11
    10   233   186   100  1098   846   270  2320  1946     1    12     7    15
    11     1     1     1     1     1     1     1     1     1     1     1     1
    12     1     1     1     1     1     1     1     1     1     1     1     1
    13     1     1     1     1     1     1     1     1     1     1     1     1
    14     1     1     1     1     1     1     1     1     1     1     1     1
    15     1     1     1     1     1     1     1     1     1     1     1     1
    16     1     1     1     1     1     1     1     1     1     1     1     1
    17     1     1     1     1     1     1     1     1     1     1     1     1
    18     1     1     1     1     1     1     1     1     1     1     1     1
    19     1     1     1     1     1     1     1     1     1     1     1     1
    20     1     1     1     1     1     1     1     1     1     1     1     1
    21    18    14     5    22    23    13    28    30     1     6     5     7
    22     5     4     1     6     6     5     6     6     1     4     2     4
    23    11    11     5    12    12     8    12    12     1     4     4     6
    24     6     6     5     6     6     5     6     6     1     3     4     5
    25    18    14     5    22    23    13    28    30     1     6     5     7
    26     2     2     1     2     2     2     2     2     1     2     1     2
    27     2     2     2     2     2     2     2     2     1     2     1     1
    28     2     2     2     2     2     2     2     2     1     2     2     2
    29     3     3     3     3     3     3     3     3     1     2     3     2
    30     7     8     7     9    10     7    10    11     1     5     5     4
    31     7     8     7     8     8     8     8     9     1     4     3     7
        V571  V572  V573  V574  V575  V576  V577  V578  V579  V580  V581  V582
    1    C_6   C_6   C_6   C_6   C_6   C_6   C_6   C_6   C_6   C_6   C_6   C_6
    2    D_5   D_6   E_1   E_2   E_3   E_4   E_5   E_6   F_1   F_2   F_3   F_4
    3    183   208     2    13    22    13    48    89     7    38    38    17
    4      3     3     1     1     2     1     3     3     1     1     3     1
    5      9     9     1     4     7     4     8     9     4     7     8     8
    6      3     3     1     3     3     3     3     3     2     3     3     3
    7      3     3     1     3     3     2     3     3     3     3     3     2
    8     92   120     1     9    15     7    27    45     6    24    27     9
    9     76   111     1    10    14     7    26    34     5    22    24    13
    10   102   122     1     9    15     7    30    49     6    27    28    10
    11     1     1     1     1     1     1     1     1     1     1     1     1
    12     1     1     1     1     1     1     1     1     1     1     1     1
    13     1     1     1     1     1     1     1     1     1     1     1     1
    14     1     1     1     1     1     1     1     1     1     1     1     1
    15     1     1     1     1     1     1     1     1     1     1     1     1
    16     1     1     1     1     1     1     1     1     1     1     1     1
    17     1     1     1     1     1     1     1     1     1     1     1     1
    18     1     1     1     1     1     1     1     1     1     1     1     1
    19     1     1     1     1     1     1     1     1     1     1     1     1
    20     1     1     1     1     1     1     1     1     1     1     1     1
    21    15    12     1     2     4     3     5     6     3     6     8     3
    22     5     4     1     1     4     2     3     3     3     3     4     2
    23     7     9     1     2     3     3     4     5     2     4     6     3
    24     5     6     1     2     3     2     3     4     2     4     4     3
    25    15    12     1     2     4     3     5     6     3     6     8     3
    26     2     2     1     1     2     2     2     2     1     2     2     1
    27     2     2     1     1     1     1     2     1     1     1     2     1
    28     2     2     1     2     2     2     2     2     2     2     2     2
    29     3     3     1     2     3     2     2     2     3     2     2     3
    30     6     6     1     3     5     3     6     4     4     4     5     4
    31     7     8     1     3     5     3     5     7     2     3     6     4
        V583  V584  V585  V586  V587  V588  V589  V590  V591  V592  V593  V594
    1    C_6   C_6   C_6   D_1   D_1   D_1   D_1   D_1   D_1   D_1   D_1   D_1
    2    F_5   F_6  <NA>   A_2   B_1   B_2   B_3   D_1   D_2   D_3   D_4   D_5
    3    130    65     6     1     1     1     1    26    21    21    13    12
    4      2     2     2     1     1     1     1     3     2     1     1     3
    5      8     8     3     1     1     1     1     7     6     5     5     4
    6      3     3     2     1     1     1     1     3     3     3     3     3
    7      3     3     2     1     1     1     1     2     3     2     2     2
    8     72    33     4     1     1     1     1     9     9     6     3     7
    9     66    28     1     1     1     1     1     8    15    12     6    10
    10    82    37     4     1     1     1     1    10    17    16     6     9
    11     1     1     1     1     1     1     1     1     1     1     1     1
    12     1     1     1     1     1     1     1     1     1     1     1     1
    13     1     1     1     1     1     1     1     1     1     1     1     1
    14     1     1     1     1     1     1     1     1     1     1     1     1
    15     1     1     1     1     1     1     1     1     1     1     1     1
    16     1     1     1     1     1     1     1     1     1     1     1     1
    17     1     1     1     1     1     1     1     1     1     1     1     1
    18     1     1     1     1     1     1     1     1     1     1     1     1
    19     1     1     1     1     1     1     1     1     1     1     1     1
    20     1     1     1     1     1     1     1     1     1     1     1     1
    21     9     8     3     1     1     1     1     6     5     7     2     3
    22     4     4     2     1     1     1     1     3     3     3     1     1
    23     6     6     3     1     1     1     1     5     5     6     2     3
    24     5     5     2     1     1     1     1     4     4     5     2     3
    25     9     8     3     1     1     1     1     6     5     7     2     3
    26     2     2     2     1     1     1     1     2     2     2     1     1
    27     2     1     1     1     1     1     1     2     2     1     1     1
    28     2     2     2     1     1     1     1     2     2     2     2     2
    29     3     3     2     1     1     1     1     2     2     2     1     2
    30     7     6     3     1     1     1     1     5     5     4     2     3
    31     7     8     1     1     1     1     1     3     7     6     5     5
        V595  V596  V597  V598  V599  V600  V601  V602  V603  V604  V605  V606
    1    D_1   D_2   D_2   D_2   D_2   D_2   D_2   D_2   D_2   D_2   D_2   D_2
    2    D_6   A_1   A_2   A_4   A_5   B_1   B_2   B_3   B_4   B_5   B_6   C_2
    3      1     7     9     1     3     7    12    12     1     5    12    10
    4      1     1     2     1     1     2     1     1     1     2     1     1
    5      1     3     6     1     2     4     6     6     1     3     3     4
    6      1     3     2     1     1     2     3     2     1     3     3     3
    7      1     2     2     1     1     3     2     3     1     2     3     2
    8      1     3     6     1     2     3     6     7     1     3     6     8
    9      1     3     6     1     2     3     8     8     1     4     6     8
    10     1     3     6     1     2     4     7     7     1     3     6     9
    11     1     1     1     1     1     1     1     1     1     1     1     1
    12     1     1     1     1     1     1     1     1     1     1     1     1
    13     1     1     1     1     1     1     1     1     1     1     1     1
    14     1     1     1     1     1     1     1     1     1     1     1     1
    15     1     1     1     1     1     1     1     1     1     1     1     1
    16     1     1     1     1     1     1     1     1     1     1     1     1
    17     1     1     1     1     1     1     1     1     1     1     1     1
    18     1     1     1     1     1     1     1     1     1     1     1     1
    19     1     1     1     1     1     1     1     1     1     1     1     1
    20     1     1     1     1     1     1     1     1     1     1     1     1
    21     1     2     5     1     2     3     3     3     1     3     2     4
    22     1     2     3     1     1     2     2     2     1     2     2     4
    23     1     2     4     1     2     2     3     3     1     3     2     3
    24     1     1     3     1     2     2     2     2     1     2     2     2
    25     1     2     5     1     2     3     3     3     1     3     2     4
    26     1     2     2     1     1     1     2     2     1     2     2     2
    27     1     1     1     1     1     1     1     1     1     1     1     1
    28     1     2     2     1     1     2     2     2     1     1     1     2
    29     1     2     2     1     1     2     2     2     1     2     3     2
    30     1     3     3     1     1     3     3     4     1     2     3     4
    31     1     1     1     1     2     2     1     1     1     2     2     4
        V607  V608  V609  V610  V611  V612  V613  V614  V615  V616  V617  V618
    1    D_2   D_2   D_2   D_2   D_2   D_2   D_2   D_2   D_2   D_2   D_2   D_2
    2    C_3   C_4   C_5   C_6   D_1   D_2   D_3   D_4   D_5   D_6   E_2   E_3
    3     10     8    21    25    25  1539   205   109   608   210     1     4
    4      1     1     1     1     2     6     3     4     5     5     1     1
    5      5     5     7     6     7     9     9     9     9     9     1     2
    6      3     2     3     3     3     3     3     3     3     3     1     1
    7      2     2     3     2     2     3     3     3     3     3     1     2
    8      7     6    11    14    18   275    89    60   112    50     1     3
    9      7     5    17    17     9   276    78    45   134    63     1     3
    10     7     6    16    18    19   266   107    63   176    84     1     3
    11     1     1     1     1     1     1     1     1     1     1     1     1
    12     1     1     1     1     1     1     1     1     1     1     1     1
    13     1     1     1     1     1     1     1     1     1     1     1     1
    14     1     1     1     1     1     1     1     1     1     1     1     1
    15     1     1     1     1     1     1     1     1     1     1     1     1
    16     1     1     1     1     1     1     1     1     1     1     1     1
    17     1     1     1     1     1     1     1     1     1     1     1     1
    18     1     1     1     1     1     1     1     1     1     1     1     1
    19     1     1     1     1     1     1     1     1     1     1     1     1
    20     1     1     1     1     1     1     1     1     1     1     1     1
    21     4     4     5    12     7    23    19     9    18     7     1     2
    22     3     2     2     5     4     6     5     4     6     3     1     2
    23     4     4     4     7     6    12    11     7     9     4     1     2
    24     3     4     4     5     5     6     6     5     6     3     1     2
    25     4     4     5    12     7    23    19     9    18     7     1     2
    26     2     1     1     2     2     2     2     2     2     2     1     1
    27     1     1     2     1     2     2     2     2     2     2     1     1
    28     2     2     2     2     2     2     2     2     2     2     1     2
    29     2     2     2     2     2     3     3     3     3     3     1     2
    30     4     4     5     4     5     9     7     7     7     7     1     3
    31     2     3     2     5     7     9     8     8     8     8     1     2
        V619  V620  V621  V622  V623  V624  V625  V626  V627  V628  V629  V630
    1    D_2   D_2   D_2   D_2   D_2   D_2   D_2   D_2   D_2   D_2   D_3   D_3
    2    E_4   E_5   E_6   F_1   F_2   F_3   F_4   F_5   F_6  <NA>   A_2   A_3
    3      2     4     6     1     4     4     6     2     4     3     7    13
    4      1     1     2     1     1     1     1     1     2     1     3     2
    5      2     2     4     1     3     3     3     2     3     2     3     6
    6      2     2     3     1     2     1     2     2     3     1     2     3
    7      1     2     2     1     1     1     2     1     2     1     3     3
    8      1     1     4     1     2     2     4     2     2     1     4     7
    9      2     2     4     1     3     4     4     2     3     1     7     9
    10     2     2     4     1     3     2     4     2     3     2     7    11
    11     1     1     1     1     1     1     1     1     1     1     1     1
    12     1     1     1     1     1     1     1     1     1     1     1     1
    13     1     1     1     1     1     1     1     1     1     1     1     1
    14     1     1     1     1     1     1     1     1     1     1     1     1
    15     1     1     1     1     1     1     1     1     1     1     1     1
    16     1     1     1     1     1     1     1     1     1     1     1     1
    17     1     1     1     1     1     1     1     1     1     1     1     1
    18     1     1     1     1     1     1     1     1     1     1     1     1
    19     1     1     1     1     1     1     1     1     1     1     1     1
    20     1     1     1     1     1     1     1     1     1     1     1     1
    21     2     1     4     1     3     2     2     2     2     2     4     7
    22     2     1     4     1     3     2     2     2     2     1     3     4
    23     2     1     3     1     2     2     2     2     2     2     4     6
    24     2     1     2     1     1     1     2     2     2     2     2     4
    25     2     1     4     1     3     2     2     2     2     2     4     7
    26     1     1     2     1     2     2     1     1     1     1     2     2
    27     1     1     1     1     1     1     1     1     1     1     1     1
    28     1     2     2     1     1     2     2     2     1     2     2     2
    29     1     2     2     1     1     1     2     1     2     1     2     2
    30     1     2     3     1     1     2     3     2     2     2     4     4
    31     2     1     4     1     1     3     2     1     2     2     1     1
        V631  V632  V633  V634  V635  V636  V637  V638  V639  V640  V641  V642
    1    D_3   D_3   D_3   D_3   D_3   D_3   D_3   D_3   D_3   D_3   D_3   D_3
    2    A_4   A_5   B_1   B_2   B_3   B_4   B_5   B_6   C_1   C_2   C_3   C_4
    3      2    12     2     9    21     2    18     5     1    11    28     5
    4      1     1     1     2     2     1     2     1     1     1     2     1
    5      1     4     1     5     7     1     7     2     1     6     8     2
    6      1     2     1     2     3     1     3     2     1     3     3     2
    7      1     2     1     2     3     1     3     2     1     2     2     2
    8      1     5     1     5    14     1     9     4     1     6    16     3
    9      1     8     1     5    15     1    12     4     1     7    17     3
    10     1     8     1     5    15     2    13     4     1     8    18     3
    11     1     1     1     1     1     1     1     1     1     1     1     1
    12     1     1     1     1     1     1     1     1     1     1     1     1
    13     1     1     1     1     1     1     1     1     1     1     1     1
    14     1     1     1     1     1     1     1     1     1     1     1     1
    15     1     1     1     1     1     1     1     1     1     1     1     1
    16     1     1     1     1     1     1     1     1     1     1     1     1
    17     1     1     1     1     1     1     1     1     1     1     1     1
    18     1     1     1     1     1     1     1     1     1     1     1     1
    19     1     1     1     1     1     1     1     1     1     1     1     1
    20     1     1     1     1     1     1     1     1     1     1     1     1
    21     1     5     1     4     8     2     8     3     1     4     8     1
    22     1     3     1     3     4     2     4     3     1     2     3     1
    23     1     4     1     4     8     2     5     3     1     3     6     1
    24     1     3     1     4     4     1     4     3     1     3     5     1
    25     1     5     1     4     8     2     8     3     1     4     8     1
    26     1     2     1     2     2     2     2     2     1     1     2     1
    27     1     1     1     1     1     1     1     1     1     1     1     1
    28     1     2     1     2     2     1     2     2     1     2     2     2
    29     1     2     1     2     3     2     2     1     1     2     3     1
    30     1     3     1     4     4     2     4     2     1     3     5     2
    31     1     1     1     2     5     1     3     2     1     3     5     2
        V643  V644  V645  V646  V647  V648  V649  V650  V651  V652  V653  V654
    1    D_3   D_3   D_3   D_3   D_3   D_3   D_3   D_3   D_3   D_3   D_3   D_3
    2    C_5   C_6   D_1   D_2   D_3   D_4   D_5   D_6   E_3   E_5   E_6   F_2
    3     32    19    16   199   669   107   408    74     2     2     1     7
    4      3     1     1     5     6     3     5     3     1     1     1     1
    5      6     4     5     9     9     9     9     8     1     1     1     3
    6      3     2     3     3     3     3     3     3     1     1     1     2
    7      3     2     2     3     3     3     3     3     1     1     1     3
    8     20     8    12    78   133    50   111    34     1     1     1     5
    9     24     9     6    89   133    41   135    36     1     2     1     5
    10    25    10    13   105   160    54   149    43     1     2     1     5
    11     1     1     1     1     1     1     1     1     1     1     1     1
    12     1     1     1     1     1     1     1     1     1     1     1     1
    13     1     1     1     1     1     1     1     1     1     1     1     1
    14     1     1     1     1     1     1     1     1     1     1     1     1
    15     1     1     1     1     1     1     1     1     1     1     1     1
    16     1     1     1     1     1     1     1     1     1     1     1     1
    17     1     1     1     1     1     1     1     1     1     1     1     1
    18     1     1     1     1     1     1     1     1     1     1     1     1
    19     1     1     1     1     1     1     1     1     1     1     1     1
    20     1     1     1     1     1     1     1     1     1     1     1     1
    21     5     6     6    18    21     9    15     8     1     1     1     3
    22     3     5     3     4     6     3     5     4     1     1     1     3
    23     4     5     6    11    11     8    10     5     1     1     1     3
    24     4     4     5     6     6     6     6     4     1     1     1     3
    25     5     6     6    18    21     9    15     8     1     1     1     3
    26     2     2     2     2     2     2     2     2     1     1     1     2
    27     1     2     1     2     2     1     2     1     1     1     1     1
    28     2     2     2     2     2     2     2     2     2     1     1     1
    29     2     2     2     3     3     2     3     3     1     1     1     2
    30     4     5     4     7     7     4     8     6     2     1     1     2
    31     6     4     5     8     8     8     8     7     1     1     1     2
        V655  V656  V657  V658  V659  V660  V661  V662  V663  V664  V665  V666
    1    D_3   D_3   D_3   D_3   D_4   D_4   D_4   D_4   D_4   D_4   D_4   D_4
    2    F_3   F_4   F_5   F_6   A_1   A_2   A_3   A_4   A_5   A_6   B_1   B_2
    3      5     2     8     2     6     4     3     7    11     1     7    15
    4      2     1     2     2     1     1     1     1     1     1     1     1
    5      3     1     5     2     2     2     2     4     2     1     4     5
    6      2     1     3     1     2     2     2     3     2     1     3     3
    7      2     1     2     1     2     1     2     3     1     1     2     2
    8      4     2     7     2     2     3     2     4     4     1     4     7
    9      3     2     7     2     2     3     2     6     4     1     5     9
    10     5     2     7     2     2     3     2     6     4     1     5     9
    11     1     1     1     1     1     1     1     1     1     1     1     1
    12     1     1     1     1     1     1     1     1     1     1     1     1
    13     1     1     1     1     1     1     1     1     1     1     1     1
    14     1     1     1     1     1     1     1     1     1     1     1     1
    15     1     1     1     1     1     1     1     1     1     1     1     1
    16     1     1     1     1     1     1     1     1     1     1     1     1
    17     1     1     1     1     1     1     1     1     1     1     1     1
    18     1     1     1     1     1     1     1     1     1     1     1     1
    19     1     1     1     1     1     1     1     1     1     1     1     1
    20     1     1     1     1     1     1     1     1     1     1     1     1
    21     5     2     5     2     2     2     2     2     3     1     3     3
    22     3     2     2     2     2     2     2     2     2     1     2     2
    23     4     2     4     2     2     2     2     2     3     1     3     3
    24     4     2     4     2     2     2     2     1     3     1     2     3
    25     5     2     5     2     2     2     2     2     3     1     3     3
    26     1     2     1     2     2     2     2     2     2     1     2     2
    27     1     1     1     1     1     1     1     1     1     1     1     1
    28     2     1     1     1     1     2     1     1     2     1     2     2
    29     2     1     3     1     2     2     1     2     2     1     2     2
    30     3     1     3     1     2     3     1     2     3     1     3     3
    31     2     1     2     1     1     1     1     3     3     1     4     2
        V667  V668  V669  V670  V671  V672  V673  V674  V675  V676  V677  V678
    1    D_4   D_4   D_4   D_4   D_4   D_4   D_4   D_4   D_4   D_4   D_4   D_4
    2    B_3   B_4   B_5   B_6   C_2   C_3   C_4   C_5   C_6   D_1   D_2   D_3
    3      5     8    12     7     4     8    11    30    26    13   111    98
    4      2     1     1     1     1     1     1     1     1     1     4     4
    5      3     3     4     2     3     4     5     6     4     6     9     8
    6      2     3     3     2     2     3     2     2     2     2     3     3
    7      2     2     2     2     1     2     2     2     2     2     2     3
    8      4     7     4     5     3     4     6    15     9     8    46    44
    9      5     7     4     4     3     5     6    17    12     4    57    46
    10     5     7     5     4     3     4     8    19    12     8    65    50
    11     1     1     1     1     1     1     1     1     1     1     1     1
    12     1     1     1     1     1     1     1     1     1     1     1     1
    13     1     1     1     1     1     1     1     1     1     1     1     1
    14     1     1     1     1     1     1     1     1     1     1     1     1
    15     1     1     1     1     1     1     1     1     1     1     1     1
    16     1     1     1     1     1     1     1     1     1     1     1     1
    17     1     1     1     1     1     1     1     1     1     1     1     1
    18     1     1     1     1     1     1     1     1     1     1     1     1
    19     1     1     1     1     1     1     1     1     1     1     1     1
    20     1     1     1     1     1     1     1     1     1     1     1     1
    21     3     2     3     2     3     4     6     9     6     2    10    10
    22     3     2     2     2     3     2     3     5     4     1     4     5
    23     3     2     3     2     3     3     4     7     6     2     8     7
    24     3     1     2     2     3     3     3     5     5     2     6     5
    25     3     2     3     2     3     4     6     9     6     2    10    10
    26     2     2     2     1     2     1     2     2     2     1     2     2
    27     1     1     1     1     1     1     1     1     1     1     2     1
    28     2     1     2     1     1     2     2     2     2     2     2     2
    29     2     2     3     2     3     2     3     3     2     2     3     2
    30     3     2     4     2     3     2     4     5     4     3     7     4
    31     3     4     5     4     1     1     5     6     6     4     7     8
        V679  V680  V681  V682  V683  V684  V685  V686  V687  V688  V689  V690
    1    D_4   D_4   D_4   D_4   D_4   D_4   D_4   D_5   D_5   D_5   D_5   D_5
    2    D_4   D_5   D_6   E_5   E_6   F_3   F_5   A_1   A_2   A_3   A_4   A_5
    3    681   281    56     2     2     1     1     1    14    18     8    20
    4      5     6     1     1     1     1     1     1     1     2     1     2
    5      9     9     7     1     2     1     1     1     4     7     4     6
    6      3     3     3     1     2     1     1     1     3     3     3     3
    7      3     3     3     1     1     1     1     1     1     3     3     3
    8    102    65    15     1     2     1     1     1     7    15     4    10
    9    103    98    19     1     2     1     1     1     8    15     5    14
    10   125   117    21     1     2     1     1     1     8    15     5    13
    11     1     1     1     1     1     1     1     1     1     1     1     1
    12     1     1     1     1     1     1     1     1     1     1     1     1
    13     1     1     1     1     1     1     1     1     1     1     1     1
    14     1     1     1     1     1     1     1     1     1     1     1     1
    15     1     1     1     1     1     1     1     1     1     1     1     1
    16     1     1     1     1     1     1     1     1     1     1     1     1
    17     1     1     1     1     1     1     1     1     1     1     1     1
    18     1     1     1     1     1     1     1     1     1     1     1     1
    19     1     1     1     1     1     1     1     1     1     1     1     1
    20     1     1     1     1     1     1     1     1     1     1     1     1
    21    22    18     5     1     2     1     1     1     3     5     3     2
    22     5     6     3     1     2     1     1     1     2     3     3     2
    23    11     9     3     1     2     1     1     1     3     4     3     2
    24     6     5     3     1     2     1     1     1     3     3     3     1
    25    22    18     5     1     2     1     1     1     3     5     3     2
    26     2     2     1     1     1     1     1     1     2     2     2     2
    27     1     2     1     1     1     1     1     1     1     1     1     1
    28     2     2     2     1     1     1     1     1     2     2     2     2
    29     3     3     2     1     2     1     1     1     3     2     2     2
    30     6     8     4     1     2     1     1     1     4     4     3     4
    31     9     8     7     1     1     1     1     1     2     1     2     4
        V691  V692  V693  V694  V695  V696  V697  V698  V699  V700  V701  V702
    1    D_5   D_5   D_5   D_5   D_5   D_5   D_5   D_5   D_5   D_5   D_5   D_5
    2    A_6   B_1   B_2   B_3   B_4   B_5   B_6   C_1   C_2   C_3   C_4   C_5
    3      6    22   105    69    10    72    58     2    57    82    63   392
    4      1     2     2     1     2     3     3     1     2     3     1     4
    5      1     8     9     9     3     9     8     2     9     9     8     9
    6      1     3     3     3     3     3     3     2     3     3     3     3
    7      2     3     3     3     2     3     3     2     3     3     3     3
    8      2    17    56    39     6    40    35     2    37    57    32   143
    9      2    18    64    44     6    43    35     2    42    59    28   190
    10     2    16    64    45     6    47    39     2    43    61    37   207
    11     1     1     1     1     1     1     1     1     1     1     1     1
    12     1     1     1     1     1     1     1     1     1     1     1     1
    13     1     1     1     1     1     1     1     1     1     1     1     1
    14     1     1     1     1     1     1     1     1     1     1     1     1
    15     1     1     1     1     1     1     1     1     1     1     1     1
    16     1     1     1     1     1     1     1     1     1     1     1     1
    17     1     1     1     1     1     1     1     1     1     1     1     1
    18     1     1     1     1     1     1     1     1     1     1     1     1
    19     1     1     1     1     1     1     1     1     1     1     1     1
    20     1     1     1     1     1     1     1     1     1     1     1     1
    21     1     5    12    13     4    10     8     2     7    14     8    20
    22     1     3     4     4     4     5     3     1     3     6     3     6
    23     1     4     8    10     4     6     7     2     5     9     7    11
    24     1     4     5     6     3     4     5     2     4     5     6     6
    25     1     5    12    13     4    10     8     2     7    14     8    20
    26     1     2     2     2     2     2     2     1     2     2     2     2
    27     1     1     1     1     1     1     1     1     1     1     1     2
    28     1     2     2     2     2     2     2     1     2     2     2     2
    29     1     2     3     3     1     3     3     2     2     3     3     3
    30     1     4     5     5     2     5     6     2     4     5     6     8
    31     2     4     4     4     1     4     7     1     6     7     7     8
        V703  V704  V705  V706  V707  V708  V709  V710  V711  V712  V713  V714
    1    D_5   D_5   D_5   D_5   D_5   D_5   D_5   D_5   D_5   D_5   D_5   D_5
    2    C_6   D_1   D_2   D_3   D_4   D_5   D_6   E_2   E_3   E_4   E_5   E_6
    3    162    11   609   402   285  8210   955    24     8     5    37    31
    4      2     3     6     5     6     6     5     2     1     1     2     1
    5      8     6     9     9     9     9     9     6     3     3     8     6
    6      3     2     3     3     3     3     3     3     2     2     3     3
    7      3     2     3     3     3     3     3     3     3     1     2     2
    8     60     8   141   135    95   616   220     8     8     2    15    16
    9     74     4   115   108    67   615   232     9     6     3    22    15
    10    85     8   184   150   114   791   330    11     6     4    19    17
    11     1     1     1     1     1     1     1     1     1     1     1     1
    12     1     1     1     1     1     1     1     1     1     1     1     1
    13     1     1     1     1     1     1     1     1     1     1     1     1
    14     1     1     1     1     1     1     1     1     1     1     1     1
    15     1     1     1     1     1     1     1     1     1     1     1     1
    16     1     1     1     1     1     1     1     1     1     1     1     1
    17     1     1     1     1     1     1     1     1     1     1     1     1
    18     1     1     1     1     1     1     1     1     1     1     1     1
    19     1     1     1     1     1     1     1     1     1     1     1     1
    20     1     1     1     1     1     1     1     1     1     1     1     1
    21    14     4    20    12    19    29    21     4     4     3     5     8
    22     6     1     5     4     6     6     6     2     3     2     4     5
    23     8     4    10     7     9    11    11     3     3     2     4     4
    24     5     4     6     5     5     6     6     3     2     2     3     4
    25    14     4    20    12    19    29    21     4     4     3     5     8
    26     2     1     2     2     2     2     2     1     2     1     2     2
    27     2     1     2     2     2     2     2     1     1     1     1     1
    28     2     1     2     2     2     2     2     2     2     2     2     2
    29     3     2     3     3     3     3     3     2     2     2     2     3
    30     6     2     7     8     8     9     8     4     4     3     4     4
    31     6     4     8     8     8     8     8     6     3     2     6     4
        V715  V716  V717  V718  V719  V720  V721  V722  V723  V724  V725  V726
    1    D_5   D_5   D_5   D_5   D_5   D_5   D_6   D_6   D_6   D_6   D_6   D_6
    2    F_1   F_2   F_3   F_4   F_5   F_6   A_1   A_2   A_3   A_4   A_5   A_6
    3      1     8    12     4    35    11     3    26    25     3    16    15
    4      1     1     2     1     1     1     1     1     1     1     3     2
    5      1     3     7     2     6     3     2     7     7     2     5     6
    6      1     2     3     1     3     2     2     3     3     2     3     3
    7      1     2     2     1     3     2     1     3     3     3     3     2
    8      1     6     8     2    22     8     3    15    14     3    12     7
    9      1     6     7     2    18     7     3    17    18     2    13     6
    10     1     6     9     2    24     7     3    16    18     3    13     8
    11     1     1     1     1     1     1     1     1     1     1     1     1
    12     1     1     1     1     1     1     1     1     1     1     1     1
    13     1     1     1     1     1     1     1     1     1     1     1     1
    14     1     1     1     1     1     1     1     1     1     1     1     1
    15     1     1     1     1     1     1     1     1     1     1     1     1
    16     1     1     1     1     1     1     1     1     1     1     1     1
    17     1     1     1     1     1     1     1     1     1     1     1     1
    18     1     1     1     1     1     1     1     1     1     1     1     1
    19     1     1     1     1     1     1     1     1     1     1     1     1
    20     1     1     1     1     1     1     1     1     1     1     1     1
    21     1     5     6     1     8     3     3     7    10     2     4     3
    22     1     4     5     1     4     3     2     4     5     2     2     2
    23     1     5     5     1     5     3     3     5     8     2     4     3
    24     1     3     4     1     4     2     3     5     5     2     4     2
    25     1     5     6     1     8     3     3     7    10     2     4     3
    26     1     2     2     1     2     2     2     2     2     2     2     2
    27     1     1     1     1     1     1     1     1     1     1     1     1
    28     1     2     2     1     2     2     2     2     2     2     2     2
    29     1     3     3     1     3     2     1     3     2     2     2     2
    30     1     4     4     1     5     4     2     5     3     3     3     3
    31     1     3     2     2     3     3     1     1     1     1     2     4
        V727  V728  V729  V730  V731  V732  V733  V734  V735  V736  V737  V738
    1    D_6   D_6   D_6   D_6   D_6   D_6   D_6   D_6   D_6   D_6   D_6   D_6
    2    B_1   B_2   B_3   B_4   B_5   B_6   C_1   C_2   C_3   C_4   C_5   C_6
    3     22    76    39    13    73    96     3    93    71    23   230   188
    4      1     2     2     1     3     3     1     1     3     1     3     4
    5      9     9     8     4     8     8     2     9     9     9     9     9
    6      3     3     3     3     3     3     1     3     3     3     3     3
    7      3     2     3     3     3     3     1     3     3     2     3     3
    8     14    46    29     9    38    51     2    51    45    11   111   104
    9     14    55    27    11    45    53     2    59    44    10   145   113
    10    15    55    29    10    46    56     2    58    50    12   143   116
    11     1     1     1     1     1     1     1     1     1     1     1     1
    12     1     1     1     1     1     1     1     1     1     1     1     1
    13     1     1     1     1     1     1     1     1     1     1     1     1
    14     1     1     1     1     1     1     1     1     1     1     1     1
    15     1     1     1     1     1     1     1     1     1     1     1     1
    16     1     1     1     1     1     1     1     1     1     1     1     1
    17     1     1     1     1     1     1     1     1     1     1     1     1
    18     1     1     1     1     1     1     1     1     1     1     1     1
    19     1     1     1     1     1     1     1     1     1     1     1     1
    20     1     1     1     1     1     1     1     1     1     1     1     1
    21     5     9    11     4     8    10     2     6    10     5    15    11
    22     4     4     5     3     4     4     2     4     4     3     6     4
    23     3     9     7     4     6     8     1     6     9     4     7     8
    24     3     5     6     4     4     5     1     3     5     4     4     6
    25     5     9    11     4     8    10     2     6    10     5    15    11
    26     2     2     2     2     2     2     1     2     2     2     2     2
    27     2     1     1     1     1     1     1     2     1     1     2     2
    28     2     2     2     2     2     2     1     2     2     2     2     2
    29     2     3     3     2     3     3     1     3     2     2     3     3
    30     5     5     6     3     5     5     1     8     4     4     8     6
    31     3     4     5     3     7     7     2     6     6     4     6     8
        V739  V740  V741  V742  V743  V744  V745  V746  V747  V748  V749  V750
    1    D_6   D_6   D_6   D_6   D_6   D_6   D_6   D_6   D_6   D_6   D_6   D_6
    2    D_1   D_2   D_3   D_4   D_5   D_6   E_3   E_5   E_6   F_2   F_3   F_5
    3      4   227    69    48   991  3075     2    11    20     5     8    17
    4      1     5     3     1     5     5     1     1     1     1     1     2
    5      1     9     9     7     9     9     1     6     4     2     3     5
    6      1     3     3     3     3     3     1     3     3     2     3     3
    7      1     3     3     3     3     3     1     2     3     3     2     2
    8      1    64    33    16   226   363     1     6    14     4     6     9
    9      1    53    35    12   220   366     1     6    10     3     7     9
    10     1    88    42    20   332   416     1     6    14     4     7     9
    11     1     1     1     1     1     1     1     1     1     1     1     1
    12     1     1     1     1     1     1     1     1     1     1     1     1
    13     1     1     1     1     1     1     1     1     1     1     1     1
    14     1     1     1     1     1     1     1     1     1     1     1     1
    15     1     1     1     1     1     1     1     1     1     1     1     1
    16     1     1     1     1     1     1     1     1     1     1     1     1
    17     1     1     1     1     1     1     1     1     1     1     1     1
    18     1     1     1     1     1     1     1     1     1     1     1     1
    19     1     1     1     1     1     1     1     1     1     1     1     1
    20     1     1     1     1     1     1     1     1     1     1     1     1
    21     1    10     9     6    23    25     1     2     4     3     4     5
    22     1     5     4     4     6     6     1     2     4     3     3     2
    23     1     5     6     5    11    11     1     2     2     3     3     3
    24     1     4     4     4     6     6     1     2     2     2     3     3
    25     1    10     9     6    23    25     1     2     4     3     4     5
    26     1     2     2     2     2     2     1     2     1     2     1     1
    27     1     2     1     1     2     2     1     1     1     1     1     1
    28     1     2     2     2     2     2     1     2     2     2     2     2
    29     1     3     3     2     3     3     1     2     2     2     2     2
    30     1     8     5     4     8    10     1     4     4     3     4     3
    31     1     8     7     7     8     9     1     4     6     2     2     3
        V751  V752  V753  V754  V755  V756  V757  V758  V759  V760  V761  V762
    1    D_6   E_1   E_1   E_1   E_1   E_1   E_1   E_1   E_1   E_1   E_2   E_2
    2    F_6   B_2   C_5   C_6   E_1   E_2   E_3   E_4   E_5   E_6   A_5   B_1
    3     22     1     2     2    43    28    23     3    10    10     1     2
    4      2     1     1     1     2     2     3     1     1     1     1     1
    5      5     1     1     1     8     6     5     2     3     3     1     1
    6      3     1     1     1     3     3     3     2     2     2     1     1
    7      3     1     1     1     2     2     3     2     2     2     1     1
    8     14     1     1     1    11    11    12     1     5     4     1     1
    9     15     1     1     1    11    19    12     3     4     5     1     1
    10    16     1     1     1    14    19    14     2     4     5     1     1
    11     1     1     1     1     1     1     1     1     1     1     1     1
    12     1     1     1     1     1     1     1     1     1     1     1     1
    13     1     1     1     1     1     1     1     1     1     1     1     1
    14     1     1     1     1     1     1     1     1     1     1     1     1
    15     1     1     1     1     1     1     1     1     1     1     1     1
    16     1     1     1     1     1     1     1     1     1     1     1     1
    17     1     1     1     1     1     1     1     1     1     1     1     1
    18     1     1     1     1     1     1     1     1     1     1     1     1
    19     1     1     1     1     1     1     1     1     1     1     1     1
    20     1     1     1     1     1     1     1     1     1     1     1     1
    21     6     1     1     1     7     7     4     2     3     2     1     1
    22     4     1     1     1     4     3     2     1     1     1     1     1
    23     4     1     1     1     5     5     4     2     3     2     1     1
    24     3     1     1     1     4     5     3     2     3     2     1     1
    25     6     1     1     1     7     7     4     2     3     2     1     1
    26     2     1     1     1     2     1     2     1     1     1     1     1
    27     1     1     1     1     1     1     2     1     1     1     1     1
    28     2     1     2     1     2     2     1     1     2     2     1     1
    29     2     1     1     1     2     2     2     1     2     2     1     1
    30     4     1     2     1     3     4     3     1     4     3     1     1
    31     6     1     1     1     4     6     6     3     4     3     1     1
        V763  V764  V765  V766  V767  V768  V769  V770  V771  V772  V773  V774
    1    E_2   E_2   E_2   E_2   E_2   E_2   E_2   E_2   E_2   E_2   E_2   E_2
    2    B_2   B_3   B_4   B_5   B_6   C_1   C_2   C_3   C_4   C_5   C_6   D_2
    3     11    17     2    15     2     1     3     5     6    29     8     1
    4      3     1     1     1     1     1     1     1     1     2     1     1
    5      5     5     2     7     1     1     2     3     4     7     2     1
    6      3     3     1     3     1     1     2     2     3     3     2     1
    7      2     3     1     2     1     1     2     2     2     2     2     1
    8      6     8     2     4     1     1     2     4     5    18     8     1
    9      7    12     2     8     1     1     2     5     5    19     7     1
    10     7    10     2     9     1     1     2     5     5    21     7     1
    11     1     1     1     1     1     1     1     1     1     1     1     1
    12     1     1     1     1     1     1     1     1     1     1     1     1
    13     1     1     1     1     1     1     1     1     1     1     1     1
    14     1     1     1     1     1     1     1     1     1     1     1     1
    15     1     1     1     1     1     1     1     1     1     1     1     1
    16     1     1     1     1     1     1     1     1     1     1     1     1
    17     1     1     1     1     1     1     1     1     1     1     1     1
    18     1     1     1     1     1     1     1     1     1     1     1     1
    19     1     1     1     1     1     1     1     1     1     1     1     1
    20     1     1     1     1     1     1     1     1     1     1     1     1
    21     6     5     2     5     1     1     2     4     3     7     2     1
    22     3     2     2     3     1     1     1     2     2     3     1     1
    23     4     5     2     4     1     1     2     4     3     5     2     1
    24     2     4     2     3     1     1     2     4     3     4     2     1
    25     6     5     2     5     1     1     2     4     3     7     2     1
    26     2     2     1     2     1     1     1     1     1     2     1     1
    27     1     1     1     1     1     1     1     1     1     2     1     1
    28     2     2     2     2     1     1     2     2     2     2     1     1
    29     2     2     2     2     1     1     2     1     3     3     1     1
    30     3     4     2     3     1     1     2     2     3     6     1     1
    31     2     3     1     4     1     1     1     2     2     4     3     1
        V775  V776  V777  V778  V779  V780  V781  V782  V783  V784  V785  V786
    1    E_2   E_2   E_2   E_2   E_2   E_2   E_2   E_2   E_2   E_2   E_2   E_2
    2    D_4   D_5   E_1   E_2   E_3   E_4   E_5   E_6   F_3   F_4   F_5   F_6
    3      1    23    30  1229   231   120   766    32     3     1     4     1
    4      1     2     2     6     4     3     6     1     1     1     1     1
    5      1     5     8     9     9     9     9     6     2     1     2     1
    6      1     3     3     3     3     3     3     3     2     1     2     1
    7      1     2     2     3     3     3     3     3     2     1     1     1
    8      1     7    21   151    93    47    80    13     2     1     2     1
    9      1     6    11   154    72    34   104    12     2     1     2     1
    10     1    10    20   184   116    69   162    16     2     1     2     1
    11     1     1     1     1     1     1     1     1     1     1     1     1
    12     1     1     1     1     1     1     1     1     1     1     1     1
    13     1     1     1     1     1     1     1     1     1     1     1     1
    14     1     1     1     1     1     1     1     1     1     1     1     1
    15     1     1     1     1     1     1     1     1     1     1     1     1
    16     1     1     1     1     1     1     1     1     1     1     1     1
    17     1     1     1     1     1     1     1     1     1     1     1     1
    18     1     1     1     1     1     1     1     1     1     1     1     1
    19     1     1     1     1     1     1     1     1     1     1     1     1
    20     1     1     1     1     1     1     1     1     1     1     1     1
    21     1     5     8    17    12    10    15     4     2     1     2     1
    22     1     3     4     6     5     4     6     1     2     1     2     1
    23     1     3     7     9     8     7     8     4     2     1     2     1
    24     1     3     6     6     6     5     6     4     2     1     2     1
    25     1     5     8    17    12    10    15     4     2     1     2     1
    26     1     1     2     2     2     2     2     1     1     1     1     1
    27     1     1     1     2     2     2     2     1     1     1     1     1
    28     1     2     2     2     2     2     2     2     2     1     1     1
    29     1     2     2     3     3     3     3     2     1     1     2     1
    30     1     4     3     9     8     8     9     4     2     1     2     1
    31     1     6     6     9     8     7     8     8     2     1     2     1
        V787  V788  V789  V790  V791  V792  V793  V794  V795  V796  V797  V798
    1    E_3   E_3   E_3   E_3   E_3   E_3   E_3   E_3   E_3   E_3   E_3   E_3
    2    A_2   A_3   B_1   B_2   B_3   B_4   B_5   B_6   C_2   C_3   C_4   C_5
    3      2     3     6    18    41    13    18     3    13    10     3    38
    4      1     1     2     2     1     2     1     2     2     2     1     1
    5      1     2     2     7     7     5     7     2     6     6     2     7
    6      1     1     2     3     3     3     3     2     3     3     2     3
    7      1     2     2     3     3     2     2     2     2     2     1     3
    8      1     2     5     9    14     3     9     2    10     8     2    20
    9      1     2     5    12    21     2    13     2    12     8     2    33
    10     1     2     5    10    20     4    15     2    11     8     2    30
    11     1     1     1     1     1     1     1     1     1     1     1     1
    12     1     1     1     1     1     1     1     1     1     1     1     1
    13     1     1     1     1     1     1     1     1     1     1     1     1
    14     1     1     1     1     1     1     1     1     1     1     1     1
    15     1     1     1     1     1     1     1     1     1     1     1     1
    16     1     1     1     1     1     1     1     1     1     1     1     1
    17     1     1     1     1     1     1     1     1     1     1     1     1
    18     1     1     1     1     1     1     1     1     1     1     1     1
    19     1     1     1     1     1     1     1     1     1     1     1     1
    20     1     1     1     1     1     1     1     1     1     1     1     1
    21     1     1     2     3     9     2     3     2     6     4     2     9
    22     1     1     2     2     4     2     2     2     3     2     2     4
    23     1     1     2     3     7     2     3     2     4     3     1     6
    24     1     1     2     3     4     2     3     1     4     3     1     4
    25     1     1     2     3     9     2     3     2     6     4     2     9
    26     1     1     2     2     2     2     2     2     1     1     1     2
    27     1     1     1     1     1     1     1     1     1     2     1     1
    28     1     2     1     2     2     2     2     1     2     2     2     2
    29     1     1     2     2     2     1     3     1     2     2     2     3
    30     1     2     2     4     4     2     5     1     4     5     2     5
    31     1     1     4     4     5     4     4     1     2     3     2     3
        V799  V800  V801  V802  V803  V804  V805  V806  V807  V808  V809  V810
    1    E_3   E_3   E_3   E_3   E_3   E_3   E_3   E_3   E_3   E_3   E_3   E_3
    2    C_6   D_2   D_4   D_5   E_1   E_2   E_3   E_4   E_5   E_6   F_4   F_6
    3     24     4     2     4    22   215  1016   110   349    95     1     2
    4      2     1     1     1     2     5     6     3     4     4     1     1
    5      8     3     1     3     8     9     9     9     9     6     1     1
    6      3     2     1     2     3     3     3     3     3     3     1     1
    7      3     2     1     2     2     3     3     3     3     2     1     1
    8     15     3     1     4    12    71   107    32    60    31     1     1
    9     15     3     1     4    11    89   105    34    80    30     1     1
    10    17     3     1     4    13   104   149    59   109    38     1     1
    11     1     1     1     1     1     1     1     1     1     1     1     1
    12     1     1     1     1     1     1     1     1     1     1     1     1
    13     1     1     1     1     1     1     1     1     1     1     1     1
    14     1     1     1     1     1     1     1     1     1     1     1     1
    15     1     1     1     1     1     1     1     1     1     1     1     1
    16     1     1     1     1     1     1     1     1     1     1     1     1
    17     1     1     1     1     1     1     1     1     1     1     1     1
    18     1     1     1     1     1     1     1     1     1     1     1     1
    19     1     1     1     1     1     1     1     1     1     1     1     1
    20     1     1     1     1     1     1     1     1     1     1     1     1
    21     7     1     1     3     4    14    16     9    13    11     1     1
    22     3     1     1     3     1     5     4     3     4     4     1     1
    23     6     1     1     3     4     9    10     5     9     8     1     1
    24     5     1     1     2     4     6     6     5     6     5     1     1
    25     7     1     1     3     4    14    16     9    13    11     1     1
    26     2     1     1     2     1     2     2     1     2     2     1     1
    27     2     2     1     1     2     2     2     2     2     2     1     1
    28     2     2     1     2     1     2     2     2     2     2     1     1
    29     3     2     1     2     2     3     3     3     3     3     1     1
    30     6     3     1     3     3     8     8     7     8     6     1     1
    31     5     2     1     3     5     8     9     7     8     8     1     1
        V811  V812  V813  V814  V815  V816  V817  V818  V819  V820  V821  V822
    1    E_4   E_4   E_4   E_4   E_4   E_4   E_4   E_4   E_4   E_4   E_4   E_4
    2    A_1   A_3   B_3   B_4   B_5   B_6   C_2   C_3   C_4   C_5   C_6   D_5
    3      1     1     2     3     2     1     2     6    10    23     6     1
    4      1     1     1     1     1     1     1     1     2     1     1     1
    5      1     1     2     2     1     1     2     2     4     5     1     1
    6      1     1     1     2     1     1     2     2     2     3     1     1
    7      1     1     1     1     1     1     1     2     2     3     2     1
    8      1     1     1     2     1     1     2     2     4    10     4     1
    9      1     1     1     2     1     1     2     3     5    14     4     1
    10     1     1     1     2     1     1     2     3     4    16     4     1
    11     1     1     1     1     1     1     1     1     1     1     1     1
    12     1     1     1     1     1     1     1     1     1     1     1     1
    13     1     1     1     1     1     1     1     1     1     1     1     1
    14     1     1     1     1     1     1     1     1     1     1     1     1
    15     1     1     1     1     1     1     1     1     1     1     1     1
    16     1     1     1     1     1     1     1     1     1     1     1     1
    17     1     1     1     1     1     1     1     1     1     1     1     1
    18     1     1     1     1     1     1     1     1     1     1     1     1
    19     1     1     1     1     1     1     1     1     1     1     1     1
    20     1     1     1     1     1     1     1     1     1     1     1     1
    21     1     1     1     2     1     1     2     3     2     6     1     1
    22     1     1     1     1     1     1     2     2     2     3     1     1
    23     1     1     1     2     1     1     2     3     1     4     1     1
    24     1     1     1     2     1     1     2     3     1     3     1     1
    25     1     1     1     2     1     1     2     3     2     6     1     1
    26     1     1     1     1     1     1     1     1     1     2     1     1
    27     1     1     1     1     1     1     1     1     1     1     1     1
    28     1     1     1     2     1     1     2     2     2     2     2     1
    29     1     1     1     2     1     1     2     1     2     3     2     1
    30     1     1     1     2     1     1     2     2     4     5     3     1
    31     1     1     1     1     1     1     1     1     4     5     3     1
        V823  V824  V825  V826  V827  V828  V829  V830  V831  V832  V833  V834
    1    E_4   E_4   E_4   E_4   E_4   E_4   E_4   E_4   E_4   E_4   E_4   E_5
    2    E_1   E_2   E_3   E_4   E_5   E_6   F_2   F_3   F_4   F_5   F_6   A_1
    3      1   139   110   256   304    26     1     3     4     1     2     1
    4      1     3     3     5     4     2     1     1     2     1     1     1
    5      1     9     8     9     9     6     1     2     2     1     1     1
    6      1     3     3     3     3     3     1     2     1     1     1     1
    7      1     2     3     2     3     3     1     1     2     1     1     1
    8      1    39    32    48    40     9     1     1     1     1     1     1
    9      1    46    31    41    75    10     1     1     1     1     1     1
    10     1    78    58    72   109    13     1     1     1     1     1     1
    11     1     1     1     1     1     1     1     1     1     1     1     1
    12     1     1     1     1     1     1     1     1     1     1     1     1
    13     1     1     1     1     1     1     1     1     1     1     1     1
    14     1     1     1     1     1     1     1     1     1     1     1     1
    15     1     1     1     1     1     1     1     1     1     1     1     1
    16     1     1     1     1     1     1     1     1     1     1     1     1
    17     1     1     1     1     1     1     1     1     1     1     1     1
    18     1     1     1     1     1     1     1     1     1     1     1     1
    19     1     1     1     1     1     1     1     1     1     1     1     1
    20     1     1     1     1     1     1     1     1     1     1     1     1
    21     1    10    11    12    14     3     1     1     1     1     1     1
    22     1     5     4     4     6     2     1     1     1     1     1     1
    23     1     6     7     9     7     3     1     1     1     1     1     1
    24     1     5     5     5     5     3     1     1     1     1     1     1
    25     1    10    11    12    14     3     1     1     1     1     1     1
    26     1     2     2     2     2     2     1     1     1     1     1     1
    27     1     2     2     1     2     1     1     1     1     1     1     1
    28     1     2     2     2     2     2     1     2     2     1     1     1
    29     1     3     3     3     3     3     1     1     2     1     1     1
    30     1     8     8     6     9     5     1     2     3     1     1     1
    31     1     7     7     8     8     6     1     1     2     1     1     1
        V835  V836  V837  V838  V839  V840  V841  V842  V843  V844  V845  V846
    1    E_5   E_5   E_5   E_5   E_5   E_5   E_5   E_5   E_5   E_5   E_5   E_5
    2    A_2   A_3   A_5   B_1   B_2   B_3   B_4   B_5   B_6   C_1   C_2   C_3
    3      1     6     1     7    35    42     4    85    11     3    45    52
    4      1     2     1     1     1     2     2     3     3     1     1     2
    5      1     3     1     5     9     9     3     9     5     1     8     9
    6      1     3     1     3     3     3     2     3     3     1     3     3
    7      1     2     1     3     3     3     2     3     2     1     3     3
    8      1     6     1     4    16    13     3    17     8     2    19    26
    9      1     6     1     4    21    16     2    20     9     2    22    34
    10     1     6     1     4    18    16     3    23     9     2    23    30
    11     1     1     1     1     1     1     1     1     1     1     1     1
    12     1     1     1     1     1     1     1     1     1     1     1     1
    13     1     1     1     1     1     1     1     1     1     1     1     1
    14     1     1     1     1     1     1     1     1     1     1     1     1
    15     1     1     1     1     1     1     1     1     1     1     1     1
    16     1     1     1     1     1     1     1     1     1     1     1     1
    17     1     1     1     1     1     1     1     1     1     1     1     1
    18     1     1     1     1     1     1     1     1     1     1     1     1
    19     1     1     1     1     1     1     1     1     1     1     1     1
    20     1     1     1     1     1     1     1     1     1     1     1     1
    21     1     4     1     3     3     7     2     6     4     2     5    10
    22     1     2     1     2     2     4     2     3     3     1     2     5
    23     1     4     1     3     3     5     2     5     3     2     4     6
    24     1     3     1     3     2     4     2     3     3     2     4     5
    25     1     4     1     3     3     7     2     6     4     2     5    10
    26     1     2     1     2     2     2     2     2     2     1     1     2
    27     1     1     1     1     1     1     1     1     1     1     1     1
    28     1     2     1     1     2     2     1     2     2     2     2     2
    29     1     2     1     2     2     2     1     2     2     1     3     2
    30     1     3     1     2     4     4     1     4     3     2     6     4
    31     1     1     1     1     2     5     3     5     2     1     5     4
        V847  V848  V849  V850  V851  V852  V853  V854  V855  V856  V857  V858
    1    E_5   E_5   E_5   E_5   E_5   E_5   E_5   E_5   E_5   E_5   E_5   E_5
    2    C_4   C_5   C_6   D_2   D_3   D_4   D_5   D_6   E_1   E_2   E_3   E_4
    3     15   130    53     7     1     5    48    17    11   761   326   300
    4      1     2     3     1     1     1     2     1     1     5     4     4
    5      9     8     8     3     1     4     8     5     4     9     9     9
    6      3     3     3     2     1     3     3     3     3     3     3     3
    7      2     3     3     2     1     2     3     2     3     3     3     3
    8      9    54    29     3     1     4    23     7     5   106    85    74
    9      7    74    29     3     1     4    17     7     4    81    59    41
    10     9    73    32     3     1     4    23     9     5   160   109   107
    11     1     1     1     1     1     1     1     1     1     1     1     1
    12     1     1     1     1     1     1     1     1     1     1     1     1
    13     1     1     1     1     1     1     1     1     1     1     1     1
    14     1     1     1     1     1     1     1     1     1     1     1     1
    15     1     1     1     1     1     1     1     1     1     1     1     1
    16     1     1     1     1     1     1     1     1     1     1     1     1
    17     1     1     1     1     1     1     1     1     1     1     1     1
    18     1     1     1     1     1     1     1     1     1     1     1     1
    19     1     1     1     1     1     1     1     1     1     1     1     1
    20     1     1     1     1     1     1     1     1     1     1     1     1
    21     4    10     7     1     1     2     5     4     3    12    12    13
    22     3     3     4     1     1     2     4     4     1     5     4     6
    23     2     7     5     1     1     2     3     3     3     6     8     7
    24     2     5     4     1     1     2     3     2     3     5     6     5
    25     4    10     7     1     1     2     5     4     3    12    12    13
    26     1     2     2     1     1     1     1     2     1     2     2     2
    27     1     1     1     1     1     1     2     1     1     2     2     2
    28     2     2     2     2     1     2     2     2     2     2     2     2
    29     2     3     2     2     1     2     2     2     2     3     3     3
    30     3     5     4     3     1     3     5     4     4     9     7     8
    31     5     6     5     2     1     2     6     4     4     8     8     8
        V859  V860  V861  V862  V863  V864  V865  V866  V867  V868  V869  V870
    1    E_5   E_5   E_5   E_5   E_5   E_5   E_6   E_6   E_6   E_6   E_6   E_6
    2    E_5   E_6   F_3   F_4   F_5   F_6   A_1   A_2   A_3   A_5   A_6   B_1
    3   3483   194     8     1     6     1     3     1     3     8     6    11
    4      5     4     2     1     1     1     1     1     1     1     1     1
    5      9     9     4     1     4     1     2     1     1     4     2     5
    6      3     3     3     1     3     1     2     1     1     3     2     3
    7      3     3     3     1     1     1     2     1     2     2     2     2
    8    229    63     5     1     5     1     2     1     2     2     3     6
    9    227    49     6     1     6     1     2     1     2     6     2     6
    10   290    79     6     1     6     1     2     1     2     3     3     6
    11     1     1     1     1     1     1     1     1     1     1     1     1
    12     1     1     1     1     1     1     1     1     1     1     1     1
    13     1     1     1     1     1     1     1     1     1     1     1     1
    14     1     1     1     1     1     1     1     1     1     1     1     1
    15     1     1     1     1     1     1     1     1     1     1     1     1
    16     1     1     1     1     1     1     1     1     1     1     1     1
    17     1     1     1     1     1     1     1     1     1     1     1     1
    18     1     1     1     1     1     1     1     1     1     1     1     1
    19     1     1     1     1     1     1     1     1     1     1     1     1
    20     1     1     1     1     1     1     1     1     1     1     1     1
    21    21    15     3     1     5     1     2     1     2     3     2     5
    22     6     5     2     1     4     1     2     1     2     2     2     3
    23    11     8     3     1     3     1     1     1     2     3     2     5
    24     6     6     3     1     2     1     1     1     2     3     1     4
    25    21    15     3     1     5     1     2     1     2     3     2     5
    26     2     2     1     1     2     1     1     1     2     2     2     2
    27     2     2     1     1     1     1     1     1     1     1     1     1
    28     2     2     2     1     2     1     1     1     2     2     2     2
    29     3     3     2     1     3     1     1     1     2     2     2     2
    30    10     7     3     1     4     1     1     1     2     3     4     2
    31     9     8     1     1     2     1     1     1     1     4     3     2
        V871  V872  V873  V874  V875  V876  V877  V878  V879  V880  V881  V882
    1    E_6   E_6   E_6   E_6   E_6   E_6   E_6   E_6   E_6   E_6   E_6   E_6
    2    B_2   B_3   B_4   B_5   B_6   C_1   C_2   C_3   C_4   C_5   C_6   D_2
    3     20    10     1    23    11     5    32    25     3   112    89     3
    4      1     1     1     2     2     1     1     1     1     3     3     1
    5      7     6     1     7     4     3     6     5     3     8     8     2
    6      3     3     1     3     3     2     3     3     3     3     3     2
    7      2     2     1     3     3     2     3     3     1     3     3     2
    8     11     8     1    11     8     4    19    15     3    39    33     2
    9     15     8     1    14     8     3    23    15     3    59    48     2
    10    13     8     1    14     9     4    21    17     3    54    46     2
    11     1     1     1     1     1     1     1     1     1     1     1     1
    12     1     1     1     1     1     1     1     1     1     1     1     1
    13     1     1     1     1     1     1     1     1     1     1     1     1
    14     1     1     1     1     1     1     1     1     1     1     1     1
    15     1     1     1     1     1     1     1     1     1     1     1     1
    16     1     1     1     1     1     1     1     1     1     1     1     1
    17     1     1     1     1     1     1     1     1     1     1     1     1
    18     1     1     1     1     1     1     1     1     1     1     1     1
    19     1     1     1     1     1     1     1     1     1     1     1     1
    20     1     1     1     1     1     1     1     1     1     1     1     1
    21     4     6     1     8     4     2     6     5     2     6     4     1
    22     3     4     1     4     3     2     2     3     2     3     3     1
    23     4     5     1     8     3     2     4     4     2     5     3     1
    24     4     4     1     5     2     2     4     3     2     4     2     1
    25     4     6     1     8     4     2     6     5     2     6     4     1
    26     2     2     1     2     2     1     1     2     1     2     2     1
    27     1     1     1     1     1     1     1     1     1     1     1     1
    28     2     2     1     2     2     2     2     2     1     2     2     2
    29     2     3     1     2     2     3     2     2     1     3     2     1
    30     4     5     1     4     3     4     4     4     1     5     4     2
    31     3     1     1     5     5     2     4     4     3     6     6     2
        V883  V884  V885  V886  V887  V888  V889  V890  V891  V892  V893  V894
    1    E_6   E_6   E_6   E_6   E_6   E_6   E_6   E_6   E_6   E_6   E_6   E_6
    2    D_3   D_4   D_5   D_6   E_1   E_2   E_3   E_4   E_5   E_6   F_3   F_4
    3      1     1    21    22     9    32    84    33   194  1215     1     2
    4      1     1     1     1     1     1     4     2     5     5     1     1
    5      1     1     7     7     5     8     8     6     9     9     1     1
    6      1     1     3     3     3     3     3     3     3     3     1     1
    7      1     1     2     3     2     2     3     3     3     3     1     1
    8      1     1    12    13     4    13    24    10    52   118     1     1
    9      1     1    14    16     4    14    28     8    67   116     1     1
    10     1     1    12    15     3    16    34    12    82   154     1     1
    11     1     1     1     1     1     1     1     1     1     1     1     1
    12     1     1     1     1     1     1     1     1     1     1     1     1
    13     1     1     1     1     1     1     1     1     1     1     1     1
    14     1     1     1     1     1     1     1     1     1     1     1     1
    15     1     1     1     1     1     1     1     1     1     1     1     1
    16     1     1     1     1     1     1     1     1     1     1     1     1
    17     1     1     1     1     1     1     1     1     1     1     1     1
    18     1     1     1     1     1     1     1     1     1     1     1     1
    19     1     1     1     1     1     1     1     1     1     1     1     1
    20     1     1     1     1     1     1     1     1     1     1     1     1
    21     1     1     4     4     2     5    10     4    13    19     1     1
    22     1     1     3     4     1     2     3     2     5     6     1     1
    23     1     1     2     3     2     4     8     4     7    11     1     1
    24     1     1     2     3     2     4     6     4     5     6     1     1
    25     1     1     4     4     2     5    10     4    13    19     1     1
    26     1     1     1     2     1     1     2     2     2     2     1     1
    27     1     1     1     1     1     1     2     1     2     2     1     1
    28     1     1     2     2     2     2     2     2     2     2     1     1
    29     1     1     2     2     1     2     3     2     3     3     1     1
    30     1     1     3     4     2     4     7     4     7     8     1     1
    31     1     1     3     7     2     8     8     6     8     9     1     1
        V895  V896  V897  V898  V899  V900  V901  V902  V903  V904  V905  V906
    1    E_6   E_6   F_1   F_1   F_1   F_1   F_1   F_1   F_1   F_1   F_1   F_1
    2    F_5   F_6   A_1   A_2   A_3   A_4   B_1   B_2   B_3   B_4   B_5   B_6
    3      6    14     4     1     2     1     2     6     4     6     1     1
    4      1     2     3     1     1     1     2     1     1     2     1     1
    5      3     5     3     1     2     1     2     5     4     2     1     1
    6      3     3     1     1     2     1     1     3     3     2     1     1
    7      1     2     2     1     2     1     2     2     3     1     1     1
    8      4     6     4     1     2     1     2     5     4     4     1     1
    9      4     8     4     1     2     1     2     6     4     4     1     1
    10     4     8     4     1     2     1     2     6     4     4     1     1
    11     1     1     1     1     1     1     1     1     1     1     1     1
    12     1     1     1     1     1     1     1     1     1     1     1     1
    13     1     1     1     1     1     1     1     1     1     1     1     1
    14     1     1     1     1     1     1     1     1     1     1     1     1
    15     1     1     1     1     1     1     1     1     1     1     1     1
    16     1     1     1     1     1     1     1     1     1     1     1     1
    17     1     1     1     1     1     1     1     1     1     1     1     1
    18     1     1     1     1     1     1     1     1     1     1     1     1
    19     1     1     1     1     1     1     1     1     1     1     1     1
    20     1     1     1     1     1     1     1     1     1     1     1     1
    21     4     4     3     1     2     1     2     5     4     2     1     1
    22     3     4     3     1     1     1     2     3     2     2     1     1
    23     2     3     3     1     2     1     2     5     4     2     1     1
    24     2     2     2     1     2     1     1     4     4     2     1     1
    25     4     4     3     1     2     1     2     5     4     2     1     1
    26     1     2     2     1     1     1     2     2     2     2     1     1
    27     1     1     1     1     1     1     2     1     1     1     1     1
    28     2     2     2     1     1     1     1     1     1     2     1     1
    29     2     2     2     1     1     1     2     2     2     1     1     1
    30     3     4     3     1     1     1     2     2     2     2     1     1
    31     3     4     2     1     1     1     1     1     2     1     1     1
        V907  V908  V909  V910  V911  V912  V913  V914  V915  V916  V917  V918
    1    F_1   F_1   F_1   F_1   F_1   F_1   F_1   F_1   F_1   F_1   F_1   F_1
    2    C_1   C_2   C_3   C_4   C_5   C_6   D_3   D_5   E_5   E_6   F_1   F_2
    3      2     4     5     6    13     6     1     1     1     1   775   594
    4      1     2     1     1     2     1     1     1     1     1     6     7
    5      2     2     3     2     4     2     1     1     1     1     9     9
    6      2     2     1     2     2     2     1     1     1     1     3     3
    7      1     2     2     2     2     2     1     1     1     1     3     3
    8      2     2     4     4     8     5     1     1     1     1    34    41
    9      2     2     4     2    10     5     1     1     1     1    33   109
    10     2     2     4     3    10     5     1     1     1     1   132   165
    11     1     1     1     1     1     1     1     1     1     1     1     1
    12     1     1     1     1     1     1     1     1     1     1     1     1
    13     1     1     1     1     1     1     1     1     1     1     1     1
    14     1     1     1     1     1     1     1     1     1     1     1     1
    15     1     1     1     1     1     1     1     1     1     1     1     1
    16     1     1     1     1     1     1     1     1     1     1     1     1
    17     1     1     1     1     1     1     1     1     1     1     1     1
    18     1     1     1     1     1     1     1     1     1     1     1     1
    19     1     1     1     1     1     1     1     1     1     1     1     1
    20     1     1     1     1     1     1     1     1     1     1     1     1
    21     1     1     3     2     4     2     1     1     1     1    15    14
    22     1     1     3     1     3     1     1     1     1     1     4     5
    23     1     1     3     2     4     2     1     1     1     1    10    10
    24     1     1     3     2     4     2     1     1     1     1     5     6
    25     1     1     3     2     4     2     1     1     1     1    15    14
    26     1     1     2     1     2     1     1     1     1     1     2     2
    27     1     1     1     1     1     1     1     1     1     1     2     2
    28     1     1     1     2     2     2     1     1     1     1     2     2
    29     1     2     2     2     1     2     1     1     1     1     3     3
    30     1     2     2     3     2     3     1     1     1     1    10    11
    31     2     1     1     2     4     2     1     1     1     1     5     7
        V919  V920  V921  V922  V923  V924  V925  V926  V927  V928  V929  V930
    1    F_1   F_1   F_1   F_1   F_2   F_2   F_2   F_2   F_2   F_2   F_2   F_2
    2    F_3   F_4   F_5   F_6   A_1   A_2   A_3   A_4   A_5   A_6   B_1   B_2
    3    241    68   154    15    42    63    98     6    25     1     4    18
    4      7     3     4     1     4     2     5     1     2     1     2     2
    5      9     7     9     4     7     8     9     5     5     1     4     7
    6      3     3     3     3     3     3     3     3     3     1     3     3
    7      3     2     2     3     3     3     3     2     3     1     1     3
    8     39    22    31     9    27    41    58     4    16     1     4    14
    9     71    23    57    10    28    40    66     4    15     1     4    15
    10   120    39    76    11    29    41    72     4    17     1     4    15
    11     1     1     1     1     1     1     1     1     1     1     1     1
    12     1     1     1     1     1     1     1     1     1     1     1     1
    13     1     1     1     1     1     1     1     1     1     1     1     1
    14     1     1     1     1     1     1     1     1     1     1     1     1
    15     1     1     1     1     1     1     1     1     1     1     1     1
    16     1     1     1     1     1     1     1     1     1     1     1     1
    17     1     1     1     1     1     1     1     1     1     1     1     1
    18     1     1     1     1     1     1     1     1     1     1     1     1
    19     1     1     1     1     1     1     1     1     1     1     1     1
    20     1     1     1     1     1     1     1     1     1     1     1     1
    21    12     6    13     3     7     9    13     3     6     1     3     5
    22     4     2     4     1     4     3     4     2     3     1     2     4
    23    10     6    11     3     6     6     9     3     5     1     3     5
    24     6     5     6     3     4     4     6     3     3     1     2     3
    25    12     6    13     3     7     9    13     3     6     1     3     5
    26     2     2     2     1     2     2     2     2     2     1     2     2
    27     2     2     2     1     1     1     1     1     1     1     1     1
    28     2     2     2     2     2     2     2     1     2     1     2     2
    29     3     3     3     3     2     2     3     2     2     1     2     2
    30     8     6     7     4     4     4     5     2     3     1     3     4
    31     8     5     7     5     5     5     6     2     4     1     1     1
        V931  V932  V933  V934  V935  V936  V937  V938  V939  V940  V941  V942
    1    F_2   F_2   F_2   F_2   F_2   F_2   F_2   F_2   F_2   F_2   F_2   F_2
    2    B_3   B_4   B_5   B_6   C_2   C_3   C_4   C_5   C_6   D_2   D_3   D_5
    3     24     9    14     1    34    30    22   111    38     4     6     4
    4      2     1     2     1     3     1     1     4     1     1     1     1
    5      7     3     6     1     8     7     5     8     5     3     5     2
    6      3     2     3     1     3     3     3     3     3     3     2     2
    7      3     2     3     1     2     3     2     3     3     2     2     2
    8     17     6    11     1    22    20    14    58    21     3     6     3
    9     16     5    11     1    20    20    14    56    23     3     6     3
    10    17     5    11     1    22    23    14    76    26     3     6     3
    11     1     1     1     1     1     1     1     1     1     1     1     1
    12     1     1     1     1     1     1     1     1     1     1     1     1
    13     1     1     1     1     1     1     1     1     1     1     1     1
    14     1     1     1     1     1     1     1     1     1     1     1     1
    15     1     1     1     1     1     1     1     1     1     1     1     1
    16     1     1     1     1     1     1     1     1     1     1     1     1
    17     1     1     1     1     1     1     1     1     1     1     1     1
    18     1     1     1     1     1     1     1     1     1     1     1     1
    19     1     1     1     1     1     1     1     1     1     1     1     1
    20     1     1     1     1     1     1     1     1     1     1     1     1
    21     7     2     9     1     7     6     8    10     5     3     5     2
    22     3     2     4     1     3     3     6     4     2     3     5     2
    23     7     2     6     1     5     4     6     6     4     2     5     2
    24     5     2     5     1     5     3     4     5     4     2     4     2
    25     7     2     9     1     7     6     8    10     5     3     5     2
    26     2     2     2     1     2     2     2     2     1     2     2     1
    27     1     1     1     1     2     1     1     1     1     1     1     1
    28     2     1     2     1     2     2     2     2     2     1     2     1
    29     2     3     1     1     3     3     3     2     2     1     3     2
    30     4     3     2     1     6     5     4     4     4     1     4     2
    31     2     1     2     1     5     3     4     8     3     2     1     2
        V943  V944  V945  V946  V947  V948  V949  V950  V951  V952  V953  V954
    1    F_2   F_2   F_2   F_2   F_2   F_2   F_2   F_2   F_2   F_3   F_3   F_3
    2    D_6   E_4   E_5   F_1   F_2   F_3   F_4   F_5   F_6   A_1   A_2   A_3
    3     10     2     1   613  5780  1776   655  1999    89    37    79   107
    4      1     1     1     7     7     7     5     7     1     3     3     3
    5      5     1     1     9     9     9     9     9     7     6     9     9
    6      3     1     1     3     3     3     3     3     3     3     3     3
    7      3     1     1     3     3     3     3     3     3     3     3     3
    8      6     1     1   113   600   410   192   434    40    20    44    42
    9      8     1     1    41   585   324   127   487    22    21    48    59
    10     8     1     1   165   784   640   274   743    46    21    55    70
    11     1     1     1     1     1     1     1     1     1     1     1     1
    12     1     1     1     1     1     1     1     1     1     1     1     1
    13     1     1     1     1     1     1     1     1     1     1     1     1
    14     1     1     1     1     1     1     1     1     1     1     1     1
    15     1     1     1     1     1     1     1     1     1     1     1     1
    16     1     1     1     1     1     1     1     1     1     1     1     1
    17     1     1     1     1     1     1     1     1     1     1     1     1
    18     1     1     1     1     1     1     1     1     1     1     1     1
    19     1     1     1     1     1     1     1     1     1     1     1     1
    20     1     1     1     1     1     1     1     1     1     1     1     1
    21     5     1     1    14    26    23    18    23     8     8    11    16
    22     4     1     1     4     6     5     5     6     4     4     4     5
    23     5     1     1     9    12    11    10    12     7     7     8     9
    24     4     1     1     6     6     6     6     6     5     5     5     6
    25     5     1     1    14    26    23    18    23     8     8    11    16
    26     2     1     1     2     2     2     2     2     2     2     2     2
    27     1     1     1     2     2     2     2     2     1     2     1     2
    28     2     1     1     2     2     2     2     2     2     2     2     2
    29     2     1     1     3     3     3     3     3     2     2     3     3
    30     3     1     1    11    10    11     9     8     4     5     5     6
    31     3     1     1     7     9     8     8     8     8     2     5     6
        V955  V956  V957  V958  V959  V960  V961  V962  V963  V964  V965  V966
    1    F_3   F_3   F_3   F_3   F_3   F_3   F_3   F_3   F_3   F_3   F_3   F_3
    2    A_4   A_5   A_6   B_1   B_2   B_3   B_4   B_5   B_6   C_1   C_2   C_3
    3      9    24     5    14    40    31     6    23    12     3    68    71
    4      2     2     2     1     2     2     1     3     2     1     3     2
    5      4     5     3     4     6     5     3     6     4     2     9     8
    6      3     3     2     3     3     2     3     3     3     1     3     3
    7      2     3     3     2     3     2     3     2     1     1     3     3
    8      6    13     2     8    19    10     5    14     8     2    29    35
    9      5    13     2     8    28    20     5    17     6     2    41    40
    10     7    13     4     9    28    24     5    17     7     2    36    50
    11     1     1     1     1     1     1     1     1     1     1     1     1
    12     1     1     1     1     1     1     1     1     1     1     1     1
    13     1     1     1     1     1     1     1     1     1     1     1     1
    14     1     1     1     1     1     1     1     1     1     1     1     1
    15     1     1     1     1     1     1     1     1     1     1     1     1
    16     1     1     1     1     1     1     1     1     1     1     1     1
    17     1     1     1     1     1     1     1     1     1     1     1     1
    18     1     1     1     1     1     1     1     1     1     1     1     1
    19     1     1     1     1     1     1     1     1     1     1     1     1
    20     1     1     1     1     1     1     1     1     1     1     1     1
    21     4     4     3     7     7    14     4     6     5     2    10    13
    22     3     3     3     4     3     5     2     2     3     1     4     4
    23     4     3     3     6     6     8     4     6     5     2     7     8
    24     3     3     3     5     3     5     4     4     4     2     5     5
    25     4     4     3     7     7    14     4     6     5     2    10    13
    26     2     2     2     2     2     2     2     2     2     1     2     2
    27     1     1     1     1     1     2     1     1     1     1     1     2
    28     1     2     2     2     2     2     2     2     2     2     2     2
    29     2     2     1     3     3     3     2     2     3     2     3     3
    30     2     3     2     5     5     8     3     4     4     3     5     7
    31     3     4     1     2     3     3     1     4     3     2     5     5
        V967  V968  V969  V970  V971  V972  V973  V974  V975  V976  V977  V978
    1    F_3   F_3   F_3   F_3   F_3   F_3   F_3   F_3   F_3   F_3   F_3   F_3
    2    C_4   C_5   C_6   D_2   D_3   D_4   D_5   D_6   E_2   E_4   E_5   E_6
    3     41   262    44     5     6     2     8     4     3     3     9     1
    4      3     3     2     1     2     1     2     1     1     1     2     1
    5      7     9     7     4     3     2     5     2     2     1     3     1
    6      3     3     3     3     2     1     3     1     2     1     3     1
    7      3     3     3     3     1     1     2     1     1     1     3     1
    8     24    99    24     5     4     1     5     2     2     1     7     1
    9     20   116    28     3     4     2     5     2     2     1     7     1
    10    26   139    32     4     5     1     5     2     2     1     7     1
    11     1     1     1     1     1     1     1     1     1     1     1     1
    12     1     1     1     1     1     1     1     1     1     1     1     1
    13     1     1     1     1     1     1     1     1     1     1     1     1
    14     1     1     1     1     1     1     1     1     1     1     1     1
    15     1     1     1     1     1     1     1     1     1     1     1     1
    16     1     1     1     1     1     1     1     1     1     1     1     1
    17     1     1     1     1     1     1     1     1     1     1     1     1
    18     1     1     1     1     1     1     1     1     1     1     1     1
    19     1     1     1     1     1     1     1     1     1     1     1     1
    20     1     1     1     1     1     1     1     1     1     1     1     1
    21     9    17     7     4     5     1     3     2     2     1     3     1
    22     4     5     4     2     4     1     3     2     2     1     3     1
    23     6     9     5     4     4     1     3     2     2     1     2     1
    24     5     5     5     4     3     1     3     2     2     1     2     1
    25     9    17     7     4     5     1     3     2     2     1     3     1
    26     2     2     2     1     2     1     1     1     1     1     1     1
    27     2     2     1     1     1     1     1     2     1     1     1     1
    28     2     2     2     1     1     2     2     2     2     2     2     1
    29     2     3     3     2     2     2     2     2     1     1     1     1
    30     5     7     5     2     2     2     3     2     2     2     2     1
    31     5     7     6     3     1     1     1     1     2     1     1     1
        V979  V980  V981  V982  V983  V984  V985  V986  V987  V988  V989  V990
    1    F_3   F_3   F_3   F_3   F_3   F_3   F_3   F_4   F_4   F_4   F_4   F_4
    2    F_1   F_2   F_3   F_4   F_5   F_6  <NA>   A_1   A_2   A_3   A_4   B_2
    3    229  1758  4937   862  2845    86     5     2     3     4     1     2
    4      7     7     7     7     7     2     1     2     1     1     1     1
    5      9     9     9     9     9     8     2     2     3     3     1     1
    6      3     3     3     3     3     3     2     2     3     2     1     1
    7      3     3     3     3     3     3     2     1     1     3     1     1
    8     66   322   436   196   419    30     1     2     2     3     1     1
    9     38   404   443   155   668    29     2     2     3     3     1     1
    10   110   607   878   349   925    42     4     2     3     3     1     1
    11     1     1     1     1     1     1     1     1     1     1     1     1
    12     1     1     1     1     1     1     1     1     1     1     1     1
    13     1     1     1     1     1     1     1     1     1     1     1     1
    14     1     1     1     1     1     1     1     1     1     1     1     1
    15     1     1     1     1     1     1     1     1     1     1     1     1
    16     1     1     1     1     1     1     1     1     1     1     1     1
    17     1     1     1     1     1     1     1     1     1     1     1     1
    18     1     1     1     1     1     1     1     1     1     1     1     1
    19     1     1     1     1     1     1     1     1     1     1     1     1
    20     1     1     1     1     1     1     1     1     1     1     1     1
    21    13    23    27    15    23    14     4     2     3     3     1     1
    22     5     5     6     5     5     5     3     2     2     3     1     1
    23    10    11    12     9    12     9     4     2     3     2     1     1
    24     6     6     6     6     6     6     3     2     3     2     1     1
    25    13    23    27    15    23    14     4     2     3     3     1     1
    26     2     2     2     2     2     2     2     1     2     2     1     1
    27     2     2     2     2     2     1     1     1     1     1     1     1
    28     2     2     2     2     2     2     1     2     2     1     1     1
    29     3     3     3     3     3     2     1     1     2     1     1     1
    30     8    11    11     9    10     4     1     2     3     1     1     1
    31     8     8     9     8     8     8     1     1     2     2     1     1
        V991  V992  V993  V994  V995  V996  V997  V998  V999 V1000 V1001 V1002
    1    F_4   F_4   F_4   F_4   F_4   F_4   F_4   F_4   F_4   F_4   F_4   F_4
    2    B_3   B_5   B_6   C_1   C_2   C_3   C_4   C_5   C_6   D_2   D_3   D_5
    3      1     2     2     1    13    20    40    77    19     4     3     8
    4      1     1     1     1     1     1     2     2     2     1     1     1
    5      1     2     1     1     5     6     8     8     3     2     2     2
    6      1     2     1     1     3     3     3     3     2     1     2     2
    7      1     1     1     1     2     2     3     2     3     2     2     2
    8      1     1     1     1     7    13    23    38    11     2     3     3
    9      1     1     1     1    10    12    23    44    10     2     3     4
    10     1     1     1     1     9    14    25    49    10     2     3     3
    11     1     1     1     1     1     1     1     1     1     1     1     1
    12     1     1     1     1     1     1     1     1     1     1     1     1
    13     1     1     1     1     1     1     1     1     1     1     1     1
    14     1     1     1     1     1     1     1     1     1     1     1     1
    15     1     1     1     1     1     1     1     1     1     1     1     1
    16     1     1     1     1     1     1     1     1     1     1     1     1
    17     1     1     1     1     1     1     1     1     1     1     1     1
    18     1     1     1     1     1     1     1     1     1     1     1     1
    19     1     1     1     1     1     1     1     1     1     1     1     1
    20     1     1     1     1     1     1     1     1     1     1     1     1
    21     1     1     1     1     5     5     6    10     4     2     3     1
    22     1     1     1     1     2     3     3     4     2     2     3     1
    23     1     1     1     1     4     4     4     6     3     2     3     1
    24     1     1     1     1     4     4     4     4     3     2     2     1
    25     1     1     1     1     5     5     6    10     4     2     3     1
    26     1     1     1     1     1     2     2     2     1     1     2     1
    27     1     1     1     1     1     2     2     1     1     1     1     1
    28     1     1     1     1     2     2     2     2     2     2     1     1
    29     1     1     1     1     3     3     3     3     2     2     2     2
    30     1     1     1     1     4     5     5     5     3     3     2     2
    31     1     1     1     1     3     6     7     7     4     1     2     3
       V1003 V1004 V1005 V1006 V1007 V1008 V1009 V1010 V1011 V1012 V1013 V1014
    1    F_4   F_4   F_4   F_4   F_4   F_4   F_4   F_4   F_4   F_4   F_4   F_4
    2    E_2   E_3   E_4   E_5   E_6   F_1   F_2   F_3   F_4   F_5   F_6  <NA>
    3      1     3     6     1     2    67   681   844  1648  1283    14     1
    4      1     2     2     1     1     3     6     7     6     6     1     1
    5      1     2     4     1     1     8     9     9     9     9     4     1
    6      1     2     3     1     1     3     3     3     3     3     2     1
    7      1     1     2     1     1     3     3     3     3     3     2     1
    8      1     2     2     1     1    26   127   152   190   171     7     1
    9      1     2     3     1     1    18   199   190   189   372     9     1
    10     1     2     2     1     1    38   278   355   323   469     9     1
    11     1     1     1     1     1     1     1     1     1     1     1     1
    12     1     1     1     1     1     1     1     1     1     1     1     1
    13     1     1     1     1     1     1     1     1     1     1     1     1
    14     1     1     1     1     1     1     1     1     1     1     1     1
    15     1     1     1     1     1     1     1     1     1     1     1     1
    16     1     1     1     1     1     1     1     1     1     1     1     1
    17     1     1     1     1     1     1     1     1     1     1     1     1
    18     1     1     1     1     1     1     1     1     1     1     1     1
    19     1     1     1     1     1     1     1     1     1     1     1     1
    20     1     1     1     1     1     1     1     1     1     1     1     1
    21     1     2     2     1     1     7    18    18    18    15     3     1
    22     1     1     2     1     1     3     5     5     5     5     1     1
    23     1     2     2     1     1     6    10    11    10     9     3     1
    24     1     2     2     1     1     5     6     6     6     6     3     1
    25     1     2     2     1     1     7    18    18    18    15     3     1
    26     1     1     1     1     1     2     2     2     2     2     1     1
    27     1     1     1     1     1     2     2     2     2     2     1     1
    28     1     1     2     1     1     2     2     2     2     2     2     1
    29     1     2     2     1     1     3     3     3     3     3     3     1
    30     1     2     3     1     1     7     9     9    12     9     4     1
    31     1     2     3     1     1     4     8     8     9     8     4     1
       V1015 V1016 V1017 V1018 V1019 V1020 V1021 V1022 V1023 V1024 V1025 V1026
    1    F_5   F_5   F_5   F_5   F_5   F_5   F_5   F_5   F_5   F_5   F_5   F_5
    2    A_1   A_2   A_3   A_4   A_5   A_6   B_1   B_2   B_3   B_4   B_5   B_6
    3     41    36    88     3    38     2    15    49    27     6    34    17
    4      2     2     4     2     1     1     1     3     2     1     1     3
    5      8     7     9     3     4     1     6     8     7     3     8     5
    6      3     3     3     2     3     1     3     3     3     2     3     3
    7      3     3     3     2     3     2     2     3     3     3     3     3
    8     26    22    53     3    21     2    10    25    18     6    18    13
    9     26    28    57     3    21     2    11    32    19     5    20    11
    10    26    26    62     3    21     2    10    36    19     6    23    12
    11     1     1     1     1     1     1     1     1     1     1     1     1
    12     1     1     1     1     1     1     1     1     1     1     1     1
    13     1     1     1     1     1     1     1     1     1     1     1     1
    14     1     1     1     1     1     1     1     1     1     1     1     1
    15     1     1     1     1     1     1     1     1     1     1     1     1
    16     1     1     1     1     1     1     1     1     1     1     1     1
    17     1     1     1     1     1     1     1     1     1     1     1     1
    18     1     1     1     1     1     1     1     1     1     1     1     1
    19     1     1     1     1     1     1     1     1     1     1     1     1
    20     1     1     1     1     1     1     1     1     1     1     1     1
    21     7     5    13     2     7     2     5     6    10     4     3     7
    22     4     3     4     2     4     2     3     3     4     3     3     3
    23     7     4    11     2     5     2     4     5     7     3     3     6
    24     5     4     6     2     4     2     3     3     5     3     2     4
    25     7     5    13     2     7     2     5     6    10     4     3     7
    26     2     2     2     2     2     2     2     2     2     2     2     2
    27     1     1     2     1     1     1     1     1     1     1     1     2
    28     2     2     2     2     2     1     2     2     2     2     2     2
    29     2     2     3     2     2     1     3     3     3     1     2     2
    30     3     4     6     3     3     1     4     5     4     2     4     5
    31     3     4     6     1     5     1     1     6     4     3     6     5
       V1027 V1028 V1029 V1030 V1031 V1032 V1033 V1034 V1035 V1036 V1037 V1038
    1    F_5   F_5   F_5   F_5   F_5   F_5   F_5   F_5   F_5   F_5   F_5   F_5
    2    C_1   C_2   C_3   C_4   C_5   C_6   D_2   D_3   D_4   D_5   D_6   E_2
    3      6   121   100    70   420   129     5     7     2    27    13     3
    4      1     1     2     2     4     2     1     1     1     1     1     1
    5      4     9     8     8     9     8     3     4     1     7     4     3
    6      3     3     3     3     3     3     2     2     1     3     3     2
    7      2     3     3     3     3     3     2     3     2     3     3     2
    8      5    56    60    41   166    71     4     4     2    20     9     3
    9      5    58    45    30   177    72     4     3     2    19     9     3
    10     6    67    59    42   229    80     4     4     2    23    10     3
    11     1     1     1     1     1     1     1     1     1     1     1     1
    12     1     1     1     1     1     1     1     1     1     1     1     1
    13     1     1     1     1     1     1     1     1     1     1     1     1
    14     1     1     1     1     1     1     1     1     1     1     1     1
    15     1     1     1     1     1     1     1     1     1     1     1     1
    16     1     1     1     1     1     1     1     1     1     1     1     1
    17     1     1     1     1     1     1     1     1     1     1     1     1
    18     1     1     1     1     1     1     1     1     1     1     1     1
    19     1     1     1     1     1     1     1     1     1     1     1     1
    20     1     1     1     1     1     1     1     1     1     1     1     1
    21     4     9    11     8    19    12     3     4     1     8     4     2
    22     3     3     4     5     6     4     2     1     1     4     3     2
    23     3     6     7     6    10     8     3     4     1     6     3     2
    24     3     5     5     4     6     6     3     4     1     5     3     2
    25     4     9    11     8    19    12     3     4     1     8     4     2
    26     2     2     2     2     2     2     2     1     1     2     2     1
    27     1     1     2     1     2     2     1     1     1     1     1     2
    28     2     2     2     2     2     2     2     2     2     2     2     2
    29     3     3     3     3     3     3     2     1     1     3     2     2
    30     5     6     7     6     7     7     3     2     2     5     4     3
    31     5     6     8     6     6     8     2     2     2     3     3     2
       V1039 V1040 V1041 V1042 V1043 V1044 V1045 V1046 V1047 V1048 V1049 V1050
    1    F_5   F_5   F_5   F_5   F_5   F_5   F_5   F_5   F_6   F_6   F_6   F_6
    2    E_5   E_6   F_1   F_2   F_3   F_4   F_5   F_6   A_1   A_2   A_3   A_5
    3      8     4   162  2004  2866  1275 12295   390     3     5    10     5
    4      1     1     5     7     7     7     7     4     1     2     2     1
    5      4     2     9     9     9     9     9     9     2     3     3     2
    6      3     2     3     3     3     3     3     3     2     2     2     2
    7      3     1     3     3     3     3     3     3     2     1     2     1
    8      6     3    65   486   672   361  1088   118     2     3     4     3
    9      6     3    29   427   412   170  1087    67     2     3     4     3
    10     6     3    83   739   957   471  1320   130     2     3     4     3
    11     1     1     1     1     1     1     1     1     1     1     1     1
    12     1     1     1     1     1     1     1     1     1     1     1     1
    13     1     1     1     1     1     1     1     1     1     1     1     1
    14     1     1     1     1     1     1     1     1     1     1     1     1
    15     1     1     1     1     1     1     1     1     1     1     1     1
    16     1     1     1     1     1     1     1     1     1     1     1     1
    17     1     1     1     1     1     1     1     1     1     1     1     1
    18     1     1     1     1     1     1     1     1     1     1     1     1
    19     1     1     1     1     1     1     1     1     1     1     1     1
    20     1     1     1     1     1     1     1     1     1     1     1     1
    21     3     2    13    23    24    13    26    14     2     2     4     2
    22     3     2     4     6     5     4     6     5     2     2     3     1
    23     1     2     9    11    12     8    12     8     2     2     3     2
    24     1     2     6     6     6     6     6     5     2     2     3     2
    25     3     2    13    23    24    13    26    14     2     2     4     2
    26     1     1     2     2     2     2     2     2     2     2     1     1
    27     1     1     2     2     2     2     2     1     1     1     1     1
    28     2     2     2     2     2     2     2     2     2     2     2     1
    29     3     2     3     3     3     3     3     3     1     2     2     1
    30     3     3     7     8     9     9    12     6     2     3     3     1
    31     2     2     8     8     8     8     9     8     1     1     1     1
       V1051 V1052 V1053 V1054 V1055 V1056 V1057 V1058 V1059 V1060 V1061 V1062
    1    F_6   F_6   F_6   F_6   F_6   F_6   F_6   F_6   F_6   F_6   F_6   F_6
    2    B_1   B_2   B_3   B_5   B_6   C_1   C_2   C_3   C_4   C_5   C_6   D_2
    3      8    21    19    12    20     1    17    35     1    35    79     4
    4      2     1     3     2     2     1     2     1     1     1     3     1
    5      5     3     7     6     6     1     6     7     1     8     7     3
    6      3     3     3     3     3     1     3     3     1     3     3     2
    7      2     2     3     3     2     1     3     3     1     3     3     1
    8      5     9    12     7    10     1    12    17     1    20    31     3
    9      5     9    13     8    12     1    13    17     1    22    39     2
    10     5    10    13     9    12     1    13    19     1    27    42     3
    11     1     1     1     1     1     1     1     1     1     1     1     1
    12     1     1     1     1     1     1     1     1     1     1     1     1
    13     1     1     1     1     1     1     1     1     1     1     1     1
    14     1     1     1     1     1     1     1     1     1     1     1     1
    15     1     1     1     1     1     1     1     1     1     1     1     1
    16     1     1     1     1     1     1     1     1     1     1     1     1
    17     1     1     1     1     1     1     1     1     1     1     1     1
    18     1     1     1     1     1     1     1     1     1     1     1     1
    19     1     1     1     1     1     1     1     1     1     1     1     1
    20     1     1     1     1     1     1     1     1     1     1     1     1
    21     3     4     6     5     8     1     9     7     1     7    10     2
    22     2     3     3     4     4     1     3     3     1     3     5     2
    23     3     3     6     5     7     1     6     5     1     5     7     2
    24     3     3     5     4     5     1     4     4     1     3     5     2
    25     3     4     6     5     8     1     9     7     1     7    10     2
    26     2     2     2     2     2     1     2     2     1     2     2     1
    27     1     1     1     1     1     1     1     1     1     1     1     1
    28     2     2     2     2     2     1     2     2     1     2     2     2
    29     2     3     2     2     2     1     2     2     1     2     3     2
    30     3     4     3     4     4     1     4     4     1     4     5     2
    31     1     1     2     5     5     1     5     5     1     6     8     2
       V1063 V1064 V1065 V1066 V1067 V1068 V1069 V1070 V1071 V1072 V1073 V1074
    1    F_6   F_6   F_6   F_6   F_6   F_6   F_6   F_6   F_6   F_6   F_6   F_6
    2    D_5   D_6   E_2   E_3   E_4   E_5   E_6   F_1   F_2   F_3   F_4   F_5
    3      8    26     1     2     2     1     9    10    83    71    15   398
    4      1     2     1     1     1     1     2     2     1     2     1     4
    5      4     7     1     1     1     1     5     5     9     8     5     9
    6      2     3     1     1     1     1     3     2     3     3     3     3
    7      2     3     1     1     1     1     2     3     3     3     3     3
    8      5    18     1     1     1     1     7     7    23    23     7    63
    9      6    17     1     1     1     1     6     6    39    27     8   116
    10     5    19     1     1     1     1     7     8    43    40     9   128
    11     1     1     1     1     1     1     1     1     1     1     1     1
    12     1     1     1     1     1     1     1     1     1     1     1     1
    13     1     1     1     1     1     1     1     1     1     1     1     1
    14     1     1     1     1     1     1     1     1     1     1     1     1
    15     1     1     1     1     1     1     1     1     1     1     1     1
    16     1     1     1     1     1     1     1     1     1     1     1     1
    17     1     1     1     1     1     1     1     1     1     1     1     1
    18     1     1     1     1     1     1     1     1     1     1     1     1
    19     1     1     1     1     1     1     1     1     1     1     1     1
    20     1     1     1     1     1     1     1     1     1     1     1     1
    21     4     7     1     1     1     1     2     2     9    10     4    17
    22     4     5     1     1     1     1     2     1     3     5     2     5
    23     4     5     1     1     1     1     1     2     8     6     3    10
    24     4     4     1     1     1     1     1     2     6     4     3     6
    25     4     7     1     1     1     1     2     2     9    10     4    17
    26     2     2     1     1     1     1     1     1     2     2     1     2
    27     1     1     1     1     1     1     1     1     1     1     1     1
    28     2     2     1     1     1     1     2     1     2     2     2     2
    29     2     2     1     1     1     1     2     2     3     3     2     3
    30     2     4     1     1     1     1     4     2     5     5     4     6
    31     4     4     1     1     1     1     4     5     6     8     4     8
       V1075 V1076 V1077 V1078 V1079 V1080 V1081 V1082 V1083 V1084 V1085 V1086
    1    F_6  <NA>  <NA>  <NA>  <NA>  <NA>  <NA>  <NA>  <NA>  <NA>  <NA>  <NA>
    2    F_6   A_1   A_2   A_3   A_5   A_6   B_1   B_2   B_3   B_4   B_5   B_6
    3    924    16     9    56     7     3    15    22    22     7    14    10
    4      5     3     3     2     2     1     2     2     2     2     4     2
    5      9     4     4     5     2     1     5     7     6     4     6     4
    6      3     2     2     3     2     1     2     3     3     3     3     3
    7      3     2     2     3     1     2     2     2     2     3     3     2
    8     98     2     3     2     2     1     1     3     3     2     4     2
    9     98     5     7    17     3     1     7    16    13     5    10     7
    10   123     4     7    38     6     2     7    15    13     4    10     7
    11     1     1     1     1     1     1     1     1     1     1     1     1
    12     1     1     1     1     1     1     1     1     1     1     1     1
    13     1     1     1     1     1     1     1     1     1     1     1     1
    14     1     1     1     1     1     1     1     1     1     1     1     1
    15     1     1     1     1     1     1     1     1     1     1     1     1
    16     1     1     1     1     1     1     1     1     1     1     1     1
    17     1     1     1     1     1     1     1     1     1     1     1     1
    18     1     1     1     1     1     1     1     1     1     1     1     1
    19     1     1     1     1     1     1     1     1     1     1     1     1
    20     1     1     1     1     1     1     1     1     1     1     1     1
    21    21     2     4    17     5     2     5     4     8     4     4     4
    22     6     2     4     6     3     1     3     2     3     4     3     3
    23    10     2     4    10     5     2     5     4     8     4     4     4
    24     6     2     4     6     3     2     5     4     5     3     3     4
    25    21     2     4    17     5     2     5     4     8     4     4     4
    26     2     2     3     2     2     1     2     2     3     3     3     3
    27     1     1     1     1     1     1     1     1     1     1     1     1
    28     2     2     2     2     2     2     2     2     2     2     2     2
    29     3     2     2     3     2     1     2     2     2     2     3     2
    30     6     3     4     5     3     2     3     4     4     2     5     3
    31     9     4     6     3     2     1     3     6     5     3     6     4
       V1087 V1088 V1089 V1090 V1091 V1092 V1093 V1094
    1   <NA>  <NA>  <NA>  <NA>  <NA>  <NA>  <NA>  <NA>
    2    C_2   C_3   C_5   C_6   D_6   F_3   F_4  <NA>
    3      5     1    23     8     4     8     1    12
    4      1     1     4     2     1     1     1     2
    5      2     1     3     3     1     2     1     5
    6      2     1     2     2     1     2     1     2
    7      2     1     2     2     1     2     1     3
    8      1     1     1     1     1     2     1     2
    9      2     1    11     5     1     1     1     2
    10     2     1    11     5     1     5     1     3
    11     1     1     1     1     1     1     1     1
    12     1     1     1     1     1     1     1     1
    13     1     1     1     1     1     1     1     1
    14     1     1     1     1     1     1     1     1
    15     1     1     1     1     1     1     1     1
    16     1     1     1     1     1     1     1     1
    17     1     1     1     1     1     1     1     1
    18     1     1     1     1     1     1     1     1
    19     1     1     1     1     1     1     1     1
    20     1     1     1     1     1     1     1     1
    21     2     1     3     2     1     4     1     2
    22     1     1     1     1     1     3     1     2
    23     2     1     3     2     1     4     1     2
    24     2     1     3     2     1     4     1     2
    25     2     1     3     2     1     4     1     2
    26     1     1     1     1     1     2     1     2
    27     1     1     1     1     1     1     1     1
    28     2     1     2     2     1     2     1     2
    29     1     1     2     1     1     1     1     2
    30     2     1     3     2     1     2     1     3
    31     2     1     5     2     1     1     1     3

## Data:

## Data: make analysis dataset (wider)

This is based on notes from here:
<https://docs.google.com/spreadsheets/d/1ERafo_dtfzE6o0_MMA9KZGOPj6Jkycqd/edit?usp=sharing&ouid=109372603671818325634&rtpof=true&sd=true>

make wider dataset to examine further:

then use the smaller to make wider dataset. This is to make the modes go
across rather than down

``` r
df_trips_only_small <- df_trips_only_small |>
  mutate(onePerObs = 1)
```

``` r
df_trips_only_small_wide <- df_trips_only_small  |>
  group_by(origin_geoXmicrotype_ATB,dest_geoXmicrotype_ATB) %>% 
  summarise("Number Obs" = n(),
            across(contains("_ATB"),~n_distinct(.x),.names = "{.col}"),
    .groups = "drop")
df_trips_only_small_wide
```

    # A tibble: 1,094 × 31
       origin_geoXmicrotype_ATB dest_geoXmicrotype_ATB `Number Obs` mode_ATB
       <chr>                    <chr>                         <int>    <int>
     1 A_1                      A_1                           23776        7
     2 A_1                      A_2                            6717        7
     3 A_1                      A_3                            5960        7
     4 A_1                      A_4                             827        7
     5 A_1                      A_5                            1367        7
     6 A_1                      A_6                             147        6
     7 A_1                      B_1                              33        4
     8 A_1                      B_2                              89        5
     9 A_1                      B_3                              80        4
    10 A_1                      B_4                              38        4
    # ℹ 1,084 more rows
    # ℹ 27 more variables: trip_purpose_ATB <int>, trip_purpose_small_ATB <int>,
    #   start_time_bin_ATB <int>, orig_fips11_ATB <int>, dest_fips11_ATB <int>,
    #   hh_fips11_ATB <int>, origin_microtypeXgeotype_ATB <int>,
    #   origin_geotype_ATB <int>, origin_microXgeo2types_ATB <int>,
    #   origin_microtype_ATB <int>, origin_geo2types_ATB <int>,
    #   dest_microtypeXgeotype_ATB <int>, dest_geotype_ATB <int>, …

#### How many have all 7 modes?

``` r
df_trips_only_small_wide  %>% 
  pivot_wider(
    names_from = mode_ATB,
    values_from = "Number Obs",
    values_fn = sum
  )
```

    # A tibble: 1,094 × 36
       origin_geoXmicrotype_ATB dest_geoXmicrotype_ATB trip_purpose_ATB
       <chr>                    <chr>                             <int>
     1 A_1                      A_1                                   9
     2 A_1                      A_2                                   9
     3 A_1                      A_3                                   9
     4 A_1                      A_4                                   9
     5 A_1                      A_5                                   9
     6 A_1                      A_6                                   9
     7 A_1                      B_1                                   8
     8 A_1                      B_2                                   9
     9 A_1                      B_3                                   8
    10 A_1                      B_4                                   7
    # ℹ 1,084 more rows
    # ℹ 33 more variables: trip_purpose_small_ATB <int>, start_time_bin_ATB <int>,
    #   orig_fips11_ATB <int>, dest_fips11_ATB <int>, hh_fips11_ATB <int>,
    #   origin_microtypeXgeotype_ATB <int>, origin_geotype_ATB <int>,
    #   origin_microXgeo2types_ATB <int>, origin_microtype_ATB <int>,
    #   origin_geo2types_ATB <int>, dest_microtypeXgeotype_ATB <int>,
    #   dest_geotype_ATB <int>, dest_microXgeo2types_ATB <int>, …

``` r
df_trips_only_small_wide
```

    # A tibble: 1,094 × 31
       origin_geoXmicrotype_ATB dest_geoXmicrotype_ATB `Number Obs` mode_ATB
       <chr>                    <chr>                         <int>    <int>
     1 A_1                      A_1                           23776        7
     2 A_1                      A_2                            6717        7
     3 A_1                      A_3                            5960        7
     4 A_1                      A_4                             827        7
     5 A_1                      A_5                            1367        7
     6 A_1                      A_6                             147        6
     7 A_1                      B_1                              33        4
     8 A_1                      B_2                              89        5
     9 A_1                      B_3                              80        4
    10 A_1                      B_4                              38        4
    # ℹ 1,084 more rows
    # ℹ 27 more variables: trip_purpose_ATB <int>, trip_purpose_small_ATB <int>,
    #   start_time_bin_ATB <int>, orig_fips11_ATB <int>, dest_fips11_ATB <int>,
    #   hh_fips11_ATB <int>, origin_microtypeXgeotype_ATB <int>,
    #   origin_geotype_ATB <int>, origin_microXgeo2types_ATB <int>,
    #   origin_microtype_ATB <int>, origin_geo2types_ATB <int>,
    #   dest_microtypeXgeotype_ATB <int>, dest_geotype_ATB <int>, …

``` r
# df_trips_only_small %>% 
#   count(origin_geoXmicrotype_ATB,dest_geoXmicrotype_ATB) %>% 
#   pivot_wider(names_from = dest_geoXmicrotype_ATB,values_from = n)
```

### make county level dataset

``` r
# df_county_origin <- df_trips_only_small |>
#   group_by(ORIG_ST,ORIG_CNTY) |>
#   summarise(Ntrips = n(),
#             across(contains("mode_ATB"),~n_distinct(.x),.names = "{.col}_Ndis"),
#     .groups = "drop")
# df_county_origin
```

### make microXgeotype level dataset

``` r
df_microXgeotype <- df_trips_only_small |>
  group_by(origin_geoXmicrotype_ATB,dest_geoXmicrotype_ATB) |>
  summarise(Ntrips = n(),
            across(contains("_ATB"),~n_distinct(.x),.names = "{.col}_Ndis"),
    .groups = "drop")
df_microXgeotype
```

    # A tibble: 1,094 × 31
       origin_geoXmicrotype_ATB dest_geoXmicrotype_ATB Ntrips mode_ATB_Ndis
       <chr>                    <chr>                   <int>         <int>
     1 A_1                      A_1                     23776             7
     2 A_1                      A_2                      6717             7
     3 A_1                      A_3                      5960             7
     4 A_1                      A_4                       827             7
     5 A_1                      A_5                      1367             7
     6 A_1                      A_6                       147             6
     7 A_1                      B_1                        33             4
     8 A_1                      B_2                        89             5
     9 A_1                      B_3                        80             4
    10 A_1                      B_4                        38             4
    # ℹ 1,084 more rows
    # ℹ 27 more variables: trip_purpose_ATB_Ndis <int>,
    #   trip_purpose_small_ATB_Ndis <int>, start_time_bin_ATB_Ndis <int>,
    #   orig_fips11_ATB_Ndis <int>, dest_fips11_ATB_Ndis <int>,
    #   hh_fips11_ATB_Ndis <int>, origin_microtypeXgeotype_ATB_Ndis <int>,
    #   origin_geotype_ATB_Ndis <int>, origin_microXgeo2types_ATB_Ndis <int>,
    #   origin_microtype_ATB_Ndis <int>, origin_geo2types_ATB_Ndis <int>, …

## START HERE DEC 14!!

## This is where put the modes wider

After count, then next step is to get the proportion

``` r
names(df_trips_only_small)
```

     [1] "mode_ATB"                     "trip_purpose_ATB"            
     [3] "trip_purpose_small_ATB"       "start_time_bin_ATB"          
     [5] "orig_fips11_ATB"              "dest_fips11_ATB"             
     [7] "hh_fips11_ATB"                "origin_microtypeXgeotype_ATB"
     [9] "origin_geotype_ATB"           "origin_microXgeo2types_ATB"  
    [11] "origin_microtype_ATB"         "origin_geoXmicrotype_ATB"    
    [13] "origin_geo2types_ATB"         "dest_microtypeXgeotype_ATB"  
    [15] "dest_geotype_ATB"             "dest_microXgeo2types_ATB"    
    [17] "dest_microtype_ATB"           "dest_geoXmicrotype_ATB"      
    [19] "dest_geo2types_ATB"           "hh_microtypeXgeotype_ATB"    
    [21] "hh_geotype_ATB"               "hh_microXgeo2types_ATB"      
    [23] "hh_microtype_ATB"             "hh_geoXmicrotype_ATB"        
    [25] "hh_geo2types_ATB"             "vehicleYN_ATB"               
    [27] "isSenior_ATB"                 "incHiLo_ATB"                 
    [29] "user_class_ATB"               "distance_bin_class_ATB"      
    [31] "onePerObs"                   

### Collapse by type unit etc

#### CHANGE to summary instead of through count)

``` r
df_collapsed <- df_trips_only_small |>
    count(origin_microXgeo2types_ATB,dest_microXgeo2types_ATB,
          trip_purpose_small_ATB,start_time_bin_ATB,user_class_ATB,distance_bin_class_ATB,
          mode_ATB)
df_collapsed
```

    # A tibble: 44,443 × 8
       origin_microXgeo2types_ATB dest_microXgeo2types_ATB trip_purpose_small_ATB
       <chr>                      <chr>                    <chr>                 
     1 1_AB                       1_AB                     home                  
     2 1_AB                       1_AB                     home                  
     3 1_AB                       1_AB                     home                  
     4 1_AB                       1_AB                     home                  
     5 1_AB                       1_AB                     home                  
     6 1_AB                       1_AB                     home                  
     7 1_AB                       1_AB                     home                  
     8 1_AB                       1_AB                     home                  
     9 1_AB                       1_AB                     home                  
    10 1_AB                       1_AB                     home                  
    # ℹ 44,433 more rows
    # ℹ 5 more variables: start_time_bin_ATB <chr>, user_class_ATB <chr>,
    #   distance_bin_class_ATB <fct>, mode_ATB <chr>, n <int>

#### histogram

``` r
df_collapsed |> 
  filter(n<20) |>  
  ggplot( aes(x = n)) +
  geom_histogram(binwidth = 1)
```

![](20_mode-choice-cleaned-stats_files/figure-commonmark/unnamed-chunk-47-1.png)

### Then widen

``` r
df_collapsed_wide <- df_collapsed  %>% 
   pivot_wider(
    names_from = mode_ATB,
    values_from = n
  )
df_collapsed_wide
```

    # A tibble: 28,271 × 13
       origin_microXgeo2types_ATB dest_microXgeo2types_ATB trip_purpose_small_ATB
       <chr>                      <chr>                    <chr>                 
     1 1_AB                       1_AB                     home                  
     2 1_AB                       1_AB                     home                  
     3 1_AB                       1_AB                     home                  
     4 1_AB                       1_AB                     home                  
     5 1_AB                       1_AB                     home                  
     6 1_AB                       1_AB                     home                  
     7 1_AB                       1_AB                     home                  
     8 1_AB                       1_AB                     home                  
     9 1_AB                       1_AB                     home                  
    10 1_AB                       1_AB                     home                  
    # ℹ 28,261 more rows
    # ℹ 10 more variables: start_time_bin_ATB <chr>, user_class_ATB <chr>,
    #   distance_bin_class_ATB <fct>, bike <int>, bus <int>, hv <int>, rail <int>,
    #   taxi <int>, walk <int>, other <int>

### save widened

``` r
df_trips_only_small <- df_trips_only |> 
  select(contains("_ATB")) %>% 
  select(-contains("rawdatafrom"))

write_parquet(df_collapsed_wide,  file.path(data_results, "10-mode-choice-cleaning_output-merged-onlytrips-fewvars-wide.parquet"))
write_rds(df_collapsed_wide,  file.path(data_results, "10-mode-choice-cleaning_output-merged-onlytrips-fewvars-wide.rds"))
write_csv(df_collapsed_wide,  file.path(data_results, "10-mode-choice-cleaning_output-merged-onlytrips-fewvars-wide.csv"))
```

## histograms

#### histogram mode stacked

``` r
df_collapsed |> 
  filter(n<50) |>  
  ggplot( aes(x = n, fill = mode_ATB)) +
  geom_histogram(binwidth = 1)
```

![](20_mode-choice-cleaned-stats_files/figure-commonmark/unnamed-chunk-50-1.png)

#### histogram mode faceted

``` r
df_collapsed |> 
  filter(n<10) |>  
  ggplot( aes(x = n)) +
  geom_histogram(binwidth = 1) +
  facet_wrap(vars(mode_ATB),nrow=2)
```

![](20_mode-choice-cleaned-stats_files/figure-commonmark/unnamed-chunk-51-1.png)

#### histogram mode lines

``` r
df_collapsed |> 
  filter(n<50) |>  
  ggplot( aes(x = n, colour = mode_ATB)) +
  geom_freqpoly(binwidth = 1)
```

![](20_mode-choice-cleaned-stats_files/figure-commonmark/unnamed-chunk-52-1.png)

#### look at the bins graph

``` r
ggplot(df_trips_only_small, 
       aes(x = origin_microXgeo2types_ATB, 
           y = dest_microXgeo2types_ATB)) +
  geom_count()
```

![](20_mode-choice-cleaned-stats_files/figure-commonmark/unnamed-chunk-53-1.png)

``` r
ggplot(df_trips_only_small, 
       aes(x = origin_microXgeo2types_ATB, 
           y = dest_microXgeo2types_ATB,
           color = start_time_bin_ATB,
           shape = trip_purpose_small_ATB)) +
  geom_count()
```

![](20_mode-choice-cleaned-stats_files/figure-commonmark/unnamed-chunk-54-1.png)

``` r
ggplot(df_trips_only_small, 
       aes(x = origin_microXgeo2types_ATB, 
           y = user_class_ATB,
           color = start_time_bin_ATB,
           shape = trip_purpose_small_ATB,
           fill = distance_bin_class_ATB)) +
  geom_count()
```

![](20_mode-choice-cleaned-stats_files/figure-commonmark/unnamed-chunk-55-1.png)

``` r
ggplot(df_trips_only_small, 
       aes(x = origin_microXgeo2types_ATB, 
           y = user_class_ATB)) +
  geom_count()
```

![](20_mode-choice-cleaned-stats_files/figure-commonmark/unnamed-chunk-56-1.png)

``` r
ggplot(df_trips_only_small, 
       aes(x = origin_microXgeo2types_ATB, 
           y = distance_bin_class_ATB)) +
  geom_count()
```

![](20_mode-choice-cleaned-stats_files/figure-commonmark/unnamed-chunk-57-1.png)

### END 12/15

#### NEXT 12/15

Make a new histogram

#### WHY? doesn’t this work without count?

``` r
df_trips_only_small %>% 
  count(origin_microXgeo2types_ATB,dest_microXgeo2types_ATB,
          trip_purpose_small_ATB,start_time_bin_ATB,user_class_ATB,distance_bin_class_ATB,
          mode_ATB) %>% 
  filter(n<20) %>% 
  ggplot( aes(x = n)) +
  geom_histogram(binwidth = 1)
```

![](20_mode-choice-cleaned-stats_files/figure-commonmark/unnamed-chunk-58-1.png)

``` r
df_collapsed <- df_trips_only_small |>
    count(origin_microXgeo2types_ATB,dest_microXgeo2types_ATB,
          trip_purpose_small_ATB,start_time_bin_ATB,user_class_ATB,distance_bin_class_ATB,
          mode_ATB)

df_collapsed |> 
  count(origin_microXgeo2types_ATB,dest_microXgeo2types_ATB) %>% 
  filter(n<100) %>% 
  ggplot( aes(x = n)) +
  geom_histogram(binwidth = 5)
```

![](20_mode-choice-cleaned-stats_files/figure-commonmark/unnamed-chunk-59-1.png)

### Wide microgeo by mode to get fractions (first get the sum)

``` r
df_microXgeotype_wide <- df_trips_only_small |>
    count(origin_geoXmicrotype_ATB,dest_geoXmicrotype_ATB,
          trip_purpose_ATB,start_time_bin_ATB,
          mode_ATB) %>% 
   pivot_wider(
    names_from = mode_ATB,
    values_from = n
  )
df_microXgeotype_wide
```

    # A tibble: 11,305 × 11
       origin_geoXmicrotype_ATB dest_geoXmicrotype_ATB trip_purpose_ATB
       <chr>                    <chr>                  <chr>           
     1 A_1                      A_1                    home            
     2 A_1                      A_1                    home            
     3 A_1                      A_1                    home            
     4 A_1                      A_1                    meals           
     5 A_1                      A_1                    meals           
     6 A_1                      A_1                    meals           
     7 A_1                      A_1                    medical         
     8 A_1                      A_1                    medical         
     9 A_1                      A_1                    medical         
    10 A_1                      A_1                    other           
    # ℹ 11,295 more rows
    # ℹ 8 more variables: start_time_bin_ATB <chr>, bike <int>, bus <int>,
    #   hv <int>, other <int>, rail <int>, taxi <int>, walk <int>

### new dataset

- county
- user class (income variation) use xiaodan’s
- trip purpose – which may or may not. Mandatory versus non-mandatory.
  Work and School
- trip distance bin
- departure time bin

Micro-geotype – merge this into the dataset, and then use micro type.
Break up by micro geo Replace county by microtype. There are 6
microtypes. Use Origin and destination microtypes – could do that, then
there would be

Need to ask Xiaodan to how to merge microtype and geo type IDs to FIPS
blocks.

Then Combinatorials of

## Summary stats by coumty

### basic

how many trips in each state

``` r
summary_table <- df_trips_only |> 
  group_by(ORIG_ST) |>
  summarise(   
    Ntrips = n(),
    .groups = "drop")
summary_table
```

    # A tibble: 55 × 2
       ORIG_ST Ntrips
       <chr>    <int>
     1 -9           4
     2 01        2446
     3 02        1784
     4 04       19568
     5 05        1497
     6 06      183392
     7 08        4285
     8 09        2318
     9 10        1978
    10 11        2099
    # ℹ 45 more rows

how many trips for each mode

``` r
summary_table <- df_trips_only |> 
  group_by(mode_ATB) |>
  summarise(   
    Ntrips = n(),
    .groups = "drop") |>
  arrange(-Ntrips)   
summary_table
```

    # A tibble: 7 × 2
      mode_ATB Ntrips
      <chr>     <int>
    1 hv       800071
    2 walk      81288
    3 bus       20254
    4 bike       8034
    5 other      6638
    6 rail       4474
    7 taxi       2813

### by county

how many trips in each county

``` r
# ggplot(df_county_origin,aes(x=Ntrips)) +
#   geom_histogram(binwidth=1) +
#   coord_cartesian(xlim = c(0, 50))
```

### by mode type by

``` r
# ggplot(df_county_origin,aes(x=mode_Ndis)) +
#   geom_histogram(binwidth=1) 
# #  coord_cartesian(xlim = c(0, 50))
```

### by purpose

``` r
# df_county_origin <- df_trips_only_small |>
#   group_by(mode_ATB,trip_purpose_ATB) |>
#   summarise(Ntrips = n(),
#             #across(contains("mode_ATB"),~n_distinct(.x),.names = "{.col}_Ndis"),
#     .groups = "drop")
# #df_county_origin
# df_county_origin
```

      across(where(is.numeric),~mean(.x),.names = "{.col}_avg"),
        across(where(is.factor ),~n_distinct(.x),.names = "{.col}_Ndis"),

## Make new proportional dataset

### by microXgeotype

``` r
# ggplot(df_county_origin,aes(x=Ntrips)) +
#   geom_histogram(binwidth=1) +
#   coord_cartesian(xlim = c(0, 50))
```

## fractional split logit

### methodology

The R package is here, I think it’s mostly based on the stata package:
https://github.com/f1kidd/fmlogit

It looks like there is no need to include information about how the
proportions within each observation were obtained, like how many people
or whatever were used to make the proportions, see this from the seminal
paper:

Papke, Leslie E., and Jeffrey M. Wooldridge. “Econometric Methods for
Fractional Response Variables With an Application to 401 (K) Plan
Participation Rates.” *Journal of Applied Econometrics*, vol. 11, no. 6,
1996, pp. 619–32. *JSTOR*, http://www.jstor.org/stable/2285155. Accessed
29 Nov. 2023.

<img src="images/fractional_split_woolridge_2.png" width="465" />

This is an
[example](https://www.sciencedirect.com/science/article/abs/pii/S0001457517304049)
of a fractional split logit using the fraction of crashes in each TAZ as
the y var, and the x vars are descriptors of the TAZ also in
proportions. Lee J, Yasmin S, Eluru N, Abdel-Aty M, Cai Q. Analysis of
crash proportion by vehicle type at traffic analysis zone level: A mixed
fractional split multinomial logit modeling approach with spatial
effects. Accid Anal Prev. 2018 Feb;111:12-22. doi:
10.1016/j.aap.2017.11.017. Epub 2017 Nov 20. PMID: 29161538.
