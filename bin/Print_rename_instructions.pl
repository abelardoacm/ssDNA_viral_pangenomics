#!/usr/local/bin/perl
#Print_rename_instructions.pl
#
#Author: Abelardo Aguilar Camara
#
#Tasks performed:
#
#    This script makes use of emboss package, seqretsplit command to
#    split anytaxon.gb into individual genbank files.
#
#    This script opens a file of concatenated full genbank files
#    and reads line by line to rename an emboss output to match 
#    name assignation by other scripts in this repo.
#
#
#NOTE: Print_rename_instructions is meant to be used by 1_Set_family_files_from_raw_genbank.sh
#
#      This script depends on a functional emboss install, particularly on the command seqretsplit
#
#      It splits anytaxon.gb but only prints the instructions to rename output without execution
#
#
#
#INPUT: Concatenated full genbanks of anytaxon in ../data/Raw_database/anytaxon.gb (e.g. Geminiviridae.gb)
#
#OUTPUT:   Multiple individual full genbank files (*.gbk) in current folder.
#          rename_rules.txt. *Althought user is not supposed to see it. 
#
#
#
##########################################
#
#Print_rename_instructions.pl
#
##########################################
#Reach input file, create outdir
$archivo = $ARGV[0]; # Reads first positional argument. Expected $ARGV[0] is anytaxon.gb
chomp ($archivo); # Removes trailing endlines
$carpeta = $archivo;
$carpeta =~ s/\.gb/_genbank_genomes/g;
system ("mkdir -p ../data/Individual_full_genbank_files/$carpeta"); # Makes output folder
open (FILE, "../data/Raw_database/$archivo"); # Opens input
open (OUT, ">>rename_rules.txt"); # Starts output file
$count = 0; # Variable to stdout report
##########################################
#Read input file line by line
while ($linea = <FILE>) {
	chomp ($linea);
	#################################
	#Define source organism from "DEFINITION" line
	if ($linea =~ /^DEFINITION\s+/) {
		$organismo = $linea; #Organism name equals DEFINITION line
		#Remove undesired text and special character
		$organismo =~ s/DEFINITION\s+//;
		$organismo =~ s/\s+/-/g;
		$organismo =~ s/:/-/g;
		$organismo =~ s/;/-/g;
		$organismo =~ s/_/-/g;
		$organismo =~ s/\,//g;
		$organismo =~ s/\.//g;
		$gbk = ".gbk"; # File extension for genbank files
	}
	################################
	#Recover accession identifier from "ACCESSION" line
	if ($linea =~ /^ACCESSION\s+/) { #if line begins with "ACCESSION"
		$accession = $linea;
		$accession =~ s/ACCESSION\s+//;
		$str = "$accession";
		$firtsaccession = ($str =~ m/\w+/g)[0]; # Regex to take only first accession
		$accession =~ s/\s+/_/g; #Removes spaces
		$accession =~ s/\,//g; #Removes commas
		$accession =~ s/\.//g; #Removes dots
		$forname = "$accession"; #Variable to concatenate in new name
	}
	################################
	#Recover taxid from db_xref in source field
        if ($linea =~ /\s+\/db_xref\="taxon/) {
                $TAXID = $linea; #Taxonomic ID defined as line next to dr_xref pattern
                #Remove undesired text and special characters
                $TAXID =~ s/\s+//;
		$TAXID =~ s/\/db_xref//;
		$TAXID =~ s/taxon//;
		$TAXID =~ s/://g;
		$TAXID =~ s/=//g;
		$TAXID =~ s/"//g;
		$taxid = "taxid";
		########################
		#Build output name in $NombreOutput
		$NombreOutput = "$organismo"."_"."$forname"."_"."$taxid"."_"."$TAXID"."_"."$fn";
		$NombreOutput =~ s/--/-/g;
		$NombreOutput =~ s/\(//g;
		$NombreOutput =~ s/\)//g;
		$NombreOutput =~ s/\[//g;
		$NombreOutput =~ s/\]//g;
		$NombreOutput =~ s/\{//g;
		$NombreOutput =~ s/\}//g; 
		$NombreOutput =~ s/\//-/g; #New name with proper format up to this line inside $NombreOutput
		$newname = "$NombreOutput.gbk"; #New Filename
		$old = lc($firtsaccession); #Convert to lowercase
		$oldname = "$old".".genbank"; #Previous name to be replaced by $newname
		print OUT "$oldname $newname\n"; #Entry line in list of rename rules
		$count += 1; #Sums one to count of files to be renamed
	} #END OF INDIVIDUAL ENTRY
} #END OF CONCATENATED GENBANK
close (FILE); #Close file
########################################
#STDOUT REPORT
print STDOUT ("\nThe file $archivo was splitted into $count individual genomic(.fn), proteomic(.faa) and full-genbank(.gbk) files\n\n "); #Out count message
system ("cp ../data/Raw_database/$archivo ."); #Copy anytaxon.gb to bin folder (current)
print STDOUT ("\nMessages similar to \"Warning: bad /collection_date value\" point out that the date in the file is not in the correct format.\nSuch cases can be corrected although it is not needed to continue.\n They come from seqretsplit -sequence $archivo -outseq seqoutall -feature -osformat genbank\n\n\n" ); # Explain stdout error message
########################################
#Use emboss to split files
system ("seqretsplit -sequence $archivo -outseq seqoutall -feature -osformat genbank"); # Performs emboss seqretsplit with anytaxon.gb file
