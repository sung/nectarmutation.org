use strict;
use warnings;
use Test::More;


use Catalyst::Test 'Nectar::Web';
use Nectar::Web::Controller::Util::Messenger;

ok( request('/util/messenger')->is_success, 'Request should succeed' );
done_testing();
