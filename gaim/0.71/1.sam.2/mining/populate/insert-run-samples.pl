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
#  get the list of already-known sample reports
#


sub get_known ($) {
    my ($dbh) = @_;
    my $column = $dbh->selectcol_arrayref('SELECT DISTINCT run_id FROM run_sample');

    print 'already known: ', scalar @{$column}, "\n";

    my %known;
    $known{$_} = 1 foreach @{$column};
    return %known;
}


my %known = get_known $dbh;


########################################################################
#
#  insert any new reports
#


my ($upload, $upload_filename) = tempfile(UNLINK => 1);
my $upload_count = 0;

foreach my $dir (@ARGV) {
    my $run_id = basename $dir;
    next if $known{$run_id};
    $known{$run_id} = 1;
    print "reading samples for $dir\n";
    ++$upload_count;

    local ($,, $\) = ("\t", "\n");

    my $samples_filename = "$dir/samples.gz";
    my $samples_handle = new FileHandle;
    open $samples_handle, '-|', 'zcat', $samples_filename;

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
	    }
	    ++$site_order;
	}
    }
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
	(run_id, build_id,
	 unit_signature, site_order,
	 predicate, count)

	SELECT upload.run_id, build_id,
	unit_signature, site_order,
	predicate, count

	FROM upload NATURAL LEFT JOIN run
    }) or die;


########################################################################
#
#  finish up
#


$dbh->commit;
$dbh->disconnect;
