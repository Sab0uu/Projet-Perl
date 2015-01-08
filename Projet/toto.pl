#!/usr/bin/perl

use strict;
use warnings;

my $open= $ARGV[0];

my @lines;
# On parcourt la liste de codes PDB
my %counter;
my %dist;

# for (my $i = 1; $i <=30; $i ++){
# 	$counter{"class$i"} = 0;
# }
my($resid1,$resname1,$resid2,$resname2,$distance);
my ($left,$right);

open FILE, $open;
while (<FILE>){
	chomp;
	($resid1,$resname1,$resid2,$resname2,$distance)=split;
	# my ($left,$right);

	for (my $i = 0; $i < 15; $i+=0.5){
		$left = $i;
		$right = $i+0.5;
		$counter{$left.'_'.$right.'_'.$resname1.'_'.$resname2} = 0;	
	}
}
close FILE;

	if (($distance >= int($distance) + 0.5) and ($distance <= int($distance) + 1)){
		$left = int($distance) + 0.5;
		$right = int($distance) + 1;

		if (exists $counter{$left.'_'.$right.'_'.$resname1.'_'.$resname2}){
			$counter{$left.'_'.$right.'_'.$resname1.'_'.$resname2} += 1;
		} else {
			$counter{$left.'_'.$right.'_'.$resname1.'_'.$resname2} = 0;
		}

	} elsif (($distance >= int($distance)) and ($distance <= int($distance) + 0.5)){

		$left = int($distance);
		$right = int($distance) + 0.5;
<<<<<<< HEAD

		if (exists $counter{$left.'_'.$right.'_'.$resname1.'_'.$resname2}){
			$counter{$left.'_'.$right.'_'.$resname1.'_'.$resname2} += 1;
		} else {
			$counter{$left.'_'.$right.'_'.$resname1.'_'.$resname2} = 0;
		}
	}

=======

		if (exists $counter{$left.'_'.$right.'_'.$resname1.'_'.$resname2}){
			$counter{$left.'_'.$right.'_'.$resname1.'_'.$resname2} += 1;
		} else {
			$counter{$left.'_'.$right.'_'.$resname1.'_'.$resname2} = 0;
		}
	}

>>>>>>> aa3b97b55a40c711bc7276016e5111023e1fdb55
# foreach my $k (sort keys %dist){
# 	print "$k -> $dist{$k}\n";
# }

foreach my $k (sort keys %counter){
	my($min,$max,$aa1,$aa2)=split('_',$k);
	my $count = $counter{$k};

	printf "%4.1f %4.1f %3s %3s %3d\n",$min,$max,$aa1,$aa2,$count;
<<<<<<< HEAD
}
Status API Training Shop Blog About
© 2015 GitHub, Inc. Terms Privacy Security Contact
=======
}
>>>>>>> aa3b97b55a40c711bc7276016e5111023e1fdb55
