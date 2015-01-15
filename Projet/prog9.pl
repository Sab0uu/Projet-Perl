#!/usr/bin/perl

use strict;
use warnings;

require "Calculate_Distance_Filters.pm";
require "Count-Classify-Aa.pm";
require "Protein_Interaction_Energy.pm";

my $pdbfile = $ARGV[0];
my $energyfile = $ARGV[1];

my %coord = read_PDB($pdbfile);
my $distancefile = &calculate_Distance_Filters($pdbfile,%coord);
my %count_aa = &Count_Classify_Aa($distancefile);
my %energyhash = read_Energy($energyfile);

my $energy_tot;
foreach my $i (sort keys %count_aa){
	foreach my $j (sort keys %energyhash){
		if ($i eq $j){
			print "$i --> $j\n";
		}
	}
	# $energy_tot += ($energyhash{$k} * $count_aa{$k});
}

# print "$energy_tot\n";
