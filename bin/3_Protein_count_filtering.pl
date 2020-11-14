#!/usr/local/bin/perl

#This section generates the protein_count list for the family proteomic files
#The first positional argument corresponds to the family.
$familia = $ARGV[0];
$carpetafamilia = "$familia"."_fasta_proteomes";
use POSIX;
system ("cp -r ../data/Genomic_fasta_files/$familia\_concatenated_fasta_genomes .");
system ("cp -r ../data/Individual_full_genbank_files/$familia\_concatenated_genbank_genomes .");
system ("cp -r ../data/Proteomic_fasta_files/$familia\_concatenated_fasta_proteomes .");
system ("mv $familia\_concatenated_fasta_genomes $familia\_catfiltered_fasta_genomes ");
system ("mv $familia\_concatenated_genbank_genomes $familia\_catfiltered_genbank_genomes");
system ("mv $familia\_concatenated_fasta_proteomes $familia\_catfiltered_fasta_proteomes");
system ("grep -c \">\" $familia\_catfiltered_fasta_proteomes/* > PROTEIN_COUNT_$familia");

open (FILE, "PROTEIN_COUNT_$familia");
$numero_proteomas = 0;
$suma_conteo = 0;

#Once the protein_count_famil file is opened, limit values are set
while ($linea = <FILE>) {
	chomp ($linea);
	my ( $count ) = $linea=~ /(\:.*)\s*$/;
	$count =~ s/://g;
	$suma_conteo += $count;
	$numero_proteomas += 1;	
}


#The second positional argument corresponds to the allowed percentage of difference from the mean count

$percdiff = $ARGV[1];
$diff = $percdiff / 100;
$promedio_conteo = ceil($suma_conteo / $numero_proteomas);
$intervalo = $promedio_conteo * $diff;
$maxcalc = ceil($promedio_conteo + $intervalo);
$mincalc = ceil($promedio_conteo - $intervalo);


#The third and fourth positional argument correspond to the minimum and maximum protein count for reference strains. Such info can be easily obtained from Viralzone.
#This section down makes sure that calculated limits are not strict enough to filter reference proteomes.
$minref = $ARGV[2];
$maxref = $ARGV[3];

if ($minref == 0) {
	$minref = $mincalc;
	print STDOUT "\nNo minimum protein count from reference proteome was given... setting lower limit to -\%$percdiff deviation from the mean \n";
}

if ($maxref == 0) {
	$maxref = $maxcalc;
	print STDOUT "\nNo maximum protein count from reference proteome was given... setting upper limit to +\%$percdiff deviation from the mean \n\n";
}

print STDOUT "\nmean protein count is $promedio_conteo (rounded-up) \n\n";

if ($minref < $mincalc) {
	$lim_inferior = $minref;
	print STDOUT "Minimum protein count from reference strain is lower than -\%$percdiff cutoff value... setting lower limit to $minref proteins \n";
}else{
	$lim_inferior = $mincalc;
	print STDOUT "... setting lower protein cutoff count in $lim_inferior proteins \n";
}


if ($maxref > $maxcalc) {
	$lim_superior = $maxref;
	print STDOUT "Maximum protein count from reference strain is bigger than +\%$percdiff cutoff value... setting upper limit to $maxref proteins \n\n";
}else{
	$lim_superior = $maxcalc;
	print STDOUT "... setting upper protein cutoff count in $lim_superior proteins \n\n";
}


$eliminated_count = 0;

open (FILE, "PROTEIN_COUNT_$familia");
while ($linea = <FILE>) {
	chomp ($linea);
	my ( $count ) = $linea=~ /(\:.*)\s*$/;
	$count =~ s/://g;
	if ($count > $lim_superior || $count < $lim_inferior ) {
		my $rejected_file = substr($linea, 0, index($linea, ":"));
		my $rejwithoutextension = substr($rejected_file, 0, index($linea, "."));
		my $pathtofile = "$familia\_catfiltered_fasta_proteomes/";
		$rejwithoutpath = $rejwithoutextension;
		$rejwithoutpath =~ s/$pathtofile//g;
		print STDOUT "$rejwithoutpath will be filtered as protein count is $count \n";
		$eliminated_count += 1;
		system ("rm $familia\_catfiltered_fasta_genomes/$rejwithoutpath*");
		system ("rm $familia\_catfiltered_genbank_genomes/$rejwithoutpath*");
		system ("rm $familia\_catfiltered_fasta_proteomes/$rejwithoutpath*");
	}
}
print STDOUT ("\n$eliminated_count organisms were discarded from the database for further analysis\n");
system ("rm PROTEIN_COUNT_$familia");
system ("mv $familia\_catfiltered_fasta_genomes ../data/Genomic_fasta_files/");
system ("mv $familia\_catfiltered_genbank_genomes ../data/Individual_full_genbank_files/");
system ("mv $familia\_catfiltered_fasta_proteomes ../data/Proteomic_fasta_files/");



