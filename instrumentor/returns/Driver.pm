package Driver;

use strict;

use CillySampler;
our @ISA = qw(CillySampler);


########################################################################


sub extraHeaders {
    my $self = shift;
    my @extras = $self->SUPER::extraHeaders;
    push @extras, '-include', "$::home/libreturns/returns.h";
    push @extras, '-include', "$::root/lib/requires.h";
    push @extras, '-include', "$::root/lib/unit.h";
    push @extras, '-include', "$::root/lib/tuples-cil.h";
    return @extras;
}


sub extraLibs {
    my $self = shift;
    my @extras = $self->SUPER::extraLibs;
    push @extras, '-lpthread' if $self->threading;
    push @extras, "-L$::home/libreturns", '-lreturns';
    return @extras;
}


########################################################################


1;
