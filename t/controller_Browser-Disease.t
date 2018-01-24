use strict;
use warnings;
use Test::More;


use Catalyst::Test 'Nectar::Web';
use Nectar::Web::Controller::Browser::Disease;

ok( request('/browser/disease')->is_success, 'Request should succeed' );
done_testing();
