#!/bin/bash
#1_Set_family_files_from_raw_genbank.sh
#
#Author: Abelardo Aguilar Camara
#
#Task performed:
#    This script makes use of Genbank_to_genomic_fasta_taxid_in_name.pl,
#    Genbank_to_proteomic_fasta_taxid_in_name.pl, and Print_rename_instructions.pl.
#    The later to rename seqretsplit
#
#INPUT: Concatenated full genbanks of anytaxon in ../data/Raw_database/anytaxon.gb (g.e. Geminiviridae.gb)
#
#OUTPUT: Multiple fasta aminoacid proteomic files (*.faa) in ../data/Proteomic_fasta_files/anytaxon_fasta_proteomes/ 
#            (g.e. Geminiviridae_fasta_proteomes/ )
#
#        Multiple fasta nucleotide files (*.fn) in ../data/Genomic_fasta_files/anytaxon_fasta_genomes/ 
#            (g.e. Geminiviridae_fasta_genomes/ )
#
#        Multiple individual full genbank files (*.gbk) in ../data/Individual_full_genbank_files/anytaxon_genbank_genomes/ 
#            (g.e. Geminiviridae_genbank_genomes/ )
# 
##########################################
#
#1_Set_family_files_from_raw_genbank.sh
#
##########################################
mkdir -p ../data/Genomic_fasta_files ../data/Individual_full_genbank_files ../data/Proteomic_fasta_files # Makes output directories
##########################################
# Using other scripts
perl Genbank_to_genomic_fasta_taxid_in_name.pl $1.gb
perl Genbank_to_proteomic_fasta_taxid_in_name.pl $1.gb
perl Print_rename_instructions.pl $1.gb
##########################################
eval "$(sed 's/^/mv /g' rename_rules.txt )" # Renames *.gbk files following current rename_rules.txt
mv *.gbk ../data/Individual_full_genbank_files/$1_genbank_genomes # Redirects genbank files to desired folder
##########################################
# Cleans temporary files
rm rename_rules.txt
rm $1.gb

