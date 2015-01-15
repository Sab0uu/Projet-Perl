#!/usr/bin/perl

use strict;
use warnings;

require "Extract_CA.pm";
require "Help.pm";

my $pdbfile = $ARGV[0];

&extract_CA($pdbfile);

#-----------------------------------------#

# Fonction help propre à ce programme

help();

__END__

=head1 SYNOPSIS

./prog1.pl [options] PDB

=head1 OPTIONS

=over 8

=item B<-help>

Print a brief help message and exits.

=item B<-man>

Prints the manual page and exits.

=back

=head1 DESCRIPTION

B<This program> extracts Carbones Alpha (CA) from the PDB file and their x, y, z coordinates.

=cut