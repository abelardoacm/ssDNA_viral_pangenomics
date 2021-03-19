#!/bin/bash
#6_Files_to_clusters.sh
#
#Author: Abelardo Aguilar Camara
#
#Task performed:
#     Redirects .gbk files of anytaxon, after concatenation, filtering and clustering, 
#     into folders for pangenomic analysis.
#
#INPUT: Current membership vectors       from  ../results/NbClust_membership_vectors/
#
#OUTPUT: Folders of anytaxon clusters     in   ../results/Pangenomic_input_clusters/
#
#
#################################################
#
#6_Files_to_clusters.sh
#
#################################################
#Create oufolders and copy input
mkdir -p ../results/Pangenomic_input_clusters
mkdir -p $1_clusters
cp ../data/Individual_full_genbank_files/$1_catfiltered_genbank_genomes/* .
#
#################################################
#Get a temporary file matching taxids and its cluster as follows:
cat ../results/NbClust_membership_vectors/$1_membership_vectors.csv |
 grep -v -i "consenso" |
  cut -d, -f1,$2 |
   sed 's/"//g' |
    sed 's/,/.gbk,cluster_/g' |
     sed 's/,/ /g' |
      sed 's/taxid/*taxid/g' > rename_rules.txt
#display membership vectors
 #deletes header
  #prints only taxid and cluster
   #removes string delimiter
    #prints .gbk and cluster between columns
     #delete commas
      #Print table in temporary files
#
#################################################
#Make outfolder for each cluster as follows:
cat ../results/NbClust_membership_vectors/$1_membership_vectors.csv |
 sed 's/"//g'| grep -v -i "consenso" |
  cut -d, -f$2 |
   sort | uniq | while read line ; do mkdir -p cluster_$line ; done
#displays membership vectors
 #removes commas
  #gets one line per cluster
   #deletes header
    #makes outdir named as cluster
#
#################################################
eval "$(sed 's/^/mv /g' rename_rules.txt )" #Moves each file to its corresponding cluster
mv cluster* $1_clusters #Folders to base anytaxon folder
mv $1_clusters ../results/Pangenomic_input_clusters/ #Base anytaxon folder to results
#################################################
#Remove temporary files
rm rename_rules.txt
rm -f *.gbk

