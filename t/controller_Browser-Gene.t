use strict;
use warnings;
use Test::More;


use Catalyst::Test 'Nectar::Web';
use Nectar::Web::Controller::Browser::Gene;

ok( request('/browser/gene')->is_success, 'Request should succeed' );
done_testing();
