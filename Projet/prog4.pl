#!/usr/bin/perl

use strict;
use warnings;

require "Ddl_PDB.pm";

my $pdbfile = $ARGV[0];

&ddl_PDB($pdbfile);