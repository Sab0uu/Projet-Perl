#!/usr/bin/perl

use strict;
use warnings;
use File::Fetch;
# use Tk::ColoredButton;
use Carp;
use Tk;

require "Extract_CA.pm";
require "Calculate_Distance.pm";
# require "Calculate_Distance_Filters.pm";
# require "Ddl_PDB.pm";

my $pdb;
my $filename;
my @Results;
my $sw;
my @tmp;

my $mw = MainWindow->new(-background => 'white');

$mw->minsize(200,180);
$mw->maxsize(200,180);

$mw->title("Calculate distance between 2 amino acids");

$mw->Label(-text => "Entry PDB code",
		   -background => 'white',
		  )->pack(-side => 'top',-expand => 1);

$mw->Entry(-textvariable => \$pdb,
		   -background => '#FAEFAD',
		   -width => 10, 
		  )->pack(-side => 'top',-expand => 1);

	# -side => 'left', #positionnement à gauche 
	# -anchor => 'n' #positionnement en haut de la fenêtre

$mw->Button(-text => "Download PDB file", 
			-command => \&ddl_PDB,
			-background => '#FAFAFA',
			)->pack(-side => 'left',-expand => 1, -fill => 'x');

$mw->Button(-text => "Load",
			-command => \&results_Load,
			-background => '#FAFAFA',
			)->pack(-side => 'left', -expand => 1, -fill => 'x');

$mw->Button(-text => 'Load on a list' ,
            -command => \&results_LoadOnList,
            -background => '#FAFAFA',
       	   
       	    )->pack (-side => 'top', -expand => 1, -fill => 'x');

# $mw->Button(-text => "Exit",
# 			-command => \&clean_mw,
# 			-background => '#FAFAFA',
# 			)->pack(-side => 'left', -expand => 1, -fill => 'x');

# $mw->Button(-text => "Exit",
# 			-command => \&clean_mw,
# 			-background => '#FAFAFA',
# 			)->pack(-side => 'bottom', -expand => 1, -fill => 'x');

my $menubar = $mw->Menu(-type => 'menubar',
						-background => '#FAFAFA');
$mw->configure(-menu => $menubar);

my $file = $menubar->cascade(-label => '~File', -tearoff => 0);

$file->command(-label => '~Quit',
                -accelerator => 'Ctrl+Q',
                -command => \&clean_mw); 

$mw->bind('<Control-q>', [\&clean_mw]);

MainLoop;

sub save_File {
	my (@Results)=@_;
	# my $output = "Calculate_Distance_Filters-$pdbFix";

	my $save = $sw->getSaveFile(-filetypes => [['Text Files',['.txt', '.text']],
  												['All Files',   '*']], 
                        	    # -initialfile => $output,
                        	    -initialdir => 'Results',
                        	    -defaultextension => '.txt');
	open OUTPUT, "> $save";
	print OUTPUT sort @Results;
	close OUTPUT; 

	print qq{You chose to save as "$save"\n} if $save;
}

sub open_file {
	my $open = $mw->getOpenFile(-filetypes => [['Text Files',['.txt', '.text']],
  												['All Files',   '*']]);

	print qq{You chose to open "$open"\n} if $open;

	return $open;
}

sub results_LoadOnList {
	my $open = &open_file;

    open FILE, $open;
	while (<FILE>){
		s/\t+//g;
		s/\r//g;
		s/\s//g;
		if(/^[0-9A-Za-z]{4}$/){
			$pdb = $_;
			&calculate_Distance_Filters;
			open OUTPUT, ">> Results/tmp.txt";
			print OUTPUT sort @Results;
			close OUTPUT;
		}
	}
	close FILE;

	$sw = $mw -> Toplevel();
    $sw->title("Results of distances calculations");

	open TMPFILE, "Results/tmp.txt";
	push @tmp, <TMPFILE>;
	close TMPFILE;

	my $Results=$sw->Scrolled("Listbox", 
							  -scrollbars=>"e",
							  -heigh=> 30,
							  -background => 'white',
							  -width=> 50)->pack();

	$Results->insert('end', sort @tmp);

    $sw->Button(-text=>"Save", 
    			-command =>[\&save_File,@tmp],
    			-background => '#FAFAFA',
    			)->pack(-side => 'left', -expand => 1, -fill => 'x');

    $sw->Button(-text=>"Exit", 
    			-command =>sub {$sw -> destroy},
    			-background => '#FAFAFA',
    			)->pack(-side => 'left', -expand => 1, -fill => 'x');

    system("rm -f Results/tmp.txt");
}

sub ddl_PDB {
	if ($pdb ne ""){
		my $pdbFix = $pdb;
		$pdbFix = lc($pdbFix);

	    print qq{You chose to download "$pdb"\n} if $pdbFix;

	    my $dir = $mw->chooseDirectory(-initialdir => '.',
	                                   -title => 'Choose a folder');

	    print qq{You chose "$dir" as download directory\n} if $pdbFix;

		my $ff = File::Fetch->new(uri => 'ftp://ftp.rcsb.org/pub/pdb/data/structures/all/pdb/pdb'.$pdbFix.'.ent.gz');
		my $where = $ff->fetch(to => $dir) or die $ff->error;
		system("if [ -e ${dir}/pdb${pdbFix}.ent ]; then rm -f ${dir}/pdb${pdbFix}.ent; gunzip ${dir}/pdb${pdbFix}.ent.gz; else gunzip ${dir}/pdb${pdbFix}.ent.gz; fi");
	} else {
			print "You have to write a PDB code\n";
	}
}

sub clean_mw{ 
	print "\nGood Bye\n";
	sleep 1;
	$mw -> destroy;
}

sub results_Load {
	my $pdbFix = $pdb;
	$pdbFix = lc($pdbFix);
	
	$sw = $mw -> Toplevel();
	$sw->title("results of distances calculations");

	&calculate_Distance_Filters;

	my $Results=$sw->Scrolled("Listbox", 
							  -scrollbars=>"e",
							  -heigh=> 30,
							  -background => 'white',
							  -width=> 50)->pack();

	$Results->insert('end', sort @Results);

    $sw->Button(-text=>"Save", 
    			-command =>[\&save_File,@Results],
    			-background => '#FAFAFA',
    			)->pack(-side => 'left', -expand => 1, -fill => 'x');

    $sw->Button(-text=>"Exit", 
    			-command =>sub {$sw -> destroy},
    			-background => '#FAFAFA',
    			)->pack(-side => 'left', -expand => 1, -fill => 'x');

}

sub calculate_Distance_Filters {
	my $pdbFix = $pdb;
	$pdbFix = lc($pdbFix);

	if ($pdb ne ""){
		&ddl_PDB;

		print qq{You chose to calculate distances between amino acids from Results/pdb${pdbFix}.ent\n};

		my %coord = &extract_CA("Results/pdb${pdbFix}.ent");

		for my $i (sort {$coord{$a} <=> $coord{$b}} keys %coord){
			my($coordx1,$coordy1,$coordz1) = @{$coord{$i}};
			my @infos1 = split "_",$i;
			my $resname1 = $infos1[0];
			my $resid1 = $infos1[1];

			for my $j (sort {$coord{$a} <=> $coord{$b}} keys %coord){
				my($coordx2,$coordy2,$coordz2) = @{$coord{$j}};
				my @infos2 = split "_",$j;
				my $resname2 = $infos2[0];
				my $resid2 = $infos2[1];

				#Premier filtre : la séquence séparant 2 acides aminés doit être supérieure à 4
				if ($resid2 > 4){

					#On ne souhaite pas calculer les distances entre les deux mêmes résidus
					if ($i ne $j){

						my $distance = sqrt(($coordx1-$coordx2)**2+($coordy1-$coordy2)**2+($coordz1-$coordz2)**2);

						#Deuxième filtre : la distance au niveau spatial séparant 2 CA comprise entre 0 et 15 Å
						if ($distance > 0 and $distance < 15){
							push @Results,sprintf ("%4d %3s %4d %3s %6.3f\n",$resid1,$resname1,$resid2,$resname2,$distance);
							# printf ("%4d %3s %4d %3s %6.3f\n",$resid1,$resname1,$resid2,$resname2,$distance);
						}
					}
				}	
			}
		}
	} else {
		print "You have to write a PDB code\n";
	}
}