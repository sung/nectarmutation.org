use utf8;
package Nectar::Schema::UNIPROT::Result::Disease;

# Created by DBIx::Class::Schema::Loader
# DO NOT MODIFY THE FIRST PART OF THIS FILE

=head1 NAME

Nectar::Schema::UNIPROT::Result::Disease

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

=head1 TABLE: C<disease>

=cut

__PACKAGE__->table("disease");

=head1 ACCESSORS

=head2 id

  data_type: 'integer'
  extra: {unsigned => 1}
  is_auto_increment: 1
  is_nullable: 0

=head2 acc

  data_type: 'char'
  is_nullable: 0
  size: 12

=head2 gene

  data_type: 'char'
  is_nullable: 1
  size: 20

=head2 disease

  data_type: 'tinytext'
  is_nullable: 1

=head2 disease_abr

  data_type: 'varchar'
  is_nullable: 1
  size: 300

=head2 is_definite

  data_type: 'enum'
  extra: {list => [0,1]}
  is_nullable: 1

=head2 mims

  data_type: 'varchar'
  is_nullable: 1
  size: 255

=head2 evidence_ref

  data_type: 'integer'
  extra: {unsigned => 1}
  is_nullable: 1

=head2 des

  data_type: 'longtext'
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
  "acc",
  { data_type => "char", is_nullable => 0, size => 12 },
  "gene",
  { data_type => "char", is_nullable => 1, size => 20 },
  "disease_id",
  { data_type => "varchar", is_nullable => 1, size=> 20 },
  "disease_name",
  { data_type => "tinytext", is_nullable => 1 },
  "disease_abr",
  { data_type => "varchar", is_nullable => 1, size => 300 },
  "des",
  { data_type => "longtext", is_nullable => 1 },
  "type",
  { data_type => "varchar", is_nullable => 1, size=> 20 },
  "mim",
  { data_type => "varchar", is_nullable => 1, size => 255 },
  "evidence_ref",
  { data_type => "integer", extra => { unsigned => 1 }, is_nullable => 1 },
);

=head1 PRIMARY KEY

=over 4

=item * L</id>

=back

=cut

__PACKAGE__->set_primary_key("id");


# Created by DBIx::Class::Schema::Loader v0.07014 @ 2012-07-20 16:20:11
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:2DYyElXMbGZk+3u+d0mBbA

__PACKAGE__->might_have('UniProtSeq', 'Nectar::Schema::UNIPROT::Result::UniProtSeq', {'foreign.acc'=>'self.acc'});
__PACKAGE__->has_many('diseaseEvi', 'Nectar::Schema::UNIPROT::Result::DiseaseEvi', {'foreign.id'=>'self.evidence_ref'}); #has_many =>left join
#__PACKAGE__->might_have('Evidences', 'Nectar::Schema::UNIPROT::Result::Evidence', {'foreign.acc'=>'self.acc'});

# You can replace this text with custom code or comments, and it will be preserved on regeneration
__PACKAGE__->meta->make_immutable;
1;
