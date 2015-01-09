use File::Fetch;
use Carp;

sub ddl_PDB {
	my ($pdbfile)=@_;
	
	system("if [ ! -d Results ]; then mkdir Results;fi")

	my $pdb = $pdbfile;
	$pdb =~ s/\.pdb//;
	$pdb = lc($pdb);

	my $ff = File::Fetch->new(uri => 'ftp://ftp.rcsb.org/pub/pdb/data/structures/all/pdb/pdb'.$pdb.'.ent.gz');
	my $where = $ff->fetch(to => "Results/") or die $ff->error;
	system("if [ -e Results/pdb${pdb}.ent ]; then rm -f Results/pdb${pdb}.ent; gunzip Results/pdb${pdb}.ent.gz; else gunzip Results/pdb${pdb}.ent.gz; fi");
}

1;