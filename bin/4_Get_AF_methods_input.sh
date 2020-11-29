#!/bin/bash

mkdir ../data/AF_methods_input

#A positional argument $1 is expected when calling this script. (i.e. ./4_Get_AF_methods_input.sh Geminiviridae.gb)

awk ' /^>/ && FNR > 1 {next} {print $0} ' ../data/Genomic_fasta_files/$1_catfiltered_fasta_genomes/* > ../data/AF_methods_input/$1_AF_input.fasta

