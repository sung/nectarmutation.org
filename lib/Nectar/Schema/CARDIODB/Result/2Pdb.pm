use utf8;
package Nectar::Schema::CARDIODB::Result::2Pdb;

# Created by DBIx::Class::Schema::Loader
# DO NOT MODIFY THE FIRST PART OF THIS FILE

=head1 NAME

Nectar::Schema::CARDIODB::Result::2Pdb

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

=head1 TABLE: C<2PDBs>

=cut

__PACKAGE__->table("2PDBs");

=head1 ACCESSORS

=head2 id

  data_type: 'integer'
  is_auto_increment: 1
  is_nullable: 0

=head2 uid

  data_type: 'integer'
  extra: {unsigned => 1}
  is_nullable: 0

=head2 2u_id

  data_type: 'integer'
  is_nullable: 0

=head2 vid

  data_type: 'integer'
  is_nullable: 0

=head2 res_id

  data_type: 'integer'
  is_nullable: 0

=head2 pdb

  data_type: 'char'
  is_nullable: 0
  size: 4

=head2 chain

  data_type: 'varchar'
  is_nullable: 0
  size: 2

=head2 res_num

  data_type: 'varchar'
  is_nullable: 0
  size: 50

=head2 pdb_res

  data_type: 'varchar'
  is_nullable: 1
  size: 50

=head2 env

  data_type: 'char'
  is_nullable: 1
  size: 5

=head2 annotation

  data_type: 'varchar'
  is_nullable: 1
  size: 20

=head2 des

  data_type: 'tinytext'
  is_nullable: 1

=head2 esst

  data_type: 'integer'
  is_nullable: 1

=cut

__PACKAGE__->add_columns(
  "id",
  { data_type => "integer", is_auto_increment => 1, is_nullable => 0 },
  "uid",
  { data_type => "integer", extra => { unsigned => 1 }, is_nullable => 0 },
  "2u_id",
  { data_type => "integer", is_nullable => 0 },
  "vid",
  { data_type => "integer", is_nullable => 0 },
  "res_id",
  { data_type => "integer", is_nullable => 0 },
  "pdb",
  { data_type => "char", is_nullable => 0, size => 4 },
  "chain",
  { data_type => "varchar", is_nullable => 0, size => 2 },
  "res_num",
  { data_type => "varchar", is_nullable => 0, size => 50 },
  "pdb_res",
  { data_type => "varchar", is_nullable => 1, size => 50 },
  "env",
  { data_type => "char", is_nullable => 1, size => 5 },
  "annotation",
  { data_type => "varchar", is_nullable => 1, size => 20 },
  "des",
  { data_type => "tinytext", is_nullable => 1 },
  "esst",
  { data_type => "integer", is_nullable => 1 },
);

=head1 PRIMARY KEY

=over 4

=item * L</id>

=back

=cut

__PACKAGE__->set_primary_key("id");


# Created by DBIx::Class::Schema::Loader v0.07014 @ 2013-01-16 11:26:41
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:zSZwb4G0XRX2E7IzhaF5KA

__PACKAGE__->belongs_to('V2Ensembls', 'Nectar::Schema::CARDIODB::Result::V2Ensembl', {'foreign.id'=>'self.vid'});

# You can replace this text with custom code or comments, and it will be preserved on regeneration
__PACKAGE__->meta->make_immutable;
1;
