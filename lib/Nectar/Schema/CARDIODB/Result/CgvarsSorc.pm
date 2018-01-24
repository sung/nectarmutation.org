use utf8;
package Nectar::Schema::CARDIODB::Result::CgvarsSorc;

# Created by DBIx::Class::Schema::Loader
# DO NOT MODIFY THE FIRST PART OF THIS FILE

=head1 NAME

Nectar::Schema::CARDIODB::Result::CgvarsSorc

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

=head1 TABLE: C<CGvars_SORCS>

=cut

__PACKAGE__->table("CGvars_SORCS");

=head1 ACCESSORS

=head2 id

  data_type: 'integer'
  is_auto_increment: 1
  is_nullable: 0

=head2 sample_id

  data_type: 'integer'
  is_nullable: 0

=head2 locus

  data_type: 'integer'
  is_nullable: 0

=head2 allele_cnt

  data_type: 'integer'
  is_nullable: 0

=head2 chr

  data_type: 'varchar'
  is_nullable: 0
  size: 5

=head2 v_start

  data_type: 'integer'
  is_nullable: 0

=head2 v_end

  data_type: 'integer'
  is_nullable: 0

=head2 var_type

  data_type: 'char'
  is_nullable: 0
  size: 10

=head2 reference

  data_type: 'varchar'
  is_nullable: 0
  size: 255

=head2 genotype

  data_type: 'varchar'
  is_nullable: 0
  size: 255

=head2 vaf_score

  data_type: 'integer'
  is_nullable: 0

=head2 eaf_score

  data_type: 'integer'
  is_nullable: 0

=head2 qual

  data_type: 'enum'
  extra: {list => ["H","L"]}
  is_nullable: 0

=cut

__PACKAGE__->add_columns(
  "id",
  { data_type => "integer", is_auto_increment => 1, is_nullable => 0 },
  "sample_id",
  { data_type => "integer", is_nullable => 0 },
  "locus",
  { data_type => "integer", is_nullable => 0 },
  "allele_cnt",
  { data_type => "integer", is_nullable => 0 },
  "chr",
  { data_type => "varchar", is_nullable => 0, size => 5 },
  "v_start",
  { data_type => "integer", is_nullable => 0 },
  "v_end",
  { data_type => "integer", is_nullable => 0 },
  "var_type",
  { data_type => "char", is_nullable => 0, size => 10 },
  "reference",
  { data_type => "varchar", is_nullable => 0, size => 255 },
  "genotype",
  { data_type => "varchar", is_nullable => 0, size => 255 },
  "vaf_score",
  { data_type => "integer", is_nullable => 0 },
  "eaf_score",
  { data_type => "integer", is_nullable => 0 },
  "qual",
  { data_type => "enum", extra => { list => ["H", "L"] }, is_nullable => 0 },
);

=head1 PRIMARY KEY

=over 4

=item * L</id>

=back

=cut

__PACKAGE__->set_primary_key("id");

=head1 UNIQUE CONSTRAINTS

=head2 C<sample_id>

=over 4

=item * L</sample_id>

=item * L</locus>

=item * L</allele_cnt>

=back

=cut

__PACKAGE__->add_unique_constraint("sample_id", ["sample_id", "locus", "allele_cnt"]);


# Created by DBIx::Class::Schema::Loader v0.07014 @ 2013-01-16 11:26:41
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:5JAFYxgpHABmC8CojfMbGg


# You can replace this text with custom code or comments, and it will be preserved on regeneration
__PACKAGE__->meta->make_immutable;
1;
