#!/usr/local/bin/perl
#3_Protein_count_filtering.pl
#
#Author: Abelardo Aguilar Camara
#
#Task performed:
#    This script filters individual files depending on the protein count and a cutoff 
#    value defined as a certain percentage of allowed variation around the mean count
#    for the taxon (family) proteomes.
#
#    It also asks for upper/lower reference protein count values to prevent losing reference strains
#
#NOTE:"Catfiltered" label stands for concatenated (cat) and filtered
#     "pc" in comments stands for "protein count"
#
#INPUT: Concatenated genomic fasta files           from     ../data/Genomic_fasta_files/anytaxon_concatenated_fasta_genomes
#       Concatenated individual genbank files      from   ../data/Individual_full_genbank_files/anytaxon_concatenated_genbank_genomes
#       Concatenated proteomic fasta files         from   ../data/Proteomic_fasta_files/anytaxon_concatenated_fasta_proteomes
#
#OUTPUT:Catfiltered genomic fasta files           in   ../data/Genomic_fasta_files/anytaxon_catfiltered_fasta_genomes
#       Catfiltered individual genbank files      in     ../data/Individual_full_genbank_files/anytaxon_catfiltered_genbank_genomes
#       Catfiltered proteomic fasta files         in     ../data/Proteomic_fasta_files/anytaxon_catfiltered_fasta_proteomes
# 
#################################################
#
#3_Protein_count_filtering.pl
#
#################################################
#Copy input files to output folders ready for manipulation
$familia = $ARGV[0]; # Reads first positional argument. Expected $ARGV[0] is anytaxon (e.g. Geminiviridae)
$carpetafamilia = "$familia"."_fasta_proteomes";
use POSIX;
system ("cp -r ../data/Genomic_fasta_files/$familia\_concatenated_fasta_genomes ."); # Copies anytaxon_concatenated_fasta_genomes
system ("cp -r ../data/Individual_full_genbank_files/$familia\_concatenated_genbank_genomes ."); # Copies anytaxon_genbank_genomes
system ("cp -r ../data/Proteomic_fasta_files/$familia\_concatenated_fasta_proteomes ."); # Copies anytaxon_concatenated_fasta_proteomes
system ("mv $familia\_concatenated_fasta_genomes $familia\_catfiltered_fasta_genomes "); # Moves anytaxon_concatenated_fasta_genomes
system ("mv $familia\_concatenated_genbank_genomes $familia\_catfiltered_genbank_genomes"); # Moves anytaxon_genbank_genomes
system ("mv $familia\_concatenated_fasta_proteomes $familia\_catfiltered_fasta_proteomes"); # Moves anytaxon_concatenated_fasta_proteomes
#
system ("grep -c \">\" $familia\_catfiltered_fasta_proteomes/* > PROTEIN_COUNT_$familia"); # Generate protein counts for anytaxon proteomes
#################################################
#Open protein_count* file to compute mean pc
open (FILE, "PROTEIN_COUNT_$familia");
$numero_proteomas = 0; # Initiates variable to count computed organisms
$suma_conteo = 0; # Initiates variable to sum protein counts 
#Recover
while ($linea = <FILE>) { # Read file with protein counts line by line
	chomp ($linea);
	my ( $count ) = $linea=~ /(\:.*)\s*$/; # Finds the number of proteins for the file stated in $linea
	$count =~ s/://g; # Removes ":" character from pc ($count)
	$suma_conteo += $count; # summation of protein count
	$numero_proteomas += 1; # total number of computed files
}
#################################################
#Set initial cutoff values
$percdiff = $ARGV[1]; #The second positional argument corresponds to the allowed percentage of difference from mean pc
$diff = $percdiff / 100; #$diff = relative difference
$promedio_conteo = ceil($suma_conteo / $numero_proteomas); #Estimates pc rounded mean
$intervalo = $promedio_conteo * $diff; #Estimates length of allowed interval
$maxcalc = ceil($promedio_conteo + $intervalo); #Sets upper pc limit
$mincalc = ceil($promedio_conteo - $intervalo); #Sets lower pc limit
#################################################
#Obtain reference protein counts
$minref = $ARGV[2]; #Minimum
$maxref = $ARGV[3]; #Maximum
#################################################
#Ignore if reference protein counts are not given by user
if ($minref == 0) { #Ignore minimum
	$minref = $mincalc;
	print STDOUT "\nNo minimum protein count from reference proteome was given... setting lower limit to -\%$percdiff deviation from the mean \n";
}
if ($maxref == 0) { #Ignore maximum
	$maxref = $maxcalc;
	print STDOUT "\nNo maximum protein count from reference proteome was given... setting upper limit to +\%$percdiff deviation from the mean \n\n";
}
print STDOUT "\nmean protein count is $promedio_conteo (rounded-up) \n\n";
#################################################
#Make sure that reference protein counts are not outside calculated cutoff values
if ($minref < $mincalc) { #When minimum pc is lower than calculated minimum cutoff
	$lim_inferior = $minref;
	print STDOUT "Minimum protein count from reference strain is lower than -\%$percdiff cutoff value... setting lower limit to $minref proteins \n";
}else{
	$lim_inferior = $mincalc; #... when not
	print STDOUT "... setting lower protein cutoff count in $lim_inferior proteins \n";
}
if ($maxref > $maxcalc) { #When maximum pc is bigger than calculated maximum cutoff
	$lim_superior = $maxref;
	print STDOUT "Maximum protein count from reference strain is bigger than +\%$percdiff cutoff value... setting upper limit to $maxref proteins \n\n";
}else{ #... when not
	$lim_superior = $maxcalc;
	print STDOUT "... setting upper protein cutoff count in $lim_superior proteins \n\n";
}
#################################################
#Start count of filtered files
$eliminated_count = 0;
#################################################
#Open and read protein_count* file to decide files to be filtered
print STDOUT "\n\n\n_____________________________________\n The following files will be filtered:\n\n";
print STDOUT "\tProtein count\tSpecies + Taxonimic ID\n\n";
open (FILE, "PROTEIN_COUNT_$familia");
while ($linea = <FILE>) {
	chomp ($linea);
	my ( $count ) = $linea=~ /(\:.*)\s*$/; # Finds the number of proteins for the file stated in $linea
	$count =~ s/://g;
	########################################
	########################################
	#
	# Here's the magic:
	if ($count > $lim_superior || $count < $lim_inferior ) { # If pc exceeds allowed limits ...
		my $rejected_file = substr($linea, 0, index($linea, ":"));
		my $rejwithoutextension = substr($rejected_file, 0, index($linea, "."));
		my $pathtofile = "$familia\_catfiltered_fasta_proteomes/";
		$rejwithoutpath = $rejwithoutextension;
		$rejwithoutpath =~ s/$pathtofile//g; # $rejwithoutpath stands for "Rejected file without relative path"
		print STDOUT "\t   $count   \t $rejwithoutpath\n"; #... file is listed as filtered
		$eliminated_count += 1; # summation of filtered files
		########################################
		########################################
		#
		# Here's the execution
		#    if a species is to be filtered, then the following lines
		system ("rm $familia\_catfiltered_fasta_genomes/$rejwithoutpath*"); # Removes its fasta genome 
		system ("rm $familia\_catfiltered_genbank_genomes/$rejwithoutpath*"); # Removes its genbank file
		system ("rm $familia\_catfiltered_fasta_proteomes/$rejwithoutpath*"); # Removes its fasta proteome
	}
} # END OF FILTERING
print STDOUT ("\n$eliminated_count organisms were discarded from the database for further analysis\n"); # prints stdout report
system ("rm PROTEIN_COUNT_$familia"); # removes temporary files
#################################################
#Redirect output folders to desired locations, labeled as "catfiltered"
system ("mv $familia\_catfiltered_fasta_genomes ../data/Genomic_fasta_files/");
system ("mv $familia\_catfiltered_genbank_genomes ../data/Individual_full_genbank_files/");
system ("mv $familia\_catfiltered_fasta_proteomes ../data/Proteomic_fasta_files/");



