# initialization of the clustering

our_packages<- c("dplyr", "MASS", "reshape2","cowplot","rgdal", 
                 "ggplot2", "corrplot", "raster","readxl","RColorBrewer","fmsb",
                 "ncdf4","rgdal","ggmap","lawn","sp","shapefiles", "maps", "sf", 
                 "fields", "Imap", "raster","readxl",
                 "tictoc","stargazer","psych","GPArotation","spdplyr","sp","shapefiles","tmap",
                 "cluster","factoextra","DandEFA",
                 "xtable","psychTools",
                 "aCRM",
                 "clusterCrit",
                 'data.table',
                 'tigris',
                 'DAAG',
                 'fastDummies',
                 'tidyr',
                 'mlogit',
                 'filling',
                 'FNN', # knn regression,
                 'rlist',
                 'openxlsx' # write excel file
                 )
# # need to insall dummies from downloads for aCRM
# install.packages(file.path('./Rpackages/dummies_1.5.6.tar.gz'), repos=NULL, type='source',dependencies=F)
# library(devtools)
# install_github("cran/aCRM")

for (i in our_packages){
  if ( i %in% rownames(installed.packages()) == FALSE) {
    install.packages(i)
  }
}

require(dplyr)  # working with data frames
#require(MASS)
#require(reshape2)
#require(cowplot)
require(rgdal) # reading shapefiles
require(sp) # reading shapefiles
library(ggplot2) # plots
library(corrplot) # correlation plots
library(RColorBrewer) # color paletters
#library(ggthemes)
library(fmsb) # radar charts
library(tictoc) # time procedures
library(stargazer) # nice summary statistics 
# require(psych) #EFA
require(GPArotation) #EFA 
library(cluster) # clustering
library(factoextra) # metrics to choose number of clusters 
library(DandEFA) # for dandelion plots of EFA factors 
library(sf)
library(xtable)
library(psych)
library(aCRM) # for data imputation
library(clusterCrit) # for cluster internal and external validity metrics
library(sf)
library(dplyr)
library(stargazer)
library(psych)
library(data.table)
library(tigris)
library(DAAG)
library(tidyr)
library(fastDummies)
library(mlogit)
library(filling)
library(FNN)
library(rlist)
library(openxlsx)
