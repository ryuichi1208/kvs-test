#!perl
use strict;
use warnings;
use Cache::Memcached;
use Data::Dumper;

my @_SERVERS = [{address => 'mem001:11211'},
		{address => 'mem002:11211'},
		{address => 'mem003:11211'},
		{address => 'mem004:11211'}
	];

my $memd = new Cache::Memcached {
	servers => @_SERVERS,
	ketama_points => 150,
	max_failures => 1,
	failure_timeout => 1
};

my $loop = 30;
for (my $i = 0; $i < $loop; $i++) {
	$memd->add("$i" => $i);
}
