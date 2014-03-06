#!perl

use 5.010;
use strict;
use warnings;

use Test::More 0.98;
use Test::Perinci::Sub::Wrapper qw(test_wrap);

subtest 'prop: args' => sub {
    my $sub = sub {
        my %args = @_;
        [200, "OK", join("", map{"$_=".($args{$_}//"")."\n"} "a".."e")];
    };
    my $meta;

    $meta = {v=>1.1, args=>{a=>{foo=>1}}};
    test_wrap(
        name      => 'unknown arg spec key -> dies',
        wrap_args => {sub => $sub, meta => $meta},
        wrap_dies => 1,
    );

    $meta = {v=>1.1, args=>{a=>{x=>1, "x.y"=>2}}};
    test_wrap(
        name      => 'arg spec key x',
        wrap_args => {sub => $sub, meta => $meta},
    );

    $meta = {v=>1.1, args=>{a=>{_foo=>1}}};
    test_wrap(
        name        => 'arg spec key prefixed by _ is ignored',
        wrap_args   => {sub => $sub, meta => $meta},
    );

    $meta = {v=>1.1, args=>{a=>{req=>1, schema=>'int*'}}};
    test_wrap(
        name        => 'req arg + schema req no schema default',
        wrap_args   => {sub => $sub, meta => $meta},
        calls       => [
            {argsr=>[a=>1], status=>200, name=>'ok'},
            {argsr=>[a=>1, -b=>1], status=>200, name=>'unknown special arg ok'},

            {argsr=>[a=>1, b=>1], status=>400, name=>'unknown arg'},
            {argsr=>["a b"=>1], status=>400, name=>'invalid arg name'},

            {argsr=>[], status=>400, name=>'missing arg'},
            {argsr=>[a=>"x"], status=>400, name=>'invalid arg value'},
            {argsr=>[a=>undef], status=>400, name=>'undef arg value'},
        ],
    );

    $meta = {v=>1.1, args=>{a=>{req=>1, schema=>[int => default=>10]}}};
    test_wrap(
        name        => 'req arg + schema no req with schema default',
        wrap_args   => {sub => $sub, meta => $meta},
        calls       => [
            {argsr=>[], status=>200, actual_res_re=>qr/^a=10/m,
             name=>'missing arg -> default supplied'},
            {argsr=>[a=>undef], status=>200, actual_res_re=>qr/^a=10/m,
             name=>'undef arg value -> default supplied'},
            {argsr=>[a=>"x"], status=>400, name=>'invalid arg value'},
        ],
    );

    $meta = {v=>1.1, args=>{a=>{req=>1, schema=>'int'}}};
    test_wrap(
        name        => 'req arg + schema no req no schema default',
        wrap_args   => {sub => $sub, meta => $meta},
        calls       => [
            {argsr=>[], status=>400, name=>'missing arg'},
            {argsr=>[a=>undef], status=>200, name=>'undef arg value'},
        ],
    );

    $meta = {v=>1.1, args=>{a=>{req=>1}}};
    test_wrap(
        name        => 'req arg + no schema',
        wrap_args   => {sub => $sub, meta => $meta},
        calls       => [
            {argsr=>[], status=>400, name=>'missing arg'},
            {argsr=>[a=>undef], status=>200, name=>'undef arg value'},
        ],
    );

    $meta = {v=>1.1, args=>{a=>{}}};
    test_wrap(
        name        => 'no req arg + schema no req with schema default',
        wrap_args   => {sub => $sub, meta => $meta},
        calls       => [
            {argsr=>[], status=>200, name=>'missing arg'},
            {argsr=>[a=>undef], status=>200, name=>'undef arg value'},
        ],
    );

    $meta = {v=>1.1, args=>{a=>{schema=>[int => default=>10]}}};
    test_wrap(
        name        => 'no req arg + schema with schema default',
        wrap_args   => {sub => $sub, meta => $meta},
        calls       => [
            {argsr=>[], status=>200, actual_res_like=>qr/^a=10/m,
             name=>'missing arg'},
            {argsr=>[a=>undef], status=>200, actual_res_like=>qr/^a=10/m,
             name=>'undef arg value'},
        ],
    );

    subtest "spec key: default" => sub {
        my $meta;

        $meta = {v=>1.1, args=>{a=>{schema=>"int", default=>10}}};
        test_wrap(
            name        => 'normal',
            wrap_args   => {sub => $sub, meta => $meta},
            calls       => [
                {argsr=>[], status=>200, actual_res_like=>qr/^a=10/m,
                 name=>'missing arg'},
                {argsr=>[a=>undef], status=>200, actual_res_like=>qr/^a=10/m,
                 name=>'undef arg value'},
                {argsr=>[a=>2], status=>200, actual_res_like=>qr/^a=2/m,
                 name=>'supplied arg'},
            ],
        );
        $meta = {v=>1.1, args=>{a=>{schema=>"int", default=>10, req=>1}}};
        test_wrap(
            name        => 'req',
            wrap_args   => {sub => $sub, meta => $meta},
            calls       => [
                {argsr=>[], status=>200, actual_res_like=>qr/^a=10/m,
                 name=>'missing arg'},
                {argsr=>[a=>undef], status=>200, actual_res_like=>qr/^a=10/m,
                 name=>'undef arg value'},
                {argsr=>[a=>2], status=>200, actual_res_like=>qr/^a=2/m,
                 name=>'supplied arg'},
            ],
        );
        $meta = {v=>1.1, args=>{a=>{schema=>[int => default=>5],
                                    default=>10, req=>1}}};
        test_wrap(
            name        => 'default prop supersedes schema default',
            wrap_args   => {sub => $sub, meta => $meta},
            calls       => [
                {argsr=>[], status=>200, actual_res_like=>qr/^a=10/m,
                 name=>'missing arg'},
                {argsr=>[a=>undef], status=>200, actual_res_like=>qr/^a=10/m,
                 name=>'undef arg value'},
                {argsr=>[a=>2], status=>200, actual_res_like=>qr/^a=2/m,
                 name=>'supplied arg'},
            ],
        );
    }; # spec key: default

}; # subtest

DONE_TESTING:
done_testing;
