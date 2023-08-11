# Calibrating external costs
# NATALIE POPOVICH
# BERKELEY NATIONAL LAB
# LAST UPDATED: MARCH 8 2021
####################################

# set working directory and sub-directories
mywd <- "~/Library/CloudStorage/Box-Box/FHWA/Task2"
setwd(mywd)

figuredir <- "./Figures"
rawdir <- "./Data/Raw"
datadir <- "./Data/Clean"
#tabdir <- './Tables'
#resultsdir <- './Results'

# Load packages
library(tidyverse)

#########
# LOAD DATASETS
############

#import crash modification database
cmf <- xlsx::read.xlsx2(file.path(rawdir, "./CMF/Starratedsearchresults.xls"), sheetIndex = 1, header = T) 

#  READ IN RAW EXTERNAL COST DATA
# Raw data for external costs provided by FHWA - it is not public
x <- openxlsx::read.xlsx(file.path(rawdir, "fhwa_external_costs_edited.xlsx"), sheet = 1, colNames = F) #urban
y <- openxlsx::read.xlsx(file.path(rawdir, "fhwa_external_costs_edited.xlsx"), sheet = 2, colNames = F) #rural  
z <- openxlsx::read.xlsx(file.path(rawdir, "fhwa_external_costs_edited.xlsx"), sheet = 4, colNames = F) #natl crash avg  

# assign externality costs by pct of functional system in each census tract
lm <- read.csv(file.path(datadir,"row_no_sample.csv")) %>% 
  mutate_at(vars(contains("lm_tract_fsys")),  funs("percent" = . /lm_all_tract)) %>% 
  select(contains("percent"), tract, state_code)

# need to bring in state names to merge
xwalk <- read.csv(file.path(datadir, "us_xwalk_tract_2017_withID.csv"))

##########
#  DATA CLEANING 
###########
# create new column names as a composite of the first two rows
new_names <- paste0(as.character(x[2,]),as.character(x[1,]))
names(x) <- new_names          # assign the new column names
names(y) <- new_names

new_z <- paste0(as.character(z[2,]),as.character(z[1,]))
names(z) <-new_z

x <- x[3:nrow(x), ]    # subset off the first three rows
y <- y[3:nrow(y), ]  

x <- rbind(x,y)

# cleaning column names
x <- x %>% 
  select(-contains("DEADWEIGHT"), -contains("LOW"), -contains("HIGH"), -contains("DELAY")) %>% 
  rename_all(~ str_replace(., "COSTS", "")) %>% 
  rename_all( ~ str_replace(., "NA", "")) %>%
  rename_all( ~ str_replace(., "COSTS", "")) %>%
  rename_all( ~ str_replace(., "COST", "")) %>%
  rename(f_sys = "FUNCTIOL SYSTEMNA", 
         mode = "VEHICLE TYPE", 
         noise_avg_cost = "MIDNOISE  - $ PER MILE", 
         air_avg_cost = "MIDCAC EMISSION  - $ PER MILE", 
         ghg_avg_cost = "MIDGHG EMISSION  - $ PER MILE") %>% 
  drop_na(STATE, f_sys)  %>% # remove rows with all NAs
  filter(VMT != 0) # remove observations with ZERO VMT since they disrupt the calcs

# average costs are not reported in their spreadsheet, plugging in national average costs
z <- z[-c(1:2),c(1,3,6)]
colnames(z) <- c("mode", "rural", "urban")

#reshape long to merge with other costs
long <- z %>% 
  gather(loc_type, crash_avg_cost, rural:urban)

keep = x %>% 
  select(STATE, f_sys, mode, loc_type, air_avg_cost, ghg_avg_cost, noise_avg_cost) %>%
  left_join(long, by = c("loc_type", "mode"))


#make costs numeric values
keep[, c(5:8)] <- sapply(keep[, c(5:8)], as.numeric)

states = xwalk %>% 
  select(state) %>% 
  distinct() %>%
  mutate(STATE = toupper(state))

xwalk = xwalk %>% 
  select(tract, state) %>%
  left_join(states)

lm = lm %>% 
  merge(xwalk, by = "tract")

costs <- lm %>%
  merge(keep, by = "STATE", all = T)

# compute tract-level estimates by mode based on proportion of functional system 
e <- costs %>% 
  select(-STATE) %>% 
  filter(mode != "All") %>%
  rename_all(~str_replace(., "lm_tract_","")) %>% 
  mutate(weight = case_when( # generate column weights
    f_sys == "Interstate" ~ fsys1_percent,
    f_sys == "Other Freeways and Expressways" ~ fsys2_percent,
    f_sys == "Other Principal Arterial" ~ fsys3_percent,
    f_sys == "Minor Arterial"~ fsys4_percent,
    f_sys == "Major Collector" ~ fsys5_percent,
    f_sys == "Minor Collector"~ fsys6_percent,
    f_sys == "Local"~ fsys7_percent)) %>% 
  select(- contains("percent")) %>%
  mutate(air_avg_cost = as.numeric(air_avg_cost),
         ghg_avg_cost <- as.numeric(ghg_avg_cost),
         noise_avg_cost <- as.numeric(noise_avg_cost)) %>% 
  #generate tract level estimate weighted by functional system
  group_by(tract, mode, loc_type) %>% 
  mutate(air_cost_tract = sum(air_avg_cost*weight, na.rm = T)) %>% 
  mutate(ghg_cost_tract = sum(ghg_avg_cost*weight, na.rm = T)) %>% 
  mutate(noise_cost_tract = sum(noise_avg_cost*weight, na.rm = T)) %>% 
  mutate(crash_cost_tract = sum(crash_avg_cost*weight, na.rm = T))

out <- e %>% 
  ungroup () %>%
  select(tract, mode, loc_type,air_cost_tract, ghg_cost_tract, noise_cost_tract, crash_cost_tract) %>% 
  distinct()  %>% 
  filter(mode != "Motorcycles") %>% 
  mutate(Mode = case_when( #make sure modes are the same as Task 2 modes
    mode == "Buses" ~ 'bus',
    mode %in% c("Light Trucks", "Passenger Cars") ~ 'hv', 
    mode %in% c("Combination Trucks", "Single-Unit Trucks") ~ 'freight'))

############################
# ESTIMATING CRASH SAFETY SCALARS 
# FROM CMF: http://www.cmfclearinghouse.org/
########################
names(cmf)
cmf <- cmf[,c(1,3,5,7,13) ]

# countermeasure install separated bicycle lane for modes Auto/Bike	CMF
# countermeasure implement transit lane priority for modes Transit/Auto 	CMF
betas <- cmf %>% 
  filter(grepl('Implement transit lane |Install separated bicycle lane|Presence of bus stops', 
               Countermeasure)) %>%
  filter(Star.Quality.Rating > 1) %>% # throw away the poor data 
  group_by(Countermeasure) %>%
  mutate(CMF = as.numeric(CMF), 
         SafetyScalar = mean(CMF), 
         Mode = case_when(
           CMF.ID == 7274 ~ 'bus'),
         Mode2 = case_when(
           CMF.ID == 7274 ~'hv')) %>%
  ungroup() %>%
  select(Mode, Mode2, SafetyScalar) %>%
  distinct() 

export = out %>%
  left_join(betas, by = "Mode")

write.csv(export, file.path(datadir,"external_costs_mode_tract.csv"), row.names = F)
