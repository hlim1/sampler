#!/usr/bin/perl -w

use strict;
use 5.008;			# for safe pipe opens using list form of open
use File::Path;
use File::Temp qw(tempfile);
use FileHandle;
use POSIX qw(strftime);

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

my $guess_instrumentation_version = '0.1';


########################################################################
#
#  insert any sites from new builds
#


my ($upload, $upload_filename) = tempfile(UNLINK => 1);
my $upload_count = 0;

foreach my $package (@ARGV) {
    my @command = ('rpm', '-qp', '--qf', '%{name}\t%{version}\t%{release}\n%{buildtime}\n', $package);
    my $rpm_query = new FileHandle;
    open $rpm_query, '-|', @command;

    # extract application name, version, release
    my @app_id = Common::read_app_id $rpm_query;
    my $app_id = join "\t", @app_id;

    # have we seen this before?
    next if exists $known{$app_id};
    $known{$app_id} = 1;
    ++$upload_count;

    print "new: $package\n";

    # not previously seen, so also need build date
    my $raw_date = <$rpm_query>;
    defined $raw_date or die "mangled RPM build date\n";
    my $build_date = strftime('%F %T', gmtime $raw_date);

    # add to upload
    local ($,, $\) = ("\t", "\n");
    my $instrumentation_type = $guess_instrumentation_type{$app_id[0]};
    my $instrumentation_version = $guess_instrumentation_version;
    my @fields = (@app_id, $instrumentation_type, $instrumentation_version, $build_date);
    Common::escape @fields;
    print $upload @fields;

    # done with rpm query
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
	 instrumentation_type ENUM('branches', 'returns', 'scalar-pairs') NOT NULL,
	 instrumentation_version VARCHAR(50) NOT NULL,
	 build_date DATETIME NOT NULL)
	TYPE=InnoDB
    }) or die;

$dbh->do(q{
    LOAD DATA LOCAL INFILE ?
	INTO TABLE upload
    
	(application_name,
	 application_version,
	 application_release,
	 instrumentation_type,
	 instrumentation_version,
	 build_date)
    },
	 undef, $upload_filename)
    or die;


########################################################################
#
#  merge into existing table
#


print "insert into build\n";

$dbh->do(q{
    INSERT INTO build
	(application_name,
	 application_version,
	 application_release,
	 instrumentation_type,
	 instrumentation_version,
	 build_date)

	SELECT *
	FROM upload
    }) or die;


print "newly added: $upload_count\n";


########################################################################
#
#  finish up
#


$dbh->commit;
$dbh->disconnect;
