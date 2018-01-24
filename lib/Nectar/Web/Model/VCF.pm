package Nectar::Web::Model::VCF;

# see below for details
#https://metacpan.org/module/Catalyst::Model::Adaptor

use strict;
#use Moose;
#use namespace::autoclean;

use base 'Catalyst::Model::Adaptor';

__PACKAGE__->config(
	class=>'Nectar::Parser::VCF', # lib/Nectar/Parser/VCF.pm
	args=>{},
);


=head1 NAME

Nectar::Web::Model::VCF - Catalyst Model

=head1 DESCRIPTION

Catalyst Model.

=head1 AUTHOR

Sung Gong

=head1 LICENSE

This library is free software. You can redistribute it and/or modify
it under the same terms as Perl itself.

=cut

#__PACKAGE__->meta->make_immutable;

1;
