package Function;

use strict;

use Embedded;
use Node;

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

    /^([-+])\t([\w\$]+)\t(.+)\t(\d+)$/ or $self->malformed('function header');
    ($self->{linkage}, $self->{name}, $self->{filename}, $self->{line}) = ($1, $2, $3, $4);
    $self->{nodes} = [];

    while (my $node = new Node $self) {
	$node->{id} = @{$self->{nodes}};
	push @{$self->{nodes}}, $node;
    }

    $_->resolveSuccessors($self->{nodes}) foreach @{$self->{nodes}};

    return $self;
}


sub resolveCallees ($$$) {
    my $self = shift;
    $_->resolveCallees(@_) foreach @{$self->{nodes}};
}


sub dump ($) {
    my $self = shift;

    print "\tfunction $self->{name} at $self->{filename}:$self->{line}\n";
    $_->dump foreach @{$self->{nodes}};
}


########################################################################


sub dot ($) {
    my $self = shift;

    print "\t\tsubgraph \"$self\" {\n";
    print "\t\t\tlabel=\"$self->{name}()\";\n";
    $_->dot foreach @{$self->{nodes}};
    print "\t\t}\n"
}


sub dot_calls ($) {
    my $self = shift;

    print "\t\t\"$self\" [label=\"$self->{name}\", shape=box];\n";

    my %callees;
    $_->count_callees(\%callees) foreach @{$self->{nodes}};

    while (my ($callee, $count) = each %callees) {
	print "\t\t\"$self\" -> \"$callee\"";
	print " [label=$count]" if $count > 1;
	print ";\n";
    }
}


########################################################################


1;
