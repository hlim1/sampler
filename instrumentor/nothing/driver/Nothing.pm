package Nothing;

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
#     $self->{libdir} = "$self->{home}/libdaikon";
}


########################################################################


1;
