use Carp;

require "Extract_CA.pm";
require "Calculate_Distance_Filters.pm";
require "Ddl_PDB.pm";

# Génération des résultats si l'on agit sur une liste de codes PDB
sub OnaList {
	my ($open) = @_;
	my $pdb;

	my $output = $open;
	$output =~ s/^.*\///g;
	$output =~ s/\..*$//;
	$output = lc($output);

	system("if [ -e Results/tmp-${output}.txt ]; then rm -f Results/tmp-${output}.txt; fi");

	# On parcourt la liste de codes PDB
    open FILE, $open;
	while (<FILE>){
		s/\t+//g;
		s/\r//g;
		s/\s//g;

		# On vérifie que le code PDB est composé de 4 caractères si ce n'est 
		# pas le cas, on ne le traite pas
		if(/^[0-9A-Za-z]{4}$/){
			$pdb = $_;
		}
		my $pdbfile = &ddl_PDB($pdb);
		my %coord  = &extract_CA($pdbfile);
		my $results = &calculate_Distance_Filters($pdbfile,%coord);

		# Création d'un fichier tmp.txt dans le dossir Results servant à la concaténation des 
		# résultats de calcul pour chaque PDB
		open OUTPUT, ">> Results/tmp-${output}.txt";
		open RESULTS,$results;
		my @Results = <RESULTS>;
		print OUTPUT @Results;
		close RESULTS;
		close OUTPUT;
		
	}
	close FILE;
	# On trie les résultats par ordre croissant de numéro d'atome.
	system("cat Results/tmp-${output}.txt | sort -k1n,1n -k3n,3n > Results/Calculate_Distance_Filters-OnaList-${output}.txt");
	system("rm -f Results/tmp-${output}.txt");
}

1;