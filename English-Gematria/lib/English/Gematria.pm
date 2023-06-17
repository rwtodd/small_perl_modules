package English::Gematria;

use v5.36;
use Exporter qw/import/;
use Carp ();
our $VERSION = '0.01';

our %EXPORT_TAGS = ( 'all' => [ qw(
 names_ciphers make_cipher synonyms 
) ] );

our @EXPORT_OK = ( @{ $EXPORT_TAGS{'all'} } );
our @EXPORT = qw();

my %ciphers = (
  alw => 
    [1, 20, 13, 6, 25, 18, 11, 4, 23, 16, 9, 2, 21, 14, 7, 26, 19, 12, 5, 24, 17, 10, 3, 22, 15, 8],
  'love-x' =>
    [9, 20, 13, 6, 17, 2, 19, 12, 23, 16, 1, 18, 5, 22, 15, 26, 11, 4, 21, 8, 25, 10, 3, 14, 7, 24],
  'liber-cxv' =>
    [1, 5, 9, 12, 2, 8, 10, 0, 3, 6, 9, 14, 6, 13, 4, 7, 18, 15, 16, 11, 5, 8, 10, 11, 6, 32],
  leeds =>
    [1, 2, 3, 4, 5, 6, 7, 6, 5, 4, 3, 2, 1, 1, 2, 3, 4, 5, 6, 7, 6, 5, 4, 3, 2, 1],
  simple =>
    [1..26],
  'liber-a' =>
    [0..25],
  trigrammaton =>
    [5, 20, 2, 23, 13, 12, 11, 3, 0, 7, 17, 1, 21, 24, 10, 4, 16, 14, 15, 9, 25, 22, 8, 6, 18, 19]
);

sub named_ciphers() { keys %ciphers }

package English::Gematria::Cipher {
  use Carp ();
  use List::Util ();
  sub sum($self, $str) {
    List::Util::sum map { $self->{$_} // 0 } split(//, $str) 
  }

  sub new($cls,$cipher_hash) {
    Carp::croak 'Cipher definition must be a hash ref!' unless( ref($cipher_hash) eq 'HASH' );
    bless $cipher_hash, $cls;
  }

  sub add_to_lexicon($self, $lexicon, @words) {
    $lexicon->{$_} = $self->sum($_) for (@words);
  }

  sub describe($self, $fh=\*STDOUT) {
    my $count = 0;
    for my $k ('A' .. 'Z') {
      my $val = $self->{$k} // 0;
      my $lcval = $self->{lc $k} // 0;
      $val .= "/$lcval" if($val != $lcval);
      $fh->print("$k: $val",++$count % 5 == 0 ? "\n" : "\t")
    }
    for my $k (sort grep { m/[^A-Za-z]/ } keys %$self) {
      my $val = $self->{$k};
      $fh->print("$k: $val",++$count % 5 == 0 ? "\n" : "\t")
    }
    $fh->print("\n") unless $count % 5 == 0;
  }
}

sub make_cipher($cipher) {
  my %result;
  my @nums;
  $cipher = $ciphers{$cipher} if(ref($cipher) eq '');
  Carp::croak 'Bad argument for make_cipher' unless(ref($cipher) eq 'ARRAY'); 
  my $idx = 0;
  for my $letter ('A' .. 'Z') {
    $result{lc $letter} = $result{$letter} = $$cipher[$idx++]; 
  }
  English::Gematria::Cipher->new(\%result);
}

sub synonyms($dict) {
  my %result;
  for my $word (sort keys $dict->%*) {
    push $result{ $$dict{$word} }->@*, $word;
  }
  return \%result;
}

1;
__END__
# Below is stub documentation for your module. You'd better edit it!

=head1 NAME

English::Gematria - Perl extension for blah blah blah

=head1 SYNOPSIS

  use English::Gematria;
  my $alw = English::Gematria::make_cipher('alw');
  say $alw->sum('one');  # 46

=head1 DESCRIPTION

This module supports a number of common "Enlgish Qabalah" gematria ciphers.

=over 4

=item alw

The default english qabalah letter values. Named for A=1, L=2, W=3.

=item love-x

An inversion of the ALW cipher -- see New Order of Thelema

=item liber-cxv

From linda falorio, 1978 (see http://englishqabalah.com/).

=item leeds

1-7-1 1-7-1 cipher (see https://grahamhancock.com/leedsm1/).

=item simple

A-Z 1-26

=item trigrammaton

From R. Leo Gillis TQ (trigrammaton qabalah).

=item liber-a

Liber A vel Follis (see https://hermetic.com/wisdom/lib-follis).

=back

=head2 EXPORT

None by default.  Supports C<:all> to get at the functions.

=head1 SEE ALSO

TODO

=head1 AUTHOR

Richard Todd, E<lt>richardtodd@localE<gt>

=head1 COPYRIGHT AND LICENSE

Copyright (C) 2023 by Richard Todd

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself, either Perl version 5.36.1 or,
at your option, any later version of Perl 5 you may have available.


=cut
