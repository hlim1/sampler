package Decure;

use strict;
use FindBin;
use File::Basename;

use CCured;
our @ISA = qw(CCured);


my $libcountdown = "$FindBin::Bin/../../../libcountdown";


########################################################################


sub setDefaultArguments {
    my $self = shift;
    $self->SUPER::setDefaultArguments;
    $self->{LD} = "libtool $self->{LD}";
    $self->{cycle} = 'acyclic';
}


sub collectOneArgument {
    my $self = shift;
    my ($arg) = @_;

    if ($arg eq '--only') {
	$self->{only} = shift @{$pargs};
	return 1;
    } elsif ($arg eq '--cyclic') {
	$self->{cycle} = 'cyclic';
	return 1;
    } elsif ($arg eq '--acyclic') {
	$self->{cycle} = 'acyclic';
	return 1;
    } else {
	$self->SUPER::collectOneArgument(@_);
    }
}


sub preprocess_after_cil {
    my $self = shift;
    my @ppargs = @{(pop)};

    push @ppargs, ('-include', "$libcountdown/countdown.h",
		   '-include', "$libcountdown/$self->{cycle}.h",
		   '-include', "$FindBin::Bin/../../libdecure/decure.h");
    
    $self->SUPER::preprocess_after_cil(@_, \@ppargs);
}


sub compile_cil {
    my $self = shift;
    my $input = shift;

    my $base = basename $input, ".i";
    my $output = "${base}_inst.c";
    my $instrumentor = "$FindBin::Bin/../main";
    $self->runShell("$instrumentor --only '$self->{only}' $input >$output");

    $self->SUPER::compile_cil($output, @_);
}


sub link_after_cil {
    my $self = shift;
    my @ldargs = @{(pop)};

    push @ldargs, "-L$libcountdown", '-lcountdown', "-l$self->{cycle}", '-lcountdown';
    push @ldargs, `gsl-config --libs`;

    $self->SUPER::link_after_cil(@_, \@ldargs);
}


########################################################################


1;
