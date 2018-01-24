use utf8;
package Nectar::Schema::CARDIODB::Result::DiBaye;

# Created by DBIx::Class::Schema::Loader
# DO NOT MODIFY THE FIRST PART OF THIS FILE

=head1 NAME

Nectar::Schema::CARDIODB::Result::DiBaye

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

=head1 TABLE: C<diBayes>

=cut

__PACKAGE__->table("diBayes");

=head1 ACCESSORS

=head2 id

  data_type: 'integer'
  is_auto_increment: 1
  is_nullable: 0

=head2 sample_id

  data_type: 'integer'
  is_nullable: 0

=head2 variant_type

  data_type: 'varchar'
  is_nullable: 0
  size: 50

=head2 chr

  data_type: 'varchar'
  is_nullable: 0
  size: 50

=head2 v_start

  data_type: 'integer'
  is_nullable: 0

=head2 v_end

  data_type: 'integer'
  is_nullable: 0

=head2 reference

  data_type: 'varchar'
  is_nullable: 0
  size: 255

=head2 genotype

  data_type: 'varchar'
  is_nullable: 0
  size: 255

=head2 score

  data_type: 'float'
  is_nullable: 0
  size: [8,6]

=head2 coverage

  data_type: 'integer'
  is_nullable: 0

=head2 ref_allele_counts

  data_type: 'integer'
  is_nullable: 0

=head2 ref_allele_starts

  data_type: 'integer'
  is_nullable: 0

=head2 ref_allele_meanqv

  data_type: 'integer'
  is_nullable: 0

=head2 novel_allele_counts

  data_type: 'integer'
  is_nullable: 0

=head2 novel_allele_starts

  data_type: 'integer'
  is_nullable: 0

=head2 novel_allele_meanqv

  data_type: 'integer'
  is_nullable: 0

=head2 maad2

  data_type: 'integer'
  is_nullable: 0

=head2 saad3

  data_type: 'integer'
  is_nullable: 0

=head2 het

  data_type: 'integer'
  is_nullable: 0

=cut

__PACKAGE__->add_columns(
  "id",
  { data_type => "integer", is_auto_increment => 1, is_nullable => 0 },
  "sample_id",
  { data_type => "integer", is_nullable => 0 },
  "variant_type",
  { data_type => "varchar", is_nullable => 0, size => 50 },
  "chr",
  { data_type => "varchar", is_nullable => 0, size => 50 },
  "v_start",
  { data_type => "integer", is_nullable => 0 },
  "v_end",
  { data_type => "integer", is_nullable => 0 },
  "reference",
  { data_type => "varchar", is_nullable => 0, size => 255 },
  "genotype",
  { data_type => "varchar", is_nullable => 0, size => 255 },
  "score",
  { data_type => "float", is_nullable => 0, size => [8, 6] },
  "coverage",
  { data_type => "integer", is_nullable => 0 },
  "ref_allele_counts",
  { data_type => "integer", is_nullable => 0 },
  "ref_allele_starts",
  { data_type => "integer", is_nullable => 0 },
  "ref_allele_meanqv",
  { data_type => "integer", is_nullable => 0 },
  "novel_allele_counts",
  { data_type => "integer", is_nullable => 0 },
  "novel_allele_starts",
  { data_type => "integer", is_nullable => 0 },
  "novel_allele_meanqv",
  { data_type => "integer", is_nullable => 0 },
  "maad2",
  { data_type => "integer", is_nullable => 0 },
  "saad3",
  { data_type => "integer", is_nullable => 0 },
  "het",
  { data_type => "integer", is_nullable => 0 },
);

=head1 PRIMARY KEY

=over 4

=item * L</id>

=back

=cut

__PACKAGE__->set_primary_key("id");

=head1 UNIQUE CONSTRAINTS

=head2 C<sample_id>

=over 4

=item * L</sample_id>

=item * L</chr>

=item * L</v_start>

=item * L</v_end>

=item * L</reference>

=item * L</genotype>

=back

=cut

__PACKAGE__->add_unique_constraint(
  "sample_id",
  ["sample_id", "chr", "v_start", "v_end", "reference", "genotype"],
);


# Created by DBIx::Class::Schema::Loader v0.07014 @ 2013-01-16 11:26:42
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:0Egv/IFWABrABGgRyfZRwQ

__PACKAGE__->belongs_to('Samples', 'Nectar::Schema::CARDIODB::Result::Sample', {'foreign.id'=>'self.sample_id'});

# You can replace this text with custom code or comments, and it will be preserved on regeneration
__PACKAGE__->meta->make_immutable;
1;
