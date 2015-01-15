#!/usr/bin/perl

use strict;
use warnings;
use Carp;

require "OnaList.pm";

my $open = $ARGV[0];

&OnaList($open);