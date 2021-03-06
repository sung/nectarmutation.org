use utf8;
package Nectar::Schema::NECTAR::Result::Hpmd;

# Created by DBIx::Class::Schema::Loader
# DO NOT MODIFY THE FIRST PART OF THIS FILE

=head1 NAME

Nectar::Schema::NECTAR::Result::Hpmd

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

=head1 TABLE: C<HPMDs>

=cut

__PACKAGE__->table("HPMDs");

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

=head2 hgnc

  data_type: 'varchar'
  is_nullable: 1
  size: 50

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

=head2 p_mut

  data_type: 'char'
  is_nullable: 1
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
  "fid",
  { data_type => "integer", extra => { unsigned => 1 }, is_nullable => 0 },
  "xref",
  { data_type => "varchar", is_nullable => 1, size => 50 },
  "hgnc",
  { data_type => "varchar", is_nullable => 1, size => 50 },
  "ensp",
  { data_type => "varchar", is_nullable => 0, size => 50 },
  "res_num",
  { data_type => "integer", is_nullable => 0 },
  "p_ref",
  { data_type => "char", is_nullable => 0, size => 1 },
  "p_mut",
  { data_type => "char", is_nullable => 1, size => 1 },
);

=head1 PRIMARY KEY

=over 4

=item * L</id>

=back

=cut

__PACKAGE__->set_primary_key("id");

=head1 UNIQUE CONSTRAINTS

=head2 C<xref>

=over 4

=item * L</xref>

=item * L</ensp>

=item * L</res_num>

=item * L</p_ref>

=item * L</p_mut>

=back

=cut

__PACKAGE__->add_unique_constraint("xref", ["xref", "ensp", "res_num", "p_ref", "p_mut"]);


# Created by DBIx::Class::Schema::Loader v0.07014 @ 2012-12-17 14:00:48
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:TCCXUioyU56nGpYkgCmjqg

__PACKAGE__->belongs_to('p2ENSX', 'Nectar::Schema::NECTAR::Result::Ensx', {'foreign.ensp'=>'self.ensp'}); 
__PACKAGE__->belongs_to('featureDef', 'Nectar::Schema::NECTAR::Result::FeatureDef', {'foreign.id'=>'self.fid'}); #belongs_to=>join
__PACKAGE__->has_many('HPMDRefs', 'Nectar::Schema::NECTAR::Result::Hpmdref', {'foreign.fid'=>'self.fid', 'foreign.xref'=>'self.xref'}); # has_many=> left join

# You can replace this text with custom code or comments, and it will be preserved on regeneration
__PACKAGE__->meta->make_immutable;
1;
