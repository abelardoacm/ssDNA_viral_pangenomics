#!/usr/local/bin/perl
#Genbank_to_proteomic_fasta_taxid_in_name.pl
#
#Author: Abelardo Aguilar Camara
#
#Task performed:
#    This script opens a file of concatenated full genbank files
#    and reads line by line to write a fasta proteomic file for 
#    each entry, named as the source organism + its taxid.
#
#INPUT: Concatenated full genbanks of anytaxon in ../data/Raw_database/anytaxon.gb (e.g. Geminiviridae.gb)
#
#OUTPUT: Multiple fasta aminoacid proteomic files (*.faa) in ../data/Proteomic_fasta_files/anytaxon_fasta_proteomes/ 
#        (e.g. Geminiviridae_fasta_proteomes/ )
#
#
#
##########################################
#
#Genbank_to_proteomic_fasta_taxid_in_name.pl
#
##########################################
#Reach input file, create outdir
$archivo = $ARGV[0]; # Reads first positional argument. Expected $ARGV[0] is anytaxon.gb
chomp ($archivo); # Removes trailing endlines
$carpeta = $archivo;
$carpeta =~ s/\.gb/_fasta_proteomes/g;
system ("mkdir -p ../data/Proteomic_fasta_files/$carpeta"); # Makes output folder
open (FILE, "../data/Raw_database/$archivo"); # Opens input
##########################################
#Read input file line by line
$numero = 0; #Variable to indicate favorable (1) or absent (0) condition, when a line is part of aminoacid sequence
while ($linea = <FILE>) { #Read by line until end of file, defines $linea variable as the current line
	chomp ($linea);
	#################################
	#Define source organism from "DEFINITION" line
	if ($linea =~ /^DEFINITION\s+/) {
		$organismo = $linea;#Organism name equals DEFINITION line
		#Remove undesired text and special character
		$organismo =~ s/DEFINITION\s+//;
		$organismo =~ s/\s+/-/g;
		$organismo =~ s/:/-/g;
		$organismo =~ s/;/-/g;
		$organismo =~ s/_/-/g;
		$organismo =~ s/\,//g;
		$organismo =~ s/\.//g;
		$faa = ".faa"; #Fasta aminoacids file extension
	}
	################################
	#Recover accession identifier from "ACCESSION" line
        if ($linea =~ /^ACCESSION\s+/) {
		$accession = $linea; #Accession equals ACCESSION line
		#Remove undesired text and special characters
		$accession =~ s/ACCESSION\s+//;
		$accession =~ s/\s+/_/g;
		$accession =~ s/\,//g;
		$accession =~ s/\.//g;
		$forname = "$accession"; #Variable to write in fasta header
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
		$taxid = "taxid"; #Variable to concatenate in header
		#########################
		#Define and give proper format to individual output name
		$NombreOutput = "$organismo"."_"."$forname"."_"."$taxid"."_"."$TAXID"."_"."$faa";
		#Remove spaces and undesired text
		$NombreOutput =~ s/--/-/g;
		$NombreOutput =~ s/\(//g;
		$NombreOutput =~ s/\)//g;
		$NombreOutput =~ s/\[//g;
		$NombreOutput =~ s/\]//g;
		$NombreOutput =~ s/\{//g;
		$NombreOutput =~ s/\}//g;
		$NombreOutput =~ s/\//-/g;
		open (OUT, ">>$NombreOutput");
        }  
        #################################
        #Save protein_id to variable $id
        if ($linea =~ /\s+\/protein_id\=/) { #when pattern "protein_id" is found...
                $id = $linea;
                $id =~ s/\s+//; # Removes spaces
		$id =~ s/\/protein_id=//; # Removes tag
		$id =~ s/"//g; #Variable containing only protein_id
        }
        #################################
        #Save taxid to variable $ID
        if ($linea =~ /\s+\/db_xref\=/) { #when pattern "db_xref" is found...
                $ID = $linea;
                $ID =~ s/\s+//; # Removes spaces
                $ID =~ s/\/db_xref=//; # Removes tag
                $ID =~ s/"//g; # Variable containing only taxonomic id
        }
        #################################
        #Save GI to variable $GI
        if ($linea =~ /\s+\/db_xref\="GI/) { #when pattern "db_xref="GI" is found...
                $GI = $linea;
                #Remove spaces and undesired text
                $GI =~ s/\s+//;
                $GI =~ s/\/db_xref\="GI//;
                $GI =~ s/"//g;
		$G = "GI";
		$conc = $G.$GI; #Variable to concatenate in protein fasta header
	}
	#################################
        #Save locus_tag to variable $locus
        if ($linea =~ /\s+\/locus_tag\=/) { #when pattern "db_xref="GI" is found...
                $locus = $linea;
                #Remove spaces and undesired text
                $locus =~ s/\s+//;
                $locus =~ s/\/locus_tag\=//;
                $locus =~ s/"//g;
		$l = "locus-";
                $con = $l.$locus; #Variable to concatenate in protein fasta header
        }
        #################################
        #Save protein name to variable $proteina
	if ($linea =~ /\s+\/product\=/) { #when pattern "db_xref="GI" is found...
		$proteina = $linea;
		#Remove spaces and undesired text
		$proteina =~ s/\s+\/product\=//;
		$proteina =~ s/"//g;
	}
	#################################
	#Write fasta header of protein
	if ($linea =~ /\s+\/translation\=/) { #If $linea contains "translation" tag, recover lines corresponding to the aminoacid sequence of a protein
		$numero = 1; #Line meets condition of being part of aminacids sequence
		print OUT ">$id | $ID | $conc | $con | $proteina\n"; # Write fasta header of protein
		#EXAMPLE: >YP_007974221.1|GeneID-15486949|GI-498907898|locus-L677_gp1|protein_AV2-protein_|
	}
	#################################
	#Line is not part of proteomic fasta when...
	#Lines to ignore (1st set)
	if ($linea =~ /\s+gene\s+/ || $linea =~ /^ORIGIN/ || $linea =~ /\s+CDS\s+/ || $linea =~ /\s+polyA_site\s+/ || $linea =~ /\s+repeat_region\s+/ || $linea =~ /\s+polyA_signal\s+/ || $linea =~ /\s+rep_origen\s+/ || $linea =~ /\s+promoter\s+/ || $linea =~ /\s+sig_peptide\s+/ || $linea =~ /\s+misc_feature\s+/ || $linea =~ /\s+5'UTR\s+/) {
		$numero = 0; # Line does not correspond to aminoacids sequence, condition variable set to 0.
	}
	#Lines to ignore (2nd set)
        if ($linea =~ /\s+stem_loop\s+/ || $linea =~ /\s+3'UTR\s+/ || $linea =~ /\s+CDS\s+complement/ || $linea =~ /\s+regulatory\s+/ || $linea =~ /\/product\=/ || $linea =~ /\s+intron\s+/ || $linea =~ /\s+unsure\s+/ ||  $linea =~ /\/gene\=/ || $linea =~ /\s+tRNA\s+/ || $linea =~ /\s+exon\s+/ || $linea =~ /\s+ncRNA\s+/ || $linea =~ /\s+variation\s+/ || $linea =~ /\TATA_signal\s+/ || $linea =~ /\/locus_tag\=/ || $linea =~ /\/note\=/) {
                $numero = 0;
	}
	#Lines to ignore (3rd set)
 	if ($linea =~ /\s+STS\s+/ || $linea =~ /\/standard_name\=/ || $linea =~ /mat_peptide/ || $linea =~ /\/db_xref\=/ || $linea =~ /\s+rep_origin\s+/ || $linea =~ /\s+misc_recomb\s+/ || $linea =~ /\s+protein_bind\s+/ ) {  
		 $numero = 0;
 	}
 	#################################
 	#Line is part of proteomic fasta file when...
	if ($numero == 1) { #Variable $linea contains "translation" tag
		#Remove undesired spaces and text
		$linea =~ s/\s+//;
		$linea =~ s/\/translation\=//;
		$linea =~ s/"//g;
		print OUT "$linea\n"; #Print line in proteomic fasta file
	} #END OF INDIVIDUAL ENTRY
} #END OF CONCATENATED GENBANK
close (FILE); #Close output at input end
system ("mv *.faa ../data/Proteomic_fasta_files/$carpeta"); #Redirect individual fasta proteomes to proper location
