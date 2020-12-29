#!/bin/bash

# Ask for viral family
clear
echo _____________________________________________
echo Which taxon\/family do you want to work with?
echo _____________________________________________
echo 
echo valid options in your Raw_database folder are:
echo
ls ../data/Raw_database/ | sed 's/.gb//g' | nl
echo
echo 
echo
read -p "type taxon/family and hit enter: " family
while [[ $(ls ../data/Raw_database/ | sed 's/.gb//g' | grep -w $family | wc -l) != [1] ]] ; do
  echo
  echo $family is not a valid option, please try again...
  echo
  read -p "type taxon/family and hit enter: " family
done
echo Working with $family genomes > Report_$family
clear

# ./1_Set_family_files_from_raw_genbank.sh
echo ...
echo reading $family.gb file to split into: individual genomic fasta \(.fn\), proteomic fasta \(.faa\) and genbank \(.gbk\) files
echo ...
sleep 3
echo "./1_Set_family_files_from_raw_genbank.sh" >> Report_$family
./1_Set_family_files_from_raw_genbank.sh $family | tee -a Report_$family
echo DONE: Obtained individual files
sleep 3
clear

# perl 2_Concatenation_from_taxid.pl
echo "perl 2_Concatenation_from_taxid.pl" | tee -a Report_$family
echo ...
echo matching species and taxonomic IDs for genomic segments concatenation
echo ...
sleep 3
perl 2_Concatenation_from_taxid.pl $family | tee -a Report_$family
echo DONE: Concatenated segmented genomes into single files
sleep 3
clear

# perl 3_Protein_count_filtering.pl
echo "3_Protein_count_filtering.pl" | tee -a Report_$family
echo ...
echo collecting parameters for protein count filtering
echo ___________________________________________________________________________________
read -p "What percentage of variation from average protein count do you want to allow? " percvar
echo Allowed percentage of variation from average protein count is\: $percvar >> Report_$family
echo ___________________________________________________________________________________
echo
echo Among $family reference genomes\,
read -p "    which is the lowest protein count? " lesspc
echo Minimum protein count among reference strains is\: $lesspc >> Report_$family
read -p "    which is the highest protein count? " morepc
echo Maximum protein count among reference strains is\: $morepc >> Report_$family
echo ...
echo performing $family filtering by protein count
echo ...
sleep 2
perl 3_Protein_count_filtering.pl $family $percvar $lesspc $morepc | tee -a Report_$family 
echo DONE: Filtered genomes by its protein count
sleep 3
clear

# ./4_Vectors_CPFSCC.sh $family
echo "./4_Vectors_CPFSCC.sh $family" | tee -a Report_$family
echo ...
echo computing central moments and covariance vectors of cumulative Fourier Transform power and phase spectra of $family genomes
echo ...
sleep 3
./4_Vectors_CPFSCC.sh $family | tee -a Report_$family
echo DONE: Computed CPFSCC vectors
sleep 3
clear

# Rscript 5a_NbClust.r $family $minnc $maxnc
echo "Rscript 5a_NbClust.r $family $minnc $maxnc" | tee -a Report_$family
echo ...
echo collecting parameters for pre-pangenomic clustering with NbClust
echo ______________________________________________________________________________________________
read -p "What is the minimum number of clusters you want to allow? (one cluster recommended)  " minnc
echo Minimum number of clusters allowed\: $minnc >> Report_$family
read -p "What is the maximum number of clusters you want to allow? (no more than 15 recommended)  " maxnc
echo Maximum number of clusters allowed\: $maxnc >> Report_$family
echo ______________________________________________________________________________________________
sleep 2
Rscript 5a_NbClust.r $family $minnc $maxnc | tee -a Report_$family
echo DONE: Generated clusters with NbClust
sleep 3
clear

# Rscript 5b_Sample_reduction.r $family $percsr
echo "Rscript 5b_Sample_reduction.r $family $percsr" | tee -a Report_$family
echo 
echo ______________________________________________________________________________________________
read -p "Do you want to perform sample reduction based on distances (recommended)?  (yes/no)  " -n 1 -r
echo
if [[ $REPLY =~ ^[Nn]$ ]]; then
	echo sample reduction won\'t be performed >> Report_$family
fi
if [[ $REPLY =~ ^[Yy]$ ]]; then
	echo sample reduction will be performed >> Report_$family
	echo ...
	echo collecting parameters for sample reduction
	echo ...
	sleep 1
	echo 
	read -p "    By which percentage you want to reduce your sample ?  " percsr
	echo percentage for sample reduction is\: $percsr >> Report_$family
	Rscript 5b_Sample_reduction.r $family $percsr | tee -a Report_$family
	echo DONE: Reduced sample by \%$percsr
	sleep 3
	clear
fi

# ./6_Files_to_clusters.sh $family
echo "./6_Files_to_clusters.sh $family" >> Report_$family
echo ...
echo redirecting files to clusters
echo ...
./6_Files_to_clusters.sh $family | tee -a Report_$family
echo DONE: Files sent to pangenomic input clusters
sleep 3
echo $family genomes were redirected to pangenomic input clusters >> Report_$family
