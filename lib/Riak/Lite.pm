package Riak::Lite;
use Mouse;

use Cache::LRU;
use Furl::HTTP;
use Net::DNS::Lite;

our $VERSION = '0.01';

$Net::DNS::Lite::CACHE = Cache::LRU->new( size => 256 );

has server => (
    is      => 'rw',
    isa     => 'Str',
    lazy    => 1,
    default => '127.0.0.1',
);

has port => (
    is      => 'rw',
    isa     => 'Int',
    lazy    => 1,
    default => 8098,
);

has bucket => (
    is       => 'rw',
    isa      => 'Str',
    required => 1,
);

has timeout => (
    is      => 'rw',
    isa     => 'Num',
    default => 1,
);

has client => (
    is      => 'ro',
    isa     => 'Furl::HTTP',
    lazy    => 1,
    default => sub {
        Furl::HTTP->new(
            agent   => "Riak-Lite/$VERSION",
            timeout => shift->timeout,
            inet_aton => \&Net::DNS::Lite::inet_aton,
        )
    },
);

sub get {
    my ($self, $key) = @_;

    my ($minor_version, $code, $msg, $headers, $body) = $self->client->request(
        method     => 'GET',
        host       => $self->server,
        port       => $self->port,
        path_query => '/riak/'.$self->bucket.'/'.$key
    );

    if ($code == 200) {
        return $body;
    }
    else {
        return;
    }
}

sub set {
    my ($self, $key, $value) = @_;

    use Data::Dump qw/dump/;

    my ($minor_version, $code, $msg, $headers, $body) = $self->client->request(
        method     => 'PUT',
        host       => $self->server,
        port       => $self->port,
        path_query => '/riak/'.$self->bucket.'/'.$key,
        headers    => [ 'Content-Type' => 'text/plain' ],
        content    => $value,
    );

    if ($code == 200 || $code == 204) {
        return 1;
    }
    else {
        return;
    }
}

sub delete {
    my ($self, $key) = @_;

    my ($minor_version, $code, $msg, $headers, $body) = $self->client->request(
        method     => 'DELETE',
        host       => $self->server,
        port       => $self->port,
        path_query => '/riak/'.$self->bucket.'/'.$key
    );

    if ($code == 204 || $code == 404) {
        return 1;
    }
    else {
        return;
    }
}

sub ping {
    my $self = shift;

    my ($minor_version, $code, $msg, $headers, $body) = $self->client->request(
        method     => 'GET',
        host       => $self->server,
        port       => $self->port,
        path_query => '/ping',
    );

    if ($body eq 'OK') {
        return $body;
    }
    else {
        return;
    }
}

sub stats {
    my $self = shift;

    my ($minor_version, $code, $msg, $headers, $body) = $self->client->request(
        method     => 'GET',
        host       => $self->server,
        port       => $self->port,
        path_query => '/stats',
    );

    if ($code == 200) {
        return $body;
    }
    else {
        return;
    }
}

no Mouse;
__PACKAGE__->meta->make_immutable;
1;
__END__

=head1 NAME

Riak::Lite - simple and lightweight client interface to Riak

=head1 SYNOPSIS

  use Riak::Lite;

  my $riak = Riak::Lite->new(
    server     => '127.0.0.1',
    port       => 8098,
    bucket     => 'bucket_name',
    teimeout   => 0.05,
  );

Set

  $riak->set('key', 'value');

Set Structured Object

  use JSON;

  my $value = {
    foo => 'bar',
  };

  $riak->set('key', encode_json $value);

Get

  my $obj = $riak->get('key');

Delete

  $riak->delete('key');


=head1 DESCRIPTION

Riak::Lite is simple and lightweight client interface to Riak

=head1 AUTHOR

Tatsuro Hisamori E<lt>myfinder@cpan.orgE<gt>

=head1 SEE ALSO

=head1 LICENSE

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself.

=cut
