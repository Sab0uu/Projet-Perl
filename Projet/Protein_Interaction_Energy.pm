
sub read_PDB {
	my($pdbfile) = @_;
	my %coord;

	open PDB, $pdbfile;
	while (<PDB>) {
		if (/^ATOM/) {
			#On récupère les différents champs du PDB nécessaires
			my $resid = substr($_,22,4);
			my $resname = substr($_,17,3);
			my $coordx = substr($_,30,8);
			my $coordy = substr($_,38,8);
			my $coordz = substr($_,46,8);

			#On supprime les espaces de part et d'autres des "valeurs"
			my $residStrip = $resid;
			$residStrip =~ s/^ *//;
			$residStrip =~ s/ *$//;
			my $resnameStrip = $resname;
			$resnameStrip =~ s/^ *//;
			$resnameStrip =~ s/ *$//;
			my $coordxStrip = $coordx;
			$coordxStrip =~ s/^ *//;
			$coordxStrip =~ s/ *$//;
			my $coordyStrip = $coordy;
			$coordyStrip =~ s/^ *//;
			$coordyStrip =~ s/ *$//;
			my $coordzStrip = $coordz;
			$coordzStrip =~ s/^ *//;
			$coordzStrip =~ s/ *$//;

			#On stocke les coordonnées dans une table de hashage
			$coord{$resnameStrip."_".$residStrip}=[$coordxStrip,$coordyStrip,$coordzStrip];
		}
	}
	return %coord;
}

sub read_Energy {
	my($energyfile) = @_;
	my %energyhash;

	open ENERGY,$energyfile;
	while (<ENERGY>) {
		my ($left,$right,$aa1,$aa2,$energy)=split;
		$energyhash{$left.'_'.$right.'_'.$aa1.'_'.$aa2} = $energy;
	}
	close ENERGY;
	return %energyhash;
}

1;