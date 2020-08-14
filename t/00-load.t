#!perl -T
use 5.006;
use strict;
use warnings;
use Test::More;

plan tests => 1;

BEGIN {
    use_ok( 'CDR::Loader' ) || print "Bail out!\n";
}

diag( "Testing CDR::Loader $CDR::Loader::VERSION, Perl $], $^X" );
