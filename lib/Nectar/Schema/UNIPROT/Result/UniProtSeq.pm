use utf8;
package Nectar::Schema::UNIPROT::Result::UniProtSeq;

# Created by DBIx::Class::Schema::Loader
# DO NOT MODIFY THE FIRST PART OF THIS FILE

=head1 NAME

Nectar::Schema::UNIPROT::Result::UniProtSeq

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

=head1 TABLE: C<UniProtSeq>

=cut

__PACKAGE__->table("UniProtSeq");

=head1 ACCESSORS

=head2 id

  data_type: 'integer'
  extra: {unsigned => 1}
  is_auto_increment: 1
  is_nullable: 0

=head2 acc

  data_type: 'char'
  is_nullable: 0
  size: 12

=head2 display_id

  data_type: 'char'
  is_nullable: 0
  size: 12

=head2 name

  data_type: 'varchar'
  is_nullable: 1
  size: 500

=head2 gene

  data_type: 'char'
  is_nullable: 1
  size: 20

=head2 length

  data_type: 'integer'
  is_nullable: 0

=head2 mw

  data_type: 'integer'
  is_nullable: 1

=head2 sequence

  accessor: 'column_sequence'
  data_type: 'longtext'
  is_nullable: 1

=head2 is_sp

  data_type: 'integer'
  is_nullable: 0

=head2 tax_id

  data_type: 'integer'
  is_nullable: 0

=cut

__PACKAGE__->add_columns(
  "id",
  {
    data_type => "integer",
    extra => { unsigned => 1 },
    is_auto_increment => 1,
    is_nullable => 0,
  },
  "acc",
  { data_type => "char", is_nullable => 0, size => 12 },
  "display_id",
  { data_type => "char", is_nullable => 0, size => 12 },
  "name",
  { data_type => "varchar", is_nullable => 1, size => 500 },
  "gene",
  { data_type => "char", is_nullable => 1, size => 20 },
  "length",
  { data_type => "integer", is_nullable => 0 },
  "mw",
  { data_type => "integer", is_nullable => 1 },
  "sequence",
  {
    accessor    => "column_sequence",
    data_type   => "longtext",
    is_nullable => 1,
  },
  "is_sp",
  { data_type => "integer", is_nullable => 0 },
  "tax_id",
  { data_type => "integer", is_nullable => 0 },
);

=head1 PRIMARY KEY

=over 4

=item * L</id>

=back

=cut

__PACKAGE__->set_primary_key("id");

=head1 UNIQUE CONSTRAINTS

=head2 C<acc>

=over 4

=item * L</acc>

=back

=cut

__PACKAGE__->add_unique_constraint("acc", ["acc"]);

=head2 C<display_id>

=over 4

=item * L</display_id>

=back

=cut

__PACKAGE__->add_unique_constraint("display_id", ["display_id"]);


# Created by DBIx::Class::Schema::Loader v0.07014 @ 2012-07-20 16:20:11
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:FuX6O8xfE8ti9aSC/I7vrg


# You can replace this text with custom code or comments, and it will be preserved on regeneration
__PACKAGE__->meta->make_immutable;
1;
