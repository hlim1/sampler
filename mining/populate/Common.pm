package Common;

use strict;

use DBI;

use Site;


########################################################################


sub connect () {
    my %options = (AutoCommit => 0, RaiseError => 1);
    return DBI->connect("DBI:mysql:$Site::database", $Site::user, $Site::password, \%options);
}


sub parse_signature ($$$$) {
    my ($tag, $filename, $lineno, $signature) = @_;
    return ($1, undef) if $signature =~ /^([0-9A-Fa-f]{32})\z/;
    return ($1, $2) if $signature =~ qr{^<$tag unit="([0-9A-Fa-f]{32})" scheme="([-a-z]+)">\z};
    return undef;
}


sub escape (\@) {
    my ($fields) = @_;
    foreach (@{$fields}) {
	if (defined $_) {
	    $_ =~ s/\\/\\\\/g;
	    $_ =~ s/[^[:print:]]/\\$&/g;
	} else {
	    $_ = '\N';
	}
    }
}


########################################################################


1;
