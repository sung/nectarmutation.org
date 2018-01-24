use strict;
use warnings;
use Plack::Builder;
use Plack::Middleware::Debug;
use lib './lib';
use Nectar::Web;

my $app = Nectar::Web->apply_default_middlewares(Nectar::Web->psgi_app);
my $panels = Plack::Middleware::Debug->default_panels;

builder {
  enable_if {
    $ENV{CATALYST_DEBUG}
  } 'Debug',  panels =>[['DBIC::QueryLog', passthrough=>1], @$panels];
  $app;
};
