# Before 'make install' is performed this script should be runnable with
# 'make test'. After 'make install' it should work as 'perl Tie-Hash-Default.t'

#########################

# change 'tests => 1' to 'tests => last_test_to_print';
use v5.36;
use Test::More tests => 11;

BEGIN { use_ok('Tie::Hash::Default') };

#########################

# test the default, identity value
tie my %tst, 'Tie::Hash::Default';
%tst = (name => 'Terry', job => 'Gardener');
is(scalar keys %tst, 2, 'stored keys 1');
is($tst{name},'Terry','normal lookup 1');
is($tst{job},'Gardener','normal lookup 2');
is($tst{markov},'markov','identity function of key 1');
is($tst{21}, 21, 'identity function of key 2');


# test a computed value...
tie my %compute, 'Tie::Hash::Default', sub($k) { $k * 100 };
$compute{1} = 5;
$compute{2} = 6;
is(scalar keys %compute, 2, 'stored keys 2');
is($compute{1},5,'normal lookup 3');
is($compute{2},6,'normal lookup 3');
is($compute{3},300,'computed lookup 1');
is($compute{4},400,'computed lookup 2');

