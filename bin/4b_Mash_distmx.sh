#!/bin/bash
#
#Author: Abelardo Aguilar Camara
#
mkdir -p ../data/Mash_input #Creates output directory
mkdir -p ../data/Mash_input/$1_mash_in
#
ls ../data/Genomic_fasta_files/$1_catfiltered_fasta_genomes/ | while read virus; do awk ' /^>/ && FNR > 1 {next} {print $0} ' ../data/Genomic_fasta_files/$1_catfiltered_fasta_genomes/$virus > ../data/Mash_input/$1_mash_in/$virus; done
#
#Use mash
#
./mash/mash-Linux64-v2.2/mash sketch -s 700 -k 20 -o $1 ../data/Mash_input/$1_mash_in/*.fn
#
mkdir -p ../results # Starts results folder
mkdir -p ../results/Mash_sketches
#
mv $1.msh ../results/Mash_sketches/
mkdir -p ../results/Mash_distances/
#
./mash/mash-Linux64-v2.2/mash dist ../results/Mash_sketches/$1.msh ../results/Mash_sketches/$1.msh | sed 's/\t/,/g' | sed 's/..\/data\/Mash_input\///g' | sed 's/_mash_in\//_/g' > ../results/Mash_distances/$1_mashd_raw.csv
#
Rscript Mash_dist_to_matrix.r $1
#
sed -i 's/V1//g' ../results/Distance_Matrices/$1_mash_distmx.csv
#

