package Test::Perinci::Sub::Wrapper;

use 5.010;
use strict;
use warnings;

use Perinci::Sub::Wrapper qw(wrap_sub);
use Test::More 0.96;

our @ISA = qw(Exporter);
our @EXPORT_OK = qw(test_wrap);

our $VERSION = '0.46'; # VERSION

sub test_wrap {
    my %test_args = @_;
    my $wrap_args = $test_args{wrap_args} or die "BUG: wrap_args not defined";
    my $test_name = $test_args{name} or die "BUG: test name not defined";

    subtest $test_name => sub {

        my $wrap_res;
        eval { $wrap_res = wrap_sub(%$wrap_args) };
        my $wrap_eval_err = $@;
        if ($test_args{wrap_dies}) {
            ok($wrap_eval_err, "wrap dies");
            return;
        } else {
            ok(!$wrap_eval_err, "wrap doesn't die") or diag $wrap_eval_err;
        }

        if (defined $test_args{wrap_status}) {
            is(ref($wrap_res), 'ARRAY', 'wrap res is array');
            is($wrap_res->[0], $test_args{wrap_status},
               "wrap status is $test_args{wrap_status}")
                or diag "wrap res: ", explain($wrap_res);
        }

        return unless $wrap_res->[0] == 200;

        my $call_argsr = $test_args{call_argsr};
        my $call_res;
        if ($call_argsr) {
            my $sub = $wrap_res->[2]{sub};
            eval { $call_res = $sub->(@$call_argsr) };
            my $call_eval_err = $@;
            if ($test_args{call_dies}) {
                ok($call_eval_err, "call dies");
                if ($test_args{call_die_message}) {
                    like($call_eval_err, $test_args{call_die_message},
                         "call die message");
                }
                return;
            } else {
                ok(!$call_eval_err, "call doesn't die")
                    or diag $call_eval_err;
            }

            if (defined $test_args{call_status}) {
                is(ref($call_res), 'ARRAY', 'call res is array')
                    or diag "call res = ", explain($call_res);
                is($call_res->[0], $test_args{call_status},
                   "call status is $test_args{call_status}")
                    or diag "call res = ", explain($call_res);
            }

            if (exists $test_args{call_res}) {
                is_deeply($call_res, $test_args{call_res},
                          "call res")
                    or diag explain $call_res;
            }

            if (exists $test_args{call_actual_res_re}) {
                like($call_res->[2], $test_args{call_actual_res_re},
                     "call actual res");
            }
        }

        if ($test_args{calls}) {
            my $sub = $wrap_res->[2]{sub};
            my $i = 0;
            for my $call (@{$test_args{calls}}) {
                $i++;
                subtest "call #$i: ".($call->{name} // "") => sub {
                    my $res;
                    eval { $res = $sub->(@{$call->{argsr}}) };
                    my $eval_err = $@;
                    if ($call->{dies}) {
                        ok($eval_err, "dies");
                        if ($call->{die_message}) {
                            like($eval_err, $call->{die_message},
                                 "die message");
                        }
                        return;
                    } else {
                        ok(!$eval_err, "doesn't die")
                            or diag $eval_err;
                    }

                    if (defined $call->{status}) {
                        is(ref($res), 'ARRAY', 'res is array')
                            or diag "res = ", explain($res);
                        is($res->[0], $call->{status},
                           "status is $call->{status}")
                            or diag "res = ", explain($res);
                    }

                    if (exists $call->{res}) {
                        is_deeply($res, $call->{res}, "res")
                            or diag explain $res;
                    }

                    if (exists $call->{actual_res_re}) {
                        like($res->[2], $call->{actual_res_re}, "actual res");
                    }
                }; # subtest call #$i
            }
        } # if calls

        if ($test_args{posttest}) {
            $test_args{posttest}->($wrap_res, $call_res);
        }

        done_testing();
    };
}

1;
# ABSTRACT: Provide test_wrap() to test wrapper

__END__

=pod

=encoding utf-8

=head1 NAME

Test::Perinci::Sub::Wrapper - Provide test_wrap() to test wrapper

=head1 VERSION

version 0.46

=for Pod::Coverage test_wrap

=head1 AUTHOR

Steven Haryanto <stevenharyanto@gmail.com>

=head1 COPYRIGHT AND LICENSE

This software is copyright (c) 2013 by Steven Haryanto.

This is free software; you can redistribute it and/or modify it under
the same terms as the Perl 5 programming language system itself.

=head1 DESCRIPTION

=head1 FUNCTIONS


None are exported by default, but they are exportable.

=cut
