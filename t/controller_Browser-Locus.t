use strict;
use warnings;
use Test::More;


use Catalyst::Test 'Nectar::Web';
use Nectar::Web::Controller::Browser::Locus;

ok( request('/browser/locus')->is_success, 'Request should succeed' );
done_testing();
