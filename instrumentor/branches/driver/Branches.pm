package Branches;

use strict;
use FindBin;

use CillySampler;
our @ISA = qw(CillySampler);


########################################################################


sub root {
    my $self = shift;
    return "$self->{home}/../..";
}


sub setDefaultArguments {
    my $self = shift;

    $self->SUPER::setDefaultArguments;

    $self->{home} = "$FindBin::Bin/..";
    $self->{instrumentor} = ["$self->{home}/main"];
    $self->{libdir} = "$self->{home}/libbranches";
}


sub extraHeaders {
    my $self = shift;
    my @extras = $self->SUPER::extraHeaders;
    push @extras, '-include', $self->root . '/libreport/requires.h';
    push @extras, '-include', "$self->{libdir}/branches-cil.h";
    return @extras;
}


sub extraLibs {
    my $self = shift;
    my @extras = $self->SUPER::extraLibs;
    push @extras, '-L' . $self->root . '/libreport', '-lreport';
    push @extras, "-L$self->{libdir}", '-lbranches';
    return @extras;
}


########################################################################


1;
