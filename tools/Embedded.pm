package Embedded;

use strict;


########################################################################


sub new ($$$) {
    my $proto = shift;
    my $class = ref($proto) || $proto;

    if (@_ == 1) {
	my $parent = shift;
	@_ = ($parent->{objectName}, $parent->{handle});
    }

    my $self = {};
    ($self->{objectName}, $self->{handle}) = @_;

    bless $self, $class;
    return $self;
}


sub malformed ($$$) {
    my ($self, $context) = @_;
    die "$self->{objectName}:", $self->{handle}->input_line_number, ": malformed $context: $_\n";
}


sub warn ($$) {
    my ($self, $message) = @_;
    warn "$self->{objectName}:", $self->{handle}->input_line_number, ": $message\n";
}


########################################################################


1;
