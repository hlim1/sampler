package Daikon;

use strict;
use FindBin;
use File::Basename;

use CilConfig;
use Cilly;
our @ISA = qw(Cilly);


########################################################################


my $daikon = "$FindBin::Bin/..";
my $instrumentor = "$daikon/main";
my $libdaikon = "$daikon/libdaikon";

my $root = "$daikon/../..";
my $libcountdown = "$root/libcountdown";


########################################################################


sub setDefaultArguments {
    my $self = shift;
    $self->SUPER::setDefaultArguments;
    $self->{instrumentor} = [$instrumentor];
    $self->{LD} = "libtool $self->{LD}";
    $self->{TRACE_COMMANDS} = 0;
}


sub collectOneArgument {
    my $self = shift;
    my ($arg, $pargs) = @_;

    if ($arg eq '--only') {
	push @{$self->{instrumentor}}, $arg, shift @{$pargs};
	return 1;
    } elsif ($arg =~ /^--(no-)?sample$/) {
	push @{$self->{instrumentor}}, $arg;
	return 1;
    } else {
	$self->SUPER::collectOneArgument(@_);
    }
}


sub preprocess_before_cil {
    my $self = shift;
    my @ppargs = @{(pop)};

    push @ppargs, ('-include', "$libcountdown/countdown.h",
		   '-include', "$libcountdown/cyclic.h",
		   '-include', "$libdaikon/daikon.h");
    
    $self->SUPER::preprocess_before_cil(@_, \@ppargs);
}


sub applyCil {
    my ($self, $ppsrc, $dest) = @_;
    
    my ($base, $dir, undef) = fileparse $dest, '\\.[^.]+';
    my $aftercil = "$dir$base.inst.c";

    $self->runShell("@{$self->{instrumentor}} @{$ppsrc} >$aftercil");
    return $aftercil;
}


sub link_after_cil {
    my $self = shift;
    my @ldargs = @{(pop)};

    push @ldargs, ("-L$libdaikon", '-ldaikon',
		   "-L$libcountdown", '-lcyclic');

    $self->SUPER::link_after_cil(@_, \@ldargs);
}
