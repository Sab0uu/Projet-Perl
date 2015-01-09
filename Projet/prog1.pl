#!/usr/bin/perl

use strict;
use warnings;

require "Extract_CA.pm";


my $pdbfile = $ARGV[0];

&extract_CA($pdbfile);