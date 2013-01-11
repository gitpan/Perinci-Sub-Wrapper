
use strict;
use warnings;

use Module::Build 0.3601;


my %module_build_args = (
  "build_requires" => {
    "Module::Build" => "0.3601",
    "Test::More" => "0.98"
  },
  "configure_requires" => {
    "Module::Build" => "0.3601"
  },
  "dist_abstract" => "A multi-purpose subroutine wrapping framework",
  "dist_author" => [
    "Steven Haryanto <stevenharyanto\@gmail.com>"
  ],
  "dist_name" => "Perinci-Sub-Wrapper",
  "dist_version" => "0.37",
  "license" => "perl",
  "module_name" => "Perinci::Sub::Wrapper",
  "recommends" => {},
  "recursive_test_files" => 1,
  "requires" => {
    "Data::Clone" => 0,
    "Data::Sah" => "0.10",
    "Log::Any" => 0,
    "Perinci::MetaAccessor::Default" => "0.26",
    "Perinci::Sub::DepChecker" => "0.06",
    "Perinci::Sub::Util" => 0,
    "Perinci::Util" => "0.25",
    "Rinci" => "v1.1.32",
    "SHARYANTO::String::Util" => "0.22",
    "perl" => "5.010000"
  },
  "script_files" => []
);


my $build = Module::Build->new(%module_build_args);

$build->create_build_script;
