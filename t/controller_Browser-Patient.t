use strict;
use warnings;
use Test::More;


use Catalyst::Test 'Nectar::Web';
use Nectar::Web::Controller::Browser::Patient;

ok( request('/browser/patient')->is_success, 'Request should succeed' );
done_testing();
