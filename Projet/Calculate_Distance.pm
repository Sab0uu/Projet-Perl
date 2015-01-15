use Carp;

# Calcule la distance entre deux acides aminées
sub calculate_Distance {
	my ($pdbfile,%coord)=@_;

	my $output = $pdbfile;
	$output =~ s/^.*\///g;
	$output =~ s/\..*$//;
	$output = lc($output);

	open OUTPUT, "> Results/Calculate_Distance-${output}.tmp";

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

			#On ne souhaite pas calculer les distances entre les deux mêmes résidus
			if ($i ne $j){
				my $distance = sqrt(($coordx1-$coordx2)**2+($coordy1-$coordy2)**2+($coordz1-$coordz2)**2);
				printf OUTPUT "%4d %3s %4d %3s %6.3f\n",$resid1,$resname1,$resid2,$resname2,$distance;
			}	
		}
	}
	close OUTPUT;
	system("cat Results/Calculate_Distance-${output}.tmp | sort -k1n,1n -k3n,3n > Results/Calculate_Distance-${output}.txt");
	system("rm -f Results/Calculate_Distance-${output}.tmp");
	return "Results/Calculate_Distance-${output}.txt"
}	

1;