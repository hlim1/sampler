package Logging;

use strict;
use FindBin;
use File::Basename;

use Cilly;
use Instrumentor;
our @ISA = qw(Cilly Instrumentor);


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
    $self->{LD} = "libtool $self->{LD}";
    $self->{cycle} = 'acyclic';
}


sub collectOneArgument {
    my $self = shift;
    my ($arg) = @_;

    if ($arg eq '--cyclic') {
	$self->{cycle} = 'cyclic';
	return 1;
    } elsif ($arg eq '--acyclic') {
	$self->{cycle} = 'acyclic';
	return 1;
    } else {
	$self->SUPER::collectOneArgument(@_);
    }
}


sub preprocess_before_cil {
    my $self = shift;
    my @ppargs = @{(pop)};

    push @ppargs, ('-include', "$libcountdown/countdown.h",
		   '-include', "$libcountdown/$self->{cycle}.h",
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
		   "-L$libcountdown", '-lcountdown', "-l$self->{cycle}",
		   `gsl-config --libs`);

    $self->SUPER::link_after_cil(@_, \@ldargs);
}
