#!/bin/bash
print_center(){
    local x
    local y
    text="$*"
    x=$(( ($(tput cols) - ${#text}) / 2))
    echo -ne "\E[6n";read -sdR y; y=$(echo -ne "${y#*[}" | cut -d';' -f1)
    echo -ne "\033[${y};${x}f$*"
}
# Ask for viral family
clear
echo -e "_____________________________________________\nWhich taxon/family do you want to work with?\n_____________________________________________\n\n\tvalid options in your Raw_database folder are:\n"
ls ../data/Raw_database/ | sed 's/.gb//g' | nl
echo -e "\n\n"
read -p "type taxon/family and hit enter: " family
while [[ $(ls ../data/Raw_database/ | sed 's/.gb//g' | grep -w $family | wc -l) != [1] ]] ; do
  echo
  echo $family is not a valid option, please try again...
  echo
  read -p "type taxon/family and hit enter: " family
done
echo -e "Working with $family genomes\n\n" > Report_$family
clear

# ./1_Set_family_files_from_raw_genbank.sh
print_center "- - - - - -1_Set_family_files_from_raw_genbank.sh- - - - - -"
echo -e "\n\n...\nreading $family.gb to split into individual files\n..."
echo -e "------------1_Set_family_files_from_raw_genbank.sh------------\n" >> Report_$family
./1_Set_family_files_from_raw_genbank.sh $family | tee -a Report_$family
echo -e "\n\nDONE: Obtained individual files\n\n\n\n\n" | tee -a Report_$family
sleep 3
clear

# perl 2_Concatenation_from_taxid.pl
print_center "- - - - - -2_Concatenation_from_taxid.pl- - - - - -"
echo -e "\n\n...\nmatching species and taxonomic IDs for genomic segments concatenation\n..."
echo -e "------------2_Concatenation_from_taxid.pl------------\n" >> Report_$family
perl 2_Concatenation_from_taxid.pl $family | tee -a Report_$family
echo -e "\n\nDONE: Concatenated segmented genomes into single files\n\n\n\n\n" | tee -a Report_$family
sleep 3
clear

# perl 3_Protein_count_filtering.pl
print_center "- - - - - -3_Protein_count_filtering.pl- - - - - -"
echo -e "\n\n"
echo -e "------------3_Protein_count_filtering.pl------------\n" >> Report_$family
read -p "What percentage of variation from average protein count do you want to allow? " percvar
echo Allowed percentage of variation from average protein count\: $percvar >> Report_$family
echo -e "...\n collecting parameters for protein count filtering\n...\n________________________________\n\nAmong $family reference genomes,"
read -p "    which is the lowest protein count? " lesspc
echo Minimum protein count among reference strains\: $lesspc >> Report_$family
read -p "    which is the highest protein count? " morepc
echo Maximum protein count among reference strains\: $morepc >> Report_$family
echo -e "...\nperforming $family filtering by protein count\n..."
perl 3_Protein_count_filtering.pl $family $percvar $lesspc $morepc | tee -a Report_$family 
echo -e "\n\nDONE: Filtered genomes by its protein count \n\n\n\n\n" | tee -a Report_$family
sleep 3
clear

# ./4_Vectors_CPFSCC.sh $family
print_center "- - - - - -4_Vectors_CPFSCC.sh- - - - - -"
echo -e "\n\n"
echo -e "------------4_Vectors_CPFSCC.sh $family------------\n" >> Report_$family
echo -e "...\ncomputing central moments and covariance vectors of cumulative Fourier Transform power and phase spectra of $family genomes\n..."
./4_Vectors_CPFSCC.sh $family
echo CPFSCC vectors of $family genomes saved in ../results/Central_moments_and_covariance_vectors_CPFSCC/$family\_CPFSCC_vectors.txt | tee -a Report_$family
echo -e "\n\nDONE: Computed CPFSCC vectors\n\n\n\n\n" | tee -a Report_$family
sleep 3
clear

# Rscript 5a_NbClust.r $family $minnc $maxnc
print_center "- - - - - -5a_NbClust.r- - - - - -"
echo -e "\n\n"
echo -e "------------5a_NbClust.r $family $minnc $maxnc------------\n" >> Report_$family
read -p "What is the minimum number of clusters you want to allow? (one cluster recommended)  " minnc
echo Minimum number of clusters allowed\: $minnc >> Report_$family
read -p "What is the maximum number of clusters you want to allow? (no more than 15 recommended)  " maxnc
echo Maximum number of clusters allowed\: $maxnc >> Report_$family
echo ______________________________________________________________________________________________
Rscript 5a_NbClust.r $family $minnc $maxnc
echo -e "\nNumber of clusters found for $family genomes: $(cat ../results/NbClust_membership_vectors/$family\_membership_vectors.csv | cut -d, -f10 | sed 's/"//g' | sort | uniq | grep -v "Consenso" | tail -n1)"| tee -a Report_$family
echo -e "\n\nDONE: Generated clusters with NbClust\n\n\n\n\n" | tee -a Report_$family
sleep 3
clear

# Rscript 5b_Sample_reduction.r $family $percsr
print_center "- - - - - -5b_Sample_reduction.r- - - - - -"
echo -e "\n\n"
echo -e "------------5b_Sample_reduction.r $family $percsr------------\n" >> Report_$family
echo -e "\n______________________________________________________________________________________________\n\n"
read -p "Do you want to perform sample reduction based on distances (recommended)?  (yes/no)  " -n 1 -r 
echo
if [[ $REPLY =~ ^[Nn]$ ]]; then
	echo sample reduction won\'t be performed >> Report_$family
fi
if [[ $REPLY =~ ^[Yy]$ ]]; then
	echo sample reduction will be performed >> Report_$family
	echo -e "...\necho collecting parameters for sample reduction\n...\n"
	read -p "    By which percentage you want to reduce your sample ?  " percsr
	echo Percentage for sample reduction\: $percsr >> Report_$family
	Rscript 5b_Sample_reduction.r $family $percsr
	echo -e "$(cat ../results/Lists_for_sample_reduction/*$family\.txt | wc -l) genomes, corresponding to %$percsr most distant to centroid of each cluster were discarded"
	echo -e "\n\nDONE: Reduced sample by %$percsr\n\n\n\n\n" | tee -a Report_$family
	sleep 3
	clear
fi

# ./6_Files_to_clusters.sh $family
print_center "- - - - - -6_Files_to_clusters.sh- - - - - -"
echo -e "\n\n...\n redirecting files to clusters\n..."
echo -e "------------6_Files_to_clusters.sh $family------------\n" >> Report_$family
./6_Files_to_clusters.sh $family | tee -a Report_$family
sleep 3
echo $family genomes were redirected to pangenomic input clusters >> Report_$family
echo -e "\n\nDONE: Files sent to pangenomic input clusters\n\n\n\n\n" | tee -a Report_$family
clear
