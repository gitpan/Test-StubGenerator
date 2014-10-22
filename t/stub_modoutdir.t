#!/usr/bin/perl

use strict;
use warnings;

use Test::More tests => 4;

use File::Find;
use File::Spec;

BEGIN { use_ok( 'Test::StubGenerator' ); }

ok( my $stub = Test::StubGenerator->new( {
      file  => 't/inc/MyObj.pm',
      output => 'file',
      out_dir => 't/inc/t', perltidyrc => 't/perltidyrc' ,
    } ), 'can call new' );

ok( $stub->gen_testfile, 'generated output' );

open my $in_fh, '<', 't/inc/t/MyObj.t' or die "can't open file for reading - $!";
my $output = do { local $/; <$in_fh> };
close $in_fh;

my $expected = return_mod_expected();
is( $output, $expected, 'got back what we were expecting' );

sub return_mod_expected {
  return <<'END_EXPECTED';
#!/usr/bin/perl

use strict;
use warnings;

use Test::More qw/no_plan/;

BEGIN { use_ok('MyObj'); }

ok( my $obj = MyObj->new(), 'can create object MyObj' );
isa_ok( $obj, 'MyObj', 'object $obj' );
can_ok( $obj, 'get_name', 'set_names' );

# Create some variables with which to test the MyObj objects' methods
# Note: give these some reasonable values.  Then try unreasonable values :)
my @names = ( '', );

# And now to test the methods/subroutines.
ok( $obj->get_name(), 'can call $obj->get_name() without params' );

ok( $obj->set_names(@names), 'can call $obj->set_names()' );
ok( $obj->set_names(), 'can call $obj->set_names() without params' );
END_EXPECTED
}
