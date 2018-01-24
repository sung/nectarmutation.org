use strict;
use warnings;
use Test::More;


use Catalyst::Test 'Nectar::Web';
use Nectar::Web::Controller::Browser::Run;

ok( request('/browser/run')->is_success, 'Request should succeed' );
done_testing();
