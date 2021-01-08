#!/bin/bash
mkdir -p ../results
mkdir -p ../results/Master_reports
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
clear
echo -e "\n\nWorking with $family genomes\nA report text file will be saved in /results/Master_reports/Report_$family \n\n...\nchecking if $family was already used as input\n...\n"
sleep 1
clear
#Display steps already performed
print_center "Previous results from the following steps are available for $family:"
echo -e "\n\n"
stepcheck=1
if [[ $(find ../data/Proteomic_fasta_files/ -name "$family\_fasta_proteomes*" | wc -l) != [0] ]]; then
	print_center "1.- Set family files from raw genbank was already performed "
	echo
	stepcheck=2	
	varmenu1=1
else
	varmenu1=0
fi
if [[ $(find ../data/Proteomic_fasta_files/ -name "$family\_concatenated_fasta_proteomes" | wc -l) != [0] ]]; then
	print_center "2.- Concatenate matching taxid and name                     "
	echo
	stepcheck=3
	varmenu2=1
else
	varmenu2=0
fi
if [[ $(find ../data/Proteomic_fasta_files/ -name "$family\_catfiltered_fasta_proteomes" | wc -l) != [0] ]]; then
	print_center "3.- Filter by protein count                                 "
	echo
	stepcheck=4
	varmenu3=1
else
	varmenu3=0
fi
if [[ $(find ../results/CPFSCC_vectors/ -name "$family\_CPFSCC_vectors.txt" | wc -l) != [0] ]]; then
	print_center "4.- Compute CPFSCC vectors                                  "
	echo
	stepcheck=5
	varmenu4=1
else
	varmenu4=0
fi
if [[ $(find ../results/NbClust_membership_vectors/ -name "$family\_membership_vectors.csv" | wc -l) != [0] ]]; then
	print_center "5.- Estimate clusters with R package NbClust                "
	echo
	stepcheck=6
	varmenu5=1
else
	varmenu5=0
fi
if [[ $(find ../results/Pangenomic_input_clusters/ -name "$family\_clusters" | wc -l) != [0] ]]; then
	print_center "6.- Redirect files to folders by current clustering scenario"
	echo
	varmenu6=1
else
	varmenu6=0
fi
if [[ $(find ../results/Master_reports/ -name "Report_$family" | wc -l) == [0] ]]; then
	echo
	print_center "No previous Report_$family file report was found"
else
	echo
	print_center "A previous Report_$family file report was found"
fi
#Variable menu
echo -e "\n________________________________________\nAvailable options with current data are:\n\n \t(0)\tPerform all steps\n\n\tor pick a single step \n\n\t(1)\tSet family files from raw genbank\n"
if [[ $varmenu1 -gt 0 ]]; then
	echo -e "\t(2)\tConcatenate matching taxid and name\n"
fi
if [[ $varmenu2 -gt 0 ]]; then
	echo -e "\t(3)\tFilter by protein count\n"
fi
if [[ $varmenu3 -gt 0 ]]; then
	echo -e "\t(4)\tCompute CPFSCC vectors\n"
fi
if [[ $varmenu4 -gt 0 ]]; then
	echo -e "\t(5)\tEstimate clusters + option to sample reduction\n"
fi
if [[ $varmenu5 -gt 0 ]]; then
	echo -e "\t(6)\tRedirect files to folders by current clustering scenario\n"
fi
echo
read -p "... type the number of available option:" -n 1 -r repl

#Repeat if stepcheck not passed
until [ $stepcheck -ge $repl ]; do 
	echo -e "\n $repl is not a valid option, please try again...\n"
	read -p "... type an available option:" -n 1 -r repl
done

clear
#PERFORM INDIVIDUAL STEPS
if [[ $repl =~ ^[1]$ ]]; then
	print_center "- - - - - -1_Set_family_files_from_raw_genbank.sh- - - - - -"
	while [[ $(find ../data/Proteomic_fasta_files/ -name "$family\_fasta_proteomes*" | wc -l) != [0] ]]; do
		echo -e "\n\nThe first step (1_Set_family_files_from_raw_genbank.sh) was already performed for $family.gb\n... you can decide if you want to continue and delete previous results for this step or exit\n\n________________________________\n"
		sleep 1
		read -p "    do you want to continue (yes/no) ?" -n 1 -r
		until [[ $REPLY =~ ^[YyNn]$ ]]; do
			echo -e "    $REPLY not a valid answer\n"
			read -p "    do you want to continue (yes/no) ?" -n 1 -r
		done  
		if [[ $REPLY =~ ^[Yy]$ ]]; then
			rm -r ../data/Individual_full_genbank_files/$family\_genbank_genomes/
			rm -r ../data/Proteomic_fasta_files/$family\_fasta_proteomes/
			rm -r ../data/Genomic_fasta_files/$family\_fasta_genomes/
			echo -e "\n...\nDONE: Deleted previous results"
			sleep 2
			clear
		fi
		if [[ $REPLY =~ ^[Nn]$ ]]; then
			clear
			exit 1
		fi
	done
	# ./1_Set_family_files_from_raw_genbank.sh
	echo -e "\n\n...\nreading $family.gb to split into individual files\n..."
	echo -e "------------1_Set_family_files_from_raw_genbank.sh------------\n" >> ../results/Master_reports/Report_$family
	./1_Set_family_files_from_raw_genbank.sh $family | tee -a ../results/Master_reports/Report_$family
	echo -e "\n\nINPUT:\t/data/Raw_database/$family.gb\n\nOUTPUT:  *.fn files\tin\t/data/Genomic_fasta_files/$family\_fasta_genomes\n        *.gbk files\tin\t/data/Individual_full_genbank_files/$family\_genbank_genomes\n        *.faa files\tin\t/data/Proteomic_fasta_files/$family\_fasta_proteomes" | tee -a ../results/Master_reports/Report_$family 
	echo -e "\n\nDONE: Obtained individual files\n\n\n\n\n" | tee -a ../results/Master_reports/Report_$family
	sleep 4
	exit 1
fi

# perl 2_Concatenation_from_taxid.pl
if [[ $repl =~ ^[2]$ ]]; then
	print_center "- - - - - -2_Concatenation_from_taxid.pl- - - - - -"
	while [[ $(find ../data/Proteomic_fasta_files/ -name "$family\_concatenated_fasta_proteomes" | wc -l) != [0] ]]; do
		echo -e "\n\nThe second step (2_Concatenation_from_taxid.pl) was already performed for $family\nif you wish to continue, previous results for this step will be deleted\n\n"
		sleep 0.5
		read -p "    do you want to continue (yes/no) ?" -n 1 -r 
		until [[ $REPLY =~ ^[YyNn]$ ]]; do
			echo -e "    $REPLY not a valid answer\n"
			read -p "    do you want to continue (yes/no) ?" -n 1 -r
		done
		if [[ $REPLY =~ ^[Yy]$ ]]; then
			rm -r ../data/Individual_full_genbank_files/$family\_concatenated_genbank_genomes/
			rm -r ../data/Proteomic_fasta_files/$family\_concatenated_fasta_proteomes/
			rm -r ../data/Genomic_fasta_files/$family\_concatenated_fasta_genomes/
			echo -e "\n...\nDONE: Deleted previous results"
			sleep 0.5
			clear
		fi
		if [[ $REPLY =~ ^[Nn]$ ]]; then
			clear
			exit 1
		fi
	done
	echo -e "\n\n...\nmatching species and taxonomic IDs for genomic segments concatenation\n..."
	echo -e "------------2_Concatenation_from_taxid.pl------------\n" >> ../results/Master_reports/Report_$family
	perl 2_Concatenation_from_taxid.pl $family | tee -a ../results/Master_reports/Report_$family
	echo -e "\n\nINPUT:\t/data/Raw_database/$family.gb\n\t/data/Genomic_fasta_files/$family\_fasta_genomes\n      \t/data/Individual_full_genbank_files/$family\_genbank_genomes\n      \t/data/Proteomic_fasta_files/$family\_fasta_proteomes\n\nOUTPUT:  *.fn files\tin\t/data/Genomic_fasta_files/$family\_concatenated_fasta_genomes\n        *.gbk files\tin\t/data/Individual_full_genbank_files/$family\_concatenated_genbank_genomes\n        *.faa files\tin\t/data/Proteomic_fasta_files/$family\_concatenated_fasta_proteomes" | tee -a ../results/Master_reports/Report_$family
	echo -e "\n\nDONE: Concatenated segmented genomes into single files\n\n\n\n\n" | tee -a ../results/Master_reports/Report_$family
	sleep 4
	exit 1
fi


# perl 3_Protein_count_filtering.pl
if [[ $repl =~ ^[3]$ ]]; then
	print_center "- - - - - -3_Protein_count_filtering.pl- - - - - -"
	while [[ $(find ../data/Proteomic_fasta_files/ -name "$family\_catfiltered_fasta_proteomes" | wc -l) != [0] ]]; do
		echo -e "\n\nThe third step (3_Protein_count_filtering.pl) was already performed for $family\nif you wish to continue, previous results for this step will be deleted\n\n"
		sleep 0.5
		read -p "    do you want to continue (yes/no) ?" -n 1 -r 
		until [[ $REPLY =~ ^[YyNn]$ ]]; do
			echo -e "    $REPLY not a valid answer\n"
			read -p "    do you want to continue (yes/no) ?" -n 1 -r
		done
		if [[ $REPLY =~ ^[Yy]$ ]]; then
			rm -r ../data/Individual_full_genbank_files/$family\_catfiltered_genbank_genomes/
			rm -r ../data/Proteomic_fasta_files/$family\_catfiltered_fasta_proteomes/
			rm -r ../data/Genomic_fasta_files/$family\_catfiltered_fasta_genomes/
			echo -e "\n...\nDONE: Deleted previous results"
			sleep 0.5
		fi
		if [[ $REPLY =~ ^[Nn]$ ]]; then
			clear
			exit 1
		fi
	done
	echo -e "\n\n"
	echo -e "------------3_Protein_count_filtering.pl------------\n" >> ../results/Master_reports/Report_$family
	read -p "What percentage of variation from average protein count do you want to allow? " percvar
	echo Allowed percentage of variation from average protein count\: $percvar >> ../results/Master_reports/Report_$family
	echo -e "...\n collecting parameters for protein count filtering\n...\n________________________________\n\nAmong $family reference genomes,"
	read -p "    which is the lowest protein count? " lesspc
	echo Minimum protein count among reference strains\: $lesspc >> ../results/Master_reports/Report_$family
	read -p "    which is the highest protein count? " morepc
	echo Maximum protein count among reference strains\: $morepc >> ../results/Master_reports/Report_$family
	echo -e "...\nperforming $family filtering by protein count\n..."
	perl 3_Protein_count_filtering.pl $family $percvar $lesspc $morepc | tee -a ../results/Master_reports/Report_$family 
	echo -e "\n\nINPUT:\t/data/Genomic_fasta_files/$family\_concatenated_fasta_genomes\n      \t/data/Individual_full_genbank_files/$family\_concatenated_genbank_genomes\n      \t/data/Proteomic_fasta_files/$family\_concatenated_fasta_proteomes\n\nOUTPUT:  *.fn files\tin\t/data/Genomic_fasta_files/$family\_catfiltered_fasta_genomes\n        *.gbk files\tin\t/data/Individual_full_genbank_files/$family\_catfiltered_genbank_genomes\n        *.faa files\tin\t/data/Proteomic_fasta_files/$family\_catfiltered_fasta_proteomes" | tee -a ../results/Master_reports/Report_$family
	echo -e "\n\nDONE: Filtered genomes by protein count \n\n\n\n\n" | tee -a ../results/Master_reports/Report_$family
	sleep 4
	exit 1
fi


# ./4_Vectors_CPFSCC.sh $family
if [[ $repl =~ ^[4]$ ]]; then
	print_center "- - - - - -4_Vectors_CPFSCC.sh- - - - - -"
	while [[ $(find ../results/CPFSCC_vectors/ -name "$family\_CPFSCC_vectors.txt" | wc -l) != [0] ]]; do
		echo -e "\n\nThe fourth step, performed by 4_Vectors_CPFSCC.sh was already performed for $family\nif you wish to continue, previous results for this step will be deleted\n\n"
		sleep 0.5
		read -p "    do you want to continue (yes/no) ?" -n 1 -r 
		until [[ $REPLY =~ ^[YyNn]$ ]]; do
			echo -e "    $REPLY not a valid answer\n"
			read -p "    do you want to continue (yes/no) ?" -n 1 -r
		done
		if [[ $REPLY =~ ^[Yy]$ ]]; then
			rm ../data/AF_methods_input/$family\_AF_input.fasta
			rm ../results/CPFSCC_vectors/$family\_CPFSCC_vectors.txt
			echo -e "\n...\nDONE: Deleted previous results"
			sleep 0.5
		fi
		if [[ $REPLY =~ ^[Nn]$ ]]; then
			clear
			exit 1
		fi
	done
	echo -e "\n\n"
	echo -e "------------4_Vectors_CPFSCC.sh $family------------\n" >> ../results/Master_reports/Report_$family
	echo -e "...\ncomputing central moments and covariance vectors of cumulative Fourier Transform power and phase spectra of $family genomes\n..."
	./4_Vectors_CPFSCC.sh $family
	echo CPFSCC vectors of $family genomes saved in ../results/CPFSCC_vectors/$family\_CPFSCC_vectors.txt | tee -a ../results/Master_reports/Report_$family
	echo -e "\n\nINPUT:\tMulti-fasta containing all $family genomes:\t/data/AF_methods_input/$family\_AF_input.fasta\n\nOUTPUT: Text file containing $family CPFSCC vectors:\t/results/CPFSCC_vectors/$family\_CPFSCC_vectors.txt" | tee -a ../results/Master_reports/Report_$family
	echo -e "\n\nDONE: Computed CPFSCC vectors\n\n\n\n\n" | tee -a ../results/Master_reports/Report_$family
	sleep 4
	exit 1
fi


# Rscript 5a_NbClust.r $family $minnc $maxnc
if [[ $repl =~ ^[5]$ ]]; then
	print_center "- - - - - -5a_NbClust.r- - - - - -"
	while [[ $(find ../results/NbClust_membership_vectors/ -name "$family\_membership_vectors.csv" | wc -l) != [0] ]]; do
		echo -e "\n\nNbClust R package estimations were already performed for $family\nif you wish to continue, previous results for this step will be deleted\n\n"
		sleep 0.5
		read -p "    do you want to continue (yes/no) ?" -n 1 -r 
		until [[ $REPLY =~ ^[YyNn]$ ]]; do
			echo -e "    $REPLY not a valid answer\n"
			read -p "    do you want to continue (yes/no) ?" -n 1 -r
		done
		if [[ $REPLY =~ ^[Yy]$ ]]; then
			rm ../results/NbClust_membership_vectors/$family\_membership_vectors.csv
			rm ../results/Distance_Matrices/$family\_distance_matrix.csv
			rm ../results/Clustering_graphics/$family\_distances_pplot.tiff
			rm ../results/Clustering_graphics/$family\_PCA_clusters.tiff
			echo -e "\n...\nDONE: Deleted previous results"
			sleep 0.5
		fi
		if [[ $REPLY =~ ^[Nn]$ ]]; then
			clear
			exit 1
		fi
	done
	echo -e "\n\n"
	echo -e "------------5a_NbClust.r $family $minnc $maxnc------------\n" >> ../results/Master_reports/Report_$family
	read -p "What is the minimum number of clusters you want to allow? (one cluster recommended)  " minnc
	echo Minimum number of clusters allowed\: $minnc >> ../results/Master_reports/Report_$family
	read -p "What is the maximum number of clusters you want to allow? (no more than 15 recommended)  " maxnc
	echo Maximum number of clusters allowed\: $maxnc >> ../results/Master_reports/Report_$family
	echo -e "\n...\ncomputing Nbclust R package indices\n..."
	Rscript 5a_NbClust.r $family $minnc $maxnc
	echo -e "\nNumber of clusters found for $family genomes: $(cat ../results/NbClust_membership_vectors/$family\_membership_vectors.csv | cut -d, -f10 | sed 's/"//g' | sort | uniq | grep -v "Consenso" | tail -n1)"| tee -a ../results/Master_reports/Report_$family
	echo -e "\n\nINPUT:\tText file containing CPFSCC vectors:\t/results/CPFSCC_vectors/$family\_CPFSCC_vectors.txt\n\nOUTPUT: Membership vectors\t/results/NbClust_membership_vectors/$family\_membership_vectors.csv\n\tDistance matrix\t/results/Distance_Matrices/$family\_distance_matrix.csv\n\tLinear point plot\t/results/Clustering_graphics/$family\_distances_pplot.tiff\n\tClusters PCA    \t/results/Clustering_graphics/$family\_PCA_clusters.tiff" | tee -a ../results/Master_reports/Report_$family
	echo -e "\n\nDONE: Generated clusters with NbClust\n\n\n\n\n" | tee -a ../results/Master_reports/Report_$family
	sleep 4
	# Rscript 5b_Sample_reduction.r $family $percsr
	print_center "- - - - - -5b_Sample_reduction.r- - - - - -"
	echo -e "\n...\nanswer whether or not to perform sample reduction\n...\n"
	echo -e "------------5b_Sample_reduction.r $family $percsr------------\n" >> ../results/Master_reports/Report_$family
	read -p "Do you want to perform sample reduction based on distances (recommended)?  (yes/no)  " -n 1 -r 
	echo
	until [[ $REPLY =~ ^[YyNn]$ ]]; do
		echo -e "    $REPLY not a valid answer\n"
		read -p "    do you want to continue (yes/no) ?" -n 1 -r
	done
	if [[ $REPLY =~ ^[Nn]$ ]]; then
		echo sample reduction won\'t be performed >> ../results/Master_reports/Report_$family
	fi
	if [[ $REPLY =~ ^[Yy]$ ]]; then
		echo sample reduction will be performed >> ../results/Master_reports/Report_$family
		echo -e "...\ncollecting parameters for sample reduction\n...\n"
		read -p "    By which percentage you want to reduce your sample ?  " percsr
		echo Percentage for sample reduction\: $percsr >> ../results/Master_reports/Report_$family
		Rscript 5b_Sample_reduction.r $family $percsr
		echo -e "$(cat ../results/Lists_for_sample_reduction/*$family\.txt | wc -l) genomes, corresponding to %$percsr most distant to centroid of each cluster were discarded"
		echo -e "$(cat ../results/Lists_for_sample_reduction/*$family\.txt | wc -l) genomes, corresponding to %$percsr most distant to centroid of each cluster were discarded" >> ../results/Master_reports/Report_$family
		echo -e "\n\nINPUT:\tDistance matrix:  \tresults/Distance_Matrices/$family\_distance_matrix.csv\n\tMembership vectors:\t/results/Distance_Matrices/$family\_membership_vectors.csv\n\nOUTPUT: Linear point plot\t/results/Clustering_graphics/$family\_distances_pplot_after_sr_by_$percsr\_percent.tiff\n\tClusters PCA\t/results/Clustering_graphics/$family\_PCA_clusters_after_sr_by_$percsr\_percent.tiff\n\tList of discarded taxa:\t/results/Lists_for_sample_reduction/$percsr\_percent_most_distant_$family\..txt\n\tModified membership vectors\t/results/NbClust_membership_vectors/$family\_membership_vectors.csv" | tee -a ../results/Master_reports/Report_$family
		echo -e "\n\nDONE: Reduced sample by %$percsr\n\n\n\n\n" | tee -a ../results/Master_reports/Report_$family
		sleep 4
		exit 1
	fi
fi



# ./6_Files_to_clusters.sh $family
if [[ $repl =~ ^[6]$ ]]; then
	print_center "- - - - - -6_Files_to_clusters.sh- - - - - -"
	echo -e "\n\n\n"
	if [[ $(find ../results/Pangenomic_input_clusters/ -name "$family\_clusters" | wc -l) != [0] ]]; then
		print_center "Up to this point you've generated a new membership vectors file. It contains a possible scenario to build the input clusters for pangenomic analysis. Now you have to decide if you want to redirect files as the current membership vectors file indicates"
		echo -e "\n\n\n"
		print_center "If you decide to continue, $family pangenomic_input_clusters folder will be overwritten "
		echo -e "\n\n_____________________________________"
		read -p "    do you want to continue?  (yes/no)  " -n 1 -r
		until [[ $REPLY =~ ^[YyNn]$ ]]; do
			echo -e "    $REPLY not a valid answer\n"
			read -p "    do you want to continue (yes/no) ?" -n 1 -r
		done
		if [[ $REPLY =~ ^[Yy]$ ]]; then
			rm -r ../results/Pangenomic_input_clusters/*$family*
			echo -e "DONE: Deleted previous $family pangenomic input clusters"
		fi
		if [[ $REPLY =~ ^[Nn]$ ]]; then
			clear
			exit 1
		fi
	fi
	echo -e "\n\n...\nredirecting files to clusters\n..."
	echo -e "------------6_Files_to_clusters.sh $family------------\n" >> ../results/Master_reports/Report_$family
	./6_Files_to_clusters.sh $family | tee -a ../results/Master_reports/Report_$family
	sleep 4
	echo $family genomes were redirected to pangenomic input clusters >> ../results/Master_reports/Report_$family
	echo -e "\n\nINPUT:\tMembership vectors\t/results/NbClust_membership_vectors/$family\_membership_vectors.csv\n\nOUTPUT: Pangenomic input clusters:\t/results/Pangenomic_input_clusters/$family\_clusters/" | tee -a ../results/Master_reports/Report_$family
	echo -e "\n\nDONE: Files sent to pangenomic input clusters\n\n\n\n\n" | tee -a ../results/Master_reports/Report_$family
	sleep 4
	exit 1
fi

#If there was no previous report (or it was deleted); then
#PERFORM ENTIRE ANALYSIS
if [[ $repl =~ ^[0]$ ]]; then
	find .. -name "*$family*" | grep -v "Raw" | while read line ; do
		rm -fr $line
	done
	echo -e "Working with $family genomes\n\n" > ../results/Master_reports/Report_$family
	# ./1_Set_family_files_from_raw_genbank.sh
	print_center "- - - - - -1_Set_family_files_from_raw_genbank.sh- - - - - -"
	echo -e "\n\n...\nreading $family.gb to split into individual files\n..."
	echo -e "------------1_Set_family_files_from_raw_genbank.sh------------\n" >> ../results/Master_reports/Report_$family
	./1_Set_family_files_from_raw_genbank.sh $family | tee -a ../results/Master_reports/Report_$family
	echo -e "\n\nINPUT:\t/data/Raw_database/$family.gb\n\nOUTPUT:  *.fn files\tin\t/data/Genomic_fasta_files/$family\_fasta_genomes\n        *.gbk files\tin\t/data/Individual_full_genbank_files/$family\_genbank_genomes\n        *.faa files\tin\t/data/Proteomic_fasta_files/$family\_fasta_proteomes" | tee -a ../results/Master_reports/Report_$family 
	echo -e "\n\nDONE: Obtained individual files\n\n\n\n\n" | tee -a ../results/Master_reports/Report_$family
	sleep 4
	clear
	print_center "- - - - - -2_Concatenation_from_taxid.pl- - - - - -"
	echo -e "\n\n...\nmatching species and taxonomic IDs for genomic segments concatenation\n..."
	echo -e "------------2_Concatenation_from_taxid.pl------------\n" >> ../results/Master_reports/Report_$family
	perl 2_Concatenation_from_taxid.pl $family | tee -a ../results/Master_reports/Report_$family
	echo -e "\n\nINPUT:\t/data/Raw_database/$family.gb\n\t/data/Genomic_fasta_files/$family\_fasta_genomes\n      \t/data/Individual_full_genbank_files/$family\_genbank_genomes\n      \t/data/Proteomic_fasta_files/$family\_fasta_proteomes\n\nOUTPUT:  *.fn files\tin\t/data/Genomic_fasta_files/$family\_concatenated_fasta_genomes\n        *.gbk files\tin\t/data/Individual_full_genbank_files/$family\_concatenated_genbank_genomes\n        *.faa files\tin\t/data/Proteomic_fasta_files/$family\_concatenated_fasta_proteomes" | tee -a ../results/Master_reports/Report_$family
	echo -e "\n\nDONE: Concatenated segmented genomes into single files\n\n\n\n\n" | tee -a ../results/Master_reports/Report_$family
	sleep 4
	clear
	print_center "- - - - - -3_Protein_count_filtering.pl- - - - - -"
	echo -e "\n\n"
	echo -e "------------3_Protein_count_filtering.pl------------\n" >> ../results/Master_reports/Report_$family
	read -p "What percentage of variation from average protein count do you want to allow? " percvar
	echo Allowed percentage of variation from average protein count\: $percvar >> ../results/Master_reports/Report_$family
	echo -e "...\n collecting parameters for protein count filtering\n...\n________________________________\n\nAmong $family reference genomes,"
	read -p "    which is the lowest protein count? " lesspc
	echo Minimum protein count among reference strains\: $lesspc >> ../results/Master_reports/Report_$family
	read -p "    which is the highest protein count? " morepc
	echo Maximum protein count among reference strains\: $morepc >> ../results/Master_reports/Report_$family
	echo -e "...\nperforming $family filtering by protein count\n..."
	perl 3_Protein_count_filtering.pl $family $percvar $lesspc $morepc | tee -a ../results/Master_reports/Report_$family 
	echo -e "\n\nINPUT:\t/data/Genomic_fasta_files/$family\_concatenated_fasta_genomes\n      \t/data/Individual_full_genbank_files/$family\_concatenated_genbank_genomes\n      \t/data/Proteomic_fasta_files/$family\_concatenated_fasta_proteomes\n\nOUTPUT:  *.fn files\tin\t/data/Genomic_fasta_files/$family\_catfiltered_fasta_genomes\n        *.gbk files\tin\t/data/Individual_full_genbank_files/$family\_catfiltered_genbank_genomes\n        *.faa files\tin\t/data/Proteomic_fasta_files/$family\_catfiltered_fasta_proteomes" | tee -a ../results/Master_reports/Report_$family
	echo -e "\n\nDONE: Filtered genomes by protein count \n\n\n\n\n" | tee -a ../results/Master_reports/Report_$family
	sleep 4
	clear
	print_center "- - - - - -4_Vectors_CPFSCC.sh- - - - - -"
	echo -e "\n\n"
	echo -e "------------4_Vectors_CPFSCC.sh $family------------\n" >> ../results/Master_reports/Report_$family
	echo -e "...\ncomputing central moments and covariance vectors of cumulative Fourier Transform power and phase spectra of $family genomes\n..."
	./4_Vectors_CPFSCC.sh $family
	echo CPFSCC vectors of $family genomes saved in ../results/CPFSCC_vectors/$family\_CPFSCC_vectors.txt | tee -a ../results/Master_reports/Report_$family
	echo -e "\n\nINPUT:\tMulti-fasta containing all $family genomes:\t/data/AF_methods_input/$family\_AF_input.fasta\n\nOUTPUT: Text file containing $family CPFSCC vectors:\t/results/CPFSCC_vectors/$family\_CPFSCC_vectors.txt" | tee -a ../results/Master_reports/Report_$family
	echo -e "\n\nDONE: Computed CPFSCC vectors\n\n\n\n\n" | tee -a ../results/Master_reports/Report_$family
	sleep 4
	clear
	print_center "- - - - - -5a_NbClust.r- - - - - -"
	echo -e "\n\n"
	echo -e "------------5a_NbClust.r $family $minnc $maxnc------------\n" >> ../results/Master_reports/Report_$family
	read -p "What is the minimum number of clusters you want to allow? (one cluster recommended)  " minnc
	until [[ $minnc -gt 0 ]]; do
		echo -e "    $REPLY not a valid answer\n"
		read -p "What is the minimum number of clusters you want to allow? (one cluster recommended)  " minnc
	done
	echo Minimum number of clusters allowed\: $minnc >> ../results/Master_reports/Report_$family
	read -p "What is the maximum number of clusters you want to allow? (no more than 15 recommended)  " maxnc
	echo Maximum number of clusters allowed\: $maxnc >> ../results/Master_reports/Report_$family
	echo -e "\n...\ncomputing Nbclust R package indices\n..."
	Rscript 5a_NbClust.r $family $minnc $maxnc
	echo -e "\nNumber of clusters found for $family genomes: $(cat ../results/NbClust_membership_vectors/$family\_membership_vectors.csv | cut -d, -f10 | sed 's/"//g' | sort | uniq | grep -v "Consenso" | tail -n1)"| tee -a ../results/Master_reports/Report_$family
	echo -e "\n\nINPUT:\tText file containing CPFSCC vectors:\t/results/CPFSCC_vectors/$family\_CPFSCC_vectors.txt\n\nOUTPUT: Membership vectors\t/results/NbClust_membership_vectors/$family\_membership_vectors.csv\n\tDistance matrix\t/results/Distance_Matrices/$family\_distance_matrix.csv\n\tLinear point plot\t/results/Clustering_graphics/$family\_distances_pplot.tiff\n\tClusters PCA    \t/results/Clustering_graphics/$family\_PCA_clusters.tiff" | tee -a ../results/Master_reports/Report_$family
	echo -e "\n\nDONE: Generated clusters with NbClust\n\n\n\n\n" | tee -a ../results/Master_reports/Report_$family
	sleep 4
	clear
	print_center "- - - - - -5b_Sample_reduction.r- - - - - -"
	echo -e "\n...\nanswer whether or not to perform sample reduction\n...\n"
	echo -e "------------5b_Sample_reduction.r $family $percsr------------\n" >> ../results/Master_reports/Report_$family
	read -p "Do you want to perform sample reduction based on distances (recommended)?  (yes/no)  " -n 1 -r 
	echo
	until [[ $REPLY =~ ^[YyNn]$ ]]; do
		echo -e "    $REPLY not a valid answer\n"
		read -p "    do you want to continue (yes/no) ?" -n 1 -r
	done
	if [[ $REPLY =~ ^[Nn]$ ]]; then
		echo sample reduction won\'t be performed >> ../results/Master_reports/Report_$family
	fi
	if [[ $REPLY =~ ^[Yy]$ ]]; then
		echo sample reduction will be performed >> ../results/Master_reports/Report_$family
		echo -e "...\ncollecting parameters for sample reduction\n...\n"
		read -p "    By which percentage you want to reduce your sample ?  " percsr
		echo Percentage for sample reduction\: $percsr >> ../results/Master_reports/Report_$family
		Rscript 5b_Sample_reduction.r $family $percsr
		echo -e "$(cat ../results/Lists_for_sample_reduction/*$family\.txt | wc -l) genomes, corresponding to %$percsr most distant to centroid of each cluster were discarded"
		echo -e "$(cat ../results/Lists_for_sample_reduction/*$family\.txt | wc -l) genomes, corresponding to %$percsr most distant to centroid of each cluster were discarded" >> ../results/Master_reports/Report_$family
		echo -e "\n\nINPUT:\tDistance matrix:  \tresults/Distance_Matrices/$family\_distance_matrix.csv\n\tMembership vectors:\t/results/Distance_Matrices/$family\_membership_vectors.csv\n\nOUTPUT: Linear point plot\t/results/Clustering_graphics/$family\_distances_pplot_after_sr_by_$percsr\_percent.tiff\n\tClusters PCA\t/results/Clustering_graphics/$family\_PCA_clusters_after_sr_by_$percsr\_percent.tiff\n\tList of discarded taxa:\t/results/Lists_for_sample_reduction/$percsr\_percent_most_distant_$family\..txt\n\tModified membership vectors\t/results/NbClust_membership_vectors/$family\_membership_vectors.csv" | tee -a ../results/Master_reports/Report_$family
		echo -e "\n\nDONE: Reduced sample by %$percsr\n\n\n\n\n" | tee -a ../results/Master_reports/Report_$family
		sleep 4
		clear
	fi
	print_center "- - - - - -6_Files_to_clusters.sh- - - - - -"
	echo -e "\n\n\n"
	print_center "Up to this point you've generated a new membership vectors file. It contains a possible scenario to build the input clusters for pangenomic analysis. Now you have to decide if you want to redirect files as the current membership vectors file indicates"
	echo -e "\n\n\n"
	print_center "If you decide to continue, $family pangenomic_input_clusters folder will be overwritten "
	echo -e "\n\n_____________________________________"
	read -p "    do you want to continue?  (yes/no)  " -n 1 -r
	until [[ $REPLY =~ ^[YyNn]$ ]]; do
		echo -e "    $REPLY not a valid answer\n"
		read -p "    do you want to continue (yes/no) ?" -n 1 -r
	done
	if [[ $REPLY =~ ^[Yy]$ ]]; then
		echo -e "\nDONE: Deleted previous $family pangenomic input clusters"
	fi
	if [[ $REPLY =~ ^[Nn]$ ]]; then
		clear
		exit 1
	fi
	echo -e "\n\n...\nredirecting files to clusters\n..."
	echo -e "------------6_Files_to_clusters.sh $family------------\n" >> ../results/Master_reports/Report_$family
	./6_Files_to_clusters.sh $family | tee -a ../results/Master_reports/Report_$family
	sleep 4
	echo $family genomes were redirected to pangenomic input clusters >> ../results/Master_reports/Report_$family
	echo -e "\n\nINPUT:\tMembership vectors\t/results/NbClust_membership_vectors/$family\_membership_vectors.csv\n\nOUTPUT: Pangenomic input clusters:\t/results/Pangenomic_input_clusters/$family\_clusters/" | tee -a ../results/Master_reports/Report_$family
	echo -e "\n\nDONE: Files sent to pangenomic input clusters\n\n\n\n\n" | tee -a ../results/Master_reports/Report_$family
	sleep 4
	exit 1
fi
