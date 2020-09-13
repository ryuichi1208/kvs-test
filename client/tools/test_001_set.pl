#!/usr/bin/perl

use strict;
use warnings;

use Cache::Memcached::Fast;
use String::Random;

my $debug = 0;

sub init_memd {
	my $memd = new Cache::Memcached::Fast({
			servers => [ { address => 'mem001:11211'}, {address => 'mem002:11211'}],
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
	my $cpu_num = qx(grep -c processor /proc/cpuinfo);
	chomp($cpu_num);
	for (my $j = 0; $j < $cpu_num; $j++) {
		my $pid = fork();
		if ($pid) {
			print "P:[$$] parent proc\n" if $debug;
			wait;
		} elsif ($pid == 0) {
			print "C:[$$] child prorc\n" if $debug;
			my $memd = init_memd();
			my $i = 0;
			my $sr = String::Random->new();
			while ($i < 10) {
				# ランダムな長さのvalueを登録
				my $value = $sr->randregex('.{8,32}');
				my $keys = "key::" . $i . "::" . $$;
				$memd->set("$keys", "$value", 60 - $i);
				$i++;
				my $g_value = $memd->get($keys);
				print "keys->$keys value->$g_value\n" if $debug;
			}
			exit();
		}
	}
}

main();

1;
