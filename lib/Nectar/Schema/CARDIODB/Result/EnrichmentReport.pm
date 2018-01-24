use utf8;
package Nectar::Schema::CARDIODB::Result::EnrichmentReport;

# Created by DBIx::Class::Schema::Loader
# DO NOT MODIFY THE FIRST PART OF THIS FILE

=head1 NAME

Nectar::Schema::CARDIODB::Result::EnrichmentReport

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

=head1 TABLE: C<EnrichmentReports>

=cut

__PACKAGE__->table("EnrichmentReports");

=head1 ACCESSORS

=head2 id

  data_type: 'integer'
  is_auto_increment: 1
  is_nullable: 0

=head2 sample_id

  data_type: 'integer'
  is_nullable: 0

=head2 bamfile

  data_type: 'tinytext'
  is_nullable: 0

=head2 reportfile

  data_type: 'tinytext'
  is_nullable: 0

=head2 bp_target

  data_type: 'integer'
  is_nullable: 0

=head2 reads_on

  data_type: 'integer'
  is_nullable: 0

=head2 reads_off

  data_type: 'integer'
  is_nullable: 0

=head2 pct_reads_on

  data_type: 'float'
  is_nullable: 0
  size: [6,4]

=head2 pct_reads_off

  data_type: 'float'
  is_nullable: 0
  size: [6,4]

=head2 ratio_on_off

  data_type: 'float'
  is_nullable: 0
  size: [7,5]

=head2 enrichment_fold

  data_type: 'float'
  is_nullable: 0
  size: [7,2]

=head2 bp_target_null_coverage

  data_type: 'integer'
  is_nullable: 0

=head2 pct_target_bp_not_covered

  data_type: 'float'
  is_nullable: 0
  size: [4,2]

=head2 target_covered_1x

  data_type: 'float'
  is_nullable: 0
  size: [4,2]

=head2 target_covered_5x

  data_type: 'float'
  is_nullable: 0
  size: [4,2]

=head2 target_covered_10x

  data_type: 'float'
  is_nullable: 0
  size: [4,2]

=head2 target_covered_20x

  data_type: 'float'
  is_nullable: 0
  size: [4,2]

=head2 max_depth_of_target_coverage

  data_type: 'float'
  is_nullable: 0
  size: [7,2]

=head2 avg_depth_of_target_coverage

  data_type: 'float'
  is_nullable: 0
  size: [7,2]

=cut

__PACKAGE__->add_columns(
  "id",
  { data_type => "integer", is_auto_increment => 1, is_nullable => 0 },
  "sample_id",
  { data_type => "integer", is_nullable => 0 },
  "bamfile",
  { data_type => "tinytext", is_nullable => 0 },
  "reportfile",
  { data_type => "tinytext", is_nullable => 0 },
  "bp_target",
  { data_type => "integer", is_nullable => 0 },
  "reads_on",
  { data_type => "integer", is_nullable => 0 },
  "reads_off",
  { data_type => "integer", is_nullable => 0 },
  "pct_reads_on",
  { data_type => "float", is_nullable => 0, size => [6, 4] },
  "pct_reads_off",
  { data_type => "float", is_nullable => 0, size => [6, 4] },
  "ratio_on_off",
  { data_type => "float", is_nullable => 0, size => [7, 5] },
  "enrichment_fold",
  { data_type => "float", is_nullable => 0, size => [7, 2] },
  "bp_target_null_coverage",
  { data_type => "integer", is_nullable => 0 },
  "pct_target_bp_not_covered",
  { data_type => "float", is_nullable => 0, size => [4, 2] },
  "target_covered_1x",
  { data_type => "float", is_nullable => 0, size => [4, 2] },
  "target_covered_5x",
  { data_type => "float", is_nullable => 0, size => [4, 2] },
  "target_covered_10x",
  { data_type => "float", is_nullable => 0, size => [4, 2] },
  "target_covered_20x",
  { data_type => "float", is_nullable => 0, size => [4, 2] },
  "max_depth_of_target_coverage",
  { data_type => "float", is_nullable => 0, size => [7, 2] },
  "avg_depth_of_target_coverage",
  { data_type => "float", is_nullable => 0, size => [7, 2] },
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

=back

=cut

__PACKAGE__->add_unique_constraint("sample_id", ["sample_id"]);


# Created by DBIx::Class::Schema::Loader v0.07014 @ 2013-01-16 11:26:41
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:gOz0NkVwLzbWZAmjufis7w


# You can replace this text with custom code or comments, and it will be preserved on regeneration
__PACKAGE__->meta->make_immutable;
1;
