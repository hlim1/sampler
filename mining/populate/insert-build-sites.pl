#!/usr/bin/perl -w

use strict;
use 5.008;			# for safe pipe opens using list form of open
use File::Path;
use File::Temp qw(tempfile tempdir unlink0);
use FileHandle;

use Common;

my $dbh = Common::connect;


########################################################################
#
#  get the list of already-known builds
#


sub get_known ($) {
    my ($dbh) = @_;
    my %known;

    my $rows = $dbh->selectall_arrayref(q{
	SELECT DISTINCT
	    application_name,
	    application_version,
	    application_release
	    FROM build natural join build_site});

    foreach my $row (@{$rows}) {
	$row = join "\t", @{$row};
	$known{$row} = 1;
    }

    return %known;
}


my %known = get_known $dbh;
print 'already known: ', scalar keys %known, "\n";


########################################################################
#
#  insert any sites from new builds
#


my ($upload, $upload_filename) = tempfile(UNLINK => 1);
my $upload_count = 0;

foreach my $package (@ARGV) {
    my @command = ('rpm', '-qp', '--qf', '%{name}\t%{version}\t%{release}\n[%{filenames}\n]', $package);
    my $rpm_query = new FileHandle;
    open $rpm_query, '-|', @command;

    # extract application name, version, release
    my @app_id = Common::read_app_id $rpm_query;
    my $app_id = join "\t", @app_id;

    # have we seen this before?
    next if exists $known{$app_id};
    $known{$app_id} = 1;
    ++$upload_count;

    # not previously seen, so unpack site information
    print "new: $package\n";
    print "\tunpack cpio\n";
    my $tempdir = tempdir(CLEANUP => 1);
    $ENV{package} = $package;
    system("rpm2cpio \$package | ( cd $tempdir && cpio -id --quiet --no-absolute-filenames; )") == 0
	or die "cpio extraction failed: $?\n";

    # grovel through site information
    print "\tcollect sites\n";

    while (my $filename = <$rpm_query>) {
	chomp $filename;
	next unless $filename =~ /^\/usr\/lib\/sampler\/sites\/.*\.sites$/;

	my $extracted = "$tempdir$filename";
	die "missing file: $filename\n" unless -e $extracted;
	next if -d $extracted;

	local ($,, $\) = ("\t", "\n");
	my $contents = new FileHandle($extracted);
	while (my $unit_signature = <$contents>) {
	    chomp $unit_signature;
	    Common::check_signature $extracted, $contents->input_line_number, $unit_signature;

	    my $site_order = 0;
	    while (my $description = <$contents>) {
		chomp $description;
		last unless $description;
		my @fields = (@app_id, $unit_signature, $site_order, $description);
		Common::escape @fields;
		print $upload @fields;
		++$site_order;
	    }
	}
    }

    print "\tclean cpio\n";
    rmtree $tempdir;

    $rpm_query->close;
    if ($?) {
	print "rpm command failed: $?";
        exit($? >> 8 || $?);
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
	(application_name VARCHAR(50) NOT NULL,
	 application_version VARCHAR(50) NOT NULL,
	 application_release VARCHAR(50) NOT NULL,

	 unit_signature CHAR(32) NOT NULL,
	 site_order INTEGER UNSIGNED NOT NULL,

	 source_name VARCHAR(255) NOT NULL,
	 line_number INTEGER UNSIGNED NOT NULL,
	 function VARCHAR(255) NOT NULL,
	 operand_0 VARCHAR(255) NOT NULL,
	 operand_1 VARCHAR(255))

	TYPE=InnoDB
    }) or die;

$dbh->do(q{
    LOAD DATA LOCAL INFILE ?
	INTO TABLE upload
    },
	 undef, $upload_filename)
    or die;


########################################################################
#
#  merge into existing table
#


print "insert\n";

$dbh->do(q{
    INSERT
	IGNORE
	INTO build_site

	(build_id, unit_signature, site_order,
	 source_name, line_number, function, operand_0, operand_1)

	SELECT build_id, unit_signature, site_order,
	source_name, line_number, function, operand_0, operand_1

	FROM build NATURAL JOIN upload
    }) or die;


########################################################################
#
#  finish up
#


print "newly added: $upload_count\n";

$dbh->commit;
$dbh->disconnect;
