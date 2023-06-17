package Hebrew::Romanized;

use v5.36;

use Exporter qw(import);

our @EXPORT_OK = qw/to_hebrew/;
our @EXPORT = ();
our $VERSION = '1.10';

use Tie::Hash::Default;
tie my %tbl, 'Tie::Hash::Default';
%tbl = (
  A => "\x{5d0}", B => "\x{5d1}", G => "\x{5d2}", D => "\x{5d3}",    # aleph, beth, gimel, dalet
  H => "\x{5d4}", V => "\x{5d5}", Z => "\x{5d6}", "Ch" => "\x{5d7}", # heh, vav, zain, cheth
  T => "\x{5d8}", I => "\x{5d9}", Kf => "\x{5da}", K => "\x{5db}",  Ki => "\x{5db}",  # tayt, yod, kaf_final, kaf, kaf_initial
  L => "\x{5dc}", Mf => "\x{5dd}", M => "\x{5de}", Mi => "\x{5de}", Nf => "\x{5df}",  # lamed, mem_final, mem, mem_initial, nun_final
  N => "\x{5e0}", S => "\x{5e1}", O => "\x{5e2}", Pf => "\x{5e3}",   # nun, samekh, ayin, peh_final
  P => "\x{5e4}", Pi => "\x{5e4}", Tzf => "\x{5e5}", Tz => "\x{5e6}", Tzi => "\x{5e6}", # peh, peh_initial, tzaddi_final, tzaddi, tzaddi_initial 
  Q => "\x{5e7}",  R => "\x{5e8}", Sh => "\x{5e9}", Th => "\x{5ea}",  # qoph, resh, shin, tav
  # niqqud
  ';;' => ';',       # escape an actual semicolon
  ';' => "\x{5b0}",  # Sh'va 
  ';3' => "\x{5b1}", # Reduced Segol
  ';_' => "\x{5b2}", # Reduced Patach
  ';7' => "\x{5b3}", # Reduced Kamatz
  '1' => "\x{5b4}",  # Hiriq
  '2' => "\x{5b5}",  # Zeire
  '3' => "\x{5b6}",  # Segol
  '_' => "\x{5b7}",  # Patach
  '7' => "\x{5b8}",  # Kamatz
  '*' => "\x{5bc}",  # Dagesh
  '\\' => "\x{5bb}",  # Kubutz
  '`' => "\x{5b9}",  # Holam
  'Shl' => "\x{5e9}\x{5c2}", # Shin dot left
  'Shr' => "\x{5e9}\x{5c1}"  # Shin dot right
);

my $niqqud = qr(;[;37_]?  |  [1237_*\\`])x; 

sub to_hebrew($rom) {
  # first, add automatic final letters...
  $rom =~ s{
    (K|M|N|P|Tz)   # one of the potential final letters
    (?=$niqqud*+   # looking at zero or more niqqud...
       (?:\W|\Z))  # ...followed by a non-word or end-of-line 
  }{$&f}gx;        # then make it final

  # second, perform the transliteration, allowing for 2 niqqud between each letter
  $rom =~ s!
    ([A-Z][fhilz]*+)       # consonant (and Shin dots)
    ($niqqud?+)($niqqud?+) # possible niqqud 
  !$tbl{$1}$tbl{$2}$tbl{$3}!gx;
  $rom
}

1;
__END__

=head1 NAME

Hebrew::Romanized - Handle Romanized Hebrew Letters

=head1 SYNOPSIS

  use Hebrew::Romanized qw/to_hebrew/;
  say to_hebrew("KThR HVD");

=head1 DESCRIPTION

This romanization scheme is the one chosen by my edition of I<The Qabalah Unveiled>,
which I have seen also in other esoteric books.  It may not be the most scholarly, but
it's the one with which I'm most familiar.

=head2 THE ROMANIZATION

  A  = aleph   B  = beth    G  = gimel    D  = dalet
  H  = heh     V  = vav     Z  = zayin    Ch = chet
  T  = teth    I  = yod     K  = kaf      L  = lamed
  M  = mem     N  = nun     S  = samekh   O  = ayin
  P  = peh     Tz = tzaddi  Q  = qoph     R  = resh
  Sh = shin    Th = tav

  Niqqud:
  ;  = Sh'va                *  = Dagesh
  \\ =  Kubutz              `  = Holam
  1  = Hiriq                2  = Zeire                
  3  = Segol                ;3 = Reduced Segol        
  _  = Patach               ;_ = Reduced Patach       
  7  = Kamatz               ;7 = Reduced Kamatz       
  Shl = Shin dot left       Shr = Shin dot right
      ;; = escape an actual semicolon

And, when a letter can be final, you can optionally add an 'i' or an 'f' to the end of it to
force the transliteration to use the initial or final forms.  Otherwise, the module will
translate potential finals on word boundaries to their final form automatically.

=head1 SEE ALSO

Qabalah books, good for your mind.

=head1 AUTHOR

Richard Todd, E<lt>richardtodd@nothing<gt>

=head1 COPYRIGHT AND LICENSE

Copyright (C) 2023 by Richard Todd

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself, either Perl version 5.36.1 or,
at your option, any later version of Perl 5 you may have available.

=cut
