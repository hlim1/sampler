#!/usr/bin/perl -w

use strict;
use 5.008;			# for safe pipe opens using list form of open

use DBI;
use File::Basename;
use File::stat;
use File::Temp qw(tempfile);
use FileHandle;
use POSIX qw(strftime);

use Common;
use Upload;

my $dry_run = (@ARGV && $ARGV[0] eq '--dry-run') ? shift : undef;

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
	SELECT application_name, application_version, application_release, build_distribution
	    FROM build
	    WHERE build_suppress IS NOT NULL});

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


my @slot = ('HTTP_SAMPLER_APPLICATION_NAME',
	    'HTTP_SAMPLER_APPLICATION_VERSION',
	    'HTTP_SAMPLER_APPLICATION_RELEASE',
	    'HTTP_SAMPLER_BUILD_DISTRIBUTION',
	    'HTTP_SAMPLER_VERSION',
	    'HTTP_SAMPLER_SPARSITY',
	    'HTTP_SAMPLER_EXIT_SIGNAL',
	    'HTTP_SAMPLER_EXIT_STATUS',
	    'DATE');


sub guess_distro (\%) {
    my $environment = shift;
    my $instrumentor = $environment->{HTTP_SAMPLER_INSTRUMENTOR_VERSION};
    return 'fedora-1-i386' if $instrumentor eq '0.9.1';
    return 'redhat-9-i386';
}


sub read_environment ($\%) {
    my ($dir, $known) = @_;

    my $filename = "$dir/environment";
    my $file = new FileHandle($filename) or die "cannot read $filename: $!";
    my %environment;

    while (my $line = <$file>) {
	$line =~ /^([^	]+)	(.*)$/ or die;
	$environment{$1} = $2;
    }

    unless (defined $environment{HTTP_SAMPLER_BUILD_DISTRIBUTION}) {
	$environment{HTTP_SAMPLER_BUILD_DISTRIBUTION} =
	    guess_distro %environment;
    }

    unless (defined $environment{DATE}) {
	my $stat = stat($filename) or die;
	$environment{DATE} = strftime('%F %T', gmtime $stat->mtime);
    }

    my $app_id = join("\t", @environment{@slot[0 .. 2]});
    return undef if $suppressed{$app_id};

    return \%environment;
}


sub environment_fields (\%) {
    my ($environment) = @_;
    my @result;

    foreach (@slot) {
	exists $environment->{$_} or die "missing environment field: $_";
	push @result, $environment->{$_};
    }

    return @result;
}


########################################################################
#
#  insert any new reports
#


my $upload_run = new Upload;

sub insert_run ($) {
    my $dir = shift;
    my $run_id = basename $dir;

    # skip already-known reports
    return if exists $known{$run_id};
    $known{$run_id} = 1;

    # load environment, and skip reports from bad builds
    my $environment = read_environment $dir, %known;
    return unless defined $environment;

    # new report of good build, so add to upload
    print "new: $dir\n";
    my @environment = environment_fields %{$environment};
    $upload_run->print($run_id, @environment);
}


if (@ARGV) {
    insert_run $_ foreach @ARGV;
} else {
    while (local $_ = <STDIN>) {
	chomp;
	insert_run $_;
    }
}


########################################################################
#
#  bulk upload
#


print "upload\n";

print "\trun: ", $upload_run->count, " new\n";

$dbh->do(q{
    CREATE TEMPORARY TABLE upload_run
	(run_id VARCHAR(24) NOT NULL,
	 application_name VARCHAR(50) NOT NULL,
	 application_version VARCHAR(50) NOT NULL,
	 application_release VARCHAR(50) NOT NULL,
	 build_distribution VARCHAR(50) NOT NULL,
	 version VARCHAR(255),
	 sparsity INTEGER UNSIGNED NOT NULL,
	 exit_signal TINYINT UNSIGNED NOT NULL,
	 exit_status TINYINT UNSIGNED NOT NULL,
	 date DATETIME NOT NULL)
	TYPE=InnoDB
    }) or die;

$upload_run->send($dbh, 'upload_run');


########################################################################
#
#  add to existing tables
#


unless ($dry_run) {

    print "insert\n";

    print "\trun: ", $upload_run->count, " new\n";

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
	    NULL

	    FROM upload_run
	    NATURAL LEFT JOIN build
	    WHERE build_suppress IS NULL
	}) or die;
}


########################################################################
#
#  finish up
#


$dbh->commit;
$dbh->disconnect;
