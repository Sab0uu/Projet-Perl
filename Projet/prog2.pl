#!/usr/bin/perl

use strict;
use warnings;

require "Extract_CA.pm";
require "Calculate_Distance.pm";


my $pdbfile = $ARGV[0];

my %coord = &extract_CA($pdbfile);

&calculate_Distance($pdbfile,%coord);