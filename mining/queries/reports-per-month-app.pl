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


my $query = new FileHandle 'reports-per-month-app.sql' or die;
my @query = $query->getlines;
$query = join '', @query;

my $dbh = Common::connect;
$query = $dbh->prepare($query);
$query->execute;

while (my $row = $query->fetchrow_hashref) {
    $count{$row->{application_name}}{$row->{year}}{$row->{month}} = $row->{count};
    $seen{$row->{year}}{$row->{month}} = 1;
}

$dbh->disconnect;


########################################################################


#open STDOUT, '|gnuplot -persist';

print <<'EOT';
set terminal x11
set data style lines
EOT

{
    my @datasets = map "'-' using (12 * (\$1 - 2003) + \$2 - 1) :3 title '$_'", sort keys %count;
    local $" = ', ';
    print "plot @datasets\n";
}

{
    local ($,, $\) = ("\t", "\n");
    foreach my $app (sort keys %count) {
	my $years = $count{$app};
	foreach my $year (sort {$a <=> $b} keys %seen) {
	    my $months = $years->{$year};
	    foreach my $month (sort {$a <=> $b} keys %{$seen{$year}}) {
		my $count = $months->{$month} || 0;
		print $year, $month, $count;
	    }
	}
	print 'e';
    }
}
