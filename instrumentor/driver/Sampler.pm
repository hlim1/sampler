package Sampler;

use strict;
use FindBin;

use CilConfig;


########################################################################


sub setDefaultArguments {
    my $self = shift;

    $self->{sample_events} = 1;
    $self->{sample_funcs} = 0;
    unshift @{$self->{LD}}, 'libtool';
    $self->{TRACE_COMMANDS} = 0;
}


sub collectOneArgument {
    my $self = shift;
    my ($arg, $pargs) = @_;

    if ($arg =~ '--(in|ex)clude-(function|file)') {
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
    } elsif ($arg eq '--no-sample-funcs') {
	push @{$self->{instrumentor}}, $arg;
	$self->{sample_funcs} = 0;
	return 1;
    } elsif ($arg eq '--sample-funcs') {
	push @{$self->{instrumentor}}, $arg;
	$self->{sample_funcs} = 1;
	return 1;
    } elsif ($arg eq '--no-show-stats') {
	push @{$self->{instrumentor}}, $arg;
	return 1;
    } elsif ($arg eq '--show-stats') {
	push @{$self->{instrumentor}}, $arg;
	return 1;
    } else {
	return 0;
    }
}


########################################################################


sub runShellOut {
    my ($self, $out, @cmd) = @_;
    open my $oldOut, '>&STDOUT' or die "cannot dup stdout: $!\n";
    open STDOUT, '>', $out or die "cannot redirect stdout: $!\n";

    $self->runShell(@cmd);

    close STDOUT;
    open STDOUT, '>&', $oldOut or die "cannot restore stdout: $!\n";
}


########################################################################


sub libcountdown {
    my $self = shift;
    return $self->root . '/libcountdown';
}


sub sampling {
    my $self = shift;
    return $self->{sample_events} || $self->{sample_funcs};
}


sub extraHeaders {
    my $self = shift;
    my @extras;

    my $dir = $self->libcountdown;
    push @extras, '-include', "$dir/event.h" if $self->{sample_events};
    push @extras, '-include', "$dir/func.h" if $self->{sample_funcs};

    return @extras;
}


sub extraLibs {
    my $self = shift;
    my @extras;

    if ($self->sampling) {
	push @extras, '-L' . $self->libcountdown;
	push @extras, '-levent' if $self->{sample_events};
	push @extras, '-lfunc' if $self->{sample_funcs};
	push @extras, '-lcyclic';
    }

    return @extras;
}


########################################################################


1;
