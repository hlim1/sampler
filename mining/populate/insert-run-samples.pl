#!/usr/bin/perl -w

use strict;

use DBI;
use File::Basename;
use File::Temp qw(tempfile);
use FileHandle;


########################################################################


use Common;

my $dbh = Common::connect;


########################################################################
#
#  get the list of reports with no samples, excluding known empties
#


sub get_missing ($) {
    my ($dbh) = @_;
    my $column = $dbh->selectcol_arrayref(q{
	SELECT run.run_id
	    FROM run
	    LEFT JOIN run_sample USING (run_id)
	    WHERE run_sample.run_id IS NULL
	    AND NOT empty
	});

    print 'missing: ', scalar @{$column}, "\n";

    my %missing;
    $missing{$_} = 1 foreach @{$column};
    return %missing;
}


my %missing = get_missing $dbh;


########################################################################
#
#  insert any new reports
#


my ($upload, $upload_filename) = tempfile(UNLINK => 1);
my $upload_count = 0;
my @empties;

foreach my $dir (@ARGV) {
    my $run_id = basename $dir;
    next unless $missing{$run_id};
    print "reading samples for $dir\n";
    ++$upload_count;

    local ($,, $\) = ("\t", "\n");

    my $samples_filename = "$dir/samples.gz";
    my $samples_handle = new FileHandle;
    open $samples_handle, '-|', 'zcat', $samples_filename;
    my $empty = 1;

    while (my $unit_signature = <$samples_handle>) {
	chomp $unit_signature;
	Common::check_signature $samples_filename, $samples_handle->input_line_number, $unit_signature;

	my $site_order = 0;

	while (my $counts = <$samples_handle>) {
	    unless ($counts =~ /^0(\t0)*$/) {
		chomp $counts;
		last if $counts eq '';
		my @counts = split /\t/, $counts;
		foreach my $predicate (0 .. $#counts) {
		    my $count = $counts[$predicate];
		    next unless $count;
		    my @fields = ($run_id, $unit_signature, $site_order, $predicate, $count);
		    Common::escape @fields;
		    print $upload @fields;
		}
		$empty = 0;
	    }
	    ++$site_order;
	}
    }

    push @empties, $run_id if $empty;
}

close $upload;


########################################################################
#
#  bulk upload
#


print "upload\n";

$dbh->do(q{
    CREATE TEMPORARY TABLE upload
	(run_id VARCHAR(24) NOT NULL,
	 unit_signature CHAR(32) NOT NULL,
	 site_order INTEGER UNSIGNED NOT NULL,
	 predicate TINYINT UNSIGNED NOT NULL,
	 count INTEGER UNSIGNED NOT NULL)
	TYPE=InnoDB
    }) or die;

$dbh->do(q{
    LOAD DATA LOCAL INFILE ?
	INTO TABLE upload},
	 undef, $upload_filename);

unlink $upload_filename;


########################################################################
#
#  merge into existing table
#


print "insert\n";

$dbh->do(q{
    INSERT run_sample
	SELECT *
	FROM upload
    }) or die;


########################################################################
#
#  flag empties
#


if (@empties) {
    my @placeholders = map '?', @empties;
    my $placeholders = join ',', @placeholders;

    $dbh->do(qq{
	UPDATE run
	    SET empty = 1
	    WHERE run_id IN ($placeholders)},
	     undef, @empties);

    print "marked ", scalar @empties, " new empties\n";
}


########################################################################
#
#  finish up
#


$dbh->commit;
$dbh->disconnect;
