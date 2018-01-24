use utf8;
package Nectar::Schema::UNIPROT::Result::SwissVariant2IsNovel;

# Created by DBIx::Class::Schema::Loader
# DO NOT MODIFY THE FIRST PART OF THIS FILE


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

__PACKAGE__->table_class('DBIx::Class::ResultSource::View');

=head1 TABLE: C<SwissVariants>

=cut

__PACKAGE__->table("SwissVariant2IsNovels");

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
  "uid",
  { data_type => "integer", extra => { unsigned => 1 }, is_nullable => 0 },
);

=head1 PRIMARY KEY

=over 4

=item * L</id>

=back

=cut

#__PACKAGE__->set_primary_key("id");
# do not attempt to deploy() this view
__PACKAGE__->result_source_instance->is_virtual(1);
__PACKAGE__->result_source_instance->view_definition(q[
	SELECT DISTINCT sv.id, sv.variant_id, sv.gene, sv.sp_acc, sv.res_num, sv.aa_original, sv.aa_variation, sv.type, sv.rs_id, sv.disease_name, sv.mim, n.uid
	FROM UNIPROT.SwissVariants sv
	LEFT JOIN CARDIODB_DEVEL.IsNovels n ON sv.variant_id=n.humsavar
	WHERE sv.gene=?
	ORDER by sv.res_num
]);


# Created by DBIx::Class::Schema::Loader v0.07014 @ 2012-07-20 16:20:11
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:qLLRlzJhE9+UletIKK3NdA

# You can replace this text with custom code or comments, and it will be preserved on regeneration
__PACKAGE__->meta->make_immutable;
1;
