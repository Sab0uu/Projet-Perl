#!/usr/bin/perl

use strict;
use warnings;

require "Extract_CA.pm";
require "Calculate_Distance_Filters.pm";
require "Help.pm";

my $pdbfile = $ARGV[0];

my %coord = &extract_CA($pdbfile);

&calculate_Distance_Filters($pdbfile,%coord);

#-----------------------------------------#

# Fonction help propre à ce programme

help();

__END__

=head1 SYNOPSIS

./prog3.pl [options] PDB

=head1 OPTIONS

=over 8

=item B<-help>

Print a brief help message and exits.

=item B<-man>

Prints the manual page and exits.

=back

=head1 DESCRIPTION

B<This program> calculates the distance between two amino acids with filters.

=cut