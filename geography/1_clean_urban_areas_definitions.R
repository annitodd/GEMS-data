# NATALIE POPOVICH
# BERKELEY LAB


# load packages
library(sf)
library(readxl)
library(dplyr)
library(tidycensus)

# Set working directory
mywd <- "C:/FHWA/For FHWA folks/microtype_input_preparation"
setwd(mywd)

datadir <- "RawData"
cleandir <- "CleanData"

###########
# LOAD DATA
################
# import shapefile of Urbanized areas and clusters
# https://catalog.data.gov/dataset/tiger-line-shapefile-2019-2010-nation-u-s-2010-census-urban-area-national
# https://www2.census.gov/geo/tiger/TIGER2019/UAC/tl_2019_us_uac10.zip
ua <- st_read(file.path(datadir, "UAS/tl_2019_us_uac10"), 
              query = "SELECT * FROM tl_2019_us_uac10") 

# import populations for each urban cluster and urban area
# main website https://www.census.gov/programs-surveys/geography/technical-documentation/records-layout/2010-urban-lists-record-layout.html
# Source link: https://www2.census.gov/geo/docs/reference/ua/ua_st_list_all.xls 
pop <- read_excel(file.path(datadir, "/UAS/ua_st_list_all.xls"), col_names = T)

# crosswalk with spatial_ids
xwalk <- read.csv(file.path(cleandir, "us_xwalk_tract_2017_withID.csv")) 

# read in combined census tract CENSUS TRACT COMPILE
#######################################
# NOTE: TIGRIS files produce on 72,837 tracts for both 2017 and 2018 

# tidycensus produces 73,056

# importing and combining US census tracts
us <- unique(fips_codes$state)[1:51]

#tidycensus
census_api_key("e74b4d8c97989e07245040ac84168a638247af9a", overwrite = TRUE)
options(tigris_use_cache = TRUE)

tracts <- reduce(
  map(us, function(x) {
    get_acs(geography = "tract", variables = "B01003_001", 
            state = x, geometry = T, year = 2018)
  }), 
  rbind
)

#############
# DATA CLEANING
##############
tracts = tracts %>%
  select(-NAME, -variable, -moe) %>%
  rename(population = estimate)

# to save space for other data manipulation, remove geometry
tracts.df = st_drop_geometry(tracts)  

# for cbsas across state boundaries, each part must be summed to get to full size
pop <- pop %>% 
  group_by(UACE) %>% 
  mutate(UACE10 = UACE,
         pop_region = sum(POP, na.rm = T),
         hu_region = sum(HU, na.rm = T), 
         alandsqmi_region = sum(AREALANDSQMI, na.rm = T),
         awatersqmi_region = sum(AREAWATERSQMI, na.rm = T)) %>%
  #keep one observation per urbanized area
  select(UACE10, UACE, NAME, pop_region, hu_region, alandsqmi_region, awatersqmi_region) %>%
  distinct()
  
# merge with ua boundaries so that each region can be matched to a population
ua = ua %>% 
  merge(pop, by = "UACE10") %>%
  select(NAME, UACE, pop_region, hu_region, alandsqmi_region, awatersqmi_region)

##################
# intersect tracts with UAs to categorize census tracts
####################
tracts <- st_transform(tracts , st_crs(ua))
int = st_intersection(tracts, ua) 

data = int %>%
  st_drop_geometry() %>%
  select(GEOID, pop_region, UACE, NAME)  %>%
  right_join(tracts.df, by = "GEOID") %>% # merge with entire set of tracts
  distinct() %>%
 group_by(GEOID) %>% # If census tract is in two different area types, keep the one with the larger population
  mutate(max = max(pop_region)) %>%
  filter(pop_region == max | is.na(pop_region)) %>%
  select(-max)

# Create different categories of region types 
data = data %>% 
  mutate(size_type = case_when(
          pop_region >=1000000 ~ 1,
          pop_region >= 500000 & pop_region < 1000000 ~ 2,
          pop_region >= 200000 & pop_region < 500000 ~ 3, 
          pop_region >= 50000 & pop_region < 200000 ~ 4,
          pop_region >= 5000 & pop_region < 50000 ~ 5, 
          pop_region >= 2500 & pop_region < 5000 ~ 6,
          pop_region < 2500 | is.na(pop_region) ~7 )) %>% 
  mutate(fhwa_type = case_when( # FHWA categories for the HERS Final Task 1 report (YEAR)
    pop_region >=1000000 ~ 'major_urbanized',
    pop_region >= 500000 & pop_region < 1000000 ~ 'large_urbanized',
    pop_region >= 50000 & pop_region < 500000 ~ 'small_urbanized',
    pop_region >= 5000 & pop_region < 50000 ~ 'small_urban', 
    pop_region < 5000 | is.na(pop_region) ~ 'rural' )) %>% 
  mutate(fhwa_type_num = case_when(
    pop_region >=1000000 ~ 5,
    pop_region >= 500000 & pop_region < 1000000 ~ 4,
    pop_region >= 50000 & pop_region < 500000 ~ 3,
    pop_region >= 5000 & pop_region < 50000 ~ 2, 
    pop_region < 5000 | is.na(pop_region) ~ 1 )) %>% 
  mutate(census_type = case_when(
    pop_region >= 50000  ~ 'urbanized_area',
    pop_region >= 2500 & pop_region < 50000 ~ 'urban_cluster', 
    pop_region < 2500 | is.na(pop_region) ~ 'rural' ))

table(data$census_type, data$fhwa_type)

# merge with spatial IDs for stage 2 clusters 
out = data %>%
  mutate(GEOID = as.numeric(GEOID)) %>%
  merge(xwalk, by = "GEOID") %>%
  select(GEOID, pop_region, cty, ctyname, cbsa, cbsaname, fhwa_type, spatial_id, fhwa_type_num)

#export urban divisions
write.csv(out, file.path(cleandir, "urban_divisions.csv"), row.names = F)









