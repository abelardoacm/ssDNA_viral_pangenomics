#!/usr/local/bin/perl

$archivo = $ARGV[0];
chomp ($archivo);
$carpeta = $archivo;
$carpeta =~ s/\.gb/_fasta_genomes/g;
system ("mkdir ../data/Genomic_fasta_files/$carpeta");
open (FILE, "../data/Raw_database/$archivo");
$numero = 0;
while ($linea = <FILE>) {
	chomp ($linea);
	if ($linea =~ /^DEFINITION\s+/) {
		#print "$linea\n";
		$organismo = $linea;
		$organismo =~ s/DEFINITION\s+//;
		$organismo =~ s/\s+/_/g;
		$organismo =~ s/\,//g;
		$organismo =~ s/\.//g;
		$fn = ".fn";
	}
	
	if ($linea =~ /^ACCESSION\s+/) {
		#print "$linea\n";
		$accession = $linea;
		$accession =~ s/ACCESSION\s+//;
		$accession =~ s/\s+/_/g;
		$accession =~ s/\,//g;
		$accession =~ s/\.//g;
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
		$taxid = "_taxid_";
		$NombreOutput = "$organismo"."$taxid"."$TAXID"."$fn";
		$FastaHeader = "$organismo"."$taxid"."$TAXID";
	}
	
	if ($linea =~ /^ORIGIN\s+/) {
		open (OUT, ">>$NombreOutput");
		$numero = 1;
		print ">$FastaHeader\n";
		print OUT ">$FastaHeader";
	}
	
	if ($linea =~ /^\/\/+/) {
		$numero = 0;
		#close (OUT);
		#system ("mv $organismo /mnt/c/users/us/downloads/Sequences/A$nombre/");

	}

	if ($numero == 1) {
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
		print "$linea\n";
		print OUT "$linea\n";

	}
}
close (FILE);
#system ("mv *.faa /mnt/c/users/us/downloads/Sequences/$concatenado");
system ("mv *.fn ../data/Genomic_fasta_files/$carpeta");
