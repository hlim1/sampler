#!/usr/bin/perl -w

use strict;
use FileHandle;

my %elapsed;


my $collated = new FileHandle $ARGV[0];
$collated->getline;

while ($_ = <$collated>) {
    my ($form, $seed, $user, $system, $elapsed, $cpu, $text, $data, $max, $inputs, $outputs, $major, $minor, $swaps) = split;
    die if exists $elapsed{$form}{$seed};
    $elapsed{$form}{$seed} = $elapsed;
}


sub print_time ($) {
    my $form = shift;
    my $me = $elapsed{$form};
    my $ref = $elapsed{'always-none'};

    my $average = 0;
    $average += $me->{$_} / $ref->{$_} foreach 1 .. 4;
    $average /= 4;
    
    print $average, "\n";
}


print_time 'always-all';
foreach my $sparsity (100, 1000, 10000, 1000000) {
    print_time "sample-all-$sparsity";
}

exit 0;
