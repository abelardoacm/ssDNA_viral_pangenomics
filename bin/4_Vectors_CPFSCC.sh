#!/bin/bash

mkdir -p ../data/AF_methods_input

#A positional argument $1 is expected when calling this script. (i.e. ./4_Get_AF_methods_input.sh Geminiviridae.gb)

awk ' /^>/ && FNR > 1 {next} {print $0} ' ../data/Genomic_fasta_files/$1_catfiltered_fasta_genomes/* > ../data/AF_methods_input/$1_AF_input.fasta
sed -i 's/\//-/g' ../data/AF_methods_input/$1_AF_input.fasta
sed -i 's/,/-/g' ../data/AF_methods_input/$1_AF_input.fasta
sed -i 's/;/-/g' ../data/AF_methods_input/$1_AF_input.fasta
sed -i 's/:/-/g' ../data/AF_methods_input/$1_AF_input.fasta
cp ../data/AF_methods_input/$1_AF_input.fasta input.fasta
mkdir -p ../results
mkdir -p ../results/Central_moments_and_covariance_vectors_CPFSCC
matlab -batch "Modified_CPFSCC"
grep ">" ../data/AF_methods_input/$1_AF_input.fasta | cut -d"|" -f3 | sed ':a;N;$!ba;s/\n/,/g' > ../results/Central_moments_and_covariance_vectors_CPFSCC/$1_CPFSCC_vectors.txt
cat A.txt >> ../results/Central_moments_and_covariance_vectors_CPFSCC/$1_CPFSCC_vectors.txt
rm A.txt
rm input.fasta


