use strict;
use warnings;
use Test::More;


use Catalyst::Test 'Nectar::Web';
use Nectar::Web::Controller::Browser::Mutation;

ok( request('/browser/mutation')->is_success, 'Request should succeed' );
done_testing();
