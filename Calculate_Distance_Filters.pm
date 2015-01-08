use Carp;

# Calcule la distance entre deux acides aminées en y appliquant deux filtres
sub calculate_Distance_Filters {
	my ($pdbfile,%coord)=@_;

	my $output = $pdbfile;
	$output =~ s/\..*$//;
	$output = lc($output);

	open OUTPUT, "> Results/Calculate_Distance_Filters-${output}.txt";

	for my $i (sort {$coord{$a} <=> $coord{$b}} keys %coord){
		my($coordx1,$coordy1,$coordz1) = @{$coord{$i}};
		my @infos1 = split "_",$i;
		my $resname1 = $infos1[0];
		my $resid1 = $infos1[1];

		for my $j (sort {$coord{$a} <=> $coord{$b}} keys %coord){
			my($coordx2,$coordy2,$coordz2) = @{$coord{$j}};
			my @infos2 = split "_",$j;
			my $resname2 = $infos2[0];
			my $resid2 = $infos2[1];

			#Premier filtre : la séquence séparant 2 acides aminés doit être supérieure à 4
			if ($resid2 > 4){

				#On ne souhaite pas calculer les distances entre les deux mêmes résidus
				if ($i ne $j){

					my $distance = sqrt(($coordx1-$coordx2)**2+($coordy1-$coordy2)**2+($coordz1-$coordz2)**2);

					#Deuxième filtre : la distance au niveau spatial séparant 2 CA comprise entre 0 et 15 Å
					if ($distance > 0 and $distance < 15){
						printf OUTPUT "%4d %3s %4d %3s %6.3f\n",$resid1,$resname1,$resid2,$resname2,$distance;
					}

				}
			}	
		}
	}
	close OUTPUT;
}

1;