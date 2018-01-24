use utf8;
package Nectar::Schema::NECTAR_DEVEL::Result::InSilicoSnv;

# Created by DBIx::Class::Schema::Loader
# DO NOT MODIFY THE FIRST PART OF THIS FILE

=head1 NAME

Nectar::Schema::NECTAR_DEVEL::Result::InSilicoSnv

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

=head1 TABLE: C<inSilicoSNVs>

=cut

__PACKAGE__->table("inSilicoSNVs");

=head1 ACCESSORS

=head2 id

  data_type: 'integer'
  extra: {unsigned => 1}
  is_auto_increment: 1
  is_nullable: 0

=head2 enst

  data_type: 'varchar'
  is_nullable: 0
  size: 50

=head2 strand

  data_type: 'integer'
  is_nullable: 0

=head2 ensp

  data_type: 'varchar'
  is_nullable: 0
  size: 50

=head2 res_num

  data_type: 'integer'
  is_nullable: 0

=head2 p_ref

  data_type: 'char'
  is_nullable: 0
  size: 1

=head2 ref_codon

  data_type: 'char'
  is_nullable: 0
  size: 3

=head2 chr

  data_type: 'varchar'
  is_nullable: 1
  size: 100

=head2 v_start

  data_type: 'integer'
  is_nullable: 0

=head2 v_end

  data_type: 'integer'
  is_nullable: 0

=head2 reference

  data_type: 'char'
  is_nullable: 0
  size: 1

=head2 genotype

  data_type: 'char'
  is_nullable: 0
  size: 1

=head2 triplet

  data_type: 'integer'
  is_nullable: 0

=head2 mut_codon

  data_type: 'char'
  is_nullable: 0
  size: 3

=head2 p_mut

  data_type: 'char'
  is_nullable: 0
  size: 1

=cut

__PACKAGE__->add_columns(
  "id",
  {
    data_type => "integer",
    extra => { unsigned => 1 },
    is_auto_increment => 1,
    is_nullable => 0,
  },
  "enst",
  { data_type => "varchar", is_nullable => 0, size => 50 },
  "strand",
  { data_type => "integer", is_nullable => 0 },
  "ensp",
  { data_type => "varchar", is_nullable => 0, size => 50 },
  "res_num",
  { data_type => "integer", is_nullable => 0 },
  "p_ref",
  { data_type => "char", is_nullable => 0, size => 1 },
  "ref_codon",
  { data_type => "char", is_nullable => 0, size => 3 },
  "chr",
  { data_type => "varchar", is_nullable => 1, size => 100 },
  "v_start",
  { data_type => "integer", is_nullable => 0 },
  "v_end",
  { data_type => "integer", is_nullable => 0 },
  "reference",
  { data_type => "char", is_nullable => 0, size => 1 },
  "genotype",
  { data_type => "char", is_nullable => 0, size => 1 },
  "triplet",
  { data_type => "integer", is_nullable => 0 },
  "mut_codon",
  { data_type => "char", is_nullable => 0, size => 3 },
  "p_mut",
  { data_type => "char", is_nullable => 0, size => 1 },
);

=head1 PRIMARY KEY

=over 4

=item * L</id>

=back

=cut

__PACKAGE__->set_primary_key("id");

=head1 UNIQUE CONSTRAINTS

=head2 C<ensp>

=over 4

=item * L</ensp>

=item * L</res_num>

=item * L</chr>

=item * L</v_start>

=item * L</v_end>

=item * L</reference>

=item * L</genotype>

=back

=cut

__PACKAGE__->add_unique_constraint(
  "ensp",
  [
    "ensp",
    "res_num",
    "chr",
    "v_start",
    "v_end",
    "reference",
    "genotype",
  ],
);


# Created by DBIx::Class::Schema::Loader v0.07035 @ 2013-10-28 11:14:36
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:yjrpQDWJefhPadTOh5vI2w


# You can replace this text with custom code or comments, and it will be preserved on regeneration
__PACKAGE__->meta->make_immutable;
1;
