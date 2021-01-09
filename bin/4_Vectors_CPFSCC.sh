#!/bin/bash
#4_Vectors_CPFSCC.sh
#
#Author: Abelardo Aguilar Camara
#
#Task performed:
#
#    Generates the needed concatenated fasta genomic input file for CPFSCC analysis    
#
#    ...then it makes use of Modified_CPFSCC.m to compute central moments and covariance 
#    vectors of cumulative Fourier Transform power and phase spectra of anytaxon genomes
#
#    It also asks for upper/lower reference protein count values to prevent losing reference strains
#
#NOTE:"CPFSCC" stands for central moments and covariance vectors of cumulative fourier transform power and phase spectra
#     "Catfiltered" label stands for concatenated (cat) and filtered
#     A positional argument $1 is expected when calling this script. (i.e. ./4_Get_AF_methods_input.sh Geminiviridae)
#
#INPUT: All catfiltered files from ../data/Genomic_fasta_files/anytaxon_catfiltered_fasta_genomes/
#
#OUTPUT: Alignment-free method input fasta file     in     ../data/AF_methods_input/anytaxon_AF_input.fasta
#   then central moments and covariance vectors     in     ../results/CPFSCC_vectors/anytaxon_CPFSCC_vectors.txt
#
#
#################################################
#
#4_Vectors_CPFSCC.sh
#
#################################################
mkdir -p ../data/AF_methods_input #Creates output directory
#################################################
#################################################
# Use awk to create the alignment-free method input fasta file
#
# awk ' /^>/ && FNR > 1 {next} {print $0} deletes all lines in a file begining with > (fasta headers) except from the first ocurrence
#
awk ' /^>/ && FNR > 1 {next} {print $0} ' ../data/Genomic_fasta_files/$1_catfiltered_fasta_genomes/* > ../data/AF_methods_input/$1_AF_input.fasta
#
# its used over anytaxon_catfiltered_fasta_genomes to concatenate genomic segments under a unique header (set from the first)
#
#################################################
# Remove special characters from headers
sed -i 's/\//-/g' ../data/AF_methods_input/$1_AF_input.fasta
sed -i 's/,/-/g' ../data/AF_methods_input/$1_AF_input.fasta
sed -i 's/;/-/g' ../data/AF_methods_input/$1_AF_input.fasta
sed -i 's/:/-/g' ../data/AF_methods_input/$1_AF_input.fasta
#################################################
cp ../data/AF_methods_input/$1_AF_input.fasta input.fasta # copies AF input file to a temporary file
mkdir -p ../results # Starts results folder
mkdir -p ../results/CPFSCC_vectors # Starts CPFSCC_vectors folder
#################################################
#################################################
# Use matlab script from command line
matlab -batch "Modified_CPFSCC"
#################################################
#################################################
grep ">" ../data/AF_methods_input/$1_AF_input.fasta | cut -d"|" -f3 | sed ':a;N;$!ba;s/\n/,/g' > ../results/CPFSCC_vectors/$1_CPFSCC_vectors.txt # sets taxids as vectors labels
cat A.txt >> ../results/CPFSCC_vectors/$1_CPFSCC_vectors.txt # Save vector array in desired outfile
#Remove temporary files
rm A.txt
rm input.fasta


