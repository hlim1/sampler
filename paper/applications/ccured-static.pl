#!/usr/bin/perl -w

use strict;
use File::Basename;
use FileHandle;


foreach my $stats (@ARGV) {
    my $benchmark = basename dirname $stats;
    my $stats = new FileHandle $stats or die;

    my $numSites = 0;
    my $numFuncs = 0;
    my $numWeightless = 0;
    my $numHasSites = 0;
    my $numRegions = 0;
    my $totalWeight = 0;

    while (<$stats>) {
	if (/^stats: weightless: (\d+) functions, (\d+) weightless$/) {
	    $numFuncs += $1;
	    $numWeightless += $2;
	} elsif (/^stats: transform: \w+ has sites: (\d+) sites, (\d+) headers, (\d+) total header weights$/) {
	    ++$numHasSites;
	    $numSites += $1;
	    $numRegions += $2;
	    $totalWeight += $3;
	}
    }

    printf("%s & %d & %d & %d & %.1f & %.1f & %.1f \\\\\n",
	   $benchmark,
	   $numFuncs, $numWeightless, $numHasSites,
	   ($numSites / $numHasSites),
	   ($numRegions / $numHasSites),
	   ($totalWeight / $numRegions));
}
