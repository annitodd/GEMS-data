Annika created this code doc on 10/21/2023. Last compiled on 2023-12-20

# Description and Overview

This code opens the full merged dataset that was made in the R code:
10_mode-choice-cleaning, and makes several smaller versions of the
dataset for use later in histograms etc. Then saves the data in three
versions: csv, parquet (faster to load and save, and is available across
platforms), and R

GitHub: This .Rmd code (possibly qmd if I have to change it with the new
update to R Studio) is synced to Github, and when this code is knit,
it’s also synced to GitHub, as a .md file, which makes the knitted code
easy to read (kind of like python code.) Currently in a FORK:
<https://github.com/annitodd/GEMS-data/blob/main/gems-mode-choice/>

Workflow: this part of the project (mode choice) begins with the first R
code: “10_mode-choice-cleaning.Rmd” , and then goes on sequentially.

# Setup

## libraries

``` r
library(arrow)
library(tidyverse)
# library(readxl)
# library(rstudioapi)
# library(scales)
# library(writexl)
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
data_results <- 'C:/FHWA_R2/mode_choice_estimation/data'
```

# Open full dataset

``` r
df_temp_full <- read_parquet(file.path(data_results, "10-mode-choice-cleaning_output-full-merged.parquet"))
names(df_temp_full)
```

    ##   [1] "rawdatafrom_trippub_ATB"      "mode_ATB"                    
    ##   [3] "trip_purpose_ATB"             "trip_purpose_small_ATB"      
    ##   [5] "start_time_bin_ATB"           "orig_fips11_ATB"             
    ##   [7] "dest_fips11_ATB"              "rawdatafrom_tripct_ATB"      
    ##   [9] "hh_fips11_ATB"                "rawdatafrom_hhct_ATB"        
    ##  [11] "origin_microtypeXgeotype_ATB" "origin_geotype_ATB"          
    ##  [13] "origin_microXgeo2types_ATB"   "origin_microtype_ATB"        
    ##  [15] "origin_geoXmicrotype_ATB"     "origin_geo2types_ATB"        
    ##  [17] "dest_microtypeXgeotype_ATB"   "dest_geotype_ATB"            
    ##  [19] "dest_microXgeo2types_ATB"     "dest_microtype_ATB"          
    ##  [21] "dest_geoXmicrotype_ATB"       "dest_geo2types_ATB"          
    ##  [23] "hh_microtypeXgeotype_ATB"     "hh_geotype_ATB"              
    ##  [25] "hh_microXgeo2types_ATB"       "hh_microtype_ATB"            
    ##  [27] "hh_geoXmicrotype_ATB"         "hh_geo2types_ATB"            
    ##  [29] "vehicleYN_ATB"                "isSenior_ATB"                
    ##  [31] "incHiLo_ATB"                  "user_class_ATB"              
    ##  [33] "distance_bin_class_ATB"       "HOUSEID"                     
    ##  [35] "PERSONID"                     "TDTRPNUM"                    
    ##  [37] "STRTTIME"                     "ENDTIME"                     
    ##  [39] "TRVLCMIN"                     "TRPMILES"                    
    ##  [41] "TRPTRANS"                     "TRPACCMP"                    
    ##  [43] "TRPHHACC"                     "VEHID"                       
    ##  [45] "TRWAITTM"                     "NUMTRANS"                    
    ##  [47] "TRACCTM"                      "DROP_PRK"                    
    ##  [49] "TREGRTM"                      "WHODROVE"                    
    ##  [51] "WHYFROM"                      "LOOP_TRIP"                   
    ##  [53] "TRPHHVEH"                     "HHMEMDRV"                    
    ##  [55] "HH_ONTD"                      "NONHHCNT"                    
    ##  [57] "NUMONTRP"                     "PSGR_FLG"                    
    ##  [59] "PUBTRANS"                     "TRIPPURP"                    
    ##  [61] "DWELTIME"                     "TDWKND"                      
    ##  [63] "VMT_MILE"                     "DRVR_FLG"                    
    ##  [65] "WHYTRP1S"                     "ONTD_P1"                     
    ##  [67] "ONTD_P2"                      "ONTD_P3"                     
    ##  [69] "ONTD_P4"                      "ONTD_P5"                     
    ##  [71] "ONTD_P6"                      "ONTD_P7"                     
    ##  [73] "ONTD_P8"                      "ONTD_P9"                     
    ##  [75] "ONTD_P10"                     "ONTD_P11"                    
    ##  [77] "ONTD_P12"                     "ONTD_P13"                    
    ##  [79] "TDCASEID"                     "TRACC_WLK"                   
    ##  [81] "TRACC_POV"                    "TRACC_BUS"                   
    ##  [83] "TRACC_CRL"                    "TRACC_SUB"                   
    ##  [85] "TRACC_OTH"                    "TREGR_WLK"                   
    ##  [87] "TREGR_POV"                    "TREGR_BUS"                   
    ##  [89] "TREGR_CRL"                    "TREGR_SUB"                   
    ##  [91] "TREGR_OTH"                    "WHYTO"                       
    ##  [93] "TRAVDAY"                      "HOMEOWN"                     
    ##  [95] "HHSIZE"                       "HHVEHCNT"                    
    ##  [97] "HHFAMINC"                     "DRVRCNT"                     
    ##  [99] "HHSTATE"                      "HHSTFIPS.x"                  
    ## [101] "NUMADLT"                      "WRKCOUNT"                    
    ## [103] "TDAYDATE"                     "HHRESP"                      
    ## [105] "LIF_CYC"                      "MSACAT"                      
    ## [107] "MSASIZE"                      "RAIL"                        
    ## [109] "URBAN"                        "URBANSIZE"                   
    ## [111] "URBRUR"                       "GASPRICE"                    
    ## [113] "CENSUS_D"                     "CENSUS_R"                    
    ## [115] "CDIVMSAR"                     "HH_RACE"                     
    ## [117] "HH_HISP"                      "HH_CBSA"                     
    ## [119] "SMPLSRCE"                     "R_AGE"                       
    ## [121] "EDUC"                         "R_SEX"                       
    ## [123] "PRMACT"                       "PROXY"                       
    ## [125] "WORKER"                       "DRIVER"                      
    ## [127] "WTTRDFIN"                     "WHYTRP90"                    
    ## [129] "R_AGE_IMP"                    "R_SEX_IMP"                   
    ## [131] "HBHUR"                        "HTHTNRNT"                    
    ## [133] "HTPPOPDN"                     "HTRESDN"                     
    ## [135] "HTEEMPDN"                     "HBHTNRNT"                    
    ## [137] "HBPPOPDN"                     "HBRESDN"                     
    ## [139] "STRTTIME_num"                 "ORIG_COUNTRY"                
    ## [141] "ORIG_ST"                      "ORIG_CNTY"                   
    ## [143] "ORIG_CT"                      "DEST_COUNTRY"                
    ## [145] "DEST_ST"                      "DEST_CNTY"                   
    ## [147] "DEST_CT"                      "HHSTFIPS.y"                  
    ## [149] "HHCNTYFP"                     "HHCT"

## Summarize

### households vs trips

Recall that the trips dataset and the households dataset, they don’t
equally merge, as we saw before (hhct has more households on file). Anna
notes that this is likely because lots of households took the survey but
only some of them filled out the trips diary part.

``` r
df_temp_full |>
  count(rawdatafrom_trippub_ATB,rawdatafrom_tripct_ATB,rawdatafrom_hhct_ATB)
```

    ## # A tibble: 2 × 4
    ##   rawdatafrom_trippub_ATB rawdatafrom_tripct_ATB rawdatafrom_hhct_ATB      n
    ##                     <dbl>                  <dbl>                <dbl>  <int>
    ## 1                       1                      1                    1 923572
    ## 2                      NA                     NA                    1  12474

``` r
df_temp_full <- ungroup(df_temp_full)
```

### number of observations

The number of total **observations** in the dataset (these should give
the same answer):

``` r
df_temp_full |> summarise(n())
```

    ## # A tibble: 1 × 1
    ##    `n()`
    ##    <int>
    ## 1 936046

``` r
df_temp_full |> summarise(n_distinct(HOUSEID,PERSONID,TDTRPNUM))
```

    ## # A tibble: 1 × 1
    ##   `n_distinct(HOUSEID, PERSONID, TDTRPNUM)`
    ##                                       <int>
    ## 1                                    936046

number of **people** in the dataset:

``` r
df_temp_full |> summarise(n_distinct(HOUSEID,PERSONID))
```

    ## # A tibble: 1 × 1
    ##   `n_distinct(HOUSEID, PERSONID)`
    ##                             <int>
    ## 1                          231668

number of **people** in the dataset **with trips** (there are FEWER
people with trips than there are total people:

``` r
df_temp_full |> 
  filter(rawdatafrom_trippub_ATB==1,rawdatafrom_tripct_ATB==1,rawdatafrom_hhct_ATB==1) |> summarise(n_distinct(HOUSEID,PERSONID))
```

    ## # A tibble: 1 × 1
    ##   `n_distinct(HOUSEID, PERSONID)`
    ##                             <int>
    ## 1                          219194

The number of **households** in the dataset:

``` r
df_temp_full |> summarise(n_distinct(HOUSEID))
```

    ## # A tibble: 1 × 1
    ##   `n_distinct(HOUSEID)`
    ##                   <int>
    ## 1                129696

The number of **households** in the dataset **with trips**:

``` r
df_temp_full |> 
  filter(rawdatafrom_trippub_ATB==1,rawdatafrom_tripct_ATB==1,rawdatafrom_hhct_ATB==1) |> summarise(n_distinct(HOUSEID))
```

    ## # A tibble: 1 × 1
    ##   `n_distinct(HOUSEID)`
    ##                   <int>
    ## 1                117222

### Missing observations

``` r
summary <- df_temp_full |>
    group_by(mode_ATB) |>
  summarise(countN = n() ,
            Nmissing = sum(is.na(mode_ATB)),
    .groups = "drop") |> 
  arrange(-countN)   
summary
```

    ## # A tibble: 8 × 3
    ##   mode_ATB countN Nmissing
    ##   <chr>     <int>    <int>
    ## 1 hv       800071        0
    ## 2 walk      81288        0
    ## 3 bus       20254        0
    ## 4 <NA>      12474    12474
    ## 5 bike       8034        0
    ## 6 other      6638        0
    ## 7 rail       4474        0
    ## 8 taxi       2813        0

For the **bin class** It looks like the missing values are from the
non-trip survey part, but ALSO, many distance bins that are missing (656
of them)

``` r
df_temp_full |> 
  count(distance_bin_class_ATB,rawdatafrom_tripct_ATB,rawdatafrom_hhct_ATB)
```

    ## # A tibble: 10 × 4
    ##    distance_bin_class_ATB rawdatafrom_tripct_ATB rawdatafrom_hhct_ATB      n
    ##    <fct>                                   <dbl>                <dbl>  <int>
    ##  1 bin1                                        1                    1 176959
    ##  2 bin2                                        1                    1 140845
    ##  3 bin3                                        1                    1 183539
    ##  4 bin4                                        1                    1 171526
    ##  5 bin5                                        1                    1 120310
    ##  6 bin6                                        1                    1  40437
    ##  7 bin7                                        1                    1  48542
    ##  8 bin8                                        1                    1  40758
    ##  9 <NA>                                        1                    1    656
    ## 10 <NA>                                       NA                    1  12474

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

    ##                              N distinct     V1
    ## 1                                countN 936046
    ## 2       rawdatafrom_trippub_ATB_Missing  12474
    ## 3                      mode_ATB_Missing  12474
    ## 4              trip_purpose_ATB_Missing  12474
    ## 5        trip_purpose_small_ATB_Missing  12474
    ## 6            start_time_bin_ATB_Missing  12474
    ## 7               orig_fips11_ATB_Missing  12474
    ## 8               dest_fips11_ATB_Missing  12474
    ## 9        rawdatafrom_tripct_ATB_Missing  12474
    ## 10                hh_fips11_ATB_Missing      0
    ## 11         rawdatafrom_hhct_ATB_Missing      0
    ## 12 origin_microtypeXgeotype_ATB_Missing  12717
    ## 13           origin_geotype_ATB_Missing  12717
    ## 14   origin_microXgeo2types_ATB_Missing  12717
    ## 15         origin_microtype_ATB_Missing  12717
    ## 16     origin_geoXmicrotype_ATB_Missing  12717
    ## 17         origin_geo2types_ATB_Missing  12717
    ## 18   dest_microtypeXgeotype_ATB_Missing  12701
    ## 19             dest_geotype_ATB_Missing  12701
    ## 20     dest_microXgeo2types_ATB_Missing  12701
    ## 21           dest_microtype_ATB_Missing  12701
    ## 22       dest_geoXmicrotype_ATB_Missing  12701
    ## 23           dest_geo2types_ATB_Missing  12701
    ## 24     hh_microtypeXgeotype_ATB_Missing     47
    ## 25               hh_geotype_ATB_Missing     47
    ## 26       hh_microXgeo2types_ATB_Missing     47
    ## 27             hh_microtype_ATB_Missing     47
    ## 28         hh_geoXmicrotype_ATB_Missing     47
    ## 29             hh_geo2types_ATB_Missing     47
    ## 30                vehicleYN_ATB_Missing  12474
    ## 31                 isSenior_ATB_Missing  12474
    ## 32                  incHiLo_ATB_Missing  12474
    ## 33               user_class_ATB_Missing      0
    ## 34       distance_bin_class_ATB_Missing  13130
    ## 35                       countN_Missing      0
    ## 36          distance_bin_class_ATB_Ndis      9

another way to look at some missings:

``` r
df_temp_full |> 
  count(user_class_ATB,rawdatafrom_tripct_ATB,rawdatafrom_hhct_ATB)
```

    ## # A tibble: 13 × 4
    ##    user_class_ATB     rawdatafrom_tripct_ATB rawdatafrom_hhct_ATB      n
    ##    <chr>                               <dbl>                <dbl>  <int>
    ##  1 HiInc_NVeh_NSenior                      1                    1   3352
    ##  2 HiInc_NVeh_YSenior                      1                    1    634
    ##  3 HiInc_YVeh_NSenior                      1                    1 471444
    ##  4 HiInc_YVeh_YSenior                      1                    1 132075
    ##  5 LoInc_NVeh_NSenior                      1                    1  13480
    ##  6 LoInc_NVeh_YSenior                      1                    1   5008
    ##  7 LoInc_YVeh_NSenior                      1                    1 176506
    ##  8 LoInc_YVeh_YSenior                      1                    1  96733
    ##  9 NAInc_NVeh_NSenior                      1                    1    330
    ## 10 NAInc_NVeh_YSenior                      1                    1    376
    ## 11 NAInc_YVeh_NSenior                      1                    1  12041
    ## 12 NAInc_YVeh_YSenior                      1                    1  11593
    ## 13 Other                                  NA                    1  12474

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

    ## # A tibble: 2 × 36
    ##   rawdatafrom_trippub_ATB rawdatafrom_tripct_ATB rawdatafrom_hhct_ATB countN
    ##                     <dbl>                  <dbl>                <dbl>  <int>
    ## 1                      NA                     NA                    1  12474
    ## 2                       1                      1                    1 923572
    ## # ℹ 32 more variables: mode_ATB_Missing <int>, trip_purpose_ATB_Missing <int>,
    ## #   trip_purpose_small_ATB_Missing <int>, start_time_bin_ATB_Missing <int>,
    ## #   orig_fips11_ATB_Missing <int>, dest_fips11_ATB_Missing <int>,
    ## #   hh_fips11_ATB_Missing <int>, origin_microtypeXgeotype_ATB_Missing <int>,
    ## #   origin_geotype_ATB_Missing <int>, origin_microXgeo2types_ATB_Missing <int>,
    ## #   origin_microtype_ATB_Missing <int>, origin_geoXmicrotype_ATB_Missing <int>,
    ## #   origin_geo2types_ATB_Missing <int>, …

``` r
summary_table %>% sjmisc::rotate_df(rn="V2 is obs with trips")
```

    ##                    V2 is obs with trips    V1     V2
    ## 1               rawdatafrom_trippub_ATB    NA      1
    ## 2                rawdatafrom_tripct_ATB    NA      1
    ## 3                  rawdatafrom_hhct_ATB     1      1
    ## 4                                countN 12474 923572
    ## 5                      mode_ATB_Missing 12474      0
    ## 6              trip_purpose_ATB_Missing 12474      0
    ## 7        trip_purpose_small_ATB_Missing 12474      0
    ## 8            start_time_bin_ATB_Missing 12474      0
    ## 9               orig_fips11_ATB_Missing 12474      0
    ## 10              dest_fips11_ATB_Missing 12474      0
    ## 11                hh_fips11_ATB_Missing     0      0
    ## 12 origin_microtypeXgeotype_ATB_Missing 12474    243
    ## 13           origin_geotype_ATB_Missing 12474    243
    ## 14   origin_microXgeo2types_ATB_Missing 12474    243
    ## 15         origin_microtype_ATB_Missing 12474    243
    ## 16     origin_geoXmicrotype_ATB_Missing 12474    243
    ## 17         origin_geo2types_ATB_Missing 12474    243
    ## 18   dest_microtypeXgeotype_ATB_Missing 12474    227
    ## 19             dest_geotype_ATB_Missing 12474    227
    ## 20     dest_microXgeo2types_ATB_Missing 12474    227
    ## 21           dest_microtype_ATB_Missing 12474    227
    ## 22       dest_geoXmicrotype_ATB_Missing 12474    227
    ## 23           dest_geo2types_ATB_Missing 12474    227
    ## 24     hh_microtypeXgeotype_ATB_Missing     1     46
    ## 25               hh_geotype_ATB_Missing     1     46
    ## 26       hh_microXgeo2types_ATB_Missing     1     46
    ## 27             hh_microtype_ATB_Missing     1     46
    ## 28         hh_geoXmicrotype_ATB_Missing     1     46
    ## 29             hh_geo2types_ATB_Missing     1     46
    ## 30                vehicleYN_ATB_Missing 12474      0
    ## 31                 isSenior_ATB_Missing 12474      0
    ## 32                  incHiLo_ATB_Missing 12474      0
    ## 33               user_class_ATB_Missing     0      0
    ## 34       distance_bin_class_ATB_Missing 12474    656
    ## 35                       countN_Missing     0      0
    ## 36          distance_bin_class_ATB_Ndis     1      9

# Make smaller datasets

## Save with only trips

This discards observations that are households but the households don’t
have any associated trips

``` r
df_trips_only <- df_temp_full |> 
  filter(rawdatafrom_trippub_ATB==1,rawdatafrom_tripct_ATB==1,rawdatafrom_hhct_ATB==1)
```

Now number of observations

``` r
df_trips_only |> 
  count(rawdatafrom_trippub_ATB,rawdatafrom_tripct_ATB,rawdatafrom_hhct_ATB)
```

    ## # A tibble: 1 × 4
    ##   rawdatafrom_trippub_ATB rawdatafrom_tripct_ATB rawdatafrom_hhct_ATB      n
    ##                     <dbl>                  <dbl>                <dbl>  <int>
    ## 1                       1                      1                    1 923572

``` r
df_trips_only <- ungroup(df_trips_only)
```

Save

``` r
write_parquet(df_trips_only,  file.path(data_results, "15-mode-choice-cleaning_output-merged-onlytrips.parquet"))
write_rds(df_trips_only,  file.path(data_results, "15-mode-choice-cleaning_output-merged-onlytrips.rds"))
write_csv(df_trips_only,  file.path(data_results, "15-mode-choice-cleaning_output-merged-onlytrips.csv"))
```

## Save with fewer variables AND only trips

This keeps only some variables that we’ll need for the analysis

``` r
df_trips_only_small <- df_trips_only |> 
  select(contains("_ATB")) %>% 
  select(-contains("rawdatafrom"))
```

Save

``` r
write_parquet(df_trips_only_small,  file.path(data_results, "15-mode-choice-cleaning_output-merged-onlytrips-fewvars.parquet"))
write_rds(df_trips_only_small,  file.path(data_results, "15-mode-choice-cleaning_output-merged-onlytrips-fewvars.rds"))
write_csv(df_trips_only_small,  file.path(data_results, "15-mode-choice-cleaning_output-merged-onlytrips-fewvars.csv"))
```

# Widen collapse and save

## Collapse

Collapse by type unit etc

### TODO CHANGE to summary instead of through count)

``` r
df_collapsed <- df_trips_only_small |>
    count(origin_microXgeo2types_ATB,dest_microXgeo2types_ATB,
          trip_purpose_small_ATB,start_time_bin_ATB,user_class_ATB,distance_bin_class_ATB,
          mode_ATB)
df_collapsed
```

    ## # A tibble: 44,443 × 8
    ##    origin_microXgeo2types_ATB dest_microXgeo2types_ATB trip_purpose_small_ATB
    ##    <chr>                      <chr>                    <chr>                 
    ##  1 1_AB                       1_AB                     home                  
    ##  2 1_AB                       1_AB                     home                  
    ##  3 1_AB                       1_AB                     home                  
    ##  4 1_AB                       1_AB                     home                  
    ##  5 1_AB                       1_AB                     home                  
    ##  6 1_AB                       1_AB                     home                  
    ##  7 1_AB                       1_AB                     home                  
    ##  8 1_AB                       1_AB                     home                  
    ##  9 1_AB                       1_AB                     home                  
    ## 10 1_AB                       1_AB                     home                  
    ## # ℹ 44,433 more rows
    ## # ℹ 5 more variables: start_time_bin_ATB <chr>, user_class_ATB <chr>,
    ## #   distance_bin_class_ATB <fct>, mode_ATB <chr>, n <int>

## Then widen

``` r
df_collapsed_wide <- df_collapsed  %>% 
   pivot_wider(
    names_from = mode_ATB,
    values_from = n
  )
df_collapsed_wide
```

    ## # A tibble: 28,271 × 13
    ##    origin_microXgeo2types_ATB dest_microXgeo2types_ATB trip_purpose_small_ATB
    ##    <chr>                      <chr>                    <chr>                 
    ##  1 1_AB                       1_AB                     home                  
    ##  2 1_AB                       1_AB                     home                  
    ##  3 1_AB                       1_AB                     home                  
    ##  4 1_AB                       1_AB                     home                  
    ##  5 1_AB                       1_AB                     home                  
    ##  6 1_AB                       1_AB                     home                  
    ##  7 1_AB                       1_AB                     home                  
    ##  8 1_AB                       1_AB                     home                  
    ##  9 1_AB                       1_AB                     home                  
    ## 10 1_AB                       1_AB                     home                  
    ## # ℹ 28,261 more rows
    ## # ℹ 10 more variables: start_time_bin_ATB <chr>, user_class_ATB <chr>,
    ## #   distance_bin_class_ATB <fct>, bike <int>, bus <int>, hv <int>, rail <int>,
    ## #   taxi <int>, walk <int>, other <int>

## Save widened collapsed

``` r
write_parquet(df_collapsed_wide,  file.path(data_results, "15-mode-choice-cleaning_output-merged-onlytrips-fewvars-wide.parquet"))
write_rds(df_collapsed_wide,  file.path(data_results, "15-mode-choice-cleaning_output-merged-onlytrips-fewvars-wide.rds"))
write_csv(df_collapsed_wide,  file.path(data_results, "15-mode-choice-cleaning_output-merged-onlytrips-fewvars-wide.csv"))
```

# Clean up and conclude

## Remove datasets

``` r
rm(df_temp_full)
rm(df_collapsed_wide)
rm(df_collapsed)
rm(df_trips_only)
rm(df_trips_only_small)
gc()
```

    ##           used (Mb) gc trigger   (Mb)  max used   (Mb)
    ## Ncells 1355912 72.5    2804474  149.8   2804474  149.8
    ## Vcells 2444128 18.7  322227272 2458.4 335490331 2559.6

## Exit knittr

``` r
knitr::knit_exit()
```
