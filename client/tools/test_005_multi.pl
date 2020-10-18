#!/usr/bin/env perl

use warnings;
use strict;

use Cache::Memcached::Fast;
use String::Random;
use Data::Dumper;

sub init_memd {
    my $memd = new Cache::Memcached::Fast({
        servers => [ { address => 'mem001:11211'}, {address => 'mem002:11211'}],
    });
}

sub main {
    my ($num, $atomic_flg) = @_;
    my $cpu_num = $num ? $num : qx(grep -c processor /proc/cpuinfo);
    chomp($cpu_num);
    my $key = "key";
    my $m = init_memd();
    $m->set($key, 0);
    for (my $j = 0; $j < $cpu_num; $j++) {
        my $pid = fork;
        if ($pid) {
            next;
        } elsif ($pid == 0) {
            my $memd = init_memd();
            my $count = 0;
            my $val = 0;
            for (my $i = 0; $i < 100; $i++) {
                if ($atomic_flg) {
                    $count = $memd->incr($key, 1);
                    print "$$: $count\n";
                } else {
                    $count = $memd->get($key);
                    $count++;
                    print "$$: $count\n";
                    $memd->set($key, $count, 60 * 5)
                }
            }
            exit;
        }
    }
    wait;
}

main(@ARGV);

1;
