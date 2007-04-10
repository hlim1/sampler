#!/usr/bin/perl -w
#-*- cperl -*-

use strict;
use File::Basename;


print <<EOT;
<?xml version="1.0"?>
<?xml-stylesheet type="text/xsl" href="overview.xsl"?>
<!DOCTYPE overview SYSTEM "overview.dtd">
<overview>
EOT


my %seen;


while (<>) {
  chomp;
  $_ = dirname $_;
  next if $seen{$_};
  $seen{$_} = 1;

  my $application = basename $_;
  my $distribution = basename dirname $_;

  print "<result distribution=\"$distribution\" application=\"$application\"/>\n";
}


print <<EOT;
</overview>
EOT
