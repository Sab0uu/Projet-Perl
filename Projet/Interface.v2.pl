#!/usr/bin/perl

use strict;
use warnings;
use Tk;
use Carp;
use File::Fetch;

require "Extract_CA.pm";

my ($pdb, $filename, @Results, $sw, $mw, @tmp);

$mw = MainWindow->new(-background => 'white');

$mw->minsize(200,180);
$mw->maxsize(200,180);

$mw->title("Calculate distance between 2 amino acids");

system("if [ ! -d Results ]; then mkdir Results; fi");

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
$program->command(-label => '~Load on a list',
                -accelerator => 'Ctrl+L',
                -command => \&results_LoadOnList); 

# "Onglet" Program dans lequel on a la possibilité de consulter la version
# du programme ainsi que des informations concernant ce dernier
$help->command(-label => '~Version',
                -accelerator => 'Ctrl+V',
                -command => \&results_LoadOnList); 

$help->command(-label => '~About',
                -accelerator => 'Ctrl+H',
                -command => \&results_LoadOnList); 

# Raccourcis clavier
$mw->bind('<Control-q>', [\&clean_mw]);
$mw->bind('<Control-l>', [\&results_LoadOnList]);
$mw->bind('<Control-v>', [\&results_LoadOnList]);
$mw->bind('<Control-h>', [\&results_LoadOnList]);

##############################################################################
## WIDGETS et BOUTONS

#  Création de l'entrée pour que l'utilisateur rentre un code PDB ...
$mw->Label(-text => "Entry PDB code",
		   -background => 'white',
		  )->pack(-side => 'top',-expand => 1);

$mw->Entry(-textvariable => \$pdb,
		   -background => '#FAEFAD',
		   -width => 10, 
		  )->pack(-side => 'top',-expand => 1);

# ... qu'il pourra simplement télécharger ou ...
$mw->Button(-text => "Download", 
			-command => [\&ddl_PDB,"PDBcode"],
			-background => '#FAFAFA',
			)->pack(-side => 'left',-expand => 1, -fill => 'x');

# ... télécharger et calculer les distances entre les différents acides aminés
$mw->Button(-text => "Load",
			-command => \&results_Load,
			-background => '#FAFAFA',
			)->pack(-side => 'left', -expand => 1, -fill => 'x');

MainLoop;

##############################################################################
## FONCTIONS
## Fonctions importantes pour le bon fonctionnement du programme

# Fonction pour fermer la fenetre principale
sub clean_mw{ 
	print "\nGood Bye\n";
	sleep 1;
	$mw -> destroy;
}

# Fonction pour ouvrir un fichier
sub open_file {
	my $open = $mw->getOpenFile(-filetypes => [['Text Files',['.txt', '.text']],
  												['All Files',   '*']]);

	print qq{You chose to open "$open"\n} if $open;

	return $open;
}

# Fonction pour sauver les résultats des calculs
sub save_File {
	my (@Results)=@_;

	my $save = $sw->getSaveFile(-filetypes => [['Text Files',['.txt', '.text']],
  												['All Files',   '*']], 
                        	    -initialfile => 'Results',
                        	    -initialdir => 'Results',
                        	    -defaultextension => '.txt');
	open OUTPUT, "> $save";
	print OUTPUT sort @Results;
	close OUTPUT; 

	print qq{You chose to save as "$save"\n} if $save;
}

# Fonction permettant de télécharger un fichier PDB à partir du code PDB 
# modifiée pour etre adaptée à l'interface graphique.
sub ddl_PDB {
	my($type)=@_;

	system("if [ ! -d Results ]; then mkdir Results;fi");

	# On vérifie que la variable $pdb n'est pas vide
	if ($pdb ne ""){

		my $pdbFix = $pdb;
		$pdbFix = lc($pdbFix);
		my $dir;

		print qq{You chose to download "$pdb"\n} if $pdbFix;

		# Le fichier PDB téléchargé est placé dans le dossier Results si l'on agit sur une liste 
		# de codes PDB ou dans le dossier du choix de l'utilisateur si l'on agit sur un code PDB
		if($type eq "PDBcode"){
			$dir = $mw->chooseDirectory(-initialdir => '.',
	                            	    -title => 'Choose a folder');
		} elsif ($type eq "PDBlist"){
			$dir = "Results";
		} else {
			print "Error! No such type of document\n";
		}

		# On vérifie que la variable $dir n'est pas vide
		if ($dir ne ""){
		    print qq{You chose "$dir" as download directory\n} if $dir;

		    # Le fichier PDB est téléchargé depuis le site ftp.rcsb.org 
			my $ff = File::Fetch->new(uri => 'ftp://ftp.rcsb.org/pub/pdb/data/structures/all/pdb/pdb'.$pdbFix.'.ent.gz');
			my $where = $ff->fetch(to => $dir) or die $ff->error;
			system("if [ -e ${dir}/pdb${pdbFix}.ent ]; then rm -f ${dir}/pdb${pdbFix}.ent; gunzip ${dir}/pdb${pdbFix}.ent.gz; else gunzip ${dir}/pdb${pdbFix}.ent.gz; fi");

			return $dir;

		} else {
			print "You have to choose a directory\n";
			# if($type eq "PDBcode"){
			# 	$dir = $mw->chooseDirectory(-initialdir => '.',
		 #                            	    -title => 'Choose a folder');
			# } elsif ($type eq "PDBlist"){
			# 	$dir = "Results";
			# } else {
			# 	print "Error! No such type of document\n";
			# }
		}

	} else {
			print "You have to write a PDB code\n";
	}
}

# Fonction de calculs de distances avec filtres modifiée pour etre adaptée
# à l'interface graphique.
sub calculate_Distance_Filters {
	my($dir)=@_;

	my $pdbFix = $pdb;
	$pdbFix = lc($pdbFix);

	if ($pdb ne ""){
		print qq{You chose to calculate distances between amino acids from $dir/pdb${pdbFix}.ent\n};

		my %coord = &extract_CA("$dir/pdb${pdbFix}.ent");

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
				if (($resid2 > $resid1) and ($resid2 - $resid1 > 4)){

					#On ne souhaite pas calculer les distances entre les deux mêmes résidus
					if ($i ne $j){

						my $distance = sqrt(($coordx1-$coordx2)**2+($coordy1-$coordy2)**2+($coordz1-$coordz2)**2);

						#Deuxième filtre : la distance au niveau spatial séparant 2 CA comprise entre 0 et 15 Å
						if (($distance > 0) and ($distance < 15)){
							push @Results,sprintf ("%4d %3s %4d %3s %6.3f\n",$resid1,$resname1,$resid2,$resname2,$distance);
						}
					}
				}	
			}
		}
		return @Results;
	} else {
		print "You have to write a PDB code\n";
	}
}

##############################################################################
## Génération des Résultats

# Génération des résultats si l'on agit sur un code PDB
sub results_Load {
	my $pdbFix = $pdb;
	$pdbFix = lc($pdbFix);
	
	$sw = $mw -> Toplevel();
	$sw->title("results of distances calculations");

	my $dir = &ddl_PDB("PDBcode");
	&calculate_Distance_Filters($dir);

	# Création d'une "liste" permettant de visualiser les résultats
	my $Results=$sw->Scrolled("Listbox", 
							  -scrollbars=>"e",
							  -heigh=> 30,
							  -background => 'white',
							  -width=> 50)->pack();

	$Results->insert('end', sort @Results);

	#Bouton "save" afin de sauvegarder les résultats dans un fichier
    $sw->Button(-text=>"Save", 
    			-command =>[\&save_File,@Results],
    			-background => '#FAFAFA',
    			)->pack(-side => 'left', -expand => 1, -fill => 'x');

    #Bouton pour fermer la fenetre des résultats
    $sw->Button(-text=>"Exit", 
    			-command =>sub {$sw -> destroy},
    			-background => '#FAFAFA',
    			)->pack(-side => 'left', -expand => 1, -fill => 'x');
}

# Génération des résultats si l'on agit sur une liste de codes PDB
sub results_LoadOnList {
	my $dir;
	my $open = &open_file;

	# On parcourt la liste de codes PDB
    open FILE, $open;
	while (<FILE>){
		s/\t+//g;
		s/\r//g;
		s/\s//g;

		# On vérifie que le code PDB est composé de 4 caractères si ce n'est 
		# pas le cas, on ne le traite pas
		if(/^[0-9A-Za-z]{4}$/){
			$pdb = $_;
			$dir = &ddl_PDB("PDBlist");
			my @Results = &calculate_Distance_Filters($dir);

			open TMP, "> Results/$pdb.tmp";
			print TMP sort @Results;
			close TMP;
			
			# Création d'un fichier tmp.txt dans le dossir Results servant à la concaténation des 
			# résultats de calcul pour chaque PDB
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

	# Création d'une "liste" permettant de visualiser les résultats
	my $Results=$sw->Scrolled("Listbox", 
							  -scrollbars=>"e",
							  -heigh=> 30,
							  -background => 'white',
							  -width=> 50)->pack();

	$Results->insert('end', sort @tmp);

	#Bouton "save" afin de sauvegarder les résultats dans un fichier
    $sw->Button(-text=>"Save", 
    			-command =>[\&save_File,@tmp],
    			-background => '#FAFAFA',
    			)->pack(-side => 'left', -expand => 1, -fill => 'x');

    #Bouton pour fermer la fenetre des résultats
    $sw->Button(-text=>"Exit", 
    			-command =>sub {$sw -> destroy},
    			-background => '#FAFAFA',
    			)->pack(-side => 'left', -expand => 1, -fill => 'x');

    # On supprime le fichier tmp.txt qui a servi à la concaténation des résultats de chaque PDB
    system("rm -f tmp.txt");
}