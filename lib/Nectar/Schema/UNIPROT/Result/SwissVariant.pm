use utf8;
package Nectar::Schema::UNIPROT::Result::SwissVariant;

# Created by DBIx::Class::Schema::Loader
# DO NOT MODIFY THE FIRST PART OF THIS FILE

=head1 NAME

Nectar::Schema::UNIPROT::Result::SwissVariant

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

=head1 TABLE: C<SwissVariants>

=cut

__PACKAGE__->table("SwissVariants");

=head1 ACCESSORS

=head2 id

  data_type: 'integer'
  is_auto_increment: 1
  is_nullable: 0

=head2 variant_id

  data_type: 'char'
  default_value: (empty string)
  is_nullable: 0
  size: 10

=head2 gene

  data_type: 'varchar'
  is_nullable: 1
  size: 20

=head2 sp_acc

  data_type: 'char'
  is_nullable: 1
  size: 6

=head2 res_num

  data_type: 'integer'
  is_nullable: 1

=head2 aa_original

  data_type: 'char'
  is_nullable: 1
  size: 1

=head2 aa_variation

  data_type: 'char'
  is_nullable: 1
  size: 1

=head2 type

  data_type: 'enum'
  extra: {list => ["Disease","Polymorphism","Unclassified"]}
  is_nullable: 0

=head2 rs_id

  data_type: 'char'
  is_nullable: 1
  size: 15

=head2 disease_name

  data_type: 'varchar'
  is_nullable: 1
  size: 255

=head2 mim

  data_type: 'integer'
  is_nullable: 1

=cut

__PACKAGE__->add_columns(
  "id",
  { data_type => "integer", is_auto_increment => 1, is_nullable => 0 },
  "variant_id",
  { data_type => "char", default_value => "", is_nullable => 0, size => 10 },
  "gene",
  { data_type => "varchar", is_nullable => 1, size => 20 },
  "sp_acc",
  { data_type => "char", is_nullable => 1, size => 6 },
  "res_num",
  { data_type => "integer", is_nullable => 1 },
  "aa_original",
  { data_type => "char", is_nullable => 1, size => 1 },
  "aa_variation",
  { data_type => "char", is_nullable => 1, size => 1 },
  "type",
  {
    data_type => "enum",
    extra => { list => ["Disease", "Polymorphism", "Unclassified"] },
    is_nullable => 0,
  },
  "rs_id",
  { data_type => "char", is_nullable => 1, size => 15 },
  "disease_name",
  { data_type => "varchar", is_nullable => 1, size => 255 },
  "mim",
  { data_type => "integer", is_nullable => 1 },
);

=head1 PRIMARY KEY

=over 4

=item * L</id>

=back

=cut

__PACKAGE__->set_primary_key("id");


# Created by DBIx::Class::Schema::Loader v0.07014 @ 2012-07-20 16:20:11
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:qLLRlzJhE9+UletIKK3NdA

# does not work with my current config (two model / two schema - they cannot talk)
#__PACKAGE__->has_many('CARDIODB_DEVEL.2UniProts', 'Nectar::Schema::CARDIODB::Result::2UniProt', {'foreign.uniprot'=>'self.sp_acc', 'foreign.res_num'=>'self.res_num'}); # has_many => left join

# You can replace this text with custom code or comments, and it will be preserved on regeneration
__PACKAGE__->meta->make_immutable;
1;
