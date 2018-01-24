use strict;
use warnings;
use Test::More;


use Catalyst::Test 'Nectar::Web';
use Nectar::Web::Controller::Browser::Target;

ok( request('/browser/target')->is_success, 'Request should succeed' );
done_testing();
