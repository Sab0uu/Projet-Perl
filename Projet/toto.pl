#!/usr/bin/perl

use strict;
use warnings;

my $open= $ARGV[0];

my @lines;
# On parcourt la liste de codes PDB
my %counter;

open FILE, $open;
while (<FILE>){
	chomp;
	my($resid1,$resname1,$resid2,$resname2,$distance)=split;

	if (($distance >= 0.0) and ($distance <= 0.5)){
		if(exists($counter{"0.0to0.5"})) {
			$counter{"0.0to0.5"}++;
		} else {
			$counter{"0.0to0.5"} = 1 ;
		}
		print "toto\n";
	} elsif (($distance >= 1) and ($distance <= 1.5)) {
		if(exists($counter{"0.5to1.0"})) {
			$counter{"0.5to1.0"}++;
		} else {
			$counter{"0.5to1.0"} = 1 ;
		}
		print "toto2\n";
	} elsif (($distance >= 1.5) and ($distance <= 2.0)) {
		if(exists($counter{"1.5to2.0"})) {
			$counter{"1.5to2.0"}++;
		} else {
			$counter{"1.5to2.0"} = 1 ;
		}
	} elsif (($distance >= 2.5) and ($distance <= 3.0)) {
		if(exists($counter{"2.5to3.0"})) {
			$counter{"2.5to3.0"}++;
		} else {
			$counter{"2.5to3.0"} = 1 ;
		}
	} elsif (($distance >= 3.5) and ($distance <= 4.0)) {
		if(exists($counter{"3.5to4.0"})) {
			$counter{"3.5to4.0"}++;
		} else {
			$counter{"3.5to4.0"} = 1 ;
		}
	} elsif (($distance >= 4.5) and ($distance <= 5.0)) {
		if(exists($counter{"4.5to5.0"})) {
			$counter{"4.5to5.0"}++;
		} else {
			$counter{"4.5to5.0"} = 1 ;
		}
	} elsif (($distance >= 5.5) and ($distance <= 6.0)) {
		if(exists($counter{"5.5to6.0"})) {
			$counter{"5.5to6.0"}++;
		} else {
			$counter{"5.5to6.0"} = 1 ;
		}
	} elsif (($distance >= 6.5) and ($distance <= 7.0)) {
		if(exists($counter{"6.5to7.0"})) {
			$counter{"6.5to7.0"}++;
		} else {
			$counter{"6.5to7.0"} = 1 ;
		}
		if(exists($counter{"7.5to8.0"})) {
			$counter{"7.5to8.0"}++;
		} else {
			$counter{"7.5to8.0"} = 1 ;
		}
	} elsif (($distance >= 8.5) and ($distance <= 9.0)) {
		if(exists($counter{"8.5to9.0"})) {
			$counter{"8.5to9.0"}++;
		} else {
			$counter{"8.5to9.0"} = 1 ;
		}
	} elsif (($distance >= 9.5) and ($distance <= 10.0)) {
		if(exists($counter{"9.5to10.0"})) {
			$counter{"9.5to10.0"}++;
		} else {
			$counter{"9.5to10.0"} = 1 ;
		}
	} elsif (($distance >= 10.5) and ($distance <= 11.0)) {
		if(exists($counter{"10.5to11.0"})) {
			$counter{"10.5to11.0"}++;
		} else {
			$counter{"10.5to11.0"} = 1 ;
		}
	} elsif (($distance >= 11.5) and ($distance <= 12.0)) {
		if(exists($counter{"11.5to12.0"})) {
			$counter{"11.5to12.0"}++;
		} else {
			$counter{"11.5to12.0"} = 1 ;
		}
	} elsif (($distance >= 12.5) and ($distance <= 13.0)) {
		if(exists($counter{"12.5to13.0"})) {
			$counter{"12.5to13.0"}++;
		} else {
			$counter{"12.5to13.0"} = 1 ;
		}
	} elsif (($distance >= 13.5) and ($distance <= 14.0)) {
		if(exists($counter{"13.5to14.0"})) {
			$counter{"13.5to14.0"}++;
		} else {
			$counter{"13.5to14.0"} = 1 ;
		}
	} elsif (($distance >= 14.5) and ($distance <= 15.0)) {
		if(exists($counter{"14.5to15.0"})) {
			$counter{"14.5to15.0"}++;
		} else {
			$counter{"14.5to15.0"} = 1 ;
		}
	} else {
		print "Error !\n";
	}
	# push @lines, $_;
}
close FILE;

foreach my $k (sort keys %counter){
	print "$k -> $counter{$k}\n";
}

# foreach my $l (@lines){

# }

# foreach my $l (@lines) {
# 	if(exists($counter{$l})) {
# 		$counter{$l}++;
# 	} else {
# 		$counter{$l} = 1 ;
 
# 	}
# }

# foreach my $k (sort keys %counter){
# 	print "$k -> $counter{$k}\n";
# }
