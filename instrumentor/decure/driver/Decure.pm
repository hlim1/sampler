package Decure;

use strict;
use FindBin;
use File::Basename;

use CCured;
use Sampler;
our @ISA = qw(CCured Sampler);


my $libcountdown = "$FindBin::Bin/../../../libcountdown";


########################################################################


sub root {
    my $self = shift;
    return "$self->{home}/../..";
}


sub setDefaultArguments {
    my $self = shift;

    $self->CCured::setDefaultArguments;
    $self->Sampler::setDefaultArguments;

    $self->{TRACE_COMMANDS} = 1;
    $self->{home} = "$FindBin::Bin/..";
    $self->{instrumentor} = ["$self->{home}/main"];
}


sub collectOneArgument {
    my $self = shift;

    $self->Sampler::collectOneArgument(@_)
	or $self->CCured::collectOneArgument(@_);
}


sub preprocess_after_cil {
    my $self = shift;
    my @ppargs = @{(pop)};

    push @ppargs, $self->extraHeaders;
    
    $self->CCured::preprocess_after_cil(@_, \@ppargs);
}


sub compile_cil {
    my $self = shift;
    my $input = shift;

    my $base = basename $input, ".i";
    my $output = "${base}_inst.c";
    my $instrumentor = "$FindBin::Bin/../main";
    $self->runShellOut($output, @{$self->{instrumentor}}, $input);

    $self->CCured::compile_cil($output, @_);
}


sub link_after_cil {
    my $self = shift;
    my @ldargs = @{(pop)};

    push @ldargs, $self->extraLibs;

    $self->CCured::link_after_cil(@_, \@ldargs);
}


########################################################################


1;
