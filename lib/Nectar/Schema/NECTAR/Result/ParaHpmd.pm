use utf8;
package Nectar::Schema::NECTAR::Result::ParaHpmd;

# Created by DBIx::Class::Schema::Loader
# DO NOT MODIFY THE FIRST PART OF THIS FILE

=head1 NAME

Nectar::Schema::NECTAR::Result::ParaHpmd

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

=head1 TABLE: C<ParaHPMDs>

=cut

__PACKAGE__->table("ParaHPMDs");

=head1 ACCESSORS

=head2 id

  data_type: 'integer'
  extra: {unsigned => 1}
  is_auto_increment: 1
  is_nullable: 0

=head2 hpmd_align_id

  data_type: 'integer'
  extra: {unsigned => 1}
  is_nullable: 0

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

=head2 residue

  data_type: 'char'
  is_nullable: 1
  size: 1

=head2 para_hgnc

  data_type: 'varchar'
  is_nullable: 1
  size: 50

=head2 para_ensp

  data_type: 'varchar'
  is_nullable: 0
  size: 50

=head2 para_res_num

  data_type: 'integer'
  is_nullable: 0

=head2 para_ref_res

  data_type: 'char'
  is_nullable: 0
  size: 1

=head2 para_mut_res

  data_type: 'char'
  is_nullable: 0
  size: 1

=head2 para_fid

  data_type: 'integer'
  extra: {unsigned => 1}
  is_nullable: 0

=head2 para_xref

  data_type: 'varchar'
  is_nullable: 1
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
  "hpmd_align_id",
  { data_type => "integer", extra => { unsigned => 1 }, is_nullable => 0 },
  "hgnc",
  { data_type => "varchar", is_nullable => 1, size => 50 },
  "ensp",
  { data_type => "varchar", is_nullable => 0, size => 50 },
  "res_num",
  { data_type => "integer", is_nullable => 0 },
  "residue",
  { data_type => "char", is_nullable => 1, size => 1 },
  "para_hgnc",
  { data_type => "varchar", is_nullable => 1, size => 50 },
  "para_ensp",
  { data_type => "varchar", is_nullable => 0, size => 50 },
  "para_res_num",
  { data_type => "integer", is_nullable => 0 },
  "para_ref_res",
  { data_type => "char", is_nullable => 0, size => 1 },
  "para_mut_res",
  { data_type => "char", is_nullable => 0, size => 1 },
  "para_fid",
  { data_type => "integer", extra => { unsigned => 1 }, is_nullable => 0 },
  "para_xref",
  { data_type => "varchar", is_nullable => 1, size => 50 },
);

=head1 PRIMARY KEY

=over 4

=item * L</id>

=back

=cut

__PACKAGE__->set_primary_key("id");


# Created by DBIx::Class::Schema::Loader v0.07014 @ 2013-03-13 12:27:39
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:hg2NoJw+lro9MpiijJmZjg

__PACKAGE__->belongs_to('featureDef', 'Nectar::Schema::NECTAR::Result::FeatureDef', {'foreign.id'=>'self.para_fid'}); #belongs_to=>join
__PACKAGE__->has_many('HPMDRefs', 'Nectar::Schema::NECTAR::Result::Hpmdref', {'foreign.fid'=>'self.para_fid', 'foreign.xref'=>'self.para_xref'}); # has_many=> left join

# You can replace this text with custom code or comments, and it will be preserved on regeneration
__PACKAGE__->meta->make_immutable;
1;
