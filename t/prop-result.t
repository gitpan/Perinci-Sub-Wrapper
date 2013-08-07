#!perl

use 5.010;
use strict;
use warnings;

use Test::More 0.98;
use Test::Perinci::Sub::Wrapper qw(test_wrap);

my $sub;
my $meta;

$sub  = sub {};
$meta = {v=>1.1};
test_wrap(
    name      => 'wrapper checks that sub produces enveloped result',
    wrap_args => {sub => $sub, meta => $meta},
    calls     => [
        {argsr=>[], status=>500},
    ],
);

$sub  = sub {my %args = @_; [200, "OK", $args{err} ? "x":1]};
$meta = {v=>1.1, args=>{err=>{}}, result=>{schema=>"int"}};
test_wrap(
    name      => 'basics',
    wrap_args => {sub => $sub, meta => $meta},
    calls     => [
        {argsr=>[], status=>200},
        {argsr=>[err=>1], status=>500},
    ],
);

test_wrap(
    name      => 'opt: validate_result=0',
    wrap_args => {sub => $sub, meta => $meta, validate_result=>0},
    calls     => [
        {argsr=>[], status=>200},
        {argsr=>[err=>1], status=>200},
    ],
);

done_testing;