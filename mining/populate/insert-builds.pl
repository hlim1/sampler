#!/usr/bin/perl -w

use strict;
use 5.008;			# for safe pipe opens using list form of open

use File::Path;
use File::Temp qw(tempdir);
use FileHandle;
use POSIX qw(strftime);

use Common;
use Upload;

my $dry_run = (@ARGV && $ARGV[0] eq '--dry-run') ? shift : undef;

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
	    FROM build});

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
#  fields missing from early builds
#


my %guess_instrumentation_type =
    ('evolution' => 'returns',
     'gaim' => 'scalar-pairs',
     'gimp' => 'branches',
     'gnumeric' => 'returns',
     'nautilus' => 'branches',
     'rhythmbox' => 'scalar-pairs');


########################################################################
#
#  insert any new builds
#


my $upload_build = new Upload;

sub insert_build ($) {
    my $package = shift;
    my @command = ('rpm', '-qp', '--qf', '%{name}\t%{version}\t%{release}\n%{buildtime}\n', $package);
    my $rpm_query = new FileHandle;
    open $rpm_query, '-|', @command;

    # extract application name, version, release
    my @app_id = Common::read_app_id $rpm_query;
    my $app_id = join "\t", @app_id;

    # have we seen this before?
    return if exists $known{$app_id};
    $known{$app_id} = 1;

    print "new: $package\n";

    # not previously seen, so also need build date
    my $raw_date = <$rpm_query>;
    defined $raw_date or die "mangled RPM build date\n";
    my $build_date = strftime('%F %T', gmtime $raw_date);

    # add to uploads for build table
    my $instrumentation_type = $guess_instrumentation_type{$app_id[0]};
    my @fields = (@app_id, $instrumentation_type, $build_date);
    $upload_build->print(@fields);

    # done with rpm query
    $rpm_query->close;
    if ($?) {
	print "rpm command failed: $?";
        exit($? >> 8 || $?);
    }
}


if (@ARGV) {
    insert_build $_ foreach @ARGV;
} else {
    while (local $_ = <STDIN>) {
	chomp;
	insert_build $_;
    }
}


########################################################################
#
#  bulk upload
#


print "upload\n";

print "\tbuild: ", $upload_build->count, " new\n";

$dbh->do(q{
    CREATE TEMPORARY TABLE upload_build
	(application_name VARCHAR(50) NOT NULL,
	 application_version VARCHAR(50) NOT NULL,
	 application_release VARCHAR(50) NOT NULL,
	 build_date DATETIME NOT NULL)
	TYPE=InnoDB
    }) or die;

$upload_build->send($dbh, 'upload_build');


########################################################################
#
#  add to existing tables
#


unless ($dry_run) {

    print "insert\n";

    print "\tbuild: ", $upload_build->count, " new\n";

    $dbh->do(q{
	INSERT INTO build
	    (application_name,
	     application_version,
	     application_release,
	     build_date)

	    SELECT *
	    FROM upload_build
	}) or die;

}


########################################################################
#
#  finish up
#


$dbh->commit;
$dbh->disconnect;
