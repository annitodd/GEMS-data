#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
Created on Fri Mar 17 10:44:33 2023

@author: xiaodanxu
"""

# set up python environment
import pyreadr
import pandas as pd
import os
from os import listdir
import matplotlib.pyplot as plt
import seaborn as sns
import numpy as np

os.chdir('C:/FHWA/For FHWA folks')

plt.style.use('ggplot')

# define validation inputs and parameters
mode_choice_data_dir = 'CleanData/'
supplement_data_dir = 'RawData/'

mode_choice_data_source = 'NHTS/NHTS_tract_mode.split.National.RData'
mode_choice_geotype_id = 'NHTS/nhts_no_ids_1hrtimebins_with_imputation.csv'
mode_choice_microtype_id = 'NHTS/NHTS_tract_od.tr.purpose.National_transgeo.RData'
supplement_data_source = 'NHTS-Public/trippub.csv'

national_geoid_lookup_file = 'ccst_geoid_key_tranps_geo_with_imputation.csv'

mode_lookup = {1: 'walk', 2: 'bike', 3: 'auto', 4: 'auto', 5: 'auto', 6: 'auto', 7: 'scooter', 8: 'scooter', 9: 'auto', 10: 'bus', 11: 'bus',
              12: 'bus', 13: 'bus', 14: 'bus', 15: 'rail', 16: 'rail', 17: 'taxi', 18: 'auto', 19: 'other',
              20: 'other', 97: 'other'}

list_of_used_gems_variables = ['HOUSEID', 'PERSONID', 'TDTRPNUM', 'HHFAMINC', 
                               'WHYTRP1S', 'TRPMILES', 'STRTTIME', 'TRVLCMIN', 'NUMONTRP']

list_of_od_variables = ['HOUSEID', 'PERSONID', 'TDTRPNUM', 'ORIG_COUNTRY',
       'o_geoid', 'DEST_COUNTRY', 'd_geoid', 'o_microtype', 'o_geotype',
       'd_microtype', 'd_geotype']

list_of_geotype_variables = ['HOUSEID', 'h_geotype', 'h_microtype']

mode_choice_data = pyreadr.read_r(mode_choice_data_dir + mode_choice_data_source)
mode_choice_data_df = mode_choice_data['mode.split']
print(mode_choice_data_df.columns)
od_microtype_data = pyreadr.read_r(mode_choice_data_dir + mode_choice_microtype_id)
od_microtype_data_df = od_microtype_data['od.tr.purpose']
print(od_microtype_data_df.columns)
mode_choice_additional = pd.read_csv(supplement_data_dir + supplement_data_source, sep = ',')
print(mode_choice_additional.columns)
mode_choice_geotype_df = pd.read_csv(mode_choice_data_dir + mode_choice_geotype_id, sep = ',')
print(mode_choice_geotype_df.columns)

# <codecell>
# combine different NHTS tables
mode_choice_additional = mode_choice_additional.loc[:, list_of_used_gems_variables]
mode_choice_additional.columns= mode_choice_additional.columns.str.lower()
mode_choice_data_df = pd.merge(mode_choice_data_df, mode_choice_additional, 
                               on = ['houseid', 'personid', 'tdtrpnum'], how = 'left')

mode_choice_geotype_df = mode_choice_geotype_df.loc[:, list_of_geotype_variables]
mode_choice_geotype_df.columns= mode_choice_geotype_df.columns.str.lower()
mode_choice_geotype_df = mode_choice_geotype_df.drop_duplicates(keep = 'first')
mode_choice_data_df = pd.merge(mode_choice_data_df, mode_choice_geotype_df, 
                               on = ['houseid'], how = 'left')

od_variable_df = od_microtype_data_df.loc[:, list_of_od_variables]
od_variable_df.columns= od_variable_df.columns.str.lower()
mode_choice_data_df = pd.merge(mode_choice_data_df, od_variable_df, 
                               on = ['houseid', 'personid', 'tdtrpnum'], how = 'left')

# <codecell>

# clean data
mode_choice_data_df = mode_choice_data_df.dropna(subset = ['o_geoid', 'd_geoid'])
mode_choice_data_df.loc[:, 'o_geoid'] = mode_choice_data_df.loc[:, 'o_geoid'].astype(int).astype(str)
mode_choice_data_df.loc[:, 'd_geoid'] = mode_choice_data_df.loc[:, 'd_geoid'].astype(int).astype(str)
# mode_choice_data_df = mode_choice_data_df.loc[mode_choice_data_df['h_geotype'] == 'A']
mode_choice_data_df = mode_choice_data_df.loc[mode_choice_data_df['dest_country'] == 'USA']
# mode_choice_data_df = mode_choice_data_df.loc[mode_choice_data_df['trpmiles'] <= 300]
mode_choice_data_df = mode_choice_data_df.loc[mode_choice_data_df['trptrans'] > 0]

criteria_1 = (mode_choice_data_df['h_geotype'] == mode_choice_data_df['o_geotype'])
criteria_2 = (mode_choice_data_df['h_geotype'] == mode_choice_data_df['d_geotype'])
mode_choice_data_df = mode_choice_data_df.loc[criteria_1 & criteria_2]
mode_choice_data_df.loc[:, 'mode'] = \
mode_choice_data_df.loc[:, 'trptrans'].map(mode_lookup)
print(len(mode_choice_data_df))

# <codecell>
# drop duplicated trips among households
car_data_df = mode_choice_data_df.loc[mode_choice_data_df['mode'] == 'auto']
car_data_df.loc[car_data_df['numontrp'] <0, 'numontrp'] = 1
sov_trips = car_data_df.loc[car_data_df['numontrp'] == 1]
shared_trips = car_data_df.loc[car_data_df['numontrp'] > 1]

shared_trips_no_duplicate = \
    shared_trips.drop_duplicates(subset = ['houseid', 'o_geoid', 'd_geoid', 'strttime', 'trpmiles'],
                                 keep = 'first')
cleaned_trips = pd.concat([sov_trips, shared_trips_no_duplicate])
cleaned_trips.loc[:, 'weighted_participants'] = \
    cleaned_trips.loc[:, 'numontrp'] * cleaned_trips.loc[:, 'wtperfin']

# <codecell>

# aggregate participants by micro-geotype
person_by_trip_agg = \
     cleaned_trips.groupby(['h_geotype', 'h_microtype'])[['wtperfin', 'weighted_participants']].sum()
person_by_trip_agg = person_by_trip_agg.reset_index()
person_by_trip_agg.loc[:, 'weighted_pax_per_trip'] = \
    person_by_trip_agg.loc[:, 'weighted_participants'] / person_by_trip_agg.loc[:, 'wtperfin']
person_by_trip_agg = person_by_trip_agg[['h_geotype', 'h_microtype', 'weighted_pax_per_trip']]
sample_size = cleaned_trips.groupby(['h_geotype', 'h_microtype']).size()

sample_size = sample_size.reset_index()
sample_size.columns = ['h_geotype', 'h_microtype', 'NHTS_samples_unweighted']
person_by_trip_agg = pd.merge(person_by_trip_agg, sample_size,
                              on = ['h_geotype', 'h_microtype'],
                              how = 'left')
person_by_trip_agg.to_csv(mode_choice_data_dir + '/avg_rider_per_trip.csv', index = False)

