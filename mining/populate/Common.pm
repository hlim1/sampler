package Common;

use strict;

use DBI;

use Site;


########################################################################


sub connect () {
    my %options = (AutoCommit => 0, RaiseError => 1);
    return DBI->connect("DBI:mysql:$Site::database", $Site::user, $Site::password, \%options);
}


sub read_app_id ($) {
    my ($subprocess) = (@_);
    my $app_id = <$subprocess>;
    defined $app_id or exit 1;

    chomp $app_id;
    my @app_id = split /\t/, $app_id;
    @app_id == 3 or die "\tmangled name-version-release: $app_id";
    $app_id[0] =~ s/-samplerinfo$// or die "\tmangled name: $app_id[0]\n";

    return @app_id;
}


sub check_signature ($$$) {
    my ($filename, $lineno, $signature) = @_;
    die "$filename:$lineno: malformed signature: $signature\n"
	unless $signature =~ /^[0-9A-Fa-f]{32}\z/;
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
