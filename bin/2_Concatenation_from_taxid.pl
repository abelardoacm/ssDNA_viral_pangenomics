#!/usr/local/bin/perl
#2_Concatenation_from_taxid.pl
#
#Author: Abelardo Aguilar Camara
#
#Task performed:
#    This script compares files and concatenates those that share the same taxonomic id and source organism
#
#INPUT: Genomic fasta files from           ../data/Genomic_fasta_files/anytaxon_fasta_genomes
#       Individual genbank files from      ../data/Individual_full_genbank_files/anytaxon_genbank_genomes
#       Proteomic fasta files from         ../data/Proteomic_fasta_files/anytaxon_fasta_proteomes
#
#OUTPUT:Concatenated genomic fasta files           in     ../data/Genomic_fasta_files/anytaxon_concatenated_fasta_genomes
#       Concatenated individual genbank files      in     ../data/Individual_full_genbank_files/anytaxon_concatenated_genbank_genomes
#       Concatenated proteomic fasta files         in     ../data/Proteomic_fasta_files/anytaxon_concatenated_fasta_proteomes
# 
##########################################
#
#2_Concatenation_from_taxid.pl
#
##########################################
$familia = $ARGV[0]; # Reads first positional argument. Expected $ARGV[0] is anytaxon (e.g. Geminiviridae)
chomp ($familia);
##########################################
# Make temporary copies of input files in current folder
#     not optimal but prevents mishandling within a previous folder
system ("cp -r ../data/Genomic_fasta_files/$familia\_fasta_genomes .");
system ("cp -r ../data/Individual_full_genbank_files/$familia\_genbank_genomes .");
system ("cp -r ../data/Proteomic_fasta_files/$familia\_fasta_proteomes .");
##########################################
open (FILE, "../data/Raw_database/$familia.gb"); # Open anytaxon.gb file
$count = 0; # Variable for counting the number of manipulated files
##########################################
#Read file once to concatenate segmented files
while ($linea = <FILE>) {  # Reading line by line, defining variable $linea as current line
	chomp ($linea);
	#################################
	#Define source organism from "DEFINITION" line
	if ($linea =~ /^DEFINITION\s+/) {
		$organismo = $linea;
		#Remove undesired text and special character
		$organismo =~ s/DEFINITION\s+//;
		$organismo =~ s/\s+/-/g;
		$organismo =~ s/:/-/g;
		$organismo =~ s/;/-/g;
		$organismo =~ s/_/-/g;
		$organismo =~ s/\,//g;
		$organismo =~ s/\.//g; # Variable containing only organism name
	}
	################################
	#Recover accession identifier from "ACCESSION" line
	if ($linea =~ /^ACCESSION\s+/) {
		$accession = $linea;
		$accession =~ s/ACCESSION\s+//;
		$str = "$accession";
		$firtsaccession = ($str =~ m/\w+/g)[0]; # Retain only first accession
		#Remove undesired text and special characters
		$accession =~ s/\s+/_/g;
		$accession =~ s/\,//g;
		$accession =~ s/\.//g;
		$forname = "$accession"; # Variable to concatenate in outfile name
	}
	################################
	#Recover organism name from "ORGANISM" line
	if ($linea =~ /ORGANISM\s+/) {
		$source = $linea;
		$source =~ s/ORGANISM\s+//;
		#Remove undesired text and special characters
		$source =~ s/\s+/-/g;
		$source =~ s/:/-/g;
		$source =~ s/^-//g;
		$source =~ s/;/-/g;
		$source =~ s/_/-/g;
		$source =~ s/\,//g;
		$source =~ s/\.//g;
		$source =~ s/--/-/g;
		$source =~ s/\(//g;
		$source =~ s/\)//g;
		$source =~ s/\[//g;
		$source =~ s/\]//g;
		$source =~ s/\{//g;
		$source =~ s/\}//g;
		$source =~ s/\//-/g; # Variable containing source organism in desired format
	}
	################################
	#Recover taxid from db_xref in "source" field
        if ($linea =~ /\s+\/db_xref\="taxon/) {
                $TAXID = $linea; #Taxonomic ID defined as line next to dr_xref="taxon pattern
                #Remove undesired text and special characters
                $TAXID =~ s/\s+//;
		$TAXID =~ s/\/db_xref//;
		$TAXID =~ s/taxon//;
		$TAXID =~ s/://g;
		$TAXID =~ s/=//g;
		$TAXID =~ s/"//g; #Variable containing taxid in proper format
		$taxid = "taxid";
		$NombreOutput = "$organismo"."_"."$forname"."_"."$taxid"."_"."$TAXID"."_"."$fn"; #First unformated output file name
		########################################
		# Give proper format to output file name
		$NombreOutput =~ s/--/-/g;
		$NombreOutput =~ s/\(//g;
		$NombreOutput =~ s/\)//g;
		$NombreOutput =~ s/\[//g;
		$NombreOutput =~ s/\]//g;
		$NombreOutput =~ s/\{//g;
		$NombreOutput =~ s/\}//g;
		$NombreOutput =~ s/\//-/g;
		########################################
		########################################
		#
		# Here's the magic. Segmented files converge to the same $familia and $NombreOutput variables.
		#    Then, cat $familia\_fasta_genomes/$NombreOutput displays all files corresponding to a single segmented virus (or anytaxon)
		#
		# Following lines perform concatenation and removal of previously copied files
		#
		system ("cat $familia\_fasta_genomes/$NombreOutput* >> $familia\_fasta_genomes/$source\_$taxid\_$TAXID.fn");
		system ("rm $familia\_fasta_genomes/$NombreOutput*");
		system ("cat $familia\_genbank_genomes/$NombreOutput* >> $familia\_genbank_genomes/$source\_$taxid\_$TAXID.gbk");
		system ("rm $familia\_genbank_genomes/$NombreOutput*");
		system ("cat $familia\_fasta_proteomes/$NombreOutput* >> $familia\_fasta_proteomes/$source\_$taxid\_$TAXID.faa");
		system ("rm $familia\_fasta_proteomes/$NombreOutput*");
		########################################
		########################################
		$count += 1; # Variable $count sum up to the total number of original files	
	}	
}
close (FILE); #END OF FIRST FILE READ
####################################
#Show the number of original files versus the number after concatenation
print STDOUT ("\n$familia.gb generated $count individual files\nAfter concatenation the number of files reduced to ");
system ("ls $familia\_fasta_genomes/* | wc -l"); #Number of files after concatenation
print STDOUT ("\n... as the following report indicates\n\n\n");
open (OUT, ">>Cat_report"); # Create temporary report file
##########################################
#Read input file a second time to generate report
open (FILE, "../data/Raw_database/$familia.gb");
while ($linea = <FILE>) {
	chomp ($linea);
	#################################
	#Define source organism from "DEFINITION" line
	if ($linea =~ /^DEFINITION\s+/) {
		$organismo = $linea;
		$organismo =~ s/DEFINITION\s+//;
		$organismo =~ s/\s+/-/g;
		$organismo =~ s/:/-/g;
		$organismo =~ s/;/-/g;
		$organismo =~ s/_/-/g;
		$organismo =~ s/\,//g;
		$organismo =~ s/\.//g; # Variable containing only organism name
	}
	################################
	#Recover accession identifier from "ACCESSION" line
	if ($linea =~ /^ACCESSION\s+/) {
		$accession = $linea;
		$accession =~ s/ACCESSION\s+//;
		$str = "$accession";
		$firtsaccession = ($str =~ m/\w+/g)[0];
		$accession =~ s/\s+/_/g;
		$accession =~ s/\,//g;
		$accession =~ s/\.//g;
		$forname = "$accession";
	}
	################################
	#Recover organism name from "ORGANISM" line
	if ($linea =~ /ORGANISM\s+/) {
		$source = $linea;
		$source =~ s/ORGANISM\s+//;
		$source =~ s/\s+/-/g;
		$source =~ s/:/-/g;
		$source =~ s/^-//g;
		$source =~ s/;/-/g;
		$source =~ s/_/-/g;
		$source =~ s/\,//g;
		$source =~ s/\.//g;
		$source =~ s/--/-/g;
		$source =~ s/\(//g;
		$source =~ s/\)//g;
		$source =~ s/\[//g;
		$source =~ s/\]//g;
		$source =~ s/\{//g;
		$source =~ s/\}//g;
		$source =~ s/\//-/g;
	}
        ################################
	#Recover taxid from db_xref in "source" field
        if ($linea =~ /\s+\/db_xref\="taxon/) {
                $TAXID = $linea;
                $TAXID =~ s/\s+//;
		$TAXID =~ s/\/db_xref//;
		$TAXID =~ s/taxon//;
		$TAXID =~ s/://g;
		$TAXID =~ s/=//g;
		$TAXID =~ s/"//g; # Variable containing taxid
		$taxid = "taxid";
		$NombreOutput = "$organismo"."_"."$forname"."_"."$taxid"."_"."$TAXID"."_"."$fn";
		$NombreOutput =~ s/--/-/g;
		$NombreOutput =~ s/\(//g;
		$NombreOutput =~ s/\)//g;
		$NombreOutput =~ s/\[//g;
		$NombreOutput =~ s/\]//g;
		$NombreOutput =~ s/\{//g;
		$NombreOutput =~ s/\}//g;
		$NombreOutput =~ s/\//-/g;
		########################################
		########################################
		#
		# Here's the report magic. 
		# Since segments of the same virus converge to the same following string:
		#     "segments were concatenated into $source\_$taxid\_$TAXID \n"
		#
		# Then each "print OUT (" segments were concatenated into $source\_$taxid\_$TAXID \n");" 
		# is repeated n times, being n the number of segments from the same $source and $taxid 
		#
		print OUT (" segments were concatenated into $source\_$taxid\_$TAXID \n"); # Print convergent strings to Cat_report		
	}	
}
close (FILE); # Closes anytaxon.gb
close (OUT); # Closes Cat_report
system ("cat Cat_report | uniq -c | sort -r >> Cat_report2"); # Performs uniq -c to print each new filename and the number of segments it contains
####################################
# Build report
open (FILE, "Cat_report2"); # Opens Cat_report2 (File with new file names ordered by frequencies)
while ($linea = <FILE>) {
	chomp ($linea);
	$count = substr($linea, 0, index($linea, "s")); # Defines $count as the frequency of a new filename
	$count =~ s/\s+//g; # Removes undesired spaces
	############################
	# Ignore files that were not concatenated. Files made by a single segment
	if ($count != 1) { # All files with frequencies different to 1...
		print STDOUT ("$linea\n"); # ...are printed to stdout report
	}
}
####################################
# Redirecting outputs to desired labeled folders
system ("mv $familia\_fasta_genomes ../data/Genomic_fasta_files/$familia\_concatenated_fasta_genomes"); #Genomic concatenated
system ("mv $familia\_genbank_genomes ../data/Individual_full_genbank_files/$familia\_concatenated_genbank_genomes"); #Genbank concatenated
system ("mv $familia\_fasta_proteomes ../data/Proteomic_fasta_files/$familia\_concatenated_fasta_proteomes"); #Proteomic concatenated
system ("rm Cat_repor*"); #Remove temporary files





