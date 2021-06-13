#!/bin/bash
#
#Author: Abelardo Aguilar Camara
#
#Task performed:
#    This script performs all the computations to prepair the pangenomic inputs,
#    this includes clustering genomes, building graphs to picture grouping and
#    redirecting files to clusters
#
#INPUT: Full genbank file of anytaxon refseq genomes (expects a viral family).
#
#OUTPUT: Depends on selected computations, printed in terminal and in master reports.
# 
##########################################
#pre_pangenomic_clustering
##########################################
#Master script
#Creates folder to contain result and master reports
mkdir -p ../results
mkdir -p ../results/Master_reports
# Function to display text in the center of terminal
print_center(){
    local x
    local y
    text="$*"
    x=$(( ($(tput cols) - ${#text}) / 2))
    echo -ne "\E[6n";read -sdR y; y=$(echo -ne "${y#*[}" | cut -d';' -f1)
    echo -ne "\033[${y};${x}f$*"
}
##########################################
# While loop to restrict progression until a valid option is given
if [[ $(ls ../data/Raw_database/ | sed 's/.gb//g' | grep -w $1 | wc -l) != [1] ]] ; then
  echo $1 is not a valid option, please try again...
  exit 1
fi
clear
echo -e "\n\nWorking with $1 genomes\nA report text file will be saved in /results/Master_reports/Report_$1 \n\n...\nchecking if $1 was already used as input\n...\n"
clear
##########################################

##########################################
#PERFORM INDIVIDUAL STEPS
##########################################
#1_Set_family_files_from_raw_genbank.sh
#Separating from general anytaxon files to individual 
# Removing previous results for 1_Set_family_files_from_raw_genbank.sh
rm -r ../data/Individual_full_genbank_files/$1\_genbank_genomes/ 2>/dev/null
rm -r ../data/Proteomic_fasta_files/$1\_fasta_proteomes/ 2>/dev/null
rm -r ../data/Genomic_fasta_files/$1\_fasta_genomes/ 2>/dev/null
echo -e "\n...\nDeleted previous 1_Set_family_files_from_raw_genbank.sh results"
echo -e "\n\n...\nreading $1.gb to split into individual files\n..."
print_center "------------1_Set_family_files_from_raw_genbank.sh------------"
echo -e "------------1_Set_family_files_from_raw_genbank.sh------------\n" >> ../results/Master_reports/Report_$1
##############################
./1_Set_family_files_from_raw_genbank.sh $1 | tee -a ../results/Master_reports/Report_$1
##############################
echo -e "\n\nINPUT:\t/data/Raw_database/$1.gb\n\nOUTPUT:  *.fn files\tin\t/data/Genomic_fasta_files/$1\_fasta_genomes\n        *.gbk files\tin\t/data/Individual_full_genbank_files/$1\_genbank_genomes\n        *.faa files\tin\t/data/Proteomic_fasta_files/$1\_fasta_proteomes" | tee -a ../results/Master_reports/Report_$1 
echo -e "\n\nDONE: Obtained individual files\n\n\n\n\n" | tee -a ../results/Master_reports/Report_$1
##########################################
# perl 2_Concatenation_from_taxid.pl
print_center "- - - - - -2_Concatenation_from_taxid.pl- - - - - -"
echo -e "\n\n"
files_before_cat=$(ls ../data/Proteomic_fasta_files/$1\_fasta_proteomes/ | wc -l)
files_after_cat=$(ls ../data/Proteomic_fasta_files/$1\_fasta_proteomes/ | sed 's/^.*\(taxid.*.faa\).*$/\1/' | uniq | wc -l)
concatenated_files=$(ls ../data/Proteomic_fasta_files/$1\_fasta_proteomes/ | sed 's/^.*\(taxid.*.faa\).*$/\1/' | uniq -c | grep -vw "1" | wc -l)
print_center "There are $files_before_cat $1 individual files before concatenation, of which"
echo
print_center " $concatenated_files could be segments.The number of files after concatenation will be $files_after_cat."
rm -r ../data/Individual_full_genbank_files/$1\_concatenated_genbank_genomes/ 2>/dev/null
rm -r ../data/Proteomic_fasta_files/$1\_concatenated_fasta_proteomes/ 2>/dev/null
rm -r ../data/Genomic_fasta_files/$1\_concatenated_fasta_genomes/ 2>/dev/null
echo -e "\n...\nDeleted previous results"
echo -e "\n\n...\nmatching species and taxonomic IDs for genomic segments concatenation\n..."
echo -e "------------2_Concatenation_from_taxid.pl------------\n" >> ../results/Master_reports/Report_$1
#############################
perl 2_Concatenation_from_taxid.pl $1 | tee -a ../results/Master_reports/Report_$1
#############################
echo -e "\n\nINPUT:\t/data/Raw_database/$1.gb\n\t/data/Genomic_fasta_files/$1\_fasta_genomes\n      \t/data/Individual_full_genbank_files/$1\_genbank_genomes\n      \t/data/Proteomic_fasta_files/$1\_fasta_proteomes\n\nOUTPUT:  *.fn files\tin\t/data/Genomic_fasta_files/$1\_concatenated_fasta_genomes\n        *.gbk files\tin\t/data/Individual_full_genbank_files/$1\_concatenated_genbank_genomes\n        *.faa files\tin\t/data/Proteomic_fasta_files/$1\_concatenated_fasta_proteomes" | tee -a ../results/Master_reports/Report_$1
echo -e "\n\nDONE: Concatenated segmented genomes into single files\n\n\n\n\n" | tee -a ../results/Master_reports/Report_$1
##########################################
##########################################
# perl 3_Protein_count_filtering.pl
print_center "- - - - - -3_Protein_count_filtering.pl- - - - - -"
rm -r ../data/Individual_full_genbank_files/$1\_catfiltered_genbank_genomes/ 2>/dev/null
rm -r ../data/Proteomic_fasta_files/$1\_catfiltered_fasta_proteomes/ 2>/dev/null
rm -r ../data/Genomic_fasta_files/$1\_catfiltered_fasta_genomes/ 2>/dev/null
echo -e "\n...\nDeleted previous results"
echo -e "\n\n"
echo -e "------------3_Protein_count_filtering.pl------------\n" >> ../results/Master_reports/Report_$1
echo Allowed percentage of protein count variation\: $2 | tee -a ../results/Master_reports/Report_$1
echo Minimum protein count among reference strains\: $3 | tee -a ../results/Master_reports/Report_$1
echo Maximum protein count among reference strains\: $4 | tee -a ../results/Master_reports/Report_$1
echo -e "...\nperforming $1 filtering by protein count\n..."
##########################################
perl 3_Protein_count_filtering.pl $1 $2 $3 $4 | tee -a ../results/Master_reports/Report_$1 
##########################################
echo -e "\n\nINPUT:\t/data/Genomic_fasta_files/$1\_concatenated_fasta_genomes\n      \t/data/Individual_full_genbank_files/$1\_concatenated_genbank_genomes\n      \t/data/Proteomic_fasta_files/$1\_concatenated_fasta_proteomes\n\nOUTPUT:  *.fn files\tin\t/data/Genomic_fasta_files/$1\_catfiltered_fasta_genomes\n        *.gbk files\tin\t/data/Individual_full_genbank_files/$1\_catfiltered_genbank_genomes\n        *.faa files\tin\t/data/Proteomic_fasta_files/$1\_catfiltered_fasta_proteomes" | tee -a ../results/Master_reports/Report_$1
echo -e "\n\nDONE: Filtered genomes by protein count \n\n\n\n\n" | tee -a ../results/Master_reports/Report_$1
##########################################
##########################################
##########################################
# ./4_Vectors_CPFSCC.sh $1
print_center "- - - - - -4_Vectors_CPFSCC.sh- - - - - -"
rm ../data/AF_methods_input/$1\_AF_input.fasta 2>/dev/null
rm ../results/CPFSCC_vectors/$1\_CPFSCC_vectors.txt 2>/dev/null
echo -e "\n...\nDeleted previous results"
echo -e "\n\n"
echo -e "------------4_Vectors_CPFSCC.sh $1------------\n" >> ../results/Master_reports/Report_$1
echo -e "...\ncomputing central moments and covariance vectors of cumulative Fourier Transform power and phase spectra of $1 genomes\n..."
./4_Vectors_CPFSCC.sh $1
echo CPFSCC vectors of $1 genomes saved in ../results/CPFSCC_vectors/$1\_CPFSCC_vectors.txt | tee -a ../results/Master_reports/Report_$1
echo -e "\n\nINPUT:\tMulti-fasta containing all $1 genomes:\t/data/AF_methods_input/$1\_AF_input.fasta\n\nOUTPUT: Text file containing $1 CPFSCC vectors:\t/results/CPFSCC_vectors/$1\_CPFSCC_vectors.txt" | tee -a ../results/Master_reports/Report_$1
echo -e "\n\nDONE: Computed CPFSCC vectors\n\n\n" | tee -a ../results/Master_reports/Report_$1
##########################################
##########################################
##########################################
# Rscript 5a_NbClust.r $1 $5 $6
print_center "- - - - - -5a_NbClust.r- - - - - -"
rm ../results/NbClust_membership_vectors/$1\_membership_vectors.csv 2>/dev/null 
rm ../results/Distance_Matrices/$1\_distance_matrix.csv 2>/dev/null
rm ../results/Clustering_graphics/$1\_distances_pplot.tiff 2>/dev/null 
rm ../results/Clustering_graphics/$1\_PCA_clusters.tiff 2>/dev/null
echo -e "\n...\nDeleted previous results"
echo -e "\n\n"
echo -e "------------5a_NbClust.r $1 $5 $6------------\n" >> ../results/Master_reports/Report_$1
echo Minimum number of clusters allowed\: $5 | tee -a ../results/Master_reports/Report_$1
echo Maximum number of clusters allowed\: $6 | tee -a ../results/Master_reports/Report_$1
echo -e "\n...\ncomputing Nbclust R package indices\n..."
##########################################
Rscript 5a_NbClust.r $1 $5 $6
##########################################
echo -e "\nNumber of clusters found for $1 genomes: $(cat ../results/NbClust_membership_vectors/$1\_membership_vectors.csv | cut -d, -f10 | sed 's/"//g' | sort | uniq | grep -v "Consenso" | tail -n1)"| tee -a ../results/Master_reports/Report_$1
echo -e "\n\nINPUT:\tText file containing CPFSCC vectors:\t/results/CPFSCC_vectors/$1\_CPFSCC_vectors.txt\n\nOUTPUT: Membership vectors\t/results/NbClust_membership_vectors/$1\_membership_vectors.csv\n\tDistance matrix\t/results/Distance_Matrices/$1\_distance_matrix.csv\n\tLinear point plot\t/results/Clustering_graphics/$1\_distances_pplot.tiff\n\tClusters PCA    \t/results/Clustering_graphics/$1\_PCA_clusters.tiff" | tee -a ../results/Master_reports/Report_$1
echo -e "\n\nDONE: Generated clusters with NbClust\n\n\n" | tee -a ../results/Master_reports/Report_$1
##########################################
if [[ $8 == "wardD" ]]; then
	redir_method=2
fi
if [[ $8 == "wardD2" ]]; then
	redir_method=3
fi
if [[ $8 == "single" ]]; then
	redir_method=4
fi
if [[ $8 == "complete" ]]; then
	redir_method=5
fi
if [[ $8 == "average" ]]; then
	redir_method=6
fi
if [[ $8 == "mcquitty" ]]; then
	redir_method=7
fi
if [[ $8 == "median" ]]; then
	redir_method=8
fi
if [[ $8 == "centroid" ]]; then
	redir_method=9
fi
if [[ $8 == "consensus" ]]; then
	redir_method=10
fi
##########################################
if [[ $7 == 0 ]]; then
	echo -e "\nSample reduction won't be performed\n"
	./6_Files_to_clusters.sh $1 $redir_method | tee -a ../results/Master_reports/Report_$1
	exit 1
fi
##########################################
# Rscript 5b_Sample_reduction.r $1 $7
print_center "- - - - - -5b_Sample_reduction.r- - - - - -"
echo -e "------------5b_Sample_reduction.r $1 $7------------" >> ../results/Master_reports/Report_$1
echo -e "\n\nWARNING: If you choose to execute sample reduction, clusters with only one member will stay the same."
echo -e "Partition method selected: $8"
echo Percentage for sample reduction\: $7 >> ../results/Master_reports/Report_$1
##########################################
Rscript 5b_Sample_reduction.r $1 $7 $8
##########################################
echo -e "$(cat ../results/Lists_for_sample_reduction/*$1\.txt | wc -l) genomes, corresponding to %$7 most distant to centroid of each cluster were discarded"
echo -e "$(cat ../results/Lists_for_sample_reduction/*$1\.txt | wc -l) genomes, corresponding to %$7 most distant to centroid of each cluster were discarded" >> ../results/Master_reports/Report_$1
echo -e "\n\nINPUT:\tDistance matrix:  \tresults/Distance_Matrices/$1\_distance_matrix.csv\n\tMembership vectors:\t/results/Distance_Matrices/$1\_membership_vectors.csv\n\nOUTPUT: Linear point plot\t/results/Clustering_graphics/$1\_distances_pplot_after_sr_by_$7\_percent.tiff\n\tClusters PCA\t/results/Clustering_graphics/$1\_PCA_clusters_after_sr_by_$7\_percent.tiff\n\tList of discarded taxa:\t/results/Lists_for_sample_reduction/$7\_percent_most_distant_$1\..txt\n\tModified membership vectors\t/results/NbClust_membership_vectors/$1\_membership_vectors.csv" | tee -a ../results/Master_reports/Report_$1
echo -e "\n\nDONE: Reduced sample by %$7\n\n\n" | tee -a ../results/Master_reports/Report_$1
##########################################
##########################################
# ./6_Files_to_clusters.sh $1
print_center "- - - - - -6_Files_to_clusters.sh- - - - - -"
rm -r ../results/Pangenomic_input_clusters/*$family* 2>/dev/null
echo -e "\nDeleted previous $1 pangenomic input clusters"
echo -e "\n\n...\nredirecting files to clusters\n..."
echo -e "------------6_Files_to_clusters.sh $1------------\n" >> ../results/Master_reports/Report_$1
./6_Files_to_clusters.sh $1 $redir_method | tee -a ../results/Master_reports/Report_$1
echo $1 genomes were redirected to pangenomic input clusters following $redir_method method results>> ../results/Master_reports/Report_$1
echo -e "\n\nINPUT:\tMembership vectors\t/results/NbClust_membership_vectors/$1\_membership_vectors.csv\n\nOUTPUT: Pangenomic input clusters:\t/results/Pangenomic_input_clusters/$1\_clusters/" | tee -a ../results/Master_reports/Report_$1
echo -e "\n\nDONE: Files sent to pangenomic input clusters\n\n\n\n\n" | tee -a ../results/Master_reports/Report_$1
clear
cat ../results/Master_reports/Report_$1
