package CillySampler;

use strict;
use FindBin;
use File::Basename qw(fileparse);

use Cilly;
use Sampler;
our @ISA = qw(Cilly Sampler);


########################################################################


sub setDefaultArguments {
    my $self = shift;
    $self->Cilly::setDefaultArguments;
    $self->Sampler::setDefaultArguments;
}


sub collectOneArgument {
    my $self = shift;

    $self->Sampler::collectOneArgument(@_)
	or $self->Cilly::collectOneArgument(@_);
}


sub preprocess_before_cil {
    my $self = shift;
    my @ppargs = @{(pop)};

    push @ppargs, $self->extraHeaders;

    $self->Cilly::preprocess_before_cil(@_, \@ppargs);
}


sub applyCil {
    my ($self, $ppsrc, $dest) = @_;
    
    my $aftercil = $self->cilOutputFile($dest, 'inst.c');

    $self->runShellOut($aftercil, @{$self->{instrumentor}}, @{$ppsrc});
    return $aftercil;
}


sub link_after_cil {
    my $self = shift;
    my @ldargs = @{(pop)};

    push @ldargs, '-Wl,-u,providesLibReport';
    push @ldargs, $self->extraLibs;

    $self->Cilly::link_after_cil(@_, \@ldargs);
}


########################################################################


1;
