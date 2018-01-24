use utf8;
package Nectar::Schema::CARDIODB::Result::V2Phen;

# Created by DBIx::Class::Schema::Loader
# DO NOT MODIFY THE FIRST PART OF THIS FILE

=head1 NAME

Nectar::Schema::CARDIODB::Result::V2Phen

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

=head1 TABLE: C<V2Phens>

=cut

__PACKAGE__->table("V2Phens");

=head1 ACCESSORS

=head2 id

  data_type: 'integer'
  extra: {unsigned => 1}
  is_auto_increment: 1
  is_nullable: 0

=head2 uid

  data_type: 'integer'
  extra: {unsigned => 1}
  is_nullable: 0

=head2 rs_id

  data_type: 'varchar'
  is_nullable: 0
  size: 50

=head2 des

  data_type: 'varchar'
  is_nullable: 1
  size: 255

=head2 ex_ref

  data_type: 'varchar'
  is_nullable: 1
  size: 255

=head2 p_value

  data_type: 'double precision'
  is_nullable: 1

=head2 risk_allele

  data_type: 'varchar'
  is_nullable: 1
  size: 255

=head2 source

  data_type: 'varchar'
  is_nullable: 1
  size: 255

=head2 study

  data_type: 'varchar'
  is_nullable: 1
  size: 255

=head2 study_type

  data_type: 'set'
  extra: {list => ["GWAS"]}
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
  "uid",
  { data_type => "integer", extra => { unsigned => 1 }, is_nullable => 0 },
  "rs_id",
  { data_type => "varchar", is_nullable => 0, size => 50 },
  "des",
  { data_type => "varchar", is_nullable => 1, size => 255 },
  "ex_ref",
  { data_type => "varchar", is_nullable => 1, size => 255 },
  "p_value",
  { data_type => "double precision", is_nullable => 1 },
  "risk_allele",
  { data_type => "varchar", is_nullable => 1, size => 255 },
  "source",
  { data_type => "varchar", is_nullable => 1, size => 255 },
  "study",
  { data_type => "varchar", is_nullable => 1, size => 255 },
  "study_type",
  { data_type => "set", extra => { list => ["GWAS"] }, is_nullable => 1 },
);

=head1 PRIMARY KEY

=over 4

=item * L</id>

=back

=cut

__PACKAGE__->set_primary_key("id");

=head1 UNIQUE CONSTRAINTS

=head2 C<uid>

=over 4

=item * L</uid>

=item * L</rs_id>

=item * L</des>

=back

=cut

__PACKAGE__->add_unique_constraint("uid", ["uid", "rs_id", "des"]);


# Created by DBIx::Class::Schema::Loader v0.07014 @ 2013-01-16 11:26:42
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:JpUi/SjpuPi5kbtxB6E+dQ


# You can replace this text with custom code or comments, and it will be preserved on regeneration
__PACKAGE__->meta->make_immutable;
1;
