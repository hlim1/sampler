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
	    FROM build natural join build_module});

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
	my $module_name = $filename;
	next unless $module_name =~ s/^\/usr\/lib\/sampler\/sites(\/.*)\.sites$/$1/;

	my $extracted = "$tempdir$filename";
	die "missing file: $filename\n" unless -e $extracted;
	next if -d $extracted;

	local ($,, $\) = ("\t", "\n");

	my $contents = new FileHandle($extracted);
	while (my $unit_signature = <$contents>) {
	    chomp $unit_signature;
	    Common::check_signature $extracted, $contents->input_line_number, $unit_signature;

	    my $has_sites = 0;
	    while (my $description = <$contents>) {
		chomp $description;
		last unless $description;
		$has_sites = 1;
	    }
	    
	    next unless $has_sites;

	    my @fields = (@app_id, $module_name, $unit_signature);
	    Common::escape @fields;
	    print $upload @fields;
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

	 module_name VARCHAR(255) NOT NULL,
	 unit_signature CHAR(32) NOT NULL)
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
    INSERT INTO build_module
	(build_id, module_name, unit_signature)

	SELECT build_id, module_name, unit_signature
	FROM build NATURAL JOIN upload
    }) or die;


########################################################################
#
#  finish up
#


print "newly added: $upload_count\n";

$dbh->commit;
$dbh->disconnect;
