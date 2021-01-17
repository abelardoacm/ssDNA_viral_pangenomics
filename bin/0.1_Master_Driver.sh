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
function printTable()
{
    local -r delimiter="${1}"
    local -r tableData="$(removeEmptyLines "${2}")"
    local -r colorHeader="${3}"
    local -r displayTotalCount="${4}"

    if [[ "${delimiter}" != '' && "$(isEmptyString "${tableData}")" = 'false' ]]
    then
        local -r numberOfLines="$(trimString "$(wc -l <<< "${tableData}")")"

        if [[ "${numberOfLines}" -gt '0' ]]
        then
            local table=''
            local i=1

            for ((i = 1; i <= "${numberOfLines}"; i = i + 1))
            do
                local line=''
                line="$(sed "${i}q;d" <<< "${tableData}")"

                local numberOfColumns=0
                numberOfColumns="$(awk -F "${delimiter}" '{print NF}' <<< "${line}")"

                # Add Line Delimiter

                if [[ "${i}" -eq '1' ]]
                then
                    table="${table}$(printf '%s#+' "$(repeatString '#+' "${numberOfColumns}")")"
                fi

                # Add Header Or Body

                table="${table}\n"

                local j=1

                for ((j = 1; j <= "${numberOfColumns}"; j = j + 1))
                do
                    table="${table}$(printf '#|  %s' "$(cut -d "${delimiter}" -f "${j}" <<< "${line}")")"
                done

                table="${table}#|\n"

                # Add Line Delimiter

                if [[ "${i}" -eq '1' ]] || [[ "${numberOfLines}" -gt '1' && "${i}" -eq "${numberOfLines}" ]]
                then
                    table="${table}$(printf '%s#+' "$(repeatString '#+' "${numberOfColumns}")")"
                fi
            done

            if [[ "$(isEmptyString "${table}")" = 'false' ]]
            then
                local output=''
                output="$(echo -e "${table}" | column -s '#' -t | awk '/^\+/{gsub(" ", "-", $0)}1')"

                if [[ "${colorHeader}" = 'true' ]]
                then
                    echo -e "\033[1;32m$(head -n 3 <<< "${output}")\033[0m"
                    tail -n +4 <<< "${output}"
                else
                    echo "${output}"
                fi
            fi
        fi

        if [[ "${displayTotalCount}" = 'true' && "${numberOfLines}" -ge '0' ]]
        then
            echo -e "\n\033[1;36mTOTAL ROWS : $((numberOfLines - 1))\033[0m"
        fi
    fi
}

function removeEmptyLines()
{
    local -r content="${1}"

    echo -e "${content}" | sed '/^\s*$/d'
}

function repeatString()
{
    local -r string="${1}"
    local -r numberToRepeat="${2}"

    if [[ "${string}" != '' && "$(isPositiveInteger "${numberToRepeat}")" = 'true' ]]
    then
        local -r result="$(printf "%${numberToRepeat}s")"
        echo -e "${result// /${string}}"
    fi
}

function replaceString()
{
    local -r content="${1}"
    local -r oldValue="$(escapeSearchPattern "${2}")"
    local -r newValue="$(escapeSearchPattern "${3}")"

    sed "s@${oldValue}@${newValue}@g" <<< "${content}"
}
function trimString()
{
    local -r string="${1}"

    sed 's,^[[:blank:]]*,,' <<< "${string}" | sed 's,[[:blank:]]*$,,'
}
function isEmptyString()
{
    local -r string="${1}"

    if [[ "$(trimString "${string}")" = '' ]]
    then
        echo 'true' && return 0
    fi

    echo 'false' && return 1
}
function isPositiveInteger()
{
    local -r string="${1}"

    if [[ "${string}" =~ ^[1-9][0-9]*$ ]]
    then
        echo 'true' && return 0
    fi

    echo 'false' && return 1
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
if [[ $(find ../data/Proteomic_fasta_files/ -name "$family\_fasta_proteomes*" 2>/dev/null | wc -l) != [0] ]]; then
	print_center "1.- Set family files from raw genbank was already performed "
	echo
	stepcheck=2	
	varmenu1=1
else
	varmenu1=0
fi
if [[ $(find ../data/Proteomic_fasta_files/ -name "$family\_concatenated_fasta_proteomes" 2>/dev/null | wc -l) != [0] ]]; then
	print_center "2.- Concatenate matching taxid and name                     "
	echo
	stepcheck=3
	varmenu2=1
else
	varmenu2=0
fi
if [[ $(find ../data/Proteomic_fasta_files/ -name "$family\_catfiltered_fasta_proteomes" 2>/dev/null | wc -l) != [0] ]]; then
	print_center "3.- Filter by protein count                                 "
	echo
	stepcheck=4
	varmenu3=1
else
	varmenu3=0
fi
if [[ $(find ../results/CPFSCC_vectors/ -name "$family\_CPFSCC_vectors.txt" 2>/dev/null | wc -l) != [0] ]]; then
	print_center "4.- Compute CPFSCC vectors                                  "
	echo
	stepcheck=5
	varmenu4=1
else
	varmenu4=0
fi
if [[ $(find ../results/NbClust_membership_vectors/ -name "$family\_membership_vectors.csv" 2>/dev/null | wc -l) != [0] ]]; then
	print_center "5.- Estimate clusters with R package NbClust                "
	echo
	stepcheck=6
	varmenu5=1
else
	varmenu5=0
fi
if [[ $(find ../results/Pangenomic_input_clusters/ -name "$family\_clusters" 2>/dev/null | wc -l) != [0] ]]; then
	print_center "6.- Redirect files to folders by current clustering scenario"
	echo
	varmenu6=1
else
	varmenu6=0
fi
if [[ $(find ../results/Master_reports/ -name "Report_$family" 2>/dev/null | wc -l) == [0] ]]; then
	echo
	print_center "No previous Report_$family file report was found"
else
	echo
	print_center "A previous Report_$family file report was found"
fi
#Variable menu
echo -e "\n________________________________________\nAvailable options with current data are:\n\n \t(0)\tPerform all steps\n\n\n\tor pick a single step \n\n\t(1)\tSet family files from raw genbank\n"
if [[ $varmenu1 -gt 0 ]]; then
	echo -e "\t(2)\tConcatenate matching taxid and name\n"
fi
if [[ $varmenu2 -gt 0 ]]; then
	echo -e "\t(3)\tFilter by protein count\n"
fi
if [[ $varmenu3 -gt 0 ]]; then
	echo -e "\t(4)\tEstimate distance matrix with an AF-method\n"
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
if [[ $repl =~ ^[01]$ ]]; then
	print_center "- - - - - -1_Set_family_files_from_raw_genbank.sh- - - - - -"
	while [[ $(find ../data/Proteomic_fasta_files/ -name "$family\_fasta_proteomes*" | wc -l) != [0] ]]; do
		echo -e "\n\n"
		print_center "The first step (1_Set_family_files_from_raw_genbank.sh) was already performed for $family.gb,"
		echo
		print_center "you can decide if you want to continue and delete previous results for this step or exit"
		echo
		print_center "____________________________________________________________________________________________"
		echo -e "\n\n"
		sleep 0.5
		read -p "    do you want to continue (yes/no) ?" -n 1 -r
		until [[ $REPLY =~ ^[YyNn]$ ]]; do
			echo -e "    $REPLY not a valid answer\n"
			read -p "    do you want to continue (yes/no) ?  " -n 1 -r
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
fi

# perl 2_Concatenation_from_taxid.pl
if [[ $repl =~ ^[02]$ ]]; then
	clear
	print_center "- - - - - -2_Concatenation_from_taxid.pl- - - - - -"
	while [[ $(find ../data/Proteomic_fasta_files/ -name "$family\_concatenated_fasta_proteomes" | wc -l) != [0] ]]; do
		echo -e "\n\n"
		print_center "The second step (2_Concatenation_from_taxid.pl) was already performed for $family"
		echo
		print_center "if you wish to continue, previous results for this step will be deleted"
		sleep 0.5
		echo -e "\n\n_____________________________________________"
		read -p "    do you want to continue (yes/no) ?  " -n 1 -r 
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
		fi
		if [[ $REPLY =~ ^[Nn]$ ]]; then
			clear
			exit 1
		fi
	done
	echo -e "\n\n"
	files_before_cat=$(ls ../data/Proteomic_fasta_files/$family\_fasta_proteomes/ | wc -l)
	files_after_cat=$(ls ../data/Proteomic_fasta_files/$family\_fasta_proteomes/ | sed 's/^.*\(taxid.*.faa\).*$/\1/' | uniq | wc -l)
	concatenated_files=$(ls ../data/Proteomic_fasta_files/$family\_fasta_proteomes/ | sed 's/^.*\(taxid.*.faa\).*$/\1/' | uniq -c | grep -vw "1" | wc -l)
	print_center "There are $files_before_cat $family individual files before concatenation,"
	echo
	print_center "of which $concatenated_files could be segments. If you decide to perform this step "
	echo
	print_center "for $family genomes, the number of files after concatenation will be $files_after_cat."
	echo -e "\n\n"
	print_center "You can decide wether to continue or skip concatenation. If you choose to skip, previous $family files will just copied and labeled as \"concatenated\" to serve as input for upcoming steps!"
	echo -e "\n\n_____________________________________________________________\n"
	read -p "    do you want to continue or skip this step (continue/skip)" -n 1 -r
	until [[ $REPLY =~ ^[CcSs]$ ]]; do
		echo -e "    $REPLY not a valid answer\n"
		read -p "    do you want to continue (continue/skip) ?" -n 1 -r
	done
	if [[ $REPLY =~ ^[Ss]$ ]]; then
		cp -r ../data/Genomic_fasta_files/$family\_fasta_genomes ../data/Genomic_fasta_files/$family\_concatenated_fasta_genomes
		cp -r ../data/Individual_full_genbank_files/$family\_genbank_genomes ../data/Individual_full_genbank_files/$family\_concatenated_genbank_genomes
		cp -r ../data/Proteomic_fasta_files/$family\_fasta_proteomes ../data/Proteomic_fasta_files/$family\_concatenated_fasta_proteomes
		echo -e "------------2_Concatenation_from_taxid.pl------------\n\nConcatenation was skipped." >> ../results/Master_reports/Report_$family
	fi
	if [[ $REPLY =~ ^[Cc]$ ]]; then
		echo -e "\n\n...\nmatching species and taxonomic IDs for genomic segments concatenation\n..."
		echo -e "------------2_Concatenation_from_taxid.pl------------\n" >> ../results/Master_reports/Report_$family
		perl 2_Concatenation_from_taxid.pl $family | tee -a ../results/Master_reports/Report_$family
		echo -e "\n\nINPUT:\t/data/Raw_database/$family.gb\n\t/data/Genomic_fasta_files/$family\_fasta_genomes\n      \t/data/Individual_full_genbank_files/$family\_genbank_genomes\n      \t/data/Proteomic_fasta_files/$family\_fasta_proteomes\n\nOUTPUT:  *.fn files\tin\t/data/Genomic_fasta_files/$family\_concatenated_fasta_genomes\n        *.gbk files\tin\t/data/Individual_full_genbank_files/$family\_concatenated_genbank_genomes\n        *.faa files\tin\t/data/Proteomic_fasta_files/$family\_concatenated_fasta_proteomes" | tee -a ../results/Master_reports/Report_$family
		echo -e "\n\nDONE: Concatenated segmented genomes into single files\n\n\n\n\n" | tee -a ../results/Master_reports/Report_$family
		sleep 4
	fi
fi


# perl 3_Protein_count_filtering.pl
if [[ $repl =~ ^[03]$ ]]; then
	clear
	print_center "- - - - - -3_Protein_count_filtering.pl- - - - - -"
	echo -e "\n\n"
	print_center "To perform filter by protein count (pc), you need to define a percentage of allowed variation from the mean pc"
	pc_sumation=$(grep -c ">" ../data/Proteomic_fasta_files/$family\_concatenated_fasta_proteomes/* | sed 's/.*://' | paste -sd+ - | bc)
	pc_n=$(grep -c ">" ../data/Proteomic_fasta_files/$family\_concatenated_fasta_proteomes/* | wc -l)
	pc_n_round=$(($pc_n - 1))
	pc_sumation_round=$(($pc_sumation + $pc_n_round))
	pc_mean=$(($pc_sumation_round / pc_n))
	#
	interval_90=$(($pc_mean * 9))
	interval_70=$(($pc_mean * 7))
	interval_50=$(($pc_mean * 5))
	interval_30=$(($pc_mean * 3))
	interval_10=$(($pc_mean * 1))
	#
	updtd_inter_90=$(($interval_90 / 10))
	updtd_inter_70=$(($interval_70 / 10))
	updtd_inter_50=$(($interval_50 / 10))
	updtd_inter_30=$(($interval_30 / 10))
	updtd_inter_10=$(($interval_10 / 10))
	#
	ulim90=$(($pc_mean + $updtd_inter_90))
	ulim70=$(($pc_mean + $updtd_inter_70))
	ulim50=$(($pc_mean + $updtd_inter_50))
	ulim30=$(($pc_mean + $updtd_inter_30))
	ulim10=$(($pc_mean + $updtd_inter_10))
	#
	llim90=$(($pc_mean - $updtd_inter_90))
	llim70=$(($pc_mean - $updtd_inter_70))
	llim50=$(($pc_mean - $updtd_inter_50))
	llim30=$(($pc_mean - $updtd_inter_30))
	llim10=$(($pc_mean - $updtd_inter_10))
	#
	unset num_above_90
	num_above_90=$(grep -c ">" ../data/Proteomic_fasta_files/$family\_concatenated_fasta_proteomes/* | sed 's/.*://' | awk -v ulim90="${ulim90}" '$1>ulim90' | wc -l)
	unset num_under_90
	num_under_90=$(grep -c ">" ../data/Proteomic_fasta_files/$family\_concatenated_fasta_proteomes/* | sed 's/.*://' | awk -v llim90="${llim90}" '$1<llim90' | wc -l)
	deleted90=$(( $num_above_90 + $num_under_90))
	conserved90=$(($pc_n - $deleted90))
	unset num_above_70
	num_above_70=$(grep -c ">" ../data/Proteomic_fasta_files/$family\_concatenated_fasta_proteomes/* | sed 's/.*://' | awk -v ulim70="${ulim70}" '$1>ulim70' | wc -l)
	unset num_under_70
	num_under_70=$(grep -c ">" ../data/Proteomic_fasta_files/$family\_concatenated_fasta_proteomes/* | sed 's/.*://' | awk -v llim70="${llim70}" '$1<llim70' | wc -l)
	deleted70=$(( $num_above_70 + $num_under_70))
	conserved70=$(($pc_n - $deleted70))
	unset num_above_50
	num_above_50=$(grep -c ">" ../data/Proteomic_fasta_files/$family\_concatenated_fasta_proteomes/* | sed 's/.*://' | awk -v ulim50="${ulim50}" '$1>ulim50' | wc -l)
	unset num_under_50
	num_under_50=$(grep -c ">" ../data/Proteomic_fasta_files/$family\_concatenated_fasta_proteomes/* | sed 's/.*://' | awk -v llim50="${llim50}" '$1<llim50' | wc -l)
	deleted50=$(( $num_above_50 + $num_under_50))
	conserved50=$(($pc_n - $deleted50))
	unset num_above_30
	num_above_30=$(grep -c ">" ../data/Proteomic_fasta_files/$family\_concatenated_fasta_proteomes/* | sed 's/.*://' | awk -v ulim30="${ulim30}" '$1>ulim30' | wc -l)
	unset num_under_30
	num_under_30=$(grep -c ">" ../data/Proteomic_fasta_files/$family\_concatenated_fasta_proteomes/* | sed 's/.*://' | awk -v llim30="${llim30}" '$1<llim30' | wc -l)
	deleted30=$(( $num_above_30 + $num_under_30))
	conserved30=$(($pc_n - $deleted30))
	unset num_above_10
	num_above_10=$(grep -c ">" ../data/Proteomic_fasta_files/$family\_concatenated_fasta_proteomes/* | sed 's/.*://' | awk -v ulim10="${ulim10}" '$1>ulim10' | wc -l)
	unset num_under_10
	num_under_10=$(grep -c ">" ../data/Proteomic_fasta_files/$family\_concatenated_fasta_proteomes/* | sed 's/.*://' | awk -v llim10="${llim10}" '$1<llim10' | wc -l)
	deleted10=$(( $num_above_10 + $num_under_10))
	conserved10=$(($pc_n - $deleted10))
	#
	#
	perc_con90=$(($deleted90 * 100 / $pc_n))
	perc_con70=$(($deleted70 * 100 / $pc_n))
	perc_con50=$(($deleted50 * 100 / $pc_n))
	perc_con30=$(($deleted30 * 100 / $pc_n))
	perc_con10=$(($deleted10 * 100 / $pc_n))
	######################################
	#TABLE
	echo
	echo
	print_center "Here's a table with possible cutoff values ​​and approximate results for $family files:"
	echo
	print_center "($family mean protein count is equal to $pc_mean proteins, estimated over $pc_n genomes)"
	echo -e "\n\n"
	printTable ',' "$(echo -e "% filtering pc,upper pc limit,lower pc limit,discarded,number remaining, discarded %\n\n90%,$ulim90,$llim90,$deleted90,$conserved90,$perc_con90%\n70%,$ulim70,$llim70,$deleted70,$conserved70,$perc_con70%\n50%,$ulim50,$llim50,$deleted50,$conserved50,$perc_con50%\n30%,$ulim30,$llim30,$deleted30,$conserved30,$perc_con30%\n10%,$ulim10,$llim10,$deleted10,$conserved10,$perc_con10%")"
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
fi


# ./4_Vectors_CPFSCC.sh $family
if [[ $repl =~ ^[04]$ ]]; then
	clear
	print_center "- - - - - -4_Vectors_CPFSCC.sh- - - - - -"
	while [[ $(find ../results/CPFSCC_vectors/ -name "$family\_CPFSCC_vectors.txt" 2>/dev/null | wc -l) != [0] ]]; do
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
fi


# Rscript 5a_NbClust.r $family $minnc $maxnc
if [[ $repl =~ ^[05]$ ]]; then
	clear
	print_center "- - - - - -5a_NbClust.r- - - - - -"
	while [[ $(find ../results/NbClust_membership_vectors/ -name "$family\_membership_vectors.csv" 2>/dev/null | wc -l) != [0] ]]; do
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
	fi
fi



# ./6_Files_to_clusters.sh $family
if [[ $repl =~ ^[06]$ ]]; then
	clear
	print_center "- - - - - -6_Files_to_clusters.sh- - - - - -"
	echo -e "\n\n\n"
	if [[ $(find ../results/Pangenomic_input_clusters/ -name "$family\_clusters" 2>/dev/null | wc -l) != [0] ]]; then
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
