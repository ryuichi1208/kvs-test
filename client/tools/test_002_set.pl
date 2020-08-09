#!perl
use strict;
use warnings;
use Cache::Memcached::Fast;

my $memd = Cache::Memcached::Fast->new({
    servers => [ { address => 'localhost:11211' }],
}); 

# 値を追加 key => value
$memd->add('id' => 'koba04');
$memd->add('age' => 28);

# 値を取得
my $id = $memd->get('id');
my $age = $memd->get('age');

# 値を設定
$memd->set('age' => 57);

# 値を変更
$memd->replace('age' => 28);
