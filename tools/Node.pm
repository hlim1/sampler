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
    
    print "$self->{filename}:$self->{line}:\tnode\n";

    $_ = <$handle>;
    chomp;
    /^(\d+\t)*$/ or $self->malformed('successors list');
    my @successors = split /\t/;
    $self->{successors} = \@successors;
    print "$self->{filename}:$self->{line}:\t\tsuccs: @successors\n" if @successors;

    $_ = <$handle>;
    chomp;
    my @callees;
    if ($_ ne '???') {
	/^([\w\$]+\t)*$/ or self->malformed('callees list');
	@callees = split /\t/;
	$self->{callees} = \@callees;
	print "$self->{filename}:$self->{line}:\t\tcallees: @callees\n" if @callees;
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
	} else {
	    warn "unresolved callee: $_";
	}
	print "$old resolved to $_\n";
    }
}


########################################################################


1;
