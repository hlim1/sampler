package Node;

use strict;

use Embedded;

our @ISA = ('Embedded');


########################################################################


sub new {
    my $proto = shift;
    my $class = ref($proto) || $proto;
    my $self = $class->SUPER::new(@_);
    bless $self, $class;

    my $handle = $self->{handle};
    local $_ = <$handle>;
    chomp;
    return if $_ eq '';

    /^(.+)\t(\d+)$/ or $self->malformed('function header');
    ($self->{filename}, $self->{line}) = ($1, $2);
    
    $_ = <$handle>;
    chomp;
    /^(\d+\t)*$/ or $self->malformed('successors list');
    my @successors = split /\t/;
    $self->{successors} = \@successors;

    $_ = <$handle>;
    chomp;
    my @callees;
    if ($_ ne '???') {
	/^([\w\$]+\t)*$/ or self->malformed('callees list');
	@callees = split /\t/;
	$self->{callees} = \@callees;
    }

    return $self;
}


sub resolveSuccessors ($$) {
    my ($self, $peers) = @_;
    $peers->[$self->{id}] == $self or die "inconsistent node ordering";

    $_ = $peers->[$_] foreach @{$self->{successors}};
}


sub resolveCallees ($$$) {
    my ($self, $unit, $exports) = @_;

    return unless exists $self->{callees};

    foreach (@{$self->{callees}}) {
	my $old = $_;
	if (exists $unit->{$_}) {
	    $_ = $unit->{$_};
	} elsif (exists $exports->{$_}) {
	    $_ = $exports->{$_};
	}
    }
}


sub dump ($) {
    my $self = shift;

    print "\t\tnode $self->{id} at $self->{filename}:$self->{line}\n";

    if (@{$self->{successors}}) {
	print "\t\t\tsuccessors:";
	print " $_->{id}" foreach @{$self->{successors}};
	print "\n";
    }

    if (exists $self->{callees}) {
	if (@{$self->{callees}}) {
	    print "\t\t\tcallees:";
	    foreach (@{$self->{callees}}) {
		if (ref) {
		    print " $_->{name}";
		} else {
		    print " ($_)";
		}
	    }
	    print "\n";
	}
    } else {
	print "\t\t\tcallees: ???\n";
    }
}


########################################################################


1;
