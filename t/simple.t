#!perl
use strict;
use Test::More tests => 36;
use lib qw(lib t/lib);
use_ok('App::Cache');
use_ok('App::Cache::Test');

my $cache = App::Cache::Test->new();
$cache->code;
$cache->file;
$cache->scratch;
$cache->url;

