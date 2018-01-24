use strict;
use warnings;
use Test::More;


use Catalyst::Test 'Nectar::Web';
use Nectar::Web::Controller::Util::Service;

ok( request('/util/service')->is_success, 'Request should succeed' );
done_testing();
