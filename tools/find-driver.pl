my $prefix = '@prefix@';
my $exec_prefix = '@exec_prefix@';
my $bindir = '@bindir@';
my $PACKAGE = '@PACKAGE@';
my $installed = ! -e "$FindBin::Bin/Makefile";
my $driver = $installed ? "$bindir/$PACKAGE-cc" : "$FindBin::Bin/../instrumentor/driver/main";
