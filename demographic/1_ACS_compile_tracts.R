# Generating dataset for geotypes 
# FHWA project 
# Last Updated: 2019-01-11

######################################################################
setwd("C:/FHWA/For FHWA folks/trip_generation_and_gems_inputs")
library(stringr)
library(reshape2)
library(dplyr)


# ADD GEOMETRY TO CENSUS TRACTS AND CBGS
library(tidycensus)
library(purrr)
library(tidyr)
library(data.table)


# for now, only need population and geometry

# set your UC Census API key when you use this for the first time
# get an API key here: https://api.census.gov/data/key_signup.html
# census_api_key("e74b4d8c97989e07245040ac84168a638247af9a", overwrite = TRUE)
# options(tigris_use_cache = TRUE)
readRenviron("~/.Renviron")
# 
# # get FIPS codes
# us <- unique(fips_codes$state)[1:51]
# 
# search_tablecontents("acs5", years = 2017, keywords = "land", view = TRUE)
# pop2017 <- reduce(
#   map(us, function(x) {
#     get_acs(geography = "tract", variables = "B01003_001", 
#               "G001_", 
#             state = x, geometry = FALSE)
#   }), 
#   rbind
# )
# 
# pop2017 <- pop2017[,-c(2,3,5)]
# colnames(pop2017) <- c("geoid", "population")
# write.csv(pop2017, file = "Data/CleanData/pop2017.csv")

#############
# ACS 5 yr 2017 data
###############

# downloading all of the census data
library(totalcensus)
set_path_to_census("~/Desktop/my_census_data")

################
# HOUSING COSTS
# median housing cost
search_tablecontents("acs5", years = 2017, keywords = "gross rent", view = TRUE)
search_tablecontents("acs5", years = 2017, keywords = "median housing costs", view = TRUE)
hcost <- read_acs5year( year = 2017, states = states_DC,    
                         table_contents = c("median_rent = B25064_001",
                                            "median_owner_housing_cost = B25088_001"), 
                         summary_level = "tract" )
hcost <- hcost[, c(1,4:5)]

# HOUSEHOLDS
search_tablecontents("acs5", years = 2017, keywords = "B11001", view = TRUE)
hholds <- read_acs5year( year = 2017, states = states_DC,    
                      table_contents = c("hholds_total = B11001_001"), 
                      summary_level = "tract" )
hholds <- hholds[, c(1,4)]
#################
# SEX
search_tablecontents("acs5", years = 2017, keywords = "B01001", view = TRUE)
sex <- read_acs5year( year = 2017, states = states_DC,    
                          table_contents = c("sex_total = B01001_001",
                                             "sex_male = B01001_002",
                                             "sex_female = B01001_026"), 
                          summary_level = "tract" )
sex <- sex[,c(1,3, 4:6)]

#####################
# AGE
age <- read_acs5year( year = 2017, states = states_DC,    
                      table_contents = c("age_total = B01001_001",
                                         "age_m_total = B01001_002",
                                         "age_m_under5 = B01001_003",
                                         "age_m_5_9 = B01001_004",
                                         "age_m_10_14 = B01001_005",
                                         "age_m_15_17 = B01001_006",
                                         "age_m_18_19 = B01001_007",
                                         "age_m_20 = B01001_008",
                                         "age_m_21 = B01001_009",
                                         "age_m_22_24 = B01001_010",
                                         "age_m_25_29 = B01001_011",
                                         "age_m_30_34 = B01001_012",
                                         "age_m_35_39 = B01001_013",
                                         "age_m_40_44 = B01001_014",
                                         "age_m_45_49 = B01001_015",
                                         "age_m_50_54 = B01001_016",
                                         "age_m_55_59 = B01001_017",
                                         "age_m_60_61 = B01001_018",
                                         "age_m_62_64 = B01001_019",
                                         "age_m_65_66 = B01001_020",
                                         "age_m_67_69 = B01001_021",
                                         "age_m_70_74 = B01001_022",
                                         "age_m_75_79 = B01001_023",
                                         "age_m_80_84 = B01001_024",
                                         "age_m_over85 = B01001_025",
                                         "age_f_total = B01001_026", 
                                         "age_f_under5 = B01001_027",
                                         "age_f_5_9 = B01001_028",
                                         "age_f_10_14 = B01001_029",
                                         "age_f_15_17 = B01001_030",
                                         "age_f_18_19 = B01001_031",
                                         "age_f_20 = B01001_032",
                                         "age_f_21 = B01001_033",
                                         "age_f_22_24 = B01001_034",
                                         "age_f_25_29 = B01001_035",
                                         "age_f_30_34 = B01001_036",
                                         "age_f_35_39 = B01001_037",
                                         "age_f_40_44 = B01001_038",
                                         "age_f_45_49 = B01001_039",
                                         "age_f_50_54 = B01001_040",
                                         "age_f_55_59 = B01001_041",
                                         "age_f_60_61 = B01001_042",
                                         "age_f_62_64 = B01001_043",
                                         "age_f_65_66 = B01001_044",
                                         "age_f_67_69 = B01001_045",
                                         "age_f_70_74 = B01001_046",
                                         "age_f_75_79 = B01001_047",
                                         "age_f_80_84 = B01001_048",
                                         "age_f_over85 = B01001_049"),
                      summary_level = "tract" )
age <- age[,-c(2,3,53:58)]


##################
# VACANCY 

#search_tablecontents("acs5", years = 2017, keywords = "vacancy", view = TRUE)
vacancy <- read_acs5year( year = 2017, states = states_DC,    
                           table_contents = "vacant_units = B25004_001",
                            summary_level = "tract" )
vacancy <- vacancy[,c(1,4)]

###################
# MOVE IN DATE

#search_tablecontents("acs5", years = 2017, keywords = "moved into unit", view = TRUE)
movedin <- read_acs5year( year = 2017, states = states_DC,  
                        table_contents = c("movedin_total = B25038_001", 
                                           "moved_post2015o = B25038_003",
                                           "moved_2010_14o = B25038_004",
                                           "moved_2000so_ = B25038_005",
                                           "moved_1990so = B25038_006",
                                           "moved_1980so = B25038_007",
                                           "moved_pre1979o = B25038_008",
                                           "moved_post2015r = B25038_010",
                                           "moved_2010_14r = B25038_011",
                                           "moved_2000sr_ = B25038_012",
                                           "moved_1990sr = B25038_013",
                                           "moved_1980sr = B25038_014",
                                           "moved_pre1979r = B25038_015"), 
                        summary_level = "tract")
movedin <- movedin[, - c(2,3, 17:22)]

#################
# NUMBER OF UNITS IN STRUCTURE

search_tablecontents("acs5", years = 2017, keywords = "units in structure", view = TRUE)
units <- read_acs5year( year = 2017,  states = states_DC,   
  table_contents = c("structures_total = B25024_001", 
                     "structures_units1d = B25024_002", 
                     "structures_units1a = B25024_003", 
                     "structures_units2 = B25024_004", 
                     "structures_units3_4 = B25024_005", 
                     "structures_units5_9 = B25024_006", 
                     "structures_units10_19 = B25024_007", 
                     "structures_units20_49 = B25024_008", 
                     "structures_units50plus = B25024_009", 
                     "structures_unitsmobile = B25024_010", 
                     "structures_unitsother = B25024_011" ), 
  summary_level = "tract")
units <- units[,-c(2,3,15:20)]

##########################
# YEAR STRUCTURE BUILT 

#search_tablecontents("acs5", years = 2017, keywords = "B25034", view = TRUE)
built <- read_acs5year( year = 2017,  states = states_DC,   
                        table_contents = c("built_total = B25034_001", 
                                           "built_post2014 = B25034_002", 
                                           "built_2010_13 = B25034_003", 
                                           "built_2000_09 = B25034_004", 
                                           "built_1990_99 = B25034_005", 
                                           "built_1980_89 = B25034_006", 
                                           "built_1970_79 = B25034_007", 
                                           "built_1960_69 = B25034_008", 
                                           "built_1950_59 = B25034_009", 
                                           "built_1940_49= B25034_010", 
                                           "built_pre1939 = B25034_011" ), 
                        summary_level = "tract")
built <- built[,-c(2,3,15:20)]

####################
# EMPLOYMENT STATUS

#search_tablecontents("acs5", years = 2017, keywords = "employment status", view = TRUE)
emp <- read_acs5year(year = 2017,  states = states_DC,  
  table_contents = c("emp_civilian_total = B23025_002",
                     "emp_unemp = B23025_005",
                     "emp_no_labor_force = B23025_007" ),
  summary_level = "tract")
emp <- emp[,c(1,4:6)]

###############
# POVERTY STATUS

#search_tablecontents("acs5", years = 2017, keywords = "poverty status age", view = TRUE)
poverty <- read_acs5year( year = 2017,  states = states_DC,  
  table_contents = c("poverty_status_total = B17017_001",
                     "poverty_below = B17017_002",
                     "poverty_above = B17017_031"), 
  summary_level = "tract")
poverty <- poverty[,c(1,4:6)]

###############
# EDUCATION

#search_tablecontents("acs5", years = 2017, keywords = "education", view = TRUE)
edu <- read_acs5year( year = 2017,  states = states_DC,  
                          table_contents = c("edu_total = B15003_001",
                                              "edu_bs = B15003_022",
                                             "edu_ms = B15003_023",
                                             "edu_prof = B15003_024",
                                             "edu_phd = B15003_025"), 
                          summary_level = "tract" )
edu <- edu[,c(1,4:8)]

###############
# INCOME
inc <- read_acs5year( year = 2017,  states = states_DC,  
                      table_contents = "med_inc = B19013_001",
                      summary_level = "tract" )
inc <- inc[,c(1,4)]

################
# MODE TO WORK
#search_tablecontents("acs5", years = 2017, keywords = "B08301", view = TRUE)
mode <- read_acs5year( year = 2017,  states = states_DC,  
                      table_contents = c("mode_total = B08301_001",
                                         "mode_auto = B08301_002",
                                           "mode_transit = B08301_010",
                                         "mode_taxi = B08301_016" , 
                                         "mode_moto = B08301_017" , 
                                        "mode_bike = B08301_018" ,
                                        "mode_walk = B08301_019", 
                                        "mode_other = B08301_020" , 
                                        "mode_tele_total = B08301_021"),
                      summary_level = "tract" )
mode <- mode[,c(1,4:12)]

#############
# RACE
#search_tablecontents("acs5", years = 2017, keywords = "B03002", view = TRUE)
race <- read_acs5year( year = 2017,  states = states_DC,  
                       table_contents = c("race_total = B03002_001",
                                          "race_not_latino_total = B03002_002",
                                          "race_latino_total = B03002_012") ,
                       summary_level = "tract" )
race <- race[,c(1,4:12)]

##########
# tenure
#search_tablecontents("acs5", years = 2017, keywords = "B25003", view = TRUE)
tenure <- read_acs5year( year = 2017,  states = states_DC,  
                       table_contents = c("tenure_total = B25003_001",
                                          "tenure_own = B25003_002",
                                          "tenure_rent = B25003_003") ,
                       summary_level = "tract" )
tenure <- tenure[,c(1,4:6)]

##############
# vehicle ownership
#search_tablecontents("acs5", years = 2017, keywords = "B25044", view = TRUE)
vehicles <- read_acs5year( year = 2017,  states = states_DC,  
                         table_contents = c("vehices_total = B25044_001",
                                            "vehicles0_own = B25044_003",
                                            "vehicles0_rent = B25044_010") ,
                         summary_level = "tract" )
vehicles <- vehicles[,c(1,4:6)]

##########
# merge all datasets 
##############
acs <- Reduce(function(x,y) merge(x = x, y = y, by = "GEOID", na.omit = FALSE), 
                   list(age, built, edu, emp,  inc, mode, movedin, poverty, race, sex, tenure, units, vacancy, vehicles, hholds, hcost))
###########
# export CSV files to use in stata
###########
acs <- acs %>% separate(GEOID, c("del","GEOID"), "US", remove = T) %>%
  select(-del) 

fwrite(acs, file = "CleanData/acs_data_tracts_071023.csv", row.names = F)


