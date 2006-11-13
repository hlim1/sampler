#!/usr/bin/perl -w

use strict;
use 5.008;			# for safe pipe opens using list form of open

use File::Path;
use File::Temp qw(tempdir);
use FileHandle;
use POSIX qw(strftime);

use Common;
use Upload;

my $dry_run = $ARGV[0] eq '--dry-run' ? shift : undef;

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
#  insert any sites from new builds
#


my $upload_build = new Upload;
my $upload_module = new Upload;
my $upload_site = new Upload;

foreach my $package (@ARGV) {
    my @command = ('rpm', '-qp', '--qf', '%{name}\t%{version}\t%{release}\n%{buildtime}\n[%{filenames}\n]', $package);
    my $rpm_query = new FileHandle;
    open $rpm_query, '-|', @command;

    # extract application name, version, release
    my @app_id = Common::read_app_id $rpm_query;
    my $app_id = join "\t", @app_id;

    # have we seen this before?
    next if exists $known{$app_id};
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

    # unpack site information
    print "\tunpack cpio\n";
    my $tempdir = tempdir(CLEANUP => 1);
    $ENV{package} = $package;
    system("rpm2cpio \$package | ( cd $tempdir && cpio -id --quiet --no-absolute-filenames '*.sites' '*.cfg'; )") == 0
	or die "cpio extraction failed: $?\n";

    # grovel through site information
    print "\tcollect sites\n";

    while (my $filename = <$rpm_query>) {
	chomp $filename;
	my $module_name = $filename;
	next unless $module_name =~ s/^\/usr\/lib\/sampler\/sites(\/.*)\.sites$/$1/;

	# should each site have a CFG node number?
	my $cfg_name = $filename;
	$cfg_name =~ s/\.sites$/.cfg/;
	my $has_cfg = -e "$tempdir$cfg_name";

	my $extracted = "$tempdir$filename";
	die "missing file: $filename\n" unless -e $extracted;
	next if -d $extracted;

	my $contents = new FileHandle($extracted);
	while (my $unit_header = <$contents>) {
	    chomp $unit_header;
	    my $unit_signature = Common::parse_signature 'sites', $extracted, $contents->input_line_number, $unit_header;

	    my $site_order = 0;

	    while (my $description = <$contents>) {
		chomp $description;
		last if $description eq '';
		last if $description eq '</sites>';

		my @description = split /\t/, $description;
		my $source_name = shift @description;
		my $line_number = shift @description;
		my $function = shift @description;
		my $cfg = shift @description if $has_cfg;
		my $operand_0 = shift @description;
		my $operand_1 = shift @description;

		my $where = "$extracted:" . $contents->input_line_number;
		die "$where: extra descriptive fields\n" if @description;
		die "$where: empty source file name\n" unless $source_name;
		die "$where: bad source line number\n" unless $line_number =~ /^\d+$/;
		die "$where: empty function name\n" unless $function;
		die "$where: empty operand 0\n" unless defined $operand_0;

		my @fields = (@app_id, $unit_signature, $site_order, $source_name,
			      $line_number, $function, $cfg, $operand_0, $operand_1);
		$upload_site->print(@fields);
		++$site_order;
	    }
	    
	    next unless $site_order;

	    my @fields = (@app_id, $module_name, $unit_signature);
	    $upload_module->print(@fields);
	}
    }

    print "\tclean cpio\n";
    rmtree $tempdir;

    # done with rpm query
    $rpm_query->close;
    if ($?) {
	print "rpm command failed: $?";
        exit($? >> 8 || $?);
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
	 instrumentation_type ENUM('branches', 'returns', 'scalar-pairs') NOT NULL,
	 build_date DATETIME NOT NULL)
	TYPE=InnoDB
    }) or die;

$upload_build->send($dbh, 'upload_build');


print "\tmodule: ", $upload_module->count, " new\n";

$dbh->do(q{
    CREATE TEMPORARY TABLE upload_module
	(application_name VARCHAR(50) NOT NULL,
	 application_version VARCHAR(50) NOT NULL,
	 application_release VARCHAR(50) NOT NULL,

	 module_name VARCHAR(255) NOT NULL,
	 unit_signature CHAR(32) NOT NULL)
	TYPE=InnoDB
    }) or die;

$upload_module->send($dbh, 'upload_module');


print "\tsite: ", $upload_site->count, " new\n";

$dbh->do(q{
    CREATE TEMPORARY TABLE upload_site
	(application_name VARCHAR(50) NOT NULL,
	 application_version VARCHAR(50) NOT NULL,
	 application_release VARCHAR(50) NOT NULL,

	 unit_signature CHAR(32) NOT NULL,
	 site_order INTEGER UNSIGNED NOT NULL,

	 source_name VARCHAR(255) NOT NULL,
	 line_number INTEGER UNSIGNED NOT NULL,
	 function VARCHAR(255) NOT NULL,
	 cfg INTEGER UNSIGNED,

	 operand_0 VARCHAR(255) NOT NULL,
	 operand_1 VARCHAR(255))

	TYPE=InnoDB
    }) or die;

$upload_site->send($dbh, 'upload_site');


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
	     instrumentation_type,
	     build_date)

	    SELECT *
	    FROM upload_build
	}) or die;


    print "\tmodule: ", $upload_module->count, " new\n";

    $dbh->do(q{
	INSERT INTO build_module
	    (build_id, module_name, unit_signature)

	    SELECT build_id, module_name, unit_signature
	    FROM build NATURAL JOIN upload_module
	}) or die;


    print "\tsite: ", $upload_site->count, " new\n";

    $dbh->do(q{
	INSERT IGNORE INTO build_site
	    (build_id, unit_signature, site_order,
	     source_name, line_number, function, cfg, operand_0, operand_1)

	    SELECT build_id, unit_signature, site_order,
	    source_name, line_number, function, cfg, operand_0, operand_1

	    FROM build NATURAL JOIN upload_site
	}) or die;

}


########################################################################
#
#  finish up
#


$dbh->commit;
$dbh->disconnect;
