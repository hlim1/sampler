#!/usr/bin/perl -w

use strict;

use DBI;
use FileHandle;

use lib '../populate';
use Common;


########################################################################


my %count;
my %seen;


########################################################################


my $query = new FileHandle 'reports-per-week-app.sql' or die;
my @query = $query->getlines;
$query = join '', @query;

my $dbh = Common::connect;
$query = $dbh->prepare($query);
$query->execute;

while (my $row = $query->fetchrow_hashref) {
    $count{$row->{application_name}}{$row->{year}}{$row->{week}} = $row->{count};
    $seen{$row->{year}}{$row->{week}} = 1;
}

$dbh->disconnect;


########################################################################


#open STDOUT, '|gnuplot -persist';

print <<'EOT';
set terminal x11
set data style lines
set xtics 4
set mxtics 4
EOT

{
    my @datasets = map "'-' using (53 * (\$1 - 2003) + \$2) :3 title '$_'", sort keys %count;
    local $" = ', ';
    print "plot @datasets\n";
}

{
    local ($,, $\) = ("\t", "\n");
    foreach my $app (sort keys %count) {
	my $years = $count{$app};
	foreach my $year (sort {$a <=> $b} keys %seen) {
	    my $weeks = $years->{$year};
	    foreach my $week (sort {$a <=> $b} keys %{$seen{$year}}) {
		my $count = $weeks->{$week} || 0;
		print $year, $week, $count;
	    }
	}
	print 'e';
    }
}
