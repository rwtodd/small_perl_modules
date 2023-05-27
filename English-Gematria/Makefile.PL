use v5.36;
use ExtUtils::MakeMaker;
# See lib/ExtUtils/MakeMaker.pm for details of how to influence
# the contents of the Makefile that is written.
WriteMakefile(
    NAME              => 'English::Gematria',
    VERSION_FROM      => 'lib/English/Gematria.pm', # finds $VERSION, requires EU::MM from perl >= 5.5
    PREREQ_PM         => {}, # e.g., Module::Name => 1.1
    ABSTRACT_FROM     => 'lib/English/Gematria.pm', # retrieve abstract from module
    AUTHOR            => 'Richard Todd <no@email>',
    LICENSE           => 'perl',
);
