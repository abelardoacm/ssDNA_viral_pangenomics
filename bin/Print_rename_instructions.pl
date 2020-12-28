#!/usr/local/bin/perl

$archivo = $ARGV[0];
chomp ($archivo);
$carpeta = $archivo;
$carpeta =~ s/\.gb/_genbank_genomes/g;
system ("mkdir -p ../data/Individual_full_genbank_files/$carpeta");
open (FILE, "../data/Raw_database/$archivo");
open (OUT, ">>rename_rules.txt");
$count = 0;
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
		$count += 1;
	}	
}
close (FILE);
print STDOUT ("\nThe file $archivo was splitted into $count individual genomic(.fn), proteomic(.faa) and full-genbank(.gbk) files\n\n ");
system ("cp ../data/Raw_database/$archivo .");
print STDOUT ("\nMessages similar to \"Warning: bad /collection_date value\" point out that the date in the file is not in the correct format.\nSuch cases can be corrected although it is not needed to continue.\n\n\n");
system ("seqretsplit -sequence $archivo -outseq seqoutall -feature -osformat genbank");


