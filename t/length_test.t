use strict;
use warnings;

use Test::More;
use Test::More tests => 6;

my $num1 = 1;
ok($num1 == 1);

my $num2 = 2;
ok($num2 == 2);

{
  my $num1 = 1;
  my $num2 = 2;
  my $total = sum($num1, $num2);
  ok($total == 3, 'sum');
}

{
  my $num1 = 1;
  my $double = double($num1);
  ok($double == 2, 'double');
}

my $str = 3;
is($str, 3);
isnt($str, 5);


sub sum {
  my ($num1, $num2) = @_;
  return $num1 + $num2;
}

sub double {
  my $num = shift;
  return $num * 2
}
