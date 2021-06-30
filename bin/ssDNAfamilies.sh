#!/bin/bash
#
# This script computes  ./pre pangenomic clustering without graphic guides via:
# ./pre_pangenomic_clustering.sh <1_family> <2_allowed_pc_variation> <3_minimum_reference_pc> <4_maximum_reference_pc> <5_minimum_#clusters> <6_maximum_#clusters> <7_percentage_of_reduction> <8_clustering_method>
#./pre_pangenomic_clustering.sh Alphasatellitidae 50 1 2 2 15 20 complete
#./pre_pangenomic_clustering.sh Anelloviridae 30 2 4 2 7 0 single
#./pre_pangenomic_clustering.sh Bacilladnaviridae 95 3 6 1 4 0 complete
#./pre_pangenomic_clustering.sh Circoviridae 50 2 3 2 15 10 complete
#./pre_pangenomic_clustering.sh Geminiviridae 50 4 8 2 15 30 complete
#./pre_pangenomic_clustering.sh Genomoviridae 50 2 4 2 12 0 centroid
#./pre_pangenomic_clustering.sh Inoviridae 50 9 15 2 8 0 centroid
#./pre_pangenomic_clustering.sh Microviridae 50 8 19 2 8 0 single
#./pre_pangenomic_clustering.sh Nanoviridae 50 7 9 2 8 0 complete
#./pre_pangenomic_clustering.sh Parvoviridae 50 3 9 2 15 20 median
#./pre_pangenomic_clustering.sh Pleolipoviridae 50 9 15 2 6 0 mcquitty
#./pre_pangenomic_clustering.sh Smacoviridae 50 6 6 2 8 0 median
#./pre_pangenomic_clustering.sh Tolecusatellitidae 50 1 1 2 15 30 single
#
#Families that wont be pre_clustered
#./pre_pangenomic_clustering.sh Plectroviridae 95 12 13 NA
#./pre_pangenomic_clustering.sh Bidnaviridae 95 7 7 NA
#./pre_pangenomic_clustering.sh Spiraviridae 95 57 57 NA
#
#Invoking GETHOMS
#./7_invoke_get_homologues.sh Alphasatellitidae 5 10 50 0.01
#./7_invoke_get_homologues.sh Anelloviridae 5 10 50 0.01
#./7_invoke_get_homologues.sh Bacilladnaviridae 5 10 50 0.01
#./7_invoke_get_homologues.sh Circoviridae 5 10 50 0.01
#./7_invoke_get_homologues.sh Geminiviridae 5 10 50 0.01
#./7_invoke_get_homologues.sh Genomoviridae 5 10 50 0.01
#./7_invoke_get_homologues.sh Inoviridae 5 10 50 0.01
#./7_invoke_get_homologues.sh Microviridae 5 10 50 0.01
#./7_invoke_get_homologues.sh Nanoviridae 5 10 50 0.01
#./7_invoke_get_homologues.sh Parvoviridae 5 10 50 0.01
#./7_invoke_get_homologues.sh Pleolipoviridae 5 10 50 0.01
#./7_invoke_get_homologues.sh Smacoviridae 5 10 50 0.01
#./7_invoke_get_homologues.sh Tolecusatellitidae 5 10 50 0.01
#
#Invoking Compare_clusters.pl
#./8_invoke_compare_clusters.sh Alphasatellitidae
#./8_invoke_compare_clusters.sh Anelloviridae
#./8_invoke_compare_clusters.sh Bacilladnaviridae
#./8_invoke_compare_clusters.sh Circoviridae
#./8_invoke_compare_clusters.sh Geminiviridae
#./8_invoke_compare_clusters.sh Genomoviridae
#./8_invoke_compare_clusters.sh Inoviridae
#./8_invoke_compare_clusters.sh Microviridae
#./8_invoke_compare_clusters.sh Nanoviridae
#./8_invoke_compare_clusters.sh Parvoviridae
#./8_invoke_compare_clusters.sh Pleolipoviridae
#./8_invoke_compare_clusters.sh Smacoviridae
#./8_invoke_compare_clusters.sh Tolecusatellitidae
#
#Invoking parse_pangenome_matrix.pl
./9_invoke_parse_pangenome_matrix.sh Alphasatellitidae
./9_invoke_parse_pangenome_matrix.sh Anelloviridae
./9_invoke_parse_pangenome_matrix.sh Bacilladnaviridae
./9_invoke_parse_pangenome_matrix.sh Circoviridae
./9_invoke_parse_pangenome_matrix.sh Geminiviridae
./9_invoke_parse_pangenome_matrix.sh Genomoviridae
./9_invoke_parse_pangenome_matrix.sh Inoviridae
./9_invoke_parse_pangenome_matrix.sh Microviridae
./9_invoke_parse_pangenome_matrix.sh Nanoviridae
./9_invoke_parse_pangenome_matrix.sh Parvoviridae
./9_invoke_parse_pangenome_matrix.sh Pleolipoviridae
./9_invoke_parse_pangenome_matrix.sh Smacoviridae
./9_invoke_parse_pangenome_matrix.sh Tolecusatellitidae



