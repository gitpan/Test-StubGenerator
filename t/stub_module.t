#!/usr/bin/perl

use strict;
use warnings;

use Test::More tests => 9;

use File::Find;
use File::Spec;

BEGIN { use_ok( 'Test::StubGenerator' ); }

eval { my $stub = Test::StubGenerator->new(); };
ok( $@, "empty constructor should die" );

eval { my $stub = Test::StubGenerator->new({}); };
ok( $@, "empty constructor should die" );

ok( my $stub = Test::StubGenerator->new( { file  => 't/inc/MyObj.pm', tidy_config => 't/perltidyrc' } ),
    'can call new' );

isa_ok( $stub, 'Test::StubGenerator', '$stub is a Test::StubGenerator' );
can_ok( $stub, 'gen_testfile' );
isa_ok( $stub->{ doc }, 'PPI::Document', '$stub->{ doc } is a PPI::Document' );

ok( my $output = $stub->gen_testfile, 'got output' );

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
ok( $obj->set_names(@names), 'can call $obj->set_names()' );
ok( $obj->set_names(), 'can call $obj->set_names() without params' );

ok( $obj->get_name(), 'can call $obj->get_name() without params' );
END_EXPECTED
}
