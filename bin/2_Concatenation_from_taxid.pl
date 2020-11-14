#!/usr/local/bin/perl

$familia = $ARGV[0];
chomp ($familia);
system ("cp -r ../data/Genomic_fasta_files/$familia\_fasta_genomes .");
system ("cp -r ../data/Individual_full_genbank_files/$familia\_genbank_genomes .");
system ("cp -r ../data/Proteomic_fasta_files/$familia\_fasta_proteomes .");
open (FILE, "../data/Raw_database/$familia.gb");
$count = 0;
while ($linea = <FILE>) {
	chomp ($linea);
	if ($linea =~ /^DEFINITION\s+/) {
		$organismo = $linea;
		$organismo =~ s/DEFINITION\s+//;
		$organismo =~ s/\s+/-/g;
		$organismo =~ s/:/-/g;
		$organismo =~ s/;/-/g;
		$organismo =~ s/_/-/g;
		$organismo =~ s/\,//g;
		$organismo =~ s/\.//g;
	}
	
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

        if ($linea =~ /\s+\/db_xref\="taxon/) {
                #/db_xref="taxon:???"
                $TAXID = $linea;
                $TAXID =~ s/\s+//;
		$TAXID =~ s/\/db_xref//;
		$TAXID =~ s/taxon//;
		$TAXID =~ s/://g;
		$TAXID =~ s/=//g;
		$TAXID =~ s/"//g;
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
		system ("cat $familia\_fasta_genomes/$NombreOutput* >> $familia\_fasta_genomes/$source\_$taxid\_$TAXID.fn");
		system ("rm $familia\_fasta_genomes/$NombreOutput*");
		system ("cat $familia\_genbank_genomes/$NombreOutput* >> $familia\_genbank_genomes/$source\_$taxid\_$TAXID.gbk");
		system ("rm $familia\_genbank_genomes/$NombreOutput*");
		system ("cat $familia\_fasta_proteomes/$NombreOutput* >> $familia\_fasta_proteomes/$source\_$taxid\_$TAXID.faa");
		system ("rm $familia\_fasta_proteomes/$NombreOutput*");
		$count += 1;			
	}	
}


close (FILE);
print STDOUT ("\n$familia.gb generated $count individual files\nAfter concatenation the number of files reduced to ");
system ("ls $familia\_fasta_genomes/* | wc -l");
print STDOUT ("\n... as the following report indicates\n\n\n");
open (OUT, ">>Cat_report");
open (FILE, "../data/Raw_database/$familia.gb");
while ($linea = <FILE>) {
	chomp ($linea);
	if ($linea =~ /^DEFINITION\s+/) {
		$organismo = $linea;
		$organismo =~ s/DEFINITION\s+//;
		$organismo =~ s/\s+/-/g;
		$organismo =~ s/:/-/g;
		$organismo =~ s/;/-/g;
		$organismo =~ s/_/-/g;
		$organismo =~ s/\,//g;
		$organismo =~ s/\.//g;
	}
	
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

        if ($linea =~ /\s+\/db_xref\="taxon/) {
                #/db_xref="taxon:???"
                $TAXID = $linea;
                $TAXID =~ s/\s+//;
		$TAXID =~ s/\/db_xref//;
		$TAXID =~ s/taxon//;
		$TAXID =~ s/://g;
		$TAXID =~ s/=//g;
		$TAXID =~ s/"//g;
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
		print OUT (" segments were concatenated into $source\_$taxid\_$TAXID \n");		
	}	
}


close (FILE);
close (OUT);
system ("cat Cat_report | uniq -c | sort -r >> Cat_report2");

open (FILE, "Cat_report2");
while ($linea = <FILE>) {
	chomp ($linea);
	$count = substr($linea, 0, index($linea, "s"));
	$count =~ s/\s+//g;
	if ($count != 1) {
		print STDOUT ("$linea\n");
	}
}

system ("mv $familia\_fasta_genomes ../data/Genomic_fasta_files/$familia\_concatenated_fasta_genomes");
system ("mv $familia\_genbank_genomes ../data/Individual_full_genbank_files/$familia\_concatenated_genbank_genomes");
system ("mv $familia\_fasta_proteomes ../data/Proteomic_fasta_files/$familia\_concatenated_fasta_proteomes");
system ("rm Cat_repor*");

#The family.gb file invoked must not be modified since the usage of 1_Set_family_files_from_raw_genbank.sh.
#This script must be called from command line as perl Concatenation_from_taxid.pl Geminiviridae
#I've already checked manually that the output names for .fn, .faa and .gbk files only differ by extensions. 


