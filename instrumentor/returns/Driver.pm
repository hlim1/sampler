package Driver;

use strict;
use FindBin;

use CillySampler;
our @ISA = qw(CillySampler);


########################################################################


sub extraHeaders {
    my $self = shift;
    my @extras = $self->SUPER::extraHeaders;
    push @extras, '-include', "$::root/libreport/requires.h";
    push @extras, '-include', "$::home/libreturns/returns.h";
    push @extras, '-include', "$::root/libtuples/tuples-cil.h";
    return @extras;
}


sub extraLibs {
    my $self = shift;
    my @extras = $self->SUPER::extraLibs;
    push @extras, "-L$::root/libreport", '-lreport';
    push @extras, "-L$::home/libreturns", '-lreturns';
    return @extras;
}


########################################################################


1;
