#!/usr/bin/perl

use strict;
use warnings;

require "Ddl_PDB.pm";

my $pdbname = $ARGV[0];

&ddl_PDB($pdbname);