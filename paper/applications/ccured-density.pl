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
    my ($suite, $benchmark, $when, $where, $sparsity, $seed,
	$user, $system, $elapsed, $cpu, $text, $data, $max,
	$inputs, $outputs, $major, $minor, $swaps) = split;
    next unless $where =~ /^(all|none)$/;
    die if exists $elapsed{$benchmark}{$when}{$where}{$sparsity}{$seed};
    $elapsed{$benchmark}{$when}{$where}{$sparsity}{$seed} = $elapsed;
}


sub slowdown ($$) {
    my ($form, $basis) = @_;
    my $total = 0;
    $total += $form->{$_} / $basis->{$_} foreach 1 .. 4;
    return $total / 4;
}


sub print_time ($$$$) {
    my ($when, $where, $sparsity, $elapsed) = @_;
    my $me = slowdown $elapsed->{$when}{$where}{$sparsity}, $elapsed->{always}{none}{1};
    my $all = slowdown $elapsed->{always}{all}{1}, $elapsed->{always}{none}{1};

    if ($me < $all) {
	printf " & \\textit{%.2f}", $me;
    } else {
	printf " & %.2f", $me;
    }
}


foreach my $suite ('olden', 'spec95') {
    foreach my $benchmark (@{$suite{$suite}}) {
	print $benchmark;
	print_time 'always', 'all', 1, $elapsed{$benchmark};
	foreach my $sparsity (100, 1000, 10000, 1000000) {
	    print_time 'sample', 'all', $sparsity, $elapsed{$benchmark};
	}
	print " \\\\\n";
    }
    print "\\hline\n";
}

exit 0;
