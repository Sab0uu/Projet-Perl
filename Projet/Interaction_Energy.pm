sub Ref_distance {
	# Calcul la fréquence d’interaction de référence à la distance d
	my($Number_interaction_distance_d,$Number_interaction_all_distances)=@_;

	my $ref_distance = ($Number_interaction_distance_d/$Number_interaction_all_distances);
	return $ref_distance;
}


sub Ref_Observed_distance {
	# fréquence de l’interaction ij à la distance d observée
	my($Number_interaction_distance_d_couples,$Number_interaction_all_distances_couples)=@_;
	my $ref_observed_distance = $Number_interaction_distance_d_couples/$Number_interaction_all_distances_couples;
	return $ref_observed_distance;
}

sub calculate_Energy {
	my($NIDd,$NIAD,$NIDd_Couples,$NIAD_Couples)=@_;
	my $ kT = 1;

	my $energy = - $kT * ln(&Ref_distance($NIDd,$NIAD)/&Ref_Observed_distance($NIDd_Couples,$NIAD_Couples));
	return $energy;
}

1;