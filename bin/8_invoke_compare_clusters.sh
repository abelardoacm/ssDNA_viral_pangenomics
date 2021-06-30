#!/bin/bash
#8_invoke_compare_clusters.sh
#
#Author: Abelardo Aguilar Camara
#
# Task: For every folder that contains a get_homologues of ANYTAXON, this script invokes compare_clusters.pl and performs comparisons of COG vs OMCL clusters.
#
ANYTAXON=$1 # $1 = anytaxon aka viral family (e.g. Circoviridae)
#
find ../results/Get_homologues/$ANYTAXON/ -mindepth 1 -maxdepth 1 -type d |
 while read location; do find $location -mindepth 1 -maxdepth 1 -type d -name *alg* -exec bash -c "echo -ne 'echo \"{}\" >> $(echo -ne "$location.tmp.$ANYTAXON" |
  sed "s/..\/results\/Get_homologues\/$ANYTAXON\///g")\n'" \;; done >> $ANYTAXON.tmp.sh 
# finds all primary outdirs of get_homologues.pl for anytaxon
 # prints lines containing subfolders of the primary folder with an instrucion of concatenation to a text file (those sharig parent folder will converge)
  # deletes relative path to build proper -o argument
chmod +x $ANYTAXON.tmp.sh # execution permission to temporary script
./$ANYTAXON.tmp.sh # execute temporary script to build pre-compare_clusters temporary script
sed -i ':a;N;$!ba;s/\n/\/,/g' *.tmp.$ANYTAXON # builds single line -d argument 
ls *.tmp.$ANYTAXON | while read line; do echo -ne "compare_clusters.pl -o $(echo -ne "$line" | sed "s/.tmp.$ANYTAXON/_intersection/g")"; echo -ne " -m -T -d ";cat $line; done > compare_clusters.tmp.$ANYTAXON.sh # final temporary compare clusters script
chmod +x compare_clusters.tmp.$ANYTAXON.sh # permissions to temporary compare_clusters script
sed -i "s/..\/results\/Get_homologues\/$ANYTAXON\///g" compare_clusters.tmp.$ANYTAXON.sh # wordy but relative path is not needed, compare_clusters.pl must share root folder with input when used
mv compare_clusters.tmp.$ANYTAXON.sh ../results/Get_homologues/$ANYTAXON/ # send temporary script to GETHOMS outdir for anytaxon
(cd ../results/Get_homologues/$ANYTAXON; ./compare_clusters.tmp.$ANYTAXON.sh) # invoke temporary script using ../results/Get_homologues/$ANYTAXON as root folder
rm ../results/Get_homologues/$ANYTAXON/compare_clusters.tmp.$ANYTAXON.sh # removes temporary script
rm *.tmp.* #removes temporary files
