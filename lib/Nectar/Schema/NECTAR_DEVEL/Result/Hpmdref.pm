use utf8;
package Nectar::Schema::NECTAR_DEVEL::Result::Hpmdref;

# Created by DBIx::Class::Schema::Loader
# DO NOT MODIFY THE FIRST PART OF THIS FILE

=head1 NAME

Nectar::Schema::NECTAR_DEVEL::Result::Hpmdref

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

=head1 TABLE: C<HPMDRefs>

=cut

__PACKAGE__->table("HPMDRefs");

=head1 ACCESSORS

=head2 id

  data_type: 'integer'
  extra: {unsigned => 1}
  is_auto_increment: 1
  is_nullable: 0

=head2 fid

  data_type: 'integer'
  extra: {unsigned => 1}
  is_nullable: 0

=head2 xref

  data_type: 'varchar'
  is_nullable: 1
  size: 50

=head2 des

  data_type: 'tinytext'
  is_nullable: 1

=head2 omim

  data_type: 'integer'
  extra: {unsigned => 1}
  is_nullable: 1

=head2 pmid

  data_type: 'integer'
  extra: {unsigned => 1}
  is_nullable: 1

=cut

__PACKAGE__->add_columns(
  "id",
  {
    data_type => "integer",
    extra => { unsigned => 1 },
    is_auto_increment => 1,
    is_nullable => 0,
  },
  "fid",
  { data_type => "integer", extra => { unsigned => 1 }, is_nullable => 0 },
  "xref",
  { data_type => "varchar", is_nullable => 1, size => 50 },
  "des",
  { data_type => "tinytext", is_nullable => 1 },
  "omim",
  { data_type => "integer", extra => { unsigned => 1 }, is_nullable => 1 },
  "pmid",
  { data_type => "integer", extra => { unsigned => 1 }, is_nullable => 1 },
);

=head1 PRIMARY KEY

=over 4

=item * L</id>

=back

=cut

__PACKAGE__->set_primary_key("id");

=head1 UNIQUE CONSTRAINTS

=head2 C<fid>

=over 4

=item * L</fid>

=item * L</xref>

=item * L</des>

=item * L</omim>

=item * L</pmid>

=back

=cut

__PACKAGE__->add_unique_constraint("fid", ["fid", "xref", "des", "omim", "pmid"]);


# Created by DBIx::Class::Schema::Loader v0.07035 @ 2013-10-28 11:14:36
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:rC7ZgC12Pgs9Ry4mccsDkw


# You can replace this text with custom code or comments, and it will be preserved on regeneration
__PACKAGE__->meta->make_immutable;
1;
