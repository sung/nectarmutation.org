use utf8;
package Nectar::Schema::UNIPROT::Result::UniRef;

# Created by DBIx::Class::Schema::Loader
# DO NOT MODIFY THE FIRST PART OF THIS FILE

=head1 NAME

Nectar::Schema::UNIPROT::Result::UniRef

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

=head1 TABLE: C<uniRef>

=cut

__PACKAGE__->table("uniRef");

=head1 ACCESSORS

=head2 id

  data_type: 'integer'
  extra: {unsigned => 1}
  is_nullable: 0

=head2 uniref_acc

  data_type: 'varchar'
  is_nullable: 0
  size: 50

=head2 uniref_name

  data_type: 'varchar'
  is_nullable: 0
  size: 20

=head2 num_member

  data_type: 'integer'
  extra: {unsigned => 1}
  is_nullable: 0

=head2 common_taxon

  data_type: 'varchar'
  is_nullable: 1
  size: 50

=head2 common_taxon_id

  data_type: 'integer'
  extra: {unsigned => 1}
  is_nullable: 1

=cut

__PACKAGE__->add_columns(
  "id",
  { data_type => "integer", extra => { unsigned => 1 }, is_nullable => 0 },
  "uniref_acc",
  { data_type => "varchar", is_nullable => 0, size => 50 },
  "uniref_name",
  { data_type => "varchar", is_nullable => 0, size => 20 },
  "num_member",
  { data_type => "integer", extra => { unsigned => 1 }, is_nullable => 0 },
  "common_taxon",
  { data_type => "varchar", is_nullable => 1, size => 50 },
  "common_taxon_id",
  { data_type => "integer", extra => { unsigned => 1 }, is_nullable => 1 },
);

=head1 PRIMARY KEY

=over 4

=item * L</id>

=back

=cut

__PACKAGE__->set_primary_key("id");

=head1 UNIQUE CONSTRAINTS

=head2 C<uniref_acc>

=over 4

=item * L</uniref_acc>

=back

=cut

__PACKAGE__->add_unique_constraint("uniref_acc", ["uniref_acc"]);


# Created by DBIx::Class::Schema::Loader v0.07014 @ 2012-07-20 16:20:11
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:KXWSXCJx1qozLxEkHIzowg


# You can replace this text with custom code or comments, and it will be preserved on regeneration
__PACKAGE__->meta->make_immutable;
1;
