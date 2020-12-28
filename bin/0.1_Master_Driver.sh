#!/bin/bash

# Ask for viral family
echo Which family do you want to work with?
read family

# ./1_Set_family_files_from_raw_genbank.sh
echo ...
echo reading $family.gbk file to split into: individual genomic fasta \(.fn\), proteomic fasta \(.faa\) and genbank \(.gbk\) files
echo ...
sleep 3
./1_Set_family_files_from_raw_genbank.sh $family
echo DONE: Obtained individual files
sleep 3

# perl 2_Concatenation_from_taxid.pl
echo ...
echo matching species and taxonomic IDs for genomic segments concatenation
echo ...
sleep 3
perl 2_Concatenation_from_taxid.pl $family
echo DONE: Concatenated segmented genomes into single files
sleep 3

# perl 3_Protein_count_filtering.pl
echo ...
echo collecting parameters for protein count filtering
echo ...
echo What percentage of variation from average protein count do you want to allow ?
read percvar
echo ...
echo What is the lowest protein count among the reference genomes of the family $family ?
read lesspc
echo ...
echo What is the highest protein count among the reference genomes of the family $family ?
read morepc
echo ...
echo performing $family filtering by protein count
echo ...
sleep 3
perl 3_Protein_count_filtering.pl $family $percvar $lesspc $morepc
echo DONE: Filtered genomes by its protein count

# ./4_Vectors_CPFSCC.sh $family
echo ...
echo computing central moments and covariance vectors of cumulative Fourier Transform power and phase spectra of $family genomes
echo ...
sleep 3
./4_Vectors_CPFSCC.sh $family
echo DONE: Computed CPFSCC vectors
sleep 3

# Rscript 5a_NbClust.r $family $minnc $maxnc
echo ...
echo collecting parameters for pre-pangenomic clustering with NbClust
echo ...
echo What is the minimum number of clusters you want to allow? \(one cluster recommended\)
read minnc
sleep 1
echo ...
echo What is the maximum number of clusters you want to allow? \(no more than 15 recommended\)
read maxnc
sleep 3
Rscript 5a_NbClust.r $family $minnc $maxnc
echo DONE: Generated clusters with NbClust
sleep 3

# Rscript 5b_Sample_reduction.r $family $percsr
read -p "Do you want to perform sample reduction based on distances (recommended)? " -n 1 -r
if [[ $REPLY =~ ^[Yy]$ ]]
then
echo ...
echo collecting parameters for sample reduction
echo ...
sleep 1
echo By what percentage you want to reduce your sample ?
read percsr
Rscript 5b_Sample_reduction.r $family $percsr
echo DONE: Reduced sample by \%$percsr 
sleep 1
fi


# ./6_Files_to_clusters.sh $family
echo ...
echo redirecting files to clusters
echo ...
./6_Files_to_clusters.sh $family
sleep 1
echo DONE: Files sent to pangenomic input clusters
