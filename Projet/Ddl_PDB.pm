use File::Fetch;
use Carp;
use LWP::Simple;
sub ddl_PDB {
	my ($pdbfile)=@_;
	
	system("if [ ! -d Results ]; then mkdir Results;fi");

	my $pdb = $pdbfile;
	$pdb =~ s/\.pdb//;
	$pdb = lc($pdb);

	my $dir = "Results/";
	my $url = 'ftp://ftp.rcsb.org/pub/pdb/data/structures/all/pdb/pdb'.$pdb.'.ent.gz';
	# if(not head($url)){
	# 	 die "Le nom donné en argument n'est pas un fichier PDB.\n";
	# } else {
		my $ff = File::Fetch->new(uri => $url);
		my $where = $ff->fetch(to => $dir) or die $ff->error;
		system("if [ -e ${dir}pdb${pdb}.ent ]; then rm -f ${dir}pdb${pdb}.ent; gunzip ${dir}pdb${pdb}.ent.gz; else gunzip ${dir}pdb${pdb}.ent.gz; fi");
	# }

	return "${dir}pdb${pdb}.ent";
	exit;
}

1;