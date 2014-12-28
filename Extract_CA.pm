use Carp;

# Extrait les CA et leurs coordonnées
sub extract_CA {
		my ($pdbfile)=@_;

		my %coord;

		my $output = $pdbfile;
		$output =~ s/\..*$//;
		$output = lc($output);

		open OUTPUT, "> Results/Extract_CA-${output}.txt";

		open PDB, $pdbfile;
		while (<PDB>) {
		if (/^ATOM/) {
			#On récupère les noms des différents atomes
			my $atm = substr($_,12,4);

			#On retire les espaces inutiles
			my $atmStrip = $atm;
			$atmStrip =~ s/^ *//;
			$atmStrip =~ s/ *$//;

			if ($atmStrip eq "CA"){
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

				#Formatage de l'écriture
				printf OUTPUT "%4d %3s %8s %8s %8s\n",$residStrip,$resnameStrip,$coordxStrip,$coordyStrip,$coordzStrip;
			}
		}
	}
	return %coord;
	close PDB;
	close OUTPUT;
}


1;