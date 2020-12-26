#!/bin/bash
cat ../results/Lists_for_sample_reduction/*$1.txt | cut -d' ' -f1 > IDs_to_remove.txt
mv ../results/NbClust_membership_vectors/$1_membership_vectors.csv IDs_to_be_subset.csv
grep -wvf IDs_to_remove.txt IDs_to_be_subset.csv > ../results/NbClust_membership_vectors/$1_membership_vectors.csv
rm IDs_to_remove.txt
rm IDs_to_be_subset.csv
