package Upload;

use strict;

use Carp;
use DBI;
use File::Temp qw(tempfile);
use FileHandle;


########################################################################


sub new ($) {
    @_ == 1 or confess 'wrong argument count';
    my ($proto) = @_;
    my $class = ref($proto) || $proto;

    my ($handle, $filename) = tempfile(UNLINK => 1);
    my $self = {handle => $handle, filename => $filename, count => 0};

    bless $self, $class;
}


sub print ($@) {
    @_ >= 1 or confess 'wrong argument count';
    my ($self, @fields) = @_;
    ++$self->{count};
    Common::escape @fields;
    local ($,, $\) = ("\t", "\n");
    $self->{handle}->print(@fields);
}


sub count ($) {
    @_ == 1 or confess 'wrong argument count';
    my ($self) = @_;
    return $self->{count};
}


sub send ($$$) {
    @_ == 3 or confess 'wrong argument count';
    my ($self, $dbh, $table) = @_;
    $self->{handle}->flush;
    $dbh->do("LOAD DATA LOCAL INFILE ? INTO TABLE $table",
	     undef, $self->{filename}, $table)
	or die;
}


########################################################################


1;
