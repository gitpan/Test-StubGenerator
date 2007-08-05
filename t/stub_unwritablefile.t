#!/usr/bin/perl

use strict;
use warnings;

use Test::More tests => 4;

use File::Find;
use File::Spec;

use Test::Exception;

BEGIN { use_ok( 'Test::StubGenerator' ); }

my $filename = 'filename.t';

ok( my $stub = Test::StubGenerator->new( {
      file  => 't/inc/MyObj.pm',
      output => $filename,
      out_dir => '/path/that/cant/possibly/exist/',
    } ), 'can call new' );

dies_ok { $stub->gen_testfile } "Non existent directories can't be written to and dies";
like( $@, qr/Can't write to file '[\w.-]+' in directory/, "Non existent directories can't be written to" );
