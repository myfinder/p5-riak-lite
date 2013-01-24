use inc::Module::Install;
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
