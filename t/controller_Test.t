use strict;
use warnings;
use Test::More;


use Catalyst::Test 'Nectar::Web';
use Nectar::Web::Controller::Test;

ok( request('/test')->is_success, 'Request should succeed' );
done_testing();
