use Module::Build;
use strict;

my $build = Module::Build->new(
  create_makefile_pl => 'traditional',
  license            => 'perl',
  module_name        => 'App::Cache',
  requires           => {
    'Class::Accessor::Chained::Fast' => '0',
    'File::Find::Rule'               => '0',
    'File::HomeDir'                  => '0',
    'File::stat'                     => '0',
    'HTTP::Cookies'                  => '0',
    'LWP::UserAgent'                 => '0',
    'Path::Class'                    => '0',
    'Storable'                       => '0',
    'Test::More'                     => '0',
  },
);
$build->create_build_script;
