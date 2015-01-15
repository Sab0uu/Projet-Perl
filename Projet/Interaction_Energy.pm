sub Ref_distance {
	# Calcul la fréquence d’interaction de référence à la distance d
	# Nombre d’interaction ij à la distance d = nij
	# Nombre d’interaction ij pour toutes les distances = nijtot
	my($nij,$nijtot)=@_;

	my $ref_distance = ($nij/$nijtot);
	return $ref_distance;
}


sub Ref_Observed_distance {
	# fréquence de l’interaction ij à la distance d observée
	# Nombre d’interaction pour tous les couples ij à la distance d = ncij
	# Nombre d’interaction pour tous les couples ij pour toutes les distances = ncijtot
	my($ncij,$ncijtot)=@_;
	my $ref_observed_distance = $ncij/$ncijtot;
	return $ref_observed_distance;
}

sub calculate_Energy {
	# dérive une énergie pour chaque type d’interaction
	# La fonction log renvoie le logarithme népérien
	my($nij,$nijtot,$ncij,$ncijtot)=@_;
	my $ kT = 1;

	my $energy = - $kT * log(&Ref_distance($nij,$nijtot)/&Ref_Observed_distance($ncij,$ncijtot));
	return $energy;
}

sub show_Results {
	my($open) = @_;

	my $output = $open;
	$output =~ s/^.*\///g;
	$output =~ s/\..*$//;
	$output = lc($output);

	my %count_couples;
	my %count_classes;
	my %count_aa;
	my $total;
	my %aalist;
	my %clist;

	open OUTPUT, "> Results/Calculate_Interaction_Energy-${output}.txt";

	open FILE, $open;
	while (<FILE>){
		chomp;
		my ($left,$right,$resname1,$resname2,$count)=split;

		# Création de hash pour effectuer les différents comptages
		$aalist{$resname1} = 1;
		$clist{$left.'_'.$right} = 1;
		$count_aa{$left.'_'.$right.'_'.$resname1.'_'.$resname2} = $count;
		$count_couples{$resname1.'_'.$resname2} += $count;
		$count_classes{$left.'_'.$right} += $count;
		$total += $count;
	}
	close FILE;
	
	foreach my $aa1 (sort keys %aalist){
		foreach my $aa2 (sort keys %aalist){
			foreach my $class (sort keys %clist){
				my($left,$right)=split('_',$class);
				my $energy;

				# On vérifie que l'on a pas de division par zéro
				if (($count_aa{$left.'_'.$right.'_'.$aa1.'_'.$aa2} != 0) and ($count_classes{$left.'_'.$right} != 0)){
					$energy = &calculate_Energy($count_aa{$left.'_'.$right.'_'.$aa1.'_'.$aa2},$count_couples{$aa1.'_'.$aa2},$count_classes{$left.'_'.$right},$total);
				} 
				# S'il n'y a d'interaction ou que l'énergie est superieure à 10, on la met à 10
				# On met également à 10 si la variable $energy est vide
				elsif (($energy == 0) or ($energy > 10.0) or ($energy eq "")){
					$energy = 10.0;
				}
				printf OUTPUT "%4.1f %4.1f %3s %3s %4.1f\n",$left,$right,$aa1,$aa2,$energy;
			}
		}
	}
}

1;