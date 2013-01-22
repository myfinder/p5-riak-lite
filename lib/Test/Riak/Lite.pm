package Test::Riak::Lite;

use strict;
use warnings;

use Digest::MD5 qw/md5_hex/;
use Test::More;

use Sub::Exporter;

use Riak::Lite;

my @exports = qw/
    create_test_bucket_name
    skip_unless_riak
/;

Sub::Exporter::setup_exporter({
    exports => \@exports,
    groups  => { default => \@exports, }
});

sub create_test_bucket_name {
    my $prefix = shift || 'riak-lite-test';
    $prefix . '-' . md5_hex(scalar localtime);
}

sub skip_unless_riak {
    my $up = Riak::Lite->new(bucket => 'test-riak')->ping;
    unless ($up) {
        plan skip_all => 'no response from Riak, skip all tests'
    };
    $up;
}

1;
