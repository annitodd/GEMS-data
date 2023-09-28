# Census tract shapefile compile
######################################################################
# LJ add: directories so that the files are saved in the right places
mywd <- "C:/FHWA_R2/spatial_boundary"
setwd(mywd)

datadir <- "RawData"
cleandir <- "CleanData"

library(rgdal)
require(RCurl)
library(purrr) # LJ add: to use reduce
require(parallel)
# LJ add: if taRifx.geo not installed, install it once
if ( "taRifx.geo" %in% rownames(installed.packages()) == FALSE) {
 install.packages("remotes")
  remotes::install_github("gsk3/taRifx.geo")
}


#require(taRifx.geo) 
#Xiaodan notes, this package is no longer available from CRAN
# IF you need to install it, download the following GZ files and install them manually
# https://cran.r-project.org/src/contrib/Archive/taRifx.geo/
# https://cran.r-project.org/src/contrib/Archive/taRifx/

library(tidycensus) # LJ add: to get tract geometry
library(tidyverse)
library(sf)
library(sp)
library(rgeos)
library(maptools)
library(maps)
library(tigris)
library(broom) # to use tidy

#setwd("~/Box/FHWA/Data/RawData/")

##########################
# CENSUS TRACT COMPILE
#######################################
#NOTE: TIGRIS files produce on 72,837 tracts for both 2017 and 2018 
# tidycensus produces 73,056
# importing and combining US census tracts
us <- unique(fips_codes$state)[1:51]
year_selected = 2018
#tidycensus
census_api_key("e74b4d8c97989e07245040ac84168a638247af9a", install = TRUE, overwrite = TRUE)
readRenviron("~/.Renviron")
options(tigris_use_cache = TRUE)

tracts <- reduce(
  purrr::map(us, function(x) {
    get_acs(geography = "tract", variables = "B01003_001", 
            state = x, geometry = T, year = year_selected)
  }), 
  rbind
)
tracts <- tracts %>% 
  select(-variable, -estimate, -moe)
# exporting combined shape file. LJ add path to save the data
file_name = paste0('combined_tracts_', year_selected, '.geojson')
st_write(obj=tracts, dsn=file.path(cleandir, file_name))

################
# COUNTY BOUNDARIES
#########################
# Natalie's original code
# combined_counties <- rbind_tigris(
#   lapply(states, function(x) {
#     counties(x, cb = TRUE, year = 2018)
#   })
# )

# LJ add:
combined_counties <- rbind_tigris(
  lapply(us, function(x) {
    counties(x, cb = TRUE, year = year_selected)
  })
)

file_name_ct = paste0('combined_county_', year_selected, '.geojson')
st_write(obj=combined_counties, dsn=file.path(cleandir, file_name_ct))

# exporting combined shape file. LJ add path to save the data
#writeOGR(obj=combined_counties, dsn=file.path(cleandir,"Counties"), layer="combined_counties", driver="ESRI Shapefile")

# Xiaodan's notes: we didn't use the following output, please skip these lines
# combined_counties@data$GEOID <- as.character(combined_counties@data$GEOID) # convert GEOID to character
# 
# ggcbg3<-tidy(combined_counties, region = "GEOID")  # convert polygons to data.frame
# 
# fwrite(ggcbg3, file = file.path(cleandir,"Counties","all_counties_2018.csv"), row.names = F)





