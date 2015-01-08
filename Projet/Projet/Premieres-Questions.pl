#!/usr/bin/perl

use strict;
use warnings;

require "Extract_CA.pm";
require "Calculate_Distance.pm";
require "Calculate_Distance_Filters.pm";
require "Ddl_PDB.pm";

my $pdbfile = $ARGV[0];

my %coord = &extract_CA($pdbfile);

&calculate_Distance($pdbfile,%coord);
&calculate_Distance_Filters($pdbfile,%coord);
# &ddl_PDB($pdbfile);