package Logging;

use strict;
use FindBin;
use File::Basename;

use CillySampler;
our @ISA = qw(CillySampler);



########################################################################


sub new {
    my $proto = shift;
    my $instrumentor = shift or die;
    my $class = ref($proto) || $proto;
    my $self = $class->SUPER::new(@_);

    $self->{instrumentor} = $instrumentor;

    return $self;
}


sub root {
    my $self = shift;
    return "$self->{home}/../..";
}


sub setDefaultArguments {
    my $self = shift;

    $self->SUPER::setDefaultArguments;

    $self->{home} = "$FindBin::Bin/..";
    $self->{liblog} = $self->root . '/liblog';
}


sub preprocess_before_cil {
    my $self = shift;
    my @ppargs = @{(pop)};

    push @ppargs, ('-include', "$self->{liblog}/log.h",
		   '-include', "$self->{liblog}/primitive.h");
    
    $self->SUPER::preprocess_before_cil(@_, \@ppargs);
}


sub applyCil {
    my ($self, $ppsrc, $dest) = @_;
    
    my ($base, $dir, undef) = fileparse $dest, '\\.[^.]+';
    my $aftercil = "$dir$base.inst.c";

    $self->runShellOut($aftercil, $self->{instrumentor}, @{$ppsrc});
    return $aftercil;
}


sub extraLibs {
    my $self = shift;
    my @extras = $self->SUPER::extraLibs;
    push @extras, "-L$self->{liblog}", '-llog-syscall', '-llog-storage', '-llog-syscall';
    return @extras;
}
