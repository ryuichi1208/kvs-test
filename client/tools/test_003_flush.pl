use Cache::Memcached::Fast;
use String::Random;

my $memd = new Cache::Memcached::Fast({
	servers => [ { address => 'mem001:11211'},{ address => 'mem002:11211'}],
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
$memd->flush_all;
