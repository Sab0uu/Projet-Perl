#!/usr/bin/perl

use strict;
use warnings;

require "Extract_CA.pm";
require "Calculate_Distance_Filters.pm";

my $pdbfile = $ARGV[0];

my %coord = &extract_CA($pdbfile);

&calculate_Distance_Filters($pdbfile,%coord);