package Driver;

use strict;
use FindBin;

use CCured;
use Sampler
our @ISA = qw(CCured Sampler);


########################################################################


sub setDefaultArguments {
    my $self = shift;
    $self->CCured::setDefaultArguments;
    $self->Sampler::setDefaultArguments;
}


sub collectOneArgument {
    my $self = shift;

    $self->Sampler::collectOneArgument(@_)
	or $self->CCured::collectOneArgument(@_);
}


sub preprocess_compile {
    my $self = shift;

    if ($ENV{SAMPLER_ALREADY_CURED}) {
	my ($src, $dest, $early_ppargs, $ppargs, $ccargs) = @_;
	my $aftercilpp = $self->preprocessAfterOutputFile($src);
	$self->preprocess_after_cil($src, $aftercilpp, $ppargs);
	return $self->compile_cil($aftercilpp, $dest, $ppargs, $ccargs);
    } else {
	return $self->CCured::applyCilAndCompile(@_);
    }
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

    my $output = $self->cilOutputFile($input, 'inst.c');
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
