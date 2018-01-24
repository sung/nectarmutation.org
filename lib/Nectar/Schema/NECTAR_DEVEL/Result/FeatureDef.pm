use utf8;
package Nectar::Schema::NECTAR_DEVEL::Result::FeatureDef;

# Created by DBIx::Class::Schema::Loader
# DO NOT MODIFY THE FIRST PART OF THIS FILE

=head1 NAME

Nectar::Schema::NECTAR_DEVEL::Result::FeatureDef

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

=head1 TABLE: C<featureDef>

=cut

__PACKAGE__->table("featureDef");

=head1 ACCESSORS

=head2 id

  data_type: 'integer'
  is_auto_increment: 1
  is_nullable: 0

=head2 category

  data_type: 'enum'
  extra: {list => ["Molecule processing","Regions","Sites","Amino acid modifications","Natural variations","Experimental info","Secondary structure","TLB","ENSEMBL","CSA","PDB","COSMIC","Disease variants"]}
  is_nullable: 0

=head2 feature

  data_type: 'varchar'
  is_nullable: 0
  size: 50

=head2 des

  data_type: 'tinytext'
  is_nullable: 0

=head2 url

  data_type: 'varchar'
  is_nullable: 0
  size: 200

=head2 is_function

  data_type: 'integer'
  default_value: 0
  extra: {unsigned => 1}
  is_nullable: 0

=cut

__PACKAGE__->add_columns(
  "id",
  { data_type => "integer", is_auto_increment => 1, is_nullable => 0 },
  "category",
  {
    data_type => "enum",
    extra => {
      list => [
        "Molecule processing",
        "Regions",
        "Sites",
        "Amino acid modifications",
        "Natural variations",
        "Experimental info",
        "Secondary structure",
        "TLB",
        "ENSEMBL",
        "CSA",
        "PDB",
        "COSMIC",
        "Disease variants",
      ],
    },
    is_nullable => 0,
  },
  "feature",
  { data_type => "varchar", is_nullable => 0, size => 50 },
  "des",
  { data_type => "tinytext", is_nullable => 0 },
  "url",
  { data_type => "varchar", is_nullable => 0, size => 200 },
  "is_function",
  {
    data_type => "integer",
    default_value => 0,
    extra => { unsigned => 1 },
    is_nullable => 0,
  },
);

=head1 PRIMARY KEY

=over 4

=item * L</id>

=back

=cut

__PACKAGE__->set_primary_key("id");


# Created by DBIx::Class::Schema::Loader v0.07035 @ 2013-10-28 11:14:36
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:Ii4RQD1jaCldDVaN/bxuXA


# You can replace this text with custom code or comments, and it will be preserved on regeneration
__PACKAGE__->meta->make_immutable;
1;
