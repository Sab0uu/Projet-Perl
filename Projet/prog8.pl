#!/usr/bin/perl

use strict;
use warnings;

require "Interaction_Energy.pm";

# my $pdbfile = $ARGV[0];

my $energy = &calculate_Energy(2,3,4,5);
print $energy;