use Getopt::Long;
use Pod::Usage;

sub help {
    my $man = 0;
    my $help = 0;
    GetOptions('help|?' => \$help, man => \$man) or pod2usage(2);
    pod2usage(1) if $help;
    pod2usage(-exitval => 2, -verbose => 3) if $man;
    pod2usage(-verbose => 1, -message => "$0: Too many files given.\n") if (@ARGV > 1);
    pod2usage("$0: No files given.")  if ((@ARGV == 0) && (-t STDIN));
}

1;