package Tie::Hash::Default;

use v5.36;
use Tie::Hash;

our @ISA = qw(Tie::ExtraHash);
our $VERSION = '1.0';

my $identity = sub($k) { $k };

sub FETCH($self, $key) { 
  $self->[0]{$key} // ($self->[1] // $identity)->($key)
}

1;

__END__

=head1 NAME

Tie::Hash::Default - Hashes that compute missing values

=head1 SYNOPSIS

  use Tie::Hash::Default;
  tie my %var, 'Tie::Hash::Default'; # no sub given
  %var = (hi => 10);
  $var{hi};    # ==> 10
  $var{hello}; # ==> 'hello' , just returns the key unchanged


  tie my %var, 'Tie::Hash::Default', sub($k) { $k*10 };
  $var{0} = 999;
  $var{12};    # ==> 120, calculates since the key isn't stored
  $var{0};     # ==> 999, straight lookup

=head1 DESCRIPTION

A hash that defaults to a user-supplied function of the key
if the value is not found in the hash.  This is useful for
functions that have a few exceptions, or -- another way to
say the same thing -- a hash where most of the values are computable
from the key, but others must be stored.

=head1 AUTHOR

Richard Todd, E<lt>richard.wesley.todd@gmail.com<gt>

=head1 COPYRIGHT AND LICENSE

Copyright (C) 2023 by Richard Todd

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself, either Perl version 5.36.1 or,
at your option, any later version of Perl 5 you may have available.

=cut
