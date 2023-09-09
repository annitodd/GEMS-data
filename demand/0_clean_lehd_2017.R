# Code to download Census LEHD data 
# aggregates raw data to census tract level for analysis
# We use only Workplace Area Characteristics and OD pairs
# https://lehd.ces.census.gov/data/
# exports tract-level data as .csv for clustering analysis

library(lehdr) # to download LEHD data from FTP
library(tidycensus) # to list state FIPS codes
library(data.table)
library(dplyr)

# Set working directory
mywd <- 'C:/FHWA/For FHWA folks/opportunity_and_mode_availability'
setwd(mywd)

datadir <- "RawData"
cleandir <- "CleanData"

###############
# DOWNLOAD LEHD DATA 
# NOTE: downloaded data are raw data. best to use imported data for analysis
#####################
us1 <- unique(fips_codes$state)[1:56]
# Workplace area characteristics (AK and SD missing from 2017)
us <- us1[!us1 %in%  c("AS", "GU", "MP", "PR", "UM", "AK", "SD")]

wac <- grab_lodes(us, 2017, lodes_type = "wac",
           job_type = "JT00", #all jobs combined
           segment = "S000", agg_geo = "tract",
           download_dir = file.path(getwd(), "WAC"))
head(wac)
wac_us = wac
# get 2015 data for AK and SD
wac_aksd <- grab_lodes(c("AK", "SD"), 2015, lodes_type = "wac",
           job_type = "JT00", #all jobs combined
           segment = "S000", agg_geo = "tract", 
           download_dir = file.path(getwd(), "WAC"))
head(wac_aksd)

#append AK and SD to USA. LJ add: wac_us should be wac
wac <- rbind(wac, wac_aksd) %>% 
  select(w_tract, C000, CNS01, CNS02, CNS05) %>%
  distinct()

colnames(wac) <- c("trct", "jobs_total", "jobs_ag", "jobs_manuf", "jobs_mining")

#Export workplace area characteristics for each census tract
fwrite(wac, file = file.path(cleandir, "wac_tract_2017.csv"), row.names = FALSE)

##################
# Origin-destination pairs (missing AK and SD for 2017)
#########################
ods.main <- grab_lodes(us, 2017, lodes_type = "od",
           job_type = "JT00", #all jobs combined
           agg_geo = "tract", state_part = c("main"), #within state commutes
           segment = "S000", #only need the overall trips, not segmented
           download_dir = file.path(getwd(), "OD"))
head(ods.main)

ods.aux <- grab_lodes(us, 2017, lodes_type = "od",
           job_type = "JT00", #all jobs combined
           agg_geo = "tract", state_part = c("aux"), #out-of-state commutes
           segment = "S000", #only need the overall trips, not segmented
           download_dir = file.path(getwd(), "OD"))

# Alaska and SD from 2015
#NOTE 20200204: AK and SD now have 2016 data but use 2015 for now since AWS routes were generated with those
ods1  <- grab_lodes(c("AK", "SD"), 2015, lodes_type = "od",
           job_type = "JT00", #all jobs combined
           agg_geo = "tract", state_part = c("aux"), #out-of-state commutes
           segment = "S000", #only need the overall trips, not segmented
           download_dir = file.path(getwd(), "OD"))

ods2 <- grab_lodes(c("AK", "SD"), 2015, lodes_type = "od",
           job_type = "JT00", #all jobs combined
           agg_geo = "tract", state_part = c("main"), #in-state commutes
           segment = "S000", #only need the overall trips, not segmented
           download_dir = file.path(getwd(), "OD"))

ak <- grab_lodes(c("AK"), 2015, lodes_type = "od",
                          job_type = "JT00", #all jobs combined
                          agg_geo = "tract", state_part = c("main"), #out-of-state commutes
                          segment = "S000", #only need the overall trips, not segmented
                          download_dir = file.path(getwd(), "OD"))

ods <- rbind(ods.main, ods.aux, ods1, ods2) %>% 
  select(w_tract, h_tract, S000)

# Export OD pairs
fwrite(ods, file.path(cleandir, "od_pairs_tract_2017.csv"),  row.names = FALSE)

# check number of trips accounted for:
#total <- colSums(ods[3]) 
# trips = 139730858 
# 3 missing observations

############################
# CROSSWALK FOR COUNTY, STATE, AND CBSA
################################
#Note that the CBSAs change periodically and this crosswalk could be updated even without updating the LODES7 commute data
# LJ add: fixed the path
xwalk <- fread(file.path(datadir, "LEHD/LODES2017/us_xwalk.csv")) %>%
  select(st, stusps, stname, cty, ctyname, trct, cbsa, cbsaname) %>%
  rename(fips_st = st, 
       st_code = stusps, 
       state = stname, 
       tract = trct) %>% 
  filter(fips_st < 60) %>% # remove all the US territories
  distinct() # drop all duplicates since df was at block level

fwrite(xwalk, file.path(cleandir, "us_xwalk_tract_2017.csv"),  row.names = FALSE)
#XIAODAN'S NOTES: this output may very likely be the same as us_xwalk_tract_2017_withID.CSV, probably just got slightly edited by Natalie

# 2015 crosswalk for census tracts that have changed
xwalk <- fread(file.path(datadir, "LEHD/LODES2015/us_xwalk2015.csv")) %>%
  select(st, stusps, stname, cty, ctyname, trct, cbsa, cbsaname) %>%
  rename(fips_st = st,
         st_code = stusps,
         state = stname,
         tract = trct) %>%
  filter(fips_st < 60) %>% # remove all the US territories
  distinct() # drop all duplicates since df was at block level
fwrite(xwalk, file.path(cleandir, "us_xwalk_cbg_2015.csv"),  row.names = FALSE)


