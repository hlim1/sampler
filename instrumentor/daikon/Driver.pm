package Driver;

use strict;

use CillySampler;
our @ISA = qw(CillySampler);


########################################################################


sub extraHeaders {
    my $self = shift;
    my @extras = $self->SUPER::extraHeaders;
    push @extras, '-include', "$::scheme/daikon-cil.h";
    return @extras;
}


sub extraLibs {
    my $self = shift;
    my @extras = $self->SUPER::extraLibs;
    push @extras, "-L$::scheme", '-ldaikon';
    return @extras;
}


########################################################################


1;
