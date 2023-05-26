package Date::Discordian;

use v5.36;

use Exporter qw/import/;
use Time::Local qw/timelocal_modern/;

our @EXPORT_OK = qw/ddate ddate_ymd fmt_ddate/;
our $VERSION = '1.00';

my $TIBS = "St. Tib's Day";
my @SEASONS = ('Chaos','Chs','Discord','Dsc','Confusion','Cfn',
 'Bureaucracy','Bcy','The Aftermath','Afm');
my @DAYS = ('Sweetmorn','SM','Boomtime','BT','Pungenday','PD','Prickle-Prickle','PP',
    'Setting Orange','SO');
my @HOLIDAY_5 = qw(Mungday Mojoday Syaday Zaraday Maladay);
my @HOLYDAY_50 = qw(Chaoflux Discoflux Confuflux Bureflux Afflux);
my @EXCLAIM = ('Hail Eris!', 'All Hail Discordia!', 'Kallisti!', 'Fnord.', 'Or not.',
    'Wibble.', 'Pzat!', 'P\'tang!', 'Frink!', 'Slack!', 'Praise \'Bob\'!', 'Or kill me.',
    'Grudnuk demand sustenance!', 'Keep the Lasagna flying!',
    'You are what you see.', 'Or is it?', 'This statement is false.',
    'Lies and slander, sire!', 'Hee hee hee!', 'Hail Eris, Hack Perl!');

# X-Day was originally Cfn 40, 3164.  The scriptures say...
# 
# After `X-Day' passed without incident, the CoSG declared that it had 
# got the year upside down --- X-Day is actually in 8661 AD rather than 
# 1998 AD.
# 
# Thus, the True X-Day is Cfn 40, 9827.
sub days_til_x($y,$d) {
  use builtin qw/ceil/;
  no warnings 'experimental::builtin';

  my $xy = 8661; # X-Day is 8661, day 185
  my $xd = 185;
  my $flip = 1;
  if($xy < $y || ($y == $xy && $d > $xd)) {
    $flip = -1;
    ($xy,$xd,$y,$d) = ($y,$d,$xy,$xd);
  }
  if($y < 0) {
    my $addend = -400 * int($y / 400);
    $y += $addend;
    $xy += $addend;
  }
  return $flip * (365 * ($xy - $y) + $xd - $d 
                  + ceil($xy/4)   - ceil($y/4)
                  - ceil($xy/100) + ceil($y/100)
                  + ceil($xy/400) - ceil($y/400));
}

sub ddate($epoch=undef) {
  my ($year,$yday) = ( localtime($epoch // time()) )[5,7];
  $year += 1900;
  my $leapyr = is_leapyear($year);
  my $adjustedDay = $yday - (($leapyr && $yday > 59) ? 1 : 0);
  my $seasonNbr = int($adjustedDay / 73);
  my $seasonDay = ($adjustedDay % 73) + 1;
  my $weekDay = $adjustedDay % 5;
  my $tibs_p = $leapyr && $yday == 59;
  my $holyDay = ($seasonDay == 5 && $HOLIDAY_5[$seasonNbr]) || 
    ($seasonDay == 50 && $HOLYDAY_50[$seasonNbr]) || 
    undef;

  {
    year => $year + 1166, 
    day_of_year => $yday,
    season => $tibs_p ? $TIBS : $SEASONS[2 * $seasonNbr],
    season_abbrv => $tibs_p ? $TIBS : $SEASONS[2 * $seasonNbr + 1],
    day_of_season => $seasonDay,
    weekday => $tibs_p ? $TIBS : $DAYS[2 * $weekDay],
    weekday_abbrv => $tibs_p ? $TIBS : $DAYS[2 * $weekDay + 1],
    is_tibs => $tibs_p,
    holy_day => $holyDay,
    days_til_xday => days_til_x($year,$yday)
  }
}

sub ddate_ymd($y,$m,$d) {
  ddate(timelocal_modern(0,0,0,$d,$m-1,$y));
}

my %callbacks = (
    '%' => sub { '%' },
    'n' => sub { "\n" },
    't' => sub { "\t" },
    'A' => sub($dd) { $$dd{weekday} },
    'a' => sub($dd) { $$dd{weekday_abbrv} },
    'B' => sub($dd) { $$dd{season} },
    'b' => sub($dd) { $$dd{season_abbrv} },
    'd' => sub($dd) { $$dd{day_of_season} },
    'e' => sub($dd) {
      my $ord = 'th';
      my $dos = $$dd{day_of_season};
      if ($dos < 4 || $dos > 20) {
        my $digit = $dos % 10;
        if($digit == 1) { $ord = "st" }
        elsif($digit == 2) { $ord = "nd" }
        elsif($digit == 3) { $ord = "rd" }
      }
      "$dos$ord"
    },
    'H' => sub($dd) { $$dd{holy_day} // '' },
    'X' => sub($dd) { $$dd{days_til_xday} },
    'Y' => sub($dd) { $$dd{year} },
    '.' => sub { $EXCLAIM[int(rand(@EXCLAIM))] }
);

sub _nothing($dd) { '' }

sub fmt_ddate($fstring,$dd) {
  my $nothing= \&_nothing;
  $fstring =~ s!%N.*$!! unless defined $dd->{holy_day};
  $fstring =~ s!%\{.*?%\}!$TIBS!g if $dd->{is_tibs};
  $fstring =~ s!%(.)!($callbacks{$1} // $nothing)->($dd)!ge;
  return $fstring;
}

sub is_leapyear($y) { $y % 4 == 0 and $y % 100 != 0 or $y % 400 == 0 }

1;
__END__
# Below is stub documentation for your module. You'd better edit it!

=head1 NAME

Date::Discordian - Calculating the discordian date

=head1 SYNOPSIS

  use Date::Discordian qw/ddate fmt_ddate/;
  say fmt_ddate("The year is %Y. %.",ddate);

=head1 DESCRIPTION

This is a module for converting epoch-C<time> and dates to days of the
Discordian Calendar.

=head2 ddate($epoch=undef)

This function converts a seconds-since-epoch timestamp (such as from the
C<time> function) into a hash of information about the equivalent Discordian date.
If called without an argument, it uses the current time.

=head3 Hash Keys

  year           the YOLD
  day_of_year    the day within the year [0-364 for non-tibsyears] 
  season         Chaos|Discord|Confusion|Bureaucracy|The Aftermath
  season_abbrv   Chs  |Dsc    |Cfn      |Bcy        |Afm
  day_of_season  [1-73]
  weekday        Sweetmorn|Boomtime|Pungenday|Prickle-Prickle|Setting Orange
  weekday_abbrv  SM       |BT      |PD       |PP             |SO
  is_tibs        true|false 
  holy_day       Mungday |Mojoday  |Syaday   |Zaraday |Maladay
                 Chaoflux|Discoflux|Confuflux|Bureflux|Afflux
  days_til_xday  Days until Cfn 40, 9827

=head2 ddate_ymd($year,$month,$day)

This function converts a given year, month, and day into a hash of information
about the equivalent Discordian date. The hash returned is just like the one
from C<ddate>.

=head2 fmt_ddate($fmt_str, $ddate)

This function takes a format string, and a hash of discordian date information
(such as what one gets from C<ddate>), and returns a formatted string. The
format specifiers are all prefixed with a C<%> (percent-sign):

  %A  weekday        /  %a  weekday (short version)
  %B  season         /  %b  season (short version)
  %d  day of season  /  %e  ordinal day of season
  %Y  the Year of Our Lady of Discord
  %X  the number of days left until X-Day

  %H  name of the holy day, if it is one
  %N  directive to skip the rest of the format
      if today is not a holy day

  %{ ... %}  either announce Tibs Day, or format the
             interior string if it is not Tibs Day

  %n  newline        /  %t  tab

=head1 SEE ALSO

=over 4

=item * L<Principia Discordia.|http://www.ology.org/principia/>

=back

=head1 AUTHOR

Richard Todd, E<lt>no@email<gt>

=head1 COPYRIGHT AND LICENSE

Copyright (C) 2023 by Richard Todd

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself, either Perl version 5.36.1 or,
at your option, any later version of Perl 5 you may have available.

=cut
