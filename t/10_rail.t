use strict;
use Test::More;
use Test::Riak::Lite;

use Riak::Lite;

use JSON;

skip_unless_riak;

my $bucket_name = create_test_bucket_name;

ok my $riak = Riak::Lite->new(
    bucket  => 'fout-'.$bucket_name,
);

subtest 'ping and stats' => sub {
    ok $riak->ping eq 'OK', 'ping ok';
    ok decode_json $riak->stats, 'stats ok';
};

subtest 'simple key/value set/get/remove' => sub {
    ok $riak->get('key') eq undef, 'return undef ok';
    ok $riak->set('key', 'value'), 'simple set ok';
    ok $riak->get('key') eq 'value', 'return value ok';
    ok $riak->delete('key'), 'remove key/value ok';
    ok $riak->get('key') eq undef, 'return undef ok';
};

subtest 'structured value set/get/remove' => sub {
    my $value = {
        foo  => 'var',
        hoge => [ 'piyo', 'poyo' ],
    };

    ok $riak->get('key') eq undef, 'return undef ok';
    ok $riak->set('key', encode_json $value), 'structured value set ok';
    is_deeply decode_json $riak->get('key'), $value, 'return value ok';
    ok $riak->delete('key'), 'remove key/value ok';
    ok $riak->get('key') eq undef, 'return undef ok';
};

done_testing;
