package Decure;

use strict;
use FindBin;
use File::Basename;

use lib "$FindBin::Bin/../../cil/bin";
use lib "$FindBin::Bin/../../cil/lib";
use CCured;
our @ISA = qw(CCured);


my $libcountdown = "$FindBin::Bin/../../../libcountdown";


########################################################################


sub preprocess_after_cil {
    my $self = shift;
    my $ppargs = pop;

    my @ppargs = ('-include', "$FindBin::Bin/../libdecure/decure.h",
		  '-include', "$libcountdown/countdown.h",
		  @{$ppargs});
    
    $self->SUPER::preprocess_after_cil(@_, \@ppargs);
}


sub compile_cil {
    my $self = shift;
    my $input = shift;

    my $base = basename $input, ".i";
    my $output = "${base}_inst.c";
    my $instrumentor = "$FindBin::Bin/../main";
    $self->runShell("$instrumentor $input >$output");

    $self->SUPER::compile_cil($output, @_);
}


sub link_after_cil {
    my $self = shift;
    my $ldargs = pop;

    push @{$ldargs}, "-Wl,-rpath,$libcountdown";
    push @{$ldargs}, "-L$libcountdown", '-lcountdown';

    $self->SUPER::link_after_cil(@_, $ldargs);
}
