#!/usr/bin/perl
use strict;
use warnings;
use Cache::Memcached::Fast;
my $KEY = $ARGV[0];
my @servers = qw/mem001/;

my $debug = 1;

for my $server ( @servers ) {
    chomp $server;
    my $memd = Cache::Memcached::Fast->new({
        servers => ["$server:11211"],
    });

    my $versions = $memd->server_versions;
    while (my ($server, $version) = each %$versions) {
        print "$server: $version\n";
    }
    if $memd->get($KEY) {
        print "Found at $server\n"
        $memd->touch($KEY, 60) if $debug;
    }
}
