#!/bin/bash
#Sample_reduction.sh
#
#Author: Abelardo Aguilar Camara
#
#Task performed:
#
#    Updates membership vectors to delete files from sample reduction    
#
#INPUT: List for sample reduction          from    ../results/Lists_for_sample_reduction/*anytaxon.txt
#  
#OUTPUT: Updated membership vectors file   in      ../results/NbClust_membership_vectors/anytaxon_membership_vectors.csv
#
#
#################################################
#
#Sample_reduction.sh
#
#################################################
cat ../results/Lists_for_sample_reduction/*$1.txt | cut -d' ' -f1 > IDs_to_remove.txt #Save taxids of organisms to be removed
mv ../results/NbClust_membership_vectors/$1_membership_vectors.csv IDs_to_be_subset.csv #Copy old membership vectors
grep -wvf IDs_to_remove.txt IDs_to_be_subset.csv > ../results/NbClust_membership_vectors/$1_membership_vectors.csv #Retrieve lines that do not match a taxid to be deleted
#################################################
#Remove temporary files
rm IDs_to_remove.txt
rm IDs_to_be_subset.csv
