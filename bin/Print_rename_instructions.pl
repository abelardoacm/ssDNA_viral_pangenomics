#!/usr/local/bin/perl

$archivo = $ARGV[0];
chomp ($archivo);
$carpeta = $archivo;
$carpeta =~ s/\.gb/_genbank_genomes/g;
system ("mkdir ../data/Individual_full_genbank_files/$carpeta");
open (FILE, "../data/Raw_database/$archivo");
open (OUT, ">>rename_rules.txt");
while ($linea = <FILE>) {
	chomp ($linea);
	if ($linea =~ /^DEFINITION\s+/) {
		#print "$linea\n";
		$organismo = $linea;
		$organismo =~ s/DEFINITION\s+//;
		$organismo =~ s/\s+/-/g;
		$organismo =~ s/:/-/g;
		$organismo =~ s/;/-/g;
		$organismo =~ s/_/-/g;
		$organismo =~ s/\,//g;
		$organismo =~ s/\.//g;
		$gbk = ".gbk";
	}
	
	if ($linea =~ /^ACCESSION\s+/) {
		#print "$linea\n";
		$accession = $linea;
		$accession =~ s/ACCESSION\s+//;
		#AQUI DEBERIA IR EL CODIGO PARA TOMAR SOLO EL PRIMER ACCESSION
		$str = "$accession";
		$firtsaccession = ($str =~ m/\w+/g)[0];
		#SI NO SIRVE BORRA DE AQUI PARA ATRAS
		$accession =~ s/\s+/_/g;
		$accession =~ s/\,//g;
		$accession =~ s/\.//g;
		$forname = "$accession";
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
		#Nueva linea debajo necesaria para otros dos scripts de perl tambien
		$NombreOutput =~ s/\//-/g;
		$newname = "$NombreOutput.gbk";
		#Otro cambio aqui nuevo por si falla a la goma
		$old = lc($firtsaccession);
		$oldname = "$old".".genbank";
		print OUT "$oldname $newname\n";
	}	
}
close (FILE);
system ("cp ../data/Raw_database/$archivo .");
system ("seqretsplit -sequence $archivo -outseq seqoutall -feature -osformat genbank");
#system ("mv *.genbank ../data/Individual_full_genbank_files/$carpeta");
#rename_rules.txt still has to be moved

