package SiteInfo;

use strict;
use 5.008;		 # for safe pipe opens using list form of open

use TaggedLoader;
our @ISA = qw(TaggedLoader);


########################################################################


sub new ($$) {
    my ($proto) = @_;
    my $class = ref($proto) || $proto;
    my $self = $class->SUPER::new('sites');
    bless $self, $class;
}


sub merge ($\@\@) {
    my ($self, $old, $new) = @_;

    return undef unless @{$old} == @{$new};

    foreach (0 .. $#{$new}) {
	return undef unless $old->[$_] eq $new->[$_];
    }

    return $old;
}


sub load ($$) {
    my ($self, $filename) = @_;
    return if -d $filename;

    my $handle;
    if ($filename =~ /\.sites$/) {
	$handle = new FileHandle $filename, 'r';
	$handle or die "cannot read $filename: $!\n";
    } else {
	my $extractor = "$FindBin::Bin/extract-section";
	open $handle, '-|', $extractor, ".debug_site_info", $filename;
	$handle or die "cannot extract sites from $filename: $!\n";
    }

    $self->read($handle);

    close $handle or die "cannot finish reading sites from $filename: $!\n";
}


########################################################################


1;
