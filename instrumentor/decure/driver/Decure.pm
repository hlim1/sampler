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
    $self->{only} = '';
    $self->{LD} = "libtool $self->{LD}";
}


sub collectOneArgument {
    my $self = shift;
    my ($arg, $pargs) = @_;

    if ($arg eq '--only') {
	$self->{only} = shift @{$pargs};
	return 1;
    } else {
	$self->SUPER::collectOneArgument(@_);
    }
}


sub preprocess_after_cil {
    my $self = shift;
    my @ppargs = @{(pop)};

    push @ppargs, ('-include', "$libcountdown/countdown.h",
		   '-include', "$libcountdown/cyclic.h",
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

    push @ldargs, "-L$libcountdown", '-lcyclic';

    $self->SUPER::link_after_cil(@_, \@ldargs);
}


########################################################################


1;
