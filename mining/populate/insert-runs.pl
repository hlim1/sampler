#!/usr/bin/perl -w

use strict;

use DBI;
use File::Basename;
use File::stat;
use File::Temp qw(tempfile);
use FileHandle;
use POSIX qw(strftime);


########################################################################


use Common;

my $dbh = Common::connect;


########################################################################
#
#  get the list of already-known sample reports
#


sub get_known ($) {
    my ($dbh) = @_;
    my $column = $dbh->selectcol_arrayref('SELECT DISTINCT run_id FROM run');

    print 'already known runs: ', scalar @{$column}, "\n";

    my %known;
    $known{$_} = 1 foreach @{$column};
    return %known;
}


my %known = get_known $dbh;


########################################################################
#
#  get the list of suppressed builds
#


sub get_suppressed ($) {
    my ($dbh) = @_;
    my $rows = $dbh->selectall_arrayref(q{
	SELECT application_name, application_version, application_release
	    FROM build
	    WHERE suppress IS NOT NULL});

    print 'suppressed builds: ', scalar @{$rows}, "\n";

    my %suppressed;
    foreach my $row (@{$rows}) {
	my $app_id = join("\t", @{$row});
	$suppressed{$app_id} = 1;
    }
    return %suppressed;
}


my %suppressed = get_suppressed $dbh;


########################################################################
#
#  simple helper functions
#


my @slot = ('RUN_ID',
	    'HTTP_SAMPLER_APPLICATION_NAME',
	    'HTTP_SAMPLER_APPLICATION_VERSION',
	    'HTTP_SAMPLER_APPLICATION_RELEASE',
	    'HTTP_SAMPLER_INSTRUMENTATION_TYPE',
	    'HTTP_SAMPLER_INSTRUMENTATION_VERSION',
	    'HTTP_SAMPLER_VERSION',
	    'HTTP_SAMPLER_SPARSITY',
	    'HTTP_SAMPLER_EXIT_SIGNAL',
	    'HTTP_SAMPLER_EXIT_STATUS',
	    'DATE');


sub read_environment ($\%) {
    my ($dir, $known) = @_;
    my $run_id = basename $dir;
    return undef if exists $known->{$run_id};
    $known->{$run_id} = 1;

    my %environment = (RUN_ID => $run_id);

    my $filename = "$dir/environment";
    my $file = new FileHandle($filename) or die;
    while (my $line = <$file>) {
	$line =~ /^([^	]+)	(.*)$/ or die;
	$environment{$1} = $2;
    }

    unless (defined $environment{DATE}) {
	my $stat = stat($filename) or die;
	$environment{DATE} = strftime('%F %T', gmtime $stat->mtime);
    }

    $environment{HTTP_SAMPLER_VERSION} = '\N'
	unless defined $environment{HTTP_SAMPLER_VERSION};

    my $app_id = join("\t", @environment{@slot[1 .. 3]});
    return undef if $suppressed{$app_id};

    return \%environment;
}


sub environment_fields (\%) {
    my ($environment) = @_;
    return map { $environment->{$_} } @slot;
}


########################################################################
#
#  insert any new reports
#


my ($upload, $upload_filename) = tempfile(UNLINK => 1);
my $upload_count = 0;

foreach my $dir (@ARGV) {
    my $environment = read_environment $dir, %known;
    next unless defined $environment;
    print "new: $dir\n";
    ++$upload_count;

    local ($,, $\) = ("\t", "\n");
    my @environment = environment_fields %{$environment};
    Common::escape @environment;
    print $upload @environment;
}

close $upload;


print "upload\n";

$dbh->do(q{
    CREATE TEMPORARY TABLE upload
	(run_id VARCHAR(24) NOT NULL,
	 application_name VARCHAR(50) NOT NULL,
	 application_version VARCHAR(50) NOT NULL,
	 application_release VARCHAR(50) NOT NULL,
	 instrumentation_type ENUM('branches','returns','scalar-pairs') NOT NULL,
	 instrumentation_version VARCHAR(50) NOT NULL,
	 version VARCHAR(255),
	 sparsity INTEGER UNSIGNED NOT NULL,
	 exit_signal TINYINT UNSIGNED NOT NULL,
	 exit_status TINYINT UNSIGNED NOT NULL,
	 date DATETIME NOT NULL)
	TYPE=InnoDB
    }) or die;

$dbh->do(q{
    LOAD DATA LOCAL INFILE ?
	INTO TABLE upload},
	 undef, $upload_filename)
    or die;

unlink $upload_filename;

print "insert\n";

$dbh->do(q{
    INSERT INTO run
	SELECT
	run_id,
	build_id,
	version,
	sparsity,
	exit_signal,
	exit_status,
	date,
	0

	FROM upload
	NATURAL LEFT JOIN build
	WHERE suppress IS NULL
    }) or die;


print "added $upload_count new runs\n";


########################################################################
#
#  finish up
#


$dbh->commit;
$dbh->disconnect;
