package Sampler;

use strict;

use CilConfig;
use FindBin;


########################################################################


sub setDefaultArguments {
    my $self = shift;

    $self->{countdowns} = 'acyclic';
    $self->{sample_events} = 1;
    $self->{TRACE_COMMANDS} = 0;
    $self->{instrumentor} = ["$::home/main"];
    $self->{threads} = 0;
}


sub isThreadFlag {
    my ($self, $flag) = @_;

    return 1 if $flag eq '-pthread';
    return 1 if $flag =~ /^-D_REENTRANT($|=)/;
    return 1 if $flag =~ /^-D_THREAD_SAFE($|=)/;
    return 1 if $flag eq '-lpthread';

    return 0;
}


sub collectOneArgument {
    my $self = shift;
    my ($arg, $pargs) = @_;

    if ($arg =~ /^--(in|ex)clude-(function|file)$/) {
	push @{$self->{instrumentor}}, $arg, shift @{$pargs};
	return 1;
    } elsif ($arg eq '--no-sample') {
	push @{$self->{instrumentor}}, $arg;
	$self->{sample_events} = 0;
	return 1;
    } elsif ($arg eq '--sample') {
	push @{$self->{instrumentor}}, $arg;
	$self->{sample_events} = 1;
	return 1;
    } elsif ($arg =~ /^--(no-)?show-phase-times$/) {
	push @{$self->{instrumentor}}, $arg;
	return 1;
    } elsif ($arg =~ /^--(no-)?debug-weighty$/) {
	push @{$self->{instrumentor}}, $arg;
	return 1;
    } elsif ($arg =~ /^--(a?cyclic)$/) {
	$self->{countdowns} = $1;
	return 1;
    } elsif ($arg =~ /^--(no-)?show-stats$/) {
	push @{$self->{instrumentor}}, $arg;
	return 1;
    } elsif ($arg =~ /^--(no-)?specialize-(singleton|empty)-regions$/) {
	push @{$self->{instrumentor}}, $arg;
	return 1;
    } elsif ($arg =~ /^--(no-)?use-points-to$/) {
	push @{$self->{instrumentor}}, $arg;
	return 1;
    } elsif ($arg eq '--no-threads') {
	push @{$self->{instrumentor}}, $arg;
	$self->{threads_override} = 0;
	return 1;
    } elsif ($arg =~ '--threads') {
	$::have_thread_storage
	    or die "cannot instrument multithreaded applications on this platform\n";
	push @{$self->{instrumentor}}, $arg;
	$self->{threads_override} = 1;
	return 1;
    } else {
	$self->{threads} = 1 if $self->isThreadFlag($arg);
	return 0;
    }
}


########################################################################


sub runShellOut {
    my ($self, $out, @cmd) = @_;
    open OLDOUT, '>&STDOUT' or die "cannot dup stdout: $!\n";
    open STDOUT, '>', $out->filename or die "cannot redirect stdout: $!\n";

    $self->runShell(@cmd);

    close STDOUT;
    open STDOUT, '>&OLDOUT' or die "cannot restore stdout: $!\n";
    tell OLDOUT;		# avoid single-use warning
}


########################################################################


sub sampling {
    my $self = shift;
    return $self->{sample_events};
}


sub threading {
    my $self = shift;
    return $self->{threads_override} if defined $self->{threads_override};
    return $self->{threads};
}


sub extraHeaders {
    my $self = shift;
    my @extras;

    push @extras, '-DCIL';
    push @extras, '-include', "$::root/lib/" . ($self->threading ? 'threads.h' : 'no-threads.h');
    push @extras, '-include', "$::root/lib/countdown.h" if $self->sampling;
    push @extras, '-include', "$::root/lib/$self->{countdowns}.h" if $self->{sample_events};

    return @extras;
}


sub extraLibs {
    my $self = shift;
    my @extras;

    if ($self->sampling) {
	my $_r = $self->threading ? '_r' : '';
	push @extras, '-Wl,--wrap,pthread_create' if $self->threading;
	push @extras, "-L$::root/lib", "-lsampler$_r";
	push @extras, $::libm if $::libm && $self->{countdowns} eq 'acyclic';
    }

    return @extras;
}


########################################################################


1;
