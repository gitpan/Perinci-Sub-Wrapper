
# This file was automatically generated by Dist::Zilla::Plugin::MakeMaker v5.025.
use strict;
use warnings;

use 5.010001;

use ExtUtils::MakeMaker;



my %WriteMakefileArgs = (
  "ABSTRACT" => "A multi-purpose subroutine wrapping framework",
  "AUTHOR" => "perlancar <perlancar\@cpan.org>",
  "CONFIGURE_REQUIRES" => {
    "ExtUtils::MakeMaker" => 0
  },
  "DISTNAME" => "Perinci-Sub-Wrapper",
  "EXE_FILES" => [],
  "LICENSE" => "perl",
  "MIN_PERL_VERSION" => "5.010001",
  "NAME" => "Perinci::Sub::Wrapper",
  "PREREQ_PM" => {
    "Data::Sah" => "0.14",
    "Function::Fallback::CoreOrPP" => 0,
    "Log::Any" => 0,
    "Perinci::Sub::DepChecker" => "0.06",
    "Perinci::Sub::Normalize" => "0.04",
    "Perinci::Sub::Util" => 0,
    "Rinci" => "1.1.62",
    "String::LineNumber" => 0,
    "experimental" => 0
  },
  "TEST_REQUIRES" => {
    "File::Spec" => 0,
    "IO::Handle" => 0,
    "IPC::Open3" => 0,
    "Test::More" => "0.98"
  },
  "VERSION" => "0.67",
  "test" => {
    "TESTS" => "t/*.t"
  }
);


my %FallbackPrereqs = (
  "Data::Sah" => "0.14",
  "ExtUtils::MakeMaker" => 0,
  "File::Spec" => 0,
  "Function::Fallback::CoreOrPP" => 0,
  "IO::Handle" => 0,
  "IPC::Open3" => 0,
  "Log::Any" => 0,
  "Perinci::Sub::DepChecker" => "0.06",
  "Perinci::Sub::Normalize" => "0.04",
  "Perinci::Sub::Util" => 0,
  "Rinci" => "1.1.62",
  "String::LineNumber" => 0,
  "Test::More" => "0.98",
  "experimental" => 0
);


unless ( eval { ExtUtils::MakeMaker->VERSION(6.63_03) } ) {
  delete $WriteMakefileArgs{TEST_REQUIRES};
  delete $WriteMakefileArgs{BUILD_REQUIRES};
  $WriteMakefileArgs{PREREQ_PM} = \%FallbackPrereqs;
}

delete $WriteMakefileArgs{CONFIGURE_REQUIRES}
  unless eval { ExtUtils::MakeMaker->VERSION(6.52) };

WriteMakefile(%WriteMakefileArgs);



