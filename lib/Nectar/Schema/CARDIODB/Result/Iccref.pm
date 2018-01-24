use utf8;
package Nectar::Schema::CARDIODB::Result::Iccref;

# Created by DBIx::Class::Schema::Loader
# DO NOT MODIFY THE FIRST PART OF THIS FILE

=head1 NAME

Nectar::Schema::CARDIODB::Result::Iccref

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

=head1 TABLE: C<ICCRefs>

=cut

__PACKAGE__->table("ICCRefs");

=head1 ACCESSORS

=head2 id

  data_type: 'integer'
  extra: {unsigned => 1}
  is_auto_increment: 1
  is_nullable: 0

=head2 mut_id

  data_type: 'integer'
  extra: {unsigned => 1}
  is_nullable: 0

=head2 hgnc

  data_type: 'varchar'
  is_nullable: 1
  size: 50

=head2 hgvs_coding

  data_type: 'text'
  is_nullable: 0

=head2 chr

  data_type: 'varchar'
  is_nullable: 1
  size: 50

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
  size: 100

=head2 strand

  data_type: 'integer'
  is_nullable: 1

=head2 is_same_ref

  data_type: 'integer'
  is_nullable: 1

=head2 is_same_coord

  data_type: 'integer'
  is_nullable: 1

=head2 is_coord_from_icc

  data_type: 'integer'
  is_nullable: 0

=head2 exrefs

  data_type: 'varchar'
  is_nullable: 1
  size: 400

=head2 diseases

  data_type: 'varchar'
  is_nullable: 1
  size: 400

=head2 pubmeds

  data_type: 'varchar'
  is_nullable: 1
  size: 400

=cut

__PACKAGE__->add_columns(
  "id",
  {
    data_type => "integer",
    extra => { unsigned => 1 },
    is_auto_increment => 1,
    is_nullable => 0,
  },
  "mut_id",
  { data_type => "integer", extra => { unsigned => 1 }, is_nullable => 0 },
  "hgnc",
  { data_type => "varchar", is_nullable => 1, size => 50 },
  "hgvs_coding",
  { data_type => "text", is_nullable => 0 },
  "chr",
  { data_type => "varchar", is_nullable => 1, size => 50 },
  "g_start",
  { data_type => "integer", extra => { unsigned => 1 }, is_nullable => 1 },
  "g_end",
  { data_type => "integer", extra => { unsigned => 1 }, is_nullable => 1 },
  "reference",
  { data_type => "varchar", is_nullable => 1, size => 150 },
  "genotype",
  { data_type => "varchar", is_nullable => 1, size => 100 },
  "strand",
  { data_type => "integer", is_nullable => 1 },
  "is_same_ref",
  { data_type => "integer", is_nullable => 1 },
  "is_same_coord",
  { data_type => "integer", is_nullable => 1 },
  "is_coord_from_icc",
  { data_type => "integer", is_nullable => 0 },
  "exrefs",
  { data_type => "varchar", is_nullable => 1, size => 400 },
  "diseases",
  { data_type => "varchar", is_nullable => 1, size => 400 },
  "pubmeds",
  { data_type => "varchar", is_nullable => 1, size => 400 },
);

=head1 PRIMARY KEY

=over 4

=item * L</id>

=back

=cut

__PACKAGE__->set_primary_key("id");

=head1 UNIQUE CONSTRAINTS

=head2 C<mut_id>

=over 4

=item * L</mut_id>

=back

=cut

__PACKAGE__->add_unique_constraint("mut_id", ["mut_id"]);


# Created by DBIx::Class::Schema::Loader v0.07014 @ 2013-01-16 11:26:41
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:mBRMM9jKVkF3gU3No20XfA

__PACKAGE__->has_many('IsNovel', 'Nectar::Schema::CARDIODB::Result::IsNovel', {'foreign.mut_id'=>'self.mut_id'}); # has_many => left join

# You can replace this text with custom code or comments, and it will be preserved on regeneration
__PACKAGE__->meta->make_immutable;
1;
