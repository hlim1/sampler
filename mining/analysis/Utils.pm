package Utils;

use diagnostics;
use strict;

use Carp;
use Compress::Zlib;
use File::Find;
use File::Path;
use File::Spec;
use FileHandle;
use FindBin;


########################################################################
#
#  sanity check for dangerous characters
#

sub check_outdir ($) {
    my $outdir = shift;
    die "suspicious outdir: $outdir\n"
	unless $outdir =~ /^results\/\w+-\d+-i386\/[^-\/]+-[^-\/]+-[^-\/]+$/;
}


########################################################################
#
#  make a directory or die trying
#


sub try_mkdir ($) {
    my $dir = shift;
    mkdir $dir or die "cannot mkdir $dir: $!\n";
}


########################################################################
#
#  guess the instrumentation scheme used by older builds
#


sub guess_scheme ($) {
    my $name = shift;
    my %guess =
	('evolution' => 'returns',
	 'gaim' => 'scalar-pairs',
	 'gimp' => 'branches',
	 'gnumeric' => 'returns',
	 'nautilus' => 'branches',
	 'rhythmbox' => 'scalar-pairs');
    return $guess{$name};
}


our $need_modernize;


########################################################################
#
#  extract site information for use by analysis tools
#


sub unpack_sites ($$$) {
    warn "Unpacking static site info ...\n";

    my ($outdir, $scheme, $rpm) = @_;
    check_outdir $outdir;

    my $dir = "$outdir/sites";
    rmtree $dir;
    try_mkdir $dir;

    $ENV{dir} = $dir;
    $ENV{rpm} = $rpm;
    system 'rpm2cpio $rpm | ( cd $dir && cpio --extract --make-directories --no-absolute-filenames --quiet \\*.sites )';

    my @sites;

    my $wanted = sub {
	die if /\/\.\.\//;
	return unless /\.sites$/;
	push @sites, File::Spec->rel2abs($_);
    };

    find {wanted => $wanted, no_chdir => 1 }, $dir;

    croak "no sites for build\n" unless @sites;

    my $peek = (new FileHandle $sites[0])->getc;
    if ($peek eq '<') {
	$need_modernize = 0;
    } else {
	$need_modernize = 1;
	croak "unrecognized sites file format\n" unless $peek =~ /^[0-9a-f]$/;
	warn "  modernizing site files ...\n";
	foreach (@sites) {
	    $ENV{in} = $_;
	    $_ .= ',modern';
	    $ENV{out} = $_;
	    $ENV{scheme} = $scheme;
	    system('./modernize $scheme sites <$in >$out') == 0
		or die "modernization failed: $?\n";
	}
    }

    return @sites;
}


########################################################################
#
#  build a data directory suitable for the analysis tools
#


sub convert_reports ($$@) {
    my $outdir = shift;
    my $scheme = shift;
    check_outdir $outdir;
    warn "Unpacking $#_ reports for build ...\n";

    my $dir = "$outdir/data";
    rmtree $dir;
    try_mkdir $dir;

    foreach my $run_num (0 .. $#_) {
	local $_ = $_[$run_num];
	die "suspicious run id: $_" if /\//;
	my $old_dir = "../populate/sampler-uploads/$_";
	my $env_name = "$old_dir/environment";
	my $environment = new FileHandle $env_name
	    or die "cannot read $env_name: $!\n";

	my $new_dir = "$dir/$run_num";
	try_mkdir $new_dir;
	++$run_num;

	symlink File::Spec->rel2abs($old_dir), "$new_dir/original"
	    or die "cannot create link $new_dir/original: $!\n";

	while (<$environment>) {
	    chomp;
	    my ($name, $value) = split /\t/;
	    next unless $name eq 'HTTP_SAMPLER_EXIT_SIGNAL';
	    my $label = ($value == 0) ? 'success' : 'failure';
	    my $label_name = "$new_dir/label";
	    my $label_file = new FileHandle $label_name, 'w'
		or die "cannot write $label_name: $!\n";
	    $label_file->print("$label\n");
	}

	$ENV{in} = "$old_dir/samples.gz";
	$ENV{out} = "$new_dir/reports";
	$ENV{scheme} = $scheme;

	my $command = 'gunzip <$in';
	$command .= ' | ./modernize $scheme samples' if $need_modernize;
	$command .= ' >$out';
	unless (system($command) == 0) {
	    warn "gunzip or modernizer failed: $?\n";
	    die "  while processing $ENV{in}\n";
	}
    }

    return undef;
}


########################################################################
#
#  perform the analysis
#


sub analyze_reports ($\@\@) {
    my ($outdir, $runs, $sites) = @_;
    check_outdir $outdir;

    my @command = ("$FindBin::Bin/../../../cbiexp/bin/analyze-runs",
		   '-do-process-labels',
		   '-do-map-sites',
		   '-do-convert-reports',
		   '-do-compute-results',
		   '-do-print-results-1',
		   '-n', scalar @{$runs},
		   '-l', 'data/%d/label',
		   (map { ('-st', $_) } @{$sites}),
		   '-vr', 'data/%d/reports',
		   '-cr', 'data/%d/reports.new');

    my $pid = fork;
    die "cannot fork: $!\n" unless defined $pid;

    if ($pid) {
	wait;
	die "analysis failed: $?\n" if $?;
    } else {
	chdir $outdir or die "cannot chdir $outdir: $!\n";
	exec @command;
	die "cannot exec: $!\n";
    }
}


########################################################################
#
#  clean up all but the good stuff
#


sub clean ($) {
    my ($outdir) = @_;
    check_outdir $outdir;

    rmtree "$outdir/data";
    #rmtree "$outdir/sites";

    unlink
	"$outdir/f.runs",
	"$outdir/s.runs",
	"$outdir/sites.cc",
	"$outdir/sites.o",
	"$outdir/units.cc",
	"$outdir/units.o",
	"$outdir/compute-results",
	"$outdir/convert-reports",
	"$outdir/gen-views",
	glob("$outdir/*.tmp.txt");
}
    


########################################################################


1;
