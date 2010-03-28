
use strict;
use warnings;



use ExtUtils::MakeMaker 6.11;



my %WriteMakefileArgs = (
                       'test' => {
                                   'TESTS' => 't/*.t'
                                 },
                       'NAME' => 'test::project',
                       'DISTNAME' => 'test-project',
                       'CONFIGURE_REQUIRES' => {
                                                 'ExtUtils::MakeMaker' => '6.11'
                                               },
                       'AUTHOR' => 'agrangaard@rubiconproject.com',
                       'BUILD_REQUIRES' => {},
                       'ABSTRACT' => 'Test Project example of Dist::Zilla',
                       'EXE_FILES' => [],
                       'VERSION' => '0.100840',
                       'PREREQ_PM' => {},
                       'LICENSE' => 'perl'
                     );


delete $WriteMakefileArgs{LICENSE}
  unless eval { ExtUtils::MakeMaker->VERSION(6.31) };

WriteMakefile(%WriteMakefileArgs);



