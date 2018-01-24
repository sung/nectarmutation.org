use utf8;
package Nectar::Schema::CARDIODB::Result::GatksM;

# Created by DBIx::Class::Schema::Loader
# DO NOT MODIFY THE FIRST PART OF THIS FILE

=head1 NAME

Nectar::Schema::CARDIODB::Result::GatksM

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

=head1 TABLE: C<GATKsMS>

=cut

__PACKAGE__->table("GATKsMS");

=head1 ACCESSORS

=head2 id

  data_type: 'integer'
  is_auto_increment: 1
  is_nullable: 0

=head2 group_name

  data_type: 'varchar'
  is_nullable: 0
  size: 100

=head2 gid

  data_type: 'integer'
  is_nullable: 0

=head2 chr

  data_type: 'varchar'
  is_nullable: 0
  size: 50

=head2 variant_type

  data_type: 'enum'
  extra: {list => ["SNP","Ins","Del"]}
  is_nullable: 0

=head2 v_start

  data_type: 'integer'
  is_nullable: 0

=head2 v_end

  data_type: 'integer'
  is_nullable: 0

=head2 reference

  data_type: 'varchar'
  is_nullable: 0
  size: 500

=head2 genotype

  data_type: 'varchar'
  is_nullable: 0
  size: 255

=head2 qual

  data_type: 'float'
  is_nullable: 1
  size: [8,2]

=head2 filter

  data_type: 'varchar'
  is_nullable: 1
  size: 255

=head2 rs_id

  data_type: 'varchar'
  is_nullable: 1
  size: 255

=head2 ab

  data_type: 'float'
  is_nullable: 1
  size: [3,2]

=head2 ac

  data_type: 'integer'
  is_nullable: 1

=head2 af

  data_type: 'float'
  is_nullable: 1
  size: [3,2]

=head2 an

  data_type: 'integer'
  is_nullable: 1

=head2 t_dp

  data_type: 'integer'
  is_nullable: 1

=head2 hrun

  data_type: 'integer'
  is_nullable: 1

=head2 qd

  data_type: 'float'
  is_nullable: 1
  size: [5,2]

=head2 sb

  data_type: 'float'
  is_nullable: 1
  size: [7,2]

=head2 info

  data_type: 'tinytext'
  is_nullable: 0

=cut

__PACKAGE__->add_columns(
  "id",
  { data_type => "integer", is_auto_increment => 1, is_nullable => 0 },
  "group_name",
  { data_type => "varchar", is_nullable => 0, size => 100 },
  "gid",
  { data_type => "integer", is_nullable => 0 },
  "chr",
  { data_type => "varchar", is_nullable => 0, size => 50 },
  "variant_type",
  {
    data_type => "enum",
    extra => { list => ["SNP", "Ins", "Del"] },
    is_nullable => 0,
  },
  "v_start",
  { data_type => "integer", is_nullable => 0 },
  "v_end",
  { data_type => "integer", is_nullable => 0 },
  "reference",
  { data_type => "varchar", is_nullable => 0, size => 500 },
  "genotype",
  { data_type => "varchar", is_nullable => 0, size => 255 },
  "qual",
  { data_type => "float", is_nullable => 1, size => [8, 2] },
  "filter",
  { data_type => "varchar", is_nullable => 1, size => 255 },
  "rs_id",
  { data_type => "varchar", is_nullable => 1, size => 255 },
  "ab",
  { data_type => "float", is_nullable => 1, size => [3, 2] },
  "ac",
  { data_type => "integer", is_nullable => 1 },
  "af",
  { data_type => "float", is_nullable => 1, size => [3, 2] },
  "an",
  { data_type => "integer", is_nullable => 1 },
  "t_dp",
  { data_type => "integer", is_nullable => 1 },
  "hrun",
  { data_type => "integer", is_nullable => 1 },
  "qd",
  { data_type => "float", is_nullable => 1, size => [5, 2] },
  "sb",
  { data_type => "float", is_nullable => 1, size => [7, 2] },
  "info",
  { data_type => "tinytext", is_nullable => 0 },
);

=head1 PRIMARY KEY

=over 4

=item * L</id>

=back

=cut

__PACKAGE__->set_primary_key("id");

=head1 UNIQUE CONSTRAINTS

=head2 C<group_name>

=over 4

=item * L</group_name>

=item * L</gid>

=back

=cut

__PACKAGE__->add_unique_constraint("group_name", ["group_name", "gid"]);


# Created by DBIx::Class::Schema::Loader v0.07014 @ 2013-01-16 11:26:41
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:Tq9RxBQogzfgy+7cl8++Vw


# You can replace this text with custom code or comments, and it will be preserved on regeneration
__PACKAGE__->meta->make_immutable;
1;
