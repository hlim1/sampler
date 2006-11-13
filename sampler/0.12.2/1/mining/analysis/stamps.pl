#!/usr/bin/perl -w
# -*- cperl -*-

use strict;

use File::Basename;
use File::Find;


print "stamps :=\n";


sub wanted {
    return unless /^(.*)-samplerinfo-(.*)\.[^.]+\.rpm$/;
    my $build = "$1-$2";

    my $distro = basename dirname $File::Find::dir;
    die unless $distro =~ /^\w+-\d+-i386$/;

    my $stamp = "results/$distro/$build/stamp";
    print <<"EOT";

stamps += $stamp
$stamp: $File::Find::name
	mkdir -p \$(\@D)
	./one \$< \$(\@D)
	touch \$@
EOT
}


my $rpmdir = "$ENV{HOME}/public_html/sampler/downloads/rpm";
find \&wanted, $rpmdir if -d $rpmdir;
