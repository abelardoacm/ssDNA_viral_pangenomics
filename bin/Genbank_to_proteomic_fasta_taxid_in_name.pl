#!/usr/local/bin/perl

$archivo = $ARGV[0];
chomp ($archivo);
$carpeta = $archivo;
$carpeta =~ s/\.gb/_fasta_proteomes/g;
system ("mkdir -p ../data/Proteomic_fasta_files/$carpeta");
open (FILE, "../data/Raw_database/$archivo");
$numero = 0;
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
		$faa = ".faa";
	}

        if ($linea =~ /^ACCESSION\s+/) {
		#print "$linea\n";
		$accession = $linea;
		$accession =~ s/ACCESSION\s+//;
		$accession =~ s/\s+/_/g;
		$accession =~ s/\,//g;
		$accession =~ s/\.//g;
		$forname = "$accession";
	}
	
        if ($linea =~ /\s+\/db_xref\="taxon/) {
                $TAXID = $linea;
                $TAXID =~ s/\s+//;
		$TAXID =~ s/\/db_xref//;
		$TAXID =~ s/taxon//;
		$TAXID =~ s/://g;
		$TAXID =~ s/=//g;
		$TAXID =~ s/"//g;
		$taxid = "taxid";
		$NombreOutput = "$organismo"."_"."$forname"."_"."$taxid"."_"."$TAXID"."_"."$faa";
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
        
        if ($linea =~ /\s+\/protein_id\=/) {
                #print "$linea\n";
                $id = $linea;
                $id =~ s/\s+//;
		$id =~ s/\/protein_id=//;
		$id =~ s/"//g;
        }

        if ($linea =~ /\s+\/db_xref\=/) {
                #print "$linea\n";
                $ID = $linea;
                $ID =~ s/\s+//;
                $ID =~ s/\/db_xref=//;
                $ID =~ s/"//g;
        }

        if ($linea =~ /\s+\/db_xref\="GI/) {
                #print "$linea\n";
                $GI = $linea;
                $GI =~ s/\s+//;
                $GI =~ s/\/db_xref\="GI//;
                $GI =~ s/"//g;
		$G = "GI";
		$conc = $G.$GI;
	}

        if ($linea =~ /\s+\/locus_tag\=/) {
                #print "$linea\n";
                $locus = $linea;
                $locus =~ s/\s+//;
                $locus =~ s/\/locus_tag\=//;
                $locus =~ s/"//g;
		$l = "locus-";
                $con = $l.$locus;

        }

	if ($linea =~ /\s+\/product\=/) {
		#print "$linea\n";
		$proteina = $linea;
		$proteina =~ s/\s+\/product\=//;
		$proteina =~ s/"//g;
	}
	if ($linea =~ /\s+\/translation\=/) {
		#print "$linea\n";
		$numero = 1;
		print OUT ">$id | $ID | $conc | $con | $proteina\n";
		#>gi|15617167|ref|NP_240380.1| 50S ribosomal protein L31 [Buchnera aphidicola str. APS (Acyrthosiphon pisum)]
		#>YP_007974221.1|GeneID-15486949|GI-498907898|locus-L677_gp1|protein_AV2-protein_|
	}
	if ($linea =~ /\s+gene\s+/ || $linea =~ /^ORIGIN/ || $linea =~ /\s+CDS\s+/ || $linea =~ /\s+polyA_site\s+/ || $linea =~ /\s+repeat_region\s+/ || $linea =~ /\s+polyA_signal\s+/ || $linea =~ /\s+rep_origen\s+/ || $linea =~ /\s+promoter\s+/ || $linea =~ /\s+sig_peptide\s+/ || $linea =~ /\s+misc_feature\s+/ || $linea =~ /\s+5'UTR\s+/) {
		$numero = 0;
		#close (OUT);
		#system ("mv $organismo /mnt/c/users/us/downloads/Sequences/A$nombre/");

	}
        if ($linea =~ /\s+stem_loop\s+/ || $linea =~ /\s+3'UTR\s+/ || $linea =~ /\s+CDS\s+complement/ || $linea =~ /\s+regulatory\s+/ || $linea =~ /\/product\=/ || $linea =~ /\s+intron\s+/ || $linea =~ /\s+unsure\s+/ ||  $linea =~ /\/gene\=/ || $linea =~ /\s+tRNA\s+/ || $linea =~ /\s+exon\s+/ || $linea =~ /\s+ncRNA\s+/ || $linea =~ /\s+variation\s+/ || $linea =~ /\TATA_signal\s+/ || $linea =~ /\/locus_tag\=/ || $linea =~ /\/note\=/) {
                $numero = 0;


	}
 	if ($linea =~ /\s+STS\s+/ || $linea =~ /\/standard_name\=/ || $linea =~ /mat_peptide/ || $linea =~ /\/db_xref\=/ || $linea =~ /\s+rep_origin\s+/ || $linea =~ /\s+misc_recomb\s+/ || $linea =~ /\s+protein_bind\s+/ ) {  
		 $numero = 0;

 	}

	if ($numero == 1) {
		$linea =~ s/\s+//;
		$linea =~ s/\/translation\=//;
		$linea =~ s/"//g;
		print OUT "$linea\n";

	}
}
close (FILE);
system ("mv *.faa ../data/Proteomic_fasta_files/$carpeta");
