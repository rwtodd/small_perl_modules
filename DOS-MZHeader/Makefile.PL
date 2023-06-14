use 5.036001;
use ExtUtils::MakeMaker;
# See lib/ExtUtils/MakeMaker.pm for details of how to influence
# the contents of the Makefile that is written.
WriteMakefile(
    NAME              => 'DOS::MZHeader',
    VERSION_FROM      => 'lib/DOS/MZHeader.pm', # finds $VERSION, requires EU::MM from perl >= 5.5
    PREREQ_PM         => {}, # e.g., Module::Name => 1.1
    ABSTRACT_FROM     => 'lib/DOS/MZHeader.pm', # retrieve abstract from module
    AUTHOR            => 'Richard Todd <no@address>',
    LICENSE           => 'perl',
);
