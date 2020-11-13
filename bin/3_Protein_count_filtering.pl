#!/usr/local/bin/perl

#This section generates the protein_count list for the family proteomic files
#The first positional argument corresponds to the family.
$familia = $ARGV[0];
$carpetafamilia = "$familia"."_fasta_proteomes";
system ("grep -c \">\" ../data/Proteomic_fasta_files/$carpetafamilia/* > PROTEIN_COUNT_$familia");
open (FILE, "PROTEIN_COUNT_$familia");
open (OUT, ">>PC_rejected_list");
$numero_proteomas = 0;
$suma_conteo = 0;

#Once the protein_count_famil file is opened, limit values are set. To the moment, a 95% difference from the mean is allowed
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
$promedio_conteo = $suma_conteo / $numero_proteomas;
$intervalo = $promedio_conteo * $diff;
$maxcalc = $promedio_conteo + $intervalo;
$mincalc = $promedio_conteo - $intervalo;


#The third and fourth positional argument correspond to the minimum and maximum protein count for reference strains. Such info can be easily obtained from Viralzone.
#This section down makes sure that calculated limits are not strict enough to filter reference proteomes.
$minref = $ARGV[2];
$maxref = $ARGV[3];

if ($minref == 0) {
	$minref = $mincalc;
}

if ($maxref == 0) {
	$maxref = $maxcalc;
}



if ($minref < $mincalc) {
	$lim_inferior = $minref;
}else{
	$lim_inferior = $mincalc;
}


if ($maxref > $maxcalc) {
	$lim_superior = $maxref;
}else{
	$lim_superior = $maxcalc;
}






open (FILE, "PROTEIN_COUNT_$familia");
while ($linea = <FILE>) {
	chomp ($linea);
	my ( $count ) = $linea=~ /(\:.*)\s*$/;
	$count =~ s/://g;
	if ($count > $lim_superior || $count < $lim_inferior ) {
		my $rejected_file = substr($linea, 0, index($linea, ":"));
		print STDOUT "$rejected_file will be filtered as protein count is $count \n";
		print OUT "$rejected_file\n";
	}
}
close (FILE);
system ("rm PROTEIN_COUNT_$familia");
