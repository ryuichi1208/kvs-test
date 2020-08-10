#!/usr/bin/perl

use strict;
use warnings;

use Cache::Memcached::Fast;
use String::Random;
use Data::Dumper;

my $debug = 0;

sub init_memd {
	my $memd = new Cache::Memcached::Fast({
		servers => [ { address => 'mem001:11211', weight => 2.5 },],
		namespace => 'test::',
		connect_timeout => 0.2,
		io_timeout => 0.5,
		close_on_error => 1,
		compress_threshold => 100_000,
		compress_ratio => 0.9,
		compress_methods => [ \&IO::Compress::Gzip::gzip,
					\&IO::Uncompress::Gunzip::gunzip ],
		max_failures => 3,
		failure_timeout => 2,
		ketama_points => 150,
		nowait => 1,
		hash_namespace => 1,
		serialize_methods => [ \&Storable::freeze, \&Storable::thaw ],
		utf8 => ($^V ge v5.8.1 ? 1 : 0),
		max_size => 512 * 1024,
	});

	return $memd
}

sub main {
	my @args = @_;
	my $memd = init_memd();

	my $versions = $memd->server_versions;
	while (my ($server, $version) = each %$versions) {
		print "$server: $version\n";
	}
}

main(@ARGV);

1;
