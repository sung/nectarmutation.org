use utf8;
package Nectar::Schema::NECTAR::Result::CleanedHgmd;

# Created by DBIx::Class::Schema::Loader
# DO NOT MODIFY THE FIRST PART OF THIS FILE

=head1 NAME

Nectar::Schema::NECTAR::Result::CleanedHgmd

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

=head1 TABLE: C<CleanedHGMDs>

=cut

__PACKAGE__->table("CleanedHGMDs");

=head1 ACCESSORS

=head2 id

  data_type: 'integer'
  extra: {unsigned => 1}
  is_auto_increment: 1
  is_nullable: 0

=head2 acc_num

  data_type: 'varchar'
  default_value: (empty string)
  is_nullable: 0
  size: 10

=head2 hgnc

  data_type: 'varchar'
  is_nullable: 1
  size: 10

=head2 mut_type

  data_type: 'char'
  is_nullable: 1
  size: 1

=head2 tag

  data_type: 'enum'
  extra: {list => ["DP","FP","DFP","DM","FTV"]}
  is_nullable: 1

=head2 disease

  data_type: 'varchar'
  is_nullable: 1
  size: 200

=head2 omim

  data_type: 'integer'
  extra: {unsigned => 1}
  is_nullable: 1

=head2 pmid

  data_type: 'integer'
  extra: {unsigned => 1}
  is_nullable: 1

=head2 hgvs_coding

  data_type: 'varchar'
  is_nullable: 1
  size: 200

=head2 chr

  data_type: 'varchar'
  is_nullable: 1
  size: 10

=head2 g_start

  data_type: 'integer'
  extra: {unsigned => 1}
  is_nullable: 1

=head2 g_end

  data_type: 'integer'
  extra: {unsigned => 1}
  is_nullable: 1

=head2 reference

  data_type: 'varchar'
  is_nullable: 1
  size: 150

=head2 genotype

  data_type: 'varchar'
  is_nullable: 1
  size: 150

=head2 is_same_ref

  data_type: 'integer'
  extra: {unsigned => 1}
  is_nullable: 1

=head2 ens_ref

  data_type: 'varchar'
  is_nullable: 1
  size: 150

=head2 is_coord_from_ens

  data_type: 'integer'
  default_value: 0
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
  "acc_num",
  { data_type => "varchar", default_value => "", is_nullable => 0, size => 10 },
  "hgnc",
  { data_type => "varchar", is_nullable => 1, size => 10 },
  "mut_type",
  { data_type => "char", is_nullable => 1, size => 1 },
  "tag",
  {
    data_type => "enum",
    extra => { list => ["DP", "FP", "DFP", "DM", "FTV"] },
    is_nullable => 1,
  },
  "disease",
  { data_type => "varchar", is_nullable => 1, size => 200 },
  "omim",
  { data_type => "integer", extra => { unsigned => 1 }, is_nullable => 1 },
  "pmid",
  { data_type => "integer", extra => { unsigned => 1 }, is_nullable => 1 },
  "hgvs_coding",
  { data_type => "varchar", is_nullable => 1, size => 200 },
  "chr",
  { data_type => "varchar", is_nullable => 1, size => 10 },
  "g_start",
  { data_type => "integer", extra => { unsigned => 1 }, is_nullable => 1 },
  "g_end",
  { data_type => "integer", extra => { unsigned => 1 }, is_nullable => 1 },
  "reference",
  { data_type => "varchar", is_nullable => 1, size => 150 },
  "genotype",
  { data_type => "varchar", is_nullable => 1, size => 150 },
  "is_same_ref",
  { data_type => "integer", extra => { unsigned => 1 }, is_nullable => 1 },
  "ens_ref",
  { data_type => "varchar", is_nullable => 1, size => 150 },
  "is_coord_from_ens",
  {
    data_type => "integer",
    default_value => 0,
    extra => { unsigned => 1 },
    is_nullable => 1,
  },
  "is_pub",
  {
    data_type => "integer",
    default_value => 0,
    extra => { unsigned => 1 },
    is_nullable => 1,
  },
);

=head1 PRIMARY KEY

=over 4

=item * L</id>

=back

=cut

__PACKAGE__->set_primary_key("id");

=head1 UNIQUE CONSTRAINTS

=head2 C<acc_num>

=over 4

=item * L</acc_num>

=back

=cut

__PACKAGE__->add_unique_constraint("acc_num", ["acc_num"]);


# Created by DBIx::Class::Schema::Loader v0.07014 @ 2012-12-17 14:00:48
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:4/AiAK8AUI1jpidS+abmTA


# You can replace this text with custom code or comments, and it will be preserved on regeneration
__PACKAGE__->meta->make_immutable;
1;
