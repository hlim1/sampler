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

    $self->{instrumentor} = [$instrumentor];

    return $self;
}


sub setPaths {
    my $self = shift;

    my $root = ;
    my $liblog = "$root/liblog";
    my $libcountdown = "$root/libcountdown";

    $self->{root} = "$FindBin::Bin/../../..";
    $self->{libdir} = "$daikon/libdaikon";

    $self->SUPER::setPaths(@_);
}


sub preprocess_before_cil {
    my $self = shift;
    my @ppargs = @{(pop)};

    push @ppargs, ('-include', "$liblog/log.h",
		   '-include', "$liblog/primitive.h");
    
    $self->SUPER::preprocess_before_cil(@_, \@ppargs);
}


sub applyCil {
    my ($self, $ppsrc, $dest) = @_;
    
    my ($base, $dir, undef) = fileparse $dest, '\\.[^.]+';
    my $aftercil = "$dir$base.inst.c";

    $self->runShellOut($aftercil, $self->{instrumentor}, @{$ppsrc});
    return $aftercil;
}


sub link_after_cil {
    my $self = shift;
    my @ldargs = @{(pop)};

    push @ldargs, ("-L$liblog", '-llog-syscall', '-llog-storage', '-llog-syscall',
		   "-L$libcountdown", '-lcyclic');

    $self->SUPER::link_after_cil(@_, \@ldargs);
}
