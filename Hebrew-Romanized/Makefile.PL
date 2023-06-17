use 5.036001;
use ExtUtils::MakeMaker;
# See lib/ExtUtils/MakeMaker.pm for details of how to influence
# the contents of the Makefile that is written.
WriteMakefile(
    NAME              => 'Hebrew::Romanized',
    VERSION_FROM      => 'lib/Hebrew/Romanized.pm', # finds $VERSION, requires EU::MM from perl >= 5.5
    PREREQ_PM         => { 'Tie::Hash::Default' => 1.0 }, # e.g., Module::Name => 1.1
    ABSTRACT_FROM     => 'lib/Hebrew/Romanized.pm', # retrieve abstract from module
    EXE_FILES         => ['bin/rom-hebrew'],
    AUTHOR            => 'Richard Todd <richardtodd@nothing>',
    LICENSE           => 'perl',
);
