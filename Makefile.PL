BEGIN {
    my @devmods = qw(
        Module::Install::AuthorTests
        Module::Install::ReadmeFromPod
        Module::Install::Repository
    );
    my @not_available;

    {
        $|=1;
        local *STDOUT;
        eval qq{use inc::Module::Install; 1;} or push @not_available, 'inc::Module::Install';
    }

    for my $mod (@devmods) {
        eval qq{require $mod} or push @not_available, $mod;
    }
    if (@not_available) {
        print qq{# The following modules are not available.\n};
        print qq{# `$^X $0 | cpanm` will install them:\n};
        print $_, "\n" for @not_available;
        print "\n";
        exit -1;
    }
}

use inc::Module::Install;
$Module::Install::AUTHOR = 0 if $ENV{TRAVIS};

name 'Riak-Lite';
all_from 'lib/Riak/Lite.pm';

requires 'Mouse';
requires 'Cache::LRU';
requires 'Furl::HTTP';
requires 'Net::DNS::Lite';

tests_recursive;
author_tests 'xt';

test_requires 'Test::More';
auto_set_repository;
auto_include;
WriteAll;
