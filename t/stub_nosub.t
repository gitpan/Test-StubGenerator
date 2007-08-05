#!/usr/bin/perl

use strict;
use warnings;

use Test::More tests => 3;
use Test::Warn;

use File::Find;
use File::Spec;

BEGIN { use_ok( 'Test::StubGenerator' ); }

my $source =<<'SOURCE_END';
open( my $log, '<', shift ) or die "can't open file - $!";
while( my $line = <$log> ){
  print if m/target/;
}
SOURCE_END

ok( my $stub = Test::StubGenerator->new( { source => \$source } ),
    'can call new' );

warnings_like { $stub->gen_testfile() }
  [ qr/No packages found/, qr/No subs found/, ];
