#!/usr/bin/perl -w

use strict;

use Common;

my $dbh = Common::connect;

my $result;
my $count;


########################################################################


# various fields should not have degenerate or default values

sub check_value ($$$$) {
    my ($table, $field_id, $field_check, $bad) = @_;

    print "checking for $table.$field_check = '$bad'\n";

    $result = $dbh->selectcol_arrayref(qq{
	SELECT DISTINCT $field_id
	    FROM $table
	    WHERE $field_check = ?
	}, undef, $bad);

    $count = @{$result};
    if ($count) {
	warn "$count distinct $field_id in $table with $field_check of '$bad':\n";
	warn "\t$_\n" foreach @{$result};
    }
}


check_value 'build', 'build_id', 'build_id', 0;
check_value 'build', 'build_id', 'application_name', '';
check_value 'build', 'build_id', 'application_version', '';
check_value 'build', 'build_id', 'application_release', '';
check_value 'build', 'build_id', 'build_date', '0000-00-00';

check_value 'instrumentation', 'instrumentation_type', 'predicates_per_site', 0;

check_value 'run', 'run_id', 'run_id', '';
check_value 'run', 'run_id', 'version', '';
check_value 'run', 'run_id', 'sparsity', 0;
check_value 'run', 'run_id', 'date', '0000-00-00';


########################################################################


# runs cannot have both a fatal signal and a non-zero exit status

print "checking for runs with both signal and exit status\n";

$result = $dbh->selectcol_arrayref(q{
    SELECT run_id
	FROM run
	WHERE exit_status
	AND exit_signal});

$count = @{$result};
if ($count) {
    warn "$count runs with both fatal signal and non-zero exit status\n";
    warn "\t$_\n" foreach @{$result};
}


########################################################################


$dbh->commit;
$dbh->disconnect;

exit 0;
