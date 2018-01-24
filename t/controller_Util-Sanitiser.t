use strict;
use warnings;
use Test::More;


use Catalyst::Test 'Nectar::Web';
use Nectar::Web::Controller::Util::Sanitiser;

ok( request('/util/sanitiser')->is_success, 'Request should succeed' );
done_testing();
