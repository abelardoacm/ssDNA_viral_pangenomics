#!/bin/bash
mkdir -p ../results/Pangenomic_input_clusters
mkdir -p $1_clusters
cp ../data/Individual_full_genbank_files/$1_catfiltered_genbank_genomes/* .
cat ../results/NbClust_membership_vectors/$1_membership_vectors.csv | grep -v -i "consenso" | cut -d, -f1,10 | sed 's/"//g' | sed 's/,/.gbk,cluster_/g' | sed 's/,/ /g' | sed 's/taxid/*taxid/g' > rename_rules.txt
cat ../results/NbClust_membership_vectors/$1_membership_vectors.csv | sed 's/"//g'| cut -d, -f10 | sort | uniq | grep -v -i "consenso" | while read line ; do
   mkdir cluster_$line
done
eval "$(sed 's/^/mv /g' rename_rules.txt )"
mv cluster* $1_clusters
mv $1_clusters ../results/Pangenomic_input_clusters/
rm rename_rules.txt
