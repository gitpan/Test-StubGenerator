#!/usr/bin/perl

use strict;
use warnings;

use Test::More tests => 5;
use Test::Exception;

use File::Find;
use File::Spec;

BEGIN { use_ok( 'Test::StubGenerator' ); }

my $source = "\%^*&open;sub()\@sub|}hi\0x45there*\$^{retun\"hello};sub9\'\'\\\'\'\%syntax{error";
my $stub;
dies_ok { $stub = Test::StubGenerator->new( { source => \$source } ) }
    'calling new on complete garbage is unparsable';

like( $@, qr/Unable to initialize PPI document/, "die message matches" );

dies_ok { $stub->gen_testfile() } 'cannot render tests for garbage';

like( $@, qr/Can't call method/, "die message matches" );
