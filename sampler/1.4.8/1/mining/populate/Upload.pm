package Upload;

use strict;

use Carp;
use DBI;
use File::Temp qw(tempfile);
use FileHandle;

use Site;


########################################################################


sub new ($$$) {
    @_ == 3 or confess 'wrong argument count';
    my ($proto, $dbh, $table) = @_;
    my $class = ref($proto) || $proto;

    $dbh->do("COPY $table FROM STDIN") or die;

    my $self = {dbh => $dbh, table => $table, count => 0};
    bless $self, $class;
}


sub row ($@) {
    @_ >= 1 or confess 'wrong argument count';
    my ($self, @fields) = @_;
    ++$self->{count};
    Common::escape @fields;
    my $row = join "\t", @fields;
    $self->{dbh}->func("$row\n", 'putline');
}


sub count ($) {
    @_ == 1 or confess 'wrong argument count';
    my ($self) = @_;
    return $self->{count};
}


sub done ($) {
    @_ == 1 or confess 'wrong argument count';
    my ($self) = @_;

    $self->{dbh}->func("\\.\n", 'putline');
    $self->{dbh}->func('endcopy');
}


########################################################################


1;
