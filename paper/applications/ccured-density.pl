#!/usr/bin/perl -w

use strict;
use FileHandle;


my %suite = (
	     olden => ['bh', 'bisort', 'em3d', 'health', 'mst', 'perimeter', 'power', 'treeadd', 'tsp'],
	     spec95 => ['compress', 'go', 'ijpeg', 'li']
	     );

my %elapsed;


my $collated = new FileHandle $ARGV[0];
$collated->getline;

while ($_ = <$collated>) {
    my ($suite, $benchmark, $form, $seed, $user, $system, $elapsed, $cpu, $text, $data, $max, $inputs, $outputs, $major, $minor, $swaps) = split;
    $elapsed{$benchmark}{$form} += $elapsed;
}


sub print_time ($$) {
    my ($form, $elapsed) = @_;
    my $me = $elapsed->{$form};
    my $ref = $elapsed->{'always-none'};
    my $all = $elapsed->{'always-all'};
    if ($me < $all) {
	printf " & \\textit{%.2f}", $me / $ref;
    } else {
	printf " & %.2f", $me / $ref;
    }
}


foreach my $suite ('olden', 'spec95') {
    foreach my $benchmark (@{$suite{$suite}}) {
	print $benchmark;
	print_time 'always-all', $elapsed{$benchmark};
	foreach my $sparsity (100, 1000, 10000, 1000000) {
	    print_time "sample-all-$sparsity", $elapsed{$benchmark};
	}
	print " \\\\\n";
    }
    print "\\hline\n";
}

exit 0;
