#!/usr/bin/perl

use strict;
use warnings;
use Tk;

my ($pdb, $filename, @Results, $sw, $mw, @tmp);

$mw = MainWindow->new(-background => 'white');

$mw->minsize(200,180);
$mw->maxsize(200,180);

$mw->title("Calculate distance between 2 amino acids");

# print

##############################################################################
## MENU

my $menubar = $mw->Menu(-type => 'menubar',
						-background => '#FAFAFA');

$mw->configure(-menu => $menubar);

my $window = $menubar->cascade(-label => '~Window', -tearoff => 0);
my $program = $menubar->cascade(-label => '~Program', -tearoff => 0);
my $help = $menubar->cascade(-label => '~Help', -tearoff => 0);

# "Onglet" Window dans lequel on a la possibilité de fermer la fenetre
$window->command(-label => '~Quit',
                -accelerator => 'Ctrl+Q',
                -command => \&clean_mw); 

# "Onglet" Program dans lequel on a la possibilité de lancer le programme
# sur une liste de codes PDB
$program->command(-label => '~Classify amino acid pair',
                -accelerator => 'Ctrl+L',
                -command => \&results_LoadOnList); 

MainLoop;

# Fonction pour ouvrir un fichier
sub open_file {
	my $open = $mw->getOpenFile(-filetypes => [['Text Files',['.txt', '.text']],
  												['All Files',   '*']]);

	print qq{You chose to open "$open"\n} if $open;

	return $open;
}

# Génération des résultats si l'on agit sur une liste de codes PDB
sub results_LoadOnList {
	my $dir;
	my $open = &open_file;

	# On parcourt la liste de codes PDB
    open FILE, $open;
	while (<FILE>){
		my($resid1,$resname1,$resid2,$resname2,$distance) =;
	}
	close FILE;

	# $sw = $mw -> Toplevel();
	# $sw->title("Results of distances calculations");

	# #Bouton "save" afin de sauvegarder les résultats dans un fichier
 #    $sw->Button(-text=>"Save", 
 #    			-command =>[\&save_File,@tmp],
 #    			-background => '#FAFAFA',
 #    			)->pack(-side => 'left', -expand => 1, -fill => 'x');

 #    #Bouton pour fermer la fenetre des résultats
 #    $sw->Button(-text=>"Exit", 
 #    			-command =>sub {$sw -> destroy},
 #    			-background => '#FAFAFA',
 #    			)->pack(-side => 'left', -expand => 1, -fill => 'x');
}