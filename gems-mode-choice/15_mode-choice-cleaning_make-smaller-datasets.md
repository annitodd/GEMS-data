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

# Make smaller datasets

## Save with only trips

This discards observations that are households but the households don’t
have any associated trips

``` r
df_trips_only <- df_temp_full |> 
  filter(rawdatafrom_trippub_ATB==1,rawdatafrom_tripct_ATB==1,rawdatafrom_hhct_ATB==1)

write_parquet(df_trips_only,  file.path(data_results, "15-mode-choice-cleaning_output-merged-onlytrips.parquet"))
write_rds(df_trips_only,  file.path(data_results, "15-mode-choice-cleaning_output-merged-onlytrips.rds"))
write_csv(df_trips_only,  file.path(data_results, "15-mode-choice-cleaning_output-merged-onlytrips.csv"))
```

## Save with fewer variables AND only trips

This keeps only some variables

``` r
df_trips_only_small <- df_trips_only |> 
  select(contains("_ATB")) %>% 
  select(-contains("rawdatafrom"))
```

Save with fewer variables

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

## Remove temp10

``` r
rm(df_temp_full)
gc()
```

    ##             used   (Mb) gc trigger   (Mb)  max used   (Mb)
    ## Ncells   1383135   73.9    2593682  138.6   2593682  138.6
    ## Vcells 141019157 1075.9  378487964 2887.7 286885277 2188.8

## Exit knittr

``` r
knitr::knit_exit()
```
