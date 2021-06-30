#!/bin/bash
#9_invoke_parse_pangenome_matrix.sh
#
#Author: Abelardo Aguilar Camara
#
# Task: For every folder that contains a get_homologues of ANYTAXON, this script invokes parse_pangenome_matrix.pl to get rocaleta graphic files.
#
ANYTAXON=$1 # $1 = anytaxon aka viral family (e.g. Circoviridae)
#
find ../results/Get_homologues/$ANYTAXON/ -mindepth 2 -maxdepth 2 -type f -name pangenome_matrix*.tab |
 grep -v "_genes_\|\.tr\."|
  cut -d"/" -f5- |
   while read panmatrix; do echo "parse_pangenome_matrix.pl -m $panmatrix -s"; done > $ANYTAXON.parse_pangenome.tmp.sh
# finds all pangenomic matrices with tab termination   
 # filters to retrieve only pangenome_matrix_t0.tab
  # deletes relative path
   # prints every new line of temporary script containing parse_pangenome_matrix.pl commands 
chmod +x $ANYTAXON.parse_pangenome.tmp.sh # execution permission to temporary script
mv $ANYTAXON.parse_pangenome.tmp.sh ../results/Get_homologues/$ANYTAXON/ # sends temporary script to needed location
(cd ../results/Get_homologues/$ANYTAXON; ./$ANYTAXON.parse_pangenome.tmp.sh) # invoke temporary script using ../results/Get_homologues/$ANYTAXON as root folder
rm ../results/Get_homologues/$ANYTAXON/$ANYTAXON.parse_pangenome.tmp.sh # removes temporary script
