use strict;
use warnings;
use Test::More;


use Catalyst::Test 'Nectar::Web';
use Nectar::Web::Controller::Util::Boxy;

ok( request('/util/boxy')->is_success, 'Request should succeed' );
done_testing();
