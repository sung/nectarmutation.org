package Nectar::Web::Model::VEP;

# see below for details
#https://metacpan.org/module/Catalyst::Model::Adaptor

use strict;
use base 'Catalyst::Model::Adaptor';
__PACKAGE__->config(
	class=>'Nectar::Agent::EnsemblRest', 
	args=>{},
);

=head1 NAME

Nectar::Web::Model::VEP - Catalyst Model

=head1 DESCRIPTION

Catalyst Model.

=head1 AUTHOR

Sung Gong

=head1 LICENSE

This library is free software. You can redistribute it and/or modify
it under the same terms as Perl itself.

=cut

__PACKAGE__->meta->make_immutable;

1;
