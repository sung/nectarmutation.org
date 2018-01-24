use utf8;
package Nectar::Schema::NECTAR::Result::Ensx;

# Created by DBIx::Class::Schema::Loader
# DO NOT MODIFY THE FIRST PART OF THIS FILE

=head1 NAME

Nectar::Schema::NECTAR::Result::Ensx

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

=item * L<DBIx::Class::TimeStamp>

=item * L<DBIx::Class::PassphraseColumn>

=back

=cut

__PACKAGE__->load_components("InflateColumn::DateTime", "TimeStamp", "PassphraseColumn");

=head1 TABLE: C<ENSXs>

=cut

__PACKAGE__->table("ENSXs");

=head1 ACCESSORS

=head2 id

  data_type: 'integer'
  extra: {unsigned => 1}
  is_auto_increment: 1
  is_nullable: 0

=head2 ensg

  data_type: 'varchar'
  is_nullable: 0
  size: 50

=head2 strand

  data_type: 'integer'
  is_nullable: 0

=head2 ensg_type

  data_type: 'varchar'
  is_nullable: 1
  size: 50

=head2 hgnc

  data_type: 'varchar'
  is_nullable: 1
  size: 50

=head2 enst

  data_type: 'varchar'
  is_nullable: 0
  size: 50

=head2 is_canonical

  data_type: 'integer'
  default_value: 0
  is_nullable: 0

=head2 ccds

  data_type: 'varchar'
  is_nullable: 1
  size: 255

=head2 enst_type

  data_type: 'varchar'
  is_nullable: 1
  size: 50

=head2 ensp

  data_type: 'varchar'
  is_nullable: 0
  size: 50

=cut

__PACKAGE__->add_columns(
  "id",
  {
    data_type => "integer",
    extra => { unsigned => 1 },
    is_auto_increment => 1,
    is_nullable => 0,
  },
  "ensg",
  { data_type => "varchar", is_nullable => 0, size => 50 },
  "strand",
  { data_type => "integer", is_nullable => 0 },
  "ensg_type",
  { data_type => "varchar", is_nullable => 1, size => 50 },
  "hgnc",
  { data_type => "varchar", is_nullable => 1, size => 50 },
  "enst",
  { data_type => "varchar", is_nullable => 0, size => 50 },
  "is_canonical",
  { data_type => "integer", default_value => 0, is_nullable => 0 },
  "ccds",
  { data_type => "varchar", is_nullable => 1, size => 255 },
  "enst_type",
  { data_type => "varchar", is_nullable => 1, size => 50 },
  "ensp",
  { data_type => "varchar", is_nullable => 0, size => 50 },
);

=head1 PRIMARY KEY

=over 4

=item * L</id>

=back

=cut

__PACKAGE__->set_primary_key("id");

=head1 UNIQUE CONSTRAINTS

=head2 C<map>

=over 4

=item * L</ensg>

=item * L</enst>

=item * L</ensp>

=back

=cut

__PACKAGE__->add_unique_constraint("map", ["ensg", "enst", "ensp"]);


# Created by DBIx::Class::Schema::Loader v0.07014 @ 2012-12-17 14:00:48
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:WJD6q98gvpDf+Rzwh0dV4Q


# You can replace this text with custom code or comments, and it will be preserved on regeneration
__PACKAGE__->meta->make_immutable;
1;
