# Comptabilise et classe les différents couples d’acides aminés selon la distance les séparant

sub Count_Classify_Aa {
	my($open) = @_;

	my %counter;
	my ($left,$right);

	my $output = $open;
	$output =~ s/^.*\///g;
	$output =~ s/\..*$//;
	$output = lc($output);

	open OUTPUT, "> Results/Count-Classify-Aa-${output}.txt";

	open FILE, $open;
	while (<FILE>){
		chomp;
		my ($resid1,$resname1,$resid2,$resname2,$distance)=split;

		for (my $i = 0; $i < 15; $i+=0.5){
			$left = $i;
			$right = $i+0.5;

			if (($distance >= $left) and ($distance <= $right)){
				if (exists $counter{$left.'_'.$right.'_'.$resname1.'_'.$resname2}){
					$counter{$left.'_'.$right.'_'.$resname1.'_'.$resname2} += 1;
				} else {
					$counter{$left.'_'.$right.'_'.$resname1.'_'.$resname2} = 0;
				}
			} elsif (not exists $counter{$left.'_'.$right.'_'.$resname1.'_'.$resname2}){
				$counter{$left.'_'.$right.'_'.$resname1.'_'.$resname2} = 0;	
			}
		}

	}
	close FILE;

	foreach my $k (sort {$a cmp $b} keys %counter){
		my($min,$max,$aa1,$aa2)=split('_',$k);
		my $count = $counter{$k};
		my @aalist;

		printf OUTPUT "%4.1f %4.1f %3s %3s %3d\n",$min,$max,$aa1,$aa2,$count;
		
	}
	close OUTPUT;
}

1;