package RawSamples;

use strict;
use 5.008;		 # for safe pipe opens using list form of open

use TaggedLoader;
our @ISA = qw(TaggedLoader);


########################################################################


sub new ($) {
    my ($proto) = @_;
    my $class = ref($proto) || $proto;
    my $self = $class->SUPER::new('samples');
    bless $self, $class;
}


sub merge ($\@\@) {
    my ($self, $old, $new) = @_;

    return undef unless @{$old} == @{$new};

    my @sum;

    foreach (0 .. $#{$new}) {
	my @oldTuple = split /\t/, $old->[$_];
	my @newTuple = split /\t/, $new->[$_];
	return undef unless @oldTuple = @newTuple;

	my @sumTuple;
	$sumTuple[$_] = $oldTuple[$_] + $newTuple[$_]
	    foreach 0 .. $#newTuple;

	$sum[$_] = join "\t", @sumTuple;
    }
}


########################################################################


1;
