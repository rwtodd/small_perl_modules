# Before 'make install' is performed this script should be runnable with
# 'make test'. After 'make install' it should work as 'perl English-Gematria.t'

#########################
use v5.36;
use Test::More tests => 3;

BEGIN {
  use_ok('English::Gematria');
  *EG:: = *English::Gematria::;
}

#########################


my $alw = EG::make_cipher('alw');

is($alw->sum('woman'),46,'ALW woman == 46');
is($alw->sum('ONE'),  46,'ALW one == 46');

