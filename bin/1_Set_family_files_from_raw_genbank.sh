#!/bin/bash

mkdir ../data/Genomic_fasta_files ../data/Individual_full_genbank_files ../data/Proteomic_fasta_files


#This bash scripts lives in bin
#A positional argument $0 is expected when calling this script. (i.e. ./1_set_family_files_from_raw_genbank.sh Geminiviridae.gb)
#Assumes the pre-existence of folders: data/Genomic_fasta_files, data/Individual_full_genbank_files, data/Proteomic_fasta_files and data/Raw_base, this last containing a .gb file with the genomes from the corresponding viral family.

#This script will generate a folder with the name of the family, located in data/Genomic_fasta_files, with fasta nucleotides files for individual species genomes.
perl Genbank_to_genomic_fasta_taxid_in_name.pl $1.gb

#This script will generate a folder with the name of the family, located in data/Proteomic_fasta_files, with concatenated fasta aminoacids files for individual species proteomes.
perl Genbank_to_proteomic_fasta_taxid_in_name.pl $1.gb

perl Print_rename_instructions.pl $1.gb
eval "$(sed 's/^/mv /g' rename_rules.txt )"
mv *.gbk ../data/Individual_full_genbank_files/$1_genbank_genomes
rm rename_rules.txt
rm $1.gb

