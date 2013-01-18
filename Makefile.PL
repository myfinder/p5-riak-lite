use inc::Module::Install;
name 'Riak-Lite';
all_from 'lib/Riak/Lite.pm';

# requires '';

tests 't/*.t';
author_tests 'xt';

test_requires 'Test::More';
auto_set_repository;
auto_include;
WriteAll;
