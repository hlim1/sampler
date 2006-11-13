#!/usr/bin/perl -w

use strict;

use File::Basename;
use File::Temp qw(tempfile);
use FileHandle;

use Common;


########################################################################
#
#  insert any new reports
#


foreach my $dir (@ARGV) {
    my $run_id = basename $dir;
    my $empty = 1;

    my $samples_filename = "$dir/samples.gz";
    my $samples_handle = new FileHandle;
    open $samples_handle, '-|', 'zcat', $samples_filename;

  UNIT:
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
		    if ($count) {
			$empty = 0;
			last UNIT;
		    }
		}
		++$site_order;
	    }
	}
    }

    if ($empty) {
	print "$dir is empty\n";
    } else {
	print "$dir is not empty\n";
    }
}
