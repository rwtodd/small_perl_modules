#########################

use v5.36;

use Test::More tests => 11;
BEGIN {
  use_ok('Date::Discordian');
  *Disco:: = *Date::Discordian::; 
}

# test a random date
my $dd = Disco::ddate_ymd(2020,2,19);
is($$dd{year},3186, 'disco year 1');
is($$dd{holy_day},'Chaoflux', 'disco holiday 1');
is($$dd{season},'Chaos', 'disco season 1');
is($$dd{season_abbrv},'Chs', 'disco season 2');
is($$dd{day_of_season},50, 'disco day 1');

# test the x-day calculation
is(Disco::ddate_ymd(8661,2,1)->{days_til_xday},154, 'days til x 1');
is(Disco::ddate_ymd(8661,7,1)->{days_til_xday},4, 'days til x 2');
is(Disco::ddate_ymd(8661,7,5)->{days_til_xday},0, 'days til x 3');
is(Disco::ddate_ymd(8661,7,6)->{days_til_xday},-1, 'days til x 4');
is(Disco::ddate_ymd(8656,2,29)->{days_til_xday},1953, 'days til x 5');

