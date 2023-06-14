package DOS::MZHeader;

use v5.36;
use Exporter qw/import/;
use Carp ();

our @EXPORT_OK = qw( read_mz_header );
our @EXPORT = ();
our $VERSION = '0.01';


# Preloaded methods go here.
sub read_mz_header($filename) {
  open my $exe, '<:raw', $filename or Carp::croak("Unable to open $filename");
  my $data;
  $exe->read($data, 0x1C) == 0x1C or Carp::croak("Unable to read mz header!");
  $exe->close;
  return parse_mz_header($data);
}

sub parse_mz_header($content) {
  my %result = ();
  $result{'magic'} = unpack 'A2', $content;
  Carp::croak "Bad EXE magic <$result{magic}>"
    unless ($result{magic} eq 'MZ')||($result{magic} eq 'ZM');
  $content = substr $content, 2;
  @result{qw/extra_bytes pages relocation_items header_paragraphs/} = 
    unpack 'v4', $content;
  $content = substr $content, 8;
  @result{qw/min_alloc max_alloc/} = unpack 'v2', $content;
  $content = substr $content, 4;
  @result{qw/ss sp ip cs reloc_table overlay/} = unpack 'v2 x2 v4', $content;

  return \%result; 
}

1;
__END__
# Below is stub documentation for your module. You'd better edit it!

=head1 NAME

DOS::MZHeader - Perl extension for blah blah blah

=head1 SYNOPSIS

  use DOS::MZHeader;
  blah blah blah

=head1 DESCRIPTION

Stub documentation for DOS::MZHeader, created by h2xs. It looks like the
author of the extension was negligent enough to leave the stub
unedited.

Blah blah blah.

=head2 EXPORT

None by default.



=head1 SEE ALSO

Mention other useful documentation such as the documentation of
related modules or operating system documentation (such as man pages
in UNIX), or any relevant external documentation such as RFCs or
standards.

If you have a mailing list set up for your module, mention it here.

If you have a web site set up for your module, mention it here.

=head1 AUTHOR

A. U. Thor, E<lt>rwtodd@nonetE<gt>

=head1 COPYRIGHT AND LICENSE

Copyright (C) 2023 by A. U. Thor

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself, either Perl version 5.36.1 or,
at your option, any later version of Perl 5 you may have available.


=cut
