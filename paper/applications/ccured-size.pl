#!/usr/bin/env perl -w

use strict;
use File::stat;


my @benchmark = (
		 'bh', 'bisort', 'em3d', 'health', 'mst', 'perimeter', 'power', 'treeadd', 'tsp',
		 'compress', 'go', 'ijpeg', 'li'
		 );


sub measure ($$) {
    my ($benchmark, $form) = @_;
    return stat("../../benchmarks/ccured/$benchmark/$form.exe")->size;
}


my $max = 0;
my $min = 1e99;

foreach (@benchmark) {
    my $sampling = measure $_, 'sample-all';
    my $reference = measure $_, 'always-all';
    # my $reference = measure $_, 'always-none';

    my $expansion = $sampling / $reference;
    $max = $expansion if $max < $expansion;
    $min = $expansion if $min > $expansion;
}

printf "\\newcommand{\\execGrowthMin}{%d}\n", ($min - 1) * 100;
printf "\\newcommand{\\execGrowthMax}{%d}\n", ($max - 1) * 100;

exit 0;
