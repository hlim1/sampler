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

check_value 'build_module', 'build_id', 'module_name', '';
check_value 'build_module', 'build_id', 'unit_signature', '';

check_value 'build_site', 'build_id', 'unit_signature', '';
check_value 'build_site', 'build_id', 'source_name', '';
check_value 'build_site', 'build_id', 'line_number', 0;
check_value 'build_site', 'build_id', 'function', '';
check_value 'build_site', 'build_id', 'operand_0', '';

check_value 'instrumentation', 'instrumentation_type', 'predicates_per_site', 0;

check_value 'run', 'run_id', 'run_id', '';
check_value 'run', 'run_id', 'version', '';
check_value 'run', 'run_id', 'sparsity', 0;
check_value 'run', 'run_id', 'date', '0000-00-00';

check_value 'run_sample', 'run_id', 'count', 0;


########################################################################


# each build should have at least one module

print "checking for builds with no modules\n";

$result = $dbh->selectcol_arrayref(q{
    SELECT DISTINCT build.build_id
	FROM build
	NATURAL LEFT JOIN build_module
	WHERE build_module.build_id IS NULL});

$count = @{$result};
if ($count) {
    warn "$count builds with no modules:\n";
    warn "\t$_\n" foreach @{$result};
}


########################################################################


# each build should have at least one site

print "checking for builds with no sites\n";

$result = $dbh->selectcol_arrayref(q{
    SELECT DISTINCT build.build_id
	FROM build
	NATURAL LEFT JOIN build_site
	WHERE build_site.build_id IS NULL});

$count = @{$result};
if ($count) {
    warn "$count builds with no sites:\n";
    warn "\t$_\n" foreach @{$result};
}


########################################################################


# runs marked as empty should never have samples

print "checking for empty runs with samples\n";

$result = $dbh->selectcol_arrayref(q{
    SELECT DISTINCT run.run_id
	FROM run
	NATURAL JOIN run_sample
	WHERE empty});

$count = @{$result};
if ($count) {
    warn "$count runs with samples in run_sample but marked empty in run:\n";
    warn "\t$_\n" foreach @{$result};
}


########################################################################


# runs not marked as empty should always have samples

print "checking for non-empty runs without samples\n";

$result = $dbh->selectcol_arrayref(q{
    SELECT DISTINCT run.run_id
	FROM run
	NATURAL LEFT JOIN run_sample
	WHERE run_sample.run_id IS NULL
	AND NOT empty});

$count = @{$result};
if ($count) {
    warn "$count runs without samples in run_sample but not marked empty in run\n";
    warn "\t$_\n" foreach @{$result};
}


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


# site appearing in run must also appear in corresponding build

print "checking for runs with sites not appearing in build\n";

$result = $dbh->selectall_arrayref(q{
    SELECT run_sample.run_id, run_sample.unit_signature, run_sample.site_order
	FROM run_sample
	INNER JOIN run
	    USING (run_id)
	LEFT JOIN build_site
	    ON run.build_id = build_site.build_id
	    AND run_sample.unit_signature = build_site.unit_signature
	    AND run_sample.site_order = build_site.site_order
	WHERE build_site.build_id IS NULL});

$count = @{$result};
if ($count) {
    warn "$count sampled sites not in corresponding build\n";
    warn "\t@{$_}\n" foreach @{$result};
}


########################################################################


$dbh->commit;
$dbh->disconnect;

exit 0;
