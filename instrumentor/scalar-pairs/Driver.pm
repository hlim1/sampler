package Driver;

use strict;

use CillySampler;
our @ISA = qw(CillySampler);


########################################################################


sub collectOneArgument {
    my $self = shift;
    my ($arg, $pargs) = @_;

    if ($arg =~ /^--(no-)?compare-constants$/) {
	push @{$self->{instrumentor}}, $arg;
	return 1;
    } else {
	return $self->CillySampler::collectOneArgument(@_);
    }
}


sub extraHeaders {
    my $self = shift;
    my @extras = $self->SUPER::extraHeaders;
    push @extras, '-include', "$::scheme/scalar-pairs.h";
    push @extras, '-include', "$::root/lib/unit.h";
    push @extras, '-include', "$::root/lib/tuples-cil.h";
    return @extras;
}


sub extraLibs {
    my $self = shift;
    my @extras = $self->SUPER::extraLibs;
    push @extras, '-lpthread' if $self->threading;
    push @extras, "-L$::scheme", '-lscalar-pairs';
    return @extras;
}


########################################################################


1;
