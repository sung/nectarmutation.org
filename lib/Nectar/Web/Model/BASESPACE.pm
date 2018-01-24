package Nectar::Web::Model::BASESPACE;

# see below for details
#https://metacpan.org/module/Catalyst::Model::Adaptor

use strict;
use base 'Catalyst::Model::Adaptor';
__PACKAGE__->config(
	class=>'Nectar::Agent::Basespace', 
	args=>{},
);

=head1 NAME

Nectar::Web::Model::BASESPACE - Catalyst Model

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
