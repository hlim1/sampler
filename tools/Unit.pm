package Unit;

use strict;

use Embedded;
use Function;
use SymbolTable;

our @ISA = ('Embedded');


########################################################################


sub new ($$$) {
    my $proto = shift;
    my $class = ref($proto) || $proto;
    my $self = $class->SUPER::new(@_);
    bless $self, $class;

    my ($objectName, $handle) = ($self->{objectName}, $self->{handle});
    local $_ = <$handle>;
    return unless defined $_;
    chomp;
    return if $_ eq '';

    $_ eq "*\t0.0" or $self->malformed('compilation unit signature');
    $self->{functions} = new SymbolTable;

    while (my $function = new Function $self) {
	my $name = $function->{name};
	$self->{functions}->add($function);
    }

    return $self;
}


sub collectExports ($$) {
    my ($self, $exports) = @_;

    foreach (values %{$self->{functions}}) {
	print "collecting exports from $self .. $_->{name}\n";
	$exports->add($_) if $_->{linkage} eq '+';
    }
}


sub resolveCallees ($$) {
    my ($self, $exports) = @_;

    foreach (values %{$self->{functions}}) {
	print "resolving callees within $self .. $_->{name}\n";
	$_->resolveCallees($self->{functions}, $exports);
    }
}


########################################################################


1;
