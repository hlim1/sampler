package TaggedLoader;

use strict;


########################################################################


sub new ($$) {
    my ($proto, $element) = @_;
    my $class = ref($proto) || $proto;
    my $self = { element => $element };
    bless $self, $class;
}


sub find ($$$) {
    my ($self, $unit, $scheme) = @_;
    return @{$self->{lines}{$unit}{$scheme}};
}


sub foreach ($\&) {
    my ($self, $handler) = @_;

    foreach my $unit (sort keys %{$self->{lines}}) {
	foreach my $scheme (sort keys %{$self->{lines}{$unit}}) {
	    $handler->($unit, $scheme, @{$self->{lines}{$unit}{$scheme}});
	}
    }
}


sub decode_start_tag ($$) {
    my ($self, $received) = @_;
    $received =~ /\A<$self->{element} unit="([0-9a-f]{32})" scheme="([-a-z]+)">\Z/
	or die "malformed $self->{element} start tag: $received\n";

    return ($1, $2);
}


sub read ($$) {
    my ($self, $handle) = @_;

    while (my $tag = <$handle>) {
	my ($unit, $scheme) = $self->decode_start_tag($tag);

	my @lines;
	while (my $line = <$handle>) {
	    last if $line =~ /\A<\/$self->{element}>\Z/;
	    chomp $line;
	    push @lines, $line;
	}

	my $prior = $self->{lines}{$unit}{$scheme};
	my $merged;

	if (defined $prior) {
	    $merged = $self->merge($unit, $scheme, $prior, \@lines);
	    die "cannot merge multiple instances of unit $unit, scheme $scheme\n";
	} else {
	    $merged = \@lines;
	}

	$self->{lines}{$unit}{$scheme} = $merged;
    }
}


########################################################################


1;
