# Before 'make install' is performed this script should be runnable with
# 'make test'. After 'make install' it should work as 'perl Hebrew-Romanized.t'

#########################

use strict;
use warnings;

use Test::More tests => 6;
BEGIN { 
  use_ok('Hebrew::Romanized');
  *HR:: = *Hebrew::Romanized::; 
};

#########################

is(HR::to_hebrew("KThR"), "\x{5db}\x{5ea}\x{5e8}", "basic transliteration");
is(HR::to_hebrew("MOTz"), "\x{5de}\x{5e2}\x{5e5}", "auto finalization");
is(HR::to_hebrew("MOTzi"), "\x{5de}\x{5e2}\x{5e6}", "override finalization");

is(HR::to_hebrew("K*ThR"), "\x{5db}\x{5bc}\x{5ea}\x{5e8}", "finalization works correctly with niqqud 1");
is(HR::to_hebrew("MOTz7"), "\x{5de}\x{5e2}\x{5e5}\x{5b8}", "finalization works correctly with niqqud 2");
