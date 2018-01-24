use strict;
use warnings;
use Test::More;


use Catalyst::Test 'Nectar::Web';
use Nectar::Web::Controller::Util::Export;

ok( request('/util/export')->is_success, 'Request should succeed' );
done_testing();
