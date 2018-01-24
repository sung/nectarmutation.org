use utf8;
package Nectar::Schema::COSMIC::Result::CosmicMutant;

# Created by DBIx::Class::Schema::Loader
# DO NOT MODIFY THE FIRST PART OF THIS FILE

=head1 NAME

Nectar::Schema::COSMIC::Result::CosmicMutant

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

=head1 TABLE: C<CosmicMutant>

=cut

__PACKAGE__->table("CosmicMutant");

=head1 ACCESSORS

=head2 id

  data_type: 'integer'
  is_auto_increment: 1
  is_nullable: 0

=head2 gene

  data_type: 'varchar'
  is_nullable: 1
  size: 50

=head2 acc

  data_type: 'varchar'
  is_nullable: 1
  size: 50

=head2 hgnc_id

  data_type: 'mediumint'
  is_nullable: 1

=head2 sample_name

  data_type: 'varchar'
  is_nullable: 1
  size: 200

=head2 primary_site

  data_type: 'varchar'
  is_nullable: 1
  size: 200

=head2 site_subtype

  data_type: 'varchar'
  is_nullable: 1
  size: 200

=head2 primary_histology

  data_type: 'varchar'
  is_nullable: 1
  size: 200

=head2 histology_subtype

  data_type: 'varchar'
  is_nullable: 1
  size: 200

=head2 mutation_id

  data_type: 'mediumint'
  extra: {unsigned => 1}
  is_nullable: 1

=head2 mutation_cds

  data_type: 'varchar'
  is_nullable: 1
  size: 200

=head2 dna_start

  data_type: 'integer'
  is_nullable: 1

=head2 dna_end

  data_type: 'integer'
  is_nullable: 1

=head2 dna_wt

  data_type: 'varchar'
  is_nullable: 1
  size: 100

=head2 dna_mut

  data_type: 'tinytext'
  is_nullable: 1

=head2 mutation_aa

  data_type: 'varchar'
  is_nullable: 1
  size: 200

=head2 aa_start

  data_type: 'integer'
  is_nullable: 1

=head2 aa_end

  data_type: 'integer'
  is_nullable: 1

=head2 aa_wt

  data_type: 'varchar'
  is_nullable: 1
  size: 100

=head2 aa_mut

  data_type: 'varchar'
  is_nullable: 1
  size: 100

=head2 mut_type

  data_type: 'varchar'
  is_nullable: 1
  size: 255

=head2 zygosity

  data_type: 'set'
  extra: {list => ["hom","het","unk"]}
  is_nullable: 1

=head2 chr

  data_type: 'varchar'
  is_nullable: 1
  size: 10

=head2 chr_start

  data_type: 'integer'
  is_nullable: 1

=head2 chr_end

  data_type: 'integer'
  is_nullable: 1

=head2 strand

  data_type: 'set'
  extra: {list => ["+","-"]}
  is_nullable: 1

=head2 pubmed

  data_type: 'integer'
  extra: {unsigned => 1}
  is_nullable: 1

=cut

__PACKAGE__->add_columns(
  "id",
  { data_type => "integer", is_auto_increment => 1, is_nullable => 0 },
  "gene",
  { data_type => "varchar", is_nullable => 1, size => 50 },
  "acc",
  { data_type => "varchar", is_nullable => 1, size => 50 },
  "hgnc_id",
  { data_type => "mediumint", is_nullable => 1 },
  "sample_name",
  { data_type => "varchar", is_nullable => 1, size => 200 },
  "primary_site",
  { data_type => "varchar", is_nullable => 1, size => 200 },
  "site_subtype",
  { data_type => "varchar", is_nullable => 1, size => 200 },
  "primary_histology",
  { data_type => "varchar", is_nullable => 1, size => 200 },
  "histology_subtype",
  { data_type => "varchar", is_nullable => 1, size => 200 },
  "mutation_id",
  { data_type => "mediumint", extra => { unsigned => 1 }, is_nullable => 1 },
  "mutation_cds",
  { data_type => "varchar", is_nullable => 1, size => 200 },
  "dna_start",
  { data_type => "integer", is_nullable => 1 },
  "dna_end",
  { data_type => "integer", is_nullable => 1 },
  "dna_wt",
  { data_type => "varchar", is_nullable => 1, size => 100 },
  "dna_mut",
  { data_type => "tinytext", is_nullable => 1 },
  "mutation_aa",
  { data_type => "varchar", is_nullable => 1, size => 200 },
  "aa_start",
  { data_type => "integer", is_nullable => 1 },
  "aa_end",
  { data_type => "integer", is_nullable => 1 },
  "aa_wt",
  { data_type => "varchar", is_nullable => 1, size => 100 },
  "aa_mut",
  { data_type => "varchar", is_nullable => 1, size => 100 },
  "mut_type",
  { data_type => "varchar", is_nullable => 1, size => 255 },
  "zygosity",
  {
    data_type => "set",
    extra => { list => ["hom", "het", "unk"] },
    is_nullable => 1,
  },
  "chr",
  { data_type => "varchar", is_nullable => 1, size => 10 },
  "chr_start",
  { data_type => "integer", is_nullable => 1 },
  "chr_end",
  { data_type => "integer", is_nullable => 1 },
  "strand",
  { data_type => "set", extra => { list => ["+", "-"] }, is_nullable => 1 },
  "pubmed",
  { data_type => "integer", extra => { unsigned => 1 }, is_nullable => 1 },
);

=head1 PRIMARY KEY

=over 4

=item * L</id>

=back

=cut

__PACKAGE__->set_primary_key("id");


# Created by DBIx::Class::Schema::Loader v0.07014 @ 2013-02-20 17:01:28
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:e7cBhixm+BMurcNeunsy0Q


# You can replace this text with custom code or comments, and it will be preserved on regeneration
__PACKAGE__->meta->make_immutable;
1;
