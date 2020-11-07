#!/usr/local/bin/perl
#The family.gb file invoked must not be modified since the usage of 1_Set_family_files_from_raw_genbank.sh.
#This script must be called from command line as perl Concatenation_from_taxid.pl Geminiviridae.gb
#I've already checked manually that the output names for .fn, .faa and .gbk files only differ by extensions. 

$archivo = $ARGV[0];
chomp ($archivo);
open (FILE, "../data/Raw_database/$archivo");
open (OUT, ">>Concatenation_instructions_taxid.sh");
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
		print OUT "cat $NombreOutput* >> $source\_$taxid\_$TAXID\$1\n";
	}	
}
close (FILE);

