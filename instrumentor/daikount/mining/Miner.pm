package Miner;

use strict;
use FileHandle;


########################################################################


my $dir = "$ENV{HOME}/research/forensics/sampling/apps/bc-1.06/trials";


sub loadResult($) {
    my $handle = new FileHandle "$dir/$_[0].result";
    my $result = <$handle>;
    chomp $result;
    return $result;
}


sub traceName($) {
    return "$dir/$_[0].trace.gz";
}


sub readTrace($) {
    my $name = traceName @_;
    return new FileHandle "zcat $name |";
}


########################################################################


1;
