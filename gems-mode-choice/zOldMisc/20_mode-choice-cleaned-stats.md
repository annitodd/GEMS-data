Annika created this code doc on 10/21/2023. Last compiled on 2023-11-15

- [Description and Overview](#description-and-overview)
- [Setup](#setup)
- [Read in data](#read-in-data)
- [Summary stats](#summary-stats)

# Description and Overview

This code summarizes the dataset that is a result of script:
10_mode-choice-cleaning

GitHub: This .Rmd code (possibly qmd if I have to change it with the new
update to R Studio) is synced to Github, and when this code is knit,
it’s also synced to GitHub, as a .md file, which makes the knitted code
easy to read (kind of like python code.) Currently in a FORK:
<https://github.com/annitodd/GEMS-data/blob/main/gems-mode-choice>

# Setup

``` r
#rm(list=ls()) # Clear RStudio environment
#cat("\014") # Clear console
```

## libraries

``` r
library(arrow)
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
#while ((basename(root) != "GEMS-data")) {
#  root <- dirname(root)
#} # Sets root equal to the location of the Github repo
#source(file.path(root, "paths.R")) # Runs paths.R file found in users Github repo
```

``` r
data_path <- 'C:/FHWA/For FHWA folks/Mode_choice_estimation/Data'
data_results <- 'C:/FHWA_R2/mode_choice_estimation/data'
```

# Read in data

full merged dataset

``` r
df_temp <- read_parquet(file.path(data_results, "10-mode-choice-cleaning_output-full-merged.parquet"))
names(df_temp)
```

    ##   [1] "HOUSEID"             "PERSONID"            "TDTRPNUM"           
    ##   [4] "STRTTIME"            "ENDTIME"             "TRVLCMIN"           
    ##   [7] "TRPMILES"            "TRPTRANS"            "TRPACCMP"           
    ##  [10] "TRPHHACC"            "VEHID"               "TRWAITTM"           
    ##  [13] "NUMTRANS"            "TRACCTM"             "DROP_PRK"           
    ##  [16] "TREGRTM"             "WHODROVE"            "WHYFROM"            
    ##  [19] "LOOP_TRIP"           "TRPHHVEH"            "HHMEMDRV"           
    ##  [22] "HH_ONTD"             "NONHHCNT"            "NUMONTRP"           
    ##  [25] "PSGR_FLG"            "PUBTRANS"            "TRIPPURP"           
    ##  [28] "DWELTIME"            "TDWKND"              "VMT_MILE"           
    ##  [31] "DRVR_FLG"            "WHYTRP1S"            "ONTD_P1"            
    ##  [34] "ONTD_P2"             "ONTD_P3"             "ONTD_P4"            
    ##  [37] "ONTD_P5"             "ONTD_P6"             "ONTD_P7"            
    ##  [40] "ONTD_P8"             "ONTD_P9"             "ONTD_P10"           
    ##  [43] "ONTD_P11"            "ONTD_P12"            "ONTD_P13"           
    ##  [46] "TDCASEID"            "TRACC_WLK"           "TRACC_POV"          
    ##  [49] "TRACC_BUS"           "TRACC_CRL"           "TRACC_SUB"          
    ##  [52] "TRACC_OTH"           "TREGR_WLK"           "TREGR_POV"          
    ##  [55] "TREGR_BUS"           "TREGR_CRL"           "TREGR_SUB"          
    ##  [58] "TREGR_OTH"           "WHYTO"               "TRAVDAY"            
    ##  [61] "HOMEOWN"             "HHSIZE"              "HHVEHCNT"           
    ##  [64] "HHFAMINC"            "DRVRCNT"             "HHSTATE"            
    ##  [67] "HHSTFIPS.x"          "NUMADLT"             "WRKCOUNT"           
    ##  [70] "TDAYDATE"            "HHRESP"              "LIF_CYC"            
    ##  [73] "MSACAT"              "MSASIZE"             "RAIL"               
    ##  [76] "URBAN"               "URBANSIZE"           "URBRUR"             
    ##  [79] "GASPRICE"            "CENSUS_D"            "CENSUS_R"           
    ##  [82] "CDIVMSAR"            "HH_RACE"             "HH_HISP"            
    ##  [85] "HH_CBSA"             "SMPLSRCE"            "R_AGE"              
    ##  [88] "EDUC"                "R_SEX"               "PRMACT"             
    ##  [91] "PROXY"               "WORKER"              "DRIVER"             
    ##  [94] "WTTRDFIN"            "WHYTRP90"            "R_AGE_IMP"          
    ##  [97] "R_SEX_IMP"           "HBHUR"               "HTHTNRNT"           
    ## [100] "HTPPOPDN"            "HTRESDN"             "HTEEMPDN"           
    ## [103] "HBHTNRNT"            "HBPPOPDN"            "HBRESDN"            
    ## [106] "rawdatafrom_trippub" "mode"                "trip_purpose"       
    ## [109] "STRTTIME_num"        "start_time_bin"      "ORIG_COUNTRY"       
    ## [112] "ORIG_ST"             "ORIG_CNTY"           "ORIG_CT"            
    ## [115] "DEST_COUNTRY"        "DEST_ST"             "DEST_CNTY"          
    ## [118] "DEST_CT"             "rawdatafrom_tripct"  "HHSTFIPS.y"         
    ## [121] "HHCNTYFP"            "HHCT"                "rawdatafrom_hhct"

recall that they don’t equally merge, as we saw before (hhct has more
households on file)

``` r
df_temp |>
  count(rawdatafrom_trippub,rawdatafrom_tripct,rawdatafrom_hhct)
```

<div class="kable-table">

| rawdatafrom_trippub | rawdatafrom_tripct | rawdatafrom_hhct |      n |
|--------------------:|-------------------:|-----------------:|-------:|
|                   1 |                  1 |                1 | 923572 |
|                  NA |                 NA |                1 |  12474 |

</div>

``` r
df_temp <- ungroup(df_temp)
df_trips_only <- df_temp |> 
  filter(rawdatafrom_trippub==1,rawdatafrom_tripct==1,rawdatafrom_hhct==1)

df_trips_only |> 
  count(rawdatafrom_trippub,rawdatafrom_tripct,rawdatafrom_hhct)
```

<div class="kable-table">

| rawdatafrom_trippub | rawdatafrom_tripct | rawdatafrom_hhct |      n |
|--------------------:|-------------------:|-----------------:|-------:|
|                   1 |                  1 |                1 | 923572 |

</div>

``` r
df_trips_only <- ungroup(df_trips_only)
```

# Summary stats

## basic

how many trips in each state

``` r
summary_table <- df_trips_only |> 
  group_by(ORIG_ST) |>
  summarise(   
    Ntrips = n(),
    .groups = "drop")
summary_table
```

<div class="kable-table">

| ORIG_ST | Ntrips |
|:--------|-------:|
| -9      |      4 |
| 01      |   2446 |
| 02      |   1784 |
| 04      |  19568 |
| 05      |   1497 |
| 06      | 183392 |
| 08      |   4285 |
| 09      |   2318 |
| 10      |   1978 |
| 11      |   2099 |
| 12      |  11743 |
| 13      |  58964 |
| 15      |   2413 |
| 16      |   2522 |
| 17      |   8319 |
| 18      |   3684 |
| 19      |  20058 |
| 20      |   2206 |
| 21      |   2249 |
| 22      |   2171 |
| 23      |   2307 |
| 24      |   9884 |
| 25      |   4556 |
| 26      |   6006 |
| 27      |   5538 |
| 28      |   1440 |
| 29      |   3706 |
| 30      |   2358 |
| 31      |   2270 |
| 32      |   2661 |
| 33      |   2147 |
| 34      |   5074 |
| 35      |   2095 |
| 36      | 116202 |
| 37      |  61046 |
| 38      |   1904 |
| 39      |   7621 |
| 40      |   9071 |
| 41      |   3641 |
| 42      |   8255 |
| 44      |   1675 |
| 45      |  47416 |
| 46      |   2224 |
| 47      |   3862 |
| 48      | 175084 |
| 49      |   3341 |
| 50      |   2616 |
| 51      |   5993 |
| 53      |   4843 |
| 54      |   1532 |
| 55      |  81446 |
| 56      |   1853 |
| 72      |      1 |
| 78      |      2 |
| ZZ      |    202 |

</div>

how many trips for each mode

``` r
summary_table <- df_trips_only |> 
  group_by(mode) |>
  summarise(   
    Ntrips = n(),
    .groups = "drop") |>
  arrange(-Ntrips)   
summary_table
```

<div class="kable-table">

| mode    | Ntrips |
|:--------|-------:|
| hv      | 797983 |
| walk    |  81288 |
| bus     |  20254 |
| bike    |   8034 |
| other   |   5812 |
| rail    |   4474 |
| scooter |   2914 |
| taxi    |   2813 |

</div>

## by county

how many trips in each county choose only some vars

``` r
df_trips_only_small <- df_trips_only |> 
  select(mode, trip_purpose, ORIG_COUNTRY,ORIG_ST,ORIG_CNTY)
df_trips_only_small %>% 
  distinct(mode,trip_purpose)
```

<div class="kable-table">

| mode    | trip_purpose   |
|:--------|:---------------|
| hv      | school         |
| hv      | home           |
| hv      | work           |
| hv      | social         |
| hv      | medical        |
| hv      | other          |
| hv      | shopping       |
| hv      | meals          |
| walk    | home           |
| walk    | social         |
| hv      | transp_someone |
| walk    | work           |
| walk    | other          |
| walk    | meals          |
| walk    | shopping       |
| other   | shopping       |
| other   | meals          |
| other   | social         |
| bus     | work           |
| bus     | transp_someone |
| bus     | home           |
| bus     | school         |
| bike    | social         |
| bike    | home           |
| taxi    | meals          |
| taxi    | home           |
| rail    | meals          |
| bus     | shopping       |
| rail    | shopping       |
| bus     | other          |
| bus     | meals          |
| taxi    | social         |
| bus     | social         |
| other   | work           |
| taxi    | work           |
| scooter | work           |
| scooter | home           |
| bus     | medical        |
| bike    | work           |
| walk    | transp_someone |
| walk    | school         |
| other   | other          |
| rail    | work           |
| rail    | home           |
| rail    | school         |
| scooter | shopping       |
| bike    | shopping       |
| scooter | medical        |
| scooter | social         |
| bike    | other          |
| rail    | social         |
| rail    | other          |
| other   | home           |
| bike    | school         |
| scooter | meals          |
| walk    | medical        |
| other   | medical        |
| rail    | medical        |
| taxi    | medical        |
| taxi    | shopping       |
| scooter | school         |
| bike    | meals          |
| taxi    | school         |
| taxi    | other          |
| other   | school         |
| other   | transp_someone |
| rail    | transp_someone |
| scooter | transp_someone |
| scooter | other          |
| bike    | medical        |
| bike    | transp_someone |
| taxi    | transp_someone |

</div>

make wider dataset

``` r
df_trips_only_small_wide <- df_trips_only_small  |>
  pivot_wider(
    names_from = mode,
    values_from = mode,
    values_fn = n_distinct
  )
#df_trips_only_small_wide
```

``` r
df_county_origin <- df_trips_only_small |>
  group_by(ORIG_ST,ORIG_CNTY) |>
  summarise(Ntrips = n(),
            across(contains("mode"),~n_distinct(.x),.names = "{.col}_Ndis"),
    .groups = "drop")
#df_county_origin
```

``` r
ggplot(df_county_origin,aes(x=Ntrips)) +
  geom_histogram(binwidth=1) +
  coord_cartesian(xlim = c(0, 50))
```

![](20_mode-choice-cleaned-stats_files/figure-gfm/unnamed-chunk-13-1.png)<!-- -->

``` r
ggplot(df_county_origin,aes(x=mode_Ndis)) +
  geom_histogram(binwidth=1) 
```

![](20_mode-choice-cleaned-stats_files/figure-gfm/unnamed-chunk-14-1.png)<!-- -->

``` r
#  coord_cartesian(xlim = c(0, 50))
```

          across(where(is.numeric),~mean(.x),.names = "{.col}_avg"),
            across(where(is.factor ),~n_distinct(.x),.names = "{.col}_Ndis"),
