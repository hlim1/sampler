#!/usr/bin/env perl -w

use strict;
use FileHandle;


my %suite = (
	     olden => ['bh', 'bisort', 'em3d', 'health', 'mst', 'perimeter', 'power', 'treeadd', 'tsp'],
	     spec95 => ['compress', 'go', 'ijpeg', 'li']
	     );

my %stats;


my $collated = new FileHandle $ARGV[0];
$collated->getline;

while ($_ = <$collated>) {
    my ($benchmark, $numFuncs, $numWeightless, $numHasSites, $numSites, $numRegions, $totalWeight) = split;
    $stats{$benchmark} = {numFuncs => $numFuncs,
			  numWeightless => $numWeightless,
			  numHasSites => $numHasSites,
			  numSites => $numSites,
			  numRegions => $numRegions,
			  totalWeight => $totalWeight};
}


foreach ('olden', 'spec95') {
    foreach my $benchmark (@{$suite{$_}}) {
	my %info = %{$stats{$benchmark}};
	printf("%s & %d & %d & %d & %.1f & %.1f & %.1f \\\\\n",
	       $benchmark,
	       $info{numFuncs}, $info{numWeightless}, $info{numHasSites},
	       ($info{numSites} / $info{numHasSites}),
	       ($info{numRegions} / $info{numHasSites}),
	       ($info{totalWeight} / $info{numRegions}));
    }
    print "\\hline\n";
}
