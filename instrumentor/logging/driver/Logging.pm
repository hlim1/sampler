package Logging;

use strict;
use FindBin;
use File::Basename;

use Cilly;
our @ISA = qw(Cilly);


########################################################################


my $root = "$FindBin::Bin/../../..";
my $liblog = "$root/liblog";
my $libcountdown = "$root/libcountdown";


########################################################################


sub new {
    my $proto = shift;
    my $instrumentor = shift or die;
    my $class = ref($proto) || $proto;
    my $self = $class->SUPER::new(@_);

    $self->{instrumentor} = $instrumentor;

    return $self;
}


sub setDefaultArguments {
    my $self = shift;
    $self->SUPER::setDefaultArguments;
    $self->{LD} = "libtool $self->{LD}";
}


sub preprocess_before_cil {
    my $self = shift;
    my @ppargs = @{(pop)};

    push @ppargs, ('-include', "$libcountdown/countdown.h",
		   '-include', "$libcountdown/cyclic.h",
		   '-include', "$liblog/log.h",
		   '-include', "$liblog/primitive.h");
    
    $self->SUPER::preprocess_before_cil(@_, \@ppargs);
}


sub applyCil {
    my ($self, $ppsrc, $dest) = @_;
    
    my ($base, $dir, undef) = fileparse $dest, '\\.[^.]+';
    my $aftercil = "$dir$base.inst.c";

    $self->runShell("$self->{instrumentor} @{$ppsrc} >$aftercil");
    return $aftercil;
}


sub link_after_cil {
    my $self = shift;
    my @ldargs = @{(pop)};

    push @ldargs, ("-L$liblog", '-llog-syscall', '-llog-storage', '-llog-syscall',
		   "-L$libcountdown", '-lcyclic');

    $self->SUPER::link_after_cil(@_, \@ldargs);
}
