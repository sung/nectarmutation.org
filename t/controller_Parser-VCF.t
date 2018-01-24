use strict;
use warnings;
use Test::More;


use Catalyst::Test 'Nectar::Web';
use Nectar::Web::Controller::Parser::VCF;

ok( request('/parser/vcf')->is_success, 'Request should succeed' );
done_testing();
