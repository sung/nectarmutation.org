use utf8;
package Nectar::Schema::CARDIODB::Result::V2Ensembl;

# Created by DBIx::Class::Schema::Loader
# DO NOT MODIFY THE FIRST PART OF THIS FILE

=head1 NAME

Nectar::Schema::CARDIODB::Result::V2Ensembl

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

=head1 TABLE: C<V2Ensembls>

=cut

__PACKAGE__->table("V2Ensembls");

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

=head2 strand

  data_type: 'integer'
  is_nullable: 1

=head2 ensg

  data_type: 'varchar'
  is_nullable: 1
  size: 50

=head2 hgnc

  data_type: 'varchar'
  is_nullable: 1
  size: 50

=head2 ensg_type

  data_type: 'varchar'
  is_nullable: 1
  size: 50

=head2 enst

  data_type: 'varchar'
  is_nullable: 1
  size: 50

=head2 is_canonical

  data_type: 'integer'
  is_nullable: 1

=head2 enst_type

  data_type: 'varchar'
  is_nullable: 1
  size: 50

=head2 t_start

  data_type: 'integer'
  default_value: 0
  is_nullable: 0

=head2 t_end

  data_type: 'integer'
  default_value: 0
  is_nullable: 0

=head2 cds_start

  data_type: 'integer'
  default_value: 0
  is_nullable: 0

=head2 cds_end

  data_type: 'integer'
  default_value: 0
  is_nullable: 0

=head2 codon

  data_type: 'varchar'
  is_nullable: 1
  size: 1000

=head2 tr_allele

  data_type: 'varchar'
  is_nullable: 1
  size: 1000

=head2 hgvs_coding

  data_type: 'varchar'
  is_nullable: 1
  size: 1000

=head2 ccds

  data_type: 'varchar'
  is_nullable: 1
  size: 255

=head2 so_terms

  data_type: 'varchar'
  default_value: 'intergenic_variant'
  is_nullable: 0
  size: 255

=head2 rs_ids

  data_type: 'varchar'
  is_nullable: 1
  size: 255

=head2 hgmds

  data_type: 'tinytext'
  is_nullable: 1

=head2 cosmics

  data_type: 'tinytext'
  is_nullable: 1

=head2 ensp

  data_type: 'varchar'
  is_nullable: 1
  size: 50

=head2 p_start

  data_type: 'integer'
  is_nullable: 1

=head2 p_end

  data_type: 'integer'
  is_nullable: 1

=head2 p_ref

  data_type: 'varchar'
  is_nullable: 1
  size: 1000

=head2 p_mut

  data_type: 'varchar'
  is_nullable: 1
  size: 1000

=head2 hgvs_protein

  data_type: 'varchar'
  is_nullable: 1
  size: 1000

=head2 sift

  data_type: 'enum'
  extra: {list => ["tolerated","deleterious"]}
  is_nullable: 1

=head2 sift_score

  data_type: 'float'
  is_nullable: 1

=head2 pph_var

  data_type: 'enum'
  extra: {list => ["unknown","benign","possibly damaging","probably damaging"]}
  is_nullable: 1

=head2 pph_var_score

  data_type: 'float'
  is_nullable: 1

=head2 pph_div

  data_type: 'enum'
  extra: {list => ["unknown","benign","possibly damaging","probably damaging"]}
  is_nullable: 1

=head2 pph_div_score

  data_type: 'float'
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
  "strand",
  { data_type => "integer", is_nullable => 1 },
  "ensg",
  { data_type => "varchar", is_nullable => 1, size => 50 },
  "hgnc",
  { data_type => "varchar", is_nullable => 1, size => 50 },
  "ensg_type",
  { data_type => "varchar", is_nullable => 1, size => 50 },
  "enst",
  { data_type => "varchar", is_nullable => 1, size => 50 },
  "is_canonical",
  { data_type => "integer", is_nullable => 1 },
  "enst_type",
  { data_type => "varchar", is_nullable => 1, size => 50 },
  "t_start",
  { data_type => "integer", default_value => 0, is_nullable => 0 },
  "t_end",
  { data_type => "integer", default_value => 0, is_nullable => 0 },
  "cds_start",
  { data_type => "integer", default_value => 0, is_nullable => 0 },
  "cds_end",
  { data_type => "integer", default_value => 0, is_nullable => 0 },
  "codon",
  { data_type => "varchar", is_nullable => 1, size => 1000 },
  "tr_allele",
  { data_type => "varchar", is_nullable => 1, size => 1000 },
  "hgvs_coding",
  { data_type => "varchar", is_nullable => 1, size => 1000 },
  "ccds",
  { data_type => "varchar", is_nullable => 1, size => 255 },
  "so_terms",
  {
    data_type => "varchar",
    default_value => "intergenic_variant",
    is_nullable => 0,
    size => 255,
  },
  "rs_ids",
  { data_type => "varchar", is_nullable => 1, size => 255 },
  "hgmds",
  { data_type => "tinytext", is_nullable => 1 },
  "cosmics",
  { data_type => "tinytext", is_nullable => 1 },
  "ensp",
  { data_type => "varchar", is_nullable => 1, size => 50 },
  "p_start",
  { data_type => "integer", is_nullable => 1 },
  "p_end",
  { data_type => "integer", is_nullable => 1 },
  "p_ref",
  { data_type => "varchar", is_nullable => 1, size => 1000 },
  "p_mut",
  { data_type => "varchar", is_nullable => 1, size => 1000 },
  "hgvs_protein",
  { data_type => "varchar", is_nullable => 1, size => 1000 },
  "sift",
  {
    data_type => "enum",
    extra => { list => ["tolerated", "deleterious"] },
    is_nullable => 1,
  },
  "sift_score",
  { data_type => "float", is_nullable => 1 },
  "pph_var",
  {
    data_type => "enum",
    extra => {
      list => ["unknown", "benign", "possibly damaging", "probably damaging"],
    },
    is_nullable => 1,
  },
  "pph_var_score",
  { data_type => "float", is_nullable => 1 },
  "pph_div",
  {
    data_type => "enum",
    extra => {
      list => ["unknown", "benign", "possibly damaging", "probably damaging"],
    },
    is_nullable => 1,
  },
  "pph_div_score",
  { data_type => "float", is_nullable => 1 },
);

=head1 PRIMARY KEY

=over 4

=item * L</id>

=back

=cut

__PACKAGE__->set_primary_key("id");

=head1 UNIQUE CONSTRAINTS

=head2 C<uid_2>

=over 4

=item * L</uid>

=item * L</enst>

=item * L</t_start>

=item * L</t_end>

=back

=cut

__PACKAGE__->add_unique_constraint("uid_2", ["uid", "enst", "t_start", "t_end"]);


# Created by DBIx::Class::Schema::Loader v0.07014 @ 2013-01-16 11:26:42
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:7a9QOM4bfTyw95vfaQ1SBg

__PACKAGE__->has_many('ClassifiedCalls', 'Nectar::Schema::CARDIODB::Result::ClassifiedCall', {'foreign.vid'=>'self.id'});
__PACKAGE__->might_have('2UniProts', 'Nectar::Schema::CARDIODB::Result::2UniProt', {'foreign.vid'=>'self.id'}); #might_have => left join
__PACKAGE__->might_have('2PDBs', 'Nectar::Schema::CARDIODB::Result::2Pdb', {'foreign.vid'=>'self.id'});  #might_have => left join
__PACKAGE__->has_many('V2Families', 'Nectar::Schema::CARDIODB::Result::V2Family', {'foreign.vid'=>'self.id'});

# You can replace this text with custom code or comments, and it will be preserved on regeneration
__PACKAGE__->meta->make_immutable;
1;
