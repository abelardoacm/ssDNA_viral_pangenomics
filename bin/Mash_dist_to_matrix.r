#!/usr/bin/env Rscript
#Mash_dist_to_matrix.r
#
#Author: Abelardo Aguilar Camara
#
#Task performed:
#    Reads mash dist anytaxon vs anytaxon stdout and writes a
#    distance matrix with proper format
#
#
#
#INPUT: mash dist of anytax vs anytax  from  ../results/Mash_distances/anytaxon_mashd_raw.csv
#
#OUTPUT: Distance matrix           in    ../results/Distance_Matrices/
#
#################################################
#
#Mash_dist_to_matrix.r
#
#################################################
# Load needed packages
suppressPackageStartupMessages(library("dplyr"))
suppressPackageStartupMessages(library("tidyr"))
#################################################
# Reading input
setwd("../results/Mash_distances/") # Input location
PosArgs <- as.character(commandArgs(trailingOnly = TRUE))
family = PosArgs[1]  #Reads positional arguments to define family (e.g. family = "Geminiviridae")
raw_mash_out <- paste(family, "_mashd_raw.csv", sep = "") #Builds input filename
MashDistOut <- read.csv(raw_mash_out, header = FALSE) #Reads csv
#################################################
#Give format to columns names
MashDistOut$V1 <- gsub("^.*.taxid", replacement = "taxid", MashDistOut$V1 ) %>%
  gsub(".fn", replacement = "", .) #Delete everything except taxid
MashDistOut$V2 <- gsub("^.*.taxid", replacement = "taxid", MashDistOut$V2 ) %>%
  gsub(".fn", replacement = "", .) #Delete everything except taxid
#################################################
#Subset to only recover comparisons and distances
Mash.dist.mx <- select(MashDistOut, V1:V3) %>% 
  pivot_wider(., names_from= V2, values_from = V3) #Uses pivot_wider to build dist.matrix from table
Mash.dist.mx <- as.matrix(Mash.dist.mx) #reformat
setwd("../../bin/")
#################################################
#Save output
system ("mkdir -p ../results/Distance_Matrices/")
setwd("../results/Distance_Matrices/") #Output Location
outmx_name <- paste(family, "_mash_distmx.csv", sep = "")
write.csv(Mash.dist.mx, outmx_name, row.names = FALSE) #Write distance matrix as csv




