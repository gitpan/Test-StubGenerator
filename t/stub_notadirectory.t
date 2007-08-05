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
      out_dir => 't/boilerplate.t',
    } ), 'can call new' );

dies_ok { $stub->gen_testfile } "Non directory in out_dir and dies";
like( $@, qr/Can't write to file 'filename\.t'/, "Permission denied to treat file as directory." );
