use utf8;
package Nectar::Schema::UNIPROT::Result::Taxanomy;

# Created by DBIx::Class::Schema::Loader
# DO NOT MODIFY THE FIRST PART OF THIS FILE

=head1 NAME

Nectar::Schema::UNIPROT::Result::Taxanomy

=cut

use strict;
use warnings;

use Moose;
use MooseX::NonMoose;
use MooseX::MarkAsMethods autoclean => 1;
extends 'DBIx::Class::Core';

=head1 COMPONENTS LOADED

=over 4

=item * L<DBIx::Class::InflateColumn::DateTime>

=back

=cut

__PACKAGE__->load_components("InflateColumn::DateTime");

=head1 TABLE: C<Taxanomy>

=cut

__PACKAGE__->table("Taxanomy");

=head1 ACCESSORS

=head2 id

  data_type: 'integer'
  extra: {unsigned => 1}
  is_nullable: 0

=head2 sn

  data_type: 'tinyblob'
  is_nullable: 0

=head2 cn

  data_type: 'tinyblob'
  is_nullable: 1

=cut

__PACKAGE__->add_columns(
  "id",
  { data_type => "integer", extra => { unsigned => 1 }, is_nullable => 0 },
  "sn",
  { data_type => "tinyblob", is_nullable => 0 },
  "cn",
  { data_type => "tinyblob", is_nullable => 1 },
);

=head1 PRIMARY KEY

=over 4

=item * L</id>

=back

=cut

__PACKAGE__->set_primary_key("id");


# Created by DBIx::Class::Schema::Loader v0.07014 @ 2012-07-20 16:20:11
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:xAsb005HNNnv3T9YqC+5GA


# You can replace this text with custom code or comments, and it will be preserved on regeneration
__PACKAGE__->meta->make_immutable;
1;
