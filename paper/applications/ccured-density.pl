#!/usr/bin/perl -w

use strict;
use File::Basename;
use FileHandle;


sub getTime ($) {
    my $base = shift;
    my $handle = new FileHandle "$base.times"
	or die "cannot open $base.times: $!\n";
    my $total = 0;
    my $count = 0;
    
    foreach (<$handle>) {
	next unless / (\d+):(\d+.\d+)elapsed /;
	my $time = $1 * 60 + $2;
	$total += $time;
	++$count;
    }

    die unless $total;
    die unless $count == 4;
    return $total / $count;
}


foreach my $dir (@ARGV) {
    print basename $dir;

    my $basis = getTime "$dir/always-all";

    foreach my $sparsity (100, 10000, 1000000) {
	my $other = getTime "$dir/$sparsity";
	printf " & %.2f", $basis / $other;
    }

    print " \\\\\n";
}
