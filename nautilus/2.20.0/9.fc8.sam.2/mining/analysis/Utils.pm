# -*- cperl -*-

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


my $RunsPerSubdirectory = 10000;


########################################################################
#
#  sanity check for dangerous characters
#
#	Example valid directory:
#		./results/fedora-5-i386/nautilus-2.14.1-1.fc5.1.sam.2/
#

sub check_outdir ($) {
    my $outdir = shift;
    die "suspicious outdir: $outdir\nExample valid analysis output directory: ./results/fedora-5-i386/nautilus-2.14.1-1.fc5.1.sam.2/"
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


sub try_mkpath ($) {
    my $dir = shift;
    mkpath $dir or die "cannot mkpath $dir: $!\n";
}


########################################################################
#
#  guess the instrumentation scheme used by older builds
#


sub guess_schemes ($) {
    my $name = shift;
    my %guess =
	('evolution' => ['returns'],
	 'gaim' => ['scalar-pairs'],
	 'gimp' => ['branches'],
	 'gnumeric' => ['returns'],
	 'nautilus' => ['branches'],
	 'rhythmbox' => ['scalar-pairs'],
	 'spim' => ['branches', 'returns']);
    return @{$guess{$name}};
}


our $need_modernize;


########################################################################
#
#  extract the files inside an RPM
#


sub extract_rpm ($$;$) {
    $ENV{rpm} = shift;
    $ENV{dir} = shift;
    $ENV{pattern} = @_ ? shift : '';
    system('rpm2cpio $rpm | ( cd $dir && cpio --extract --make-directories --no-absolute-filenames --quiet $pattern )') == 0
	or exit($? & 127 || $? >> 8 || 1);
}


########################################################################
#
#  extract site information for use by analysis tools
#


sub unpack_sites ($\@$) {
    warn "Unpacking static site info ...\n";

    my ($outdir, $schemes, $rpm) = @_;
    check_outdir $outdir;

    my $dir = "$outdir/sites";
    rmtree $dir;
    try_mkdir $dir;

    extract_rpm $rpm, $dir, '*.sites';

    my @sites;

    my $wanted = sub {
	return if -d;
	die unless /\.sites$/;
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
	my $scheme = $schemes->[0];
	warn "  modernizing site files with \"$scheme\" scheme ...\n";
	foreach (@sites) {
	    $ENV{in} = $_;
	    $_ .= ',modern.sites';
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
#  extract debug information for linking results to source code
#


sub unpack_debuginfo ($$) {
    warn "Unpacking debug information and sources ...\n";

    my ($outdir, $rpm) = @_;
    check_outdir $outdir;

    my $dir = "$outdir/debug";
    rmtree $dir;
    try_mkdir $dir;
    extract_rpm $rpm, $dir;

    my @debugs;
    my $wanted = sub {
	return if -d;
	return unless /\.debug$/;
	push @debugs, File::Spec->rel2abs($_);
    };

    croak "no debug records for build\n" unless -d "$dir/usr/lib/debug";
    find {wanted => $wanted, no_chdir => 1 }, "$dir/usr/lib/debug";
    croak "no debug records for build\n" unless @debugs;
    return @debugs;
}


########################################################################
#
#  build a data directory suitable for the analysis tools
#


sub convert_reports ($\@@) {
    my $outdir = shift;
    my $schemes = shift;
    check_outdir $outdir;
    warn 'Unpacking ', scalar @_, " reports for build ...\n";

    my $dir = "$outdir/data";
    rmtree $dir;
    try_mkdir $dir;

    foreach my $run_num (0 .. $#_) {
	local $_ = $_[$run_num];
	die "suspicious run id: $_" if /\//;

##### This needs to be fixed - cannot take a hard-coded path for the reports directory
	my $old_dir = "/afs/cs.wisc.edu/p/cbi/uploads/archive/2006/08/$_";
	my $env_name = "$old_dir/environment";
	my $environment = new FileHandle $env_name
	    or die "cannot read $env_name: $!\n";

	my $subdir = int($run_num / $RunsPerSubdirectory);
	my $new_dir = "$dir/$subdir";
	mkdir $new_dir;
	$new_dir .= "/$run_num";
	try_mkdir $new_dir;

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

	my $scheme = $schemes->[0];
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


sub analyze_reports ($$\@\@\@\@) {
    my ($outdir, $name, $schemes, $runs, $sites, $debugs) = @_;
    check_outdir $outdir;

    my $numRuns = @$runs;
    my $makefile = new FileHandle "$outdir/GNUmakefile", 'w'
	or die "cannot write $outdir/GNUmakefile: $!\n";
    $makefile->print(<<EOT);
sites = @$sites
schemes = all @$schemes
numRuns = $numRuns
name = $name

include $FindBin::Bin/one.mk
EOT
    $makefile->close;

    system ('make', '-C', $outdir);
    exit($? & 127 || $? >> 8 || 1) if $?;
}


########################################################################
#
#  clean up all but the good stuff
#


sub clean ($) {
    my ($outdir) = @_;
    check_outdir $outdir;

    rmtree ["$outdir/data",
	    "$outdir/debug",
	    "$outdir/sites"];

    unlink
	"$outdir/f.runs",
	"$outdir/s.runs",
	"$outdir/sites.cc",
	"$outdir/sites.so",
	"$outdir/units.cc",
	"$outdir/units.so",
	"$outdir/GNUmakefile",
	glob("$outdir/*.tmp.txt");
}



########################################################################


1;
