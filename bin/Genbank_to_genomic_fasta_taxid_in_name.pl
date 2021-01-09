#!/usr/local/bin/perl
#Genbank_to_genomic_fasta_taxid_in_name.pl
#
#Author: Abelardo Aguilar Camara
#
#Task performed:
#    This script opens a file of concatenated full genbank files
#    and reads line by line to write a fasta file for each entry,
#    named as the source organism + its taxid.
#
#INPUT: Concatenated full genbanks of anytaxon in ../data/Raw_database/anytaxon.gb (g.e. Geminiviridae.gb)
#
#OUTPUT: Multiple fasta nucleotide files (*.fn) in ../data/Genomic_fasta_files/anytaxon_fasta_genomes/ (g.e. Geminiviridae_fasta_genomes/ )
#
##########################################
#
#Genbank_to_genomic_fasta_taxid_in_name.pl
#
##########################################
#Reach input file, create outdir
$archivo = $ARGV[0]; # Reads first positional argument. Expected $ARGV[0] is anytaxon.gb
chomp ($archivo); # Removes trailing endlines
$carpeta = $archivo;
$carpeta =~ s/\.gb/_fasta_genomes/g;
system ("mkdir -p ../data/Genomic_fasta_files/$carpeta"); # Makes output folder
open (FILE, "../data/Raw_database/$archivo"); #Opens input
##########################################
#Read input file line by line
$numero = 0; #Variable to indicate favorable (1) or absent (0) condition, when a line is part of nucleotide sequence
while ($linea = <FILE>) { #Displays file until end
	chomp ($linea);
	#################################
	#Define source organism from "DEFINITION" line
	if ($linea =~ /^DEFINITION\s+/) {
		$organismo = $linea; #Organism name equals DEFINITION line
		#Remove undesired text and special characters
		$organismo =~ s/DEFINITION\s+//;
		$organismo =~ s/\s+/-/g;
		$organismo =~ s/:/-/g;
		$organismo =~ s/;/-/g;
		$organismo =~ s/_/-/g;
		$organismo =~ s/\,//g;
		$organismo =~ s/\.//g;
		$fn = ".fn"; #Defines file extension
	}
	#################################
	#Recover accession identifier from "ACCESSION" line
	if ($linea =~ /^ACCESSION\s+/) {
		$accession = $linea; #Accession equals ACCESSION line
		#Remove undesired text and special characters
		$accession =~ s/ACCESSION\s+//;
		$accession =~ s/\s+/_/g;
		$accession =~ s/\,//g;
		$accession =~ s/\.//g;
		$forname = "$accession"; #Variable to concatenate in header
	}
	#################################
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
		$taxid = "taxid"; #Variable to concatenate in header
		#########################
		#Define and give format to individual output name
		$NombreOutput = "$organismo"."_"."$forname"."_"."$taxid"."_"."$TAXID"."_"."$fn";
		$NombreOutput =~ s/--/-/g;
		$NombreOutput =~ s/\(//g;
		$NombreOutput =~ s/\)//g;
		$NombreOutput =~ s/\[//g;
		$NombreOutput =~ s/\]//g;
		$NombreOutput =~ s/\{//g;
		$NombreOutput =~ s/\}//g;
		$NombreOutput =~ s/\//-/g;
		#########################
		#Define and give format to unique fasta header
		$FastaHeader = "$organismo"."|"."$forname"."|"."$taxid"."_"."$TAXID"."|";
		$FastaHeader =~ s/--/-/g;
		$FastaHeader =~ s/\(//g;
		$FastaHeader =~ s/\)//g;
		$FastaHeader =~ s/\[//g;
		$FastaHeader =~ s/\]//g;
		$FastaHeader =~ s/\{//g;
		$FastaHeader =~ s/\}//g;
	}
	#################################
	#Creates output fasta file when nucleotides sequence begins
	if ($linea =~ /^ORIGIN\s+/) {
		open (OUT, ">>$NombreOutput");
		$numero = 1; #Conditional variable is set to 1 when nucleotides sequence is available for entry
		print OUT ">$FastaHeader"; #Begin individual fasta file with built header
	}
	#################################
	#When nucleotide sequence ends, set condition to 0 (stop writing to individual outfile)
	if ($linea =~ /^\/\/+/) {
		$numero = 0;
		#possible "close (OUT);" line to close outfile
	}
	#################################
	#If line corresponds to nucleotides, then write to outfile
	if ($numero == 1) {
		#Remove undesired text and numbers
		$linea =~ s/\s+//g;
		$linea =~ s/ORIGIN//;
		$linea =~ s/0//g;
		$linea =~ s/1//g;
		$linea =~ s/2//g;
		$linea =~ s/3//g;
		$linea =~ s/4//g;
		$linea =~ s/5//g;
		$linea =~ s/6//g;
		$linea =~ s/7//g;
		$linea =~ s/8//g;
		$linea =~ s/9//g;
		$linea =~ s/"//g;
		print OUT "$linea\n"; #Here $line is a nucleotide string ready to be written in outfile
	} #END OF INDIVIDUAL ENTRY
} #END OF CONCATENATED GENBANK
close (FILE); #Close output at input end
system ("mv *.fn ../data/Genomic_fasta_files/$carpeta"); #Redirect individual fasta files to proper location
