#!/usr/bin/perl -w

use strict;

use Common;

my $dbh = Common::connect;

my $column;
my $count;


########################################################################


# runs marked as empty should never have samples

$column = $dbh->selectcol_arrayref(q{
    SELECT DISTINCT run.run_id
	FROM run
	NATURAL JOIN run_sample
	WHERE empty});

$count = @{$column};
if ($count) {
    warn "$count runs with samples in run_sample but marked empty in run:\n";
    print "\t$_\n" foreach @{$column};
}


########################################################################


# runs not marked as empty should always have samples

$column = $dbh->selectcol_arrayref(q{
    SELECT DISTINCT run.run_id
	FROM run
	NATURAL LEFT JOIN run_sample
	WHERE run_sample.run_id IS NULL
	AND NOT empty});

$count = @{$column};
if ($count) {
    warn "$count runs without samples in run_sample but not marked empty in run\n";
    print "\t$_\n" foreach @{$column};
}


########################################################################


# runs cannot have both a fatal signal and a non-zero exit status

$column = $dbh->selectcol_arrayref(q{
    SELECT run_id
	FROM run
	WHERE exit_status
	AND exit_signal});

$count = @{$column};
if ($count) {
    warn "$count runs with both fatal signal and non-zero exit status\n";
    print "\t$_\n" foreach @{$column};
}


########################################################################


$dbh->commit;
$dbh->disconnect;

exit 0;
